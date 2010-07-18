Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:60421 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756197Ab0GRPBA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Jul 2010 11:01:00 -0400
Date: Sun, 18 Jul 2010 11:00:50 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, mcgrof@gmail.com,
	kyle@parisc-linux.org
Subject: Re: [RFC] wireless: only use alpha2 regulatory information from
 country IE
Message-ID: <20100718150050.GM10884@bombadil.infradead.org>
References: <1279220807-18245-1-git-send-email-linville@tuxdriver.com>
 <20100716004658.GG10884@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="EVF5PPMfhYS0aIcm"
In-Reply-To: <20100716004658.GG10884@bombadil.infradead.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 15, 2010 at 08:46:58PM -0400, Kyle McMartin wrote:
> 
> Building it now...
> 

Works great... dmesg attached.

kyle@dreadnought ~ $ iw reg get
country CA:
	(2402 - 2472 @ 40), (3, 27)
	(5170 - 5250 @ 40), (3, 17)
	(5250 - 5330 @ 40), (3, 20), DFS
	(5490 - 5710 @ 40), (3, 20), DFS
	(5735 - 5835 @ 40), (3, 30)


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.dreadnought"

Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.35-0.40.rc5.git1.fc14.x86_64 (kyle@dreadnought.i.jkkm.org) (gcc version 4.4.4 20100630 (Red Hat 4.4.4-10) (GCC) ) #1 SMP Thu Jul 15 23:29:26 EDT 2010
Command line: ro root=/dev/mapper/vg_dreadnought-lv_root rd_LVM_LV=vg_dreadnought/lv_root rd_NO_LUKS rd_NO_MD rd_NO_DM LANG=en_US.UTF-8 SYSFONT=latarcyrheb-sun16 KEYBOARDTYPE=pc KEYTABLE=us noiswmd rhgb quiet selinux=0 audit=0
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009e800 (usable)
 BIOS-e820: 000000000009e800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000d2000 - 00000000000d4000 (reserved)
 BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000bb27c000 (usable)
 BIOS-e820: 00000000bb27c000 - 00000000bb282000 (reserved)
 BIOS-e820: 00000000bb282000 - 00000000bb363000 (usable)
 BIOS-e820: 00000000bb363000 - 00000000bb375000 (reserved)
 BIOS-e820: 00000000bb375000 - 00000000bb3f6000 (ACPI NVS)
 BIOS-e820: 00000000bb3f6000 - 00000000bb40f000 (reserved)
 BIOS-e820: 00000000bb40f000 - 00000000bb470000 (usable)
 BIOS-e820: 00000000bb470000 - 00000000bb668000 (reserved)
 BIOS-e820: 00000000bb668000 - 00000000bb6e8000 (ACPI NVS)
 BIOS-e820: 00000000bb6e8000 - 00000000bb70f000 (reserved)
 BIOS-e820: 00000000bb70f000 - 00000000bb717000 (usable)
 BIOS-e820: 00000000bb717000 - 00000000bb71f000 (reserved)
 BIOS-e820: 00000000bb71f000 - 00000000bb76b000 (usable)
 BIOS-e820: 00000000bb76b000 - 00000000bb777000 (ACPI NVS)
 BIOS-e820: 00000000bb777000 - 00000000bb77a000 (ACPI data)
 BIOS-e820: 00000000bb77a000 - 00000000bb781000 (ACPI NVS)
 BIOS-e820: 00000000bb781000 - 00000000bb782000 (ACPI data)
 BIOS-e820: 00000000bb782000 - 00000000bb78b000 (ACPI NVS)
 BIOS-e820: 00000000bb78b000 - 00000000bb78c000 (ACPI data)
 BIOS-e820: 00000000bb78c000 - 00000000bb79f000 (ACPI NVS)
 BIOS-e820: 00000000bb79f000 - 00000000bb7ff000 (ACPI data)
 BIOS-e820: 00000000bb7ff000 - 00000000bb800000 (usable)
 BIOS-e820: 00000000bb800000 - 00000000c0000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000feaff000 - 00000000feb00000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
 BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000138000000 (usable)
NX (Execute Disable) protection: active
DMI present.
e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
No AGP bridge found
last_pfn = 0x138000 max_arch_pfn = 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-D3FFF write-protect
  D4000-DBFFF uncachable
  DC000-FFFFF write-protect
MTRR variable ranges enabled:
  0 disabled
  1 base 000000000 mask F80000000 write-back
  2 base 080000000 mask FC0000000 write-back
  3 base 100000000 mask FC0000000 write-back
  4 base 138000000 mask FF8000000 uncachable
  5 base 0BC000000 mask FFC000000 uncachable
  6 disabled
  7 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
original variable MTRRs
reg 1, base: 0GB, range: 2GB, type WB
reg 2, base: 2GB, range: 1GB, type WB
reg 3, base: 4GB, range: 1GB, type WB
reg 4, base: 4992MB, range: 128MB, type UC
reg 5, base: 3008MB, range: 64MB, type UC
total RAM covered: 3904M
Found optimal setting for mtrr clean up
 gran_size: 64K 	chunk_size: 256M 	num_reg: 5  	lose cover RAM: 0G
