Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.235]:7256 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755737AbYBOUYE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2008 15:24:04 -0500
Received: by wr-out-0506.google.com with SMTP id c48so1242397wra.23
        for <linux-wireless@vger.kernel.org>; Fri, 15 Feb 2008 12:24:03 -0800 (PST)
Message-ID: <cc0a3d6b0802151224o65384231ka5b0d50e979bd357@mail.gmail.com> (sfid-20080215_202413_496164_7718C5A7)
Date: Fri, 15 Feb 2008 20:24:02 +0000
From: "Giulivo Navigante" <giulivo.navigante@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: PROBLEM: rt61pci works only if at least one "iwlist scanning" has been given
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

*1. rt61pci works only if at least one "iwlist scanning" has been given

*2. the rt61pci module works well, but only if the user gives at least
one time (after kernel initialization or module load) the command
"iwlist scanning" ... otherwise it configures correctly all the
parameters on the interface, but the card will never start
transferring packets (and you will never see the quality of signal
values on the iwconfig output). note that if the card is already
configured, it will start working just at the completion of the
"iwlist scanning" command.

*3. rt61pci, networking, wireless

*4. 2.6.24.1

*5.

*6.

*7.1.
Gnu C                  4.2.3
Gnu make               3.81
binutils               2.18
util-linux             2.13.0.1
mount                  2.13.0.1
module-init-tools      3.2.2
e2fsprogs              1.40.4
jfsutils               1.1.12
reiserfsprogs          3.6.20
xfsprogs               2.9.4
pcmciautils            014
Linux C Library        2.7
Dynamic linker (ldd)   2.7
Linux C++ Library      6.0.9
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.13
Sh-utils               6.10
udev                   116
wireless-tools         29
Modules Loaded         ipv6 nvidia agpgart ext2 mbcache snd_seq_oss
snd_seq_midi_event snd_seq snd_seq_device ppdev snd_pcm_oss
snd_mixer_oss lp firewire_ohci firewire_core ppp_generic slhc
parport_pc parport ohci1394 ieee1394 psmouse serio_raw pcspkr rtc_cmos
rtc_core rtc_lib k8temp snd_hda_intel snd_pcm snd_timer snd_page_alloc
snd_hwdep snd soundcore sg forcedeth ehci_hcd ohci_hcd i2c_nforce2
i2c_core evdev thermal processor fan button battery ac fuse arc4 ecb
rt61pci rt2x00pci rt2x00lib rfkill input_polldev crc_itu_t mac80211
cfg80211 eeprom_93cx6 usbcore reiserfs sr_mod cdrom sd_mod pata_acpi
sata_nv ata_generic pata_amd libata

*7.2.
processor	: 0
vendor_id	: AuthenticAMD
cpu family	: 15
model		: 75
model name	: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+
stepping	: 2
cpu MHz		: 2009.100
cache size	: 512 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt
rdtscp lm 3dnowext 3dnow pni cx16 lahf_lm cmp_legacy svm extapic
cr8_legacy ts fid vid ttp tm stc
bogomips	: 4022.74
clflush size	: 64

processor	: 1
vendor_id	: AuthenticAMD
cpu family	: 15
model		: 75
model name	: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+
stepping	: 2
cpu MHz		: 2009.100
cache size	: 512 KB
physical id	: 0
siblings	: 2
core id		: 1
cpu cores	: 2
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt
rdtscp lm 3dnowext 3dnow pni cx16 lahf_lm cmp_legacy svm extapic
cr8_legacy ts fid vid ttp tm stc
bogomips	: 4019.43
clflush size	: 64

