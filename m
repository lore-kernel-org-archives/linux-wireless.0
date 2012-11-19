Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:59373 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752732Ab2KSAoJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Nov 2012 19:44:09 -0500
Date: Mon, 19 Nov 2012 01:43:59 +0100 (CET)
From: sebastien.major@free.fr
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Message-ID: <1704475029.63506299.1353285839059.JavaMail.root@zimbra4-e1.priv.proxad.net> (sfid-20121119_014417_712956_E78F1EB3)
In-Reply-To: <50A9796D.5020701@lwfinger.net>
Subject: Re: Edimax EW-7612Aun does not work.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hello,

First of all : many thanks for you done with Linux !!!
Ok.

I traced rfkill, iwconfig wlan0, uname -a, dmesg, lsusb and lsusb -v.

Best regards.
S. Major

Here it is : 

===> # rfkill
0: phy0: Wireless LAN
	Soft blocked: no
	Hard blocked: no

I use debian unstable (updated last thursday).

Here some other traces :

===> # dmesg

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.2.0-4-amd64 (debian-kernel@lists.debian.org) (gcc version 4.6.3 (Debian 4.6.3-12) ) #1 SMP Debian 3.2.32-1
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.2.0-4-amd64 root=UUID=766415f7-3cd0-4074-8c20-69a0c3d5f111 ro quiet
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003f4fd000 (usable)
[    0.000000]  BIOS-e820: 000000003f4fd000 - 000000003f508000 (reserved)
[    0.000000]  BIOS-e820: 000000003f508000 - 000000003f552000 (usable)
[    0.000000]  BIOS-e820: 000000003f552000 - 000000003f555000 (reserved)
[    0.000000]  BIOS-e820: 000000003f555000 - 000000003f5bb000 (usable)
[    0.000000]  BIOS-e820: 000000003f5bb000 - 000000003f5bf000 (reserved)
[    0.000000]  BIOS-e820: 000000003f5bf000 - 000000003f670000 (usable)
[    0.000000]  BIOS-e820: 000000003f670000 - 000000003f6bf000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003f6bf000 - 000000003f700000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003f700000 - 0000000040000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] DMI: Acer       Aspire 7720     /Poyang   , BIOS V1.45 11/10/2008
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x3f670 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0FFFE0000 mask FFFFE0000 write-protect
[    0.000000]   1 base 000000000 mask FE0000000 write-back
[    0.000000]   2 base 020000000 mask FE0000000 write-back
[    0.000000]   3 base 03F800000 mask FFF800000 uncachable
[    0.000000]   4 base 03F700000 mask FFFF00000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] found SMP MP-table at [ffff8800000fe1b0] fe1b0
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff88000009a000] 9a000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-000000003f670000
[    0.000000]  0000000000 - 003f600000 page 2M
[    0.000000]  003f600000 - 003f670000 page 4k
[    0.000000] kernel direct mapping tables up to 3f670000 @ 1fffd000-20000000
[    0.000000] RAMDISK: 3674c000 - 3739e000
[    0.000000] ACPI: RSDP 00000000000fe020 00024 (v02 ACRSYS)
[    0.000000] ACPI: XSDT 000000003f6fe120 00064 (v01 ACRSYS ACRPRDCT 00000001      01000013)
[    0.000000] ACPI: FACP 000000003f6fd000 000F4 (v04 ACRSYS ACRPRDCT 00000001 MSFT 01000013)
[    0.000000] ACPI: DSDT 000000003f6f4000 08968 (v01 ACRSYS ACRPRDCT 00000001 MSFT 01000013)
[    0.000000] ACPI: FACS 000000003f675000 00040
[    0.000000] ACPI: APIC 000000003f6f3000 00068 (v02 ACRSYS ACRPRDCT 00000001 MSFT 01000013)
[    0.000000] ACPI: MCFG 000000003f6f2000 0003C (v01 ACRSYS ACRPRDCT 00000001 MSFT 01000013)
[    0.000000] ACPI: SLIC 000000003f6f1000 00176 (v01 ACRSYS ACRPRDCT 00000001 MSFT 01000013)
[    0.000000] ACPI: HPET 000000003f6f0000 00038 (v01 ACRSYS ACRPRDCT 00000001 MSFT 01000013)
[    0.000000] ACPI: SSDT 000000003f6ef000 004C4 (v01  PmRef    CpuPm 00003000 INTL 20051117)
[    0.000000] ACPI: SSDT 000000003f6ee000 00232 (v01  PmRef  Cpu0Tst 00003000 INTL 20051117)
[    0.000000] ACPI: SSDT 000000003f6ed000 000A0 (v01  PmRef  Cpu1Tst 00003000 INTL 20051117)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000003f670000
[    0.000000] Initmem setup node 0 0000000000000000-000000003f670000
[    0.000000]   NODE_DATA [000000003f66b000 - 000000003f66ffff]
[    0.000000]  [ffffea0000000000-ffffea0000dfffff] PMD -> [ffff88003dc00000-ffff88003e9fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   empty
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[5] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0003f4fd
[    0.000000]     0: 0x0003f508 -> 0x0003f552
[    0.000000]     0: 0x0003f555 -> 0x0003f5bb
[    0.000000]     0: 0x0003f5bf -> 0x0003f670
[    0.000000] On node 0 totalpages: 259565
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3922 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 3495 pages used for memmap
[    0.000000]   DMA32 zone: 252087 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 32, address 0xfec00000, GSI 0-23
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
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 000000003f4fd000 - 000000003f508000
[    0.000000] PM: Registered nosave memory: 000000003f552000 - 000000003f555000
[    0.000000] PM: Registered nosave memory: 000000003f5bb000 - 000000003f5bf000
[    0.000000] Allocating PCI resources starting at 40000000 (gap: 40000000:a0000000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88003f200000 s82880 r8192 d23616 u1048576
[    0.000000] pcpu-alloc: s82880 r8192 d23616 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 256009
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.2.0-4-amd64 root=UUID=766415f7-3cd0-4074-8c20-69a0c3d5f111 ro quiet
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 1002564k/1038784k available (3416k kernel code, 524k absent, 35696k reserved, 3319k data, 576k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] NR_IRQS:33024 nr_irqs:512 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1995.429 MHz processor.
[    0.004004] Calibrating delay loop (skipped), value calculated using timer frequency.. 3990.85 BogoMIPS (lpj=7981716)
[    0.004010] pid_max: default: 32768 minimum: 301
[    0.004063] Security Framework initialized
[    0.004071] AppArmor: AppArmor disabled by boot time parameter
[    0.004183] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.008452] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.008791] Mount-cache hash table entries: 256
[    0.008943] Initializing cgroup subsys cpuacct
[    0.008949] Initializing cgroup subsys memory
[    0.008963] Initializing cgroup subsys devices
[    0.008965] Initializing cgroup subsys freezer
[    0.008967] Initializing cgroup subsys net_cls
[    0.008971] Initializing cgroup subsys blkio
[    0.008982] Initializing cgroup subsys perf_event
[    0.009021] CPU: Physical Processor ID: 0
[    0.009022] CPU: Processor Core ID: 0
[    0.009026] mce: CPU supports 6 MCE banks
[    0.009035] CPU0: Thermal monitoring enabled (TM1)
[    0.009040] using mwait in idle threads.
[    0.009536] ACPI: Core revision 20110623
[    0.016532] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.056300] CPU0: Intel(R) Core(TM)2 Duo CPU     T5750  @ 2.00GHz stepping 0d
[    0.060003] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
[    0.060003] PEBS disabled due to CPU errata.
[    0.060003] ... version:                2
[    0.060003] ... bit width:              40
[    0.060003] ... generic registers:      2
[    0.060003] ... value mask:             000000ffffffffff
[    0.060003] ... max period:             000000007fffffff
[    0.060003] ... fixed-purpose events:   3
[    0.060003] ... event mask:             0000000700000003
[    0.060003] NMI watchdog enabled, takes one hw-pmu counter.
[    0.060003] Booting Node   0, Processors  #1 Ok.
[    0.060003] smpboot cpu 1: start_ip = 9a000
[    0.148046] NMI watchdog enabled, takes one hw-pmu counter.
[    0.148095] Brought up 2 CPUs
[    0.148098] Total of 2 processors activated (7980.77 BogoMIPS).
[    0.149421] devtmpfs: initialized
[    0.152723] PM: Registering ACPI NVS region at 3f670000 (323584 bytes)
[    0.152723] print_constraints: dummy: 
[    0.152723] NET: Registered protocol family 16
[    0.152723] ACPI: bus type pci registered
[    0.152723] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.152723] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.187727] PCI: Using configuration type 1 for base access
[    0.188429] bio: create slab <bio-0> at 0
[    0.188429] ACPI: Added _OSI(Module Device)
[    0.188429] ACPI: Added _OSI(Processor Device)
[    0.188429] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.188429] ACPI: Added _OSI(Processor Aggregator Device)
[    0.189764] ACPI: EC: Look up EC in DSDT
[    0.194160] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.196395] ACPI: SSDT 000000003f674c90 0022C (v01  PmRef  Cpu0Ist 00003000 INTL 20051117)
[    0.196811] ACPI: Dynamic OEM Table Load:
[    0.196815] ACPI: SSDT           (null) 0022C (v01  PmRef  Cpu0Ist 00003000 INTL 20051117)
[    0.196977] ACPI: SSDT 000000003f673610 005D7 (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
[    0.197368] ACPI: Dynamic OEM Table Load:
[    0.197371] ACPI: SSDT           (null) 005D7 (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
[    0.220302] ACPI: SSDT 000000003f674f10 000C4 (v01  PmRef  Cpu1Ist 00003000 INTL 20051117)
[    0.220706] ACPI: Dynamic OEM Table Load:
[    0.220710] ACPI: SSDT           (null) 000C4 (v01  PmRef  Cpu1Ist 00003000 INTL 20051117)
[    0.220835] ACPI: SSDT 000000003f676d10 00083 (v01  PmRef  Cpu1Cst 00003000 INTL 20051117)
[    0.221227] ACPI: Dynamic OEM Table Load:
[    0.221230] ACPI: SSDT           (null) 00083 (v01  PmRef  Cpu1Cst 00003000 INTL 20051117)
[    0.244359] ACPI: EC: GPE storm detected, transactions will use polling mode
[    0.260091] ACPI: Interpreter enabled
[    0.260096] ACPI: (supports S0 S3 S4 S5)
[    0.260123] ACPI: Using IOAPIC for interrupt routing
[    0.496753] ACPI: EC: GPE = 0x1c, I/O: command/status = 0x66, data = 0x62
[    0.496987] ACPI: No dock devices found.
[    0.496989] HEST: Table not found.
[    0.496994] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.497437] ACPI Warning: For \_SB_.PCI0._OSC: Parameter count mismatch - ASL declared 5, ACPI requires 4 (20110623/nspredef-359)
[    0.497445] \_SB_.PCI0:_OSC evaluation returned wrong type
[    0.497447] _OSC request data:1 8 1f 
[    0.497453] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.498204] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.498207] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.498211] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.498215] pci_root PNP0A08:00: host bridge window [mem 0x40000000-0xfebfffff]
[    0.498231] pci 0000:00:00.0: [8086:2a00] type 0 class 0x000600
[    0.498287] pci 0000:00:02.0: [8086:2a02] type 0 class 0x000300
[    0.498302] pci 0000:00:02.0: reg 10: [mem 0x53000000-0x530fffff 64bit]
[    0.498313] pci 0000:00:02.0: reg 18: [mem 0x40000000-0x4fffffff 64bit pref]
[    0.498320] pci 0000:00:02.0: reg 20: [io  0x4110-0x4117]
[    0.498365] pci 0000:00:02.1: [8086:2a03] type 0 class 0x000380
[    0.498378] pci 0000:00:02.1: reg 10: [mem 0x00000000-0x000fffff 64bit]
[    0.498477] pci 0000:00:1a.0: [8086:2834] type 0 class 0x000c03
[    0.498538] pci 0000:00:1a.0: reg 20: [io  0x40c0-0x40df]
[    0.498591] pci 0000:00:1a.1: [8086:2835] type 0 class 0x000c03
[    0.498652] pci 0000:00:1a.1: reg 20: [io  0x40a0-0x40bf]
[    0.498717] pci 0000:00:1a.7: [8086:283a] type 0 class 0x000c03
[    0.498744] pci 0000:00:1a.7: reg 10: [mem 0x56304c00-0x56304fff]
[    0.498858] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.498896] pci 0000:00:1b.0: [8086:284b] type 0 class 0x000403
[    0.498921] pci 0000:00:1b.0: reg 10: [mem 0x56300000-0x56303fff 64bit]
[    0.499033] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.499070] pci 0000:00:1c.0: [8086:283f] type 1 class 0x000604
[    0.499189] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.499229] pci 0000:00:1c.1: [8086:2841] type 1 class 0x000604
[    0.499347] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.499388] pci 0000:00:1c.2: [8086:2843] type 1 class 0x000604
[    0.499506] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.499548] pci 0000:00:1d.0: [8086:2830] type 0 class 0x000c03
[    0.499609] pci 0000:00:1d.0: reg 20: [io  0x4080-0x409f]
[    0.499657] pci 0000:00:1d.1: [8086:2831] type 0 class 0x000c03
[    0.499718] pci 0000:00:1d.1: reg 20: [io  0x4060-0x407f]
[    0.499767] pci 0000:00:1d.2: [8086:2832] type 0 class 0x000c03
[    0.499827] pci 0000:00:1d.2: reg 20: [io  0x4040-0x405f]
[    0.499889] pci 0000:00:1d.7: [8086:2836] type 0 class 0x000c03
[    0.499916] pci 0000:00:1d.7: reg 10: [mem 0x56304800-0x56304bff]
[    0.500037] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.500069] pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
[    0.500175] pci 0000:00:1f.0: [8086:2815] type 0 class 0x000601
[    0.500302] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at ff2c (mask 0003)
[    0.500307] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 0068 (mask 0007)
[    0.500371] pci 0000:00:1f.1: [8086:2850] type 0 class 0x000101
[    0.500389] pci 0000:00:1f.1: reg 10: [io  0x4108-0x410f]
[    0.500402] pci 0000:00:1f.1: reg 14: [io  0x4124-0x4127]
[    0.500416] pci 0000:00:1f.1: reg 18: [io  0x4100-0x4107]
[    0.500429] pci 0000:00:1f.1: reg 1c: [io  0x4120-0x4123]
[    0.500442] pci 0000:00:1f.1: reg 20: [io  0x40e0-0x40ef]
[    0.500502] pci 0000:00:1f.2: [8086:2829] type 0 class 0x000106
[    0.500532] pci 0000:00:1f.2: reg 10: [io  0x40f8-0x40ff]
[    0.500545] pci 0000:00:1f.2: reg 14: [io  0x411c-0x411f]
[    0.500559] pci 0000:00:1f.2: reg 18: [io  0x40f0-0x40f7]
[    0.500572] pci 0000:00:1f.2: reg 1c: [io  0x4118-0x411b]
[    0.500585] pci 0000:00:1f.2: reg 20: [io  0x4020-0x403f]
[    0.500598] pci 0000:00:1f.2: reg 24: [mem 0x56304000-0x563047ff]
[    0.500669] pci 0000:00:1f.2: PME# supported from D3hot
[    0.500697] pci 0000:00:1f.3: [8086:283e] type 0 class 0x000c05
[    0.500716] pci 0000:00:1f.3: reg 10: [mem 0x56305000-0x563050ff]
[    0.500761] pci 0000:00:1f.3: reg 20: [io  0x4000-0x401f]
[    0.500869] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.500874] pci 0000:00:1c.0:   bridge window [io  0x3000-0x3fff]
[    0.500880] pci 0000:00:1c.0:   bridge window [mem 0x55300000-0x562fffff]
[    0.500889] pci 0000:00:1c.0:   bridge window [mem 0x50000000-0x50ffffff 64bit pref]
[    0.500956] pci 0000:00:1c.1: PCI bridge to [bus 04-04]
[    0.500962] pci 0000:00:1c.1:   bridge window [io  0x2000-0x2fff]
[    0.500968] pci 0000:00:1c.1:   bridge window [mem 0x54300000-0x552fffff]
[    0.500977] pci 0000:00:1c.1:   bridge window [mem 0x51000000-0x51ffffff 64bit pref]
[    0.501080] pci 0000:05:00.0: [14e4:1693] type 0 class 0x000200
[    0.501114] pci 0000:05:00.0: reg 10: [mem 0x53200000-0x5320ffff 64bit]
[    0.501309] pci 0000:05:00.0: PME# supported from D3hot D3cold
[    0.508052] pci 0000:00:1c.2: PCI bridge to [bus 05-05]
[    0.508058] pci 0000:00:1c.2:   bridge window [io  0x1000-0x1fff]
[    0.508064] pci 0000:00:1c.2:   bridge window [mem 0x53200000-0x542fffff]
[    0.508073] pci 0000:00:1c.2:   bridge window [mem 0x52000000-0x52ffffff 64bit pref]
[    0.508125] pci 0000:07:00.0: [1180:0832] type 0 class 0x000c00
[    0.508143] pci 0000:07:00.0: proprietary Ricoh MMC controller disabled (via firewire function)
[    0.508146] pci 0000:07:00.0: MMC cards are now supported by standard SDHCI controller
[    0.508164] pci 0000:07:00.0: reg 10: [mem 0x53100000-0x531007ff]
[    0.508271] pci 0000:07:00.0: supports D1 D2
[    0.508273] pci 0000:07:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.508303] pci 0000:07:00.1: [1180:0822] type 0 class 0x000805
[    0.508328] pci 0000:07:00.1: reg 10: [mem 0x53100b00-0x53100bff]
[    0.508433] pci 0000:07:00.1: supports D1 D2
[    0.508436] pci 0000:07:00.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.508464] pci 0000:07:00.2: [1180:0592] type 0 class 0x000880
[    0.508487] pci 0000:07:00.2: reg 10: [mem 0x53100900-0x531009ff]
[    0.508595] pci 0000:07:00.2: supports D1 D2
[    0.508597] pci 0000:07:00.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.508627] pci 0000:07:00.3: [1180:0852] type 0 class 0x000880
[    0.508651] pci 0000:07:00.3: reg 10: [mem 0x53100800-0x531008ff]
[    0.508760] pci 0000:07:00.3: supports D1 D2
[    0.508762] pci 0000:07:00.3: PME# supported from D0 D1 D2 D3hot D3cold
[    0.508843] pci 0000:00:1e.0: PCI bridge to [bus 07-07] (subtractive decode)
[    0.508852] pci 0000:00:1e.0:   bridge window [mem 0x53100000-0x531fffff]
[    0.508862] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.508865] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.508868] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.508872] pci 0000:00:1e.0:   bridge window [mem 0x40000000-0xfebfffff] (subtractive decode)
[    0.508903] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.509102] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P32_._PRT]
[    0.509194] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP2._PRT]
[    0.509263] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
[    0.509433] ACPI Warning: For \_SB_.PCI0._OSC: Parameter count mismatch - ASL declared 5, ACPI requires 4 (20110623/nspredef-359)
[    0.509441] \_SB_.PCI0:_OSC evaluation returned wrong type
[    0.509443] _OSC request data:1 1f 1f 
[    0.509448]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.509518] ACPI Warning: For \_SB_.PCI0._OSC: Parameter count mismatch - ASL declared 5, ACPI requires 4 (20110623/nspredef-359)
[    0.509526] \_SB_.PCI0:_OSC evaluation returned wrong type
[    0.509528] _OSC request data:1 0 1d 
[    0.509533]  pci0000:00: ACPI _OSC request failed (AE_TYPE), returned control mask: 0x1d
[    0.509536] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.517647] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 10 *11 12)
[    0.517723] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 10 *11 12)
[    0.517797] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 10 *11 12)
[    0.517870] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 *11 12)
[    0.517944] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 9 10 11 12) *0, disabled.
[    0.518020] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 *10 11 12)
[    0.518093] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 9 10 *11 12)
[    0.518166] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 9 10 *11 12)
[    0.518298] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.518298] vgaarb: loaded
[    0.518298] vgaarb: bridge control possible 0000:00:02.0
[    0.518298] PCI: Using ACPI for IRQ routing
[    0.530175] PCI: pci_cache_line_size set to 64 bytes
[    0.530296] reserve RAM buffer: 000000000009fc00 - 000000000009ffff 
[    0.530299] reserve RAM buffer: 000000003f4fd000 - 000000003fffffff 
[    0.530304] reserve RAM buffer: 000000003f552000 - 000000003fffffff 
[    0.530308] reserve RAM buffer: 000000003f5bb000 - 000000003fffffff 
[    0.530312] reserve RAM buffer: 000000003f670000 - 000000003fffffff 
[    0.530455] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.530463] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.530468] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.536170] Switching to clocksource hpet
[    0.538426] pnp: PnP ACPI init
[    0.538446] ACPI: bus type pnp registered
[    0.538847] pnp 00:00: [bus 00-ff]
[    0.538850] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.538853] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.538856] pnp 00:00: [io  0x0d00-0xffff window]
[    0.538858] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.538861] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    0.538864] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    0.538867] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    0.538869] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    0.538872] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    0.538876] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    0.538879] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    0.538882] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    0.538884] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    0.538887] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    0.538890] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    0.538893] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    0.538895] pnp 00:00: [mem 0x000f0000-0x000fffff window]
[    0.538898] pnp 00:00: [mem 0x40000000-0xfebfffff window]
[    0.538992] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.539191] pnp 00:01: [io  0x002e-0x002f]
[    0.539193] pnp 00:01: [io  0x004e-0x004f]
[    0.539196] pnp 00:01: [io  0x0068]
[    0.539198] pnp 00:01: [io  0x006c]
[    0.539200] pnp 00:01: [io  0x164e-0x164f]
[    0.539203] pnp 00:01: [io  0x0061]
[    0.539205] pnp 00:01: [io  0x0070]
[    0.539207] pnp 00:01: [io  0x0080]
[    0.539209] pnp 00:01: [io  0x0092]
[    0.539211] pnp 00:01: [io  0x00b2-0x00b3]
[    0.539214] pnp 00:01: [io  0x0063]
[    0.539216] pnp 00:01: [io  0x0065]
[    0.539218] pnp 00:01: [io  0x0067]
[    0.539220] pnp 00:01: [io  0x0600-0x060f]
[    0.539223] pnp 00:01: [io  0x0610]
[    0.539225] pnp 00:01: [io  0x0800-0x080f]
[    0.539227] pnp 00:01: [io  0x0810-0x0817]
[    0.539229] pnp 00:01: [io  0x0400-0x047f]
[    0.539232] pnp 00:01: [io  0x0500-0x053f]
[    0.539234] pnp 00:01: [mem 0xe0000000-0xefffffff]
[    0.539237] pnp 00:01: [mem 0xfed1c000-0xfed1ffff]
[    0.539241] pnp 00:01: [mem 0xfed14000-0xfed17fff]
[    0.539243] pnp 00:01: [mem 0xfed18000-0xfed18fff]
[    0.539246] pnp 00:01: [mem 0xfed19000-0xfed19fff]
[    0.539248] pnp 00:01: [mem 0xfec00000-0xfec00fff]
[    0.539251] pnp 00:01: [mem 0xfee00000-0xfee00fff]
[    0.539253] pnp 00:01: [mem 0x32000000-0x320000ff]
[    0.539284] pnp 00:01: disabling [io  0x164e-0x164f] because it overlaps 0000:00:1c.2 BAR 13 [io  0x1000-0x1fff]
[    0.539363] system 00:01: [io  0x0600-0x060f] has been reserved
[    0.539367] system 00:01: [io  0x0610] has been reserved
[    0.539370] system 00:01: [io  0x0800-0x080f] has been reserved
[    0.539374] system 00:01: [io  0x0810-0x0817] has been reserved
[    0.539377] system 00:01: [io  0x0400-0x047f] has been reserved
[    0.539380] system 00:01: [io  0x0500-0x053f] has been reserved
[    0.539385] system 00:01: [mem 0xe0000000-0xefffffff] has been reserved
[    0.539388] system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.539392] system 00:01: [mem 0xfed14000-0xfed17fff] has been reserved
[    0.539396] system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.539401] system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.539405] system 00:01: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.539408] system 00:01: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.539412] system 00:01: [mem 0x32000000-0x320000ff] could not be reserved
[    0.539416] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.539468] pnp 00:02: [io  0x0000-0x001f]
[    0.539471] pnp 00:02: [io  0x0081-0x0091]
[    0.539473] pnp 00:02: [io  0x0093-0x009f]
[    0.539475] pnp 00:02: [io  0x00c0-0x00df]
[    0.539478] pnp 00:02: [dma 4]
[    0.539513] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.539542] pnp 00:03: [io  0x0070-0x0077]
[    0.539577] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.539662] pnp 00:04: [irq 0 disabled]
[    0.539676] pnp 00:04: [irq 8]
[    0.539679] pnp 00:04: [mem 0xfed00000-0xfed003ff]
[    0.539713] pnp 00:04: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.539728] pnp 00:05: [io  0x00f0]
[    0.539734] pnp 00:05: [irq 13]
[    0.539770] pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.539784] pnp 00:06: [mem 0xfff00000-0xffffffff]
[    0.539821] pnp 00:06: Plug and Play ACPI device, IDs INT0800 (active)
[    0.539852] pnp 00:07: [io  0x0060]
[    0.539858] pnp 00:07: [io  0x0064]
[    0.539864] pnp 00:07: [irq 1]
[    0.539900] pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.539955] pnp 00:08: [irq 12]
[    0.539993] pnp 00:08: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.664113] pnp 00:09: [io  0xff2c-0xff2f]
[    0.664122] pnp 00:09: [irq 4]
[    0.664191] pnp 00:09: Plug and Play ACPI device, IDs ENE0100 (active)
[    0.664207] pnp: PnP ACPI: found 10 devices
[    0.664209] ACPI: ACPI bus type pnp unregistered
[    0.671909] PCI: max bus depth: 1 pci_try_num: 2
[    0.671963] pci 0000:00:02.1: BAR 0: assigned [mem 0x56400000-0x564fffff 64bit]
[    0.671970] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.671975] pci 0000:00:1c.0:   bridge window [io  0x3000-0x3fff]
[    0.671982] pci 0000:00:1c.0:   bridge window [mem 0x55300000-0x562fffff]
[    0.671988] pci 0000:00:1c.0:   bridge window [mem 0x50000000-0x50ffffff 64bit pref]
[    0.671997] pci 0000:00:1c.1: PCI bridge to [bus 04-04]
[    0.672013] pci 0000:00:1c.1:   bridge window [io  0x2000-0x2fff]
[    0.672020] pci 0000:00:1c.1:   bridge window [mem 0x54300000-0x552fffff]
[    0.672026] pci 0000:00:1c.1:   bridge window [mem 0x51000000-0x51ffffff 64bit pref]
[    0.672035] pci 0000:00:1c.2: PCI bridge to [bus 05-05]
[    0.672039] pci 0000:00:1c.2:   bridge window [io  0x1000-0x1fff]
[    0.672046] pci 0000:00:1c.2:   bridge window [mem 0x53200000-0x542fffff]
[    0.672052] pci 0000:00:1c.2:   bridge window [mem 0x52000000-0x52ffffff 64bit pref]
[    0.672062] pci 0000:00:1e.0: PCI bridge to [bus 07-07]
[    0.672069] pci 0000:00:1e.0:   bridge window [mem 0x53100000-0x531fffff]
[    0.672100] pci 0000:00:1c.0: setting latency timer to 64
[    0.672115] pci 0000:00:1c.1: setting latency timer to 64
[    0.672129] pci 0000:00:1c.2: setting latency timer to 64
[    0.672138] pci 0000:00:1e.0: setting latency timer to 64
[    0.672143] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.672146] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.672149] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.672151] pci_bus 0000:00: resource 7 [mem 0x40000000-0xfebfffff]
[    0.672155] pci_bus 0000:02: resource 0 [io  0x3000-0x3fff]
[    0.672157] pci_bus 0000:02: resource 1 [mem 0x55300000-0x562fffff]
[    0.672160] pci_bus 0000:02: resource 2 [mem 0x50000000-0x50ffffff 64bit pref]
[    0.672163] pci_bus 0000:04: resource 0 [io  0x2000-0x2fff]
[    0.672166] pci_bus 0000:04: resource 1 [mem 0x54300000-0x552fffff]
[    0.672169] pci_bus 0000:04: resource 2 [mem 0x51000000-0x51ffffff 64bit pref]
[    0.672172] pci_bus 0000:05: resource 0 [io  0x1000-0x1fff]
[    0.672175] pci_bus 0000:05: resource 1 [mem 0x53200000-0x542fffff]
[    0.672178] pci_bus 0000:05: resource 2 [mem 0x52000000-0x52ffffff 64bit pref]
[    0.672181] pci_bus 0000:07: resource 1 [mem 0x53100000-0x531fffff]
[    0.672184] pci_bus 0000:07: resource 4 [io  0x0000-0x0cf7]
[    0.672186] pci_bus 0000:07: resource 5 [io  0x0d00-0xffff]
[    0.672189] pci_bus 0000:07: resource 6 [mem 0x000a0000-0x000bffff]
[    0.672192] pci_bus 0000:07: resource 7 [mem 0x40000000-0xfebfffff]
[    0.672265] NET: Registered protocol family 2
[    0.672374] IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.672949] TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
[    0.674067] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.674868] TCP: Hash tables configured (established 131072 bind 65536)
[    0.674871] TCP reno registered
[    0.674882] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.674901] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.675090] NET: Registered protocol family 1
[    0.675118] pci 0000:00:02.0: Boot video device
[    0.675598] PCI: CLS 0 bytes, default 64
[    0.675671] Unpacking initramfs...
[    0.995502] Freeing initrd memory: 12616k freed
[    1.005593] audit: initializing netlink socket (disabled)
[    1.005612] type=2000 audit(1353284629.000:1): initialized
[    1.020274] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.020731] VFS: Disk quotas dquot_6.5.2
[    1.020768] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.020854] msgmni has been set to 1982
[    1.021054] alg: No test for stdrng (krng)
[    1.021093] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    1.021097] io scheduler noop registered
[    1.021099] io scheduler deadline registered
[    1.021117] io scheduler cfq registered (default)
[    1.021229] pcieport 0000:00:1c.0: setting latency timer to 64
[    1.021298] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
[    1.021391] pcieport 0000:00:1c.1: setting latency timer to 64
[    1.021451] pcieport 0000:00:1c.1: irq 41 for MSI/MSI-X
[    1.021539] pcieport 0000:00:1c.2: setting latency timer to 64
[    1.021597] pcieport 0000:00:1c.2: irq 42 for MSI/MSI-X
[    1.021720] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.021751] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.021753] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    1.022034] acpiphp: Slot [1] registered
[    1.022195] intel_idle: does not run on family 6 model 15
[    1.022233] ERST: Table is not found!
[    1.022235] GHES: HEST is not enabled!
[    1.022311] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.072378] Linux agpgart interface v0.103
[    1.072476] agpgart-intel 0000:00:00.0: Intel 965GM Chipset
[    1.072577] agpgart-intel 0000:00:00.0: detected gtt size: 524288K total, 262144K mappable
[    1.073155] agpgart-intel 0000:00:00.0: detected 8192K stolen memory
[    1.073312] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0x40000000
[    1.073467] i8042: PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0x64 irq 1,12
[    1.110749] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.110758] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.110925] mousedev: PS/2 mouse device common for all mice
[    1.113964] rtc_cmos 00:03: RTC can wake from S4
[    1.114118] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    1.114155] rtc0: alarms up to one month, 242 bytes nvram, hpet irqs
[    1.114167] cpuidle: using governor ladder
[    1.114169] cpuidle: using governor menu
[    1.114415] TCP cubic registered
[    1.114468] NET: Registered protocol family 10
[    1.115003] Mobile IPv6
[    1.115006] NET: Registered protocol family 17
[    1.115011] Registering the dns_resolver key type
[    1.115188] PM: Hibernation image not present or could not be loaded.
[    1.115202] registered taskstats version 1
[    1.115758] rtc_cmos 00:03: setting system clock to 2012-11-19 00:23:50 UTC (1353284630)
[    1.115830] Initializing network drop monitor service
[    1.117303] Freeing unused kernel memory: 576k freed
[    1.117483] Write protecting the kernel read-only data: 6144k
[    1.120480] Freeing unused kernel memory: 664k freed
[    1.123691] Freeing unused kernel memory: 680k freed
[    1.144115] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    1.205883] udevd[52]: starting version 175
[    1.235157] usbcore: registered new interface driver usbfs
[    1.235207] usbcore: registered new interface driver hub
[    1.271006] SCSI subsystem initialized
[    1.274339] tg3.c:v3.121 (November 2, 2011)
[    1.274371] tg3 0000:05:00.0: setting latency timer to 64
[    1.278583] usbcore: registered new device driver usb
[    1.279161] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.279219] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    1.279225] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    1.279253] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    1.279293] ehci_hcd 0000:00:1a.7: debug port 1
[    1.283193] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    1.283236] ehci_hcd 0000:00:1a.7: irq 18, io mem 0x56304c00
[    1.312036] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    1.312076] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.312079] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.312083] usb usb1: Product: EHCI Host Controller
[    1.312085] usb usb1: Manufacturer: Linux 3.2.0-4-amd64 ehci_hcd
[    1.312087] usb usb1: SerialNumber: 0000:00:1a.7
[    1.312231] hub 1-0:1.0: USB hub found
[    1.312236] hub 1-0:1.0: 4 ports detected
[    1.312372] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    1.312377] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    1.312387] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    1.312423] ehci_hcd 0000:00:1d.7: debug port 1
[    1.316300] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    1.320493] uhci_hcd: USB Universal Host Controller Interface driver
[    1.328654] tg3 0000:05:00.0: eth0: Tigon3 [partno(BCM95787m) rev b002] (PCI Express) MAC address 00:1e:ec:4b:80:e9
[    1.328660] tg3 0000:05:00.0: eth0: attached PHY is 5787 (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[0])
[    1.328665] tg3 0000:05:00.0: eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[    1.328668] tg3 0000:05:00.0: eth0: dma_rwctrl[76180000] dma_mask[64-bit]
[    1.329244] libata version 3.00 loaded.
[    1.344705] ehci_hcd 0000:00:1d.7: irq 23, io mem 0x56304800
[    1.350900] sdhci: Secure Digital Host Controller Interface driver
[    1.350904] sdhci: Copyright(c) Pierre Ossman
[    1.351217] sdhci-pci 0000:07:00.1: SDHCI controller found [1180:0822] (rev 22)
[    1.352280] sdhci-pci 0000:07:00.1: Will use DMA mode even though HW doesn't fully claim to support it.
[    1.352290] sdhci-pci 0000:07:00.1: setting latency timer to 64
[    1.352326] mmc0: no vmmc regulator found
[    1.355254] Registered led device: mmc0::
[    1.357529] mmc0: SDHCI controller on PCI [0000:07:00.1] using DMA
[    1.357600] firewire_ohci 0000:07:00.0: setting latency timer to 64
[    1.364181] thermal LNXTHERM:00: registered as thermal_zone0
[    1.364185] ACPI: Thermal Zone [TZ01] (45 C)
[    1.368166] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    1.368205] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    1.368209] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.368212] usb usb2: Product: EHCI Host Controller
[    1.368214] usb usb2: Manufacturer: Linux 3.2.0-4-amd64 ehci_hcd
[    1.368217] usb usb2: SerialNumber: 0000:00:1d.7
[    1.368375] hub 2-0:1.0: USB hub found
[    1.368382] hub 2-0:1.0: 6 ports detected
[    1.368522] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    1.368528] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    1.368542] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    1.368597] uhci_hcd 0000:00:1a.0: irq 16, io base 0x000040c0
[    1.368649] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    1.368653] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.368656] usb usb3: Product: UHCI Host Controller
[    1.368658] usb usb3: Manufacturer: Linux 3.2.0-4-amd64 uhci_hcd
[    1.368660] usb usb3: SerialNumber: 0000:00:1a.0
[    1.368786] hub 3-0:1.0: USB hub found
[    1.368792] hub 3-0:1.0: 2 ports detected
[    1.368887] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    1.368892] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    1.368901] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    1.368947] uhci_hcd 0000:00:1a.1: irq 21, io base 0x000040a0
[    1.368992] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    1.368995] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.368997] usb usb4: Product: UHCI Host Controller
[    1.369000] usb usb4: Manufacturer: Linux 3.2.0-4-amd64 uhci_hcd
[    1.369002] usb usb4: SerialNumber: 0000:00:1a.1
[    1.369124] hub 4-0:1.0: USB hub found
[    1.369129] hub 4-0:1.0: 2 ports detected
[    1.369224] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    1.369228] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    1.369238] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
[    1.369270] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00004080
[    1.369312] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    1.369315] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.369318] usb usb5: Product: UHCI Host Controller
[    1.369320] usb usb5: Manufacturer: Linux 3.2.0-4-amd64 uhci_hcd
[    1.369323] usb usb5: SerialNumber: 0000:00:1d.0
[    1.369439] hub 5-0:1.0: USB hub found
[    1.369444] hub 5-0:1.0: 2 ports detected
[    1.369537] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    1.369541] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    1.369551] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
[    1.369596] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00004060
[    1.369647] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    1.369650] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.369653] usb usb6: Product: UHCI Host Controller
[    1.369655] usb usb6: Manufacturer: Linux 3.2.0-4-amd64 uhci_hcd
[    1.369658] usb usb6: SerialNumber: 0000:00:1d.1
[    1.369777] hub 6-0:1.0: USB hub found
[    1.369782] hub 6-0:1.0: 2 ports detected
[    1.369879] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    1.369883] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    1.369892] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
[    1.369925] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00004040
[    1.369970] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    1.369974] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.369976] usb usb7: Product: UHCI Host Controller
[    1.369979] usb usb7: Manufacturer: Linux 3.2.0-4-amd64 uhci_hcd
[    1.369981] usb usb7: SerialNumber: 0000:00:1d.2
[    1.370272] hub 7-0:1.0: USB hub found
[    1.370278] hub 7-0:1.0: 2 ports detected
[    1.370557] ahci 0000:00:1f.2: version 3.0
[    1.370633] ahci 0000:00:1f.2: irq 43 for MSI/MSI-X
[    1.370718] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 3 ports 3 Gbps 0x7 impl SATA mode
[    1.370722] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ccc ems 
[    1.370729] ahci 0000:00:1f.2: setting latency timer to 64
[    1.392139] scsi0 : ahci
[    1.392386] scsi1 : ahci
[    1.392463] scsi2 : ahci
[    1.392678] ata1: SATA max UDMA/133 abar m2048@0x56304000 port 0x56304100 irq 43
[    1.392683] ata2: SATA max UDMA/133 abar m2048@0x56304000 port 0x56304180 irq 43
[    1.392687] ata3: SATA max UDMA/133 abar m2048@0x56304000 port 0x56304200 irq 43
[    1.392746] ata_piix 0000:00:1f.1: version 2.13
[    1.392809] ata_piix 0000:00:1f.1: setting latency timer to 64
[    1.393173] scsi3 : ata_piix
[    1.393262] scsi4 : ata_piix
[    1.393703] ata4: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x40e0 irq 14
[    1.393706] ata5: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x40e8 irq 15
[    1.420082] firewire_ohci: Added fw-ohci device 0000:07:00.0, OHCI v1.10, 4 IR + 4 IT contexts, quirks 0x11
[    1.559473] ata4.00: ATAPI: HL-DT-ST DVDRAM GSA-T40N, JP01, max UDMA/33
[    1.572261] ata4.00: configured for UDMA/33
[    1.624022] usb 1-1: new high-speed USB device number 2 using ehci_hcd
[    1.712033] ata2: SATA link down (SStatus 0 SControl 300)
[    1.712059] ata3: SATA link down (SStatus 0 SControl 300)
[    1.712087] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.713000] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    1.713351] ata1.00: ATA-8: Hitachi HTS542525K9SA00, BBFOC31P, max UDMA/133
[    1.713354] ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.714566] ata1.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
[    1.714916] ata1.00: configured for UDMA/133
[    1.715068] scsi 0:0:0:0: Direct-Access     ATA      Hitachi HTS54252 BBFO PQ: 0 ANSI: 5
[    1.718848] scsi 3:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-T40N  JP01 PQ: 0 ANSI: 5
[    1.724927] sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
[    1.725081] sd 0:0:0:0: [sda] Write Protect is off
[    1.725085] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.725111] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.730313] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    1.730316] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.730537] sr 3:0:0:0: Attached scsi CD-ROM sr0
[    1.757536] usb 1-1: New USB device found, idVendor=7392, idProduct=7822
[    1.757539] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    1.757542] usb 1-1: Product: 802.11n WLAN Adapter
[    1.757545] usb 1-1: Manufacturer: Realtek
[    1.757547] usb 1-1: SerialNumber: 00e04c000001
[    1.794998]  sda: sda1 sda2 sda3 < sda5 sda6 sda7 >
[    1.795613] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.798088] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.798158] sr 3:0:0:0: Attached scsi generic sg1 type 5
[    1.868034] usb 2-4: new high-speed USB device number 2 using ehci_hcd
[    1.920121] firewire_core: created device fw0: GUID c740e01200023f85, S400
[    2.004021] Refined TSC clocksource calibration: 1994.999 MHz.
[    2.004027] Switching to clocksource tsc
[    2.294378] usb 2-4: New USB device found, idVendor=5986, idProduct=0102
[    2.294382] usb 2-4: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    2.294385] usb 2-4: Product: Acer Crystal Eye webcam 
[    2.452036] usb 2-5: new high-speed USB device number 3 using ehci_hcd
[    2.573162] PM: Starting manual resume from disk
[    2.573166] PM: Hibernation image partition 8:5 present
[    2.573168] PM: Looking for hibernation image.
[    2.573409] PM: Image not found (code -22)
[    2.573411] PM: Hibernation image not present or could not be loaded.
[    2.587498] usb 2-5: New USB device found, idVendor=0951, idProduct=1643
[    2.587502] usb 2-5: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    2.587505] usb 2-5: Product: DataTraveler G3
[    2.587507] usb 2-5: Manufacturer: Kingston
[    2.587509] usb 2-5: SerialNumber: F46D04613D14BCA1D931010E
[    2.590109] usbcore: registered new interface driver uas
[    2.591178] Initializing USB Mass Storage driver...
[    2.591293] scsi5 : usb-storage 2-5:1.0
[    2.591382] usbcore: registered new interface driver usb-storage
[    2.591385] USB Mass Storage support registered.
[    2.604810] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[    3.589018] scsi 5:0:0:0: Direct-Access     Kingston DataTraveler G3  PMAP PQ: 0 ANSI: 4
[    3.589575] sd 5:0:0:0: Attached scsi generic sg2 type 0
[    3.590383] sd 5:0:0:0: [sdb] 15187968 512-byte logical blocks: (7.77 GB/7.24 GiB)
[    3.591377] sd 5:0:0:0: [sdb] Write Protect is off
[    3.591380] sd 5:0:0:0: [sdb] Mode Sense: 23 00 00 00
[    3.592503] sd 5:0:0:0: [sdb] No Caching mode page present
[    3.592556] sd 5:0:0:0: [sdb] Assuming drive cache: write through
[    3.596753] sd 5:0:0:0: [sdb] No Caching mode page present
[    3.596804] sd 5:0:0:0: [sdb] Assuming drive cache: write through
[    3.597767]  sdb: sdb1
[    3.601127] sd 5:0:0:0: [sdb] No Caching mode page present
[    3.601178] sd 5:0:0:0: [sdb] Assuming drive cache: write through
[    3.601230] sd 5:0:0:0: [sdb] Attached SCSI removable disk
[    4.979478] udevd[377]: starting version 175
[    5.784136] ACPI: AC Adapter [AC] (on-line)
[    5.784240] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:03/PNP0C0C:00/input/input1
[    5.784248] ACPI: Power Button [PWRB]
[    5.784321] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:03/PNP0C0D:00/input/input2
[    5.784350] ACPI: Lid Switch [LID0]
[    5.784415] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:03/PNP0C0E:00/input/input3
[    5.784419] ACPI: Sleep Button [SLPB]
[    5.784498] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input4
[    5.784502] ACPI: Power Button [PWRF]
[    5.873942] ACPI: Requesting acpi_cpufreq
[    5.880133] Monitor-Mwait will be used to enter C-1 state
[    5.880140] Monitor-Mwait will be used to enter C-2 state
[    5.880145] Monitor-Mwait will be used to enter C-3 state
[    5.880150] Marking TSC unstable due to TSC halts in idle
[    5.880164] ACPI: acpi_idle registered with cpuidle
[    5.881153] Switching to clocksource hpet
[    6.062378] IR NEC protocol handler initialized
[    6.062589] ene_ir: chip is 0x3909 - kbver = 0x24, rev = 0xc0
[    6.062591] ene_ir: PLL freq = 1406
[    6.062593] ene_ir: KB3926B detected
[    6.141924] input: PC Speaker as /devices/platform/pcspkr/input/input5
[    6.350304] wmi: Mapper loaded
[    6.473775] iTCO_vendor_support: vendor-support=0
[    6.981358] Linux media interface: v0.10
[    7.124756] cfg80211: Calling CRDA to update world regulatory domain
[    7.559117] cfg80211: World regulatory domain updated:
[    7.559123] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    7.559128] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    7.559134] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[    7.559139] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[    7.559144] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    7.559148] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    7.644229] ACPI: Battery Slot [BAT0] (battery present)
[    7.668070] Registered IR keymap rc-rc6-mce
[    7.668274] input: ENE eHome Infrared Remote Receiver as /devices/virtual/rc/rc0/input6
[    7.668387] rc0: ENE eHome Infrared Remote Receiver as /devices/virtual/rc/rc0
[    7.668649] ene_ir: driver has been successfully loaded
[    7.768806] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.07
[    7.768969] iTCO_wdt: Found a ICH8M TCO device (Version=2, TCOBASE=0x0460)
[    7.769075] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    7.794628] Linux video capture interface: v2.00
[    7.882753] acer_wmi: Acer Laptop ACPI-WMI Extras
[    7.890191] IR RC5(x) protocol handler initialized
[    7.918769] [drm] Initialized drm 1.1.0 20060810
[    7.920159] acer_wmi: Function bitmap for Communication Device: 0x0
[    7.920331] acer_wmi: Brightness must be controlled by generic video driver
[    7.954970] r592 0000:07:00.2: setting latency timer to 64
[    7.955081] r592: driver successfully loaded
[    7.962538] IR RC6 protocol handler initialized
[    7.985589] IR JVC protocol handler initialized
[    7.997255] IR Sony protocol handler initialized
[    8.045981] uvcvideo: Found UVC 1.00 device Acer Crystal Eye webcam  (5986:0102)
[    8.127168] i915 0000:00:02.0: setting latency timer to 64
[    8.167838] r852 0000:07:00.3: setting latency timer to 64
[    8.173273] i915 0000:00:02.0: irq 44 for MSI/MSI-X
[    8.173292] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    8.173294] [drm] Driver supports precise vblank timestamp query.
[    8.173344] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    8.208149] input: Acer Crystal Eye webcam  as /devices/pci0000:00/0000:00:1d.7/usb2/2-4/2-4:1.0/input/input7
[    8.208288] usbcore: registered new interface driver uvcvideo
[    8.208291] USB Video Class driver (1.1.1)
[    8.226565] r852: driver loaded successfully
[    8.227916] fixme: max PWM is zero.
[    8.236282] input: MCE IR Keyboard/Mouse (ene_ir) as /devices/virtual/input/input8
[    8.236449] IR MCE Keyboard/mouse protocol handler initialized
[    8.251526] lirc_dev: IR Remote Control driver registered, major 250 
[    8.261674] rtl8192cu: MAC address: 80:1f:02:6e:48:d3
[    8.261684] rtl8192cu: Board Type 0
[    8.267670] rc rc0: lirc_dev: driver ir-lirc-codec (ene_ir) registered at minor = 0
[    8.267673] IR LIRC bridge handler initialized
[    8.379797] rtlwifi: rx_max_size 15360, rx_urb_num 8, in_ep 1
[    8.379946] cfg80211: Calling CRDA for country: US
[    8.385671] cfg80211: Regulatory domain changed to country: US
[    8.385675] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    8.385679] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
[    8.385682] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
[    8.385686] cfg80211:     (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    8.385689] cfg80211:     (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    8.385692] cfg80211:     (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    8.385695] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
[    8.485250] [drm] initialized overlay support
[    8.594367] ieee80211 phy0: Selected rate control algorithm 'rtl_rc'
[    8.595102] usbcore: registered new interface driver rtl8192cu
[    8.652639] fbcon: inteldrmfb (fb0) is primary device
[    8.930633] Console: switching to colour frame buffer device 180x56
[    8.935513] fb0: inteldrmfb frame buffer device
[    8.935515] drm: registered panic notifier
[    8.960700] input: PS/2 Mouse as /devices/platform/i8042/serio1/input/input9
[    8.992770] input: AlpsPS/2 ALPS GlidePoint as /devices/platform/i8042/serio1/input/input10
[    9.336124] acpi device:3b: registered as cooling_device2
[    9.336303] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:01/input/input11
[    9.337086] ACPI: Video Device [OVGA] (multi-head: yes  rom: no  post: no)
[    9.337182] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    9.354485] snd_hda_intel 0000:00:1b.0: irq 45 for MSI/MSI-X
[    9.354524] snd_hda_intel 0000:00:1b.0: setting latency timer to 64
[    9.413640] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input12
[    9.419190] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input13
[   10.817570] Adding 1196804k swap on /dev/sda5.  Priority:-1 extents:1 across:1196804k 
[   10.837662] EXT4-fs (sda1): re-mounted. Opts: (null)
[   11.419184] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro
[   11.714160] device-mapper: uevent: version 1.0.3
[   11.714430] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised: dm-devel@redhat.com
[   11.950678] fuse init (API version 7.17)
[   12.042226] loop: module loaded
[   13.958714] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: errors=remount-ro
[   14.081884] EXT4-fs (sda6): mounted filesystem with ordered data mode. Opts: errors=remount-ro
[   14.189315] EXT4-fs (sda7): mounted filesystem with ordered data mode. Opts: errors=remount-ro
[   15.617440] RPC: Registered named UNIX socket transport module.
[   15.617447] RPC: Registered udp transport module.
[   15.617451] RPC: Registered tcp transport module.
[   15.617455] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   15.680797] FS-Cache: Loaded
[   15.743494] FS-Cache: Netfs 'nfs' registered for caching
[   15.771586] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   19.415810] input: ACPI Virtual Keyboard Device as /devices/virtual/input/input14
[   22.391495] Bluetooth: Core ver 2.16
[   22.391521] NET: Registered protocol family 31
[   22.391523] Bluetooth: HCI device and connection manager initialized
[   22.391527] Bluetooth: HCI socket layer initialized
[   22.391529] Bluetooth: L2CAP socket layer initialized
[   22.391536] Bluetooth: SCO socket layer initialized
[   22.504198] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   22.504206] Bluetooth: BNEP filters: protocol multicast
[   22.536874] Bluetooth: RFCOMM TTY layer initialized
[   22.536881] Bluetooth: RFCOMM socket layer initialized
[   22.536884] Bluetooth: RFCOMM ver 1.11
[   25.268549] rtl8192cu: MAC auto ON okay!
[   25.301308] rtl8192cu: Tx queue select: 0x05
[   25.302079] rtl8192c_common: Loading firmware file rtlwifi/rtl8192cufw.bin
[   25.717662] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   25.722370] tg3 0000:05:00.0: irq 46 for MSI/MSI-X
[   25.890531] ADDRCONF(NETDEV_UP): eth0: link is not ready


