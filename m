Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:59513 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585AbaCaQKh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2014 12:10:37 -0400
Received: by mail-la0-f49.google.com with SMTP id mc6so5872721lab.22
        for <linux-wireless@vger.kernel.org>; Mon, 31 Mar 2014 09:10:35 -0700 (PDT)
MIME-Version: 1.0
From: Peter Schueller <schueller.p@gmail.com>
Date: Mon, 31 Mar 2014 19:10:15 +0300
Message-ID: <CALomXVq2qTRmm7_gd-N4ytBq+g6PV7k7Bz08mEqw0swqmFtVhw@mail.gmail.com> (sfid-20140331_181113_530346_82C466CE)
Subject: 2357:0100 [Gigabyte 965P-DS3] USB Wifi TP-Link WN8200ND unstable
 connection with access points, cannot associate to some other access point
To: linux-wireless@vger.kernel.org
Cc: Christopher Penalver <christopher.m.penalver@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Please CC me schueller.p@gmail.com in replies as I am not subscribed.

I am using the reporting format shown here:
https://wiki.ubuntu.com/Bugs/Upstream/kernel

[1.] One line summary of the problem:

2357:0100 [Gigabyte 965P-DS3] USB Wifi TP-Link WN8200ND unstable
connection with access points, cannot associate to some other access
point

[2.] Full description of the problem/report:

Using the kernel 3.14.0-rc8 on AMD64 architecture, the Usb Wifi
dongle TP-Link WN8200ND (rtl8192cu driver) fails to associate to
some access points, if a connection is established the connection
is unstable (27% packet loss, where a laptop in the same location
achieves 0% packet loss using the same access point).
Trying to configure the Usb Wifi as an access point fails with
garbage in the syslog.

[3.] Keywords (i.e., modules, networking, kernel): Please do not put
anything here.

[4.] Kernel version (from /proc/version):

Linux version 3.14.0-031400rc8-generic (apw@gomeisa) (gcc version
4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5) ) #201403242335 SMP Tue Mar 25
03:36:22 UTC 2014

[5.] No Oops message

[6.] No shell script to reproduce.

[7.] Environment

Description:    Ubuntu Trusty Tahr (development branch)
Release:    14.04

[7.1.] Software (add the output of the ver_linux script here)

If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux oldie 3.14.0-031400rc8-generic #201403242335 SMP Tue Mar 25
03:36:22 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux

Gnu C                  4.8
Gnu make               3.81
binutils               2.24
util-linux             2.20.1
mount                  support
module-init-tools      15
e2fsprogs              1.42.9
pcmciautils            018
PPP                    2.4.5
Linux C Library        2.19
Dynamic linker (ldd)   2.19
Procps                 3.3.9
Net-tools              1.60
Kbd                    1.15.5
Sh-utils               8.21
wireless-tools         30
Modules Loaded         rfcomm bnep bluetooth 6lowpan_iphc binfmt_misc
saa7134_alsa rtl_usb rtlwifi rtl8192c_common mt20xx coretemp mac80211
tea5767 kvm_intel kvm tda9887 radeon tda8290 snd_ymfpci cfg80211
snd_hda_codec_realtek snd_mpu401_uart tuner gpio_ich
snd_hda_codec_generic ppdev snd_opl3_lib snd_ac97_codec snd_hda_intel
snd_hda_codec saa7134 ac97_bus microcode gameport snd_hwdep 8192cu
snd_seq_midi snd_seq_midi_event snd_rawmidi tveeprom snd_seq ttm
snd_seq_device videobuf_dma_sg snd_pcm psmouse drm_kms_helper
snd_timer joydev rc_core drm serio_raw v4l2_common snd soundcore
videobuf_core i2c_algo_bit videodev lp parport_pc lpc_ich parport
mac_hid hid_generic usbhid hid pata_acpi ahci pata_jmicron sky2
libahci

[7.2.] Processor information (from /proc/cpuinfo):

processor    : 0
vendor_id    : GenuineIntel
cpu family    : 6
model        : 15
model name    : Intel(R) Core(TM)2 CPU          6300  @ 1.86GHz
stepping    : 6
microcode    : 0x44
cpu MHz        : 1866.645
cache size    : 2048 KB
physical id    : 0
siblings    : 2
core id        : 0
cpu cores    : 2
apicid        : 0
initial apicid    : 0
fpu        : yes
fpu_exception    : yes
cpuid level    : 10
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx lm constant_tsc arch_perfmon pebs bts rep_good nopl
aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm
lahf_lm dtherm tpr_shadow
bogomips    : 3733.29
clflush size    : 64
cache_alignment    : 64
address sizes    : 36 bits physical, 48 bits virtual
power management:

processor    : 1
vendor_id    : GenuineIntel
cpu family    : 6
model        : 15
model name    : Intel(R) Core(TM)2 CPU          6300  @ 1.86GHz
stepping    : 6
microcode    : 0x44
cpu MHz        : 1866.645
cache size    : 2048 KB
physical id    : 0
siblings    : 2
core id        : 1
cpu cores    : 2
apicid        : 1
initial apicid    : 1
fpu        : yes
fpu_exception    : yes
cpuid level    : 10
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx lm constant_tsc arch_perfmon pebs bts rep_good nopl
aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm
lahf_lm dtherm tpr_shadow
bogomips    : 3733.29
clflush size    : 64
cache_alignment    : 64
address sizes    : 36 bits physical, 48 bits virtual
power management:

[7.3.] Module information (from /proc/modules):