New variable MTRRs
reg 0, base: 0GB, range: 2GB, type WB
reg 1, base: 2GB, range: 1GB, type WB
reg 2, base: 3008MB, range: 64MB, type UC
reg 3, base: 4GB, range: 1GB, type WB
reg 4, base: 4992MB, range: 128MB, type UC
e820 update range: 00000000bc000000 - 0000000100000000 (usable) ==> (reserved)
last_pfn = 0xbb800 max_arch_pfn = 0x400000000
initial memory mapped : 0 - 20000000
found SMP MP-table at [ffff8800000f6920] f6920
init_memory_mapping: 0000000000000000-00000000bb800000
 0000000000 - 00bb800000 page 2M
kernel direct mapping tables up to bb800000 @ 8000-c000
init_memory_mapping: 0000000100000000-0000000138000000
 0100000000 - 0138000000 page 2M
kernel direct mapping tables up to 138000000 @ a000-10000
RAMDISK: 373fb000 - 37ff0000
ACPI: RSDP 00000000000f68f0 00024 (v02 LENOVO)
ACPI: XSDT 00000000bb7f0a79 00094 (v01 LENOVO TP-6Q    00001050  LTP 00000000)
ACPI: FACP 00000000bb7f0c00 000F4 (v04 LENOVO TP-6Q    00001050 LNVO 00000001)
ACPI: DSDT 00000000bb7f0f6b 0DD9B (v01 LENOVO TP-6Q    00001050 MSFT 03000001)
ACPI: FACS 00000000bb6e7000 00040
ACPI: SSDT 00000000bb7f0db4 001B7 (v01 LENOVO TP-6Q    00001050 MSFT 03000001)
ACPI: ECDT 00000000bb7fed06 00052 (v01 LENOVO TP-6Q    00001050 LNVO 00000001)
ACPI: APIC 00000000bb7fed58 00084 (v01 LENOVO TP-6Q    00001050 LNVO 00000001)
ACPI: MCFG 00000000bb7fee14 0003C (v01 LENOVO TP-6Q    00001050 LNVO 00000001)
ACPI: HPET 00000000bb7fee50 00038 (v01 LENOVO TP-6Q    00001050 LNVO 00000001)
ACPI: ASF! 00000000bb7fef34 000A4 (v16 LENOVO TP-6Q    00001050 PTL  00000001)
ACPI: BOOT 00000000bb7fefd8 00028 (v01 LENOVO TP-6Q    00001050  LTP 00000001)
ACPI: SSDT 00000000bb6e590a 0085B (v01 LENOVO TP-6Q    00001050 INTL 20050513)
ACPI: TCPA 00000000bb78b000 00032 (v02    PTL  CRESTLN 06040000      00005A52)
ACPI: DMAR 00000000bb781000 000B8 (v01 INTEL  CP_DALE  00000001 INTL 00000001)
ACPI: SSDT 00000000bb779000 009F1 (v01  PmRef    CpuPm 00003000 INTL 20050513)
ACPI: SSDT 00000000bb778000 00259 (v01  PmRef  Cpu0Tst 00003000 INTL 20050513)
ACPI: SSDT 00000000bb777000 0049F (v01  PmRef    ApTst 00003000 INTL 20050513)
ACPI: Local APIC address 0xfee00000
No NUMA configuration found
Faking a node at 0000000000000000-0000000138000000
Initmem setup node 0 0000000000000000-0000000138000000
  NODE_DATA [0000000100000000 - 0000000100013fff]
  bootmap [0000000100014000 -  000000010003afff] pages 27
(14/32 early reservations) ==> bootmem [0000000000 - 0138000000]
  #0 [0001000000 - 0001e456e8]    TEXT DATA BSS ==> [0001000000 - 0001e456e8]
  #1 [00373fb000 - 0037ff0000]          RAMDISK ==> [00373fb000 - 0037ff0000]
  #2 [0001e46000 - 0001e46144]              BRK ==> [0001e46000 - 0001e46144]
  #3 [00000f6930 - 0000100000]    BIOS reserved ==> [00000f6930 - 0000100000]
  #4 [00000f6920 - 00000f6930]     MP-table mpf ==> [00000f6920 - 00000f6930]
  #5 [000009e800 - 000009ef71]    BIOS reserved ==> [000009e800 - 000009ef71]
  #6 [000009f075 - 00000f6920]    BIOS reserved ==> [000009f075 - 00000f6920]
  #7 [000009ef71 - 000009f075]     MP-table mpc ==> [000009ef71 - 000009f075]
  #8 [0000001000 - 0000003000]       TRAMPOLINE ==> [0000001000 - 0000003000]
  #9 [0000003000 - 0000007000]      ACPI WAKEUP ==> [0000003000 - 0000007000]
  #10 [0000008000 - 000000a000]          PGTABLE ==> [0000008000 - 000000a000]
  #11 [000000a000 - 000000b000]          PGTABLE ==> [000000a000 - 000000b000]
  #12 [0100000000 - 0100014000]        NODE_DATA ==> [0100000000 - 0100014000]
  #13 [0100014000 - 010003b000]          BOOTMAP ==> [0100014000 - 010003b000]
 [ffffea0000000000-ffffea00045fffff] PMD -> [ffff880100600000-ffff880103dfffff] on node 0
