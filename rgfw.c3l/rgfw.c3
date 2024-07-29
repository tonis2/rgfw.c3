module rgfw;
import std::math;

const TRANSPARENT_WINDOW = (1L<<9);
const NO_BORDER = (1L<<3);
const NO_RESIZE = (1L<<4);
const ALLOW_DND = (1L<<5);
const HIDE_MOUSE = (1L<<6);
const FULLSCREEN = (1L<<8);

const CENTER = (1L<<10);
const OPENGL_SOFTWARE = (1L<<11);
const COCOA_MOVE_TO_RESOURCE_DIR = (1L<<12);

const SCALE_TO_MONITOR = (1L<<13);
const NO_INIT_API = (1L<<2);
const NO_GPU_RENDER = (1L<<14);
const NO_CPU_RENDER = (1L<<15);

const KEY_PRESSED = 2;
const KEY_RELEASED = 3;

const MOUSE_PRESSED = 4;
const MOUSE_RELEASED = 5;
const MOUSE_POS_CHANGED = 6;

const QUIT = 33;
const DND = 34;
const DND_INIT = 35;

const LEFT_MOUSE = 1;
const RIGHT_MOUSE = 2;
const MIDDLE_MOUSE = 3;
const MOUSE_SCROLL_UP = 4;
const MOUSE_SCROLL_DOWN = 5;

def UInt8 =  char;
def UInt16 =  ushort;
def UInt32 =  uint;
def UInt64 =  ulong;

def Int8 =  ichar;
def Int16 =  short;
def Int32 =  int;
def Int64 =  long;

struct Rect {
    Int32 x,y,w,h;
}

struct Vec2 {
    Int32 x,y;
}

struct Area {
    Int32 w,h;
}

const MAX_DROPS = 260;

struct Event {
    UInt8[16] keyName;
	UInt8* droppedFiles;
	UInt32 droppedFilesCount; 
	UInt32 type;
	Vec2 point;
	UInt32 fps;
	UInt64 frameTime, frameTime2;
	UInt8 keyCode;
	UInt8 inFocus;
	UInt8 lockState;
	UInt16 joystick; 
	UInt8 button;
	double scroll;
	UInt8 axisesCount;
	Vec2[2] axis;
}

struct DarwinWindow {
	UInt32 display;
    void* displayLink;
    void* window;
    UInt8 dndPassed;
    void* ctx; 
    void* view; 

    void* bitmap;
    void* image;
}

struct LinuxWindow {
  	void* display;
    void* window;
    void* ctx;
    void* bitmap;
    void* gc;
}

struct Window {
    DarwinWindow src @if(env::os_is_darwin());
	LinuxWindow src @if(env::LINUX);
	UInt8* buffer;
    Event event;
    Rect rect;
    UInt32 fps_cap;
    UInt32 args;
}

extern fn Window* createWindow(UInt8* name, Rect rect, UInt16 args) @extern("RGFW_createWindow");
extern fn Event* checkEvent(Window* win) @extern("RGFW_window_checkEvent");
extern fn void close(Window* win) @extern("RGFW_window_close");
extern fn bool isPressed(Window* win, UInt8 value) @extern("RGFW_isPressed");
