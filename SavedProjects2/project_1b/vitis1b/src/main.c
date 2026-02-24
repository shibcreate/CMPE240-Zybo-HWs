#define BASE_ADDR 0x43C00000

#define SW_ADDR   (BASE_ADDR + 0x00)
#define BTN_ADDR  (BASE_ADDR + 0x04)
#define LED_ADDR  (BASE_ADDR + 0x08)

int main()
{
    while(1)
    {
        unsigned int sw  = *(volatile unsigned int*)SW_ADDR;
        unsigned int btn = *(volatile unsigned int*)BTN_ADDR;

        unsigned int result = sw & btn;

        *(volatile unsigned int*)LED_ADDR = result;
    }
}
