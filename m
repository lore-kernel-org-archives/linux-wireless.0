Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:63132 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754142Ab3C2Mqz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Mar 2013 08:46:55 -0400
Received: from mailout-de.gmx.net ([10.1.76.27]) by mrigmx.server.lan
 (mrigmx002) with ESMTP (Nemesis) id 0LnVZY-1UrsNW0J5S-00hiPm for
 <linux-wireless@vger.kernel.org>; Fri, 29 Mar 2013 13:46:52 +0100
Message-ID: <51558D37.7040508@gmx.de> (sfid-20130329_134704_135270_DAB7976D)
Date: Fri, 29 Mar 2013 13:46:47 +0100
From: Laurens <laurens.nikolaisen@gmx.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: =?ISO-8859-1?Q?Intel=AE_PRO/Wireless_3945ABG_seems_to_?=
 =?ISO-8859-1?Q?cause_system_freeze?=
Content-Type: multipart/mixed;
 boundary="------------020701090508020208070400"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020701090508020208070400
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Dear Driver Developers,

it seems like if the Intel 3945BG causes freezes to my computer system 
under Xubuntu 12.04.2. Though I am not very sure about it I'd like to 
ask you to go through my dmesg log. If you can point out if it's the 
wireless card which causes trouble please let me know. Also if you know 
how to fix that I would much appreciate that!

There is one log called dmesg, including the whole log, and one with 
this request:

dmesg_wifi.txt

dmesg | egrep 'net|eth|sky|sis|via|3c3|3c5|e100|8139|8169|acx|air|ath|atl|ar9|carl|atme|at7|herm|iwl|ipw|rtl8|r81|rt2|rt3|rt6|rt7|tg3|ssb|wl|b43|b44|ori|pri|p5|zd|ndis|wmi|ns8|FW'

...called dmesg wifi.

Additional infos:

Linux 3.8.0-14-generic #24-Ubuntu SMP Fri Mar 22 19:45:03 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux

Many thanks for your help,

Laurens Nikolaisen



