module rgfw;
import std::math;
import std::os::win32;
import vk;

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

def Byte =  char;
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
const MAX_PATH = 260;

enum EventType : UInt32 (UInt32 value)
{
    KEY_PRESSED = 1,
    KEY_RELEASED = 2,
    MOUSE_PRESSED = 3,
    MOUSE_RELEASED = 4,
    MOUSE_POS_CHANGED = 6,
    WINDOW_REFRESH = 16,

    QUIT = 32,
    DND = 33,
    DND_INIT = 34,
}

enum MouseEvent : UInt32 (UInt32 value)
{
    LEFT_MOUSE = 1,
    RIGHT_MOUSE = 2,
    MIDDLE_MOUSE = 3,
    MOUSE_SCROLL_UP = 4,
    MOUSE_SCROLL_DOWN = 5,
}


enum Key : Byte {
    KEY_NULL,
    ESCAPE,
    F1,
    F2,
    F3,
    F4,
    F5,
    F6,
    F7,
    F8,
    F9,
    F10,
    F11,
    F12,

    BACKTICK,

    KEY_0,
    KEY_1,
    KEY_2,
    KEY_3,
    KEY_4,
    KEY_5,
    KEY_6,
    KEY_7,
    KEY_8,
    KEY_9,

    MINUS,
    EQUAL,
    BACKSPACE,
    TAB,
    CAPSLOCK,
    SHIFT_R,
    CONTROL_L,
    ALT_L,
    SUPER_L,
    SHIFT_L,
    CONTROL_R,
    ALT_R,
    SUPER_R,
    SPACE,

    A,
    B,
    C,
    D,
    E,
    F,
    G,
    H,
    I,
    J,
    K,
    L,
    M,
    N,
    O,
    P,
    Q,
    R,
    S,
    T,
    U,
    V,
    W,
    X,
    Y,
    Z,

    // Period,
    // Comma,
    // Slash,
    // Bracket,
    // CloseBracket,
    // Semicolon,
    // Return,
    // Quote,
    // BackSlash,

    // Up,
    // Down,
    // Left,
    // Right,

    // Delete,
    // Insert,
    // End,
    // Home,
    // PageUp,
    // PageDown,

    // Numlock,
    // KP_Slash,
    // Multiply,
    // KP_Minus,
    // KP_1,
    // KP_2,
    // KP_3,
    // KP_4,
    // KP_5,
    // KP_6,
    // KP_7,
    // KP_8,
    // KP_9,
    // KP_0,
    // KP_Period,
    // KP_Return
}

struct Event {
    Byte[16] keyName;
	Byte[MAX_DROPS][MAX_PATH] droppedFiles;
	UInt32 droppedFilesCount; 
	EventType type;
	Vec2 point;
	UInt32 fps;
	UInt64 frameTime; 
    UInt64 frameTime2;
	Key keyCode;
	Byte inFocus;
	Byte lockState;
	UInt16 joystick; 
	Byte button;
	double scroll;
	Byte axisesCount;
	Vec2[2] axis;
}

struct DarwinWindow {
	UInt32 display;
    void* displayLink;
    void* window;
    Byte dndPassed;
    void* ctx; 
    void* view; 

    void* bitmap;
    void* image;
}

struct Win32Window {
    Win32_HWND window;
    Win32_HANDLE hdc;
    UInt32 hOffset;
    void* ctx;
    void* bitmap;
    Area maxSize; 
    Area minSize; 
}

struct LinuxWindow {
  	vk::XDisplay display;
    vk::XWindow window;
    void* ctx;
    void* bitmap;
    void* gc;
}

struct Window {
    DarwinWindow src @if(env::os_is_darwin());
	LinuxWindow src @if(env::LINUX);
    Win32Window src @if(env::WIN32);
	Byte* buffer;
    Event event;
    Rect rect;
    UInt32 fps_cap;
    UInt32 args;
}

extern fn Window* createWindow(Byte* name, Rect rect, UInt16 args) @extern("RGFW_createWindow");
extern fn Event* checkEvent(Window* win) @extern("RGFW_window_checkEvent");
extern fn void close(Window* win) @extern("RGFW_window_close");
extern fn bool isPressed(Window* win, EventType value) @extern("RGFW_isPressed");
