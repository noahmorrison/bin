#include <stdio.h>
#include <xcb/xcb.h>

int
main(void)
{
    xcb_connection_t *conn;
    xcb_screen_t *scr;
    xcb_generic_event_t *e;
    xcb_create_notify_event_t *cne;

    /* initialize */
    conn = xcb_connect(NULL, NULL);
    if (xcb_connection_has_error(conn))
        errx(1, "unable to connect to the X server");

    scr = xcb_setup_roots_iterator(xcb_get_setup(conn)).data;
    if (scr == NULL)
        errx(2, "unable to connect to a screen");


    /* register window creation event */
    uint32_t mask[] = { XCB_EVENT_MASK_SUBSTRUCTURE_NOTIFY };
    xcb_change_window_attributes(conn, scr->root, XCB_CW_EVENT_MASK, mask);
    xcb_flush(conn);

    for (;;) {
        e = xcb_wait_for_event(conn);

        switch (e->response_type & ~0x80)
        {
            case XCB_CREATE_NOTIFY:
                cne = (xcb_create_notify_event_t*)e;
                printf("0x%08x\n", cne->window);
                fflush(stdout);
        }
    }

    xcb_disconnect(conn);
}