Zone PFN ranges:
  DMA      0x00000001 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00138000
Movable zone start PFN for each node
early_node_map[8] active PFN ranges
    0: 0x00000001 -> 0x0000009e
    0: 0x00000100 -> 0x000bb27c
    0: 0x000bb282 -> 0x000bb363
    0: 0x000bb40f -> 0x000bb470
    0: 0x000bb70f -> 0x000bb717
    0: 0x000bb71f -> 0x000bb76b
    0: 0x000bb7ff -> 0x000bb800
    0: 0x00100000 -> 0x00138000
On node 0 totalpages: 996272
  DMA zone: 56 pages used for memmap
  DMA zone: 105 pages reserved
  DMA zone: 3836 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 748619 pages, LIFO batch:31
  Normal zone: 3136 pages used for memmap
  Normal zone: 226240 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x04] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x05] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a701 base: 0xfed00000
SMP: Allowing 4 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 40
PM: Registered nosave memory: 000000000009e000 - 000000000009f000
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000d2000
PM: Registered nosave memory: 00000000000d2000 - 00000000000d4000
PM: Registered nosave memory: 00000000000d4000 - 00000000000dc000
PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
PM: Registered nosave memory: 00000000bb27c000 - 00000000bb282000
PM: Registered nosave memory: 00000000bb363000 - 00000000bb375000
PM: Registered nosave memory: 00000000bb375000 - 00000000bb3f6000
PM: Registered nosave memory: 00000000bb3f6000 - 00000000bb40f000
PM: Registered nosave memory: 00000000bb470000 - 00000000bb668000
PM: Registered nosave memory: 00000000bb668000 - 00000000bb6e8000
PM: Registered nosave memory: 00000000bb6e8000 - 00000000bb70f000
PM: Registered nosave memory: 00000000bb717000 - 00000000bb71f000
PM: Registered nosave memory: 00000000bb76b000 - 00000000bb777000
PM: Registered nosave memory: 00000000bb777000 - 00000000bb77a000
PM: Registered nosave memory: 00000000bb77a000 - 00000000bb781000
PM: Registered nosave memory: 00000000bb781000 - 00000000bb782000
PM: Registered nosave memory: 00000000bb782000 - 00000000bb78b000
PM: Registered nosave memory: 00000000bb78b000 - 00000000bb78c000
PM: Registered nosave memory: 00000000bb78c000 - 00000000bb79f000
PM: Registered nosave memory: 00000000bb79f000 - 00000000bb7ff000
PM: Registered nosave memory: 00000000bb800000 - 00000000c0000000
PM: Registered nosave memory: 00000000c0000000 - 00000000e0000000
PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
PM: Registered nosave memory: 00000000f0000000 - 00000000feaff000
PM: Registered nosave memory: 00000000feaff000 - 00000000feb00000
PM: Registered nosave memory: 00000000feb00000 - 00000000fec00000
PM: Registered nosave memory: 00000000fec00000 - 00000000fec10000
PM: Registered nosave memory: 00000000fec10000 - 00000000fed00000
PM: Registered nosave memory: 00000000fed00000 - 00000000fed1c000
PM: Registered nosave memory: 00000000fed1c000 - 00000000fed90000
PM: Registered nosave memory: 00000000fed90000 - 00000000fee00000
PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
PM: Registered nosave memory: 00000000fee01000 - 00000000ff000000
PM: Registered nosave memory: 00000000ff000000 - 0000000100000000
Allocating PCI resources starting at c0000000 (gap: c0000000:20000000)
Booting paravirtualized kernel on bare hardware
setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:4 nr_node_ids:1
PERCPU: Embedded 30 pages/cpu @ffff880002000000 s90304 r8192 d24384 u524288
pcpu-alloc: s90304 r8192 d24384 u524288 alloc=1*2097152
pcpu-alloc: [0] 0 1 2 3 
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 978695
Policy zone: Normal
Kernel command line: ro root=/dev/mapper/vg_dreadnought-lv_root rd_LVM_LV=vg_dreadnought/lv_root rd_NO_LUKS rd_NO_MD rd_NO_DM LANG=en_US.UTF-8 SYSFONT=latarcyrheb-sun16 KEYBOARDTYPE=pc KEYTABLE=us noiswmd rhgb quiet selinux=0 audit=0
audit: disabled (until reboot)
PID hash table entries: 4096 (order: 3, 32768 bytes)
Checking aperture...
No AGP bridge found
Calgary: detecting Calgary via BIOS EBDA area
Calgary: Unable to locate Rio Grande table in EBDA - bailing!
Memory: 3833968k/5111808k available (4519k kernel code, 1126720k absent, 151120k reserved, 7287k data, 952k init)
SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
Hierarchical RCU implementation.
	RCU dyntick-idle grace-period acceleration is enabled.
	RCU-based detection of stalled CPUs is disabled.
	Verbose stalled-CPUs detection is disabled.
