import Cocoa
import FlutterMacOS
import IOKit
import IOKit.ps

public class HardwareDetailsPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "hardware_details", binaryMessenger: registrar.messenger)
    let instance = HardwareDetailsPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      let os = ProcessInfo.processInfo.operatingSystemVersion
      let versionString = "macOS \(os.majorVersion).\(os.minorVersion).\(os.patchVersion)"
      result(versionString)
    case "getCpuId":
      var size = 0
      sysctlbyname("machdep.cpu.brand_string", nil, &size, nil, 0)
      var cpuBrand = [CChar](repeating: 0, count: size)
      sysctlbyname("machdep.cpu.brand_string", &cpuBrand, &size, nil, 0)
      let cpuId = String(cString: cpuBrand)
      result(cpuId)
    case "getBiosSerial":
      let platformExpert = IOServiceGetMatchingService(
        mach_port_t(MACH_PORT_NULL), IOServiceMatching("IOPlatformExpertDevice"))
      if platformExpert != 0 {
        if let serialNumberAsCFString = IORegistryEntryCreateCFProperty(
          platformExpert,
          kIOPlatformSerialNumberKey as CFString,
          kCFAllocatorDefault, 0)?.takeUnretainedValue() as? String
        {
          result(serialNumberAsCFString)
        } else {
          result(
            FlutterError(code: "UNAVAILABLE", message: "Serial number not available", details: nil))
        }
        IOObjectRelease(platformExpert)
      } else {
        result(
          FlutterError(code: "UNAVAILABLE", message: "Platform expert not available", details: nil))
      }
    case "getMotherboardId":
      let platformExpert = IOServiceGetMatchingService(
        mach_port_t(MACH_PORT_NULL), IOServiceMatching("IOPlatformExpertDevice"))
      if platformExpert != 0 {
        if let uuidAsCFString = IORegistryEntryCreateCFProperty(
          platformExpert,
          "IOPlatformUUID" as CFString,
          kCFAllocatorDefault, 0)?.takeUnretainedValue() as? String
        {
          result(uuidAsCFString)
        } else {
          result(
            FlutterError(
              code: "UNAVAILABLE", message: "Motherboard UUID not available", details: nil))
        }
        IOObjectRelease(platformExpert)
      } else {
        result(
          FlutterError(code: "UNAVAILABLE", message: "Platform expert not available", details: nil))
      }
    default:
      result("default")
    }
  }
}