===> # iwconfig wlan0

wlan0     IEEE 802.11bgn  ESSID:off/any  
          Mode:Managed  Access Point: Not-Associated   Tx-Power=20 dBm   
          Retry  long limit:7   RTS thr=2347 B   Fragment thr:off
          Encryption key:off
          Power Management:off
          

===> # uname -a

Linux localhost 3.2.0-4-amd64 #1 SMP Debian 3.2.32-1 x86_64 GNU/Linux


===> # lsusb

Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 006 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 007 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 001 Device 002: ID 7392:7822 Edimax Technology Co., Ltd 
Bus 002 Device 002: ID 5986:0102 Acer, Inc Crystal Eye Webcam
Bus 002 Device 003: ID 0951:1643 Kingston Technology DataTraveler G3 4GB


===> # lsusb -v


Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed (or root) hub
  bMaxPacketSize0        64
  idVendor           0x1d6b Linux Foundation
  idProduct          0x0002 2.0 root hub
  bcdDevice            3.02
  iManufacturer           3 Linux 3.2.0-4-amd64 ehci_hcd
  iProduct                2 EHCI Host Controller
  iSerial                 1 0000:00:1a.7
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0004  1x 4 bytes
        bInterval              12
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             4
  wHubCharacteristic 0x000a
    No power switching (usb 1.0)
    Per-port overcurrent protection
  bPwrOn2PwrGood       10 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0503 highspeed power enable connect
   Port 2: 0000.0100 power
   Port 3: 0000.0100 power
   Port 4: 0000.0100 power