NR_IRQS:16640 nr_irqs:712
Extended CMOS year: 2000
Console: colour VGA+ 80x25
console [tty0] enabled
allocated 40632320 bytes of page_cgroup
please try 'cgroup_disable=memory' option if you don't want memory cgroups
hpet clockevent registered
Fast TSC calibration using PIT
Detected 1994.936 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 3989.87 BogoMIPS (lpj=1994936)
pid_max: default: 32768 minimum: 301
Security Framework initialized
SELinux:  Disabled at boot.
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
Initializing cgroup subsys net_cls
Initializing cgroup subsys blkio
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 9 MCE banks
CPU0: Thermal monitoring enabled (TM1)
using mwait in idle threads.
Performance Events: PEBS fmt1+, Westmere events, Intel PMU driver.
... version:                3
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             000000070000000f
ACPI: Core revision 20100428
ftrace: converting mcount calls to 0f 1f 44 00 00
ftrace: allocating 20914 entries in 83 pages
DMAR: Host address width 36
DMAR: DRHD base: 0x000000fed90000 flags: 0x0
IOMMU 0: reg_base_addr fed90000 ver 1:0 cap c9008020e30272 ecap 1000
DMAR: DRHD base: 0x000000fed91000 flags: 0x0
IOMMU 1: reg_base_addr fed91000 ver 1:0 cap c0000020230272 ecap 1000
DMAR: DRHD base: 0x000000fed93000 flags: 0x1
IOMMU 2: reg_base_addr fed93000 ver 1:0 cap c9008020630272 ecap 1000
DMAR: RMRR base: 0x000000bb6e9000 end: 0x000000bb6fefff
DMAR: RMRR base: 0x000000bde00000 end: 0x000000bfffffff
DMAR: No ATSR found
Setting APIC routing to flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Core(TM) i7 CPU       L 620  @ 2.00GHz stepping 02
Booting Node   0, Processors  #1 #2 #3 Ok.
Brought up 4 CPUs
Total of 4 processors activated (15959.23 BogoMIPS).
sizeof(vma)=176 bytes
sizeof(page)=56 bytes
sizeof(inode)=584 bytes
sizeof(dentry)=192 bytes
sizeof(ext3inode)=800 bytes
sizeof(buffer_head)=104 bytes
sizeof(skbuff)=240 bytes
sizeof(task_struct)=5952 bytes
devtmpfs: initialized
atomic64 test passed for x86-64 platform with CX8 and with SSE
Time: 18:47:45  Date: 07/16/10
NET: Registered protocol family 16
ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
ACPI: bus type pci registered
PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: EC description table is found, configuring boot EC
ACPI: BIOS _OSI(Linux) query ignored
ACPI: SSDT 00000000bb71ac18 003A9 (v01  PmRef  Cpu0Ist 00003000 INTL 20050513)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT (null) 003A9 (v01  PmRef  Cpu0Ist 00003000 INTL 20050513)
ACPI: SSDT 00000000bb718718 006B2 (v01  PmRef  Cpu0Cst 00003001 INTL 20050513)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT (null) 006B2 (v01  PmRef  Cpu0Cst 00003001 INTL 20050513)
ACPI: SSDT 00000000bb719a98 00303 (v01  PmRef    ApIst 00003000 INTL 20050513)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20050513)
ACPI: SSDT 00000000bb717d98 00119 (v01  PmRef    ApCst 00003000 INTL 20050513)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20050513)
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
ACPI: Power Resource [PUBS] (on)
ACPI: ACPI Dock Station Driver: 3 docks/bays found
PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
ACPI: PCI Root Bridge [UNCR] (domain 0000 [bus ff])
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000d7fff]
pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000dbfff]
pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xfebfffff]
pci 0000:00:02.0: reg 10: [mem 0xf2000000-0xf23fffff 64bit]
pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff 64bit pref]
pci 0000:00:02.0: reg 20: [io  0x1800-0x1807]
pci 0000:00:16.0: reg 10: [mem 0xf2727800-0xf272780f 64bit]
pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
pci 0000:00:16.0: PME# disabled
pci 0000:00:19.0: reg 10: [mem 0xf2500000-0xf251ffff]
pci 0000:00:19.0: reg 14: [mem 0xf2525000-0xf2525fff]
pci 0000:00:19.0: reg 18: [io  0x1820-0x183f]
pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
pci 0000:00:19.0: PME# disabled
pci 0000:00:1a.0: reg 10: [mem 0xf2728000-0xf27283ff]
pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1a.0: PME# disabled
pci 0000:00:1b.0: reg 10: [mem 0xf2520000-0xf2523fff 64bit]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.3: PME# disabled
pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.4: PME# disabled
pci 0000:00:1d.0: reg 10: [mem 0xf2728400-0xf27287ff]
pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.0: PME# disabled
pci 0000:00:1f.2: reg 10: [io  0x1860-0x1867]
pci 0000:00:1f.2: reg 14: [io  0x1814-0x1817]
pci 0000:00:1f.2: reg 18: [io  0x1818-0x181f]
pci 0000:00:1f.2: reg 1c: [io  0x1810-0x1813]
pci 0000:00:1f.2: reg 20: [io  0x1840-0x185f]
pci 0000:00:1f.2: reg 24: [mem 0xf2727000-0xf27277ff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:00:1f.3: reg 10: [mem 0xf2728800-0xf27288ff 64bit]
pci 0000:00:1f.3: reg 20: [io  0x1880-0x189f]
pci 0000:00:1f.6: reg 10: [mem 0xf2526000-0xf2526fff 64bit]
pci 0000:00:1c.0: PCI bridge to [bus 0d-0d]
pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
pci 0000:00:1c.3:   bridge window [mem 0xf2800000-0xf28fffff 64bit pref]
pci 0000:02:00.0: reg 10: [mem 0xf2400000-0xf2401fff 64bit]
pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
pci 0000:02:00.0: PME# disabled
pci 0000:00:1c.4: PCI bridge to [bus 02-02]
pci 0000:00:1c.4:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:1c.4:   bridge window [mem 0xf2400000-0xf24fffff]
pci 0000:00:1c.4:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:00:1e.0: PCI bridge to [bus 0e-0e] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xfebfffff] (subtractive decode)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP5._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
HEST: Table is not found!
vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
reserve RAM buffer: 000000000009e800 - 000000000009ffff 
reserve RAM buffer: 00000000bb27c000 - 00000000bbffffff 
reserve RAM buffer: 00000000bb363000 - 00000000bbffffff 
reserve RAM buffer: 00000000bb470000 - 00000000bbffffff 
reserve RAM buffer: 00000000bb717000 - 00000000bbffffff 
reserve RAM buffer: 00000000bb76b000 - 00000000bbffffff 
reserve RAM buffer: 00000000bb800000 - 00000000bbffffff 
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
hpet0: 8 comparators, 64-bit 14.318180 MHz counter
Switching to clocksource tsc
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
system 00:00: [mem 0x000c0000-0x000c3fff] has been reserved
system 00:00: [mem 0x000c4000-0x000c7fff] has been reserved
system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
system 00:00: [mem 0x000d0000-0x000d3fff] could not be reserved
system 00:00: [mem 0x000dc000-0x000dffff] could not be reserved
system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
system 00:00: [mem 0x00100000-0xbfffffff] could not be reserved
system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
system 00:00: [mem 0xfed4c000-0xffffffff] could not be reserved
system 00:03: [io  0x164e-0x164f] has been reserved
system 00:03: [io  0x1000-0x107f] has been reserved
system 00:03: [io  0x1180-0x11ff] has been reserved
system 00:03: [io  0x0800-0x080f] has been reserved
system 00:03: [io  0x15e0-0x15ef] has been reserved
system 00:03: [io  0x1600-0x1641] has been reserved
system 00:03: [io  0x1644-0x167f] could not be reserved
system 00:03: [mem 0xe0000000-0xefffffff] has been reserved
system 00:03: [mem 0xfed1c000-0xfed1ffff] has been reserved
system 00:03: [mem 0xfed10000-0xfed13fff] has been reserved
system 00:03: [mem 0xfed18000-0xfed18fff] has been reserved
system 00:03: [mem 0xfed19000-0xfed19fff] has been reserved
system 00:03: [mem 0xfed45000-0xfed4bfff] has been reserved
system 00:0c: [mem 0xfeaff000-0xfeafffff] has been reserved
pci 0000:00:1c.0: PCI bridge to [bus 0d-0d]
pci 0000:00:1c.0:   bridge window [io  disabled]
pci 0000:00:1c.0:   bridge window [mem disabled]
pci 0000:00:1c.0:   bridge window [mem pref disabled]
pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
pci 0000:00:1c.3:   bridge window [mem 0xf2800000-0xf28fffff 64bit pref]
pci 0000:00:1c.4: PCI bridge to [bus 02-02]
pci 0000:00:1c.4:   bridge window [io  disabled]
pci 0000:00:1c.4:   bridge window [mem 0xf2400000-0xf24fffff]
pci 0000:00:1c.4:   bridge window [mem pref disabled]
pci 0000:00:1e.0: PCI bridge to [bus 0e-0e]
pci 0000:00:1e.0:   bridge window [io  disabled]
pci 0000:00:1e.0:   bridge window [mem disabled]
pci 0000:00:1e.0:   bridge window [mem pref disabled]
  alloc irq_desc for 20 on node -1
  alloc kstat_irqs on node -1
pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
pci 0000:00:1c.0: setting latency timer to 64
  alloc irq_desc for 23 on node -1
  alloc kstat_irqs on node -1
pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
pci 0000:00:1c.3: setting latency timer to 64
pci 0000:00:1c.4: PCI INT A -> GSI 20 (level, low) -> IRQ 20
pci 0000:00:1c.4: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: resource 7 [mem 0x000d4000-0x000d7fff]
pci_bus 0000:00: resource 8 [mem 0x000d8000-0x000dbfff]
pci_bus 0000:00: resource 9 [mem 0xc0000000-0xfebfffff]
pci_bus 0000:05: resource 0 [io  0x2000-0x2fff]
pci_bus 0000:05: resource 1 [mem 0xf0000000-0xf1ffffff]
pci_bus 0000:05: resource 2 [mem 0xf2800000-0xf28fffff 64bit pref]
pci_bus 0000:02: resource 1 [mem 0xf2400000-0xf24fffff]
pci_bus 0000:0e: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:0e: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:0e: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:0e: resource 7 [mem 0x000d4000-0x000d7fff]
pci_bus 0000:0e: resource 8 [mem 0x000d8000-0x000dbfff]
pci_bus 0000:0e: resource 9 [mem 0xc0000000-0xfebfffff]
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
UDP hash table entries: 2048 (order: 4, 65536 bytes)
UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
NET: Registered protocol family 1
pci 0000:00:02.0: Boot video device
PCI: CLS 64 bytes, default 64
Trying to unpack rootfs image as initramfs...
Freeing initrd memory: 12244k freed
IOMMU 0 0xfed90000: using Register based invalidation
IOMMU 2 0xfed93000: using Register based invalidation
IOMMU: Setting RMRR:
IOMMU: Setting identity map for device 0000:00:1d.0 [0xbb6e9000 - 0xbb6ff000]
IOMMU: Setting identity map for device 0000:00:1a.0 [0xbb6e9000 - 0xbb6ff000]
IOMMU: Prepare 0-16MiB unity mapping for LPC
IOMMU: Setting identity map for device 0000:00:1f.0 [0x0 - 0x1000000]
  alloc irq_desc for 40 on node 0
  alloc kstat_irqs on node 0
  alloc irq_desc for 41 on node 0
  alloc kstat_irqs on node 0
