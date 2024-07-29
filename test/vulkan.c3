import std::io;
import std::collections::list;
import std::math;
import rgfw;
import vk;

Instance instance;
DebugUtilsMessengerEXT debug_messenger;
PhysicalDevice physical_device;
QueueFamily queue_family;
Device device;
SurfaceKHR surface;

ZStringList validations;
ZStringList extensions;
ZStringList device_extensions;

fn void! main(String[] args)
{
    rgfw::Window* win = rgfw::createWindow("Vulkan Example", rgfw::Rect{0, 0, 500, 500}, rgfw::CENTER);
    defer rgfw::close(win);

    validations.add_array({"VK_LAYER_KHRONOS_validation"});
    device_extensions.add_array({"VK_KHR_swapchain", "VK_KHR_push_descriptor", "VK_KHR_dynamic_rendering"});
    extensions.add_array({"VK_KHR_surface"});

    if (env::OS_TYPE == MACOS) {
        extensions.add_array({"VK_MVK_macos_surface", "VK_KHR_portability_enumeration"});
        device_extensions.push("VK_KHR_portability_subset");
    }

    if (env::OS_TYPE == WIN32) {
        extensions.add_array({"VK_KHR_win32_surface"});
    }

    if (env::OS_TYPE == LINUX) {
        io::printfn("create linux surface");
        extensions.add_array({"VK_KHR_xlib_surface"});
    }

    vk::checkExtensionSupport(extensions)!;

    InstanceCreateInfo instanceInfo = vk::instanceCreateInfoBuilder()
    .setApplicationInfo(&&ApplicationInfo{
      .pApplicationName = "TEST",
      .pEngineName = "Super engine",
      .applicationVersion = vk::@makeApiVersion(0,1,0,0),
      .engineVersion = vk::@makeApiVersion(0,1,0,0),
      .apiVersion = vk::@makeApiVersion(0,1,3,0)
    })
    .setFlags(env::os_is_darwin() ? vk::INSTANCE_CREATE_ENUMERATE_PORTABILITY_BIT_KHR : 0)
    .setEnabledExtensionNames(extensions.array_view());

    vk::createInstance(&instanceInfo, null, &instance)!;
    vk::loadExtensions(instance);

    $switch(env::OS_TYPE) 
        $case LINUX: {
            XlibSurfaceCreateInfoKHR createInfo = {
                vk::STRUCTURE_TYPE_XLIB_SURFACE_CREATE_INFO_KHR, 
                null, 
                0, 
                win.src.display, 
                0
            };
            vk::createXlibSurfaceKHR(instance, &createInfo, null, &surface)!;
        }
        // $case MACOS: {
        //     MacOSSurfaceCreateInfoMVK createInfo = { 
        //         vk::STRUCTURE_TYPE_MACOS_SURFACE_CREATE_INFO_MVK, 
        //         null, 
        //         0, 
        //         win.src.window
        //     };
        // }
        // $case WIN32: {
        //     Win32SurfaceCreateInfoKHR createInfo = {
        //         vk::STRUCTURE_TYPE_WIN32_SURFACE_CREATE_INFO_KHR,
        //         null,
        //         0,
        //         win.src.window,
        //         win.src.hdc
        //     };
        // }
        $default: {}
    $endswitch

    bool running = true;
    while (running) {
        rgfw::Event* events = rgfw::checkEvent(win);

        if (events != null) {
            if (events.keyCode == Key.ESCAPE) running = false;
        }
    }
}