Device Status:     0x0001
  Self Powered

Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed (or root) hub
  bMaxPacketSize0        64
  idVendor           0x1d6b Linux Foundation
  idProduct          0x0002 2.0 root hub
  bcdDevice            3.02
  iManufacturer           3 Linux 3.2.0-4-amd64 ehci_hcd
  iProduct                2 EHCI Host Controller
  iSerial                 1 0000:00:1d.7
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0004  1x 4 bytes
        bInterval              12
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             6
  wHubCharacteristic 0x000a
    No power switching (usb 1.0)
    Per-port overcurrent protection
  bPwrOn2PwrGood       10 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0100 power
   Port 2: 0000.0100 power
   Port 3: 0000.0100 power
   Port 4: 0000.0507 highspeed power suspend enable connect
   Port 5: 0000.0503 highspeed power enable connect
   Port 6: 0000.0100 power
Device Status:     0x0001
  Self Powered

Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed (or root) hub
  bMaxPacketSize0        64
  idVendor           0x1d6b Linux Foundation
  idProduct          0x0001 1.1 root hub
  bcdDevice            3.02
  iManufacturer           3 Linux 3.2.0-4-amd64 uhci_hcd
  iProduct                2 UHCI Host Controller
  iSerial                 1 0000:00:1a.0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0002  1x 2 bytes
        bInterval             255
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             2
  wHubCharacteristic 0x000a
    No power switching (usb 1.0)
    Per-port overcurrent protection
  bPwrOn2PwrGood        1 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0100 power
   Port 2: 0000.0100 power
