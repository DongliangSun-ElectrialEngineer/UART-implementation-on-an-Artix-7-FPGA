# UART-implementation-on-an-Artix-7-FPGA
## Introduction

UART, an acronym for Universal Asynchronous Receiver/Transmitter, delineates a protocol facilitating the exchange of serial data between two devices. This communication standard boasts simplicity, relying solely on a pair of wires for bidirectional transmission and reception. The transmitter of one device interfaces with the receiver of the other, complemented by a shared ground connection at both ends. 

In this project, a fundamental UART system is designed, simulated, and implemented on an Artix-7 FPGA. It operates in full duplex mode and supports a baud rate of 115200 bps. The data frame format includes 1 start bit, 8 data bits, and 1 stop bit, as shown in figure1.

![](images/toda_estimation.jpg)

## Methodology

The block diagram illustrating the UART configuration is depicted in Figure 2. At its core, the UART comprises two primary components: the receiver and the transmitter. The receiver is responsible for converting incoming serial data into 8-bit parallel data, whereas the transmitter performs the reverse operation, converting parallel data into serial format for transmission.

![](images/toda_estimation.jpg)

### Counter

Both the transmitter and the receiver require two counters: Counter 1 and Counter 2. Counter 1 tracks the number of clock cycles. In the context of a 100MHz clock frequency and a baud rate of 115200 bps, the number of clock cycles per bit can be calculated based on the equation below.

Number of clock cycles per bit =  Clock frequency/Baud rate = 868

As a result, Counter 1 counting from 0 to 867 matches one bit period while counting from 0 to 433 corresponds to half bit period.

Counter 2 records the number of data bits transmitted or received, ranging from 0 to 7. It can also be seen as the index for the 8-bit parallel data.

### Transmitter

The transmitter module depicted in Figure 3 encompasses four inputs and two outputs. The CLK signal operates at a frequency of 100MHz, providing the timing reference for the circuit. The reset signal is utilized to reset the circuit when necessary. When the TX_start signal is raised to a high state, it triggers the commencement of the transmission process. The Data_in signal represents the 8-bit parallel data intended for transmission. The TX signal serves as the serial data output. Upon the completion of the transmission process, the TX_done signal is momentarily raised to a high state for one clock cycle, indicating the conclusion of the transmission.

![](images/toda_estimation.jpg)

The transmitter functions within a finite state machine (FSM) comprising four distinct states: idle, start, data, and stop, as shown in Figure 4. These states correspond closely with different phases in the data frame format. During the idle state, the transmission line is maintained high, signaling continuous transmission of bit 1. Upon activation of the TX_start signal, the transmitter transitions to the start state, where it captures the 8-bit data input into a register. In the start state, the transmitter transmits the start bit (bit 0) for one bit period. Subsequently, the transmitter progresses to the data state. Here, it continuously transmits the data bits with the least significant bit first. Each bit persists for one bit period, regulated by Counter 1. The total number of bits sent, 8 in total, is managed by Counter2. Upon completion of the 8-bit data transmission, the transmitter transitions to the stop state. In this state, it emits the stop bit for one bit duration before reverting to the idle state, ready for the next transmission cycle.

![](images/toda_estimation.jpg)

### Receiver

The receiver, as depicted in Figure 5, comprises three inputs and two outputs. The RX signal serves as the serial data input, while the data_out signal represents the 8-bit parallel data output. Upon completion of the data reception process, the data_ready signal is briefly set high for one clock cycle.

![](images/toda_estimation.jpg)

Figure 6 presents the state machine governing the receiver, which closely mirrors that of the transmitter. In the idle state, the receiver remains dormant as long as the RX signal remains high. Upon detecting a transition of RX from high to low, indicating the start of a new data transmission, the receiver transitions to the start state. During this phase, lasting half a bit duration, the receiver precisely identifies the midpoint of the start bit. If RX remains low at this juncture, the receiver progresses to the data state. In the data state, the receiver meticulously samples the serial input after each bit period. These sampled bits are then stored in the corresponding positions of the output register, as indicated by Counter 2. This meticulous sampling ensures that the midpoint of each transmitted data bit is captured. Once all 8 bits of data have been successfully captured, the receiver transitions to the stop state for one bit period before returning to the idle state, ready for the next data transmission.

![](images/toda_estimation.jpg)

## FPGA Implementation

The FPGA development board I utilize is the Basys 3 board, powered by the Artix-7 FPGA. This board is equipped with a single 100MHz oscillator and features a USB-UART bridge for communication. The USB-UART bridge model employed is the FT2232. The connection layout between the USB-UART bridge and the FPGA is illustrated in the Figure 7. Specifically, TXD is linked to pin B18 while RXD to pin A18 on the Artix-7 FPGA.

![](images/toda_estimation.jpg)

Figure 8 illustrates the implementation of the UART module on the FPGA. The RX line is connected to pin B18, while TX is linked to pin A18. To test the functionality of the UART module, the loopback method is employed. In this setup, the data_out signal is directly routed to the data_in signal, and the data_ready signal is connected to the TX_start signal. Consequently, upon completion of data reception by the UART, the data_ready signal is triggered high, initiating the data transmission process. Subsequently, the transmitter within the UART module captures the data from the data_out signal for transmission.

![](images/toda_estimation.jpg)

After connecting the FPGA board with the PC and programming the FPGA through a USB cable, Tera Term is configured with the settings as shown in Figure 9. In the Figure 9, COM6 port is the port on the PC that is used to connect with FPGA, while Speed is the baud rate.

![](images/toda_estimation.jpg)

Next, a random key on the keyboard is pressed; for example, the key 'a' is selected, and its corresponding ASCII code is sent to the FPGA board. On the FPGA development board, LED7 to LED0 are utilized to display the data_out signal, which represents the output of the UART module's receiver. LED7 corresponds to the most significant bit of the ASCII code, while LED0 corresponds to the least significant bit. Figure 10 illustrates the outcome on the FPGA board after pressing the key 'a'. In Figure 10, LD6, LD5, and LD0 are illuminated, while the others are off, indicating that the data_out signal is '01100001' in binary. Referring to the ASCII table, the ASCII code of 'a' is also '01100001' in binary. Consequently, this demonstrates that the UART receiver successfully receives and samples the serial data.

![](images/toda_estimation.jpg)

Figure 11 shows the data sent back from the FPGA on Tera Term, which is the character 'a'. This serves as evidence that the transmitter in the UART successfully transmits 8-bit parallel data.