*7.3.
ipv6 248388 10 - Live 0xf9114000
nvidia 7813728 24 - Live 0xf984f000 (P)
agpgart 27352 1 nvidia, Live 0xf900f000
ext2 62472 1 - Live 0xf8ceb000
mbcache 6912 1 ext2, Live 0xf8ca0000
snd_seq_oss 29440 0 - Live 0xf8cce000
snd_seq_midi_event 6528 1 snd_seq_oss, Live 0xf8c9d000
snd_seq 47056 4 snd_seq_oss,snd_seq_midi_event, Live 0xf8cc1000
snd_seq_device 6924 2 snd_seq_oss,snd_seq, Live 0xf8c9a000
ppdev 7556 0 - Live 0xf8c4d000
snd_pcm_oss 37024 0 - Live 0xf8ca6000
snd_mixer_oss 14464 1 snd_pcm_oss, Live 0xf8bfa000
lp 9220 0 - Live 0xf8b92000
firewire_ohci 16128 0 - Live 0xf8bdd000
firewire_core 36544 1 firewire_ohci, Live 0xf8c43000
ppp_generic 23828 0 - Live 0xf8c1d000
slhc 5632 1 ppp_generic, Live 0xf8bd4000
parport_pc 35172 1 - Live 0xf8c39000
parport 31432 3 ppdev,lp,parport_pc, Live 0xf8c14000
ohci1394 28848 0 - Live 0xf8c0b000
ieee1394 79800 1 ohci1394, Live 0xf8c24000
psmouse 36496 0 - Live 0xf8c01000
serio_raw 5636 0 - Live 0xf8bd1000
pcspkr 2944 0 - Live 0xf8bcf000
rtc_cmos 7584 0 - Live 0xf8bae000
rtc_core 15496 1 rtc_cmos, Live 0xf8bb4000
rtc_lib 2944 1 rtc_core, Live 0xf8b9c000
k8temp 4736 0 - Live 0xf8bb1000
snd_hda_intel 289952 1 - Live 0xf8c52000
snd_pcm 68996 2 snd_pcm_oss,snd_hda_intel, Live 0xf8be2000
snd_timer 19204 2 snd_seq,snd_pcm, Live 0xf8bc6000
snd_page_alloc 8072 2 snd_hda_intel,snd_pcm, Live 0xf8bab000
snd_hwdep 7300 1 snd_hda_intel, Live 0xf8b99000
snd 44772 11 snd_seq_oss,snd_seq,snd_seq_device,snd_pcm_oss,snd_mixer_oss,snd_hda_intel,snd_pcm,snd_timer,snd_hwdep,
Live 0xf8bba000
soundcore 6368 1 snd, Live 0xf8b96000
sg 26640 0 - Live 0xf8b67000
forcedeth 45196 0 - Live 0xf8b9e000
ehci_hcd 32524 0 - Live 0xf8b86000
ohci_hcd 21380 0 - Live 0xf8b7f000
i2c_nforce2 6016 0 - Live 0xf8b4d000
i2c_core 19328 2 nvidia,i2c_nforce2, Live 0xf8b79000
evdev 9344 3 - Live 0xf8b49000
thermal 13084 0 - Live 0xf8a33000
processor 29400 1 thermal, Live 0xf8b70000
fan 3844 0 - Live 0xf887e000
button 6544 0 - Live 0xf8a26000
battery 10756 0 - Live 0xf8a38000
ac 4612 0 - Live 0xf8a29000
fuse 42260 2 - Live 0xf8b59000
arc4 2176 2 - Live 0xf8a19000
ecb 3072 2 - Live 0xf8a24000
rt61pci 22528 0 - Live 0xf8a2c000
rt2x00pci 7680 1 rt61pci, Live 0xf8a1b000
rt2x00lib 17920 2 rt61pci,rt2x00pci, Live 0xf8a1e000
rfkill 5904 1 rt2x00lib, Live 0xf8841000
input_polldev 3720 1 rt2x00lib, Live 0xf887c000
crc_itu_t 2304 2 firewire_core,rt2x00lib, Live 0xf887a000
mac80211 117132 3 rt61pci,rt2x00pci,rt2x00lib, Live 0xf8b2b000
cfg80211 11528 1 mac80211, Live 0xf8a13000
eeprom_93cx6 2304 1 rt61pci, Live 0xf8878000
usbcore 125292 3 ehci_hcd,ohci_hcd, Live 0xf8b0b000
reiserfs 225408 5 - Live 0xf8a41000
sr_mod 14884 0 - Live 0xf883c000
cdrom 33824 1 sr_mod, Live 0xf886e000
sd_mod 22656 11 - Live 0xf8867000
pata_acpi 5248 0 - Live 0xf882a000
sata_nv 22152 0 - Live 0xf882f000
ata_generic 5252 0 - Live 0xf8824000
pata_amd 10500 9 - Live 0xf8820000
libata 137712 4 pata_acpi,sata_nv,ata_generic,pata_amd, Live 0xf8844000

*7.5.
00:00.0 RAM memory: nVidia Corporation MCP61 Memory Controller (rev a1)
	Subsystem: ASUSTeK Computer Inc. Unknown device 8234
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: <access denied>

00:01.0 ISA bridge: nVidia Corporation MCP61 LPC Bridge (rev a2)
	Subsystem: ASUSTeK Computer Inc. Unknown device 8234
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Region 0: I/O ports at 0900 [size=256]

00:01.1 SMBus: nVidia Corporation MCP61 SMBus (rev a2)
	Subsystem: ASUSTeK Computer Inc. Unknown device 8234
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 10
	Region 0: I/O ports at dc00 [size=64]
	Region 4: I/O ports at 0600 [size=64]
	Region 5: I/O ports at 0700 [size=64]
	Capabilities: <access denied>

00:01.2 RAM memory: nVidia Corporation MCP61 Memory Controller (rev a2)
	Subsystem: ASUSTeK Computer Inc. Unknown device 8234
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:02.0 USB Controller: nVidia Corporation MCP61 USB Controller (rev
a2) (prog-if 10 [OHCI])
	Subsystem: ASUSTeK Computer Inc. Unknown device 8234
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin A routed to IRQ 19
	Region 0: Memory at dddff000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: <access denied>

00:02.1 USB Controller: nVidia Corporation MCP61 USB Controller (rev
a2) (prog-if 20 [EHCI])
	Subsystem: ASUSTeK Computer Inc. Unknown device 8234
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin B routed to IRQ 16
	Region 0: Memory at dddfec00 (32-bit, non-prefetchable) [size=256]
	Capabilities: <access denied>