Device Status:     0x0001
  Self Powered

Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed (or root) hub
  bMaxPacketSize0        64
  idVendor           0x1d6b Linux Foundation
  idProduct          0x0001 1.1 root hub
  bcdDevice            3.02
  iManufacturer           3 Linux 3.2.0-4-amd64 uhci_hcd
  iProduct                2 UHCI Host Controller
  iSerial                 1 0000:00:1a.1
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0002  1x 2 bytes
        bInterval             255
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             2
  wHubCharacteristic 0x000a
    No power switching (usb 1.0)
    Per-port overcurrent protection
  bPwrOn2PwrGood        1 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0100 power
   Port 2: 0000.0100 power
Device Status:     0x0001
  Self Powered

Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed (or root) hub
  bMaxPacketSize0        64
  idVendor           0x1d6b Linux Foundation
  idProduct          0x0001 1.1 root hub
  bcdDevice            3.02
  iManufacturer           3 Linux 3.2.0-4-amd64 uhci_hcd
  iProduct                2 UHCI Host Controller
  iSerial                 1 0000:00:1d.0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0002  1x 2 bytes
        bInterval             255
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             2
  wHubCharacteristic 0x000a
    No power switching (usb 1.0)
    Per-port overcurrent protection
  bPwrOn2PwrGood        1 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0100 power
   Port 2: 0000.0100 power
