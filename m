Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blu0-omc2-s28.blu0.hotmail.com ([65.55.111.103]:54910 "EHLO
	blu0-omc2-s28.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754429AbaCJQEN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Mar 2014 12:04:13 -0400
Message-ID: <BLU0-SMTP46CB5A22DD3965F65B4319EE740@phx.gbl> (sfid-20140310_170433_784183_EEC8E154)
Date: Mon, 10 Mar 2014 16:58:46 +0000
From: Guilherme Calandrini <g_calandrini@hotmail.com>
MIME-Version: 1.0
To: johannes.berg@intel.com, wey-yi.w.guy@intel.com,
	ilw@linux.intel.com, linux-wireless@vger.kernel.org
Subject: Intel Wireless Microcode
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[1.] One line summary of the problem:
Intel Wireless Microcode

[2.] Full description of the problem/report:

[3.] Keywords (i.e., modules, networking, kernel):
networking, wireless, iwlwifi

[4.] Kernel version (from /proc/version):
Linux version 3.10.33 (root@megalnx) (gcc version 4.8.2 (GCC) ) #2 SMP 
Sat Mar 8 17:38:31 UTC 2014

[5.] Output of Oops.. message (if applicable) with symbolic information
      resolved (see Documentation/oops-tracing.txt)
[16690.042163] iwlwifi 0000:03:00.0: Microcode SW error detected. 
Restarting 0x82000000.
[16690.042180] iwlwifi 0000:03:00.0: CSR values:
[16690.042181] iwlwifi 0000:03:00.0: (2nd byte of CSR_INT_COALESCING is 
CSR_INT_PERIODIC_REG)
[16690.042186] iwlwifi 0000:03:00.0:        CSR_HW_IF_CONFIG_REG: 0X00484b00
[16690.042191] iwlwifi 0000:03:00.0:          CSR_INT_COALESCING: 0X00000040
[16690.042195] iwlwifi 0000:03:00.0:                     CSR_INT: 0X00000000
[16690.042199] iwlwifi 0000:03:00.0:                CSR_INT_MASK: 0X00000000
[16690.042203] iwlwifi 0000:03:00.0:           CSR_FH_INT_STATUS: 0X00000000
[16690.042208] iwlwifi 0000:03:00.0:                 CSR_GPIO_IN: 0X00000038
[16690.042212] iwlwifi 0000:03:00.0:                   CSR_RESET: 0X00000000
[16690.042216] iwlwifi 0000:03:00.0:                CSR_GP_CNTRL: 0X080403c5
[16690.042220] iwlwifi 0000:03:00.0:                  CSR_HW_REV: 0X000000b0
[16690.042225] iwlwifi 0000:03:00.0:              CSR_EEPROM_REG: 0Xaaae0ffd
[16690.042229] iwlwifi 0000:03:00.0:               CSR_EEPROM_GP: 0X90000801
[16690.042233] iwlwifi 0000:03:00.0:              CSR_OTP_GP_REG: 0X00030001
[16690.042237] iwlwifi 0000:03:00.0:                 CSR_GIO_REG: 0X00080044
[16690.042242] iwlwifi 0000:03:00.0:            CSR_GP_UCODE_REG: 0X00007112
[16690.042246] iwlwifi 0000:03:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[16690.042250] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[16690.042263] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[16690.042267] iwlwifi 0000:03:00.0:                 CSR_LED_REG: 0X00000060
[16690.042272] iwlwifi 0000:03:00.0:        CSR_DRAM_INT_TBL_REG: 0X880fffff
[16690.042276] iwlwifi 0000:03:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[16690.042280] iwlwifi 0000:03:00.0:             CSR_ANA_PLL_CFG: 0X00000000
[16690.042285] iwlwifi 0000:03:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[16690.042289] iwlwifi 0000:03:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
[16690.042290] iwlwifi 0000:03:00.0: FH register values:
[16690.042304] iwlwifi 0000:03:00.0: FH_RSCSR_CHNL0_STTS_WPTR_REG: 
0X0ffffd00
[16690.042318] iwlwifi 0000:03:00.0: FH_RSCSR_CHNL0_RBDCB_BASE_REG: 
0X00ffffe0
[16690.042330] iwlwifi 0000:03:00.0: FH_RSCSR_CHNL0_WPTR: 0X00000098
[16690.042343] iwlwifi 0000:03:00.0: FH_MEM_RCSR_CHNL0_CONFIG_REG: 
0X80801114
[16690.042356] iwlwifi 0000:03:00.0: FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[16690.042369] iwlwifi 0000:03:00.0: FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
[16690.042381] iwlwifi 0000:03:00.0: FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 
0X00000000
[16690.042394] iwlwifi 0000:03:00.0: FH_TSSR_TX_STATUS_REG: 0X07ff0001
[16690.042407] iwlwifi 0000:03:00.0: FH_TSSR_TX_ERROR_REG: 0X00000000
[16690.042409] iwlwifi 0000:03:00.0: Loaded firmware version: 18.168.6.1
[16690.042527] iwlwifi 0000:03:00.0: Start IWL Error Log Dump:
[16690.042529] iwlwifi 0000:03:00.0: Status: 0x000022CC, count: 6
[16690.042530] iwlwifi 0000:03:00.0: 0x0000198A | ADVANCED_SYSASSERT
[16690.042532] iwlwifi 0000:03:00.0: 0x00015920 | uPc
[16690.042533] iwlwifi 0000:03:00.0: 0x00015910 | branchlink1
[16690.042534] iwlwifi 0000:03:00.0: 0x00015910 | branchlink2
[16690.042535] iwlwifi 0000:03:00.0: 0x0000DBEA | interruptlink1
[16690.042536] iwlwifi 0000:03:00.0: 0x00000000 | interruptlink2
[16690.042537] iwlwifi 0000:03:00.0: 0x00000274 | data1
[16690.042539] iwlwifi 0000:03:00.0: 0x0000000A | data2
[16690.042540] iwlwifi 0000:03:00.0: 0x000001DC | line
[16690.042541] iwlwifi 0000:03:00.0: 0x0100FC93 | beacon time
[16690.042542] iwlwifi 0000:03:00.0: 0x0006D36D | tsf low
[16690.042543] iwlwifi 0000:03:00.0: 0x00000000 | tsf hi
[16690.042544] iwlwifi 0000:03:00.0: 0x00000000 | time gp1
[16690.042546] iwlwifi 0000:03:00.0: 0x045FC88B | time gp2
[16690.042547] iwlwifi 0000:03:00.0: 0x00000000 | time gp3
[16690.042548] iwlwifi 0000:03:00.0: 0x754312A8 | uCode version
[16690.042549] iwlwifi 0000:03:00.0: 0x000000B0 | hw version
[16690.042550] iwlwifi 0000:03:00.0: 0x00484B00 | board version
[16690.042551] iwlwifi 0000:03:00.0: 0x0000001C | hcmd
[16690.042553] iwlwifi 0000:03:00.0: 0x2F863000 | isr0
[16690.042554] iwlwifi 0000:03:00.0: 0x1189F800 | isr1
[16690.042555] iwlwifi 0000:03:00.0: 0x00000E02 | isr2
[16690.042556] iwlwifi 0000:03:00.0: 0x0543FCC3 | isr3
[16690.042557] iwlwifi 0000:03:00.0: 0x00000000 | isr4
[16690.042558] iwlwifi 0000:03:00.0: 0x00800110 | isr_pref
[16690.042559] iwlwifi 0000:03:00.0: 0x000260A4 | wait_event
[16690.042561] iwlwifi 0000:03:00.0: 0x00008A61 | l2p_control
[16690.042562] iwlwifi 0000:03:00.0: 0x0000A043 | l2p_duration
[16690.042563] iwlwifi 0000:03:00.0: 0x00000003 | l2p_mhvalid
[16690.042564] iwlwifi 0000:03:00.0: 0x00A00200 | l2p_addr_match
[16690.042565] iwlwifi 0000:03:00.0: 0x00000005 | lmpm_pmg_sel
[16690.042566] iwlwifi 0000:03:00.0: 0x13011136 | timestamp
[16690.042568] iwlwifi 0000:03:00.0: 0x000098A8 | flow_handler
[16690.042621] iwlwifi 0000:03:00.0: Start IWL Event Log Dump: nothing 
in log
[16690.042928] ieee80211 phy0: Hardware restart was requested
[6.] A small shell script or example program which triggers the
      problem (if possible)
None

[7.] Environment
Slackware64 14.1

[7.1.] Software (add the output of the ver_linux script here)
Linux megalnx 3.10.33 #2 SMP Sat Mar 8 17:38:31 UTC 2014 x86_64 Intel(R) 
Core(TM) i7-3517U CPU @ 1.90GHz GenuineIntel GNU/Linux

Gnu C                  4.8.2
Gnu make               3.82
binutils               2.23.2
util-linux             2.21.2
mount                  support
module-init-tools      found
quota-tools            3.17.
Linux C Library        2.17
Dynamic linker (ldd)   2.17
Procps                 3.2.8
Kbd                    1.15.3
oprofile               0.9.9
Sh-utils               8.21
Modules Loaded         ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat 
bridge stp llc rfcomm vboxpci vboxnetadp vboxnetflt vboxdrv bnep ppdev 
parport_pc parport uvcvideo videobuf2_vmalloc videobuf2_memops 
videobuf2_core btusb bluetooth mxm_wmi asus_nb_wmi intel_powerclamp 
coretemp kvm_intel kvm crc32_pclmul ghash_clmulni_intel aesni_intel 
aes_x86_64 lrw glue_helper ablk_helper cryptd joydev serio_raw i2c_i801 
gpio_ich mei_me xhci_hcd mei i2c_dev bbswitch asus_wmi

[7.2.] Processor information (from /proc/cpuinfo):
Intel(R) Core(TM) i7-3517U CPU @ 1.90GHz

[7.3.] Module information (from /proc/modules):
Module                  Size  Used by
ipt_MASQUERADE          1887  1
iptable_nat             2866  1
nf_nat_ipv4             3743  1 iptable_nat
nf_nat                 16163  3 ipt_MASQUERADE,nf_nat_ipv4,iptable_nat
bridge                 73294  0
stp                     2112  1 bridge
llc                     5360  2 stp,bridge
rfcomm                 32881  4
vboxpci                13802  0
vboxnetadp             18070  0
vboxnetflt             16749  0
vboxdrv               323561  6 vboxnetadp,vboxnetflt,vboxpci
bnep                   11020  2
ppdev                   5974  0
parport_pc             31814  0
parport                36040  2 ppdev,parport_pc
uvcvideo               72313  0
videobuf2_vmalloc       2984  1 uvcvideo
videobuf2_memops        2330  1 videobuf2_vmalloc
videobuf2_core         31299  1 uvcvideo
btusb                  16890  0
bluetooth             221870  24 bnep,btusb,rfcomm
mxm_wmi                 1893  0
asus_nb_wmi             6942  0
intel_powerclamp        9857  0
coretemp                6235  0
kvm_intel             129448  0
kvm                   404290  1 kvm_intel
crc32_pclmul            2945  0
ghash_clmulni_intel     4403  0
aesni_intel            44585  1
aes_x86_64              7731  1 aesni_intel
lrw                     3886  1 aesni_intel
glue_helper             5326  1 aesni_intel
ablk_helper             2853  1 aesni_intel
cryptd                  9207  3 ghash_clmulni_intel,aesni_intel,ablk_helper
joydev                  9788  0
serio_raw               4885  0
i2c_i801               14353  0
gpio_ich                4876  0
mei_me                  7865  0
xhci_hcd               86732  0
mei                    45641  1 mei_me
i2c_dev                 5884  0
bbswitch                5887  0
asus_wmi               16687  1 asus_nb_wmi

[7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)

[7.5.] PCI information ('lspci -vvv' as root)
00:00.0 Host bridge: Intel Corporation 3rd Gen Core processor DRAM 
Controller (rev 09)
     Subsystem: ASUSTeK Computer Inc. Device 1507
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ >SERR- <PERR- INTx-
     Latency: 0
     Capabilities: [e0] Vendor Specific Information: Len=0c <?>

00:01.0 PCI bridge: Intel Corporation Xeon E3-1200 v2/3rd Gen Core 
processor PCI Express Root Port (rev 09) (prog-if 00 [Normal decode])
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 64 bytes
     Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
     I/O behind bridge: 0000e000-0000efff
     Memory behind bridge: f6000000-f70fffff
     Prefetchable memory behind bridge: 00000000e0000000-00000000f1ffffff
     Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
     BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
     Capabilities: [88] Subsystem: ASUSTeK Computer Inc. Device 1507
     Capabilities: [80] Power Management version 3
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
         Address: fee002d8  Data: 0000
     Capabilities: [a0] Express (v2) Root Port (Slot+), MSI 00
         DevCap:    MaxPayload 256 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us
             ExtTag- RBE+ FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
             MaxPayload 256 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- 
TransPend-
         LnkCap:    Port #2, Speed 5GT/s, Width x16, ASPM L0s L1, 
Latency L0 <256ns, L1 <8us
             ClockPM- Surprise- LLActRep- BwNot+
         LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled+ Retrain- CommClk+
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x8, TrErr- Train- SlotClk+ 
DLActive- BWMgmt+ ABWMgmt-
         SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- 
Surprise-
             Slot #1, PowerLimit 75.000W; Interlock- NoCompl+
         SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- 
HPIrq- LinkChg-
             Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
         SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ 
Interlock-
             Changed: MRL- PresDet+ LinkState-
         RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- 
CRSVisible-
         RootCap: CRSVisible-
         RootSta: PME ReqID 0000, PMEStatus- PMEPending-
         DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, 
OBFF Not Supported ARIFwd-
         DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, 
OBFF Disabled ARIFwd-
         LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
              Transmit Margin: Normal Operating Range, 
EnterModifiedCompliance- ComplianceSOS-
              Compliance De-emphasis: -6dB
         LnkSta2: Current De-emphasis Level: -6dB, 
EqualizationComplete-, EqualizationPhase1-
              EqualizationPhase2-, EqualizationPhase3-, 
LinkEqualizationRequest-
     Capabilities: [100 v1] Virtual Channel
         Caps:    LPEVC=0 RefClk=100ns PATEntryBits=1
         Arb:    Fixed- WRR32- WRR64- WRR128-
         Ctrl:    ArbSelect=Fixed
         Status:    InProgress-
         VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
             Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
             Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
             Status:    NegoPending+ InProgress-
     Capabilities: [140 v1] Root Complex Link
         Desc:    PortNumber=02 ComponentID=01 EltType=Config
         Link0:    Desc:    TargetPort=00 TargetComponent=01 AssocRCRB- 
LinkType=MemMapped LinkValid+
             Addr:    00000000fed19000
     Kernel driver in use: pcieport
     Kernel modules: shpchp

00:02.0 VGA compatible controller: Intel Corporation 3rd Gen Core 
processor Graphics Controller (rev 09) (prog-if 00 [VGA controller])
     Subsystem: ASUSTeK Computer Inc. Device 1507
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin A routed to IRQ 43
     Region 0: Memory at f7400000 (64-bit, non-prefetchable) [size=4M]
     Region 2: Memory at d0000000 (64-bit, prefetchable) [size=256M]
     Region 4: I/O ports at f000 [size=64]
     Expansion ROM at <unassigned> [disabled]
     Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
         Address: fee00018  Data: 0000
     Capabilities: [d0] Power Management version 2
         Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [a4] PCI Advanced Features
         AFCap: TP+ FLR+
         AFCtrl: FLR-
         AFStatus: TP-
     Kernel driver in use: i915

00:04.0 Signal processing controller: Intel Corporation 3rd Gen Core 
Processor Thermal Subsystem (rev 09)
     Subsystem: ASUSTeK Computer Inc. Device 1507
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin A routed to IRQ 11
     Region 0: Memory at cfe08000 (64-bit, non-prefetchable) [size=32K]
     Capabilities: [90] MSI: Enable- Count=1/1 Maskable- 64bit-
         Address: 00000000  Data: 0000
     Capabilities: [d0] Power Management version 3
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
         Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [e0] Vendor Specific Information: Len=0c <?>

00:14.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset 
Family USB xHCI Host Controller (rev 04) (prog-if 30 [XHCI])
     Subsystem: ASUSTeK Computer Inc. Device 1507
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin A routed to IRQ 47
     Region 0: Memory at f7900000 (64-bit, non-prefetchable) [size=64K]
     Capabilities: [70] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0-,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [80] MSI: Enable+ Count=1/8 Maskable- 64bit+
         Address: 00000000fee00398  Data: 0000
     Kernel driver in use: xhci_hcd
     Kernel modules: xhci_hcd

00:16.0 Communication controller: Intel Corporation 7 Series/C210 Series 
Chipset Family MEI Controller #1 (rev 04)
     Subsystem: ASUSTeK Computer Inc. Device 1507
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin A routed to IRQ 48
     Region 0: Memory at f7922000 (64-bit, non-prefetchable) [size=16]
     Capabilities: [50] Power Management version 3
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [8c] MSI: Enable+ Count=1/1 Maskable- 64bit+
         Address: 00000000fee003b8  Data: 0000
     Kernel driver in use: mei_me
     Kernel modules: mei_me

00:1a.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset 
Family USB Enhanced Host Controller #2 (rev 04) (prog-if 20 [EHCI])
     Subsystem: ASUSTeK Computer Inc. Device 1507
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin A routed to IRQ 16
     Region 0: Memory at f7920000 (32-bit, non-prefetchable) [size=1K]
     Capabilities: [50] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [58] Debug port: BAR=1 offset=00a0
     Capabilities: [98] PCI Advanced Features
         AFCap: TP+ FLR+
         AFCtrl: FLR-
         AFStatus: TP-
     Kernel driver in use: ehci-pci

00:1b.0 Audio device: Intel Corporation 7 Series/C210 Series Chipset 
Family High Definition Audio Controller (rev 04)
     Subsystem: ASUSTeK Computer Inc. Device 1507
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 64 bytes
     Interrupt: pin A routed to IRQ 46
     Region 0: Memory at f7918000 (64-bit, non-prefetchable) [size=16K]
     Capabilities: [50] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
         Address: 00000000fee00378  Data: 0000
     Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, 
MSI 00
         DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us
             ExtTag- RBE- FLReset+
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
             MaxPayload 128 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ 
TransPend-
         LnkCap:    Port #0, Speed unknown, Width x0, ASPM unknown, 
Latency L0 <64ns, L1 <1us
             ClockPM- Surprise- LLActRep- BwNot-
         LnkCtl:    ASPM Disabled; Disabled- Retrain- CommClk-
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed unknown, Width x0, TrErr- Train- SlotClk- 
DLActive- BWMgmt- ABWMgmt-
     Capabilities: [100 v1] Virtual Channel
         Caps:    LPEVC=0 RefClk=100ns PATEntryBits=1
         Arb:    Fixed- WRR32- WRR64- WRR128-
         Ctrl:    ArbSelect=Fixed
         Status:    InProgress-
         VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
             Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
             Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=01
             Status:    NegoPending- InProgress-
         VC1:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
             Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
             Ctrl:    Enable+ ID=1 ArbSelect=Fixed TC/VC=22
             Status:    NegoPending- InProgress-
     Capabilities: [130 v1] Root Complex Link
         Desc:    PortNumber=0f ComponentID=00 EltType=Config
         Link0:    Desc:    TargetPort=00 TargetComponent=00 AssocRCRB- 
LinkType=MemMapped LinkValid+
             Addr:    00000000fed1c000
     Kernel driver in use: snd_hda_intel

00:1c.0 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset 
Family PCI Express Root Port 1 (rev c4) (prog-if 00 [Normal decode])
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 64 bytes
     Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
     I/O behind bridge: 0000f000-00000fff
     Memory behind bridge: fff00000-000fffff
     Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
     Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
     BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
     Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
         DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us
             ExtTag- RBE+ FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
             MaxPayload 128 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ 
TransPend-
         LnkCap:    Port #1, Speed 5GT/s, Width x1, ASPM L0s L1, Latency 
L0 <1us, L1 <16us
             ClockPM- Surprise- LLActRep+ BwNot-
         LnkCtl:    ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- 
CommClk-
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
         SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- 
Surprise-
             Slot #0, PowerLimit 10.000W; Interlock- NoCompl+
         SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- 
HPIrq- LinkChg-
             Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
         SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- 
Interlock-
             Changed: MRL- PresDet- LinkState-
         RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- 
CRSVisible-
         RootCap: CRSVisible-
         RootSta: PME ReqID 0000, PMEStatus- PMEPending-
         DevCap2: Completion Timeout: Range BC, TimeoutDis+, LTR-, OBFF 
Not Supported ARIFwd-
         DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, 
OBFF Disabled ARIFwd-
         LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
              Transmit Margin: Normal Operating Range, 
EnterModifiedCompliance- ComplianceSOS-
              Compliance De-emphasis: -6dB
         LnkSta2: Current De-emphasis Level: -3.5dB, 
EqualizationComplete-, EqualizationPhase1-
              EqualizationPhase2-, EqualizationPhase3-, 
LinkEqualizationRequest-
     Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
         Address: 00000000  Data: 0000
     Capabilities: [90] Subsystem: ASUSTeK Computer Inc. Device 1507
     Capabilities: [a0] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Kernel driver in use: pcieport
     Kernel modules: shpchp

00:1c.1 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset 
Family PCI Express Root Port 2 (rev c4) (prog-if 00 [Normal decode])
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 64 bytes
     Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
     I/O behind bridge: 0000f000-00000fff
     Memory behind bridge: f7800000-f78fffff
     Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
     Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
     BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
     Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
         DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us
             ExtTag- RBE+ FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
             MaxPayload 128 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ 
TransPend-
         LnkCap:    Port #2, Speed 5GT/s, Width x1, ASPM L0s L1, Latency 
L0 <512ns, L1 <16us
             ClockPM- Surprise- LLActRep+ BwNot-
         LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive+ BWMgmt+ ABWMgmt-
         SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- 
Surprise-
             Slot #1, PowerLimit 10.000W; Interlock- NoCompl+
         SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- 
HPIrq- LinkChg-
             Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
         SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ 
Interlock-
             Changed: MRL- PresDet- LinkState+
         RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- 
CRSVisible-
         RootCap: CRSVisible-
         RootSta: PME ReqID 0000, PMEStatus- PMEPending-
         DevCap2: Completion Timeout: Range BC, TimeoutDis+, LTR-, OBFF 
Not Supported ARIFwd-
         DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, 
OBFF Disabled ARIFwd-
         LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
              Transmit Margin: Normal Operating Range, 
EnterModifiedCompliance- ComplianceSOS-
              Compliance De-emphasis: -6dB
         LnkSta2: Current De-emphasis Level: -3.5dB, 
EqualizationComplete-, EqualizationPhase1-
              EqualizationPhase2-, EqualizationPhase3-, 
LinkEqualizationRequest-
     Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
         Address: 00000000  Data: 0000
     Capabilities: [90] Subsystem: ASUSTeK Computer Inc. Device 1507
     Capabilities: [a0] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Kernel driver in use: pcieport
     Kernel modules: shpchp

00:1d.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset 
Family USB Enhanced Host Controller #1 (rev 04) (prog-if 20 [EHCI])
     Subsystem: ASUSTeK Computer Inc. Device 1507
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin A routed to IRQ 23
     Region 0: Memory at f791f000 (32-bit, non-prefetchable) [size=1K]
     Capabilities: [50] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME+
     Capabilities: [58] Debug port: BAR=1 offset=00a0
     Capabilities: [98] PCI Advanced Features
         AFCap: TP+ FLR+
         AFCtrl: FLR-
         AFStatus: TP+
     Kernel driver in use: ehci-pci

00:1f.0 ISA bridge: Intel Corporation HM76 Express Chipset LPC 
Controller (rev 04)
     Subsystem: ASUSTeK Computer Inc. Device 1507
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Capabilities: [e0] Vendor Specific Information: Len=0c <?>
     Kernel driver in use: lpc_ich

00:1f.2 SATA controller: Intel Corporation 7 Series Chipset Family 
6-port SATA Controller [AHCI mode] (rev 04) (prog-if 01 [AHCI 1.0])
     Subsystem: ASUSTeK Computer Inc. Device 1507
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
     Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin B routed to IRQ 44
     Region 0: I/O ports at f0b0 [size=8]
     Region 1: I/O ports at f0a0 [size=4]
     Region 2: I/O ports at f090 [size=8]
     Region 3: I/O ports at f080 [size=4]
     Region 4: I/O ports at f060 [size=32]
     Region 5: Memory at f791e000 (32-bit, non-prefetchable) [size=2K]
     Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
         Address: fee00318  Data: 0000
     Capabilities: [70] Power Management version 3
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot+,D3cold-)
         Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=00000004
     Capabilities: [b0] PCI Advanced Features
         AFCap: TP+ FLR+
         AFCtrl: FLR-
         AFStatus: TP-
     Kernel driver in use: ahci

