# microphones_array

64 microphones array project

/zynq_board_prj/create_design.tcl - скрипт создания ПЛИС-проекта в Vivado 2022.1

/src - исходники HDL + констрейнты плисовой части Zynq

/vitis/zynq_board/app_iperfclient/src - исходники процессорной части Zynq



Краткая инструкция (более детально по шагам можно гуглить/промптить ИИ):

1. Запускаем вивадо. В tcl консоли заходим в /zynq_board_prj (через cd).

2. Выполняем source ./create_design.tcl.

3. Имплементим проект, создаём bitstream.

4. Делаем export hw, получаем xsa.

5. Открываем Vitis 2022.1 и создаём новый проект-платформу на основе нашего xsa.

6. В BSP подключаем библиотеки lwip211, xilffs, xilrsa.

7. Создаем Application Project и импортируем туда файлы из /vitis/zynq_board/app_iperfclient/src.

8. Собраную прошивку запускаем по jtag, либо берём BOOT.bin из проекта и шъём по jtag конфикурационную
    SPI флэш.    




