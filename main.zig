const std = @import("std");
const c = @cImport(@cInclude("gtk/gtk.h"));

pub fn main() !void {
    const app = c.gtk_application_new("org.gtk.example", c.G_APPLICATION_FLAGS_NONE) orelse @panic("null app :(");
    defer c.g_object_unref(app);

    _ = c.g_signal_connect_data(
        app,
        "activate",
        @ptrCast(c.GCallback, struct {
            fn f(a: *c.GtkApplication, data: c.gpointer) callconv(.C) void {
                _ = data;

                const window = c.gtk_application_window_new(a);
                c.gtk_window_set_title(@ptrCast(*c.GtkWindow, window), "testing program");
                c.gtk_window_set_default_size(@ptrCast(*c.GtkWindow, window), 400, 400);
                c.gtk_widget_show(window);
            }
        }.f),
        null,
        null,
        0,
    );

    _ = c.g_application_run(@ptrCast(*c.GApplication, app), 0, null);
}