PCI-DMA: Intel(R) Virtualization Technology for Directed I/O
Simple Boot Flag at 0x35 set to 0x80
HugeTLB registered 2 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
msgmni has been set to 7640
alg: No test for stdrng (krng)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
pcieport 0000:00:1c.0: setting latency timer to 64
  alloc irq_desc for 42 on node -1
  alloc kstat_irqs on node -1
pcieport 0000:00:1c.0: irq 42 for MSI/MSI-X
pcieport 0000:00:1c.3: setting latency timer to 64
  alloc irq_desc for 43 on node -1
  alloc kstat_irqs on node -1
pcieport 0000:00:1c.3: irq 43 for MSI/MSI-X
pcieport 0000:00:1c.4: setting latency timer to 64
  alloc irq_desc for 44 on node -1
  alloc kstat_irqs on node -1
pcieport 0000:00:1c.4: irq 44 for MSI/MSI-X
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
Firmware did not grant requested _OSC control
Firmware did not grant requested _OSC control
pciehp: PCI Express Hot Plug Controller Driver version: 0.4
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
acpiphp: Slot [1] registered
pci-stub: invalid id string ""
ACPI: AC Adapter [AC] (on-line)
input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
ACPI: Lid Switch [LID]
input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input1
ACPI: Sleep Button [SLPB]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
ACPI: Power Button [PWRF]
ACPI: acpi_idle registered with cpuidle
Monitor-Mwait will be used to enter C-1 state
Monitor-Mwait will be used to enter C-2 state
Monitor-Mwait will be used to enter C-3 state
thermal LNXTHERM:01: registered as thermal_zone0
ACPI: Thermal Zone [THM0] (55 C)
ERST: Table is not found!
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
agpgart-intel 0000:00:00.0: Intel HD Graphics Chipset
agpgart-intel 0000:00:00.0: detected 32764K stolen memory
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
tpm_tis 00:0b: 1.2 TPM (device-id 0x0, rev-id 78)
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
brd: module loaded
loop: module loaded
ahci 0000:00:1f.2: version 3.0
  alloc irq_desc for 16 on node -1
  alloc kstat_irqs on node -1
ahci 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
  alloc irq_desc for 45 on node -1
  alloc kstat_irqs on node -1
ahci 0000:00:1f.2: irq 45 for MSI/MSI-X
ahci: SSS flag set, parallel bus scan disabled
ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 3 Gbps 0x33 impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq sntf ilck stag pm led clo pmp pio slum part ems sxs apst 
ahci 0000:00:1f.2: setting latency timer to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
ata1: SATA max UDMA/133 abar m2048@0xf2727000 port 0xf2727100 irq 45
ata2: SATA max UDMA/133 abar m2048@0xf2727000 port 0xf2727180 irq 45
ata3: DUMMY
ata4: DUMMY
ata5: SATA max UDMA/133 abar m2048@0xf2727000 port 0xf2727300 irq 45
ata6: SATA max UDMA/133 abar m2048@0xf2727000 port 0xf2727380 irq 45
Fixed MDIO Bus: probed
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
ehci_hcd 0000:00:1a.0: PCI INT D -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1a.0: setting latency timer to 64
ehci_hcd 0000:00:1a.0: EHCI Host Controller
ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.0: debug port 2
ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
ehci_hcd 0000:00:1a.0: irq 23, io mem 0xf2728000
ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.35-0.40.rc5.git1.fc14.x86_64 ehci_hcd
usb usb1: SerialNumber: 0000:00:1a.0
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 3 ports detected
ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
  alloc irq_desc for 19 on node -1
  alloc kstat_irqs on node -1
ehci_hcd 0000:00:1d.0: PCI INT D -> GSI 19 (level, low) -> IRQ 19
ehci_hcd 0000:00:1d.0: setting latency timer to 64
ehci_hcd 0000:00:1d.0: EHCI Host Controller
ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.0: debug port 2
ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
ehci_hcd 0000:00:1d.0: irq 19, io mem 0xf2728400
ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: EHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.35-0.40.rc5.git1.fc14.x86_64 ehci_hcd
usb usb2: SerialNumber: 0000:00:1d.0
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 3 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
uhci_hcd: USB Universal Host Controller Interface driver
PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
rtc_cmos 00:08: RTC can wake from S4
rtc_cmos 00:08: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) initialised: dm-devel@redhat.com
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
nf_conntrack.acct=1 kernel parameter, acct=1 nf_conntrack module option or
sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
PM: Resume from disk failed.
registered taskstats version 1
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
IMA: No TPM chip found, activating TPM-bypass!
  Magic number: 2:354:797
