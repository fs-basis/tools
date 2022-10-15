#ifdef HAVE_CONFIG_H
#include <config.h>
#endif


#if HAVE_DUCKBOX_HARDWARE
#define RC_DEVICE "/dev/input/event0"
#define RC_DEVICE_FALLBACK "/dev/input/event1"

#elif BOXMODEL_H7
#define RC_DEVICE "/dev/input/event2"
#define RC_DEVICE_FALLBACK "/dev/input/event1"

#else
#define RC_DEVICE "/dev/input/event1"
#define RC_DEVICE_FALLBACK "/dev/input/event0"

#endif