rfcomm 74734 0 - Live 0x0000000000000000
bnep 19884 2 - Live 0x0000000000000000
bluetooth 426845 10 rfcomm,bnep, Live 0x0000000000000000
6lowpan_iphc 18968 1 bluetooth, Live 0x0000000000000000
binfmt_misc 17508 1 - Live 0x0000000000000000
saa7134_alsa 18651 1 - Live 0x0000000000000000
rtl_usb 18713 0 - Live 0x0000000000000000
rtlwifi 64281 1 rtl_usb, Live 0x0000000000000000
rtl8192c_common 58236 0 - Live 0x0000000000000000
mt20xx 18047 1 - Live 0x0000000000000000
coretemp 17768 0 - Live 0x0000000000000000
mac80211 676864 2 rtl_usb,rtlwifi, Live 0x0000000000000000
tea5767 13297 0 - Live 0x0000000000000000
kvm_intel 148674 0 - Live 0x0000000000000000
kvm 471679 1 kvm_intel, Live 0x0000000000000000
tda9887 14154 1 - Live 0x0000000000000000
radeon 1576014 0 - Live 0x0000000000000000
tda8290 22616 0 - Live 0x0000000000000000
snd_ymfpci 47920 2 - Live 0x0000000000000000
cfg80211 531467 2 rtlwifi,mac80211, Live 0x0000000000000000
snd_hda_codec_realtek 66644 1 - Live 0x0000000000000000
snd_mpu401_uart 14169 1 snd_ymfpci, Live 0x0000000000000000
tuner 27390 2 - Live 0x0000000000000000
gpio_ich 13526 0 - Live 0x0000000000000000
snd_hda_codec_generic 69424 1 snd_hda_codec_realtek, Live 0x0000000000000000
ppdev 17711 0 - Live 0x0000000000000000
snd_opl3_lib 19391 1 snd_ymfpci, Live 0x0000000000000000
snd_ac97_codec 135016 1 snd_ymfpci, Live 0x0000000000000000
snd_hda_intel 57222 3 - Live 0x0000000000000000
snd_hda_codec 142651 3
snd_hda_codec_realtek,snd_hda_codec_generic,snd_hda_intel, Live
0x0000000000000000
saa7134 187296 1 saa7134_alsa, Live 0x0000000000000000
ac97_bus 12730 1 snd_ac97_codec, Live 0x0000000000000000
microcode 24391 0 - Live 0x0000000000000000
gameport 19986 1 snd_ymfpci, Live 0x0000000000000000
snd_hwdep 13613 2 snd_opl3_lib,snd_hda_codec, Live 0x0000000000000000
8192cu 632715 0 - Live 0x0000000000000000 (OF)
snd_seq_midi 13324 0 - Live 0x0000000000000000
snd_seq_midi_event 14899 1 snd_seq_midi, Live 0x0000000000000000
snd_rawmidi 30465 2 snd_mpu401_uart,snd_seq_midi, Live 0x0000000000000000
tveeprom 21250 1 saa7134, Live 0x0000000000000000
snd_seq 66061 2 snd_seq_midi,snd_seq_midi_event, Live 0x0000000000000000
ttm 90127 1 radeon, Live 0x0000000000000000
snd_seq_device 14497 4 snd_opl3_lib,snd_seq_midi,snd_rawmidi,snd_seq,
Live 0x0000000000000000
videobuf_dma_sg 19354 2 saa7134_alsa,saa7134, Live 0x0000000000000000
snd_pcm 108860 5
saa7134_alsa,snd_ymfpci,snd_ac97_codec,snd_hda_intel,snd_hda_codec,
Live 0x0000000000000000
psmouse 108621 0 - Live 0x0000000000000000
drm_kms_helper 53224 1 radeon, Live 0x0000000000000000
snd_timer 30038 4 snd_ymfpci,snd_opl3_lib,snd_seq,snd_pcm, Live
0x0000000000000000
joydev 17575 0 - Live 0x0000000000000000
rc_core 28170 1 saa7134, Live 0x0000000000000000
drm 308197 3 radeon,ttm,drm_kms_helper, Live 0x0000000000000000
serio_raw 13462 0 - Live 0x0000000000000000
v4l2_common 15715 2 tuner,saa7134, Live 0x0000000000000000
snd 73979 28 saa7134_alsa,snd_ymfpci,snd_hda_codec_realtek,snd_mpu401_uart,snd_hda_codec_generic,snd_opl3_lib,snd_ac97_codec,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_seq_midi,snd_rawmidi,snd_seq,snd_seq_device,snd_pcm,snd_timer,
Live 0x0000000000000000
soundcore 12680 1 snd, Live 0x0000000000000000
videobuf_core 26336 2 saa7134,videobuf_dma_sg, Live 0x0000000000000000
i2c_algo_bit 13564 1 radeon, Live 0x0000000000000000
videodev 149340 3 tuner,saa7134,v4l2_common, Live 0x0000000000000000
lp 17799 0 - Live 0x0000000000000000
parport_pc 32866 1 - Live 0x0000000000000000
lpc_ich 21163 0 - Live 0x0000000000000000
parport 42481 3 ppdev,lp,parport_pc, Live 0x0000000000000000
mac_hid 13253 0 - Live 0x0000000000000000
hid_generic 12548 0 - Live 0x0000000000000000
usbhid 53067 0 - Live 0x0000000000000000
hid 106254 2 hid_generic,usbhid, Live 0x0000000000000000
pata_acpi 13038 0 - Live 0x0000000000000000
ahci 30066 0 - Live 0x0000000000000000
pata_jmicron 12758 0 - Live 0x0000000000000000
sky2 63205 0 - Live 0x0000000000000000
libahci 32191 1 ahci, Live 0x0000000000000000

[7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)

cat /proc/ioports

0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-0060 : keyboard
0064-0064 : keyboard
0070-0073 : rtc0
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0290-029f : pnp 00:00
  0290-0294 : pnp 00:00
0378-037a : parport0
03c0-03df : vesafb
03f8-03ff : serial
0400-0403 : ACPI PM1a_EVT_BLK
0404-0405 : ACPI PM1a_CNT_BLK
0408-040b : ACPI PM_TMR
0410-0415 : ACPI CPU throttle
0428-042f : ACPI GPE0_BLK
0430-0433 : iTCO_wdt
0460-047f : iTCO_wdt
0480-04bf : gpio_ich
  0480-04bf : 0000:00:1f.0
    0480-04af : gpio_ich
    04b0-04bf : gpio_ich
04d0-04d1 : pnp 00:00
0500-051f : 0000:00:1f.3
0800-087f : pnp 00:00
0880-088f : pnp 00:00
0cf8-0cff : PCI conf1
4000-4fff : PCI Bus 0000:02
5000-5fff : PCI Bus 0000:01
  5000-50ff : 0000:01:00.0
6000-7fff : PCI Bus 0000:03
  6000-6007 : 0000:03:00.1
    6000-6007 : pata_jmicron
  6400-6403 : 0000:03:00.1
    6400-6403 : pata_jmicron
  6800-6807 : 0000:03:00.1
    6800-6807 : pata_jmicron
  6c00-6c03 : 0000:03:00.1
    6c00-6c03 : pata_jmicron
  7000-700f : 0000:03:00.1
    7000-700f : pata_jmicron