--------------020701090508020208070400
Content-Type: text/plain; charset=UTF-8;
 name="dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.2.0-39-generic (buildd@lamiak) (gcc version 4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5) ) #62-Ubuntu SMP Thu Feb 28 00:28:53 UTC 2013 (Ubuntu 3.2.0-39.62-generic 3.2.39)
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.2.0-39-generic root=UUID=79c775f2-3ce0-411d-ac31-b2b842fdab87 ro hpet=force clocksource=hpet quiet splash vt.handoff=7
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000ce000 - 00000000000d0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007fe80000 (usable)
[    0.000000]  BIOS-e820: 000000007fe80000 - 000000007ff00000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007ff00000 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.3 present.
[    0.000000] DMI: Acer             TravelMate 4280 /Grapevine, BIOS V3.23 12/09/2006
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x7fe80 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-DFFFF uncachable
[    0.000000]   E0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 07FF00000 mask FFFF00000 uncachable
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 2047MB, range: 1MB, type UC
[    0.000000] total RAM covered: 2047M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K 	chunk_size: 2M 	num_reg: 2  	lose cover RAM: 0G
[    0.000000] New variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 2047MB, range: 1MB, type UC
[    0.000000] found SMP MP-table at [ffff8800000f6450] f6450
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff88000009a000] 9a000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-000000007fe80000
[    0.000000]  0000000000 - 007fe00000 page 2M
[    0.000000]  007fe00000 - 007fe80000 page 4k
[    0.000000] kernel direct mapping tables up to 7fe80000 @ 1fffc000-20000000
[    0.000000] RAMDISK: 364d8000 - 37264000
[    0.000000] ACPI: RSDP 00000000000f63a0 00014 (v00 ACRSYS)
[    0.000000] ACPI: RSDT 000000007fe85192 00058 (v01 ACRSYS ACRPRDCT 06040000  LTP 00000000)
[    0.000000] ACPI: FACP 000000007fe8cc76 00074 (v01 Acer   Grape    06040000 LOHR 0000005A)
[    0.000000] ACPI: DSDT 000000007fe86ebb 05DBB (v01 Acer   CALISTGA 06040000 INTL 20050228)
[    0.000000] ACPI: FACS 000000007fe8dfc0 00040
[    0.000000] ACPI: APIC 000000007fe8ccea 00068 (v01 Acer   Grape    06040000 LOHR 0000005A)
[    0.000000] ACPI: HPET 000000007fe8cd52 00038 (v01 Acer   Grape    06040000 LOHR 0000005A)
[    0.000000] ACPI: MCFG 000000007fe8cd8a 0003C (v01 Acer   Grape    06040000 LOHR 0000005A)
[    0.000000] ACPI: SLIC 000000007fe8cdc6 00176 (v01 ACRSYS ACRPRDCT 06040000 LOHR 00000000)
[    0.000000] ACPI: DBGP 000000007fe8cf3c 00034 (v01 Acer   Grape    06040000 LOHR 00000000)
[    0.000000] ACPI: APIC 000000007fe8cf70 00068 (v01 PTLTD  ? APIC   06040000  LTP 00000000)
[    0.000000] ACPI: BOOT 000000007fe8cfd8 00028 (v01 PTLTD  $SBFTBL$ 06040000  LTP 00000001)
[    0.000000] ACPI: SSDT 000000007fe8686c 0064F (v01 SataRe  SataPri 00001000 INTL 20050228)
[    0.000000] ACPI: SSDT 000000007fe861da 00692 (v01 SataRe  SataSec 00001000 INTL 20050228)
[    0.000000] ACPI: SSDT 000000007fe85776 0025F (v01  PmRef  Cpu0Tst 00003000 INTL 20050228)
[    0.000000] ACPI: SSDT 000000007fe856d0 000A6 (v01  PmRef  Cpu1Tst 00003000 INTL 20050228)
[    0.000000] ACPI: SSDT 000000007fe851ea 004E6 (v01  PmRef    CpuPm 00003000 INTL 20050228)
[    0.000000] ACPI: BIOS bug: multiple APIC/MADT found, using 0
[    0.000000] ACPI: If "acpi_apic_instance=2" works better, notify linux-acpi@vger.kernel.org
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000007fe80000
[    0.000000] Initmem setup node 0 0000000000000000-000000007fe80000
[    0.000000]   NODE_DATA [000000007fe7b000 - 000000007fe7ffff]
[    0.000000]  [ffffea0000000000-ffffea0001ffffff] PMD -> [ffff88007d600000-ffff88007f5fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   empty
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0007fe80
[    0.000000] On node 0 totalpages: 523791
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3914 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 8122 pages used for memmap
[    0.000000]   DMA32 zone: 511686 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000ce000
[    0.000000] PM: Registered nosave memory: 00000000000ce000 - 00000000000d0000
[    0.000000] PM: Registered nosave memory: 00000000000d0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 80000000 (gap: 80000000:60000000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88007fc00000 s83136 r8192 d23360 u1048576
[    0.000000] pcpu-alloc: s83136 r8192 d23360 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 515600
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.2.0-39-generic root=UUID=79c775f2-3ce0-411d-ac31-b2b842fdab87 ro hpet=force clocksource=hpet quiet splash vt.handoff=7
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 2032468k/2095616k available (6571k kernel code, 452k absent, 62696k reserved, 6632k data, 920k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] NR_IRQS:16640 nr_irqs:512 16
[    0.000000] vt handoff: transparent VT on vt#7
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 16777216 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1662.421 MHz processor.
[    0.004006] Calibrating delay loop (skipped), value calculated using timer frequency.. 3324.84 BogoMIPS (lpj=6649684)
[    0.004016] pid_max: default: 32768 minimum: 301
[    0.004067] Security Framework initialized
[    0.004104] AppArmor: AppArmor initialized
[    0.004108] Yama: becoming mindful.
[    0.008218] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.009831] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.010773] Mount-cache hash table entries: 256
[    0.011058] Initializing cgroup subsys cpuacct
[    0.011070] Initializing cgroup subsys memory
[    0.011090] Initializing cgroup subsys devices
[    0.011095] Initializing cgroup subsys freezer
[    0.011099] Initializing cgroup subsys blkio
[    0.011115] Initializing cgroup subsys perf_event
[    0.011184] CPU: Physical Processor ID: 0
[    0.011188] CPU: Processor Core ID: 0
[    0.011193] mce: CPU supports 6 MCE banks
[    0.011208] CPU0: Thermal monitoring enabled (TM2)
[    0.011215] using mwait in idle threads.
[    0.016842] ACPI: Core revision 20110623
[    0.028023] ftrace: allocating 26551 entries in 105 pages
[    0.032603] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.073903] CPU0: Intel(R) Core(TM)2 CPU         T5500  @ 1.66GHz stepping 02
[    0.076004] APIC calibration not consistent with PM-Timer: 207ms instead of 100ms
[    0.076004] APIC delta adjusted to PM-Timer: 1039060 (2161222)
[    0.076004] Performance Events: PEBS fmt0-, Core2 events, Intel PMU driver.
[    0.076004] PEBS disabled due to CPU errata.
[    0.076004] ... version:                2
[    0.076004] ... bit width:              40
[    0.076004] ... generic registers:      2
[    0.076004] ... value mask:             000000ffffffffff
[    0.076004] ... max period:             000000007fffffff
[    0.076004] ... fixed-purpose events:   3
[    0.076004] ... event mask:             0000000700000003
[    0.076004] NMI watchdog enabled, takes one hw-pmu counter.
[    0.076004] Booting Node   0, Processors  #1 Ok.
[    0.076004] smpboot cpu 1: start_ip = 9a000
[    0.164063] NMI watchdog enabled, takes one hw-pmu counter.
[    0.164146] Brought up 2 CPUs
[    0.164151] Total of 2 processors activated (6649.93 BogoMIPS).
[    0.166620] devtmpfs: initialized
[    0.169202] EVM: security.selinux
[    0.169206] EVM: security.SMACK64
[    0.169210] EVM: security.capability
[    0.169235] PM: Registering ACPI NVS region at 7fe80000 (524288 bytes)
[    0.169834] print_constraints: dummy: 
[    0.169888] RTC time: 17:39:32, date: 03/27/13
[    0.169961] NET: Registered protocol family 16
[    0.170021] Trying to unpack rootfs image as initramfs...
[    0.170276] ACPI: bus type pci registered
[    0.170414] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.170422] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.246453] PCI: Using configuration type 1 for base access
[    0.249048] bio: create slab <bio-0> at 0
[    0.249258] ACPI: Added _OSI(Module Device)
[    0.249264] ACPI: Added _OSI(Processor Device)
[    0.249268] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.249273] ACPI: Added _OSI(Processor Aggregator Device)
[    0.252137] ACPI: EC: Look up EC in DSDT
[    0.257926] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.258950] ACPI: SSDT 000000007fe85f1c 001F6 (v01  PmRef  Cpu0Ist 00003000 INTL 20050228)
[    0.259658] ACPI: Dynamic OEM Table Load:
[    0.259666] ACPI: SSDT           (null) 001F6 (v01  PmRef  Cpu0Ist 00003000 INTL 20050228)
[    0.259890] ACPI: SSDT 000000007fe859d5 004C2 (v01  PmRef  Cpu0Cst 00003001 INTL 20050228)
[    0.260580] ACPI: Dynamic OEM Table Load:
[    0.260587] ACPI: SSDT           (null) 004C2 (v01  PmRef  Cpu0Cst 00003001 INTL 20050228)
[    0.261014] ACPI: SSDT 000000007fe86112 000C8 (v01  PmRef  Cpu1Ist 00003000 INTL 20050228)
[    0.261710] ACPI: Dynamic OEM Table Load:
[    0.261717] ACPI: SSDT           (null) 000C8 (v01  PmRef  Cpu1Ist 00003000 INTL 20050228)
[    0.261880] ACPI: SSDT 000000007fe85e97 00085 (v01  PmRef  Cpu1Cst 00003000 INTL 20050228)
[    0.262555] ACPI: Dynamic OEM Table Load:
[    0.262562] ACPI: SSDT           (null) 00085 (v01  PmRef  Cpu1Cst 00003000 INTL 20050228)
[    0.263174] ACPI: Interpreter enabled
[    0.263182] ACPI: (supports S0 S3 S4 S5)
[    0.263220] ACPI: Using IOAPIC for interrupt routing
[    0.314949] ACPI: EC: GPE = 0x19, I/O: command/status = 0x66, data = 0x62
[    0.315325] ACPI: No dock devices found.
[    0.315330] HEST: Table not found.
[    0.315337] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.315876] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.316912] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.316919] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.316925] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.316931] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000d3fff] (ignored)
[    0.316937] pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000d7fff] (ignored)
[    0.316942] pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000dbfff] (ignored)
[    0.316948] pci_root PNP0A08:00: host bridge window [mem 0x000dc000-0x000dffff] (ignored)
[    0.316955] pci_root PNP0A08:00: host bridge window [mem 0x80000000-0xfebfffff] (ignored)
[    0.316978] pci 0000:00:00.0: [8086:27a0] type 0 class 0x000600
[    0.317072] pci 0000:00:01.0: [8086:27a1] type 1 class 0x000604
[    0.317158] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.317166] pci 0000:00:01.0: PME# disabled
[    0.317261] pci 0000:00:1b.0: [8086:27d8] type 0 class 0x000403
[    0.317292] pci 0000:00:1b.0: reg 10: [mem 0xd2500000-0xd2503fff 64bit]
[    0.317433] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.317441] pci 0000:00:1b.0: PME# disabled
[    0.317484] pci 0000:00:1c.0: [8086:27d0] type 1 class 0x000604
[    0.317629] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.317637] pci 0000:00:1c.0: PME# disabled
[    0.317688] pci 0000:00:1c.1: [8086:27d2] type 1 class 0x000604
[    0.317835] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.317843] pci 0000:00:1c.1: PME# disabled
[    0.317889] pci 0000:00:1c.2: [8086:27d4] type 1 class 0x000604
[    0.318034] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.318043] pci 0000:00:1c.2: PME# disabled
[    0.318088] pci 0000:00:1c.3: [8086:27d6] type 1 class 0x000604
[    0.318234] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.318242] pci 0000:00:1c.3: PME# disabled
[    0.318288] pci 0000:00:1d.0: [8086:27c8] type 0 class 0x000c03
[    0.318363] pci 0000:00:1d.0: reg 20: [io  0x50a0-0x50bf]
[    0.318423] pci 0000:00:1d.1: [8086:27c9] type 0 class 0x000c03
[    0.318499] pci 0000:00:1d.1: reg 20: [io  0x50c0-0x50df]
[    0.318559] pci 0000:00:1d.2: [8086:27ca] type 0 class 0x000c03
[    0.318633] pci 0000:00:1d.2: reg 20: [io  0x50e0-0x50ff]
[    0.318692] pci 0000:00:1d.3: [8086:27cb] type 0 class 0x000c03
[    0.318767] pci 0000:00:1d.3: reg 20: [io  0x5400-0x541f]
[    0.318843] pci 0000:00:1d.7: [8086:27cc] type 0 class 0x000c03
[    0.318877] pci 0000:00:1d.7: reg 10: [mem 0xd2504000-0xd25043ff]
[    0.319019] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.319028] pci 0000:00:1d.7: PME# disabled
[    0.319066] pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
[    0.319196] pci 0000:00:1f.0: [8086:27b9] type 0 class 0x000601
[    0.319339] pci 0000:00:1f.0: quirk: [io  0x1000-0x107f] claimed by ICH6 ACPI/GPIO/TCO
[    0.319350] pci 0000:00:1f.0: quirk: [io  0x1180-0x11bf] claimed by ICH6 GPIO
[    0.319361] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at ff20 (mask 000f)
[    0.319448] pci 0000:00:1f.2: [8086:27c4] type 0 class 0x000101
[    0.319477] pci 0000:00:1f.2: reg 10: [io  0x0000-0x0007]
[    0.319495] pci 0000:00:1f.2: reg 14: [io  0x0000-0x0003]
[    0.319512] pci 0000:00:1f.2: reg 18: [io  0x0000-0x0007]
[    0.319530] pci 0000:00:1f.2: reg 1c: [io  0x0000-0x0003]
[    0.319548] pci 0000:00:1f.2: reg 20: [io  0x5440-0x544f]
[    0.319623] pci 0000:00:1f.2: PME# supported from D3hot
[    0.319631] pci 0000:00:1f.2: PME# disabled
[    0.319658] pci 0000:00:1f.3: [8086:27da] type 0 class 0x000c05
[    0.319751] pci 0000:00:1f.3: reg 20: [io  0x5420-0x543f]
[    0.319891] pci 0000:01:00.0: [10de:0398] type 0 class 0x000300
[    0.319909] pci 0000:01:00.0: reg 10: [mem 0xd1000000-0xd1ffffff]
[    0.319928] pci 0000:01:00.0: reg 14: [mem 0xc0000000-0xcfffffff 64bit pref]
[    0.319948] pci 0000:01:00.0: reg 1c: [mem 0xd0000000-0xd0ffffff 64bit]
[    0.319962] pci 0000:01:00.0: reg 24: [io  0x6000-0x607f]
[    0.319976] pci 0000:01:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.320059] pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.320075] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.320082] pci 0000:00:01.0:   bridge window [io  0x6000-0x6fff]
[    0.320089] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xd1ffffff]
[    0.320099] pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xcfffffff 64bit pref]
[    0.320182] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.320281] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.320422] pci 0000:04:00.0: [14e4:1693] type 0 class 0x000200
[    0.320463] pci 0000:04:00.0: reg 10: [mem 0xd2000000-0xd200ffff 64bit]
[    0.320690] pci 0000:04:00.0: PME# supported from D3hot D3cold
[    0.320700] pci 0000:04:00.0: PME# disabled
[    0.328056] pci 0000:00:1c.2: PCI bridge to [bus 04-04]
[    0.328070] pci 0000:00:1c.2:   bridge window [mem 0xd2000000-0xd20fffff]
[    0.328235] pci 0000:05:00.0: [8086:4222] type 0 class 0x000280
[    0.328299] pci 0000:05:00.0: reg 10: [mem 0xd2100000-0xd2100fff]
[    0.328759] pci 0000:05:00.0: PME# supported from D0 D3hot D3cold
[    0.328776] pci 0000:05:00.0: PME# disabled
[    0.328853] pci 0000:05:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.328899] pci 0000:00:1c.3: PCI bridge to [bus 05-05]
[    0.328911] pci 0000:00:1c.3:   bridge window [mem 0xd2100000-0xd21fffff]
[    0.328985] pci 0000:06:00.0: [1106:3044] type 0 class 0x000c00
[    0.329020] pci 0000:06:00.0: reg 10: [mem 0xd2201000-0xd22017ff]
[    0.329041] pci 0000:06:00.0: reg 14: [io  0x7000-0x707f]
[    0.329175] pci 0000:06:00.0: supports D2
[    0.329180] pci 0000:06:00.0: PME# supported from D2 D3hot D3cold
[    0.329189] pci 0000:06:00.0: PME# disabled
[    0.329236] pci 0000:06:04.0: [1524:1412] type 2 class 0x000607
[    0.329271] pci 0000:06:04.0: reg 10: [mem 0x00000000-0x00000fff]
[    0.329327] pci 0000:06:04.0: supports D1 D2
[    0.329331] pci 0000:06:04.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.329340] pci 0000:06:04.0: PME# disabled
[    0.329375] pci 0000:06:04.1: [1524:0530] type 0 class 0x000501
[    0.329410] pci 0000:06:04.1: reg 10: [mem 0xd2201800-0xd220187f]
[    0.329557] pci 0000:06:04.1: supports D1 D2
[    0.329562] pci 0000:06:04.1: PME# supported from D0 D1 D2 D3hot
[    0.329571] pci 0000:06:04.1: PME# disabled
[    0.329605] pci 0000:06:04.2: [1524:0550] type 0 class 0x000805
[    0.329640] pci 0000:06:04.2: reg 10: [mem 0xd2201c00-0xd2201cff]
[    0.329789] pci 0000:06:04.2: supports D1 D2
[    0.329793] pci 0000:06:04.2: PME# supported from D0 D1 D2 D3hot
[    0.329802] pci 0000:06:04.2: PME# disabled
[    0.329836] pci 0000:06:04.3: [1524:0520] type 0 class 0x000501
[    0.329871] pci 0000:06:04.3: reg 10: [mem 0xd2202000-0xd220207f]
[    0.330020] pci 0000:06:04.3: supports D1 D2
[    0.330024] pci 0000:06:04.3: PME# supported from D0 D1 D2 D3hot
[    0.330034] pci 0000:06:04.3: PME# disabled
[    0.330068] pci 0000:06:04.4: [1524:0551] type 0 class 0x000501
[    0.330103] pci 0000:06:04.4: reg 10: [mem 0x00000000-0x000000ff]
[    0.330252] pci 0000:06:04.4: supports D1 D2
[    0.330256] pci 0000:06:04.4: PME# supported from D0 D1 D2 D3hot
[    0.330265] pci 0000:06:04.4: PME# disabled
[    0.330351] pci 0000:00:1e.0: PCI bridge to [bus 06-07] (subtractive decode)
[    0.330360] pci 0000:00:1e.0:   bridge window [io  0x7000-0x7fff]
[    0.330369] pci 0000:00:1e.0:   bridge window [mem 0xd2200000-0xd22fffff]
[    0.330382] pci 0000:00:1e.0:   bridge window [io  0x0000-0xffff] (subtractive decode)
[    0.330388] pci 0000:00:1e.0:   bridge window [mem 0x00000000-0xfffffffff] (subtractive decode)
[    0.330459] pci_bus 0000:07: [bus 07-0a] partially hidden behind transparent bridge 0000:06 [bus 06-07]
[    0.330518] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.330787] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEGP._PRT]
[    0.330886] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.330963] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.331038] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
[    0.331124] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
[    0.331244] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    0.331398]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.331406]  pci0000:00: ACPI _OSC request failed (AE_NOT_FOUND), returned control mask: 0x1d
[    0.331410] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.338733] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 5 *6 10 12 14 15)
[    0.338839] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 5 6 *11 12 14 15)
[    0.338938] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 5 6 10 12 14 15) *11
[    0.339037] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 5 6 11 12 14 15) *10
[    0.339135] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 5 6 *10 12 14 15)
[    0.339232] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 5 6 11 12 14 15) *0, disabled.
[    0.339332] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 5 6 *10 12 14 15)
[    0.339429] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 *5 6 11 12 14 15)
[    0.339710] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.339726] vgaarb: loaded
[    0.339729] vgaarb: bridge control possible 0000:01:00.0
[    0.339981] i2c-core: driver [aat2870] using legacy suspend method
[    0.339985] i2c-core: driver [aat2870] using legacy resume method
[    0.340173] SCSI subsystem initialized
[    0.340302] libata version 3.00 loaded.
[    0.340418] usbcore: registered new interface driver usbfs
[    0.340444] usbcore: registered new interface driver hub
[    0.340506] usbcore: registered new device driver usb
[    0.340710] PCI: Using ACPI for IRQ routing
[    0.354194] PCI: pci_cache_line_size set to 64 bytes
[    0.354404] reserve RAM buffer: 000000000009f800 - 000000000009ffff 
[    0.354410] reserve RAM buffer: 000000007fe80000 - 000000007fffffff 
[    0.354652] NetLabel: Initializing
[    0.354657] NetLabel:  domain hash size = 128
[    0.354660] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.354690] NetLabel:  unlabeled traffic allowed by default
[    0.354809] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.354819] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.354830] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.360134] Switching to clocksource hpet
[    0.378146] AppArmor: AppArmor Filesystem Enabled
[    0.378205] pnp: PnP ACPI init
[    0.378246] ACPI: bus type pnp registered
[    0.378849] pnp 00:00: [bus 00-ff]
[    0.378856] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.378862] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.378866] pnp 00:00: [io  0x0d00-0xffff window]
[    0.378873] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.378879] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    0.378885] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    0.378891] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    0.378897] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    0.378904] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    0.378909] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    0.378915] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    0.378921] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    0.378927] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    0.378933] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    0.378939] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    0.378944] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    0.378950] pnp 00:00: [mem 0x000f0000-0x000fffff window]
[    0.378956] pnp 00:00: [mem 0x80000000-0xfebfffff window]
[    0.378962] pnp 00:00: [mem 0xfed40000-0xfed44fff window]
[    0.379124] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.379149] pnp 00:01: [mem 0xe0000000-0xefffffff]
[    0.379154] pnp 00:01: [mem 0xfed14000-0xfed17fff]
[    0.379164] pnp 00:01: [mem 0xfed18000-0xfed18fff]
[    0.379169] pnp 00:01: [mem 0xfed19000-0xfed19fff]
[    0.379173] pnp 00:01: [mem 0xfed1c000-0xfed1ffff]
[    0.379178] pnp 00:01: [mem 0xfed20000-0xfed3ffff]
[    0.379312] system 00:01: [mem 0xe0000000-0xefffffff] has been reserved
[    0.379319] system 00:01: [mem 0xfed14000-0xfed17fff] has been reserved
[    0.379325] system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.379331] system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.379337] system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.379343] system 00:01: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.379351] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.400095] pnp 00:02: [io  0x0000-0x001f]
[    0.400102] pnp 00:02: [io  0x0081-0x0091]
[    0.400107] pnp 00:02: [io  0x0093-0x009f]
[    0.400110] pnp 00:02: [io  0x00c0-0x00df]
[    0.400115] pnp 00:02: [dma 4]
[    0.400271] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.400294] pnp 00:03: [mem 0xff000000-0xffffffff]
[    0.400389] pnp 00:03: Plug and Play ACPI device, IDs INT0800 (active)
[    0.400544] pnp 00:04: [mem 0xfed00000-0xfed003ff]
[    0.400711] system 00:04: [mem 0xfed00000-0xfed003ff] has been reserved
[    0.400720] system 00:04: Plug and Play ACPI device, IDs PNP0103 PNP0c01 (active)
[    0.400746] pnp 00:05: [io  0x00f0]
[    0.400765] pnp 00:05: [irq 13]
[    0.400865] pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.400914] pnp 00:06: [io  0x002e-0x002f]
[    0.400919] pnp 00:06: [io  0x004e-0x004f]
[    0.400924] pnp 00:06: [io  0x0061]
[    0.400928] pnp 00:06: [io  0x0063]
[    0.400932] pnp 00:06: [io  0x0065]
[    0.400935] pnp 00:06: [io  0x0067]
[    0.400939] pnp 00:06: [io  0x0070]
[    0.400943] pnp 00:06: [io  0x0080]
[    0.400947] pnp 00:06: [io  0x0092]
[    0.400951] pnp 00:06: [io  0x00b2-0x00b3]
[    0.400955] pnp 00:06: [io  0x0800-0x080f]
[    0.400959] pnp 00:06: [io  0x1000-0x107f]
[    0.400964] pnp 00:06: [io  0x1180-0x11bf]
[    0.400968] pnp 00:06: [io  0x1640-0x164f]
[    0.400972] pnp 00:06: [io  0xfe00-0xfefe]
[    0.400976] pnp 00:06: [io  0xff2c-0xff2f]
[    0.401140] system 00:06: [io  0x0800-0x080f] has been reserved
[    0.401147] system 00:06: [io  0x1000-0x107f] has been reserved
[    0.401153] system 00:06: [io  0x1180-0x11bf] has been reserved
[    0.401159] system 00:06: [io  0x1640-0x164f] has been reserved
[    0.401165] system 00:06: [io  0xfe00-0xfefe] has been reserved
[    0.401170] system 00:06: [io  0xff2c-0xff2f] has been reserved
[    0.401178] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.401199] pnp 00:07: [io  0x0070-0x0077]
[    0.401210] pnp 00:07: [irq 8]
[    0.401306] pnp 00:07: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.401330] pnp 00:08: [io  0x0060]
[    0.401334] pnp 00:08: [io  0x0064]
[    0.401345] pnp 00:08: [irq 1]
[    0.401444] pnp 00:08: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.401529] pnp 00:09: [irq 12]
[    0.401641] pnp 00:09: Plug and Play ACPI device, IDs SYN0703 SYN0700 SYN0002 PNP0f13 (active)
[    0.401746] pnp: PnP ACPI: found 10 devices
[    0.401751] ACPI: ACPI bus type pnp unregistered
[    0.410610] PCI: max bus depth: 2 pci_try_num: 3
[    0.410735] pci 0000:00:1e.0: BAR 15: assigned [mem 0x80000000-0x83ffffff pref]
[    0.410744] pci 0000:00:1c.3: BAR 15: assigned [mem 0x84000000-0x841fffff 64bit pref]
[    0.410753] pci 0000:00:1c.3: BAR 13: assigned [io  0x2000-0x2fff]
[    0.410760] pci 0000:00:1c.2: BAR 15: assigned [mem 0x84200000-0x843fffff 64bit pref]
[    0.410768] pci 0000:00:1c.2: BAR 13: assigned [io  0x3000-0x3fff]
[    0.410774] pci 0000:00:1c.1: BAR 14: assigned [mem 0x84400000-0x845fffff]
[    0.410781] pci 0000:00:1c.1: BAR 15: assigned [mem 0x84600000-0x847fffff 64bit pref]
[    0.410788] pci 0000:00:1c.1: BAR 13: assigned [io  0x4000-0x4fff]
[    0.410794] pci 0000:00:1c.0: BAR 14: assigned [mem 0x84800000-0x849fffff]
[    0.410801] pci 0000:00:1c.0: BAR 15: assigned [mem 0x84a00000-0x84bfffff 64bit pref]
[    0.410808] pci 0000:00:1c.0: BAR 13: assigned [io  0x8000-0x8fff]
[    0.410818] pci 0000:01:00.0: BAR 6: can't assign mem pref (size 0x20000)
[    0.410825] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.410831] pci 0000:00:01.0:   bridge window [io  0x6000-0x6fff]
[    0.410839] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xd1ffffff]
[    0.410846] pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xcfffffff 64bit pref]
[    0.410856] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.410863] pci 0000:00:1c.0:   bridge window [io  0x8000-0x8fff]
[    0.410874] pci 0000:00:1c.0:   bridge window [mem 0x84800000-0x849fffff]
[    0.410883] pci 0000:00:1c.0:   bridge window [mem 0x84a00000-0x84bfffff 64bit pref]
[    0.410895] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.410902] pci 0000:00:1c.1:   bridge window [io  0x4000-0x4fff]
[    0.410912] pci 0000:00:1c.1:   bridge window [mem 0x84400000-0x845fffff]
[    0.410921] pci 0000:00:1c.1:   bridge window [mem 0x84600000-0x847fffff 64bit pref]
[    0.410934] pci 0000:00:1c.2: PCI bridge to [bus 04-04]
[    0.410940] pci 0000:00:1c.2:   bridge window [io  0x3000-0x3fff]
[    0.410950] pci 0000:00:1c.2:   bridge window [mem 0xd2000000-0xd20fffff]
[    0.410959] pci 0000:00:1c.2:   bridge window [mem 0x84200000-0x843fffff 64bit pref]
[    0.410971] pci 0000:00:1c.3: PCI bridge to [bus 05-05]
[    0.410978] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    0.410988] pci 0000:00:1c.3:   bridge window [mem 0xd2100000-0xd21fffff]
[    0.410997] pci 0000:00:1c.3:   bridge window [mem 0x84000000-0x841fffff 64bit pref]
[    0.411016] pci 0000:06:04.0: BAR 0: assigned [mem 0x88000000-0x88000fff]
[    0.411027] pci 0000:06:04.0: BAR 0: set to [mem 0x88000000-0x88000fff] (PCI address [0x88000000-0x88000fff])
[    0.411035] pci 0000:06:04.4: BAR 0: assigned [mem 0xd2200000-0xd22000ff]
[    0.411045] pci 0000:06:04.4: BAR 0: set to [mem 0xd2200000-0xd22000ff] (PCI address [0xd2200000-0xd22000ff])
[    0.411054] pci 0000:06:04.0: BAR 16: assigned [mem 0x8c000000-0x8fffffff]
[    0.411061] pci 0000:06:04.0: BAR 15: assigned [mem 0x80000000-0x83ffffff pref]
[    0.411067] pci 0000:06:04.0: BAR 14: assigned [io  0x7400-0x74ff]
[    0.411072] pci 0000:06:04.0: BAR 13: assigned [io  0x7800-0x78ff]
[    0.411078] pci 0000:06:04.0: CardBus bridge to [bus 07-0a]
[    0.411083] pci 0000:06:04.0:   bridge window [io  0x7800-0x78ff]
[    0.411092] pci 0000:06:04.0:   bridge window [io  0x7400-0x74ff]
[    0.411101] pci 0000:06:04.0:   bridge window [mem 0x80000000-0x83ffffff pref]
[    0.411111] pci 0000:06:04.0:   bridge window [mem 0x8c000000-0x8fffffff]
[    0.411120] pci 0000:00:1e.0: PCI bridge to [bus 06-07]
[    0.411126] pci 0000:00:1e.0:   bridge window [io  0x7000-0x7fff]
[    0.411137] pci 0000:00:1e.0:   bridge window [mem 0xd2200000-0xd22fffff]
[    0.411145] pci 0000:00:1e.0:   bridge window [mem 0x80000000-0x83ffffff pref]
[    0.411186] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.411195] pci 0000:00:01.0: setting latency timer to 64
[    0.411208] pci 0000:00:1c.0: enabling device (0100 -> 0103)
[    0.411224] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.411234] pci 0000:00:1c.0: setting latency timer to 64
[    0.411248] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.411257] pci 0000:00:1c.1: setting latency timer to 64
[    0.411276] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.411285] pci 0000:00:1c.2: setting latency timer to 64
[    0.411304] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.411313] pci 0000:00:1c.3: setting latency timer to 64
[    0.411324] pci 0000:00:1e.0: enabling device (0004 -> 0007)
[    0.411334] pci 0000:00:1e.0: setting latency timer to 64
[    0.411350] pci 0000:06:04.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.411362] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
[    0.411367] pci_bus 0000:00: resource 1 [mem 0x00000000-0xfffffffff]
[    0.411373] pci_bus 0000:01: resource 0 [io  0x6000-0x6fff]
[    0.411380] pci_bus 0000:01: resource 1 [mem 0xd0000000-0xd1ffffff]
[    0.411387] pci_bus 0000:01: resource 2 [mem 0xc0000000-0xcfffffff 64bit pref]
[    0.411395] pci_bus 0000:02: resource 0 [io  0x8000-0x8fff]
[    0.411401] pci_bus 0000:02: resource 1 [mem 0x84800000-0x849fffff]
[    0.411409] pci_bus 0000:02: resource 2 [mem 0x84a00000-0x84bfffff 64bit pref]
[    0.411416] pci_bus 0000:03: resource 0 [io  0x4000-0x4fff]
[    0.411423] pci_bus 0000:03: resource 1 [mem 0x84400000-0x845fffff]
[    0.411430] pci_bus 0000:03: resource 2 [mem 0x84600000-0x847fffff 64bit pref]
[    0.411438] pci_bus 0000:04: resource 0 [io  0x3000-0x3fff]
[    0.411444] pci_bus 0000:04: resource 1 [mem 0xd2000000-0xd20fffff]
[    0.411451] pci_bus 0000:04: resource 2 [mem 0x84200000-0x843fffff 64bit pref]
[    0.411459] pci_bus 0000:05: resource 0 [io  0x2000-0x2fff]
[    0.411465] pci_bus 0000:05: resource 1 [mem 0xd2100000-0xd21fffff]
[    0.411472] pci_bus 0000:05: resource 2 [mem 0x84000000-0x841fffff 64bit pref]
[    0.411480] pci_bus 0000:06: resource 0 [io  0x7000-0x7fff]
[    0.411487] pci_bus 0000:06: resource 1 [mem 0xd2200000-0xd22fffff]
[    0.411494] pci_bus 0000:06: resource 2 [mem 0x80000000-0x83ffffff pref]
[    0.411501] pci_bus 0000:06: resource 4 [io  0x0000-0xffff]
[    0.411507] pci_bus 0000:06: resource 5 [mem 0x00000000-0xfffffffff]
[    0.411514] pci_bus 0000:07: resource 0 [io  0x7800-0x78ff]
[    0.411519] pci_bus 0000:07: resource 1 [io  0x7400-0x74ff]
[    0.411524] pci_bus 0000:07: resource 2 [mem 0x80000000-0x83ffffff pref]
[    0.411529] pci_bus 0000:07: resource 3 [mem 0x8c000000-0x8fffffff]
[    0.411614] NET: Registered protocol family 2
[    0.411849] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.413218] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.416644] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.417473] TCP: Hash tables configured (established 262144 bind 65536)
[    0.417478] TCP reno registered
[    0.417493] UDP hash table entries: 1024 (order: 3, 32768 bytes)
[    0.417528] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
[    0.417728] NET: Registered protocol family 1
[    0.417822] pci 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    0.417851] pci 0000:00:1d.0: PCI INT A disabled
[    0.417867] pci 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.417892] pci 0000:00:1d.1: PCI INT B disabled
[    0.417907] pci 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.417932] pci 0000:00:1d.2: PCI INT C disabled
[    0.417947] pci 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[    0.417973] pci 0000:00:1d.3: PCI INT D disabled
[    0.417991] pci 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    0.418035] pci 0000:00:1d.7: PCI INT A disabled
[    0.418078] pci 0000:01:00.0: Boot video device
[    0.418110] PCI: CLS mismatch (64 != 32), using 64 bytes
[    0.418143] Simple Boot Flag at 0x36 set to 0x1
[    0.418866] audit: initializing netlink socket (disabled)
[    0.418888] type=2000 audit(1364405971.412:1): initialized
[    0.470022] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.474734] VFS: Disk quotas dquot_6.5.2
[    0.474860] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.476057] fuse init (API version 7.17)
[    0.476264] msgmni has been set to 3969
[    0.476966] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.477026] io scheduler noop registered
[    0.477030] io scheduler deadline registered
[    0.477112] io scheduler cfq registered (default)
[    0.477371] pcieport 0000:00:01.0: setting latency timer to 64
[    0.477440] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
[    0.477540] pcieport 0000:00:1c.0: setting latency timer to 64
[    0.477618] pcieport 0000:00:1c.0: irq 41 for MSI/MSI-X
[    0.477745] pcieport 0000:00:1c.1: setting latency timer to 64
[    0.477821] pcieport 0000:00:1c.1: irq 42 for MSI/MSI-X
[    0.477942] pcieport 0000:00:1c.2: setting latency timer to 64
[    0.478020] pcieport 0000:00:1c.2: irq 43 for MSI/MSI-X
[    0.478150] pcieport 0000:00:1c.3: setting latency timer to 64
[    0.478230] pcieport 0000:00:1c.3: irq 44 for MSI/MSI-X
[    0.478409] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.478456] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.478585] intel_idle: MWAIT substates: 0x22220
[    0.478590] intel_idle: does not run on family 6 model 15
[    0.480056] ACPI: Deprecated procfs I/F for AC is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    0.482318] ACPI: EC: GPE storm detected, transactions will use polling mode
[    0.482355] ACPI: AC Adapter [ACAD] (on-line)
[    0.482501] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
[    0.482539] ACPI: Lid Switch [LID]
[    0.482639] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input1
[    0.482648] ACPI: Sleep Button [SLPB]
[    0.482742] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input2
[    0.482750] ACPI: Power Button [PWRB]
[    0.482883] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    0.482890] ACPI: Power Button [PWRF]
[    0.486168] Monitor-Mwait will be used to enter C-1 state
[    0.486183] Monitor-Mwait will be used to enter C-2 state
[    0.486193] Monitor-Mwait will be used to enter C-3 state
[    0.486201] Marking TSC unstable due to TSC halts in idle
[    0.486219] ACPI: acpi_idle registered with cpuidle
[    0.572102] thermal LNXTHERM:00: registered as thermal_zone0
[    0.572110] ACPI: Thermal Zone [TZ00] (52 C)
[    0.604108] thermal LNXTHERM:01: registered as thermal_zone1
[    0.604115] ACPI: Thermal Zone [TZ01] (52 C)
[    0.604213] ACPI: Deprecated procfs I/F for battery is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    0.604241] ACPI: Battery Slot [BAT1] (battery present)
[    0.604392] ERST: Table is not found!
[    0.604396] GHES: HEST is not enabled!
[    0.604586] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    0.784747] Freeing initrd memory: 13872k freed
[    0.960169] Linux agpgart interface v0.103
[    0.963949] brd: module loaded
[    0.965798] loop: module loaded
[    0.966202] ata_piix 0000:00:1f.2: version 2.13
[    0.966230] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.966241] ata_piix 0000:00:1f.2: MAP [ P0 P2 IDE IDE ]
[    1.120051] ata_piix 0000:00:1f.2: setting latency timer to 64
[    1.120754] scsi0 : ata_piix
[    1.120944] scsi1 : ata_piix
[    1.122093] ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0x5440 irq 14
[    1.122100] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x5448 irq 15
[    1.122902] Fixed MDIO Bus: probed
[    1.122950] tun: Universal TUN/TAP device driver, 1.6
[    1.122954] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    1.123074] PPP generic driver version 2.4.2
[    1.123298] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.123337] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    1.123364] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    1.123371] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    1.123473] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    1.123522] ehci_hcd 0000:00:1d.7: using broken periodic workaround
[    1.123541] ehci_hcd 0000:00:1d.7: debug port 1
[    1.127424] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    1.127454] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xd2504000
[    1.140029] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    1.140350] hub 1-0:1.0: USB hub found
[    1.140361] hub 1-0:1.0: 8 ports detected
[    1.140545] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.140575] uhci_hcd: USB Universal Host Controller Interface driver
[    1.140608] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    1.140623] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    1.140629] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    1.140730] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    1.140771] uhci_hcd 0000:00:1d.0: irq 23, io base 0x000050a0
[    1.141059] hub 2-0:1.0: USB hub found
[    1.141069] hub 2-0:1.0: 2 ports detected
[    1.141212] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.141226] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    1.141233] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    1.141345] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    1.141399] uhci_hcd 0000:00:1d.1: irq 19, io base 0x000050c0
[    1.141672] hub 3-0:1.0: USB hub found
[    1.141684] hub 3-0:1.0: 2 ports detected
[    1.141825] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.141839] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    1.141845] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    1.141945] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    1.141998] uhci_hcd 0000:00:1d.2: irq 18, io base 0x000050e0
[    1.142277] hub 4-0:1.0: USB hub found
[    1.142286] hub 4-0:1.0: 2 ports detected
[    1.142427] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[    1.142440] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    1.142447] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    1.142547] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    1.142604] uhci_hcd 0000:00:1d.3: irq 16, io base 0x00005400
[    1.142875] hub 5-0:1.0: USB hub found
[    1.142884] hub 5-0:1.0: 2 ports detected
[    1.143122] usbcore: registered new interface driver libusual
[    1.143206] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:MSS0] at 0x60,0x64 irq 1,12
[    1.145262] i8042: Detected active multiplexing controller, rev 1.1
[    1.145370] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.145384] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    1.145456] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    1.145518] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    1.145594] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    1.145879] mousedev: PS/2 mouse device common for all mice
[    1.146333] rtc_cmos 00:07: RTC can wake from S4
[    1.146531] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    1.146572] rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    1.146794] device-mapper: uevent: version 1.0.3
[    1.146974] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised: dm-devel@redhat.com
[    1.147133] cpuidle: using governor ladder
[    1.147359] cpuidle: using governor menu
[    1.147364] EFI Variables Facility v0.08 2004-May-17
[    1.147934] TCP cubic registered
[    1.148192] NET: Registered protocol family 10
[    1.149345] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
[    1.149745] NET: Registered protocol family 17
[    1.149780] Registering the dns_resolver key type
[    1.150104] PM: Hibernation image not present or could not be loaded.
[    1.150138] registered taskstats version 1
[    1.164748]   Magic number: 5:945:694
[    1.164919] rtc_cmos 00:07: setting system clock to 2013-03-27 17:39:33 UTC (1364405973)
[    1.165395] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    1.165399] EDD information not available.
[    1.284507] ata1.00: ATA-8: TS32GSSD25S-M, 100707A, max UDMA/133
[    1.284515] ata1.00: 62533296 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    1.300508] ata1.00: configured for UDMA/133
[    1.300802] scsi 0:0:0:0: Direct-Access     ATA      TS32GSSD25S-M    1007 PQ: 0 ANSI: 5
[    1.301079] sd 0:0:0:0: [sda] 62533296 512-byte logical blocks: (32.0 GB/29.8 GiB)
[    1.301138] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.301215] sd 0:0:0:0: [sda] Write Protect is off
[    1.301219] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.301287] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.303904]  sda: sda1 sda2 < sda5 >
[    1.304645] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.308461] ata2.00: ATAPI: Slimtype DVD A  DS8A1P, CA11, max UDMA/33
[    1.312223] ACPI: Battery Slot [BAT1] (battery present)
[    1.348356] ata2.00: configured for UDMA/33
[    1.352314] scsi 1:0:0:0: CD-ROM            Slimtype DVD A  DS8A1P    CA11 PQ: 0 ANSI: 5
[    1.358014] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    1.358020] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.358263] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    1.358441] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    1.360748] Freeing unused kernel memory: 920k freed
[    1.361114] Write protecting the kernel read-only data: 12288k
[    1.368587] Freeing unused kernel memory: 1600k freed
[    1.374755] Freeing unused kernel memory: 1192k freed
[    1.397393] udevd[90]: starting version 175
[    1.512052] usb 1-4: new high-speed USB device number 3 using ehci_hcd
[    1.543681] tg3.c:v3.121 (November 2, 2011)
[    1.543707] tg3 0000:04:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    1.543721] tg3 0000:04:00.0: setting latency timer to 64
[    1.550477] sdhci: Secure Digital Host Controller Interface driver
[    1.550481] sdhci: Copyright(c) Pierre Ossman
[    1.550861] sdhci-pci 0000:06:04.2: SDHCI controller found [1524:0550] (rev 1)
[    1.550879] sdhci-pci 0000:06:04.2: enabling device (0000 -> 0002)
[    1.550891] sdhci-pci 0000:06:04.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    1.550957] mmc0: no vmmc regulator found
[    1.550998] Registered led device: mmc0::
[    1.569651] mmc0: SDHCI controller on PCI [0000:06:04.2] using PIO
[    1.569685] sdhci-pci 0000:06:04.4: SDHCI controller found [1524:0551] (rev 1)
[    1.569702] sdhci-pci 0000:06:04.4: enabling device (0000 -> 0002)
[    1.569716] sdhci-pci 0000:06:04.4: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    1.569765] mmc1: no vmmc regulator found
[    1.569812] Registered led device: mmc1::
[    1.571925] mmc1: SDHCI controller on PCI [0000:06:04.4] using PIO
[    1.572189] firewire_ohci 0000:06:00.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    1.572198] firewire_ohci 0000:06:00.0: setting latency timer to 64
[    1.604516] tg3 0000:04:00.0: eth0: Tigon3 [partno(BCM95787m) rev b002] (PCI Express) MAC address 00:1b:38:2c:6d:27
[    1.604524] tg3 0000:04:00.0: eth0: attached PHY is 5787 (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[0])
[    1.604529] tg3 0000:04:00.0: eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[    1.604534] tg3 0000:04:00.0: eth0: dma_rwctrl[76180000] dma_mask[64-bit]
[    1.631998] EXT4-fs (sda1): INFO: recovery required on readonly filesystem
[    1.632029] EXT4-fs (sda1): write access will be enabled during recovery
[    1.640122] firewire_ohci: Added fw-ohci device 0000:06:00.0, OHCI v1.10, 4 IR + 8 IT contexts, quirks 0x11
[    1.900066] usb 3-1: new low-speed USB device number 2 using uhci_hcd
[    2.105896] input: PIXART USB OPTICAL MOUSE as /devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0/input/input5
[    2.106189] generic-usb 0003:093A:2510.0001: input,hidraw0: USB HID v1.11 Mouse [PIXART USB OPTICAL MOUSE] on usb-0000:00:1d.1-1/input0
[    2.106219] usbcore: registered new interface driver usbhid
[    2.106222] usbhid: USB HID core driver
[    2.140228] firewire_core: created device fw0: GUID 00023f788b400c74, S400
[    2.288700] EXT4-fs (sda1): orphan cleanup on readonly fs
[    2.288713] EXT4-fs (sda1): ext4_orphan_cleanup: deleting unreferenced inode 417442
[    2.288799] EXT4-fs (sda1): 1 orphan inode deleted
[    2.288802] EXT4-fs (sda1): recovery complete
[    2.509518] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[    3.247263] Adding 2093052k swap on /dev/sda5.  Priority:-1 extents:1 across:2093052k SS
[    3.258466] ADDRCONF(NETDEV_UP): eth0: link is not ready
[    3.269858] udevd[338]: starting version 175
[    3.272233] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro
[    3.339486] lp: driver loaded but no devices found
[    3.453238] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:00/LNXVIDEO:00/input/input6
[    3.457485] ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
[    3.660234] ppdev: user-space parallel port driver
[    3.730640] Bluetooth: Core ver 2.16
[    3.730731] NET: Registered protocol family 31
[    3.730735] Bluetooth: HCI device and connection manager initialized
[    3.730739] Bluetooth: HCI socket layer initialized
[    3.730742] Bluetooth: L2CAP socket layer initialized
[    3.730750] Bluetooth: SCO socket layer initialized
[    3.761689] Bluetooth: RFCOMM TTY layer initialized
[    3.761697] Bluetooth: RFCOMM socket layer initialized
[    3.761700] Bluetooth: RFCOMM ver 1.11
[    3.772356] type=1400 audit(1364405976.106:2): apparmor="STATUS" operation="profile_load" name="/usr/lib/cups/backend/cups-pdf" pid=623 comm="apparmor_parser"
[    3.773056] type=1400 audit(1364405976.106:3): apparmor="STATUS" operation="profile_load" name="/usr/sbin/cupsd" pid=623 comm="apparmor_parser"
[    3.778835] wmi: Mapper loaded
[    3.807353] cfg80211: Calling CRDA to update world regulatory domain
[    3.824722] type=1400 audit(1364405976.158:4): apparmor="STATUS" operation="profile_load" name="/sbin/dhclient" pid=642 comm="apparmor_parser"
[    3.825900] type=1400 audit(1364405976.158:5): apparmor="STATUS" operation="profile_load" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=642 comm="apparmor_parser"
[    3.826226] type=1400 audit(1364405976.158:6): apparmor="STATUS" operation="profile_load" name="/usr/lib/connman/scripts/dhclient-script" pid=642 comm="apparmor_parser"
[    3.839111] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    3.839117] Bluetooth: BNEP filters: protocol multicast
[    3.870880] intel_rng: FWH not detected
[    3.877009] Linux video capture interface: v2.00
[    3.877875] uvcvideo: Found UVC 1.00 device <unnamed> (046d:09b0)
[    3.891076] leds_ss4200: no LED devices found
[    3.903388] yenta_cardbus 0000:06:04.0: CardBus bridge found [1025:0090]
[    3.903418] yenta_cardbus 0000:06:04.0: Using CSCINT to route CSC interrupts to PCI
[    3.903422] yenta_cardbus 0000:06:04.0: Routing CardBus interrupts to PCI
[    3.903429] yenta_cardbus 0000:06:04.0: TI: mfunc 0x90501212, devctl 0x44
[    3.907311] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, in-tree:s
[    3.907317] iwl3945: Copyright(c) 2003-2011 Intel Corporation
[    3.907439] iwl3945 0000:05:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    3.907456] iwl3945 0000:05:00.0: setting latency timer to 64
[    3.965237] iwl3945 0000:05:00.0: Tunable channels: 13 802.11bg, 23 802.11a channels
[    3.965243] iwl3945 0000:05:00.0: Detected Intel Wireless WiFi Link 3945ABG
[    3.965404] iwl3945 0000:05:00.0: irq 45 for MSI/MSI-X
[    3.967425] Registered led device: phy0-led
[    3.967502] cfg80211: Ignoring regulatory request Set by core since the driver uses its own custom regulatory domain
[    3.970319] input: UVC Camera (046d:09b0) as /devices/pci0000:00/0000:00:1d.7/usb1/1-4/1-4:1.0/input/input7
[    3.971959] usbcore: registered new interface driver uvcvideo
[    3.971963] USB Video Class driver (1.1.1)
[    3.986405] ieee80211 phy0: Selected rate control algorithm 'iwl-3945-rs'
[    4.061013] snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    4.061096] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[    4.061136] snd_hda_intel 0000:00:1b.0: setting latency timer to 64
[    4.132833] yenta_cardbus 0000:06:04.0: ISA IRQ mask 0x0cf8, PCI irq 16
[    4.132840] yenta_cardbus 0000:06:04.0: Socket status: 30000006
[    4.132846] pci_bus 0000:06: Raising subordinate bus# of parent bus (#06) from #07 to #0a
[    4.132859] yenta_cardbus 0000:06:04.0: pcmcia: parent PCI bridge window: [io  0x7000-0x7fff]
[    4.132864] yenta_cardbus 0000:06:04.0: pcmcia: parent PCI bridge window: [mem 0xd2200000-0xd22fffff]
[    4.132869] pcmcia_socket pcmcia_socket0: cs: memory probe 0xd2200000-0xd22fffff: excluding 0xd2200000-0xd220ffff
[    4.132887] yenta_cardbus 0000:06:04.0: pcmcia: parent PCI bridge window: [mem 0x80000000-0x83ffffff pref]
[    4.132891] pcmcia_socket pcmcia_socket0: cs: memory probe 0x80000000-0x83ffffff: excluding 0x80000000-0x83ffffff
[    4.225170] init: failsafe main process (750) killed by TERM signal
[    4.326312] nvidia: module license 'NVIDIA' taints kernel.
[    4.326315] Disabling lock debugging due to kernel taint
[    4.512721] psmouse serio4: synaptics: Touchpad model: 1, fw: 6.2, id: 0x1280b1, caps: 0xa04713/0x204000/0x0
[    4.543118] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio4/input/input8
[    4.622133] acer_wmi: Acer Laptop ACPI-WMI Extras
[    4.648819] nvidia 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    4.648832] nvidia 0000:01:00.0: setting latency timer to 64
[    4.648839] vgaarb: device changed decodes: PCI:0000:01:00.0,olddecodes=io+mem,decodes=none:owns=io+mem
[    4.649077] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  304.84  Wed Feb 27 04:58:49 PST 2013
[    4.652127] acer_wmi: Function bitmap for Communication Device: 0x21
[    4.713661] cfg80211: Ignoring regulatory request Set by core since the driver uses its own custom regulatory domain
[    4.713668] cfg80211: World regulatory domain updated:
[    4.713671] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    4.713675] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    4.713679] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[    4.713682] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[    4.713685] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    4.713689] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    4.740415] type=1400 audit(1364405977.074:7): apparmor="STATUS" operation="profile_load" name="/usr/lib/lightdm/lightdm/lightdm-guest-session-wrapper" pid=900 comm="apparmor_parser"
[    4.741069] type=1400 audit(1364405977.074:8): apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient" pid=901 comm="apparmor_parser"
[    4.741825] type=1400 audit(1364405977.074:9): apparmor="STATUS" operation="profile_replace" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=901 comm="apparmor_parser"
[    4.742156] type=1400 audit(1364405977.074:10): apparmor="STATUS" operation="profile_replace" name="/usr/lib/connman/scripts/dhclient-script" pid=901 comm="apparmor_parser"
[    4.742543] pcmcia_socket pcmcia_socket0: cs: memory probe 0x0c0000-0x0fffff: excluding 0xc0000-0xcffff 0xe0000-0xfffff
[    4.742584] pcmcia_socket pcmcia_socket0: cs: memory probe 0xa0000000-0xa0ffffff: clean.
[    4.742621] pcmcia_socket pcmcia_socket0: cs: memory probe 0x60000000-0x60ffffff: excluding 0x60000000-0x60ffffff
[    4.777770] tg3 0000:04:00.0: irq 47 for MSI/MSI-X
[    4.969265] ADDRCONF(NETDEV_UP): eth0: link is not ready
[    4.969728] ADDRCONF(NETDEV_UP): eth0: link is not ready
[    4.995982] iwl3945 0000:05:00.0: loaded firmware version 15.32.2.9
[    5.066646] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[    5.066991] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[    5.109190] vesafb: mode is 1024x768x32, linelength=4096, pages=0
[    5.109195] vesafb: scrolling: redraw
[    5.109199] vesafb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    5.111527] vesafb: framebuffer at 0xc0000000, mapped to 0xffffc90011280000, using 3072k, total 3072k
[    5.111862] Console: switching to colour frame buffer device 128x48
[    5.111889] fb0: VESA VGA frame buffer device
[    7.164264] NVRM: Your system is not currently configured to drive a VGA console
[    7.164270] NVRM: on the primary VGA device. The NVIDIA Linux graphics driver
[    7.164273] NVRM: requires the use of a text-mode VGA console. Use of other console
[    7.164277] NVRM: drivers including, but not limited to, vesafb, may result in
[    7.164280] NVRM: corruption and stability problems, and is not supported.
[   14.592395] wlan0: authenticate with 88:25:2c:d1:d4:7f (try 1)
[   14.594608] wlan0: authenticated
[   14.598427] wlan0: associate with 88:25:2c:d1:d4:7f (try 1)
[   14.601578] wlan0: RX AssocResp from 88:25:2c:d1:d4:7f (capab=0x431 status=0 aid=2)
[   14.601585] wlan0: associated
[   14.605694] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   14.605769] cfg80211: Calling CRDA for country: DE
[   14.612878] cfg80211: Updating information on frequency 2412 MHz for a 20 MHz width channel with regulatory rule:
[   14.612884] cfg80211: 2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   14.612888] cfg80211: Updating information on frequency 2417 MHz for a 20 MHz width channel with regulatory rule:
[   14.612892] cfg80211: 2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   14.612895] cfg80211: Updating information on frequency 2422 MHz for a 20 MHz width channel with regulatory rule:
[   14.612898] cfg80211: 2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   14.612901] cfg80211: Updating information on frequency 2427 MHz for a 20 MHz width channel with regulatory rule:
[   14.612905] cfg80211: 2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   14.612908] cfg80211: Updating information on frequency 2432 MHz for a 20 MHz width channel with regulatory rule:
[   14.612912] cfg80211: 2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   14.612915] cfg80211: Updating information on frequency 2437 MHz for a 20 MHz width channel with regulatory rule:
[   14.612919] cfg80211: 2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   14.612921] cfg80211: Updating information on frequency 2442 MHz for a 20 MHz width channel with regulatory rule:
[   14.612925] cfg80211: 2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   14.612928] cfg80211: Updating information on frequency 2447 MHz for a 20 MHz width channel with regulatory rule:
[   14.612932] cfg80211: 2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   14.612935] cfg80211: Updating information on frequency 2452 MHz for a 20 MHz width channel with regulatory rule:
[   14.612939] cfg80211: 2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   14.612942] cfg80211: Updating information on frequency 2457 MHz for a 20 MHz width channel with regulatory rule:
[   14.612945] cfg80211: 2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   14.612948] cfg80211: Updating information on frequency 2462 MHz for a 20 MHz width channel with regulatory rule:
[   14.612952] cfg80211: 2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   14.612955] cfg80211: Updating information on frequency 2467 MHz for a 20 MHz width channel with regulatory rule:
[   14.612959] cfg80211: 2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   14.612962] cfg80211: Updating information on frequency 2472 MHz for a 20 MHz width channel with regulatory rule:
[   14.612966] cfg80211: 2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   14.612969] cfg80211: Updating information on frequency 5170 MHz for a 20 MHz width channel with regulatory rule:
[   14.612972] cfg80211: 5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   14.612976] cfg80211: Updating information on frequency 5180 MHz for a 20 MHz width channel with regulatory rule:
[   14.612980] cfg80211: 5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   14.612982] cfg80211: Updating information on frequency 5190 MHz for a 20 MHz width channel with regulatory rule:
[   14.612986] cfg80211: 5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   14.612989] cfg80211: Updating information on frequency 5200 MHz for a 20 MHz width channel with regulatory rule:
[   14.612993] cfg80211: 5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   14.612996] cfg80211: Updating information on frequency 5210 MHz for a 20 MHz width channel with regulatory rule:
[   14.613000] cfg80211: 5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   14.613003] cfg80211: Updating information on frequency 5220 MHz for a 20 MHz width channel with regulatory rule:
[   14.613007] cfg80211: 5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   14.613010] cfg80211: Updating information on frequency 5230 MHz for a 20 MHz width channel with regulatory rule:
[   14.613013] cfg80211: 5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   14.613016] cfg80211: Updating information on frequency 5240 MHz for a 20 MHz width channel with regulatory rule:
[   14.613020] cfg80211: 5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   14.613023] cfg80211: Updating information on frequency 5260 MHz for a 20 MHz width channel with regulatory rule:
[   14.613027] cfg80211: 5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   14.613030] cfg80211: Updating information on frequency 5280 MHz for a 20 MHz width channel with regulatory rule:
[   14.613034] cfg80211: 5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   14.613037] cfg80211: Updating information on frequency 5300 MHz for a 20 MHz width channel with regulatory rule:
[   14.613040] cfg80211: 5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   14.613043] cfg80211: Updating information on frequency 5320 MHz for a 20 MHz width channel with regulatory rule:
[   14.613047] cfg80211: 5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   14.613050] cfg80211: Updating information on frequency 5500 MHz for a 20 MHz width channel with regulatory rule:
[   14.613054] cfg80211: 5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A mBi, 2698 mBm)
[   14.613057] cfg80211: Updating information on frequency 5520 MHz for a 20 MHz width channel with regulatory rule:
[   14.613061] cfg80211: 5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A mBi, 2698 mBm)
[   14.613064] cfg80211: Updating information on frequency 5540 MHz for a 20 MHz width channel with regulatory rule:
[   14.613067] cfg80211: 5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A mBi, 2698 mBm)
[   14.613070] cfg80211: Updating information on frequency 5560 MHz for a 20 MHz width channel with regulatory rule:
[   14.613074] cfg80211: 5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A mBi, 2698 mBm)
[   14.613077] cfg80211: Updating information on frequency 5580 MHz for a 20 MHz width channel with regulatory rule:
[   14.613081] cfg80211: 5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A mBi, 2698 mBm)
[   14.613084] cfg80211: Updating information on frequency 5600 MHz for a 20 MHz width channel with regulatory rule:
[   14.613088] cfg80211: 5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A mBi, 2698 mBm)
[   14.613091] cfg80211: Updating information on frequency 5620 MHz for a 20 MHz width channel with regulatory rule:
[   14.613094] cfg80211: 5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A mBi, 2698 mBm)
[   14.613097] cfg80211: Updating information on frequency 5640 MHz for a 20 MHz width channel with regulatory rule:
[   14.613101] cfg80211: 5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A mBi, 2698 mBm)
[   14.613104] cfg80211: Updating information on frequency 5660 MHz for a 20 MHz width channel with regulatory rule:
[   14.613108] cfg80211: 5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A mBi, 2698 mBm)
[   14.613111] cfg80211: Updating information on frequency 5680 MHz for a 20 MHz width channel with regulatory rule:
[   14.613115] cfg80211: 5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A mBi, 2698 mBm)
[   14.613118] cfg80211: Updating information on frequency 5700 MHz for a 20 MHz width channel with regulatory rule:
[   14.613121] cfg80211: 5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A mBi, 2698 mBm)
[   14.613125] cfg80211: Regulatory domain changed to country: DE
[   14.613128] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   14.613131] cfg80211:     (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   14.613134] cfg80211:     (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   14.613138] cfg80211:     (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   14.613141] cfg80211:     (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
[   24.656095] wlan0: no IPv6 routers present

--------------020701090508020208070400
Content-Type: text/plain; charset=UTF-8;
 name="dmesg_wifi"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="dmesg_wifi"

bmllbHNANDI4MDp+JCBkbWVzZyB8IGVncmVwICduZXR8ZXRofHNreXxzaXN8dmlhfDNjM3wz
YzV8ZTEwMHw4MTM5fDgxNjl8YWN4fGFpcnxhdGh8YXRsfGFyOXxjYXJsfGF0bWV8YXQ3fGhl
cm18aXdsfGlwd3xydGw4fHI4MXxydDJ8cnQzfHJ0NnxydDd8dGczfHNzYnx3bHxiNDN8YjQ0
fG9yaXxwcml8cDV8emR8bmRpc3x3bWl8bnM4fEZXJwpbICAgIDAuMDAwMDAwXSBvcmlnaW5h
bCB2YXJpYWJsZSBNVFJScwpbICAgIDAuMDAwMDAwXSBQRVJDUFU6IEVtYmVkZGVkIDI4IHBh
Z2VzL2NwdSBAZmZmZjg4MDA3ZmMwMDAwMCBzODMxMzYgcjgxOTIgZDIzMzYwIHUxMDQ4NTc2
ClsgICAgMC4wMDAwMDBdIHBjcHUtYWxsb2M6IHM4MzEzNiByODE5MiBkMjMzNjAgdTEwNDg1
NzYgYWxsb2M9MSoyMDk3MTUyClsgICAgMC4wMDAwMDBdIENhbGdhcnk6IGRldGVjdGluZyBD
YWxnYXJ5IHZpYSBCSU9TIEVCREEgYXJlYQpbICAgIDAuMDExMjA4XSBDUFUwOiBUaGVybWFs
IG1vbml0b3JpbmcgZW5hYmxlZCAoVE0yKQpbICAgIDAuMDc2MDA0XSBBUElDIGNhbGlicmF0
aW9uIG5vdCBjb25zaXN0ZW50IHdpdGggUE0tVGltZXI6IDIwN21zIGluc3RlYWQgb2YgMTAw
bXMKWyAgICAwLjE2OTgzNF0gcHJpbnRfY29uc3RyYWludHM6IGR1bW15OiAKWyAgICAwLjMx
NTMzN10gUENJOiBJZ25vcmluZyBob3N0IGJyaWRnZSB3aW5kb3dzIGZyb20gQUNQSTsgaWYg
bmVjZXNzYXJ5LCB1c2UgInBjaT11c2VfY3JzIiBhbmQgcmVwb3J0IGEgYnVnClsgICAgMC4z
Mzk5ODFdIGkyYy1jb3JlOiBkcml2ZXIgW2FhdDI4NzBdIHVzaW5nIGxlZ2FjeSBzdXNwZW5k
IG1ldGhvZApbICAgIDAuMzM5OTg1XSBpMmMtY29yZTogZHJpdmVyIFthYXQyODcwXSB1c2lu
ZyBsZWdhY3kgcmVzdW1lIG1ldGhvZApbICAgIDAuNDE4ODY2XSBhdWRpdDogaW5pdGlhbGl6
aW5nIG5ldGxpbmsgc29ja2V0IChkaXNhYmxlZCkKWyAgICAwLjU3MjEwMl0gdGhlcm1hbCBM
TlhUSEVSTTowMDogcmVnaXN0ZXJlZCBhcyB0aGVybWFsX3pvbmUwClsgICAgMC41NzIxMTBd
IEFDUEk6IFRoZXJtYWwgWm9uZSBbVFowMF0gKDUyIEMpClsgICAgMC42MDQxMDhdIHRoZXJt
YWwgTE5YVEhFUk06MDE6IHJlZ2lzdGVyZWQgYXMgdGhlcm1hbF96b25lMQpbICAgIDAuNjA0
MTE1XSBBQ1BJOiBUaGVybWFsIFpvbmUgW1RaMDFdICg1MiBDKQpbICAgIDEuMTIyOTU0XSB0
dW46IChDKSAxOTk5LTIwMDQgTWF4IEtyYXNueWFuc2t5IDxtYXhrQHF1YWxjb21tLmNvbT4K
WyAgICAxLjU0MzY4MV0gdGczLmM6djMuMTIxIChOb3ZlbWJlciAyLCAyMDExKQpbICAgIDEu
NTQzNzA3XSB0ZzMgMDAwMDowNDowMC4wOiBQQ0kgSU5UIEEgLT4gR1NJIDE4IChsZXZlbCwg
bG93KSAtPiBJUlEgMTgKWyAgICAxLjU0MzcyMV0gdGczIDAwMDA6MDQ6MDAuMDogc2V0dGlu
ZyBsYXRlbmN5IHRpbWVyIHRvIDY0ClsgICAgMS42MDQ1MTZdIHRnMyAwMDAwOjA0OjAwLjA6
IGV0aDA6IFRpZ29uMyBbcGFydG5vKEJDTTk1Nzg3bSkgcmV2IGIwMDJdIChQQ0kgRXhwcmVz
cykgTUFDIGFkZHJlc3MgMDA6MWI6Mzg6MmM6NmQ6MjcKWyAgICAxLjYwNDUyNF0gdGczIDAw
MDA6MDQ6MDAuMDogZXRoMDogYXR0YWNoZWQgUEhZIGlzIDU3ODcgKDEwLzEwMC8xMDAwQmFz
ZS1UIEV0aGVybmV0KSAoV2lyZVNwZWVkWzFdLCBFRUVbMF0pClsgICAgMS42MDQ1MjldIHRn
MyAwMDAwOjA0OjAwLjA6IGV0aDA6IFJYY3N1bXNbMV0gTGlua0NoZ1JFR1swXSBNSWlycVsw
XSBBU0ZbMF0gVFNPY2FwWzFdClsgICAgMS42MDQ1MzRdIHRnMyAwMDAwOjA0OjAwLjA6IGV0
aDA6IGRtYV9yd2N0cmxbNzYxODAwMDBdIGRtYV9tYXNrWzY0LWJpdF0KWyAgICAzLjI0NzI2
M10gQWRkaW5nIDIwOTMwNTJrIHN3YXAgb24gL2Rldi9zZGE1LiAgUHJpb3JpdHk6LTEgZXh0
ZW50czoxIGFjcm9zczoyMDkzMDUyayBTUwpbICAgIDMuMjU4NDY2XSBBRERSQ09ORihORVRE
RVZfVVApOiBldGgwOiBsaW5rIGlzIG5vdCByZWFkeQpbICAgIDMuNzc4ODM1XSB3bWk6IE1h
cHBlciBsb2FkZWQKWyAgICAzLjgzOTExMV0gQmx1ZXRvb3RoOiBCTkVQIChFdGhlcm5ldCBF
bXVsYXRpb24pIHZlciAxLjMKWyAgICAzLjg3MDg4MF0gaW50ZWxfcm5nOiBGV0ggbm90IGRl
dGVjdGVkClsgICAgMy45MDczMTFdIGl3bDM5NDU6IEludGVsKFIpIFBSTy9XaXJlbGVzcyAz
OTQ1QUJHL0JHIE5ldHdvcmsgQ29ubmVjdGlvbiBkcml2ZXIgZm9yIExpbnV4LCBpbi10cmVl
OnMKWyAgICAzLjkwNzMxN10gaXdsMzk0NTogQ29weXJpZ2h0KGMpIDIwMDMtMjAxMSBJbnRl
bCBDb3Jwb3JhdGlvbgpbICAgIDMuOTA3NDM5XSBpd2wzOTQ1IDAwMDA6MDU6MDAuMDogUENJ
IElOVCBBIC0+IEdTSSAxOSAobGV2ZWwsIGxvdykgLT4gSVJRIDE5ClsgICAgMy45MDc0NTZd
IGl3bDM5NDUgMDAwMDowNTowMC4wOiBzZXR0aW5nIGxhdGVuY3kgdGltZXIgdG8gNjQKWyAg
ICAzLjk2NTIzN10gaXdsMzk0NSAwMDAwOjA1OjAwLjA6IFR1bmFibGUgY2hhbm5lbHM6IDEz
IDgwMi4xMWJnLCAyMyA4MDIuMTFhIGNoYW5uZWxzClsgICAgMy45NjUyNDNdIGl3bDM5NDUg
MDAwMDowNTowMC4wOiBEZXRlY3RlZCBJbnRlbCBXaXJlbGVzcyBXaUZpIExpbmsgMzk0NUFC
RwpbICAgIDMuOTY1NDA0XSBpd2wzOTQ1IDAwMDA6MDU6MDAuMDogaXJxIDQ1IGZvciBNU0kv
TVNJLVgKWyAgICAzLjk2NzUwMl0gY2ZnODAyMTE6IElnbm9yaW5nIHJlZ3VsYXRvcnkgcmVx
dWVzdCBTZXQgYnkgY29yZSBzaW5jZSB0aGUgZHJpdmVyIHVzZXMgaXRzIG93biBjdXN0b20g
cmVndWxhdG9yeSBkb21haW4KWyAgICAzLjk4NjQwNV0gaWVlZTgwMjExIHBoeTA6IFNlbGVj
dGVkIHJhdGUgY29udHJvbCBhbGdvcml0aG0gJ2l3bC0zOTQ1LXJzJwpbICAgIDQuNjIyMTMz
XSBhY2VyX3dtaTogQWNlciBMYXB0b3AgQUNQSS1XTUkgRXh0cmFzClsgICAgNC42NTIxMjdd
IGFjZXJfd21pOiBGdW5jdGlvbiBiaXRtYXAgZm9yIENvbW11bmljYXRpb24gRGV2aWNlOiAw
eDIxClsgICAgNC43MTM2NjFdIGNmZzgwMjExOiBJZ25vcmluZyByZWd1bGF0b3J5IHJlcXVl
c3QgU2V0IGJ5IGNvcmUgc2luY2UgdGhlIGRyaXZlciB1c2VzIGl0cyBvd24gY3VzdG9tIHJl
Z3VsYXRvcnkgZG9tYWluClsgICAgNC43Nzc3NzBdIHRnMyAwMDAwOjA0OjAwLjA6IGlycSA0
NyBmb3IgTVNJL01TSS1YClsgICAgNC45NjkyNjVdIEFERFJDT05GKE5FVERFVl9VUCk6IGV0
aDA6IGxpbmsgaXMgbm90IHJlYWR5ClsgICAgNC45Njk3MjhdIEFERFJDT05GKE5FVERFVl9V
UCk6IGV0aDA6IGxpbmsgaXMgbm90IHJlYWR5ClsgICAgNC45OTU5ODJdIGl3bDM5NDUgMDAw
MDowNTowMC4wOiBsb2FkZWQgZmlybXdhcmUgdmVyc2lvbiAxNS4zMi4yLjkKWyAgICA1LjA2
NjY0Nl0gQUREUkNPTkYoTkVUREVWX1VQKTogd2xhbjA6IGxpbmsgaXMgbm90IHJlYWR5Clsg
ICAgNS4wNjY5OTFdIEFERFJDT05GKE5FVERFVl9VUCk6IHdsYW4wOiBsaW5rIGlzIG5vdCBy
ZWFkeQpbICAgIDcuMTY0MjcwXSBOVlJNOiBvbiB0aGUgcHJpbWFyeSBWR0EgZGV2aWNlLiBU
aGUgTlZJRElBIExpbnV4IGdyYXBoaWNzIGRyaXZlcgpbICAgMTQuNTkyMzk1XSB3bGFuMDog
YXV0aGVudGljYXRlIHdpdGggODg6MjU6MmM6ZDE6ZDQ6N2YgKHRyeSAxKQpbICAgMTQuNTk0
NjA4XSB3bGFuMDogYXV0aGVudGljYXRlZApbICAgMTQuNTk4NDI3XSB3bGFuMDogYXNzb2Np
YXRlIHdpdGggODg6MjU6MmM6ZDE6ZDQ6N2YgKHRyeSAxKQpbICAgMTQuNjAxNTc4XSB3bGFu
MDogUlggQXNzb2NSZXNwIGZyb20gODg6MjU6MmM6ZDE6ZDQ6N2YgKGNhcGFiPTB4NDMxIHN0
YXR1cz0wIGFpZD0yKQpbICAgMTQuNjAxNTg1XSB3bGFuMDogYXNzb2NpYXRlZApbICAgMTQu
NjA1Njk0XSBBRERSQ09ORihORVRERVZfQ0hBTkdFKTogd2xhbjA6IGxpbmsgYmVjb21lcyBy
ZWFkeQpbICAgMjQuNjU2MDk1XSB3bGFuMDogbm8gSVB2NiByb3V0ZXJzIHByZXNlbnQ=
--------------020701090508020208070400--