00:04.0 PCI bridge: nVidia Corporation MCP61 PCI bridge (rev a1)
(prog-if 01 [Subtractive decode])
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=64
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: dde00000-ddefffff
	Prefetchable memory behind bridge: fff00000-000fffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr+ DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>

00:05.0 Audio device: nVidia Corporation MCP61 High Definition Audio (rev a2)
	Subsystem: ASUSTeK Computer Inc. Unknown device 8234
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (500ns min, 1250ns max)
	Interrupt: pin B routed to IRQ 17
	Region 0: Memory at dddf8000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: <access denied>

00:06.0 IDE interface: nVidia Corporation MCP61 IDE (rev a2) (prog-if
8a [Master SecP PriP])
	Subsystem: Unknown device f043:8234
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (750ns min, 250ns max)
	Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable)
[disabled] [size=8]
	Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable)
[disabled] [size=1]
	Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable)
[disabled] [size=8]
	Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable)
[disabled] [size=1]
	Region 4: I/O ports at ffa0 [size=16]
	Capabilities: <access denied>

00:07.0 Bridge: nVidia Corporation MCP61 Ethernet (rev a2)
	Subsystem: ASUSTeK Computer Inc. Unknown device 8234
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (250ns min, 5000ns max)
	Interrupt: pin A routed to IRQ 20
	Region 0: Memory at dddfd000 (32-bit, non-prefetchable) [size=4K]
	Region 1: I/O ports at d480 [size=8]
	Capabilities: <access denied>

00:08.0 IDE interface: nVidia Corporation MCP61 SATA Controller (rev
a2) (prog-if 85 [Master SecO PriO])
	Subsystem: ASUSTeK Computer Inc. Unknown device 8234
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin A routed to IRQ 16
	Region 0: I/O ports at d400 [size=8]
	Region 1: I/O ports at d080 [size=4]
	Region 2: I/O ports at d000 [size=8]
	Region 3: I/O ports at cc00 [size=4]
	Region 4: I/O ports at c880 [size=16]
	Region 5: Memory at dddfc000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: <access denied>

00:08.1 IDE interface: nVidia Corporation MCP61 SATA Controller (rev
a2) (prog-if 85 [Master SecO PriO])
	Subsystem: ASUSTeK Computer Inc. Unknown device 8234
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin B routed to IRQ 17
	Region 0: I/O ports at c800 [size=8]
	Region 1: I/O ports at c480 [size=4]
	Region 2: I/O ports at c400 [size=8]
	Region 3: I/O ports at c080 [size=4]
	Region 4: I/O ports at c000 [size=16]
	Region 5: Memory at dddf3000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: <access denied>

00:09.0 PCI bridge: nVidia Corporation MCP61 PCI Express bridge (rev
a2) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 0000e000-0000efff
	Memory behind bridge: ddf00000-dfffffff
	Prefetchable memory behind bridge: 00000000c0000000-00000000cfffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>

00:0b.0 PCI bridge: nVidia Corporation MCP61 PCI Express bridge (rev
a2) (prog-if 00 [Normal decode])
	Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>

00:0c.0 PCI bridge: nVidia Corporation MCP61 PCI Express bridge (rev
a2) (prog-if 00 [Normal decode])
	Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>

00:18.0 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] HyperTransport Technology Configuration
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: <access denied>

00:18.1 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] Address Map
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.2 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] DRAM Controller
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.3 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] Miscellaneous Control
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: <access denied>

01:06.0 Network controller: RaLink RT2561/RT61 802.11g PCI
	Subsystem: RaLink EW-7108PCg
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at ddef8000 (32-bit, non-prefetchable) [size=32K]
	Capabilities: <access denied>

01:07.0 FireWire (IEEE 1394): Texas Instruments TSB43AB23
IEEE-1394a-2000 Controller (PHY/Link) (prog-if 10 [OHCI])
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (500ns min, 1000ns max), Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 21
	Region 0: Memory at ddef7800 (32-bit, non-prefetchable) [size=2K]
	Region 1: Memory at ddef0000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: <access denied>

02:00.0 VGA compatible controller: nVidia Corporation G70 [GeForce
7600 GT] (rev a1) (prog-if 00 [VGA controller])
	Subsystem: Unknown device 1acc:0812
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 22
	Region 0: Memory at df000000 (32-bit, non-prefetchable) [size=16M]
	Region 1: Memory at c0000000 (64-bit, prefetchable) [size=256M]
	Region 3: Memory at de000000 (64-bit, non-prefetchable) [size=16M]
	Region 5: I/O ports at ec00 [size=128]
	[virtual] Expansion ROM at ddfe0000 [disabled] [size=128K]
	Capabilities: <access denied>

*7.6.
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: ST340014A        Rev: 8.01
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi0 Channel: 00 Id: 01 Lun: 00
  Vendor: ATA      Model: Maxtor 6Y080P0   Rev: YAR4
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi2 Channel: 00 Id: 00 Lun: 00
  Vendor: LITE-ON  Model: DVDRW LH-20A1S   Rev: 9L02
  Type:   CD-ROM                           ANSI  SCSI revision: 05

*7.7.

THANK YOU!
