#pragma once
#include "include/cef_client.h"

class BrowserClient : public CefClient,
                      public CefLifeSpanHandler {
public:
    BrowserClient() = default;

    CefRefPtr<CefLifeSpanHandler> GetLifeSpanHandler() override {
        return this;
    }

    void OnAfterCreated(CefRefPtr<CefBrowser> browser) override {
        browser_ = browser;
    }

private:
    CefRefPtr<CefBrowser> browser_;

    IMPLEMENT_REFCOUNTING(BrowserClient);
};
