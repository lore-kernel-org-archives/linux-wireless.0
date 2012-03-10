Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail1.atellus.se ([217.68.32.43]:39714 "EHLO mail1.atellus.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752285Ab2CJKOX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Mar 2012 05:14:23 -0500
Message-ID: <4F5B27DB.8090508@cetex.se> (sfid-20120310_111435_669513_BE147A8A)
Date: Sat, 10 Mar 2012 11:07:23 +0100
From: Oskar Stenman <oskar@cetex.se>
MIME-Version: 1.0
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: ath9k timeouts with the current Mainline
References: <4F12F5DD.3030904@gmail.com>
In-Reply-To: <4F12F5DD.3030904@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------010208010805060400050900"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010208010805060400050900
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

I'm having a similar or the same problem, it's been nagging me for at 
least 1.5years.

If I'm able to connect I get frequent dropouts from any wireless network 
I'm connected to. It gets sluggish and after a little while disconnects, 
and once it has disconnected it just keeps reconnecting and failing. 
sometimes a reboot helps, but most of the time it wont help anymore than 
a couple of seconds to a minute. It's also impossible to connect to my 
wireless hotspot on my Xperia Mini Pro and it seems ad-hoc networks are 
also impossible.

I'm running ubuntu 11.10 with latest patches applied as of today. Since 
i've not seen anything being solved during this time i doubt anyone has 
been trying to, or has been able to solve the problem recently.

uname -a
Linux 1005PE 3.0.0-16-generic #29-Ubuntu SMP Tue Feb 14 12:49:42 UTC 
2012 i686 i686 i386 GNU/Linux

lspci -vvv
02:00.0 Network controller: Atheros Communications Inc. AR9285 Wireless 
Network Adapter (PCI-Express) (rev 01)
     Subsystem: AzureWave Device 1089
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 32 bytes
     Interrupt: pin A routed to IRQ 17
     Region 0: Memory at fbff0000 (64-bit, non-prefetchable) [size=64K]
     Capabilities: [40] Power Management version 3
         Flags: PMEClk- DSI- D1+ D2- AuxCurrent=375mA 
PME(D0+,D1+,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit-
         Address: 00000000  Data: 0000
     Capabilities: [60] Express (v2) Legacy Endpoint, MSI 00
         DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<512ns, L1 <64us
             ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
             RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
             MaxPayload 128 bytes, MaxReadReq 512 bytes
         DevSta:    CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ 
TransPend-
         LnkCap:    Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, 
Latency L0 <512ns, L1 <64us
             ClockPM- Surprise- LLActRep- BwNot-
         LnkCtl:    ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- 
CommClk+
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
         DevCap2: Completion Timeout: Not Supported, TimeoutDis+
         DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
         LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- 
SpeedDis-, Selectable De-emphasis: -6dB
              Transmit Margin: Normal Operating Range, 
EnterModifiedCompliance- ComplianceSOS-
              Compliance De-emphasis: -6dB
         LnkSta2: Current De-emphasis Level: -6dB
     Capabilities: [100 v1] Advanced Error Reporting
         UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
         UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
         UESvrt:    DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
         CESta:    RxErr+ BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
         CEMsk:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
         AERCap:    First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
     Capabilities: [140 v1] Virtual Channel
         Caps:    LPEVC=0 RefClk=100ns PATEntryBits=1
         Arb:    Fixed- WRR32- WRR64- WRR128-
         Ctrl:    ArbSelect=Fixed
         Status:    InProgress-
         VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
             Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
             Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=01
             Status:    NegoPending- InProgress-
     Capabilities: [160 v1] Device Serial Number 00-15-17-ff-ff-24-14-12
     Capabilities: [170 v1] Power Budgeting <?>
     Kernel driver in use: ath9k
     Kernel modules: ath9k

after having network-manager trying to connect to my hotspot for a while 
dmesg shows a lot of:
[ 1475.249446] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 1475.448077] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 1475.648107] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 1475.848085] wlan0: direct probe to 84:00:d2:20:0d:3a timed out

complete dmesg and lsmod is attached.

What i've found that seems relevant on a quick google-run:
https://bugzilla.kernel.org/show_bug.cgi?id=42092
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/773154

No solution in sight though.

If there's any way that i can help solve this please let me know!

Oskar Stenman


On 01/15/2012 04:50 PM, Justin P. Mattock wrote:
> not sure if the Internet provider just sucks, or I am hitting a 
> wireless issue. basically my connection times out after a few mins of 
> being up.(streaming radio is not solid).
>
> dmesg shows:
>
> [ 3322.827549] wlan1: authenticate with d8:c7:c8:a2:0f:40 (try 1)
> [ 3322.831778] wlan1: d8:c7:c8:a2:0f:40 denied authentication (status 17)
> [ 3386.310128] wlan1: authenticate with d8:c7:c8:a2:0d:80 (try 1)
> [ 3386.312010] wlan1: d8:c7:c8:a2:0d:80 denied authentication (status 17)
> [ 3389.481771] wlan1: direct probe to 00:18:0a:02:19:c3 (try 1/3)
> [ 3389.681095] wlan1: direct probe to 00:18:0a:02:19:c3 (try 2/3)
> [ 3389.881094] wlan1: direct probe to 00:18:0a:02:19:c3 (try 3/3)
> [ 3390.081092] wlan1: direct probe to 00:18:0a:02:19:c3 timed out
> [ 3458.618065] wlan1: direct probe to d8:c7:c8:a2:0d:80 (try 1/3)
> [ 3458.818079] wlan1: direct probe to d8:c7:c8:a2:0d:80 (try 2/3)
> [ 3459.018080] wlan1: direct probe to d8:c7:c8:a2:0d:80 (try 3/3)
> [ 3459.218058] wlan1: direct probe to d8:c7:c8:a2:0d:80 timed out
> [ 3466.518579] wlan1: direct probe to d8:c7:c8:a2:0d:80 (try 1/3)
> [ 3466.718111] wlan1: direct probe to d8:c7:c8:a2:0d:80 (try 2/3)
> [ 3466.918074] wlan1: direct probe to d8:c7:c8:a2:0d:80 (try 3/3)
> [ 3467.118077] wlan1: direct probe to d8:c7:c8:a2:0d:80 timed out
> [ 3474.424860] wlan1: authenticate with d8:c7:c8:a2:0d:80 (try 1)
> [ 3474.449681] wlan1: authenticated
> [ 3474.457133] wlan1: associate with d8:c7:c8:a2:0d:80 (try 1)
> [ 3474.471059] wlan1: RX AssocResp from d8:c7:c8:a2:0d:80 (capab=0x421 
> status=0 aid=13)
> [ 3474.471067] wlan1: associated
> [ 3474.471075] wlan1: moving STA d8:c7:c8:a2:0d:80 to state 1
> [ 3474.471080] wlan1: moving STA d8:c7:c8:a2:0d:80 to state 2
> [ 3474.473809] wlan1: moving STA d8:c7:c8:a2:0d:80 to state 3
> [ 3484.546077] wlan1: no IPv6 routers present
>
>
> card is:
> 03:00.0 Network controller: Atheros Communications Inc. AR5008 
> Wireless Network Adapter (rev 01)
>
> has anybody else seen/experienced anything like this?
>
> Justin P. Mattock
> -- 
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>


--------------010208010805060400050900
Content-Type: text/plain;
 name="lsmod.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="lsmod.txt"

Module                  Size  Used by
rndis_host             13560  0 
cdc_ether              13312  1 rndis_host
usbnet                 25214  2 rndis_host,cdc_ether
bnep                   17923  2 
rfcomm                 38408  8 
parport_pc             32114  0 
ppdev                  12849  0 
binfmt_misc            17292  1 
uvcvideo               67271  0 
videodev               85626  1 uvcvideo
snd_hda_codec_realtek   254163  1 
snd_hda_intel          24262  2 
joydev                 17393  0 
snd_hda_codec          91859  2 snd_hda_codec_realtek,snd_hda_intel
snd_hwdep              13276  1 snd_hda_codec
snd_pcm                80435  2 snd_hda_intel,snd_hda_codec
arc4                   12473  2 
snd_seq_midi           13132  0 
snd_rawmidi            25241  1 snd_seq_midi
i915                  509519  2 
snd_seq_midi_event     14475  1 snd_seq_midi
ath9k                 112711  0 
drm_kms_helper         32889  1 i915
btusb                  18160  2 
bluetooth             148839  23 bnep,rfcomm,btusb
snd_seq                51567  2 snd_seq_midi,snd_seq_midi_event
snd_timer              28932  2 snd_pcm,snd_seq
snd_seq_device         14172  3 snd_seq_midi,snd_rawmidi,snd_seq
asus_wmi               19333  0 
psmouse                73673  0 
snd                    55902  13 snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_rawmidi,snd_seq,snd_timer,snd_seq_device
drm                   192194  3 i915,drm_kms_helper
mac80211              393421  1 ath9k
i2c_algo_bit           13199  1 i915
ath9k_common           13599  1 ath9k
serio_raw              12990  0 
ath9k_hw              293933  2 ath9k,ath9k_common
video                  18908  1 i915
soundcore              12600  1 snd
ath                    19387  2 ath9k,ath9k_hw
cfg80211              172427  3 ath9k,mac80211,ath
wmi                    18744  1 asus_wmi
eeepc_laptop           19464  0 
snd_page_alloc         14115  2 snd_hda_intel,snd_pcm
sparse_keymap          13658  2 asus_wmi,eeepc_laptop
lp                     17455  0 
parport                40930  3 parport_pc,ppdev,lp
ahci                   21634  2 
libahci                25727  1 ahci
atl1c                  36638  0 

