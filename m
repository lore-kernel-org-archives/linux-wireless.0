Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:56953 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab3GXNKI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Jul 2013 09:10:08 -0400
Received: by mail-we0-f180.google.com with SMTP id p59so4408097wes.39
        for <linux-wireless@vger.kernel.org>; Wed, 24 Jul 2013 06:10:05 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 24 Jul 2013 15:10:04 +0200
Message-ID: <CAEZsi7GVZuBXhn-K+O0sjA_fZXjOQwOmVPuYWDS0ofX65cSvoA@mail.gmail.com> (sfid-20130724_151014_903431_4BDBF5B5)
Subject: Nexus 4 causes system hang (xhci_hcd)
From: Vincent Thiele <vincentthiele@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: 1203453@bugs.launchpad.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nexus 4 causes system hang (xhci_hcd):

When I connect my Nexus 4 to the USB-Port (Front USB 3.0) the whole
system hangs. Sometimes it starts working again after a short time.
But often I need to press the reset button.
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1203453

Keywords: kernel, usb

Kernel version (from /proc/version):
Linux version 3.11.0-031100rc2-generic (apw@gomeisa) (gcc version
4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5) ) #201307211535 SMP Sun Jul 21
19:36:42 UTC 2013

Output of Oops.. message:
Oops: 0002 [#1] SMP

Environment:
Description: Ubuntu 13.04
Release: 13.04

Software:
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux Arbeits-PC 3.11.0-031100rc2-generic #201307211535 SMP Sun Jul 21
19:36:42 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux

Gnu C                  4.7
Gnu make               3.81
binutils               2.23.2
util-linux             2.20.1
mount                  support
module-init-tools      9
e2fsprogs              1.42.5
pcmciautils            018
PPP                    2.4.5
Linux C Library        2.17
Dynamic linker (ldd)   2.17
Procps                 3.3.3
Net-tools              1.60
Kbd                    1.15.5
Sh-utils               8.20
wireless-tools         30
Modules Loaded         pci_stub vboxpci vboxnetadp vboxnetflt vboxdrv
snd_hda_codec_hdmi hid_generic usbhid hid rfcomm bnep parport_pc
bluetooth ppdev joydev snd_hda_codec_realtek xpad ff_memless
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_page_alloc
nls_iso8859_1 snd_seq_midi eeepc_wmi asus_wmi sparse_keymap
snd_seq_midi_event snd_rawmidi snd_seq snd_seq_device nouveau psmouse
snd_timer serio_raw snd mxm_wmi ttm drm_kms_helper drm lpc_ich
i2c_algo_bit wmi video mac_hid soundcore mei_me mei lp parport
usb_storage ahci libahci e1000e ptp pps_core

Processor information (from /proc/cpuinfo):
processor : 0
vendor_id : GenuineIntel
cpu family : 6
model : 42
model name : Intel(R) Core(TM) i5-2300 CPU @ 2.80GHz
stepping : 7
microcode : 0x28
cpu MHz : 2884.000
cache size : 6144 KB
physical id : 0
siblings : 4
core id : 0
cpu cores : 4
apicid : 0
initial apicid : 0
fpu : yes
fpu_exception : yes
cpuid level : 13
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl
vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 popcnt
tsc_deadline_timer aes xsave avx lahf_lm ida arat epb xsaveopt pln pts
dtherm tpr_shadow vnmi flexpriority ept vpid
bogomips : 5618.39
clflush size : 64
cache_alignment : 64
address sizes : 36 bits physical, 48 bits virtual
power management:

processor : 1
vendor_id : GenuineIntel
cpu family : 6
model : 42
model name : Intel(R) Core(TM) i5-2300 CPU @ 2.80GHz
stepping : 7
microcode : 0x28
cpu MHz : 2660.000
cache size : 6144 KB
physical id : 0
siblings : 4
core id : 1
cpu cores : 4
apicid : 2
initial apicid : 2
fpu : yes
fpu_exception : yes
cpuid level : 13
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl
vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 popcnt
tsc_deadline_timer aes xsave avx lahf_lm ida arat epb xsaveopt pln pts
dtherm tpr_shadow vnmi flexpriority ept vpid
bogomips : 5618.39
clflush size : 64
cache_alignment : 64
address sizes : 36 bits physical, 48 bits virtual
power management:

processor : 2
vendor_id : GenuineIntel
cpu family : 6
model : 42
model name : Intel(R) Core(TM) i5-2300 CPU @ 2.80GHz
stepping : 7
microcode : 0x28
cpu MHz : 2912.000
cache size : 6144 KB
physical id : 0
siblings : 4
core id : 2
cpu cores : 4
apicid : 4
initial apicid : 4
fpu : yes
fpu_exception : yes
cpuid level : 13
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl
vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 popcnt
tsc_deadline_timer aes xsave avx lahf_lm ida arat epb xsaveopt pln pts
dtherm tpr_shadow vnmi flexpriority ept vpid
bogomips : 5618.39
clflush size : 64
cache_alignment : 64
address sizes : 36 bits physical, 48 bits virtual
power management:

processor : 3
vendor_id : GenuineIntel
cpu family : 6
model : 42
model name : Intel(R) Core(TM) i5-2300 CPU @ 2.80GHz
stepping : 7
microcode : 0x28
cpu MHz : 2800.000
cache size : 6144 KB
physical id : 0
siblings : 4
core id : 3
cpu cores : 4
apicid : 6
initial apicid : 6
fpu : yes
fpu_exception : yes
cpuid level : 13
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl
vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 popcnt
tsc_deadline_timer aes xsave avx lahf_lm ida arat epb xsaveopt pln pts
dtherm tpr_shadow vnmi flexpriority ept vpid
bogomips : 5618.39
clflush size : 64
cache_alignment : 64
address sizes : 36 bits physical, 48 bits virtual
power management:

Module information (from /proc/modules):
pci_stub 12622 1 - Live 0x0000000000000000
vboxpci 23194 0 - Live 0x0000000000000000 (OF)
vboxnetadp 25670 0 - Live 0x0000000000000000 (OF)
vboxnetflt 23479 0 - Live 0x0000000000000000 (OF)
vboxdrv 320372 3 vboxpci,vboxnetadp,vboxnetflt, Live 0x0000000000000000 (OF)
snd_hda_codec_hdmi 41688 1 - Live 0x0000000000000000
hid_generic 12548 0 - Live 0x0000000000000000
usbhid 53329 0 - Live 0x0000000000000000
hid 105557 2 hid_generic,usbhid, Live 0x0000000000000000
rfcomm 74589 0 - Live 0x0000000000000000
bnep 23966 2 - Live 0x0000000000000000
parport_pc 32866 0 - Live 0x0000000000000000
bluetooth 391564 10 rfcomm,bnep, Live 0x0000000000000000
ppdev 17711 0 - Live 0x0000000000000000
joydev 17613 0 - Live 0x0000000000000000
snd_hda_codec_realtek 56259 1 - Live 0x0000000000000000
xpad 18546 0 - Live 0x0000000000000000
ff_memless 13704 1 xpad, Live 0x0000000000000000
snd_hda_intel 48717 5 - Live 0x0000000000000000
snd_hda_codec 194727 3
snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_intel, Live
0x0000000000000000
snd_hwdep 13613 1 snd_hda_codec, Live 0x0000000000000000
snd_pcm 107140 3 snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec, Live
0x0000000000000000
snd_page_alloc 18798 2 snd_hda_intel,snd_pcm, Live 0x0000000000000000
nls_iso8859_1 12713 1 - Live 0x0000000000000000
snd_seq_midi 13324 0 - Live 0x0000000000000000
eeepc_wmi 13151 0 - Live 0x0000000000000000
asus_wmi 24794 1 eeepc_wmi, Live 0x0000000000000000
sparse_keymap 13890 1 asus_wmi, Live 0x0000000000000000
snd_seq_midi_event 14899 1 snd_seq_midi, Live 0x0000000000000000
snd_rawmidi 30416 1 snd_seq_midi, Live 0x0000000000000000
snd_seq 66061 2 snd_seq_midi,snd_seq_midi_event, Live 0x0000000000000000
snd_seq_device 14497 3 snd_seq_midi,snd_rawmidi,snd_seq, Live 0x0000000000000000
nouveau 974829 3 - Live 0x0000000000000000
psmouse 104015 0 - Live 0x0000000000000000
snd_timer 29989 2 snd_pcm,snd_seq, Live 0x0000000000000000
serio_raw 13413 0 - Live 0x0000000000000000
snd 69657 21 snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_seq_midi,snd_rawmidi,snd_seq,snd_seq_device,snd_timer,
Live 0x0000000000000000
mxm_wmi 13021 1 nouveau, Live 0x0000000000000000
ttm 84705 1 nouveau, Live 0x0000000000000000
drm_kms_helper 53178 1 nouveau, Live 0x0000000000000000
drm 298236 5 nouveau,ttm,drm_kms_helper, Live 0x0000000000000000
lpc_ich 21163 0 - Live 0x0000000000000000
i2c_algo_bit 13564 1 nouveau, Live 0x0000000000000000
wmi 19256 3 asus_wmi,nouveau,mxm_wmi, Live 0x0000000000000000
video 19685 2 asus_wmi,nouveau, Live 0x0000000000000000
mac_hid 13253 0 - Live 0x0000000000000000
soundcore 12680 1 snd, Live 0x0000000000000000
mei_me 18539 0 - Live 0x0000000000000000
mei 78448 1 mei_me, Live 0x0000000000000000
lp 17799 0 - Live 0x0000000000000000
parport 42466 3 parport_pc,ppdev,lp, Live 0x0000000000000000
usb_storage 66567 4 - Live 0x0000000000000000
ahci 30063 4 - Live 0x0000000000000000
libahci 32088 1 ahci, Live 0x0000000000000000
e1000e 257364 0 - Live 0x0000000000000000
ptp 18627 1 e1000e, Live 0x0000000000000000
pps_core 19027 1 ptp, Live 0x0000000000000000

Loaded driver and hardware information:
cat /proc/ioports
0000-0cf7 : PCI Bus 0000:00
0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-0060 : keyboard
0062-0062 : EC data
0064-0064 : keyboard
0066-0066 : EC cmd
0070-0077 : rtc0
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0200-020f : pnp 00:04
0290-029f : pnp 00:07
0400-0403 : ACPI PM1a_EVT_BLK
0404-0405 : ACPI PM1a_CNT_BLK
0408-040b : ACPI PM_TMR
0410-0415 : ACPI CPU throttle
0420-042f : ACPI GPE0_BLK
0430-0433 : iTCO_wdt
0450-0450 : ACPI PM2_CNT_BLK
0454-0457 : pnp 00:06
0458-047f : pnp 00:04
0460-047f : iTCO_wdt
04d0-04d1 : pnp 00:08
0500-057f : pnp 00:04
0580-059f : 0000:00:1f.3
0680-069f : pnp 00:04
0cf8-0cff : PCI conf1
0d00-ffff : PCI Bus 0000:00
164e-164f : pnp 00:04
2000-2fff : PCI Bus 0000:02
d000-dfff : PCI Bus 0000:05
d000-d00f : 0000:05:00.0
d000-d00f : ahci
d010-d013 : 0000:05:00.0
d010-d013 : ahci
d020-d027 : 0000:05:00.0
d020-d027 : ahci
d030-d033 : 0000:05:00.0
d030-d033 : ahci
d040-d047 : 0000:05:00.0
d040-d047 : ahci
e000-efff : PCI Bus 0000:01
e000-e07f : 0000:01:00.0
f020-f03f : 0000:00:1f.2
f020-f03f : ahci
f040-f05f : 0000:00:19.0
f060-f063 : 0000:00:1f.2
f060-f063 : ahci
f070-f077 : 0000:00:1f.2
f070-f077 : ahci
f080-f083 : 0000:00:1f.2
f080-f083 : ahci
f090-f097 : 0000:00:1f.2
f090-f097 : ahci
ffff-ffff : pnp 00:04
ffff-ffff : pnp 00:04

cat /proc/iomem
00000000-00000fff : reserved
00001000-0009efff : System RAM
0009f000-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
000c0000-000ce7ff : Video ROM
000d4000-000d7fff : PCI Bus 0000:00
000d8000-000dbfff : PCI Bus 0000:00
000dc000-000dffff : PCI Bus 0000:00
000f0000-000fffff : System ROM
00100000-deb8efff : System RAM
0e000000-0e737993 : Kernel code
0e737994-0ed0ec7f : Kernel data
0ee70000-0efe2fff : Kernel bss
deb8f000-df13efff : reserved
df13f000-df383fff : ACPI Non-volatile Storage
df384000-df391fff : ACPI Tables
df392000-df3befff : ACPI Non-volatile Storage
df3bf000-df3c3fff : ACPI Tables
df3c4000-df406fff : ACPI Non-volatile Storage
df407000-df7fffff : System RAM
df800000-dfffffff : RAM buffer
e0000000-feafffff : PCI Bus 0000:00
e0000000-e0000fff : pnp 00:0a
e0100000-e02fffff : PCI Bus 0000:02
e0300000-e04fffff : PCI Bus 0000:02
e0500000-e05fffff : PCI Bus 0000:05
e0500000-e050ffff : 0000:05:00.0
e8000000-f1ffffff : PCI Bus 0000:01
e8000000-efffffff : 0000:01:00.0
f0000000-f1ffffff : 0000:01:00.0
f6000000-f70fffff : PCI Bus 0000:01
f6000000-f6ffffff : 0000:01:00.0
f7000000-f707ffff : 0000:01:00.0
f7080000-f7083fff : 0000:01:00.1
7080000-f7083fff : ICH HD audio
f7100000-f71fffff : PCI Bus 0000:05
f7110000-f71101ff : 0000:05:00.0
f7110000-f71101ff : ahci
f7200000-f72fffff : PCI Bus 0000:04
f7200000-f7207fff : 0000:04:00.0
f7200000-f7207fff : xhci_hcd
f7300000-f73fffff : PCI Bus 0000:03
f7300000-f7307fff : 0000:03:00.0
f7300000-f7307fff : xhci_hcd
f7400000-f741ffff : 0000:00:19.0
f7400000-f741ffff : e1000e
f7420000-f7423fff : 0000:00:1b.0
f7420000-f7423fff : ICH HD audio
f7425000-f74250ff : 0000:00:1f.3
f7426000-f74267ff : 0000:00:1f.2
f7426000-f74267ff : ahci
f7427000-f74273ff : 0000:00:1d.0
f7427000-f74273ff : ehci_hcd
f7428000-f74283ff : 0000:00:1a.0
f7428000-f74283ff : ehci_hcd
f7429000-f7429fff : 0000:00:19.0
f7429000-f7429fff : e1000e
f742c000-f742c00f : 0000:00:16.0
f742c000-f742c00f : mei_me
f8000000-fbffffff : PCI MMCONFIG 0000 [bus 00-3f]
f8000000-fbffffff : reserved
f8000000-fbffffff : pnp 00:0a
fec00000-fec00fff : reserved
fec00000-fec003ff : IOAPIC 0
fed00000-fed03fff : reserved
fed00000-fed003ff : HPET 0
fed10000-fed17fff : pnp 00:0a
fed18000-fed18fff : pnp 00:0a
fed19000-fed19fff : pnp 00:0a
fed1c000-fed1ffff : reserved
fed1c000-fed1ffff : pnp 00:0a
fed1f410-fed1f414 : iTCO_wdt
fed20000-fed3ffff : pnp 00:0a
fed40000-fed44fff : pnp 00:00
fed45000-fed8ffff : pnp 00:0a
fed90000-fed93fff : pnp 00:0a
fee00000-fee00fff : Local APIC
fee00000-fee00fff : reserved
ff000000-ffffffff : reserved
ff000000-ffffffff : pnp 00:0a
100000000-21effffff : System RAM
21f000000-21fffffff : RAM buffer

PCI information ('lspci -vvv' as root):
sudo lspci -vvv
00:00.0 Host bridge: Intel Corporation 2nd Generation Core Processor
Family DRAM Controller (rev 09)
  Subsystem: ASUSTeK Computer Inc. P8P67 Deluxe Motherboard
  Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
  Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ >SERR- <PERR- INTx-
  Latency: 0
  Capabilities: [e0] Vendor Specific Information: Len=0c <?>

00:01.0 PCI bridge: Intel Corporation Xeon E3-1200/2nd Generation Core
Processor Family PCI Express Root Port (rev 09) (prog-if 00 [Normal
decode])
  Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
  Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
  Latency: 0, Cache Line Size: 64 bytes
  Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
  I/O behind bridge: 0000e000-0000efff
  Memory behind bridge: f6000000-f70fffff
  Prefetchable memory behind bridge: 00000000e8000000-00000000f1ffffff
  Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
  BridgeCtl: Parity- SERR- NoISA- VGA+ MAbort- >Reset- FastB2B-
    PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
  Capabilities: [88] Subsystem: ASUSTeK Computer Inc. Device 844d
  Capabilities: [80] Power Management version 3
    Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
    Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
  Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
    Address: fee0f00c  Data: 4181
  Capabilities: [a0] Express (v2) Root Port (Slot+), MSI 00
    DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
      ExtTag- RBE+ FLReset-
    DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
      RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
      MaxPayload 128 bytes, MaxReadReq 128 bytes
    DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
    LnkCap: Port #2, Speed 5GT/s, Width x16, ASPM L0s L1, Latency L0
<256ns, L1 <4us
      ClockPM- Surprise- LLActRep- BwNot+
    LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
      ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
    LnkSta: Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive-
BWMgmt+ ABWMgmt-
    SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
      Slot #1, PowerLimit 75.000W; Interlock- NoCompl+
    SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
      Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
    SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
      Changed: MRL- PresDet- LinkState-
    RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
    RootCap: CRSVisible-
    RootSta: PME ReqID 0000, PMEStatus- PMEPending-
    DevCap2: Completion Timeout: Not Supported, TimeoutDis- ARIFwd-
    DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
    LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -3.5dB
       Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
       Compliance De-emphasis: -6dB
    LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
       EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
  Capabilities: [100 v1] Virtual Channel
    Caps: LPEVC=0 RefClk=100ns PATEntryBits=1
    Arb:  Fixed- WRR32- WRR64- WRR128-
    Ctrl: ArbSelect=Fixed
    Status: InProgress-
    VC0:  Caps: PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
      Arb:  Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
      Ctrl: Enable+ ID=0 ArbSelect=Fixed TC/VC=01
      Status: NegoPending- InProgress-
  Capabilities: [140 v1] Root Complex Link
    Desc: PortNumber=02 ComponentID=01 EltType=Config
    Link0:  Desc: TargetPort=00 TargetComponent=01 AssocRCRB-
LinkType=MemMapped LinkValid+
      Addr: 00000000fed19000
  Kernel driver in use: pcieport

00:16.0 Communication controller: Intel Corporation 6 Series/C200
Series Chipset Family MEI Controller #1 (rev 04)
  Subsystem: ASUSTeK Computer Inc. P8P67 Deluxe Motherboard
  Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
  Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
  Latency: 0
  Interrupt: pin A routed to IRQ 53
  Region 0: Memory at f742c000 (64-bit, non-prefetchable) [size=16]
  Capabilities: [50] Power Management version 3
    Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
    Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
  Capabilities: [8c] MSI: Enable+ Count=1/1 Maskable- 64bit+
    Address: 00000000fee0f00c  Data: 41b2
  Kernel driver in use: mei_me

00:19.0 Ethernet controller: Intel Corporation 82579V Gigabit Network
Connection (rev 05)
  Subsystem: ASUSTeK Computer Inc. P8P67 Deluxe Motherboard
  Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
  Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
  Latency: 0
  Interrupt: pin A routed to IRQ 51
  Region 0: Memory at f7400000 (32-bit, non-prefetchable) [size=128K]
  Region 1: Memory at f7429000 (32-bit, non-prefetchable) [size=4K]
  Region 2: I/O ports at f040 [size=32]
  Capabilities: [c8] Power Management version 2
    Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
    Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-
  Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
    Address: 00000000fee0100c  Data: 4123
  Capabilities: [e0] PCI Advanced Features
    AFCap: TP+ FLR+
    AFCtrl: FLR-
    AFStatus: TP-
  Kernel driver in use: e1000e

00:1a.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset
Family USB Enhanced Host Controller #2 (rev 05) (prog-if 20 [EHCI])
  Subsystem: ASUSTeK Computer Inc. P8P67 Deluxe Motherboard
  Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
  Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
  Latency: 0
  Interrupt: pin A routed to IRQ 16
  Region 0: Memory at f7428000 (32-bit, non-prefetchable) [size=1K]
  Capabilities: [50] Power Management version 2
    Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
    Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
  Capabilities: [58] Debug port: BAR=1 offset=00a0
  Capabilities: [98] PCI Advanced Features
    AFCap: TP+ FLR+
    AFCtrl: FLR-
    AFStatus: TP-
  Kernel driver in use: ehci-pci

00:1b.0 Audio device: Intel Corporation 6 Series/C200 Series Chipset
Family High Definition Audio Controller (rev 05)
  Subsystem: ASUSTeK Computer Inc. Device 84dc
  Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
  Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
  Latency: 0, Cache Line Size: 64 bytes
  Interrupt: pin A routed to IRQ 54
  Region 0: Memory at f7420000 (64-bit, non-prefetchable) [size=16K]
  Capabilities: [50] Power Management version 2
    Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
    Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
  Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
    Address: 00000000fee0f00c  Data: 41d2
  Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
    DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
      ExtTag- RBE- FLReset+
    DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
      RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
      MaxPayload 128 bytes, MaxReadReq 128 bytes
    DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
    LnkCap: Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0
<64ns, L1 <1us
      ClockPM- Surprise- LLActRep- BwNot-
    LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
      ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
    LnkSta: Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
  Capabilities: [100 v1] Virtual Channel
    Caps: LPEVC=0 RefClk=100ns PATEntryBits=1
    Arb:  Fixed- WRR32- WRR64- WRR128-
    Ctrl: ArbSelect=Fixed
    Status: InProgress-
    VC0:  Caps: PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
      Arb:  Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
      Ctrl: Enable+ ID=0 ArbSelect=Fixed TC/VC=01
      Status: NegoPending- InProgress-
    VC1:  Caps: PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
      Arb:  Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
      Ctrl: Enable+ ID=1 ArbSelect=Fixed TC/VC=22
      Status: NegoPending- InProgress-
  Capabilities: [130 v1] Root Complex Link
    Desc: PortNumber=0f ComponentID=00 EltType=Config
    Link0:  Desc: TargetPort=00 TargetComponent=00 AssocRCRB-
LinkType=MemMapped LinkValid+
      Addr: 00000000fed1c000
  Kernel driver in use: snd_hda_intel

00:1c.0 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset
Family PCI Express Root Port 1 (rev b5) (prog-if 00 [Normal decode])
  Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
  Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
  Latency: 0, Cache Line Size: 64 bytes
  Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
  I/O behind bridge: 00002000-00002fff
  Memory behind bridge: e0100000-e02fffff
  Prefetchable memory behind bridge: 00000000e0300000-00000000e04fffff
  Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
  BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
    PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
  Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
    DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
      ExtTag- RBE+ FLReset-
    DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
      RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
      MaxPayload 128 bytes, MaxReadReq 128 bytes
    DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
    LnkCap: Port #1, Speed 5GT/s, Width x4, ASPM L0s L1, Latency L0
<1us, L1 <4us
      ClockPM- Surprise- LLActRep+ BwNot-
    LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
      ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
    LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train+ SlotClk+ DLActive-
BWMgmt- ABWMgmt-
    SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
      Slot #0, PowerLimit 0.000W; Interlock- NoCompl+
    SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
      Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
    SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
      Changed: MRL- PresDet- LinkState-
    RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
    RootCap: CRSVisible-
    RootSta: PME ReqID 0000, PMEStatus- PMEPending-
    DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
    DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
    LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
       Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
       Compliance De-emphasis: -6dB
    LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-
       EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
  Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
    Address: 00000000  Data: 0000
  Capabilities: [90] Subsystem: ASUSTeK Computer Inc. Device 844d
  Capabilities: [a0] Power Management version 2
    Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
    Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
  Kernel driver in use: pcieport

00:1c.4 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset
Family PCI Express Root Port 5 (rev b5) (prog-if 00 [Normal decode])
  Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
  Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
  Latency: 0, Cache Line Size: 64 bytes
  Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
  I/O behind bridge: 0000f000-00000fff
  Memory behind bridge: f7300000-f73fffff
  Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
  Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
  BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
    PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
  Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
    DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
      ExtTag- RBE+ FLReset-
    DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
      RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
      MaxPayload 128 bytes, MaxReadReq 128 bytes
    DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
    LnkCap: Port #5, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0
<512ns, L1 <4us
      ClockPM- Surprise- LLActRep+ BwNot-
    LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
      ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
    LnkSta: Speed 5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+
BWMgmt+ ABWMgmt-
    SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
      Slot #4, PowerLimit 10.000W; Interlock- NoCompl+
    SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
      Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
    SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
      Changed: MRL- PresDet- LinkState-
    RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
    RootCap: CRSVisible-
    RootSta: PME ReqID 0000, PMEStatus- PMEPending-
    DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
    DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
    LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
       Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
       Compliance De-emphasis: -6dB
    LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
       EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
  Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
    Address: 00000000  Data: 0000
  Capabilities: [90] Subsystem: ASUSTeK Computer Inc. Device 844d
  Capabilities: [a0] Power Management version 2
    Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
    Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
  Kernel driver in use: pcieport

00:1c.5 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset
Family PCI Express Root Port 6 (rev b5) (prog-if 00 [Normal decode])
  Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
  Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
  Latency: 0, Cache Line Size: 64 bytes
  Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
  I/O behind bridge: 0000f000-00000fff
  Memory behind bridge: f7200000-f72fffff
  Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
  Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
  BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
    PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
  Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
    DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
      ExtTag- RBE+ FLReset-
    DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
      RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
      MaxPayload 128 bytes, MaxReadReq 128 bytes
    DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
    LnkCap: Port #6, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0
<512ns, L1 <4us
      ClockPM- Surprise- LLActRep+ BwNot-
    LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
      ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
    LnkSta: Speed 5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+
BWMgmt+ ABWMgmt-
    SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
      Slot #5, PowerLimit 10.000W; Interlock- NoCompl+
    SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
      Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
    SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
      Changed: MRL- PresDet- LinkState-
    RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
    RootCap: CRSVisible-
    RootSta: PME ReqID 0000, PMEStatus- PMEPending-
    DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
    DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
    LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
       Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
       Compliance De-emphasis: -6dB
    LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
       EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
  Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
    Address: 00000000  Data: 0000
  Capabilities: [90] Subsystem: ASUSTeK Computer Inc. Device 844d
  Capabilities: [a0] Power Management version 2
    Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
    Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
  Kernel driver in use: pcieport

00:1c.6 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset
Family PCI Express Root Port 7 (rev b5) (prog-if 00 [Normal decode])
  Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
  Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
  Latency: 0, Cache Line Size: 64 bytes
  Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
  I/O behind bridge: 0000d000-0000dfff
  Memory behind bridge: f7100000-f71fffff
  Prefetchable memory behind bridge: 00000000e0500000-00000000e05fffff
  Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
  BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
    PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
  Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
    DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
      ExtTag- RBE+ FLReset-
    DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
      RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
      MaxPayload 128 bytes, MaxReadReq 128 bytes
    DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
    LnkCap: Port #7, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0
<512ns, L1 <4us
      ClockPM- Surprise- LLActRep+ BwNot-
    LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
      ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
    LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+
BWMgmt+ ABWMgmt-
    SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
      Slot #6, PowerLimit 10.000W; Interlock- NoCompl+
    SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
      Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
    SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
      Changed: MRL- PresDet- LinkState-
    RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
    RootCap: CRSVisible-
    RootSta: PME ReqID 0000, PMEStatus- PMEPending-
    DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
    DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
    LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
       Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
       Compliance De-emphasis: -6dB
    LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-
       EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
  Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
    Address: 00000000  Data: 0000
  Capabilities: [90] Subsystem: ASUSTeK Computer Inc. Device 844d
  Capabilities: [a0] Power Management version 2
    Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
    Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
  Kernel driver in use: pcieport

00:1d.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset
Family USB Enhanced Host Controller #1 (rev 05) (prog-if 20 [EHCI])
  Subsystem: ASUSTeK Computer Inc. P8P67 Deluxe Motherboard
  Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
  Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
  Latency: 0
  Interrupt: pin A routed to IRQ 23
  Region 0: Memory at f7427000 (32-bit, non-prefetchable) [size=1K]
  Capabilities: [50] Power Management version 2
    Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
    Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
  Capabilities: [58] Debug port: BAR=1 offset=00a0
  Capabilities: [98] PCI Advanced Features
    AFCap: TP+ FLR+
    AFCtrl: FLR-
    AFStatus: TP-
  Kernel driver in use: ehci-pci

00:1f.0 ISA bridge: Intel Corporation Z68 Express Chipset Family LPC
Controller (rev 05)
  Subsystem: ASUSTeK Computer Inc. Device 844d
  Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
  Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
  Latency: 0
  Capabilities: [e0] Vendor Specific Information: Len=0c <?>
  Kernel driver in use: lpc_ich

00:1f.2 SATA controller: Intel Corporation 6 Series/C200 Series
Chipset Family SATA AHCI Controller (rev 05) (prog-if 01 [AHCI 1.0])
  Subsystem: ASUSTeK Computer Inc. P8P67 Deluxe Motherboard
  Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
  Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
  Latency: 0
  Interrupt: pin B routed to IRQ 52
  Region 0: I/O ports at f090 [size=8]
  Region 1: I/O ports at f080 [size=4]
  Region 2: I/O ports at f070 [size=8]
  Region 3: I/O ports at f060 [size=4]
  Region 4: I/O ports at f020 [size=32]
  Region 5: Memory at f7426000 (32-bit, non-prefetchable) [size=2K]
  Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
    Address: fee0200c  Data: 41a2
  Capabilities: [70] Power Management version 3
    Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
    Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
  Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=00000004
  Capabilities: [b0] PCI Advanced Features
    AFCap: TP+ FLR+
    AFCtrl: FLR-
    AFStatus: TP-
  Kernel driver in use: ahci

00:1f.3 SMBus: Intel Corporation 6 Series/C200 Series Chipset Family
SMBus Controller (rev 05)
  Subsystem: ASUSTeK Computer Inc. P8P67 Deluxe Motherboard
  Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
  Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
  Interrupt: pin C routed to IRQ 11
  Region 0: Memory at f7425000 (64-bit, non-prefetchable) [size=256]
  Region 4: I/O ports at 0580 [size=32]

01:00.0 VGA compatible controller: NVIDIA Corporation GK106 [GeForce
GTX 660] (rev a1) (prog-if 00 [VGA controller])
  Subsystem: ASUSTeK Computer Inc. Device 8422
  Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
  Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
  Latency: 0, Cache Line Size: 64 bytes
  Interrupt: pin A routed to IRQ 16
  Region 0: Memory at f6000000 (32-bit, non-prefetchable) [size=16M]
  Region 1: Memory at e8000000 (64-bit, prefetchable) [size=128M]
  Region 3: Memory at f0000000 (64-bit, prefetchable) [size=32M]
  Region 5: I/O ports at e000 [size=128]
  Expansion ROM at f7000000 [disabled] [size=512K]
  Capabilities: [60] Power Management version 3
    Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
    Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
  Capabilities: [68] MSI: Enable- Count=1/1 Maskable- 64bit+
    Address: 0000000000000000  Data: 0000
  Capabilities: [78] Express (v2) Endpoint, MSI 00
    DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s unlimited, L1 <64us
      ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
    DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
      RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
      MaxPayload 128 bytes, MaxReadReq 512 bytes
    DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
    LnkCap: Port #0, Speed 8GT/s, Width x16, ASPM L0s L1, Latency L0
<512ns, L1 <4us
      ClockPM+ Surprise- LLActRep- BwNot-
    LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
      ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
    LnkSta: Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
    DevCap2: Completion Timeout: Range AB, TimeoutDis+
    DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
    LnkCtl2: Target Link Speed: 8GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
       Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
       Compliance De-emphasis: -6dB
    LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-
       EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
  Capabilities: [b4] Vendor Specific Information: Len=14 <?>
  Capabilities: [100 v1] Virtual Channel
    Caps: LPEVC=0 RefClk=100ns PATEntryBits=1
    Arb:  Fixed- WRR32- WRR64- WRR128-
    Ctrl: ArbSelect=Fixed
    Status: InProgress-
    VC0:  Caps: PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
      Arb:  Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
      Ctrl: Enable+ ID=0 ArbSelect=Fixed TC/VC=01
      Status: NegoPending- InProgress-
  Capabilities: [128 v1] Power Budgeting <?>
  Capabilities: [600 v1] Vendor Specific Information: ID=0001 Rev=1 Len=024 <?>
  Capabilities: [900 v1] #19
  Kernel driver in use: nouveau

01:00.1 Audio device: NVIDIA Corporation Device 0e0b (rev a1)
  Subsystem: ASUSTeK Computer Inc. Device 8422
  Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
  Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
  Latency: 0, Cache Line Size: 64 bytes
  Interrupt: pin B routed to IRQ 17
  Region 0: Memory at f7080000 (32-bit, non-prefetchable) [size=16K]
  Capabilities: [60] Power Management version 3
    Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
    Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
  Capabilities: [68] MSI: Enable- Count=1/1 Maskable- 64bit+
    Address: 0000000000000000  Data: 0000
  Capabilities: [78] Express (v2) Endpoint, MSI 00
    DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s unlimited, L1 <64us
      ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
    DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
      RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
      MaxPayload 128 bytes, MaxReadReq 512 bytes
    DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
    LnkCap: Port #0, Speed 8GT/s, Width x16, ASPM L0s L1, Latency L0
<512ns, L1 <4us
      ClockPM+ Surprise- LLActRep- BwNot-
    LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
      ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
    LnkSta: Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
    DevCap2: Completion Timeout: Range AB, TimeoutDis+
    DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
    LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
       Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
       Compliance De-emphasis: -6dB
    LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-
       EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
  Kernel driver in use: snd_hda_intel

03:00.0 USB controller: ASMedia Technology Inc. ASM1042 SuperSpeed USB
Host Controller (prog-if 30 [XHCI])
  Subsystem: ASUSTeK Computer Inc. Device 8488
  Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
  Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
  Latency: 0, Cache Line Size: 64 bytes
  Interrupt: pin A routed to IRQ 16
  Region 0: Memory at f7300000 (64-bit, non-prefetchable) [size=32K]
  Capabilities: [50] MSI: Enable- Count=1/8 Maskable- 64bit+
    Address: 0000000000000000  Data: 0000
  Capabilities: [68] MSI-X: Enable+ Count=8 Masked-
    Vector table: BAR=0 offset=00002000
    PBA: BAR=0 offset=00002080
  Capabilities: [78] Power Management version 3
    Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
    Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
  Capabilities: [80] Express (v2) Legacy Endpoint, MSI 00
    DevCap: MaxPayload 512 bytes, PhantFunc 0, Latency L0s <64ns, L1 <2us
      ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
    DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
      RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
      MaxPayload 128 bytes, MaxReadReq 512 bytes
    DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
    LnkCap: Port #1, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0
unlimited, L1 unlimited
      ClockPM- Surprise- LLActRep- BwNot-
    LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
      ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
    LnkSta: Speed 5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
    DevCap2: Completion Timeout: Not Supported, TimeoutDis-
    DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
    LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
       Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
       Compliance De-emphasis: -6dB
    LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
       EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
  Capabilities: [100 v1] Virtual Channel
    Caps: LPEVC=0 RefClk=100ns PATEntryBits=1
    Arb:  Fixed- WRR32- WRR64- WRR128-
    Ctrl: ArbSelect=Fixed
    Status: InProgress-
    VC0:  Caps: PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
      Arb:  Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
      Ctrl: Enable+ ID=0 ArbSelect=Fixed TC/VC=01
      Status: NegoPending- InProgress-
  Kernel driver in use: xhci_hcd

04:00.0 USB controller: ASMedia Technology Inc. ASM1042 SuperSpeed USB
Host Controller (prog-if 30 [XHCI])
  Subsystem: ASUSTeK Computer Inc. Device 8488
  Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
  Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
  Latency: 0, Cache Line Size: 64 bytes
  Interrupt: pin A routed to IRQ 17
  Region 0: Memory at f7200000 (64-bit, non-prefetchable) [size=32K]
  Capabilities: [50] MSI: Enable- Count=1/8 Maskable- 64bit+
    Address: 0000000000000000  Data: 0000
  Capabilities: [68] MSI-X: Enable+ Count=8 Masked-
    Vector table: BAR=0 offset=00002000
    PBA: BAR=0 offset=00002080
  Capabilities: [78] Power Management version 3
    Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
    Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
  Capabilities: [80] Express (v2) Legacy Endpoint, MSI 00
    DevCap: MaxPayload 512 bytes, PhantFunc 0, Latency L0s <64ns, L1 <2us
      ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
    DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
      RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
      MaxPayload 128 bytes, MaxReadReq 512 bytes
    DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
    LnkCap: Port #1, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0
unlimited, L1 unlimited
      ClockPM- Surprise- LLActRep- BwNot-
    LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
      ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
    LnkSta: Speed 5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
    DevCap2: Completion Timeout: Not Supported, TimeoutDis-
    DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
    LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
       Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
       Compliance De-emphasis: -6dB
    LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
       EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
  Capabilities: [100 v1] Virtual Channel
    Caps: LPEVC=0 RefClk=100ns PATEntryBits=1
    Arb:  Fixed- WRR32- WRR64- WRR128-
    Ctrl: ArbSelect=Fixed
    Status: InProgress-
    VC0:  Caps: PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
      Arb:  Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
      Ctrl: Enable+ ID=0 ArbSelect=Fixed TC/VC=01
      Status: NegoPending- InProgress-
  Kernel driver in use: xhci_hcd

05:00.0 SATA controller: JMicron Technology Corp. JMB362 SATA
Controller (rev 10) (prog-if 01 [AHCI 1.0])
  Subsystem: ASUSTeK Computer Inc. P8P67 Deluxe Motherboard
  Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
  Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
  Latency: 0, Cache Line Size: 64 bytes
  Interrupt: pin A routed to IRQ 18
  Region 0: I/O ports at d040 [size=8]
  Region 1: I/O ports at d030 [size=4]
  Region 2: I/O ports at d020 [size=8]
  Region 3: I/O ports at d010 [size=4]
  Region 4: I/O ports at d000 [size=16]
  Region 5: Memory at f7110000 (32-bit, non-prefetchable) [size=512]
  [virtual] Expansion ROM at e0500000 [disabled] [size=64K]
  Capabilities: [8c] Power Management version 3
    Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
    Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
  Capabilities: [50] Express (v1) Legacy Endpoint, MSI 00
    DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
      ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
    DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
      RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
      MaxPayload 128 bytes, MaxReadReq 512 bytes
    DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
    LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0
<1us, L1 <16us
      ClockPM- Surprise- LLActRep- BwNot-
    LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
      ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
    LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
  Kernel driver in use: ahci


SCSI information (from /proc/scsi/scsi):
cat /proc/scsi/scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: SanDisk SDSSDX12 Rev: R112
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: WDC WD6400AAKS-0 Rev: 01.0
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi3 Channel: 00 Id: 00 Lun: 00
  Vendor: HL-DT-ST Model: DVDRAM GH22LS50  Rev: TL02
  Type:   CD-ROM                           ANSI  SCSI revision: 05
Host: scsi8 Channel: 00 Id: 00 Lun: 00
  Vendor: WD       Model: 10EAVS External  Rev: 1.05
  Type:   Direct-Access                    ANSI  SCSI revision: 04
Host: scsi9 Channel: 00 Id: 00 Lun: 00
  Vendor: WD       Model: Ext HDD 1021     Rev: 2021
  Type:   Direct-Access                    ANSI  SCSI revision: 04
Host: scsi10 Channel: 00 Id: 00 Lun: 00
  Vendor: WD       Model: Ext HDD 1021     Rev: 2002
  Type:   Direct-Access                    ANSI  SCSI revision: 04
Host: scsi11 Channel: 00 Id: 00 Lun: 00
  Vendor: WD       Model: Ext HDD 1021     Rev: 2021
  Type:   Direct-Access                    ANSI  SCSI revision: 04

Other information:
ls /proc
1     1308  2297  2491  2680  298   3886  6     960            loadavg
10    1314  23    2494  2686  299   39    62    acpi           locks
1043  1315  2307  2496  2688  3     392   65    asound         mdstat
1053  1316  2311  2497  2689  30    40    657   buddyinfo      meminfo
1054  1356  2314  2498  269   300   404   658   bus            misc
1067  1358  2322  25    2690  3011  406   67    cgroups        modules
1070  14    2339  2517  27    306   41    690   cmdline        mounts
1075  1401  2343  2565  2704  307   4122  7     consoles       mtrr
1084  15    2372  257   2710  3072  42    723   cpuinfo        net
11    1596  2377  2570  2712  31    4261  7428  crypto         pagetypeinfo
1103  16    2380  2573  2735  3163  427   7489  devices        partitions
1107  1619  2381  2576  2744  32    428   749   diskstats      sched_debug
1119  1631  2382  2579  2746  33    4280  7512  dma            schedstat
1121  1645  2384  258   2748  34    4300  7646  dri            scsi
1125  1651  2400  2581  2759  35    44    7665  driver         self
1158  17    2403  2587  2761  3554  45    7759  execdomains    slabinfo
1160  1778  2408  259   2782  3555  46    7845  fb             softirqs
1163  1783  2418  26    2789  3556  47    8     filesystems    stat
1166  18    2423  260   2790  36    48    8097  fs             swaps
1173  1839  2427  261   2791  37    49    8099  interrupts     sys
1191  19    2444  2612  2795  3723  5     8105  iomem          sysrq-trigger
1192  2     2451  2614  2796  3724  50    8106  ioports        sysvipc
12    2024  2456  262   2828  3730  5061  8171  irq            timer_list
1252  2033  2457  2625  2834  3735  5303  818   kallsyms       timer_stats
1259  21    2459  2627  2839  3741  546   819   kcore          tty
1270  22    2473  2628  2846  3743  5618  8209  key-users      uptime
1273  2237  2475  2629  2899  3749  5675  86    kmsg           version
1282  2248  2484  2630  29    3752  5718  87    kpagecount     vmallocinfo
13    2293  2487  267   297   3756  5818  88    kpageflags     vmstat
1303  2296  2489  268   2977  38    5848  9     latency_stats  zoneinfo