rtc_cmos 00:08: setting system clock to 2010-07-16 18:47:46 UTC (1279306066)
Initalizing network drop monitor service
ACPI: Battery Slot [BAT0] (battery present)
usb 1-1: new high speed USB device using ehci_hcd and address 2
usb 1-1: New USB device found, idVendor=8087, idProduct=0020
usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
hub 1-1:1.0: USB hub found
hub 1-1:1.0: 6 ports detected
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: ATA-8: HITACHI HTS725032A9A364, PC3ZC70F, max UDMA/100
ata1.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: configured for UDMA/100
ata1.00: configured for UDMA/100
ata1: EH complete
scsi 0:0:0:0: Direct-Access     ATA      HITACHI HTS72503 PC3Z PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB/298 GiB)
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2
sd 0:0:0:0: [sda] Attached SCSI disk
usb 2-1: new high speed USB device using ehci_hcd and address 2
usb 2-1: New USB device found, idVendor=8087, idProduct=0020
usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
hub 2-1:1.0: USB hub found
hub 2-1:1.0: 8 ports detected
usb 1-1.3: new full speed USB device using ehci_hcd and address 3
ata2: SATA link down (SStatus 0 SControl 300)
usb 1-1.3: New USB device found, idVendor=147e, idProduct=2016
usb 1-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-1.3: Product: Biometric Coprocessor
usb 1-1.3: Manufacturer: UPEK
input: PS/2 Generic Mouse as /devices/platform/i8042/serio1/input/input4
usb 1-1.4: new full speed USB device using ehci_hcd and address 4
usb 1-1.4: New USB device found, idVendor=0a5c, idProduct=217f
usb 1-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-1.4: Product: Broadcom Bluetooth Device
usb 1-1.4: Manufacturer: Broadcom Corp
usb 1-1.4: SerialNumber: C417FEF2CB38
ata5: SATA link down (SStatus 0 SControl 300)
ata6: SATA link down (SStatus 0 SControl 300)
Freeing unused kernel memory: 952k freed
Write protecting the kernel read-only data: 10240k
Freeing unused kernel memory: 1604k freed
Freeing unused kernel memory: 1900k freed
dracut: dracut-005-3.fc13
dracut: rd_NO_LUKS: removing cryptoluks activation
udev: starting version 151
[drm] Initialized drm 1.1.0 20060810
i915 0000:00:02.0: power state changed by ACPI to D0
i915 0000:00:02.0: power state changed by ACPI to D0
i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
i915 0000:00:02.0: setting latency timer to 64
  alloc irq_desc for 46 on node -1
  alloc kstat_irqs on node -1
i915 0000:00:02.0: irq 46 for MSI/MSI-X
[drm] set up 31M of stolen space
fbcon: inteldrmfb (fb0) is primary device
Console: switching to colour frame buffer device 180x56
fb0: inteldrmfb frame buffer device
drm: registered panic notifier
Slow work thread pool: Starting up
Slow work thread pool: Ready
acpi device:01: registered as cooling_device4
input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input5
ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
dracut: Starting plymouth daemon
dracut: rd_NO_DM: removing DM RAID activation
dracut: rd_NO_MD: removing MD RAID activation
dracut: rd_NO_MDIMSM: no MD RAID for imsm/isw raids
dracut: Scanning devices sda2  for LVM logical volumes vg_dreadnought/lv_root 
dracut: inactive '/dev/vg_dreadnought/lv_root' [50.00 GiB] inherit
dracut: inactive '/dev/vg_dreadnought/lv_home' [241.94 GiB] inherit
dracut: inactive '/dev/vg_dreadnought/lv_swap' [5.66 GiB] inherit
EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: (null)
dracut: Mounted root filesystem /dev/mapper/vg_dreadnought-lv_root
dracut: Loading SELinux policy
dracut: /sbin/load_policy: Can't load policy: No such device
dracut: Switching root
readahead-collector: starting
readahead-collector: sorting
udev: starting version 151
microcode: CPU0 sig=0x20652, pf=0x10, revision=0x9
microcode: CPU1 sig=0x20652, pf=0x10, revision=0x9
microcode: CPU2 sig=0x20652, pf=0x10, revision=0x9
microcode: CPU3 sig=0x20652, pf=0x10, revision=0x9
microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
WARNING! power/level is deprecated; use power/control instead
ACPI: WMI: Mapper loaded
i801_smbus 0000:00:1f.3: PCI INT A -> GSI 23 (level, low) -> IRQ 23
thinkpad_acpi: ThinkPad ACPI Extras v0.24
thinkpad_acpi: http://ibm-acpi.sf.net/
thinkpad_acpi: ThinkPad BIOS 6QET35WW (1.05 ), EC 6QHT24WW-1.05
thinkpad_acpi: Lenovo ThinkPad X201s, model 5397CTO
thinkpad_acpi: detected a 16-level brightness capable ThinkPad
thinkpad_acpi: radio switch found; radios are enabled
thinkpad_acpi: possible tablet mode switch found; ThinkPad in laptop mode
thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness control, supported by the ACPI video driver
thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is unblocked
Registered led device: tpacpi::thinklight
Registered led device: tpacpi::power
Registered led device: tpacpi::standby
Registered led device: tpacpi::thinkvantage
cfg80211: Calling CRDA to update world regulatory domain
thinkpad_acpi: Standard ACPI backlight interface available, not loading native one.
thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input6
e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k4
e1000e: Copyright (c) 1999 - 2009 Intel Corporation.
e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
e1000e 0000:00:19.0: setting latency timer to 64
  alloc irq_desc for 47 on node -1
  alloc kstat_irqs on node -1