8000-8fff : PCI Bus 0000:04
  8000-80ff : 0000:04:00.0
    8000-80ff : sky2
9000-9fff : PCI Bus 0000:05
  9000-903f : 0000:05:00.0
  9400-9403 : 0000:05:00.0
a000-a01f : 0000:00:1a.1
  a000-a01f : uhci_hcd
a400-a41f : 0000:00:1d.0
  a400-a41f : uhci_hcd
a800-a81f : 0000:00:1d.1
  a800-a81f : uhci_hcd
ac00-ac1f : 0000:00:1d.2
  ac00-ac1f : uhci_hcd
b000-b01f : 0000:00:1a.0
  b000-b01f : uhci_hcd
b400-b407 : 0000:00:1f.2
  b400-b407 : ata_piix
b800-b803 : 0000:00:1f.2
  b800-b803 : ata_piix
bc00-bc07 : 0000:00:1f.2
  bc00-bc07 : ata_piix
c000-c003 : 0000:00:1f.2
  c000-c003 : ata_piix
c400-c40f : 0000:00:1f.2
  c400-c40f : ata_piix
c800-c80f : 0000:00:1f.2
  c800-c80f : ata_piix
d000-d007 : 0000:00:1f.5
  d000-d007 : ata_piix
d400-d403 : 0000:00:1f.5
  d400-d403 : ata_piix
d800-d807 : 0000:00:1f.5
  d800-d807 : ata_piix
dc00-dc03 : 0000:00:1f.5
  dc00-dc03 : ata_piix
e000-e00f : 0000:00:1f.5
  e000-e00f : ata_piix
e400-e40f : 0000:00:1f.5
  e400-e40f : ata_piix

cat /proc/iomem

00000000-00000fff : reserved
00001000-0009f7ff : System RAM
0009f800-0009ffff : reserved
000c0000-000cf5ff : Video ROM
000cf600-000cffff : pnp 00:09
000e0000-000effff : pnp 00:09
000f0000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-dfedffff : System RAM
  01000000-01776385 : Kernel code
  01776386-01d1573f : Kernel data
  01e72000-01fd7fff : Kernel bss
dfee0000-dfee2fff : ACPI Non-volatile Storage
dfee3000-dfeeffff : ACPI Tables
dfef0000-dfefffff : reserved
dff00000-dfffffff : RAM buffer
e0000000-efffffff : PCI Bus 0000:01
  e0000000-efffffff : 0000:01:00.0
    e0000000-e04fffff : vesafb
f0000000-f3ffffff : PCI MMCONFIG 0000 [bus 00-3f]
  f0000000-f3ffffff : reserved
    f0000000-f3ffffff : pnp 00:08
f4000000-f5ffffff : PCI Bus 0000:01
  f4000000-f401ffff : 0000:01:00.0
  f5000000-f500ffff : 0000:01:00.0
  f5010000-f501ffff : 0000:01:00.1
f6000000-f7ffffff : PCI Bus 0000:04
  f7000000-f7003fff : 0000:04:00.0
    f7000000-f7003fff : sky2
f8000000-f80fffff : PCI Bus 0000:03
  f8000000-f8001fff : 0000:03:00.0
    f8000000-f8001fff : ahci
f8100000-f81fffff : PCI Bus 0000:05
  f8100000-f8107fff : 0000:05:00.0
    f8100000-f8107fff : YMFPCI
  f8108000-f81083ff : 0000:05:01.0
    f8108000-f81083ff : saa7134[0]
f8200000-f8203fff : 0000:00:1b.0
  f8200000-f8203fff : ICH HD audio
f8204000-f82043ff : 0000:00:1d.7
  f8204000-f82043ff : ehci_hcd
f8205000-f82053ff : 0000:00:1a.7
  f8205000-f82053ff : ehci_hcd
f8206000-f82060ff : 0000:00:1f.3
f8300000-f84fffff : PCI Bus 0000:02
f8500000-f87fffff : PCI Bus 0000:04
  f8500000-f851ffff : 0000:04:00.0
fec00000-ffffffff : reserved
  fec00000-fec003ff : IOAPIC 0
  fed00000-fed003ff : HPET 0
  fed10000-fed1dfff : pnp 00:09
  fed1f410-fed1f414 : iTCO_wdt
  fed20000-fed8ffff : pnp 00:09
  fee00000-fee00fff : Local APIC
    fee00000-fee00fff : pnp 00:09
  ffb00000-ffb7ffff : pnp 00:09
  fff00000-ffffffff : pnp 00:09
100000000-11fffffff : System RAM
120000000-1201fffff : PCI Bus 0000:02
120200000-1203fffff : PCI Bus 0000:03

[7.5.] PCI information ('lspci -vvv' as root)

00:00.0 Host bridge: Intel Corporation 82P965/G965 Memory Controller
Hub (rev 02)
    Subsystem: Gigabyte Technology Co., Ltd Device 5000
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ >SERR- <PERR- INTx-
    Latency: 0
    Capabilities: [e0] Vendor Specific Information: Len=09 <?>

