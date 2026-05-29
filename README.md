# 🏀 Real-Time Scoring System with CDC and Debounce Handling

![Platform](https://img.shields.io/badge/Platform-Basys3%20Artix--7-red)
![Language](https://img.shields.io/badge/Language-Verilog%20HDL-blue)
![Tool](https://img.shields.io/badge/Tool-Xilinx%20Vivado-orange)
![Status](https://img.shields.io/badge/Status-Complete-brightgreen)

## 📌 Overview
Real-time scoring system implemented in Verilog HDL on Basys3 (Artix-7) FPGA. The system handles asynchronous IR sensor input using a 2-flip-flop synchronizer for Clock Domain Crossing (CDC), filters noise using a 20-bit counter-based debounce filter, and displays scores up to 9999 on a 7-segment display.

## 🏗️ System Architecture

```
IR Sensor Input (Async)
      |
      v
2-FF Synchronizer
(CDC — eliminates metastability)
      |
      v
20-bit Counter Debounce Filter
(~10ms window — removes noise)
      |
      v
Rising Edge Detector
(single-cycle pulse per event)
      |
      v
4-Digit BCD Score Counter
(0000 to 9999)
      |
      v
Time-Multiplexed 7-Segment Display
```

## ✨ Features
- 2-flip-flop synchronizer for Clock Domain Crossing (CDC)
- 20-bit counter-based debounce filter (~10ms window)
- Rising edge detector — single pulse per valid event
- 4-digit BCD counter with cascaded carry logic (0000–9999)
- Time-multiplexed 7-segment display driver (~380Hz refresh)
- Modular architecture across 4 sub-modules
- Reset via center button (btnC)

## 📁 Repository Structure

```
basys3-scoring-system/
├── src/
│   ├── top_basketball.v       ← Top level module
│   ├── debouncer.v            ← Synchronizer + debounce + edge detect
│   ├── score_counter.v        ← 4-digit BCD counter
│   └── sev_seg_driver.v       ← 7-segment display driver
├── constraints/
│   └── basys3.xdc             ← Pin constraints
└── README.md
```

## 🔬 Key Concepts Demonstrated

| Concept | Where Used |
|---|---|
| CDC — 2-FF Synchronizer | debouncer.v — sync_0, sync_1 |
| Counter-based debouncing | debouncer.v — 20-bit counter |
| Rising edge detection | debouncer.v — one_shot output |
| BCD cascaded carry | score_counter.v |
| Time-multiplexed display | sev_seg_driver.v |
| Modular Verilog design | 4 separate sub-modules |

## 🛠️ Tools & Platform

| Item | Details |
|---|---|
| FPGA Board | Digilent Basys3 (Artix-7 XC7A35T) |
| Language | Verilog HDL |
| Tool | Xilinx Vivado |
| Clock | 100 MHz |
| Debounce Window | ~10ms (20-bit counter) |
| Display Refresh | ~380Hz |

## 📐 Module Description

### debouncer.v
Handles the full input conditioning pipeline:
- **Synchronizer** — 2 flip-flops prevent metastability from async IR sensor
- **Counter Filter** — 20-bit counter ensures signal stable for ~10ms before accepting
- **Edge Detector** — Generates exactly one clock-cycle pulse per valid event

### score_counter.v
- 4-digit BCD counter
- Cascaded carry logic — digit0 → digit1 → digit2 → digit3
- Supports scores from 0000 to 9999
- Synchronous reset

### sev_seg_driver.v
- Time-multiplexed 7-segment display
- 18-bit refresh counter → ~380Hz per digit
- Active-low anode and segment control for Basys3

## ▶️ How to Run

**Hardware:**
```
1. Add src/*.v as Design Sources
2. Add constraints/basys3.xdc
3. Run Synthesis → Implementation → Generate Bitstream
4. Program Basys3 via Hardware Manager
5. Connect IR sensor to Pmod JB Pin 1 (A14)
6. Trigger sensor — score increments on display
7. Press btnC to reset score to 0000
```

## 👤 Author
**Raghavendra Palukuri**  
M.Tech VLSI & ES — DIAT Pune (DRDO)  
📧 raghavapalukuri25p@gmail.com  
🔗 [LinkedIn](https://www.linkedin.com/in/raghavendra-palukuri)