--------------010208010805060400050900
Content-Type: text/plain;
 name="dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg.txt"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.0.0-16-generic (buildd@zirconium) (gcc version 4.6.1 (Ubuntu/Linaro 4.6.1-9ubuntu3) ) #29-Ubuntu SMP Tue Feb 14 12:49:42 UTC 2012 (Ubuntu 3.0.0-16.29-generic 3.0.20)
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Centaur CentaurHauls
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000]   UMC UMC UMC UMC
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e2000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003f690000 (usable)
[    0.000000]  BIOS-e820: 000000003f690000 - 000000003f69e000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003f69e000 - 000000003f6e0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003f6e0000 - 000000003f700000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled in hardware: non-PAE kernel!
[    0.000000] NX (Execute Disable) protection: approximated by x86 segment limits
[    0.000000] DMI present.
[    0.000000] DMI: ASUSTeK Computer INC. 1005PE/1005P, BIOS 1003    03/18/2010
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] last_pfn = 0x3f690 max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-DFFFF uncachable
[    0.000000]   E0000-EFFFF write-through
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask 0C0000000 write-back
[    0.000000]   1 base 03F700000 mask 0FFF00000 uncachable
[    0.000000]   2 base 03F800000 mask 0FF800000 uncachable
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 1GB, type WB
[    0.000000] reg 1, base: 1015MB, range: 1MB, type UC
[    0.000000] reg 2, base: 1016MB, range: 8MB, type UC
[    0.000000] total RAM covered: 1015M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K 	chunk_size: 16M 	num_reg: 3  	lose cover RAM: 0G
[    0.000000] New variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 1GB, type WB
[    0.000000] reg 1, base: 1015MB, range: 1MB, type UC
[    0.000000] reg 2, base: 1016MB, range: 8MB, type UC
[    0.000000] found SMP MP-table at [c00ff780] ff780
[    0.000000] initial memory mapped : 0 - 01c00000
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: 0000000000000000-00000000377fe000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0037400000 page 2M
[    0.000000]  0037400000 - 00377fe000 page 4k
[    0.000000] kernel direct mapping tables up to 377fe000 @ 1bfb000-1c00000
[    0.000000] RAMDISK: 365ea000 - 372ed000
[    0.000000] ACPI: RSDP 000fbf40 00024 (v02 ACPIAM)
[    0.000000] ACPI: XSDT 3f690100 0006C (v01 _ASUS_ Notebook 03001018 MSFT 00000097)
[    0.000000] ACPI: FACP 3f690290 000F4 (v04 A_M_I_ OEMFACP  03001018 MSFT 00000097)
[    0.000000] ACPI: DSDT 3f690490 08C96 (v02  A1414 A1414000 00000000 INTL 20060113)
[    0.000000] ACPI: FACS 3f69e000 00040
[    0.000000] ACPI: APIC 3f690390 0005C (v02 A_M_I_ OEMAPIC  03001018 MSFT 00000097)
[    0.000000] ACPI: MCFG 3f6903f0 0003C (v01 A_M_I_ OEMMCFG  03001018 MSFT 00000097)
[    0.000000] ACPI: ECDT 3f690430 00055 (v01 A_M_I_ OEMECDT  03001018 MSFT 00000097)
[    0.000000] ACPI: OEMB 3f69e040 00061 (v01 A_M_I_ AMI_OEM  03001018 MSFT 00000097)
[    0.000000] ACPI: HPET 3f699130 00038 (v01 A_M_I_ OEMHPET  03001018 MSFT 00000097)
[    0.000000] ACPI: GSCI 3f69e0b0 02024 (v01 A_M_I_ GMCHSCI  03001018 MSFT 00000097)
[    0.000000] ACPI: SSDT 3f6a0c80 004F0 (v01  PmRef    CpuPm 00003000 INTL 20060113)
[    0.000000] ACPI: SLIC 3f699170 00176 (v01 _ASUS_ Notebook 03001018 MSFT 00000097)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 126MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 0 - 377fe000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000377fe
[    0.000000]   HighMem  0x000377fe -> 0x0003f690
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0003f690
[    0.000000] On node 0 totalpages: 259615
[    0.000000] free_area_init_node: node 0, pgdat c17b54c0, node_mem_map f5dfa200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3951 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 221486 pages, LIFO batch:31
[    0.000000]   HighMem zone: 254 pages used for memmap
[    0.000000]   HighMem zone: 32148 pages, LIFO batch:7
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0xffffffff base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e2000
[    0.000000] PM: Registered nosave memory: 00000000000e2000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 3f700000 (gap: 3f700000:bf700000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 12 pages/cpu @f5800000 s26240 r0 d22912 u2097152
[    0.000000] pcpu-alloc: s26240 r0 d22912 u2097152 alloc=1*4194304
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 257585
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.0.0-16-generic root=UUID=de9e766d-e61a-4a30-8e08-030ddc786a3e ro quiet splash acpi_osi=Linux acpi_backlight=vendor vt.handoff=7
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] allocated 4155392 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] Initializing HighMem for node 0 (000377fe:0003f690)
[    0.000000] Memory: 1002472k/1038912k available (5340k kernel code, 35988k reserved, 2596k data, 696k init, 129608k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff16000 - 0xfffff000   ( 932 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.000000]       .init : 0xc17c1000 - 0xc186f000   ( 696 kB)
[    0.000000]       .data : 0xc1537104 - 0xc17c0140   (2596 kB)
[    0.000000]       .text : 0xc1000000 - 0xc1537104   (5340 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=f5408000 soft=f540a000
[    0.000000] Extended CMOS year: 2000
[    0.000000] vt handoff: transparent VT on vt#7
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1666.443 MHz processor.
[    0.004005] Calibrating delay loop (skipped), value calculated using timer frequency.. 3332.88 BogoMIPS (lpj=6665772)
[    0.004017] pid_max: default: 32768 minimum: 301
[    0.004065] Security Framework initialized
[    0.004100] AppArmor: AppArmor initialized
[    0.004105] Yama: becoming mindful.
[    0.004222] Mount-cache hash table entries: 512
[    0.004488] Initializing cgroup subsys cpuacct
[    0.004503] Initializing cgroup subsys memory
[    0.004521] Initializing cgroup subsys devices
[    0.004528] Initializing cgroup subsys freezer
[    0.004533] Initializing cgroup subsys net_cls
[    0.004539] Initializing cgroup subsys blkio
[    0.004555] Initializing cgroup subsys perf_event
[    0.008062] CPU: Physical Processor ID: 0
[    0.008067] CPU: Processor Core ID: 0
[    0.008074] mce: CPU supports 5 MCE banks
[    0.008090] CPU0: Thermal monitoring enabled (TM2)
[    0.008098] using mwait in idle threads.
[    0.011584] ACPI: Core revision 20110413
[    0.024029] ftrace: allocating 24901 entries in 49 pages
[    0.028098] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.028518] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.069995] CPU0: Intel(R) Atom(TM) CPU N450   @ 1.66GHz stepping 0a
[    0.072003] Performance Events: PEBS fmt0+, Atom events, Intel PMU driver.
[    0.072003] ... version:                3
[    0.072003] ... bit width:              40
[    0.072003] ... generic registers:      2
[    0.072003] ... value mask:             000000ffffffffff
[    0.072003] ... max period:             000000007fffffff
[    0.072003] ... fixed-purpose events:   3
[    0.072003] ... event mask:             0000000700000003
[    0.072003] CPU 1 irqstacks, hard=f54ca000 soft=f54cc000
[    0.072003] Booting Node   0, Processors  #1 Ok.
[    0.072003] smpboot cpu 1: start_ip = 9b000
[    0.008000] Initializing CPU#1
[    0.008000] Disabled fast string operations
[    0.160039] Brought up 2 CPUs
[    0.160048] Total of 2 processors activated (6665.81 BogoMIPS).
[    0.160563] devtmpfs: initialized
[    0.160563] PM: Registering ACPI NVS region at 3f69e000 (270336 bytes)
[    0.166552] print_constraints: dummy: 
[    0.166589] Time:  8:59:48  Date: 03/10/12
[    0.166680] NET: Registered protocol family 16
[    0.166705] Trying to unpack rootfs image as initramfs...
[    0.167132] EISA bus registered
[    0.167159] ACPI: bus type pci registered
[    0.167357] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.167368] PCI: not using MMCONFIG
[    0.167640] PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=5
[    0.167649] PCI: Using configuration type 1 for base access
[    0.172083] bio: create slab <bio-0> at 0
[    0.172441] ACPI: Added _OSI(Linux)
[    0.177638] ACPI: EC: EC description table is found, configuring boot EC
[    0.183379] ACPI: Executed 1 blocks of module-level executable AML code
[    0.197147] ACPI: SSDT 3f6a0190 00326 (v01  PmRef  Cpu0Ist 00003000 INTL 20060113)
[    0.198574] ACPI: Dynamic OEM Table Load:
[    0.198586] ACPI: SSDT   (null) 00326 (v01  PmRef  Cpu0Ist 00003000 INTL 20060113)
[    0.200301] ACPI: SSDT 3f6a0550 00724 (v01  PmRef  Cpu0Cst 00003001 INTL 20060113)
[    0.201585] ACPI: Dynamic OEM Table Load:
[    0.201597] ACPI: SSDT   (null) 00724 (v01  PmRef  Cpu0Cst 00003001 INTL 20060113)
[    0.202437] ACPI: SSDT 3f6a00e0 000AB (v01  PmRef  Cpu1Ist 00003000 INTL 20060113)
[    0.203758] ACPI: Dynamic OEM Table Load:
[    0.203770] ACPI: SSDT   (null) 000AB (v01  PmRef  Cpu1Ist 00003000 INTL 20060113)
[    0.204129] ACPI: SSDT 3f6a04c0 00085 (v01  PmRef  Cpu1Cst 00003000 INTL 20060113)
[    0.205407] ACPI: Dynamic OEM Table Load:
[    0.205420] ACPI: SSDT   (null) 00085 (v01  PmRef  Cpu1Cst 00003000 INTL 20060113)
[    0.206069] ACPI: Interpreter enabled
[    0.206086] ACPI: (supports S0 S3 S4 S5)
[    0.206153] ACPI: Using IOAPIC for interrupt routing
[    0.206248] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.207921] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
[    0.207931] PCI: Using MMCONFIG for extended config space
[    0.222864] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query honored via cmdline
[    0.227154] ACPI: EC: GPE = 0x1c, I/O: command/status = 0x66, data = 0x62
[    0.227729] ACPI: No dock devices found.
[    0.227738] HEST: Table not found.
[    0.227750] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.228033] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.228583] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.228594] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.228604] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.228613] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000dffff]
[    0.228623] pci_root PNP0A08:00: host bridge window [mem 0x3f700000-0xfed8ffff]
[    0.228660] pci 0000:00:00.0: [8086:a010] type 0 class 0x000600
[    0.228742] pci 0000:00:02.0: [8086:a011] type 0 class 0x000300
[    0.228764] pci 0000:00:02.0: reg 10: [mem 0xf7e00000-0xf7e7ffff]
[    0.228779] pci 0000:00:02.0: reg 14: [io  0xdc00-0xdc07]
[    0.228793] pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff pref]
[    0.228808] pci 0000:00:02.0: reg 1c: [mem 0xf7d00000-0xf7dfffff]
[    0.228879] pci 0000:00:02.1: [8086:a012] type 0 class 0x000380
[    0.228898] pci 0000:00:02.1: reg 10: [mem 0xf7e80000-0xf7efffff]
[    0.229030] pci 0000:00:1b.0: [8086:27d8] type 0 class 0x000403
[    0.229062] pci 0000:00:1b.0: reg 10: [mem 0xf7cf8000-0xf7cfbfff 64bit]
[    0.229175] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.229187] pci 0000:00:1b.0: PME# disabled
[    0.229230] pci 0000:00:1c.0: [8086:27d0] type 1 class 0x000604
[    0.229355] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.229366] pci 0000:00:1c.0: PME# disabled
[    0.229412] pci 0000:00:1c.1: [8086:27d2] type 1 class 0x000604
[    0.229531] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.229542] pci 0000:00:1c.1: PME# disabled
[    0.229588] pci 0000:00:1c.3: [8086:27d6] type 1 class 0x000604
[    0.229707] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.229718] pci 0000:00:1c.3: PME# disabled
[    0.229765] pci 0000:00:1d.0: [8086:27c8] type 0 class 0x000c03
[    0.229831] pci 0000:00:1d.0: reg 20: [io  0xd400-0xd41f]
[    0.229898] pci 0000:00:1d.1: [8086:27c9] type 0 class 0x000c03
[    0.229966] pci 0000:00:1d.1: reg 20: [io  0xd480-0xd49f]
[    0.230030] pci 0000:00:1d.2: [8086:27ca] type 0 class 0x000c03
[    0.230095] pci 0000:00:1d.2: reg 20: [io  0xd800-0xd81f]
[    0.230157] pci 0000:00:1d.3: [8086:27cb] type 0 class 0x000c03
[    0.230222] pci 0000:00:1d.3: reg 20: [io  0xd880-0xd89f]
[    0.230296] pci 0000:00:1d.7: [8086:27cc] type 0 class 0x000c03
[    0.230330] pci 0000:00:1d.7: reg 10: [mem 0xf7cf7c00-0xf7cf7fff]
[    0.230456] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.230468] pci 0000:00:1d.7: PME# disabled
[    0.230513] pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
[    0.230631] pci 0000:00:1f.0: [8086:27bc] type 0 class 0x000601
[    0.230819] pci 0000:00:1f.2: [8086:27c1] type 0 class 0x000106
[    0.230853] pci 0000:00:1f.2: reg 10: [io  0xd080-0xd087]
[    0.230871] pci 0000:00:1f.2: reg 14: [io  0xd000-0xd003]
[    0.230889] pci 0000:00:1f.2: reg 18: [io  0xcc00-0xcc07]
[    0.230906] pci 0000:00:1f.2: reg 1c: [io  0xc880-0xc883]
[    0.230924] pci 0000:00:1f.2: reg 20: [io  0xc800-0xc81f]
[    0.230942] pci 0000:00:1f.2: reg 24: [mem 0xf7cf7800-0xf7cf7bff]
[    0.231014] pci 0000:00:1f.2: PME# supported from D3hot
[    0.231025] pci 0000:00:1f.2: PME# disabled
[    0.231061] pci 0000:00:1f.3: [8086:27da] type 0 class 0x000c05
[    0.231138] pci 0000:00:1f.3: reg 20: [io  0x0400-0x041f]
[    0.231260] pci 0000:00:1c.0: PCI bridge to [bus 04-04]
[    0.231272] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.231285] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.231300] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.231403] pci 0000:02:00.0: [168c:002b] type 0 class 0x000280
[    0.231446] pci 0000:02:00.0: reg 10: [mem 0xfbff0000-0xfbffffff 64bit]
[    0.231605] pci 0000:02:00.0: supports D1
[    0.231614] pci 0000:02:00.0: PME# supported from D0 D1 D3hot D3cold
[    0.231625] pci 0000:02:00.0: PME# disabled
[    0.236069] pci 0000:00:1c.1: PCI bridge to [bus 02-03]
[    0.236084] pci 0000:00:1c.1:   bridge window [io  0xf000-0x0000] (disabled)
[    0.236097] pci 0000:00:1c.1:   bridge window [mem 0xf8000000-0xfbffffff]
[    0.236113] pci 0000:00:1c.1:   bridge window [mem 0xf0000000-0xf6ffffff 64bit pref]
[    0.236231] pci 0000:01:00.0: [1969:1062] type 0 class 0x000200
[    0.236272] pci 0000:01:00.0: reg 10: [mem 0xf7fc0000-0xf7ffffff 64bit]
[    0.236295] pci 0000:01:00.0: reg 18: [io  0xec00-0xec7f]
[    0.236448] pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.236461] pci 0000:01:00.0: PME# disabled
[    0.244071] pci 0000:00:1c.3: PCI bridge to [bus 01-01]
[    0.244087] pci 0000:00:1c.3:   bridge window [io  0xe000-0xefff]
[    0.244099] pci 0000:00:1c.3:   bridge window [mem 0xf7f00000-0xf7ffffff]
[    0.244114] pci 0000:00:1c.3:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.244228] pci 0000:00:1e.0: PCI bridge to [bus 05-05] (subtractive decode)
[    0.244242] pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.244255] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.244271] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.244282] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.244292] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.244302] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.244312] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000dffff] (subtractive decode)
[    0.244323] pci 0000:00:1e.0:   bridge window [mem 0x3f700000-0xfed8ffff] (subtractive decode)
[    0.244363] pci_bus 0000:00: on NUMA node 0
[    0.244380] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.244809] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
[    0.244931] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P5._PRT]
[    0.245017] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P7._PRT]
[    0.245092]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.245105]  pci0000:00: ACPI _OSC request failed (AE_NOT_FOUND), returned control mask: 0x1d
[    0.245113] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.265632] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11 12 14 *15)
[    0.265816] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.266013] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *7 10 11 12 14 15)
[    0.266195] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.266374] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.266554] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    0.266733] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 *4 5 6 7 10 11 12 14 15)
[    0.266931] ACPI: PCI Interrupt Link [LNKH] (IRQs *3 4 5 6 7 10 11 12 14 15)
[    0.267292] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.267322] vgaarb: loaded
[    0.267328] vgaarb: bridge control possible 0000:00:02.0
[    0.268222] SCSI subsystem initialized
[    0.268416] libata version 3.00 loaded.
[    0.268602] usbcore: registered new interface driver usbfs
[    0.268658] usbcore: registered new interface driver hub
[    0.268789] usbcore: registered new device driver usb
[    0.269155] PCI: Using ACPI for IRQ routing
[    0.269224] PCI: pci_cache_line_size set to 64 bytes
[    0.269357] reserve RAM buffer: 000000000009fc00 - 000000000009ffff 
[    0.269366] reserve RAM buffer: 000000003f690000 - 000000003fffffff 
[    0.269714] NetLabel: Initializing
[    0.269722] NetLabel:  domain hash size = 128
[    0.269727] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.269760] NetLabel:  unlabeled traffic allowed by default
[    0.269927] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.269940] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.269955] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.280187] Switching to clocksource hpet
[    0.283314] Switched to NOHz mode on CPU #0
[    0.283444] Switched to NOHz mode on CPU #1
[    0.301190] AppArmor: AppArmor Filesystem Enabled
[    0.301264] pnp: PnP ACPI init
[    0.301315] ACPI: bus type pnp registered
[    0.301606] pnp 00:00: [bus 00-ff]
[    0.301616] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.301625] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.301633] pnp 00:00: [io  0x0d00-0xffff window]
[    0.301642] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.301650] pnp 00:00: [mem 0x000d0000-0x000dffff window]
[    0.301659] pnp 00:00: [mem 0x3f700000-0xfed8ffff window]
[    0.301840] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.301881] pnp 00:01: [mem 0xfed14000-0xfed19fff]
[    0.301896] pnp 00:01: [mem 0xfed90000-0xfed93fff]
[    0.302029] system 00:01: [mem 0xfed14000-0xfed19fff] has been reserved
[    0.302041] system 00:01: [mem 0xfed90000-0xfed93fff] has been reserved
[    0.302053] system 00:01: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.302179] pnp 00:02: [dma 4]
[    0.302188] pnp 00:02: [io  0x0000-0x000f]
[    0.302195] pnp 00:02: [io  0x0081-0x0083]
[    0.302202] pnp 00:02: [io  0x0087]
[    0.302209] pnp 00:02: [io  0x0089-0x008b]
[    0.302216] pnp 00:02: [io  0x008f]
[    0.302223] pnp 00:02: [io  0x00c0-0x00df]
[    0.302333] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.302375] pnp 00:03: [io  0x0070-0x0071]
[    0.302398] pnp 00:03: [irq 8]
[    0.302481] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.302588] pnp 00:04: [io  0x0060]
[    0.302596] pnp 00:04: [io  0x0064]
[    0.302611] pnp 00:04: [irq 1]
[    0.302698] pnp 00:04: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
[    0.302802] pnp 00:05: [irq 12]
[    0.302900] pnp 00:05: Plug and Play ACPI device, IDs SYN0a13 SYN0a00 SYN0002 PNP0f13 (active)
[    0.302936] pnp 00:06: [io  0x0061]
[    0.303025] pnp 00:06: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.303064] pnp 00:07: [io  0x00f0-0x00ff]
[    0.303084] pnp 00:07: [irq 13]
[    0.303179] pnp 00:07: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.303593] pnp 00:08: [io  0x0010-0x001f]
[    0.303602] pnp 00:08: [io  0x0022-0x003f]
[    0.303610] pnp 00:08: [io  0x0044-0x004d]
[    0.303617] pnp 00:08: [io  0x0050-0x005e]
[    0.303624] pnp 00:08: [io  0x0063]
[    0.303631] pnp 00:08: [io  0x0065]
[    0.303638] pnp 00:08: [io  0x0067-0x006f]
[    0.303645] pnp 00:08: [io  0x0072-0x007f]
[    0.303652] pnp 00:08: [io  0x0080]
[    0.303659] pnp 00:08: [io  0x0084-0x0086]
[    0.303667] pnp 00:08: [io  0x0088]
[    0.303673] pnp 00:08: [io  0x008c-0x008e]
[    0.303681] pnp 00:08: [io  0x0090-0x009f]
[    0.303688] pnp 00:08: [io  0x00a2-0x00bf]
[    0.303695] pnp 00:08: [io  0x00e0-0x00ef]
[    0.303703] pnp 00:08: [io  0x025c-0x025f]
[    0.303710] pnp 00:08: [io  0x0380-0x0383]
[    0.303718] pnp 00:08: [io  0x0400-0x041f]
[    0.303725] pnp 00:08: [io  0x04d0-0x04d1]
[    0.303732] pnp 00:08: [io  0x0800-0x087f]
[    0.303740] pnp 00:08: [io  0x0400-0x03ff disabled]
[    0.303748] pnp 00:08: [io  0x0480-0x04bf]
[    0.303756] pnp 00:08: [mem 0xfed1c000-0xfed1ffff]
[    0.303764] pnp 00:08: [mem 0xfed20000-0xfed3ffff]
[    0.303772] pnp 00:08: [mem 0xfed50000-0xfed8ffff]
[    0.303780] pnp 00:08: [mem 0xffb00000-0xffbfffff]
[    0.303788] pnp 00:08: [mem 0xfff00000-0xffffffff]
[    0.303991] system 00:08: [io  0x025c-0x025f] has been reserved
[    0.304041] system 00:08: [io  0x0380-0x0383] has been reserved
[    0.304052] system 00:08: [io  0x0400-0x041f] has been reserved
[    0.304062] system 00:08: [io  0x04d0-0x04d1] has been reserved
[    0.304072] system 00:08: [io  0x0800-0x087f] has been reserved
[    0.304083] system 00:08: [io  0x0480-0x04bf] has been reserved
[    0.304096] system 00:08: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.304108] system 00:08: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.304118] system 00:08: [mem 0xfed50000-0xfed8ffff] has been reserved
[    0.304128] system 00:08: [mem 0xffb00000-0xffbfffff] has been reserved
[    0.304139] system 00:08: [mem 0xfff00000-0xffffffff] could not be reserved
[    0.304152] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.304376] pnp 00:09: [mem 0xfed00000-0xfed003ff]
[    0.304484] pnp 00:09: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.304665] pnp 00:0a: [mem 0xfec00000-0xfec00fff]
[    0.304674] pnp 00:0a: [mem 0xfee00000-0xfee00fff]
[    0.304813] system 00:0a: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.304825] system 00:0a: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.304837] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.304974] pnp 00:0b: [mem 0xe0000000-0xefffffff]
[    0.305117] system 00:0b: [mem 0xe0000000-0xefffffff] has been reserved
[    0.305129] system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.305876] pnp 00:0c: [mem 0x00000000-0x0009ffff]
[    0.305886] pnp 00:0c: [mem 0x000c0000-0x000cffff]
[    0.305895] pnp 00:0c: [mem 0x000e0000-0x000fffff]
[    0.305903] pnp 00:0c: [mem 0x00100000-0x3f6fffff]
[    0.305911] pnp 00:0c: [mem 0xfed90000-0xffffffff]
[    0.306116] system 00:0c: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.306128] system 00:0c: [mem 0x000c0000-0x000cffff] could not be reserved
[    0.306138] system 00:0c: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.306149] system 00:0c: [mem 0x00100000-0x3f6fffff] could not be reserved
[    0.306159] system 00:0c: [mem 0xfed90000-0xffffffff] could not be reserved
[    0.306172] system 00:0c: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.306813] pnp: PnP ACPI: found 13 devices
[    0.306821] ACPI: ACPI bus type pnp unregistered
[    0.306832] PnPBIOS: Disabled by ACPI PNP
[    0.347801] PCI: max bus depth: 1 pci_try_num: 2
[    0.347877] pci 0000:00:1c.3: BAR 15: assigned [mem 0x3f700000-0x3f8fffff 64bit pref]
[    0.347891] pci 0000:00:1c.1: BAR 13: assigned [io  0x1000-0x1fff]
[    0.347902] pci 0000:00:1c.0: BAR 14: assigned [mem 0x3f900000-0x3fafffff]
[    0.347915] pci 0000:00:1c.0: BAR 15: assigned [mem 0x3fb00000-0x3fcfffff 64bit pref]
[    0.347927] pci 0000:00:1c.0: BAR 13: assigned [io  0x2000-0x2fff]
[    0.347936] pci 0000:00:1c.0: PCI bridge to [bus 04-04]
[    0.347946] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.347958] pci 0000:00:1c.0:   bridge window [mem 0x3f900000-0x3fafffff]
[    0.347970] pci 0000:00:1c.0:   bridge window [mem 0x3fb00000-0x3fcfffff 64bit pref]
[    0.347985] pci 0000:00:1c.1: PCI bridge to [bus 02-03]
[    0.347995] pci 0000:00:1c.1:   bridge window [io  0x1000-0x1fff]
[    0.348043] pci 0000:00:1c.1:   bridge window [mem 0xf8000000-0xfbffffff]
[    0.348055] pci 0000:00:1c.1:   bridge window [mem 0xf0000000-0xf6ffffff 64bit pref]
[    0.348071] pci 0000:00:1c.3: PCI bridge to [bus 01-01]
[    0.348080] pci 0000:00:1c.3:   bridge window [io  0xe000-0xefff]
[    0.348093] pci 0000:00:1c.3:   bridge window [mem 0xf7f00000-0xf7ffffff]
[    0.348105] pci 0000:00:1c.3:   bridge window [mem 0x3f700000-0x3f8fffff 64bit pref]
[    0.348119] pci 0000:00:1e.0: PCI bridge to [bus 05-05]
[    0.348126] pci 0000:00:1e.0:   bridge window [io  disabled]
[    0.348137] pci 0000:00:1e.0:   bridge window [mem disabled]
[    0.348147] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.348171] pci 0000:00:1c.0: enabling device (0104 -> 0107)
[    0.348209] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.348222] pci 0000:00:1c.0: setting latency timer to 64
[    0.348237] pci 0000:00:1c.1: enabling device (0106 -> 0107)
[    0.348260] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.348271] pci 0000:00:1c.1: setting latency timer to 64
[    0.348299] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.348311] pci 0000:00:1c.3: setting latency timer to 64
[    0.348328] pci 0000:00:1e.0: setting latency timer to 64
[    0.348339] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.348348] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.348356] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.348365] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
[    0.348374] pci_bus 0000:00: resource 8 [mem 0x3f700000-0xfed8ffff]
[    0.348384] pci_bus 0000:04: resource 0 [io  0x2000-0x2fff]
[    0.348392] pci_bus 0000:04: resource 1 [mem 0x3f900000-0x3fafffff]
[    0.348402] pci_bus 0000:04: resource 2 [mem 0x3fb00000-0x3fcfffff 64bit pref]
[    0.348411] pci_bus 0000:02: resource 0 [io  0x1000-0x1fff]
[    0.348419] pci_bus 0000:02: resource 1 [mem 0xf8000000-0xfbffffff]
[    0.348429] pci_bus 0000:02: resource 2 [mem 0xf0000000-0xf6ffffff 64bit pref]
[    0.348438] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    0.348447] pci_bus 0000:01: resource 1 [mem 0xf7f00000-0xf7ffffff]
[    0.348456] pci_bus 0000:01: resource 2 [mem 0x3f700000-0x3f8fffff 64bit pref]
[    0.348465] pci_bus 0000:05: resource 4 [io  0x0000-0x0cf7]
[    0.348474] pci_bus 0000:05: resource 5 [io  0x0d00-0xffff]
[    0.348483] pci_bus 0000:05: resource 6 [mem 0x000a0000-0x000bffff]
[    0.348493] pci_bus 0000:05: resource 7 [mem 0x000d0000-0x000dffff]
[    0.348502] pci_bus 0000:05: resource 8 [mem 0x3f700000-0xfed8ffff]
[    0.348622] NET: Registered protocol family 2
[    0.348813] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.349672] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.350779] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.351331] TCP: Hash tables configured (established 131072 bind 65536)
[    0.351342] TCP reno registered
[    0.351359] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.351387] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.351697] NET: Registered protocol family 1
[    0.351745] pci 0000:00:02.0: Boot video device
[    0.351935] PCI: CLS 32 bytes, default 64
[    0.353002] audit: initializing netlink socket (disabled)
[    0.353030] type=2000 audit(1331369988.348:1): initialized
[    0.410049] highmem bounce pool size: 64 pages
[    0.410068] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.422101] VFS: Disk quotas dquot_6.5.2
[    0.422327] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.424878] fuse init (API version 7.16)
[    0.425245] msgmni has been set to 1704
[    0.426504] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.426625] io scheduler noop registered
[    0.426633] io scheduler deadline registered
[    0.426691] io scheduler cfq registered (default)
[    0.427036] pcieport 0000:00:1c.0: setting latency timer to 64
[    0.427120] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
[    0.427264] pcieport 0000:00:1c.1: setting latency timer to 64
[    0.427334] pcieport 0000:00:1c.1: irq 41 for MSI/MSI-X
[    0.427472] pcieport 0000:00:1c.3: setting latency timer to 64
[    0.427543] pcieport 0000:00:1c.3: irq 42 for MSI/MSI-X
[    0.427779] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.427884] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.428127] intel_idle: MWAIT substates: 0x20220
[    0.428146] intel_idle: v0.4 model 0x1C
[    0.428152] intel_idle: lapic_timer_reliable_states 0x2
[    0.428172] Marking TSC unstable due to TSC halts in idle states deeper than C2
[    0.428340] ACPI: Deprecated procfs I/F for AC is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    0.428491] ACPI: AC Adapter [AC0] (off-line)
[    0.428727] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
[    0.433451] ACPI: Lid Switch [LID]
[    0.433641] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
[    0.433656] ACPI: Sleep Button [SLPB]
[    0.433797] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2
[    0.433809] ACPI: Power Button [PWRB]
[    0.433962] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    0.433973] ACPI: Power Button [PWRF]
[    0.434076] ACPI: acpi_idle yielding to intel_idle
[    0.449549] thermal LNXTHERM:00: registered as thermal_zone0
[    0.449560] ACPI: Thermal Zone [TZ00] (58 C)
[    0.449658] ACPI: Deprecated procfs I/F for battery is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    0.449811] ERST: Table is not found!
[    0.450000] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    0.450538] isapnp: Scanning for PnP cards...
[    0.533394] ACPI: Battery Slot [BAT0] (battery present)
[    0.805153] isapnp: No Plug & Play device found
[    0.906631] Freeing initrd memory: 13324k freed
[    0.943165] Linux agpgart interface v0.103
[    0.943334] agpgart-intel 0000:00:00.0: Intel GMA3150 Chipset
[    0.943506] agpgart-intel 0000:00:00.0: detected gtt size: 524288K total, 262144K mappable
[    0.943744] agpgart-intel 0000:00:00.0: detected 8192K stolen memory
[    0.943981] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    0.947061] brd: module loaded
[    0.948565] loop: module loaded
[    0.949813] Fixed MDIO Bus: probed
[    0.949883] PPP generic driver version 2.4.2
[    0.949997] tun: Universal TUN/TAP device driver, 1.6
[    0.950002] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    0.950217] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.950288] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    0.950323] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    0.950331] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    0.950420] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    0.950460] ehci_hcd 0000:00:1d.7: using broken periodic workaround
[    0.950477] ehci_hcd 0000:00:1d.7: debug port 1
[    0.954353] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    0.954393] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf7cf7c00
[    0.968030] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    0.968325] hub 1-0:1.0: USB hub found
[    0.968337] hub 1-0:1.0: 8 ports detected
[    0.968495] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.968529] uhci_hcd: USB Universal Host Controller Interface driver
[    0.968600] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    0.968616] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    0.968623] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    0.968725] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    0.968767] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000d400
[    0.969058] hub 2-0:1.0: USB hub found
[    0.969069] hub 2-0:1.0: 2 ports detected
[    0.969198] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.969212] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    0.969219] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    0.969310] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    0.969366] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000d480
[    0.969661] hub 3-0:1.0: USB hub found
[    0.969673] hub 3-0:1.0: 2 ports detected
[    0.969816] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.969830] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    0.969837] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    0.969929] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    0.969983] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000d800
[    0.970267] hub 4-0:1.0: USB hub found
[    0.970278] hub 4-0:1.0: 2 ports detected
[    0.970400] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[    0.970414] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    0.970421] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    0.970523] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    0.970577] uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000d880
[    0.970859] hub 5-0:1.0: USB hub found
[    0.970870] hub 5-0:1.0: 2 ports detected
[    0.971123] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    0.988609] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.988630] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.988949] mousedev: PS/2 mouse device common for all mice
[    0.989899] rtc_cmos 00:03: RTC can wake from S4
[    0.990064] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    0.990103] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.990350] device-mapper: uevent: version 1.0.3
[    0.990553] device-mapper: ioctl: 4.20.0-ioctl (2011-02-02) initialised: dm-devel@redhat.com
[    0.990633] EISA: Probing bus 0 at eisa.0
[    0.990639] EISA: Cannot allocate resource for mainboard
[    0.990646] Cannot allocate resource for EISA slot 1
[    0.990651] Cannot allocate resource for EISA slot 2
[    0.990656] Cannot allocate resource for EISA slot 3
[    0.990662] Cannot allocate resource for EISA slot 4
[    0.990667] Cannot allocate resource for EISA slot 5
[    0.990672] Cannot allocate resource for EISA slot 6
[    0.990678] Cannot allocate resource for EISA slot 7
[    0.990683] Cannot allocate resource for EISA slot 8
[    0.990688] EISA: Detected 0 cards.
[    0.990705] cpufreq-nforce2: No nForce2 chipset.
[    0.990867] cpuidle: using governor ladder
[    0.991135] cpuidle: using governor menu
[    0.991140] EFI Variables Facility v0.08 2004-May-17
[    0.991774] TCP cubic registered
[    0.992153] NET: Registered protocol family 10
[    0.993510] NET: Registered protocol family 17
[    0.993557] Registering the dns_resolver key type
[    0.993599] Using IPI No-Shortcut mode
[    0.993838] PM: Hibernation image not present or could not be loaded.
[    0.993872] registered taskstats version 1
[    1.008284] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
[    1.012369]   Magic number: 4:22:978
[    1.012508] rtc_cmos 00:03: setting system clock to 2012-03-10 08:59:49 UTC (1331369989)
[    1.013462] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    1.013467] EDD information not available.
[    1.013713] Freeing unused kernel memory: 696k freed
[    1.014137] Write protecting the kernel text: 5344k
[    1.014224] Write protecting the kernel read-only data: 2188k
[    1.058436] udevd[81]: starting version 173
[    1.280130] usb 1-1: new high speed USB device number 2 using ehci_hcd
[    1.295107] atl1c 0000:01:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    1.295136] atl1c 0000:01:00.0: setting latency timer to 64
[    1.339188] ahci 0000:00:1f.2: version 3.0
[    1.339242] ahci 0000:00:1f.2: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    1.339336] ahci 0000:00:1f.2: irq 43 for MSI/MSI-X
[    1.339460] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0x1 impl SATA mode
[    1.339474] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part 
[    1.339487] ahci 0000:00:1f.2: setting latency timer to 64
[    1.342927] scsi0 : ahci
[    1.346063] scsi1 : ahci
[    1.349550] scsi2 : ahci
[    1.352916] scsi3 : ahci
[    1.353638] ata1: SATA max UDMA/133 abar m1024@0xf7cf7800 port 0xf7cf7900 irq 43
[    1.353649] ata2: DUMMY
[    1.353655] ata3: DUMMY
[    1.353660] ata4: DUMMY
[    1.393908] atl1c 0000:01:00.0: version 1.0.1.0-NAPI
[    1.524088] usb 1-6: new high speed USB device number 3 using ehci_hcd
[    1.672107] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.673238] ata1.00: unexpected _GTF length (8)
[    1.723350] ata1.00: ATA-8: ST9250315AS, 0002SDM1, max UDMA/133
[    1.723364] ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    1.725352] ata1.00: unexpected _GTF length (8)
[    1.725697] ata1.00: configured for UDMA/133
[    1.725978] scsi 0:0:0:0: Direct-Access     ATA      ST9250315AS      0002 PQ: 0 ANSI: 5
[    1.726495] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.726606] sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
[    1.726868] sd 0:0:0:0: [sda] Write Protect is off
[    1.726880] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.726996] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.775695]  sda: sda1 sda2 < sda5 > sda3
[    1.776756] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.132085] usb 5-1: new full speed USB device number 2 using uhci_hcd
[    2.266679] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[    5.591290] udevd[290]: starting version 173
[    5.877358] Adding 1999868k swap on /dev/sda5.  Priority:-1 extents:1 across:1999868k 
[    7.624202] lp: driver loaded but no devices found
[    7.913386] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro
[    8.313201] eeepc_laptop: Eee PC Hotkey Driver
[    8.313214] eeepc_laptop: wlan hotplug disabled
[    8.313329] eeepc_laptop: Hotkey init flags 0x41
[    8.329293] wmi: Mapper loaded
[    8.329973] eeepc_laptop: TYPE (2000000) not reported by BIOS, enabling anyway
[    8.339927] eeepc_laptop: PANELPOWER (4000000) not reported by BIOS, enabling anyway
[    8.344835] eeepc_laptop: TPD (8000000) not reported by BIOS, enabling anyway
[    8.344845] eeepc_laptop: Get control methods supported: 0xe101703
[    8.348879] input: Asus EeePC extra buttons as /devices/platform/eeepc/input/input5
[    8.376577] cfg80211: Calling CRDA to update world regulatory domain
[    8.380864] Registered led device: eeepc::touchpad
[    8.730461] [drm] Initialized drm 1.1.0 20060810
[    8.915587] asus_wmi: ASUS WMI generic driver loaded
[    8.986696] eeepc_wmi: Found legacy ATKD device (ASUS010)
[    8.986708] eeepc_wmi: WMI device present, but legacy ATKD device is also present and enabled
[    8.986716] eeepc_wmi: You probably booted with acpi_osi="Linux" or acpi_osi="!Windows 2009"
[    8.986722] eeepc_wmi: Can't load eeepc-wmi, use default acpi_osi (preferred) or eeepc-laptop
[    8.986740] eeepc-wmi: probe of eeepc-wmi failed with error -16
[    9.053397] Bluetooth: Core ver 2.16
[    9.053588] NET: Registered protocol family 31
[    9.053600] Bluetooth: HCI device and connection manager initialized
[    9.053609] Bluetooth: HCI socket layer initialized
[    9.053615] Bluetooth: L2CAP socket layer initialized
[    9.060097] Bluetooth: SCO socket layer initialized
[    9.104773] Bluetooth: Generic Bluetooth USB driver ver 0.6
[    9.256948] ath9k 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    9.256973] ath9k 0000:02:00.0: setting latency timer to 64
[    9.307517] ath: EEPROM regdomain: 0x60
[    9.307526] ath: EEPROM indicates we should expect a direct regpair map
[    9.307537] ath: Country alpha2 being used: 00
[    9.307543] ath: Regpair used: 0x60
[    9.307553] cfg80211: Updating information on frequency 2412 MHz for a 20 MHz width channel with regulatory rule:
[    9.307564] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 2000 mBm)
[    9.307573] cfg80211: Updating information on frequency 2417 MHz for a 20 MHz width channel with regulatory rule:
[    9.307583] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 2000 mBm)
[    9.307591] cfg80211: Updating information on frequency 2422 MHz for a 20 MHz width channel with regulatory rule:
[    9.307601] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 2000 mBm)
[    9.307609] cfg80211: Updating information on frequency 2427 MHz for a 20 MHz width channel with regulatory rule:
[    9.307618] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 2000 mBm)
[    9.307625] cfg80211: Updating information on frequency 2432 MHz for a 20 MHz width channel with regulatory rule:
[    9.307635] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 2000 mBm)
[    9.307643] cfg80211: Updating information on frequency 2437 MHz for a 20 MHz width channel with regulatory rule:
[    9.307653] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 2000 mBm)
[    9.307661] cfg80211: Updating information on frequency 2442 MHz for a 20 MHz width channel with regulatory rule:
[    9.307671] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 2000 mBm)
[    9.307679] cfg80211: Updating information on frequency 2447 MHz for a 20 MHz width channel with regulatory rule:
[    9.307689] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 2000 mBm)
[    9.307697] cfg80211: Updating information on frequency 2452 MHz for a 20 MHz width channel with regulatory rule:
[    9.307707] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 2000 mBm)
[    9.307715] cfg80211: Updating information on frequency 2457 MHz for a 20 MHz width channel with regulatory rule:
[    9.307725] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 2000 mBm)
[    9.307733] cfg80211: Updating information on frequency 2462 MHz for a 20 MHz width channel with regulatory rule:
[    9.307742] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (N/A mBi, 2000 mBm)
[    9.307750] cfg80211: Updating information on frequency 2467 MHz for a 20 MHz width channel with regulatory rule:
[    9.307760] cfg80211: 2457000 KHz - 2482000 KHz @  KHz), (N/A mBi, 2000 mBm)
[    9.307768] cfg80211: Updating information on frequency 2472 MHz for a 20 MHz width channel with regulatory rule:
[    9.307777] cfg80211: 2457000 KHz - 2482000 KHz @  KHz), (N/A mBi, 2000 mBm)
[    9.307785] cfg80211: Updating information on frequency 2484 MHz for a 20 MHz width channel with regulatory rule:
[    9.307795] cfg80211: 2474000 KHz - 2494000 KHz @  KHz), (N/A mBi, 2000 mBm)
[    9.310239] cfg80211: Ignoring regulatory request Set by core since the driver uses its own custom regulatory domain 
[    9.581414] usbcore: registered new interface driver btusb
[    9.779300] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    9.779312] i915 0000:00:02.0: setting latency timer to 64
[    9.820149] i915 0000:00:02.0: irq 44 for MSI/MSI-X
[    9.820166] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    9.820173] [drm] Driver supports precise vblank timestamp query.
[    9.856213] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    9.877777] Synaptics Touchpad, model: 1, fw: 7.2, id: 0x1a0b1, caps: 0xd04733/0xa40000/0xa0000
[    9.910459] composite sync not supported
[    9.950276] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input6
[   10.172323] [drm] initialized overlay support
[   10.172397] composite sync not supported
[   10.193718] fbcon: inteldrmfb (fb0) is primary device
[   10.193972] Console: switching to colour frame buffer device 128x37
[   10.194049] fb0: inteldrmfb frame buffer device
[   10.194056] drm: registered panic notifier
[   10.194620] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input7
[   10.194805] ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
[   10.194931] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[   10.245696] ieee80211 phy0: Selected rate control algorithm 'ath9k_rate_control'
[   10.247962] Registered led device: ath9k-phy0
[   10.247991] ieee80211 phy0: Atheros AR9285 Rev:2 mem=0xf8440000, irq=17
[   10.514826] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[   10.514939] HDA Intel 0000:00:1b.0: irq 45 for MSI/MSI-X
[   10.515001] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   10.549082] composite sync not supported
[   10.734475] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
[   10.734783] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[   11.087047] cfg80211: Ignoring regulatory request Set by core since the driver uses its own custom regulatory domain 
[   11.087057] cfg80211: World regulatory domain updated:
[   11.087062] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   11.087070] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   11.087077] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   11.087083] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   11.087090] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   11.087097] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   11.628670] Linux video capture interface: v2.00
[   11.771476] type=1400 audit(1331370000.253:2): apparmor="STATUS" operation="profile_load" name="/sbin/dhclient" pid=626 comm="apparmor_parser"
[   11.771503] type=1400 audit(1331370000.253:3): apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient" pid=654 comm="apparmor_parser"
[   11.772988] type=1400 audit(1331370000.257:4): apparmor="STATUS" operation="profile_load" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=626 comm="apparmor_parser"
[   11.773014] type=1400 audit(1331370000.257:5): apparmor="STATUS" operation="profile_replace" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=654 comm="apparmor_parser"
[   11.773902] type=1400 audit(1331370000.257:6): apparmor="STATUS" operation="profile_load" name="/usr/lib/connman/scripts/dhclient-script" pid=626 comm="apparmor_parser"
[   11.773954] type=1400 audit(1331370000.257:7): apparmor="STATUS" operation="profile_replace" name="/usr/lib/connman/scripts/dhclient-script" pid=654 comm="apparmor_parser"
[   11.776107] type=1400 audit(1331370000.261:8): apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient" pid=611 comm="apparmor_parser"
[   11.779950] type=1400 audit(1331370000.261:9): apparmor="STATUS" operation="profile_replace" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=611 comm="apparmor_parser"
[   11.780897] type=1400 audit(1331370000.265:10): apparmor="STATUS" operation="profile_replace" name="/usr/lib/connman/scripts/dhclient-script" pid=611 comm="apparmor_parser"
[   11.909370] uvcvideo: Found UVC 1.00 device USB2.0 UVC VGA WebCam (13d3:5111)
[   11.910990] input: USB2.0 UVC VGA WebCam as /devices/pci0000:00/0000:00:1d.7/usb1/1-6/1-6:1.0/input/input10
[   11.911263] usbcore: registered new interface driver uvcvideo
[   11.911272] USB Video Class driver (v1.1.0)
[   14.977015] init: failsafe main process (758) killed by TERM signal
[   17.505869] ppdev: user-space parallel port driver
[   18.009254] type=1400 audit(1331370006.493:11): apparmor="STATUS" operation="profile_load" name="/usr/lib/cups/backend/cups-pdf" pid=853 comm="apparmor_parser"
[   18.010963] type=1400 audit(1331370006.493:12): apparmor="STATUS" operation="profile_load" name="/usr/sbin/cupsd" pid=853 comm="apparmor_parser"
[   18.035416] type=1400 audit(1331370006.517:13): apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient" pid=866 comm="apparmor_parser"
[   18.036984] type=1400 audit(1331370006.521:14): apparmor="STATUS" operation="profile_replace" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=866 comm="apparmor_parser"
[   18.037882] type=1400 audit(1331370006.521:15): apparmor="STATUS" operation="profile_replace" name="/usr/lib/connman/scripts/dhclient-script" pid=866 comm="apparmor_parser"
[   18.047103] type=1400 audit(1331370006.529:16): apparmor="STATUS" operation="profile_load" name="/usr/lib/lightdm/lightdm-guest-session-wrapper" pid=865 comm="apparmor_parser"
[   18.740348] type=1400 audit(1331370007.225:17): apparmor="STATUS" operation="profile_load" name="/usr/lib/telepathy/mission-control-5" pid=870 comm="apparmor_parser"
[   18.741477] type=1400 audit(1331370007.225:18): apparmor="STATUS" operation="profile_load" name="/usr/lib/telepathy/telepathy-*" pid=870 comm="apparmor_parser"
[   18.750999] type=1400 audit(1331370007.233:19): apparmor="STATUS" operation="profile_replace" name="/usr/lib/cups/backend/cups-pdf" pid=874 comm="apparmor_parser"
[   18.752317] type=1400 audit(1331370007.237:20): apparmor="STATUS" operation="profile_replace" name="/usr/sbin/cupsd" pid=874 comm="apparmor_parser"
[   20.604926] init: apport pre-start process (920) terminated with status 1
[   20.612698] init: apport post-stop process (944) terminated with status 1
[   20.994223] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   21.009215] atl1c 0000:01:00.0: irq 46 for MSI/MSI-X
[   21.068878] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   22.697641] composite sync not supported
[   22.728279] composite sync not supported
[   24.228391] Bluetooth: RFCOMM TTY layer initialized
[   24.228410] Bluetooth: RFCOMM socket layer initialized
[   24.228417] Bluetooth: RFCOMM ver 1.11
[   24.291494] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   24.291504] Bluetooth: BNEP filters: protocol multicast
[   26.460312] init: anacron main process (938) killed by TERM signal
[   27.583494] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro,commit=600
[   29.063798] init: plymouth-stop pre-start process (1197) terminated with status 1
[   31.876341] composite sync not supported
[   35.897603] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro,commit=600
[   36.003007] composite sync not supported
[   40.598494] composite sync not supported
[   49.283713] composite sync not supported
[   50.830765] composite sync not supported
[   51.048407] composite sync not supported
[  463.149537] usb 1-1: USB disconnect, device number 2
[  464.656174] hub 1-0:1.0: unable to enumerate USB device on port 1
[  466.712177] usb 1-1: new high speed USB device number 6 using ehci_hcd
[  472.541630] usb 1-1: USB disconnect, device number 6
[  472.812155] usb 1-1: new high speed USB device number 7 using ehci_hcd
[  473.228320] usbcore: registered new interface driver cdc_ether
[  473.241702] rndis_host 1-1:1.0: usb0: register 'rndis_host' at usb-0000:00:1d.7-1, RNDIS device, 16:cf:87:89:74:c8
[  473.242770] usbcore: registered new interface driver rndis_host
[  483.936059] usb0: no IPv6 routers present
[  646.142882] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[  646.340097] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[  646.540078] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[  646.740079] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[  652.856221] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[  653.056109] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[  653.256108] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[  653.456115] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[  659.552295] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[  659.752072] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[  659.952096] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[  660.152078] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[  666.256813] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[  666.456079] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[  666.656092] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[  666.856070] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[  672.940819] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[  673.140068] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[  673.340096] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[  673.540086] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[  679.672831] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[  679.872073] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[  680.073891] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[  680.272426] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[  686.398852] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[  686.596062] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[  686.796782] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[  686.996079] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[  693.108853] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[  693.308069] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[  693.508115] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[  693.708128] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[  699.781825] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[  699.980090] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[  700.180095] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[  700.380119] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[  709.117237] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[  709.316088] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[  709.516053] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[  709.716065] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[  715.832834] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[  716.032088] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[  716.232108] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[  716.432115] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[  722.565741] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[  722.764072] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[  722.964064] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[  723.164064] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[  729.264741] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[  729.464115] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[  729.664110] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[  729.864122] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[  735.960846] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[  736.160074] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[  736.360093] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[  736.560097] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[  742.638457] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[  742.836070] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[  743.036073] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[  743.236084] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[  749.349167] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[  749.548106] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[  749.748086] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[  749.948099] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[  756.071796] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[  756.268076] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[  756.468078] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[  756.668074] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[  762.780849] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[  762.980074] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[  763.180088] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[  763.380058] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[  772.126745] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[  772.324075] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[  772.524088] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[  772.724060] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[  778.869270] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[  779.068078] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[  779.268095] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[  779.468069] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[  785.600847] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[  785.800093] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[  786.000169] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[  786.200100] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[  792.279370] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[  792.476075] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[  792.676071] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[  792.876064] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[  798.984829] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[  799.184112] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[  799.384111] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[  799.584092] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[  805.672376] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[  805.872075] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[  806.072081] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[  806.272061] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[  812.379401] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[  812.576091] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[  812.776098] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[  812.976126] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[  819.080823] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[  819.280062] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[  819.480075] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[  819.680090] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[  825.812882] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[  826.012684] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[  826.212080] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[  826.412090] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[  835.124808] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[  835.324095] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[  835.524155] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[  835.724081] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[  841.816786] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[  842.016115] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[  842.216122] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[  842.416080] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[  848.499842] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[  848.696078] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[  848.896070] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[  849.096067] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[  855.199517] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[  855.396127] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[  855.596098] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[  855.796099] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[  861.881361] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[  862.080073] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[  862.280110] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[  862.480075] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[  868.573540] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[  868.772058] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[  868.972121] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[  869.172083] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[  875.252060] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[  875.452110] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[  875.652134] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[  875.852093] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[  881.949180] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[  882.148086] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[  882.348097] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[  882.548063] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[  888.671345] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[  888.868081] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[  889.068092] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[  889.268066] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 1246.032845] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 1246.232098] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 1246.432090] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 1246.632089] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 1252.720387] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 1252.920121] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 1253.120095] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 1253.320075] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 1259.423683] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 1259.620105] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 1259.820098] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 1260.020087] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 1266.091739] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 1266.288084] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 1266.488096] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 1266.688117] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 1272.764831] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 1272.964085] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 1273.164084] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 1273.364094] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 1279.454801] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 1279.652073] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 1279.852069] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 1280.052062] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 1286.146399] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 1286.344081] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 1286.544115] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 1286.744075] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 1292.832835] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 1293.036123] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 1293.236080] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 1293.436082] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 1299.534765] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 1299.732077] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 1299.932092] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 1300.132080] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 1309.088807] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 1309.288109] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 1309.488093] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 1309.688124] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 1315.765338] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 1315.964093] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 1316.164095] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 1316.364107] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 1322.472942] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 1322.672097] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 1322.872095] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 1323.072069] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 1329.162932] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 1329.360934] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 1329.560094] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 1329.760128] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 1335.864829] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 1336.064111] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 1336.264103] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 1336.464097] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 1342.544488] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 1342.744094] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 1342.944092] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 1343.144128] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 1349.254952] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 1349.452092] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 1349.652102] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 1349.852115] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 1355.948454] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 1356.148078] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 1356.348093] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 1356.548079] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 1362.647452] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 1362.844108] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 1363.044107] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 1363.244114] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 1372.146832] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 1372.344088] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 1372.544060] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 1372.744072] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 1378.856859] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 1379.056113] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 1379.256111] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 1379.456108] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 1385.548855] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 1385.748394] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 1385.948064] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 1386.148117] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 1392.252913] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 1392.452109] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 1392.652083] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 1392.852124] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 1398.924297] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 1399.124087] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 1399.324095] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 1399.524077] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 1405.601483] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 1405.800134] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 1406.000170] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 1406.200096] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 1412.293749] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 1412.492096] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 1412.692086] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 1412.892075] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 1418.963257] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 1419.160120] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 1419.360080] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 1419.560092] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 1425.651873] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 1425.848074] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 1426.048132] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 1426.248072] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 1435.098072] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 1435.296070] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 1435.496110] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 1435.696108] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 1441.800846] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 1442.000072] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 1442.200075] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 1442.400065] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 1448.500862] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 1448.700123] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 1448.900170] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 1449.100098] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 1455.184854] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 1455.384107] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 1455.584091] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 1455.784114] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 1461.882854] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 1462.080093] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 1462.280113] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 1462.480095] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 1468.561774] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 1468.760253] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 1468.960119] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 1469.160096] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 1475.249446] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 1475.448077] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 1475.648107] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 1475.848085] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 1481.929039] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 1482.128077] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 1482.328084] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 1482.528130] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 1488.625308] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 1488.824079] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 1489.024085] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 1489.224114] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 1667.004074] atl1c 0000:01:00.0: vpd r/w failed.  This is likely a firmware bug on this device.  Contact the card vendor for a firmware update.
[ 1846.057487] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 1846.256136] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 1846.456113] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 1846.656100] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 1852.752408] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 1852.952077] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 1853.152087] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 1853.352071] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 1859.453386] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 1859.652066] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 1859.852134] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 1860.052107] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 1866.130214] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 1866.328080] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 1866.528073] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 1866.728061] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 1872.817783] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 1873.016072] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 1873.216068] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 1873.416094] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 1879.524128] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 1879.724093] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 1879.924120] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 1880.124094] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 1886.197168] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 1886.396117] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 1886.596100] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 1886.796113] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 1892.879992] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 1893.080070] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 1893.280070] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 1893.480061] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 1899.588866] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 1899.788090] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 1899.988091] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 1900.188090] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 1909.099915] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 1909.296085] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 1909.496135] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 1909.696112] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 1915.781326] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 1915.980084] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 1916.180097] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 1916.380115] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 1922.484187] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 1922.684100] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 1922.884112] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 1923.084122] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 1929.164143] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 1929.364083] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 1929.564083] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 1929.764146] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 1935.875561] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 1936.072094] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 1936.272082] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 1936.472123] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 1942.566473] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 1942.764127] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 1942.964078] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 1943.164089] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 1949.281493] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 1949.480074] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 1949.680074] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 1949.880104] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 1955.958981] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 1956.156131] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 1956.356109] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 1956.556079] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 1962.659352] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 1962.856081] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 1963.056075] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 1963.256093] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 1972.101334] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 1972.300118] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 1972.500104] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 1972.700116] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 1978.800855] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 1979.000078] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 1979.200096] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 1979.400055] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 1985.508925] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 1985.708069] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 1985.908068] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 1986.108085] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 1992.207268] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 1992.404076] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 1992.604076] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 1992.804107] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 1998.900863] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 1999.100091] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 1999.300066] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 1999.500093] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 2005.579630] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 2005.776123] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 2005.976100] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 2006.176065] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 2012.292856] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 2012.492148] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 2012.692069] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 2012.892076] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 2018.989627] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 2019.188122] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 2019.388072] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 2019.588119] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 2025.696834] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 2025.896076] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 2026.096088] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 2026.296088] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 2035.096439] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 2035.296065] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 2035.496126] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 2035.696108] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 2041.768231] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 2041.968119] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 2042.168116] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 2042.368077] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 2048.464840] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 2048.664076] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 2048.864098] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 2049.064077] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 2055.149122] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 2055.348095] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 2055.548097] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 2055.748078] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 2061.859210] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 2062.056084] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 2062.256082] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 2062.456065] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 2068.558889] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 2068.756077] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 2068.956124] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 2069.156091] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 2075.237255] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 2075.436098] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 2075.636070] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 2075.836079] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 2081.934996] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 2082.132068] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 2082.332088] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 2082.532111] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 2088.631596] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 2088.828068] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 2089.028068] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 2089.228070] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 2446.162075] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 2446.360072] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 2446.560065] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 2446.760067] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 2452.884852] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 2453.084074] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 2453.284199] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 2453.484096] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 2459.588200] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 2459.788128] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 2459.988147] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 2460.188117] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 2466.274256] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 2466.472170] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 2466.672073] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 2466.872078] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 2472.963263] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 2473.160108] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 2473.360121] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 2473.560111] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 2479.638592] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 2479.836106] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 2480.036140] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 2480.236079] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 2486.352884] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 2486.552121] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 2486.752130] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 2486.952097] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 2493.029210] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 2493.228131] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 2493.428128] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 2493.628497] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 2499.730146] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 2499.928085] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 2500.128079] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 2500.328062] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 2509.090098] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 2509.288104] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 2509.488120] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 2509.688123] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 2515.767726] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 2515.964134] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 2516.164417] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 2516.364530] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 2522.468503] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 2522.668125] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 2522.868085] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 2523.068097] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 2529.141769] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 2529.340117] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 2529.540087] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 2529.740111] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 2535.825954] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 2536.024073] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 2536.224132] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 2536.424065] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 2542.516570] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 2542.716079] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 2542.916079] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 2543.116086] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 2549.195339] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 2549.392083] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 2549.592113] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 2549.792139] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 2555.890296] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 2556.088085] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 2556.288112] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 2556.488091] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 2562.559622] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 2562.756082] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 2562.956096] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 2563.156141] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 2572.136230] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 2572.336072] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 2572.536093] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 2572.736084] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 2578.908862] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 2579.108074] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 2579.308077] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 2579.508075] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 2585.604827] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 2585.804092] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 2586.004099] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 2586.204118] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 2592.308816] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 2592.508119] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 2592.708114] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 2592.908104] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 2598.989587] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 2599.188100] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 2599.388070] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 2599.588082] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 2605.680460] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 2605.880084] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 2606.080085] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 2606.280120] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 2612.362133] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 2612.560082] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 2612.760099] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 2612.960083] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 2619.048860] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 2619.248087] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 2619.448083] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 2619.648074] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 2625.742669] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 2625.940102] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 2626.140083] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 2626.340085] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 2635.089993] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 2635.288137] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 2635.488122] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 2635.688112] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 2641.801247] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 2642.000459] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 2642.200097] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 2642.400114] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 2648.497665] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 2648.696080] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 2648.896097] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 2649.096117] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 2655.202866] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 2655.400087] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 2655.600627] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 2655.800115] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 2661.886091] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 2662.084117] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 2662.284096] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 2662.484098] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 2668.557054] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 2668.756101] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 2668.956122] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 2669.156072] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 2675.266814] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 2675.464136] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 2675.664087] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 2675.864117] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 2681.962806] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 2682.160103] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 2682.360076] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 2682.561334] wlan0: direct probe to 84:00:d2:20:0d:3a timed out
[ 2688.664971] wlan0: direct probe to 84:00:d2:20:0d:3a (try 1/3)
[ 2688.864092] wlan0: direct probe to 84:00:d2:20:0d:3a (try 2/3)
[ 2689.064120] wlan0: direct probe to 84:00:d2:20:0d:3a (try 3/3)
[ 2689.264096] wlan0: direct probe to 84:00:d2:20:0d:3a timed out

--------------010208010805060400050900--
