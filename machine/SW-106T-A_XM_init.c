#include "machine_init_defs.h"
#include "rtl837x_regs.h"
#include "rtl837x_common.h"

/* V0.2.5: all LEDs off when no link; per-port activity on the correct LED. */
void machine_custom_init(void) __banked
{
	REG_SET(RTL837X_REG_LED_GLB_IO_EN, 0xffffffff);
	REG_SET(RTL837X_REG_LED_GLB_ACTIVE, 0x3fffffff);
}
