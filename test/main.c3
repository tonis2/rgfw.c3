import std::io;
import std::collections::list;
import std::math;
import rgfw;


fn void! main(String[] args)
{
    rgfw::Window* win = rgfw::createWindow("Vulkan Example", rgfw::Rect{0, 0, 500, 500}, rgfw::CENTER);
    defer rgfw::close(win);

    bool running = true;

    while (running && !rgfw::isPressed(win, rgfw::QUIT)) {
        rgfw::Event* events = rgfw::checkEvent(win);
        if(events != null) io::printfn("%d", events.type);
        // if (events != null && events.type == rgfw::QUIT) running = false;
    }
    
}