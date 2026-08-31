#define PIN_RSTN 		0
#define PIN_TEST_MODE 	1
#define PIN_LED1 		2
#define PIN_LED2 		3


u32 init_gpio_ps();
//void set_led1(u8 val);
//void set_led2(u8 val);
void set_gpio_pin(u32 pin, u32 val);