Device Status:     0x0001
  Self Powered

Bus 006 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed (or root) hub
  bMaxPacketSize0        64
  idVendor           0x1d6b Linux Foundation
  idProduct          0x0001 1.1 root hub
  bcdDevice            3.02
  iManufacturer           3 Linux 3.2.0-4-amd64 uhci_hcd
  iProduct                2 UHCI Host Controller
  iSerial                 1 0000:00:1d.1
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0002  1x 2 bytes
        bInterval             255
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             2
  wHubCharacteristic 0x000a
    No power switching (usb 1.0)
    Per-port overcurrent protection
  bPwrOn2PwrGood        1 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0100 power
   Port 2: 0000.0100 power
Device Status:     0x0001
  Self Powered

Bus 007 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed (or root) hub
  bMaxPacketSize0        64
  idVendor           0x1d6b Linux Foundation
  idProduct          0x0001 1.1 root hub
  bcdDevice            3.02
  iManufacturer           3 Linux 3.2.0-4-amd64 uhci_hcd
  iProduct                2 UHCI Host Controller
  iSerial                 1 0000:00:1d.2
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0002  1x 2 bytes
        bInterval             255
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             2
  wHubCharacteristic 0x000a
    No power switching (usb 1.0)
    Per-port overcurrent protection
  bPwrOn2PwrGood        1 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0100 power
   Port 2: 0000.0100 power