e1000e 0000:00:19.0: irq 47 for MSI/MSI-X
iTCO_vendor_support: vendor-support=0
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.06
iTCO_wdt: Found a QM57 TCO device (Version=2, TCOBASE=0x1060)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
e1000e 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:26:2d:f4:fe:af
e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
e1000e 0000:00:19.0: eth0: MAC: 9, PHY: 10, PBA No: a002ff-0ff
  alloc irq_desc for 17 on node -1
  alloc kstat_irqs on node -1
HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
  alloc irq_desc for 48 on node -1
  alloc kstat_irqs on node -1
HDA Intel 0000:00:1b.0: irq 48 for MSI/MSI-X
HDA Intel 0000:00:1b.0: setting latency timer to 64
Bluetooth: Core ver 2.15
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: Generic Bluetooth USB driver ver 0.6
usbcore: registered new interface driver btusb
iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:d
iwlagn: Copyright(c) 2003-2010 Intel Corporation
iwlagn 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
iwlagn 0000:02:00.0: setting latency timer to 64
iwlagn 0000:02:00.0: Detected Intel(R) Centrino(R) Ultimate-N 6300 AGN, REV=0x74
iwlagn 0000:02:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
  alloc irq_desc for 49 on node -1
  alloc kstat_irqs on node -1
iwlagn 0000:02:00.0: irq 49 for MSI/MSI-X
iwlagn 0000:02:00.0: loaded firmware version 9.221.4.1 build 25532
cfg80211: World regulatory domain updated:
    (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
    (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
    (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
    (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
    (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
    (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
phy0: Selected rate control algorithm 'iwl-agn-rs'
cfg80211: Calling CRDA for country: CA
cfg80211: Regulatory domain changed to country: CA
    (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
    (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
    (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
    (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
    (5490000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
    (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
EXT4-fs (dm-0): re-mounted. Opts: (null)
EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
EXT4-fs (dm-1): mounted filesystem with ordered data mode. Opts: (null)
Adding 5931004k swap on /dev/mapper/vg_dreadnought-lv_swap.  Priority:-1 extents:1 across:5931004k 
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
e1000e 0000:00:19.0: irq 47 for MSI/MSI-X
e1000e 0000:00:19.0: irq 47 for MSI/MSI-X
ADDRCONF(NETDEV_UP): eth0: link is not ready
readahead-collector: finished
ADDRCONF(NETDEV_UP): wlan0: link is not ready
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
Bluetooth: L2CAP ver 2.14
Bluetooth: L2CAP socket layer initialized
Bluetooth: BNEP (Ethernet Emulation) ver 1.3
Bluetooth: BNEP filters: protocol multicast
Bridge firewalling registered
Bluetooth: SCO (Voice Link) ver 0.6
Bluetooth: SCO socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM ver 1.11
lo: Disabled Privacy Extensions
fuse init (API version 7.14)
wlan0: deauthenticating from 00:25:bc:8a:6e:da by local choice (reason=3)
wlan0: authenticate with 00:25:bc:8a:6e:da (try 1)
wlan0: authenticate with 00:25:bc:8a:6e:da (try 2)
wlan0: authenticated
wlan0: associate with 00:25:bc:8a:6e:da (try 1)
wlan0: associate with 00:25:bc:8a:6e:da (try 2)
wlan0: RX AssocResp from 00:25:bc:8a:6e:da (capab=0x411 status=0 aid=3)
wlan0: associated
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
cfg80211: Calling CRDA for country: CA
padlock: VIA PadLock not detected.
wlan0: no IPv6 routers present
iwlagn 0000:02:00.0: iwlagn_tx_agg_start on ra = 00:25:bc:8a:6e:da tid = 6
iwlagn 0000:02:00.0: iwlagn_tx_agg_start on ra = 00:25:bc:8a:6e:da tid = 0
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
tun0: Disabled Privacy Extensions
iwlagn 0000:02:00.0: Received BA when not expected
iwlagn 0000:02:00.0: Received BA when not expected
iwlagn 0000:02:00.0: Received BA when not expected
iwlagn 0000:02:00.0: Received BA when not expected
iwlagn 0000:02:00.0: Received BA when not expected
iwlagn 0000:02:00.0: Received BA when not expected
tun0: Disabled Privacy Extensions

--EVF5PPMfhYS0aIcm--
