#!/usr/bin/env python3
import asyncio
from dbus_next.aio.message_bus import MessageBus
from dbus_next.constants import BusType
from dbus_next.errors import DBusError

BLUEZ = "org.bluez"
OBJECT_MANAGER = "org.freedesktop.DBus.ObjectManager"

DEVICE_IFACE = "org.bluez.Device1"
SERVICE_IFACE = "org.bluez.GattService1"
CHAR_IFACE = "org.bluez.GattCharacteristic1"
DESC_IFACE = "org.bluez.GattDescriptor1"

BATTERY_SERVICE_UUID = "0000180f-0000-1000-8000-00805f9b34fb"
BATTERY_LEVEL_UUID = "00002a19-0000-1000-8000-00805f9b34fb"
USER_DESC_UUID = "00002901-0000-1000-8000-00805f9b34fb"


def unwrap(v):
    return getattr(v, "value", v)


async def read_value(bus, path, iface_name):
    introspection = await bus.introspect(BLUEZ, path)
    obj = bus.get_proxy_object(BLUEZ, path, introspection)
    iface = obj.get_interface(iface_name)
    return await getattr(iface, "call_read_value")({})


async def main():
    bus = await MessageBus(bus_type=BusType.SYSTEM).connect()

    root_xml = await bus.introspect(BLUEZ, "/")
    root = bus.get_proxy_object(BLUEZ, "/", root_xml)
    manager = root.get_interface(OBJECT_MANAGER)
    objects = await getattr(manager, "call_get_managed_objects")()

    devices = {}
    services = {}
    descriptors_by_char = {}

    for path, ifaces in objects.items():
        if DEVICE_IFACE in ifaces:
            props = ifaces[DEVICE_IFACE]
            devices[path] = {
                "name": unwrap(props.get("Alias", props.get("Name", "unknown"))),
                "connected": bool(unwrap(props.get("Connected", False))),
                "resolved": bool(unwrap(props.get("ServicesResolved", False))),
            }

        if SERVICE_IFACE in ifaces:
            props = ifaces[SERVICE_IFACE]
            if str(unwrap(props.get("UUID", ""))).lower() == BATTERY_SERVICE_UUID:
                services[path] = unwrap(props.get("Device"))

        if DESC_IFACE in ifaces:
            props = ifaces[DESC_IFACE]
            char_path = unwrap(props.get("Characteristic"))
            uuid = str(unwrap(props.get("UUID", ""))).lower()
            if uuid == USER_DESC_UUID:
                descriptors_by_char.setdefault(char_path, []).append(path)

    results = []

    for path, ifaces in objects.items():
        if CHAR_IFACE not in ifaces:
            continue

        props = ifaces[CHAR_IFACE]
        uuid = str(unwrap(props.get("UUID", ""))).lower()
        if uuid != BATTERY_LEVEL_UUID:
            continue

        service_path = unwrap(props.get("Service"))
        if service_path not in services:
            continue

        device_path = services[service_path]
        device = devices.get(device_path, {})
        if device and not device.get("connected", False):
            continue

        label = "main"
        for desc_path in descriptors_by_char.get(path, []):
            try:
                raw = await read_value(bus, desc_path, DESC_IFACE)
                label = bytes(raw).decode(errors="replace").strip() or label
            except DBusError:
                pass

        try:
            raw = await read_value(bus, path, CHAR_IFACE)
            level = int(bytes(raw)[0])
        except Exception as e:
            level = f"read failed: {e}"

        results.append((device.get("name", device_path), label, level))

    if not results:
        print("No ZMK battery characteristics found.")
        print("Check that the keyboard is connected and ServicesResolved is true:")
        print("  bluetoothctl info <keyboard-mac>")
        return

    for dev, label, level in results:
        print(f"{dev} / {label}: {level}%")


asyncio.run(main())