Device Status:     0x0001
  Self Powered

Bus 001 Device 002: ID 7392:7822 Edimax Technology Co., Ltd 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x7392 Edimax Technology Co., Ltd
  idProduct          0x7822 
  bcdDevice            2.00
  iManufacturer           1 Realtek
  iProduct                2 802.11n WLAN Adapter
  iSerial                 3 00e04c000001
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           46
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              500mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           4
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               1
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0000
  (Bus Powered)

Bus 002 Device 002: ID 5986:0102 Acer, Inc Crystal Eye Webcam
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass          239 Miscellaneous Device
  bDeviceSubClass         2 ?
  bDeviceProtocol         1 Interface Association
  bMaxPacketSize0        64
  idVendor           0x5986 Acer, Inc
  idProduct          0x0102 Crystal Eye Webcam
  bcdDevice            0.05
  iManufacturer           0 
  iProduct                1 Acer Crystal Eye webcam 
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength          632
    bNumInterfaces          2
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              500mA
    Interface Association:
      bLength                 8
      bDescriptorType        11
      bFirstInterface         0
      bInterfaceCount         2
      bFunctionClass         14 Video
      bFunctionSubClass       3 Video Interface Collection
      bFunctionProtocol       0 
      iFunction               1 Acer Crystal Eye webcam 
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      1 Video Control
      bInterfaceProtocol      0 
      iInterface              1 Acer Crystal Eye webcam 
      VideoControl Interface Descriptor:
        bLength                13
        bDescriptorType        36
        bDescriptorSubtype      1 (HEADER)
        bcdUVC               1.00
        wTotalLength           84
        dwClockFrequency       30.000000MHz
        bInCollection           1
        baInterfaceNr( 0)       1
      VideoControl Interface Descriptor:
        bLength                17
        bDescriptorType        36
        bDescriptorSubtype      2 (INPUT_TERMINAL)
        bTerminalID             1
        wTerminalType      0x0201 Camera Sensor
        bAssocTerminal          0
        iTerminal               0 
        wObjectiveFocalLengthMin      0
        wObjectiveFocalLengthMax      0
        wOcularFocalLength            0
        bControlSize                  2
        bmControls           0x00000000
      VideoControl Interface Descriptor:
        bLength                 9
        bDescriptorType        36
        bDescriptorSubtype      3 (OUTPUT_TERMINAL)
        bTerminalID             3
        wTerminalType      0x0101 USB Streaming
        bAssocTerminal          0
        bSourceID               6
        iTerminal               0 
      VideoControl Interface Descriptor:
        bLength                 7
        bDescriptorType        36
        bDescriptorSubtype      4 (SELECTOR_UNIT)
        bUnitID                 4
        bNrInPins               1
        baSource( 0)            1
        iSelector               0 
      VideoControl Interface Descriptor:
        bLength                11
        bDescriptorType        36
        bDescriptorSubtype      5 (PROCESSING_UNIT)
      Warning: Descriptor too short
        bUnitID                 5
        bSourceID               4
        wMaxMultiplier          0
        bControlSize            2
        bmControls     0x0000053f
          Brightness
          Contrast
          Hue
          Saturation
          Sharpness
          Gamma
          Backlight Compensation
          Power Line Frequency
        iProcessing             0 
        bmVideoStandards     0x1b
          None
          NTSC - 525/60
          SECAM - 625/50
          NTSC - 625/50
      VideoControl Interface Descriptor:
        bLength                27
        bDescriptorType        36
        bDescriptorSubtype      6 (EXTENSION_UNIT)
        bUnitID                 6
        guidExtensionCode         {564c97a7-7ea7-904b-8cbf-1c71ec303000}
        bNumControl            16
        bNrPins                 1
        baSourceID( 0)          5
        bControlSize            2
        bmControls( 0)       0xff
        bmControls( 1)       0xff
        iExtension              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0008  1x 8 bytes
        bInterval              15
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0 
      iInterface              0 
      VideoStreaming Interface Descriptor:
        bLength                            15
        bDescriptorType                    36
        bDescriptorSubtype                  1 (INPUT_HEADER)
        bNumFormats                         2
        wTotalLength                      485
        bEndPointAddress                  129
        bmInfo                              0
        bTerminalLink                       3
        bStillCaptureMethod                 2
        bTriggerSupport                     1
        bTriggerUsage                       1
        bControlSize                        1
        bmaControls( 0)                    11
        bmaControls( 1)                    11
      VideoStreaming Interface Descriptor:
        bLength                            11
        bDescriptorType                    36
        bDescriptorSubtype                  6 (FORMAT_MJPEG)
        bFormatIndex                        1
        bNumFrameDescriptors                5
        bFlags                              1
          Fixed-size samples: Yes
        bDefaultFrameIndex                  1
        bAspectRatioX                       0
        bAspectRatioY                       0
        bmInterlaceFlags                 0x00
          Interlaced stream or variable: No
          Fields per frame: 1 fields
          Field 1 first: No
          Field pattern: Field 1 only
          bCopyProtect                      0
      VideoStreaming Interface Descriptor:
        bLength                            38
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                         1
        bmCapabilities                   0x01
          Still image supported
        wWidth                            640
        wHeight                           480
        dwMinBitRate                   912384
        dwMaxBitRate                   912384
        dwMaxVideoFrameBufferSize      921600
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  3
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            666666
        dwFrameInterval( 2)           1000000
      VideoStreaming Interface Descriptor:
        bLength                            38
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                         2
        bmCapabilities                   0x01
          Still image supported
        wWidth                            320
        wHeight                           240
        dwMinBitRate                   912384
        dwMaxBitRate                   912384
        dwMaxVideoFrameBufferSize      230400
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  3
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            666666
        dwFrameInterval( 2)           1000000
      VideoStreaming Interface Descriptor:
        bLength                            38
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                         3
        bmCapabilities                   0x01
          Still image supported
        wWidth                            160
        wHeight                           120
        dwMinBitRate                   912384
        dwMaxBitRate                   912384
        dwMaxVideoFrameBufferSize       57600
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  3
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            666666
        dwFrameInterval( 2)           1000000
      VideoStreaming Interface Descriptor:
        bLength                            38
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                         4
        bmCapabilities                   0x01
          Still image supported
        wWidth                            352
        wHeight                           288
        dwMinBitRate                   912384
        dwMaxBitRate                   912384
        dwMaxVideoFrameBufferSize      304128
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  3
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            666666
        dwFrameInterval( 2)           1000000
      VideoStreaming Interface Descriptor:
        bLength                            38
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                         5
        bmCapabilities                   0x01
          Still image supported
        wWidth                            176
        wHeight                           144
        dwMinBitRate                   912384
        dwMaxBitRate                   912384
        dwMaxVideoFrameBufferSize       76032
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  3
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            666666
        dwFrameInterval( 2)           1000000
      VideoStreaming Interface Descriptor:
        bLength                            26
        bDescriptorType                    36
        bDescriptorSubtype                  3 (STILL_IMAGE_FRAME)
        bEndpointAddress                    0
        bNumImageSizePatterns               5
        wWidth( 0)                        640
        wHeight( 0)                       480
        wWidth( 1)                        320
        wHeight( 1)                       240
        wWidth( 2)                        160
        wHeight( 2)                       120
        wWidth( 3)                        352
        wHeight( 3)                       288
        wWidth( 4)                        176
        wHeight( 4)                       144
        bNumCompressionPatterns             5
      VideoStreaming Interface Descriptor:
        bLength                            27
        bDescriptorType                    36
        bDescriptorSubtype                  4 (FORMAT_UNCOMPRESSED)
        bFormatIndex                        2
        bNumFrameDescriptors                5
        guidFormat                            {59555932-0000-1000-8000-00aa00389b71}
        bBitsPerPixel                      16
        bDefaultFrameIndex                  1
        bAspectRatioX                       0
        bAspectRatioY                       0
        bmInterlaceFlags                 0x00
          Interlaced stream or variable: No
          Fields per frame: 2 fields
          Field 1 first: No
          Field pattern: Field 1 only
          bCopyProtect                      0
      VideoStreaming Interface Descriptor:
        bLength                            38
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         1
        bmCapabilities                   0x01
          Still image supported
        wWidth                            640
        wHeight                           480
        dwMinBitRate                   912384
        dwMaxBitRate                   912384
        dwMaxVideoFrameBufferSize      614400
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  3
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            666666
        dwFrameInterval( 2)           1000000
      VideoStreaming Interface Descriptor:
        bLength                            38
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         2
        bmCapabilities                   0x01
          Still image supported
        wWidth                            320
        wHeight                           240
        dwMinBitRate                   912384
        dwMaxBitRate                   912384
        dwMaxVideoFrameBufferSize      230400
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  3
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            666666
        dwFrameInterval( 2)           1000000
      VideoStreaming Interface Descriptor:
        bLength                            38
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         3
        bmCapabilities                   0x01
          Still image supported
        wWidth                            160
        wHeight                           120
        dwMinBitRate                   912384
        dwMaxBitRate                   912384
        dwMaxVideoFrameBufferSize       57600
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  3
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            666666
        dwFrameInterval( 2)           1000000
      VideoStreaming Interface Descriptor:
        bLength                            38
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         4
        bmCapabilities                   0x01
          Still image supported
        wWidth                            352
        wHeight                           288
        dwMinBitRate                   912384
        dwMaxBitRate                   912384
        dwMaxVideoFrameBufferSize      304128
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  3
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            666666
        dwFrameInterval( 2)           1000000
      VideoStreaming Interface Descriptor:
        bLength                            38
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         5
        bmCapabilities                   0x01
          Still image supported
        wWidth                            176
        wHeight                           144
        dwMinBitRate                   912384
        dwMaxBitRate                   912384
        dwMaxVideoFrameBufferSize       76032
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  3
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            666666
        dwFrameInterval( 2)           1000000
      VideoStreaming Interface Descriptor:
        bLength                            26
        bDescriptorType                    36
        bDescriptorSubtype                  3 (STILL_IMAGE_FRAME)
        bEndpointAddress                    0
        bNumImageSizePatterns               5
        wWidth( 0)                        640
        wHeight( 0)                       480
        wWidth( 1)                        320
        wHeight( 1)                       240
        wWidth( 2)                        160
        wHeight( 2)                       120
        wWidth( 3)                        352
        wHeight( 3)                       288
        wWidth( 4)                        176
        wHeight( 4)                       144
        bNumCompressionPatterns             5
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       1
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x1400  3x 1024 bytes
        bInterval               1
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0000
  (Bus Powered)

