#pragma once
#include "include/cef_app.h"

class BrowserApp : public CefApp {
public:
    BrowserApp() = default;

private:
    IMPLEMENT_REFCOUNTING(BrowserApp);
};
