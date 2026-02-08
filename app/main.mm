#import <Cocoa/Cocoa.h>

#include "include/cef_app.h"
#include "include/cef_command_line.h"
#include "include/wrapper/cef_library_loader.h"
#include "include/cef_browser.h"

#include "browser_app.h"
#include "browser_client.h"

int main(int argc, char* argv[]) {
    @autoreleasepool {

        // Load CEF framework
        CefScopedLibraryLoader library_loader;
        if (!library_loader.LoadInMain()) {
            return 1;
        }

        // Start Cocoa app
        [NSApplication sharedApplication];
        [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];

        CefMainArgs main_args(argc, argv);
        CefRefPtr<BrowserApp> app(new BrowserApp);

        int exit_code = CefExecuteProcess(main_args, app, nullptr);
        if (exit_code >= 0) {
            return exit_code;
        }

        CefSettings settings;
        settings.no_sandbox = true;

        // 🔑 REQUIRED on macOS
        settings.multi_threaded_message_loop = true;

        CefInitialize(main_args, settings, app, nullptr);

        // Create window
        NSRect frame = NSMakeRect(0, 0, 1024, 768);
        NSWindow* window = [[NSWindow alloc]
            initWithContentRect:frame
                      styleMask:(NSWindowStyleMaskTitled |
                                 NSWindowStyleMaskClosable |
                                 NSWindowStyleMaskResizable)
                        backing:NSBackingStoreBuffered
                          defer:NO];

        [window setTitle:@"Bochi Browser"];
        [window center];
        [window makeKeyAndOrderFront:nil];

        // Create CEF browser
        CefWindowInfo window_info;
        window_info.SetAsChild(
            (__bridge void*)[window contentView],
            CefRect(0, 0, 1024, 768)
        );

        CefBrowserSettings browser_settings;
        CefRefPtr<BrowserClient> client(new BrowserClient);

        CefBrowserHost::CreateBrowser(
            window_info,
            client,
            "https://example.com",
            browser_settings,
            nullptr,
            nullptr
        );

        // Bring app to front
        [NSApp activateIgnoringOtherApps:YES];

        // 🔑 Cocoa owns the main loop
        [NSApp run];

        CefShutdown();
    }
    return 0;
}