Bus 002 Device 003: ID 0951:1643 Kingston Technology DataTraveler G3 4GB
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x0951 Kingston Technology
  idProduct          0x1643 DataTraveler G3 4GB
  bcdDevice            1.00
  iManufacturer           1 Kingston
  iProduct                2 DataTraveler G3
  iSerial                 3 F46D04613D14BCA1D931010E
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           32
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              200mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass         8 Mass Storage
      bInterfaceSubClass      6 SCSI
      bInterfaceProtocol     80 Bulk-Only
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0000
  (Bus Powered)


===> That's all.

----- Mail original -----
De: "Larry Finger" <Larry.Finger@lwfinger.net>
À: "sebastien major" <sebastien.major@free.fr>
Cc: linux-wireless@vger.kernel.org
Envoyé: Lundi 19 Novembre 2012 01:12:29
Objet: Re: Edimax EW-7612Aun does not work.

On 11/18/2012 05:54 PM, sebastien.major@free.fr wrote:
>
> Hello,
>
> All is said in title : my edimax refuse to start correctly.
>
> kernel choose to load rtl8192cu and appropriate firmware but nothing : I see a reply in dmesg which says "wlan10 : link not ready".
>
> tested on Acer laptop Core 2 duo with linux 3.6.7 freshly compiled by kpkg-buildpackage (Debian unstable).
>
> Edimax driver are old and for i386 (32 bits).
>
>
> Any doc is welcome : thanks by advance.

That problem is not likely due to rtl8192cu, but is related to some other issue. 
What does 'rfkill list' show?

What distro do you use?

Larry