00:01.0 PCI bridge: Intel Corporation 82P965/G965 PCI Express Root
Port (rev 02) (prog-if 00 [Normal decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 32 bytes
    Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
    I/O behind bridge: 00005000-00005fff
    Memory behind bridge: f4000000-f5ffffff
    Prefetchable memory behind bridge: 00000000e0000000-00000000efffffff
    Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
    BridgeCtl: Parity- SERR- NoISA- VGA+ MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
    Capabilities: [88] Subsystem: Gigabyte Technology Co., Ltd Device 5000
    Capabilities: [80] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
        Address: fee0300c  Data: 4191
    Capabilities: [a0] Express (v1) Root Port (Slot+), MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0
            ExtTag- RBE+
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
        LnkCap:    Port #2, Speed 2.5GT/s, Width x16, ASPM L0s, Exit
Latency L0s <256ns, L1 <64us
            ClockPM- Surprise- LLActRep- BwNot-
        LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- CommClk+
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
        SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
            Slot #32, PowerLimit 75.000W; Interlock- NoCompl+
        SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt-
HPIrq- LinkChg-
            Control: AttnInd Off, PwrInd On, Power- Interlock-
        SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
            Changed: MRL- PresDet+ LinkState-
        RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
        RootCap: CRSVisible-
        RootSta: PME ReqID 0000, PMEStatus- PMEPending-
    Capabilities: [100 v1] Virtual Channel
        Caps:    LPEVC=0 RefClk=100ns PATEntryBits=1
        Arb:    Fixed- WRR32- WRR64- WRR128-
        Ctrl:    ArbSelect=Fixed
        Status:    InProgress-
        VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
            Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
            Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=01
            Status:    NegoPending- InProgress-
    Capabilities: [140 v1] Root Complex Link
        Desc:    PortNumber=02 ComponentID=01 EltType=Config
        Link0:    Desc:    TargetPort=00 TargetComponent=01 AssocRCRB-
LinkType=MemMapped LinkValid+
            Addr:    00000000fed19000
    Kernel driver in use: pcieport

00:1a.0 USB controller: Intel Corporation 82801H (ICH8 Family) USB
UHCI Controller #4 (rev 02) (prog-if 00 [UHCI])
    Subsystem: Gigabyte Technology Co., Ltd Device 5004
    Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin A routed to IRQ 16
    Region 4: I/O ports at b000 [size=32]
    Kernel driver in use: uhci_hcd

00:1a.1 USB controller: Intel Corporation 82801H (ICH8 Family) USB
UHCI Controller #5 (rev 02) (prog-if 00 [UHCI])
    Subsystem: Gigabyte Technology Co., Ltd Device 5004
    Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin B routed to IRQ 21
    Region 4: I/O ports at a000 [size=32]
    Kernel driver in use: uhci_hcd

00:1a.7 USB controller: Intel Corporation 82801H (ICH8 Family) USB2
EHCI Controller #2 (rev 02) (prog-if 20 [EHCI])
    Subsystem: Gigabyte Technology Co., Ltd Device 5006
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin C routed to IRQ 18
    Region 0: Memory at f8205000 (32-bit, non-prefetchable) [size=1K]
    Capabilities: [50] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Kernel driver in use: ehci-pci

00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio
Controller (rev 02)
    Subsystem: Gigabyte Technology Co., Ltd Device a002
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 32 bytes
    Interrupt: pin A routed to IRQ 45
    Region 0: Memory at f8200000 (64-bit, non-prefetchable) [size=16K]
    Capabilities: [50] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
        Address: 00000000fee0300c  Data: 4122
    Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0
            ExtTag- RBE-
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
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
            Ctrl:    Enable+ ID=1 ArbSelect=Fixed TC/VC=80
            Status:    NegoPending- InProgress-
    Capabilities: [130 v1] Root Complex Link
        Desc:    PortNumber=0f ComponentID=02 EltType=Config
        Link0:    Desc:    TargetPort=00 TargetComponent=02 AssocRCRB-
LinkType=MemMapped LinkValid+
            Addr:    00000000fed1c000
    Kernel driver in use: snd_hda_intel

00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express
Port 1 (rev 02) (prog-if 00 [Normal decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 32 bytes
    Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
    I/O behind bridge: 00004000-00004fff
    Memory behind bridge: f8300000-f84fffff
    Prefetchable memory behind bridge: 0000000120000000-00000001201fffff
    Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
    BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
    Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0
            ExtTag- RBE+
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
        LnkCap:    Port #1, Speed 2.5GT/s, Width x1, ASPM L0s, Exit
Latency L0s <1us, L1 <4us
            ClockPM- Surprise- LLActRep+ BwNot-
        LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- CommClk-
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
        SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
            Slot #16, PowerLimit 10.000W; Interlock- NoCompl-
        SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt-
HPIrq- LinkChg-
            Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
        SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
            Changed: MRL- PresDet- LinkState-
        RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
        RootCap: CRSVisible-
        RootSta: PME ReqID 0000, PMEStatus- PMEPending-
    Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
        Address: fee0300c  Data: 41a1
    Capabilities: [90] Subsystem: Gigabyte Technology Co., Ltd Device 5001
    Capabilities: [a0] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [100 v1] Virtual Channel
        Caps:    LPEVC=0 RefClk=100ns PATEntryBits=1
        Arb:    Fixed+ WRR32- WRR64- WRR128-
        Ctrl:    ArbSelect=Fixed
        Status:    InProgress-
        VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
            Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
            Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=01
            Status:    NegoPending- InProgress-
    Capabilities: [180 v1] Root Complex Link
        Desc:    PortNumber=01 ComponentID=02 EltType=Config
        Link0:    Desc:    TargetPort=00 TargetComponent=02 AssocRCRB-
LinkType=MemMapped LinkValid+
            Addr:    00000000fed1c001
    Kernel driver in use: pcieport

00:1c.3 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express
Port 4 (rev 02) (prog-if 00 [Normal decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 32 bytes
    Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
    I/O behind bridge: 00006000-00007fff
    Memory behind bridge: f8000000-f80fffff
    Prefetchable memory behind bridge: 0000000120200000-00000001203fffff
    Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
    BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
    Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0
            ExtTag- RBE+
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
        LnkCap:    Port #4, Speed 2.5GT/s, Width x1, ASPM L0s, Exit
Latency L0s <256ns, L1 <4us
            ClockPM- Surprise- LLActRep+ BwNot-
        LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- CommClk+
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive+ BWMgmt- ABWMgmt-
        SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
            Slot #19, PowerLimit 10.000W; Interlock- NoCompl-
        SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt-
HPIrq- LinkChg-
            Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
        SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
            Changed: MRL- PresDet+ LinkState+
        RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
        RootCap: CRSVisible-
        RootSta: PME ReqID 0000, PMEStatus- PMEPending-
    Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
        Address: fee0300c  Data: 41b1
    Capabilities: [90] Subsystem: Gigabyte Technology Co., Ltd Device 5001
    Capabilities: [a0] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [100 v1] Virtual Channel
        Caps:    LPEVC=0 RefClk=100ns PATEntryBits=1
        Arb:    Fixed+ WRR32- WRR64- WRR128-
        Ctrl:    ArbSelect=Fixed
        Status:    InProgress-
        VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
            Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
            Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=01
            Status:    NegoPending- InProgress-
    Capabilities: [180 v1] Root Complex Link
        Desc:    PortNumber=04 ComponentID=02 EltType=Config
        Link0:    Desc:    TargetPort=00 TargetComponent=02 AssocRCRB-
LinkType=MemMapped LinkValid+
            Addr:    00000000fed1c001
    Kernel driver in use: pcieport

00:1c.4 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express
Port 5 (rev 02) (prog-if 00 [Normal decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 32 bytes
    Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
    I/O behind bridge: 00008000-00008fff
    Memory behind bridge: f6000000-f7ffffff
    Prefetchable memory behind bridge: 00000000f8500000-00000000f87fffff
    Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
    BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
    Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0
            ExtTag- RBE+
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
        LnkCap:    Port #5, Speed 2.5GT/s, Width x1, ASPM L0s, Exit
Latency L0s <256ns, L1 <4us
            ClockPM- Surprise- LLActRep+ BwNot-
        LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- CommClk+
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive+ BWMgmt- ABWMgmt-
        SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
            Slot #20, PowerLimit 10.000W; Interlock- NoCompl-
        SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt-
HPIrq- LinkChg-
            Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
        SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
            Changed: MRL- PresDet+ LinkState+
        RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
        RootCap: CRSVisible-
        RootSta: PME ReqID 0000, PMEStatus- PMEPending-
    Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
        Address: fee0300c  Data: 41c1
    Capabilities: [90] Subsystem: Gigabyte Technology Co., Ltd Device 5001
    Capabilities: [a0] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [100 v1] Virtual Channel
        Caps:    LPEVC=0 RefClk=100ns PATEntryBits=1
        Arb:    Fixed+ WRR32- WRR64- WRR128-
        Ctrl:    ArbSelect=Fixed
        Status:    InProgress-
        VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
            Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
            Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=01
            Status:    NegoPending- InProgress-
    Capabilities: [180 v1] Root Complex Link
        Desc:    PortNumber=05 ComponentID=02 EltType=Config
        Link0:    Desc:    TargetPort=00 TargetComponent=02 AssocRCRB-
LinkType=MemMapped LinkValid+
            Addr:    00000000fed1c001
    Kernel driver in use: pcieport

00:1d.0 USB controller: Intel Corporation 82801H (ICH8 Family) USB
UHCI Controller #1 (rev 02) (prog-if 00 [UHCI])
    Subsystem: Gigabyte Technology Co., Ltd Device 5004
    Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin A routed to IRQ 23
    Region 4: I/O ports at a400 [size=32]
    Kernel driver in use: uhci_hcd

00:1d.1 USB controller: Intel Corporation 82801H (ICH8 Family) USB
UHCI Controller #2 (rev 02) (prog-if 00 [UHCI])
    Subsystem: Gigabyte Technology Co., Ltd Device 5004
    Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin B routed to IRQ 19
    Region 4: I/O ports at a800 [size=32]
    Kernel driver in use: uhci_hcd

00:1d.2 USB controller: Intel Corporation 82801H (ICH8 Family) USB
UHCI Controller #3 (rev 02) (prog-if 00 [UHCI])
    Subsystem: Gigabyte Technology Co., Ltd Device 5004
    Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin C routed to IRQ 18
    Region 4: I/O ports at ac00 [size=32]
    Kernel driver in use: uhci_hcd

00:1d.7 USB controller: Intel Corporation 82801H (ICH8 Family) USB2
EHCI Controller #1 (rev 02) (prog-if 20 [EHCI])
    Subsystem: Gigabyte Technology Co., Ltd Device 5006
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin A routed to IRQ 23
    Region 0: Memory at f8204000 (32-bit, non-prefetchable) [size=1K]
    Capabilities: [50] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Kernel driver in use: ehci-pci

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev f2)
(prog-if 01 [Subtractive decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Bus: primary=00, secondary=05, subordinate=05, sec-latency=32
    I/O behind bridge: 00009000-00009fff
    Memory behind bridge: f8100000-f81fffff
    Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
    Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
    BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
    Capabilities: [50] Subsystem: Gigabyte Technology Co., Ltd Motherboard

00:1f.0 ISA bridge: Intel Corporation 82801HB/HR (ICH8/R) LPC
Interface Controller (rev 02)
    Subsystem: Gigabyte Technology Co., Ltd Device 5001
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Capabilities: [e0] Vendor Specific Information: Len=0c <?>
    Kernel driver in use: lpc_ich

00:1f.2 IDE interface: Intel Corporation 82801H (ICH8 Family) 4 port
SATA Controller [IDE mode] (rev 02) (prog-if 8f [Master SecP SecO PriP
PriO])
    Subsystem: Gigabyte Technology Co., Ltd Device b002
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin B routed to IRQ 19
    Region 0: I/O ports at b400 [size=8]
    Region 1: I/O ports at b800 [size=4]
    Region 2: I/O ports at bc00 [size=8]
    Region 3: I/O ports at c000 [size=4]
    Region 4: I/O ports at c400 [size=16]
    Region 5: I/O ports at c800 [size=16]
    Capabilities: [70] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot+,D3cold-)
        Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
    Kernel driver in use: ata_piix

00:1f.3 SMBus: Intel Corporation 82801H (ICH8 Family) SMBus Controller (rev 02)
    Subsystem: Gigabyte Technology Co., Ltd Device 5001
    Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Interrupt: pin C routed to IRQ 9
    Region 0: Memory at f8206000 (32-bit, non-prefetchable) [size=256]
    Region 4: I/O ports at 0500 [size=32]

00:1f.5 IDE interface: Intel Corporation 82801HR/HO/HH (ICH8R/DO/DH) 2
port SATA Controller [IDE mode] (rev 02) (prog-if 85 [Master SecO
PriO])
    Subsystem: Gigabyte Technology Co., Ltd Device b002
    Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin B routed to IRQ 19
    Region 0: I/O ports at d000 [size=8]
    Region 1: I/O ports at d400 [size=4]
    Region 2: I/O ports at d800 [size=8]
    Region 3: I/O ports at dc00 [size=4]
    Region 4: I/O ports at e000 [size=16]
    Region 5: I/O ports at e400 [size=16]
    Capabilities: [70] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot+,D3cold-)
        Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
    Kernel driver in use: ata_piix

01:00.0 VGA compatible controller: Advanced Micro Devices, Inc.
[AMD/ATI] RV570 [Radeon X1950 PRO] (prog-if 00 [VGA controller])
    Subsystem: Tul Corporation / PowerColor Device 2204
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 32 bytes
    Interrupt: pin A routed to IRQ 16
    Region 0: Memory at e0000000 (64-bit, prefetchable) [size=256M]
    Region 2: Memory at f5000000 (64-bit, non-prefetchable) [size=64K]
    Region 4: I/O ports at 5000 [size=256]
    [virtual] Expansion ROM at f4000000 [disabled] [size=128K]
    Capabilities: [50] Power Management version 2
        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [58] Express (v1) Endpoint, MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<4us, L1 unlimited
            ExtTag+ AttnBtn- AttnInd- PwrInd- RBE- FLReset-
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
        LnkCap:    Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1,
Exit Latency L0s <64ns, L1 <1us
            ClockPM- Surprise- LLActRep- BwNot-
        LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- CommClk+
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
    Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit+
        Address: 0000000000000000  Data: 0000

01:00.1 Display controller: Advanced Micro Devices, Inc. [AMD/ATI]
RV570 [Radeon X1950 PRO] (Secondary)
    Subsystem: Tul Corporation / PowerColor Device 2205
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 32 bytes
    Region 0: Memory at f5010000 (64-bit, non-prefetchable) [size=64K]
    Capabilities: [50] Power Management version 2
        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [58] Express (v1) Endpoint, MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<4us, L1 unlimited
            ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
        LnkCap:    Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1,
Exit Latency L0s <64ns, L1 <1us
            ClockPM- Surprise- LLActRep- BwNot-
        LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- CommClk-
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-

03:00.0 SATA controller: JMicron Technology Corp. JMB363 SATA/IDE
Controller (rev 02) (prog-if 01 [AHCI 1.0])
    Subsystem: Gigabyte Technology Co., Ltd Motherboard
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 32 bytes
    Interrupt: pin A routed to IRQ 19
    Region 5: Memory at f8000000 (32-bit, non-prefetchable) [size=8K]
    Capabilities: [68] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot+,D3cold-)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [50] Express (v1) Legacy Endpoint, MSI 01
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
            ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 512 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
        LnkCap:    Port #1, Speed 2.5GT/s, Width x1, ASPM L0s, Exit
Latency L0s unlimited, L1 unlimited
            ClockPM- Surprise- LLActRep- BwNot-
        LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- CommClk-
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
    Kernel driver in use: ahci

03:00.1 IDE interface: JMicron Technology Corp. JMB363 SATA/IDE
Controller (rev 02) (prog-if 85 [Master SecO PriO])
    Subsystem: Gigabyte Technology Co., Ltd Motherboard
    Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin B routed to IRQ 16
    Region 0: I/O ports at 6000 [size=8]
    Region 1: I/O ports at 6400 [size=4]
    Region 2: I/O ports at 6800 [size=8]
    Region 3: I/O ports at 6c00 [size=4]
    Region 4: I/O ports at 7000 [size=16]
    Capabilities: [68] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Kernel driver in use: pata_jmicron

04:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8053
PCI-E Gigabit Ethernet Controller (rev 22)
    Subsystem: Gigabyte Technology Co., Ltd Marvell 88E8053 Gigabit
Ethernet Controller (Gigabyte)
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 32 bytes
    Interrupt: pin A routed to IRQ 44
    Region 0: Memory at f7000000 (64-bit, non-prefetchable) [size=16K]
    Region 2: I/O ports at 8000 [size=256]
    [virtual] Expansion ROM at f8500000 [disabled] [size=128K]
    Capabilities: [48] Power Management version 2
        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-
    Capabilities: [50] Vital Product Data
        Product Name: Marvell Yukon 88E8053 Gigabit Ethernet Controller
        Read-only fields:
            [PN] Part number: Yukon 88E8053
            [EC] Engineering changes: Rev. 2.2
            [MN] Manufacture ID: 4d 61 72 76 65 6c 6c
            [SN] Serial number: AbCdEfG86EB2A
            [CP] Extended capability: 01 10 cc 03
            [RV] Reserved: checksum good, 9 byte(s) reserved
        Read/write fields:
            [RW] Read-write area: 121 byte(s) free
        End
    Capabilities: [5c] MSI: Enable+ Count=1/2 Maskable- 64bit+
        Address: 00000000fee0100c  Data: 41d1
    Capabilities: [e0] Express (v1) Legacy Endpoint, MSI 00
        DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s
unlimited, L1 unlimited
            ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 512 bytes
        DevSta:    CorrErr+ UncorrErr+ FatalErr- UnsuppReq+ AuxPwr+ TransPend-
        LnkCap:    Port #0, Speed 2.5GT/s, Width x1, ASPM L0s, Exit
Latency L0s <256ns, L1 unlimited
            ClockPM- Surprise- LLActRep- BwNot-
        LnkCtl:    ASPM Disabled; RCB 128 bytes Disabled- CommClk-
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
    Capabilities: [100 v1] Advanced Error Reporting
        UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
        UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
        UESvrt:    DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt-
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
        CESta:    RxErr+ BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
        CEMsk:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
        AERCap:    First Error Pointer: 1f, GenCap- CGenEn- ChkCap- ChkEn-
    Kernel driver in use: sky2

05:00.0 Multimedia audio controller: Yamaha Corporation YMF-744B
[DS-1S Audio Controller] (rev 02)
    Subsystem: Yamaha Corporation DS-XG PCI Audio CODEC
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 32 (1250ns min, 6250ns max)
    Interrupt: pin A routed to IRQ 20
    Region 0: Memory at f8100000 (32-bit, non-prefetchable) [size=32K]
    Region 1: I/O ports at 9000 [size=64]
    Region 2: I/O ports at 9400 [size=4]
    Capabilities: [50] Power Management version 1
        Flags: PMEClk- DSI- D1- D2+ AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Kernel driver in use: snd_ymfpci

05:01.0 Multimedia controller: Philips Semiconductors
SAA7134/SAA7135HL Video Broadcast Decoder (rev 01)
    Subsystem: Pinnacle Systems Inc. PCTV Stereo
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 32 (62000ns min, 62000ns max)
    Interrupt: pin A routed to IRQ 19
    Region 0: Memory at f8108000 (32-bit, non-prefetchable) [size=1K]
    Capabilities: [40] Power Management version 1
        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-
    Kernel driver in use: saa7134

[7.6.] SCSI information (from /proc/scsi/scsi)

Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: ST3250620AS      Rev: 3.AA
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi2 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: ST3250620AS      Rev: 3.AA
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi4 Channel: 00 Id: 00 Lun: 00
  Vendor: LG       Model: DVD-ROM DRD8120B Rev: 1.03
  Type:   CD-ROM                           ANSI  SCSI revision: 05

[7.7.] No other relevant information in /proc

[X.] Other notes, patches, fixes, workarounds:

Launchpad bug report:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1298802

After some testing with 3.14-rc8:
* associating to the cellphone accesspoint does not always work
  and the syslog shows several attempts until it works
* if the association to the cellphone succeeded, it sometimes
  disconnects with traffic
* packet loss and ping times are bad (see below results for
  pinging my personal homepage (hosted in switzerland) via my
  cellphone accesspoint)

pinging from my laptop (centrino ultimate-n 6300 wifi card) via
my cellphone access point:

--- www.peterschueller.com ping statistics ---
28 packets transmitted, 28 received, 0% packet loss, time 27045ms
rtt min/avg/max/mdev = 157.014/496.532/2018.405/510.937 ms, pipe 3

pinging from the computer with the 3.14-rc8 kernel and the
WN8200ND hardware via my cellphone access point:

--- www.peterschueller.com ping statistics ---
29 packets transmitted, 21 received, 27% packet loss, time 28101ms
rtt min/avg/max/mdev = 367.968/867.568/4077.452/835.474 ms, pipe 5

So the average roundtrip is better with the 8192cu but the
deviation is greater and the packet loss is 27% compared to 0%.

Syslog contains garbage for the SSID in the rtw_wx_set_essid
ioctl upon disconnect (connect contains the intended SSID).

Connection:

Mar 31 18:54:04 oldie wpa_supplicant[3194]: wlan0: Trying to associate
with b0:c4:e7:2a:01:d9 (SSID='AndroidAP5397' freq=2437 MHz)
Mar 31 18:54:04 oldie kernel: [ 6244.818289] wpa_set_auth_algs,
AUTH_ALG_OPEN_SYSTEM
Mar 31 18:54:04 oldie kernel: [ 6244.818300] _rtw_pwr_wakeup call ips_leave....
Mar 31 18:54:04 oldie kernel: [ 6244.818302] ==>ips_leave cnts:63
Mar 31 18:54:04 oldie kernel: [ 6244.818304] ===>  rtw_ips_pwr_up..............
Mar 31 18:54:04 oldie kernel: [ 6244.818309] ===> ips_netdrv_open.........
Mar 31 18:54:04 oldie kernel: [ 6244.823782]  ===>
FirmwareDownload91C() fw:Rtl819XFwImageArray_TSMC
Mar 31 18:54:04 oldie kernel: [ 6244.823789] FirmwareDownload92C
accquire FW from embedded image
Mar 31 18:54:04 oldie kernel: [ 6244.823792] fw_ver=v88, fw_subver=2, sig=0x88c0
Mar 31 18:54:04 oldie kernel: [ 6244.856779] fw download ok!
Mar 31 18:54:04 oldie kernel: [ 6244.856785] Set RF Chip ID to RF_6052
and RF type to 2.
Mar 31 18:54:05 oldie kernel: [ 6245.245033] IQK:Start!!!
Mar 31 18:54:05 oldie kernel: [ 6245.259657] Path A IQK failed!!
Mar 31 18:54:05 oldie kernel: [ 6245.265162] Path B IQK Success!!
Mar 31 18:54:05 oldie kernel: [ 6245.287414] Path A IQK Success!!
Mar 31 18:54:05 oldie kernel: [ 6245.292293] Path B IQK Success!!
Mar 31 18:54:05 oldie kernel: [ 6245.310412] Path A IQK Success!!
Mar 31 18:54:05 oldie kernel: [ 6245.315163] Path B IQK Success!!
Mar 31 18:54:05 oldie kernel: [ 6245.319916] IQK: final_candidate is 3
Mar 31 18:54:05 oldie kernel: [ 6245.319922] IQK: RegE94=0 RegE9C=0
RegEA4=0 RegEAC=0 RegEB4=101 RegEBC=f RegEC4=fd RegECC=3fe
Mar 31 18:54:05 oldie kernel: [ 6245.319922]  Path B IQ Calibration Success !
Mar 31 18:54:05 oldie kernel: [ 6245.431793] pdmpriv->TxPowerTrackControl = 1
Mar 31 18:54:05 oldie kernel: [ 6245.436415] rtl8192cu_hal_init in 620ms
Mar 31 18:54:05 oldie wpa_supplicant[3194]: wlan0: Association request
to the driver failed
Mar 31 18:54:05 oldie NetworkManager[912]: <info> (wlan0): supplicant
interface state: disconnected -> associating
Mar 31 18:54:05 oldie kernel: [ 6245.449679] <===
rtw_ips_pwr_up.............. in 632ms
Mar 31 18:54:05 oldie kernel: [ 6245.449790] ==>
ips_leave.....LED(0x00028080)...
Mar 31 18:54:05 oldie kernel: [ 6245.449793] set_mode = IW_MODE_INFRA
Mar 31 18:54:05 oldie kernel: [ 6245.449825]
Mar 31 18:54:05 oldie kernel: [ 6245.449825]  wpa_ie(length:22):
Mar 31 18:54:05 oldie kernel: [ 6245.449829] 0x30 0x14 0x01 0x00 0x00
0x0f 0xac 0x04
Mar 31 18:54:05 oldie kernel: [ 6245.449832] 0x01 0x00 0x00 0x0f 0xac
0x04 0x01 0x00
Mar 31 18:54:05 oldie kernel: [ 6245.449834] 0x00 0x0f 0xac 0x02 0x00
0x00 0x00 0x00
Mar 31 18:54:05 oldie kernel: [ 6245.450167] SetHwReg8192CU, 5130, RCR= 700060ca
Mar 31 18:54:05 oldie kernel: [ 6245.450192] =>rtw_wx_set_essid
Mar 31 18:54:05 oldie kernel: [ 6245.450194] ssid=AndroidAP5397, len=13
Mar 31 18:54:05 oldie kernel: [ 6245.450199] Set SSID under fw_state=0x00000008
Mar 31 18:54:05 oldie kernel: [ 6245.450204]
[by_bssid:0][assoc_ssid:AndroidAP5397][to_roaming:0] new candidate:
AndroidAP5397(b0:c4:e7:2a:01:d9, ch6) rssi:-27
Mar 31 18:54:05 oldie kernel: [ 6245.450210]
rtw_select_and_join_from_scanned_queue: candidate:
AndroidAP5397(b0:c4:e7:2a:01:d9, ch:6)
Mar 31 18:54:05 oldie kernel: [ 6245.450217] link to Broadcom AP
Mar 31 18:54:05 oldie kernel: [ 6245.450220] <=rtw_wx_set_essid, ret 0
Mar 31 18:54:05 oldie kernel: [ 6245.450227] Set BSSID under fw_state=0x00000088
Mar 31 18:54:05 oldie kernel: [ 6245.452039] hw_var_set_opmode()-4234 mode = 2
Mar 31 18:54:05 oldie kernel: [ 6245.452504] start_join_set_ch_bw:
ch=6, bwmode=0, ch_offset=0
Mar 31 18:54:05 oldie kernel: [ 6245.502612] link to Broadcom AP
Mar 31 18:54:05 oldie kernel: [ 6245.527699] OnAuthClient

...

Disconnect (note the line at [ 6301.875861])

Mar 31 18:54:16 oldie kernel: [ 6256.472603] rtw_set_ps_mode(): Enter
802.11 power save mode...
Mar 31 18:54:16 oldie kernel: [ 6256.472612]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Mar 31 18:54:25 oldie NetworkManager[912]: <info> (wlan0): IP6
addrconf timed out or failed.
Mar 31 18:54:25 oldie NetworkManager[912]: <info> Activation (wlan0)
Stage 4 of 5 (IPv6 Configure Timeout) scheduled...
Mar 31 18:54:25 oldie NetworkManager[912]: <info> Activation (wlan0)
Stage 4 of 5 (IPv6 Configure Timeout) started...
Mar 31 18:54:25 oldie NetworkManager[912]: <info> Activation (wlan0)
Stage 4 of 5 (IPv6 Configure Timeout) complete.
Mar 31 18:54:48 oldie kernel: [ 6288.300076] rtw_set_ps_mode(): Busy
Traffic , Leave 802.11 power save..
Mar 31 18:54:48 oldie kernel: [ 6288.300190]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Mar 31 18:54:50 oldie kernel: [ 6290.540617] rtw_set_ps_mode(): Enter
802.11 power save mode...
Mar 31 18:54:50 oldie kernel: [ 6290.540626]
rtl8192c_set_FwPwrMode_cmd(): Mode = 1, SmartPS = 2
Mar 31 18:55:01 oldie NetworkManager[912]: <info> (wlan0): device
state change: activated -> unavailable (reason 'none') [100 20 0]
Mar 31 18:55:01 oldie NetworkManager[912]: <info> (wlan0):
deactivating device (reason 'none') [0]
Mar 31 18:55:01 oldie NetworkManager[912]: <info> (wlan0): canceled
DHCP transaction, DHCP client pid 16099
Mar 31 18:55:01 oldie avahi-daemon[729]: Withdrawing address record
for 192.168.43.8 on wlan0.
Mar 31 18:55:01 oldie avahi-daemon[729]: Leaving mDNS multicast group
on interface wlan0.IPv4 with address 192.168.43.8.
Mar 31 18:55:01 oldie NetworkManager[912]: <info> Policy set 'Wired
connection 1' (eth0) as default for IPv4 routing and DNS.
Mar 31 18:55:01 oldie avahi-daemon[729]: Interface wlan0.IPv4 no
longer relevant for mDNS.
Mar 31 18:55:01 oldie kernel: [ 6301.875755] rtw_wx_set_mlme
Mar 31 18:55:01 oldie kernel: [ 6301.875763] rtw_wx_set_mlme, cmd=0, reason=3
Mar 31 18:55:01 oldie kernel: [ 6301.875858] =>rtw_wx_set_essid
Mar 31 18:55:01 oldie kernel: [ 6301.875861]
ssid=pé>¡Aáüg> ~—êÜk– 8\*ì°;û2¯<Tì Û\, len=32
Mar 31 18:55:01 oldie kernel: [ 6301.875865] Set SSID under fw_state=0x00000008
Mar 31 18:55:01 oldie kernel: [ 6301.875869]
rtw_select_and_join_from_scanned_queue: return _FAIL(candidate ==
NULL)
Mar 31 18:55:01 oldie kernel: [ 6301.875876] <=rtw_wx_set_essid, ret 0
Mar 31 18:55:01 oldie wpa_supplicant[3194]: wlan0:
CTRL-EVENT-DISCONNECTED bssid=b0:c4:e7:2a:01:d9 reason=3
locally_generated=1
Mar 31 18:55:01 oldie NetworkManager[912]: <info> Writing DNS
information to /sbin/resolvconf
Mar 31 18:55:01 oldie dnsmasq[2147]: setting upstream servers from DBus
Mar 31 18:55:01 oldie dnsmasq[2147]: using nameserver 10.42.0.1#53
Mar 31 18:55:01 oldie kernel: [ 6301.914803] HW_VAR_BASIC_RATE: BrateCfg(0x15d)
Mar 31 18:55:01 oldie NetworkManager[912]: <info> (wlan0): taking down device.
Mar 31 18:55:01 oldie kernel: [ 6301.920728] (2)871x_drv - drv_close,
bup=1, hw_init_completed=1
Mar 31 18:55:01 oldie kernel: [ 6301.930317] rtw_set_ps_mode(): Busy
Traffic , Leave 802.11 power save..
Mar 31 18:55:01 oldie kernel: [ 6301.930432]
rtl8192c_set_FwPwrMode_cmd(): Mode = 0, SmartPS = 0
Mar 31 18:55:01 oldie kernel: [ 6301.933559] HW_VAR_BASIC_RATE: BrateCfg(0x15d)
Mar 31 18:55:01 oldie kernel: [ 6301.939566] HW_VAR_BASIC_RATE: BrateCfg(0x15d)
Mar 31 18:55:01 oldie kernel: [ 6301.940206] -871x_drv - drv_close, bup=1
Mar 31 18:55:01 oldie NetworkManager[912]: <info> WiFi hardware radio
set disabled
Mar 31 18:55:01 oldie avahi-daemon[729]: Interface wlan0.IPv6 no
longer relevant for mDNS.