00:1f.3 SMBus: Intel Corporation 7 Series/C210 Series Chipset Family 
SMBus Controller (rev 04)
     Subsystem: ASUSTeK Computer Inc. Device 1507
     Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Interrupt: pin C routed to IRQ 18
     Region 0: Memory at f791d000 (64-bit, non-prefetchable) [size=256]
     Region 4: I/O ports at f040 [size=32]
     Kernel driver in use: i801_smbus
     Kernel modules: i2c_i801

00:1f.6 Signal processing controller: Intel Corporation 7 Series/C210 
Series Chipset Family Thermal Management Controller (rev 04)
     Subsystem: ASUSTeK Computer Inc. Device 1507
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin C routed to IRQ 10
     Region 0: Memory at f791c000 (64-bit, non-prefetchable) [size=4K]
     Capabilities: [50] Power Management version 3
         Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
         Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-

01:00.0 3D controller: NVIDIA Corporation GF117M [GeForce 610M/710M / GT 
620M/625M/630M/720M] (rev ff) (prog-if ff)
     !!! Unknown header type 7f
     Kernel modules: nouveau, nvidia

03:00.0 Network controller: Intel Corporation Centrino Advanced-N 6235 
(rev 24)
     Subsystem: Intel Corporation Centrino Advanced-N 6235 AGN
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 64 bytes
     Interrupt: pin A routed to IRQ 45
     Region 0: Memory at f7800000 (64-bit, non-prefetchable) [size=8K]
     Capabilities: [c8] Power Management version 3
         Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
         Address: 00000000fee00338  Data: 0000
     Capabilities: [e0] Express (v1) Endpoint, MSI 00
         DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<512ns, L1 unlimited
             ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
             RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
             MaxPayload 128 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ 
TransPend-
         LnkCap:    Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, 
Latency L0 <4us, L1 <32us
             ClockPM+ Surprise- LLActRep- BwNot-
         LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
     Capabilities: [100 v1] Advanced Error Reporting
         UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
         UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
         UESvrt:    DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
         CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
         CEMsk:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
         AERCap:    First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
     Capabilities: [140 v1] Device Serial Number c4-85-08-ff-ff-20-75-9c
     Kernel driver in use: iwlwifi

[7.6.] SCSI information (from /proc/scsi/scsi)
None
[7.7.] Other information that might be relevant to the problem
        (please look in /proc and include all information that you
        think to be relevant):
I'm not sure, but the problem normaly happen using the Bluetooth

[X.] Other notes, patches, fixes, workarounds:



-- 
Regards,

Guilherme Calandrini


