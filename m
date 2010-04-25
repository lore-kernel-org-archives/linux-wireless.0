Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:47862 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab0DYImh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Apr 2010 04:42:37 -0400
Received: by vws17 with SMTP id 17so830657vws.19
        for <linux-wireless@vger.kernel.org>; Sun, 25 Apr 2010 01:42:36 -0700 (PDT)
MIME-Version: 1.0
Reply-To: seco.wu@gmail.com
In-Reply-To: <u2p69e28c911004230108pd2452f2fga186ee2155c9e36c@mail.gmail.com>
References: <v2ne4fca08d1004221625o4eb31e79ke1043f0c9a8e686f@mail.gmail.com>
	 <t2qe4fca08d1004221720gc8551b6bq21fb043eb9128f56@mail.gmail.com>
	 <u2p69e28c911004230108pd2452f2fga186ee2155c9e36c@mail.gmail.com>
Date: Sun, 25 Apr 2010 16:42:36 +0800
Message-ID: <s2ne4fca08d1004250142ga518cbfdn1692b54c23191bef@mail.gmail.com>
Subject: Re: update compat drivers,adpter can not be work,4 help.tks
From: SECO <secowu@gmail.com>
To: =?UTF-8?Q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

tks Sir

what's matter with update compat-wireless under bt4?

--seco


00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-CBFFF write-protect
  CC000-EFFFF uncachable
  F0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 0000000000 mask FFE0000000 write-back
  1 disabled
  2 disabled
  3 disabled
  4 disabled
  5 disabled
  6 disabled
  7 disabled
x86 PAT enabled: cpu 0, old 0x0, new 0x7010600070106
init_memory_mapping: 0000000000000000-0000000020000000
 0000000000 - 0000400000 page 4k
 0000400000 - 0020000000 page 2M
kernel direct mapping tables up to 20000000 @ 10000-14000
RAMDISK: 1f9ef000 - 1fedf950
ACPI: RSDP 000f6940 00024 (v02 PTLTD )
ACPI: XSDT 1fef0885 0004C (v01 INTEL  440BX    06040000 VMW  01324272)
ACPI: FACP 1fefee98 000F4 (v04 INTEL  440BX    06040000 PTL  000F4240)
ACPI: DSDT 1fef0a3d 0E45B (v01 PTLTD  Custom   06040000 MSFT 03000001)
ACPI: FACS 1fefffc0 00040
ACPI: BOOT 1fef0a15 00028 (v01 PTLTD  $SBFTBL$ 06040000  LTP 00000001)
ACPI: APIC 1fef09c5 00050 (v01 PTLTD     APIC   06040000  LTP 00000000)
ACPI: MCFG 1fef0989 0003C (v01 PTLTD  $PCITBL$ 06040000  LTP 00000001)
ACPI: SRAT 1fef0909 00080 (v02 VMWARE MEMPLUG  06040000 VMW  00000001)
ACPI: Local APIC address 0xfee00000
0MB HIGHMEM available.
512MB LOWMEM available.
  mapped low ram: 0 - 20000000
  low ram: 0 - 20000000
  node 0 low ram: 00000000 - 20000000
  node 0 bootmap 00010000 - 00014000
(8 early reservations) ==> bootmem [0000000000 - 0020000000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
  #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
  #3 [0000100000 - 00009e4374]    TEXT DATA BSS ==> [0000100000 - 00009e4374]
  #4 [001f9ef000 - 001fedf950]          RAMDISK ==> [001f9ef000 - 001fedf950]
  #5 [000009f800 - 0000100000]    BIOS reserved ==> [000009f800 - 0000100000]
  #6 [00009e5000 - 00009e81c0]              BRK ==> [00009e5000 - 00009e81c0]
  #7 [0000010000 - 0000014000]          BOOTMAP ==> [0000010000 - 0000014000]
found SMP MP-table at [c00f69b0] f69b0
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  Normal   0x00001000 -> 0x00020000
  HighMem  0x00020000 -> 0x00020000
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0: 0x00000010 -> 0x0000009f
    0: 0x00000100 -> 0x0001fef0
    0: 0x0001ff00 -> 0x00020000
On node 0 totalpages: 130943
free_area_init_node: node 0, pgdat c08e7b40, node_mem_map c1000200
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3951 pages, LIFO batch:0
  Normal zone: 992 pages used for memmap
  Normal zone: 125968 pages, LIFO batch:31
Using APIC driver default
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 17, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 1 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 24
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000dc000
PM: Registered nosave memory: 00000000000dc000 - 00000000000e4000
PM: Registered nosave memory: 00000000000e4000 - 00000000000e8000
PM: Registered nosave memory: 00000000000e8000 - 0000000000100000
PM: Registered nosave memory: 000000001fef0000 - 000000001feff000
PM: Registered nosave memory: 000000001feff000 - 000000001ff00000
Allocating PCI resources starting at 30000000 (gap: 20000000:c0000000)
NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:1 nr_node_ids:1
PERCPU: Embedded 11 pages at c1402000, static data 23068 bytes
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 129919
Kernel command line: root=UUID=f996e2eb-094e-46ef-93c6-8a9b3aa71aaa ro
quiet splash
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
NR_IRQS:512
PID hash table entries: 2048 (order: 11, 8192 bytes)
Extended CMOS year: 2000
TSC: Frequency read from the hypervisor
Detected 2800.099 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Initializing HighMem for node 0 (00000000:00000000)
Memory: 504580k/524288k available (6103k kernel code, 18816k reserved,
2103k data, 432k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff4f000 - 0xfffff000   ( 704 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xe0800000 - 0xff7fe000   ( 495 MB)
    lowmem  : 0xc0000000 - 0xe0000000   ( 512 MB)
      .init : 0xc090d000 - 0xc0979000   ( 432 kB)
      .data : 0xc06f5dad - 0xc0903a44   (2103 kB)
      .text : 0xc0100000 - 0xc06f5dad   (6103 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
Calibrating delay loop (skipped), value calculated using timer
frequency.. 5602.53 BogoMIPS (lpj=9333663)
Security Framework initialized
Mount-cache hash table entries: 512
CPU: Physical Processor ID: 0
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 3072K
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
Freeing SMP alternatives: 24k freed
ACPI: Core revision 20090320
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Core(TM)2 Duo CPU     E7400  @ 2.80GHz stepping 0a
Brought up 1 CPUs
Total of 1 processors activated (5602.53 BogoMIPS).
net_namespace: 980 bytes
xor: automatically using best checksumming function: pIII_sse
   pIII_sse  :  9027.600 MB/sec
xor: using function: pIII_sse (9027.600 MB/sec)
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
PCI: MCFG area at e0000000 reserved in E820
PCI: Using MMCONFIG for extended config space
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI: BIOS _OSI(Linux) query ignored
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:07.1: reg 20 io port: [0x10c0-0x10cf]
pci 0000:00:07.3: quirk: region 1000-103f claimed by PIIX4 ACPI
pci 0000:00:07.3: quirk: region 1040-104f claimed by PIIX4 SMB
pci 0000:00:07.7: reg 10 io port: [0x1080-0x10bf]
pci 0000:00:0f.0: reg 10 io port: [0x10d0-0x10df]
pci 0000:00:0f.0: reg 14 32bit mmio: [0xd0000000-0xd7ffffff]
pci 0000:00:0f.0: reg 18 32bit mmio: [0xd8000000-0xd87fffff]
pci 0000:00:0f.0: reg 30 32bit mmio: [0x000000-0x007fff]
pci 0000:00:10.0: reg 10 io port: [0x1400-0x14ff]
pci 0000:00:10.0: reg 14 64bit mmio: [0xd8820000-0xd883ffff]
pci 0000:00:10.0: reg 1c 64bit mmio: [0xd8800000-0xd881ffff]
pci 0000:00:10.0: reg 30 32bit mmio: [0x000000-0x003fff]
pci 0000:00:15.0: PME# supported from D0 D3hot D3cold
pci 0000:00:15.0: PME# disabled
pci 0000:00:15.1: PME# supported from D0 D3hot D3cold
pci 0000:00:15.1: PME# disabled
pci 0000:00:15.2: PME# supported from D0 D3hot D3cold
pci 0000:00:15.2: PME# disabled
pci 0000:00:15.3: PME# supported from D0 D3hot D3cold
pci 0000:00:15.3: PME# disabled
pci 0000:00:15.4: PME# supported from D0 D3hot D3cold
pci 0000:00:15.4: PME# disabled
pci 0000:00:15.5: PME# supported from D0 D3hot D3cold
pci 0000:00:15.5: PME# disabled
pci 0000:00:15.6: PME# supported from D0 D3hot D3cold
pci 0000:00:15.6: PME# disabled
pci 0000:00:15.7: PME# supported from D0 D3hot D3cold
pci 0000:00:15.7: PME# disabled
pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
pci 0000:00:16.0: PME# disabled
pci 0000:00:16.1: PME# supported from D0 D3hot D3cold
pci 0000:00:16.1: PME# disabled
pci 0000:00:16.2: PME# supported from D0 D3hot D3cold
pci 0000:00:16.2: PME# disabled
pci 0000:00:16.3: PME# supported from D0 D3hot D3cold
pci 0000:00:16.3: PME# disabled
pci 0000:00:16.4: PME# supported from D0 D3hot D3cold
pci 0000:00:16.4: PME# disabled
pci 0000:00:16.5: PME# supported from D0 D3hot D3cold
pci 0000:00:16.5: PME# disabled
pci 0000:00:16.6: PME# supported from D0 D3hot D3cold
pci 0000:00:16.6: PME# disabled
pci 0000:00:16.7: PME# supported from D0 D3hot D3cold
pci 0000:00:16.7: PME# disabled
pci 0000:00:17.0: PME# supported from D0 D3hot D3cold
pci 0000:00:17.0: PME# disabled
pci 0000:00:17.1: PME# supported from D0 D3hot D3cold
pci 0000:00:17.1: PME# disabled
pci 0000:00:17.2: PME# supported from D0 D3hot D3cold
pci 0000:00:17.2: PME# disabled
pci 0000:00:17.3: PME# supported from D0 D3hot D3cold
pci 0000:00:17.3: PME# disabled
pci 0000:00:17.4: PME# supported from D0 D3hot D3cold
pci 0000:00:17.4: PME# disabled
pci 0000:00:17.5: PME# supported from D0 D3hot D3cold
pci 0000:00:17.5: PME# disabled
pci 0000:00:17.6: PME# supported from D0 D3hot D3cold
pci 0000:00:17.6: PME# disabled
pci 0000:00:17.7: PME# supported from D0 D3hot D3cold
pci 0000:00:17.7: PME# disabled
pci 0000:00:18.0: PME# supported from D0 D3hot D3cold
pci 0000:00:18.0: PME# disabled
pci 0000:00:18.1: PME# supported from D0 D3hot D3cold
pci 0000:00:18.1: PME# disabled
pci 0000:00:18.2: PME# supported from D0 D3hot D3cold
pci 0000:00:18.2: PME# disabled
pci 0000:00:18.3: PME# supported from D0 D3hot D3cold
pci 0000:00:18.3: PME# disabled
pci 0000:00:18.4: PME# supported from D0 D3hot D3cold
pci 0000:00:18.4: PME# disabled
pci 0000:00:18.5: PME# supported from D0 D3hot D3cold
pci 0000:00:18.5: PME# disabled
pci 0000:00:18.6: PME# supported from D0 D3hot D3cold
pci 0000:00:18.6: PME# disabled
pci 0000:00:18.7: PME# supported from D0 D3hot D3cold
pci 0000:00:18.7: PME# disabled
pci 0000:02:00.0: reg 20 io port: [0x20c0-0x20df]
pci 0000:02:01.0: reg 10 io port: [0x2000-0x207f]
pci 0000:02:01.0: reg 30 32bit mmio: [0x000000-0x00ffff]
pci 0000:02:02.0: reg 10 io port: [0x2080-0x20bf]
pci 0000:02:03.0: reg 10 32bit mmio: [0xd8900000-0xd8900fff]
pci 0000:00:11.0: transparent bridge
pci 0000:00:11.0: bridge io port: [0x2000-0x3fff]
pci 0000:00:11.0: bridge 32bit mmio: [0xd8900000-0xd9cfffff]
pci 0000:00:11.0: bridge 64bit mmio pref: [0xdc400000-0xdc9fffff]
pci 0000:00:15.0: bridge io port: [0x4000-0x4fff]
pci 0000:00:15.0: bridge 32bit mmio: [0xd9d00000-0xd9dfffff]
pci 0000:00:15.0: bridge 64bit mmio pref: [0xdca00000-0xdcafffff]
pci 0000:00:15.1: bridge io port: [0x8000-0x8fff]
pci 0000:00:15.1: bridge 32bit mmio: [0xda100000-0xda1fffff]
pci 0000:00:15.1: bridge 64bit mmio pref: [0xdce00000-0xdcefffff]
pci 0000:00:15.2: bridge io port: [0xc000-0xcfff]
pci 0000:00:15.2: bridge 32bit mmio: [0xda500000-0xda5fffff]
pci 0000:00:15.2: bridge 64bit mmio pref: [0xdd200000-0xdd2fffff]
pci 0000:00:15.3: bridge 32bit mmio: [0xda900000-0xda9fffff]
pci 0000:00:15.3: bridge 64bit mmio pref: [0xdd600000-0xdd6fffff]
pci 0000:00:15.4: bridge 32bit mmio: [0xdad00000-0xdadfffff]
pci 0000:00:15.4: bridge 64bit mmio pref: [0xdda00000-0xddafffff]
pci 0000:00:15.5: bridge 32bit mmio: [0xdb100000-0xdb1fffff]
pci 0000:00:15.5: bridge 64bit mmio pref: [0xdde00000-0xddefffff]
pci 0000:00:15.6: bridge 32bit mmio: [0xdb500000-0xdb5fffff]
pci 0000:00:15.6: bridge 64bit mmio pref: [0xde200000-0xde2fffff]
pci 0000:00:15.7: bridge 32bit mmio: [0xdb900000-0xdb9fffff]
pci 0000:00:15.7: bridge 64bit mmio pref: [0xde600000-0xde6fffff]
pci 0000:00:16.0: bridge io port: [0x5000-0x5fff]
pci 0000:00:16.0: bridge 32bit mmio: [0xd9e00000-0xd9efffff]
pci 0000:00:16.0: bridge 64bit mmio pref: [0xdcb00000-0xdcbfffff]
pci 0000:00:16.1: bridge io port: [0x9000-0x9fff]
pci 0000:00:16.1: bridge 32bit mmio: [0xda200000-0xda2fffff]
pci 0000:00:16.1: bridge 64bit mmio pref: [0xdcf00000-0xdcffffff]
pci 0000:00:16.2: bridge io port: [0xd000-0xdfff]
pci 0000:00:16.2: bridge 32bit mmio: [0xda600000-0xda6fffff]
pci 0000:00:16.2: bridge 64bit mmio pref: [0xdd300000-0xdd3fffff]
pci 0000:00:16.3: bridge 32bit mmio: [0xdaa00000-0xdaafffff]
pci 0000:00:16.3: bridge 64bit mmio pref: [0xdd700000-0xdd7fffff]
pci 0000:00:16.4: bridge 32bit mmio: [0xdae00000-0xdaefffff]
pci 0000:00:16.4: bridge 64bit mmio pref: [0xddb00000-0xddbfffff]
pci 0000:00:16.5: bridge 32bit mmio: [0xdb200000-0xdb2fffff]
pci 0000:00:16.5: bridge 64bit mmio pref: [0xddf00000-0xddffffff]
pci 0000:00:16.6: bridge 32bit mmio: [0xdb600000-0xdb6fffff]
pci 0000:00:16.6: bridge 64bit mmio pref: [0xde300000-0xde3fffff]
pci 0000:00:16.7: bridge 32bit mmio: [0xdba00000-0xdbafffff]
pci 0000:00:16.7: bridge 64bit mmio pref: [0xde700000-0xde7fffff]
pci 0000:00:17.0: bridge io port: [0x6000-0x6fff]
pci 0000:00:17.0: bridge 32bit mmio: [0xd9f00000-0xd9ffffff]
pci 0000:00:17.0: bridge 64bit mmio pref: [0xdcc00000-0xdccfffff]
pci 0000:00:17.1: bridge io port: [0xa000-0xafff]
pci 0000:00:17.1: bridge 32bit mmio: [0xda300000-0xda3fffff]
pci 0000:00:17.1: bridge 64bit mmio pref: [0xdd000000-0xdd0fffff]
pci 0000:00:17.2: bridge io port: [0xe000-0xefff]
pci 0000:00:17.2: bridge 32bit mmio: [0xda700000-0xda7fffff]
pci 0000:00:17.2: bridge 64bit mmio pref: [0xdd400000-0xdd4fffff]
pci 0000:00:17.3: bridge 32bit mmio: [0xdab00000-0xdabfffff]
pci 0000:00:17.3: bridge 64bit mmio pref: [0xdd800000-0xdd8fffff]
pci 0000:00:17.4: bridge 32bit mmio: [0xdaf00000-0xdaffffff]
pci 0000:00:17.4: bridge 64bit mmio pref: [0xddc00000-0xddcfffff]
pci 0000:00:17.5: bridge 32bit mmio: [0xdb300000-0xdb3fffff]
pci 0000:00:17.5: bridge 64bit mmio pref: [0xde000000-0xde0fffff]
pci 0000:00:17.6: bridge 32bit mmio: [0xdb700000-0xdb7fffff]
pci 0000:00:17.6: bridge 64bit mmio pref: [0xde400000-0xde4fffff]
pci 0000:00:17.7: bridge 32bit mmio: [0xdbb00000-0xdbbfffff]
pci 0000:00:17.7: bridge 64bit mmio pref: [0xde800000-0xde8fffff]
pci 0000:00:18.0: bridge io port: [0x7000-0x7fff]
pci 0000:00:18.0: bridge 32bit mmio: [0xda000000-0xda0fffff]
pci 0000:00:18.0: bridge 64bit mmio pref: [0xdcd00000-0xdcdfffff]
pci 0000:00:18.1: bridge io port: [0xb000-0xbfff]
pci 0000:00:18.1: bridge 32bit mmio: [0xda400000-0xda4fffff]
pci 0000:00:18.1: bridge 64bit mmio pref: [0xdd100000-0xdd1fffff]
pci 0000:00:18.2: bridge io port: [0xf000-0xffff]
pci 0000:00:18.2: bridge 32bit mmio: [0xda800000-0xda8fffff]
pci 0000:00:18.2: bridge 64bit mmio pref: [0xdd500000-0xdd5fffff]
pci 0000:00:18.3: bridge 32bit mmio: [0xdac00000-0xdacfffff]
pci 0000:00:18.3: bridge 64bit mmio pref: [0xdd900000-0xdd9fffff]
pci 0000:00:18.4: bridge 32bit mmio: [0xdb000000-0xdb0fffff]
pci 0000:00:18.4: bridge 64bit mmio pref: [0xddd00000-0xdddfffff]
pci 0000:00:18.5: bridge 32bit mmio: [0xdb400000-0xdb4fffff]
pci 0000:00:18.5: bridge 64bit mmio pref: [0xde100000-0xde1fffff]
pci 0000:00:18.6: bridge 32bit mmio: [0xdb800000-0xdb8fffff]
pci 0000:00:18.6: bridge 64bit mmio pref: [0xde500000-0xde5fffff]
pci 0000:00:18.7: bridge 32bit mmio: [0xdbc00000-0xdbcfffff]
pci 0000:00:18.7: bridge 64bit mmio pref: [0xde900000-0xde9fffff]
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *9 10 11 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 *10 11 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 9 10 11 14 15)
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
raid6: int32x1   1528 MB/s
raid6: int32x2   1484 MB/s
raid6: int32x4   1136 MB/s
raid6: int32x8   1189 MB/s
raid6: mmxx1     3446 MB/s
raid6: mmxx2     3937 MB/s
raid6: sse1x1    2347 MB/s
raid6: sse1x2    3989 MB/s
raid6: sse2x1    5889 MB/s
raid6: sse2x2    3582 MB/s
raid6: using algorithm sse2x1 (5889 MB/s)
PCI: Using ACPI for IRQ routing
pnp: PnP ACPI init
ACPI: bus type pnp registered
Switched to high resolution mode on CPU 0
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
system 00:01: ioport range 0x1000-0x103f has been reserved
system 00:01: ioport range 0x1040-0x104f has been reserved
system 00:01: ioport range 0xcf0-0xcf1 has been reserved
system 00:0c: ioport range 0x1060-0x107f has been reserved
system 00:0c: iomem range 0xe0000000-0xefffffff has been reserved
system 00:0c: iomem range 0xdbe00000-0xdbffffff has been reserved
pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
pci 0000:00:01.0:   IO window: disabled
pci 0000:00:01.0:   MEM window: disabled
pci 0000:00:01.0:   PREFETCH window: disabled
pci 0000:00:11.0: PCI bridge, secondary bus 0000:02
pci 0000:00:11.0:   IO window: 0x2000-0x3fff
pci 0000:00:11.0:   MEM window: 0xd8900000-0xd9cfffff
pci 0000:00:11.0:   PREFETCH window: 0x000000dc400000-0x000000dc9fffff
pci 0000:00:15.0: PCI bridge, secondary bus 0000:03
pci 0000:00:15.0:   IO window: 0x4000-0x4fff
pci 0000:00:15.0:   MEM window: 0xd9d00000-0xd9dfffff
pci 0000:00:15.0:   PREFETCH window: 0x000000dca00000-0x000000dcafffff
pci 0000:00:15.1: PCI bridge, secondary bus 0000:04
pci 0000:00:15.1:   IO window: 0x8000-0x8fff
pci 0000:00:15.1:   MEM window: 0xda100000-0xda1fffff
pci 0000:00:15.1:   PREFETCH window: 0x000000dce00000-0x000000dcefffff
pci 0000:00:15.2: PCI bridge, secondary bus 0000:05
pci 0000:00:15.2:   IO window: 0xc000-0xcfff
pci 0000:00:15.2:   MEM window: 0xda500000-0xda5fffff
pci 0000:00:15.2:   PREFETCH window: 0x000000dd200000-0x000000dd2fffff
pci 0000:00:15.3: PCI bridge, secondary bus 0000:06
pci 0000:00:15.3:   IO window: disabled
pci 0000:00:15.3:   MEM window: 0xda900000-0xda9fffff
pci 0000:00:15.3:   PREFETCH window: 0x000000dd600000-0x000000dd6fffff
pci 0000:00:15.4: PCI bridge, secondary bus 0000:07
pci 0000:00:15.4:   IO window: disabled
pci 0000:00:15.4:   MEM window: 0xdad00000-0xdadfffff
pci 0000:00:15.4:   PREFETCH window: 0x000000dda00000-0x000000ddafffff
pci 0000:00:15.5: PCI bridge, secondary bus 0000:08
pci 0000:00:15.5:   IO window: disabled
pci 0000:00:15.5:   MEM window: 0xdb100000-0xdb1fffff
pci 0000:00:15.5:   PREFETCH window: 0x000000dde00000-0x000000ddefffff
pci 0000:00:15.6: PCI bridge, secondary bus 0000:09
pci 0000:00:15.6:   IO window: disabled
pci 0000:00:15.6:   MEM window: 0xdb500000-0xdb5fffff
pci 0000:00:15.6:   PREFETCH window: 0x000000de200000-0x000000de2fffff
pci 0000:00:15.7: PCI bridge, secondary bus 0000:0a
pci 0000:00:15.7:   IO window: disabled
pci 0000:00:15.7:   MEM window: 0xdb900000-0xdb9fffff
pci 0000:00:15.7:   PREFETCH window: 0x000000de600000-0x000000de6fffff
pci 0000:00:16.0: PCI bridge, secondary bus 0000:0b
pci 0000:00:16.0:   IO window: 0x5000-0x5fff
pci 0000:00:16.0:   MEM window: 0xd9e00000-0xd9efffff
pci 0000:00:16.0:   PREFETCH window: 0x000000dcb00000-0x000000dcbfffff
pci 0000:00:16.1: PCI bridge, secondary bus 0000:0c
pci 0000:00:16.1:   IO window: 0x9000-0x9fff
pci 0000:00:16.1:   MEM window: 0xda200000-0xda2fffff
pci 0000:00:16.1:   PREFETCH window: 0x000000dcf00000-0x000000dcffffff
pci 0000:00:16.2: PCI bridge, secondary bus 0000:0d
pci 0000:00:16.2:   IO window: 0xd000-0xdfff
pci 0000:00:16.2:   MEM window: 0xda600000-0xda6fffff
pci 0000:00:16.2:   PREFETCH window: 0x000000dd300000-0x000000dd3fffff
pci 0000:00:16.3: PCI bridge, secondary bus 0000:0e
pci 0000:00:16.3:   IO window: disabled
pci 0000:00:16.3:   MEM window: 0xdaa00000-0xdaafffff
pci 0000:00:16.3:   PREFETCH window: 0x000000dd700000-0x000000dd7fffff
pci 0000:00:16.4: PCI bridge, secondary bus 0000:0f
pci 0000:00:16.4:   IO window: disabled
pci 0000:00:16.4:   MEM window: 0xdae00000-0xdaefffff
pci 0000:00:16.4:   PREFETCH window: 0x000000ddb00000-0x000000ddbfffff
pci 0000:00:16.5: PCI bridge, secondary bus 0000:10
pci 0000:00:16.5:   IO window: disabled
pci 0000:00:16.5:   MEM window: 0xdb200000-0xdb2fffff
pci 0000:00:16.5:   PREFETCH window: 0x000000ddf00000-0x000000ddffffff
pci 0000:00:16.6: PCI bridge, secondary bus 0000:11
pci 0000:00:16.6:   IO window: disabled
pci 0000:00:16.6:   MEM window: 0xdb600000-0xdb6fffff
pci 0000:00:16.6:   PREFETCH window: 0x000000de300000-0x000000de3fffff
pci 0000:00:16.7: PCI bridge, secondary bus 0000:12
pci 0000:00:16.7:   IO window: disabled
pci 0000:00:16.7:   MEM window: 0xdba00000-0xdbafffff
pci 0000:00:16.7:   PREFETCH window: 0x000000de700000-0x000000de7fffff
pci 0000:00:17.0: PCI bridge, secondary bus 0000:13
pci 0000:00:17.0:   IO window: 0x6000-0x6fff
pci 0000:00:17.0:   MEM window: 0xd9f00000-0xd9ffffff
pci 0000:00:17.0:   PREFETCH window: 0x000000dcc00000-0x000000dccfffff
pci 0000:00:17.1: PCI bridge, secondary bus 0000:14
pci 0000:00:17.1:   IO window: 0xa000-0xafff
pci 0000:00:17.1:   MEM window: 0xda300000-0xda3fffff
pci 0000:00:17.1:   PREFETCH window: 0x000000dd000000-0x000000dd0fffff
pci 0000:00:17.2: PCI bridge, secondary bus 0000:15
pci 0000:00:17.2:   IO window: 0xe000-0xefff
pci 0000:00:17.2:   MEM window: 0xda700000-0xda7fffff
pci 0000:00:17.2:   PREFETCH window: 0x000000dd400000-0x000000dd4fffff
pci 0000:00:17.3: PCI bridge, secondary bus 0000:16
pci 0000:00:17.3:   IO window: disabled
pci 0000:00:17.3:   MEM window: 0xdab00000-0xdabfffff
pci 0000:00:17.3:   PREFETCH window: 0x000000dd800000-0x000000dd8fffff
pci 0000:00:17.4: PCI bridge, secondary bus 0000:17
pci 0000:00:17.4:   IO window: disabled
pci 0000:00:17.4:   MEM window: 0xdaf00000-0xdaffffff
pci 0000:00:17.4:   PREFETCH window: 0x000000ddc00000-0x000000ddcfffff
pci 0000:00:17.5: PCI bridge, secondary bus 0000:18
pci 0000:00:17.5:   IO window: disabled
pci 0000:00:17.5:   MEM window: 0xdb300000-0xdb3fffff
pci 0000:00:17.5:   PREFETCH window: 0x000000de000000-0x000000de0fffff
pci 0000:00:17.6: PCI bridge, secondary bus 0000:19
pci 0000:00:17.6:   IO window: disabled
pci 0000:00:17.6:   MEM window: 0xdb700000-0xdb7fffff
pci 0000:00:17.6:   PREFETCH window: 0x000000de400000-0x000000de4fffff
pci 0000:00:17.7: PCI bridge, secondary bus 0000:1a
pci 0000:00:17.7:   IO window: disabled
pci 0000:00:17.7:   MEM window: 0xdbb00000-0xdbbfffff
pci 0000:00:17.7:   PREFETCH window: 0x000000de800000-0x000000de8fffff
pci 0000:00:18.0: PCI bridge, secondary bus 0000:1b
pci 0000:00:18.0:   IO window: 0x7000-0x7fff
pci 0000:00:18.0:   MEM window: 0xda000000-0xda0fffff
pci 0000:00:18.0:   PREFETCH window: 0x000000dcd00000-0x000000dcdfffff
pci 0000:00:18.1: PCI bridge, secondary bus 0000:1c
pci 0000:00:18.1:   IO window: 0xb000-0xbfff
pci 0000:00:18.1:   MEM window: 0xda400000-0xda4fffff
pci 0000:00:18.1:   PREFETCH window: 0x000000dd100000-0x000000dd1fffff
pci 0000:00:18.2: PCI bridge, secondary bus 0000:1d
pci 0000:00:18.2:   IO window: 0xf000-0xffff
pci 0000:00:18.2:   MEM window: 0xda800000-0xda8fffff
pci 0000:00:18.2:   PREFETCH window: 0x000000dd500000-0x000000dd5fffff
pci 0000:00:18.3: PCI bridge, secondary bus 0000:1e
pci 0000:00:18.3:   IO window: disabled
pci 0000:00:18.3:   MEM window: 0xdac00000-0xdacfffff
pci 0000:00:18.3:   PREFETCH window: 0x000000dd900000-0x000000dd9fffff
pci 0000:00:18.4: PCI bridge, secondary bus 0000:1f
pci 0000:00:18.4:   IO window: disabled
pci 0000:00:18.4:   MEM window: 0xdb000000-0xdb0fffff
pci 0000:00:18.4:   PREFETCH window: 0x000000ddd00000-0x000000dddfffff
pci 0000:00:18.5: PCI bridge, secondary bus 0000:20
pci 0000:00:18.5:   IO window: disabled
pci 0000:00:18.5:   MEM window: 0xdb400000-0xdb4fffff
pci 0000:00:18.5:   PREFETCH window: 0x000000de100000-0x000000de1fffff
pci 0000:00:18.6: PCI bridge, secondary bus 0000:21
pci 0000:00:18.6:   IO window: disabled
pci 0000:00:18.6:   MEM window: 0xdb800000-0xdb8fffff
pci 0000:00:18.6:   PREFETCH window: 0x000000de500000-0x000000de5fffff
pci 0000:00:18.7: PCI bridge, secondary bus 0000:22
pci 0000:00:18.7:   IO window: disabled
pci 0000:00:18.7:   MEM window: 0xdbc00000-0xdbcfffff
pci 0000:00:18.7:   PREFETCH window: 0x000000de900000-0x000000de9fffff
pci 0000:00:01.0: setting latency timer to 64
pci 0000:00:15.0: setting latency timer to 64
pci 0000:00:15.1: setting latency timer to 64
pci 0000:00:15.2: setting latency timer to 64
pci 0000:00:15.3: setting latency timer to 64
pci 0000:00:15.4: setting latency timer to 64
pci 0000:00:15.5: setting latency timer to 64
pci 0000:00:15.6: setting latency timer to 64
pci 0000:00:15.7: setting latency timer to 64
pci 0000:00:16.0: setting latency timer to 64
pci 0000:00:16.1: setting latency timer to 64
pci 0000:00:16.2: setting latency timer to 64
pci 0000:00:16.3: setting latency timer to 64
pci 0000:00:16.4: setting latency timer to 64
pci 0000:00:16.5: setting latency timer to 64
pci 0000:00:16.6: setting latency timer to 64
pci 0000:00:16.7: setting latency timer to 64
pci 0000:00:17.0: setting latency timer to 64
pci 0000:00:17.1: setting latency timer to 64
pci 0000:00:17.2: setting latency timer to 64
pci 0000:00:17.3: setting latency timer to 64
pci 0000:00:17.4: setting latency timer to 64
pci 0000:00:17.5: setting latency timer to 64
pci 0000:00:17.6: setting latency timer to 64
pci 0000:00:17.7: setting latency timer to 64
pci 0000:00:18.0: setting latency timer to 64
pci 0000:00:18.1: setting latency timer to 64
pci 0000:00:18.2: setting latency timer to 64
pci 0000:00:18.3: setting latency timer to 64
pci 0000:00:18.4: setting latency timer to 64
pci 0000:00:18.5: setting latency timer to 64
pci 0000:00:18.6: setting latency timer to 64
pci 0000:00:18.7: setting latency timer to 64
pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
pci_bus 0000:02: resource 0 io:  [0x2000-0x3fff]
pci_bus 0000:02: resource 1 mem: [0xd8900000-0xd9cfffff]
pci_bus 0000:02: resource 2 pref mem [0xdc400000-0xdc9fffff]
pci_bus 0000:02: resource 3 io:  [0x00-0xffff]
pci_bus 0000:02: resource 4 mem: [0x000000-0xffffffff]
pci_bus 0000:03: resource 0 io:  [0x4000-0x4fff]
pci_bus 0000:03: resource 1 mem: [0xd9d00000-0xd9dfffff]
pci_bus 0000:03: resource 2 pref mem [0xdca00000-0xdcafffff]
pci_bus 0000:04: resource 0 io:  [0x8000-0x8fff]
pci_bus 0000:04: resource 1 mem: [0xda100000-0xda1fffff]
pci_bus 0000:04: resource 2 pref mem [0xdce00000-0xdcefffff]
pci_bus 0000:05: resource 0 io:  [0xc000-0xcfff]
pci_bus 0000:05: resource 1 mem: [0xda500000-0xda5fffff]
pci_bus 0000:05: resource 2 pref mem [0xdd200000-0xdd2fffff]
pci_bus 0000:06: resource 1 mem: [0xda900000-0xda9fffff]
pci_bus 0000:06: resource 2 pref mem [0xdd600000-0xdd6fffff]
pci_bus 0000:07: resource 1 mem: [0xdad00000-0xdadfffff]
pci_bus 0000:07: resource 2 pref mem [0xdda00000-0xddafffff]
pci_bus 0000:08: resource 1 mem: [0xdb100000-0xdb1fffff]
pci_bus 0000:08: resource 2 pref mem [0xdde00000-0xddefffff]
pci_bus 0000:09: resource 1 mem: [0xdb500000-0xdb5fffff]
pci_bus 0000:09: resource 2 pref mem [0xde200000-0xde2fffff]
pci_bus 0000:0a: resource 1 mem: [0xdb900000-0xdb9fffff]
pci_bus 0000:0a: resource 2 pref mem [0xde600000-0xde6fffff]
pci_bus 0000:0b: resource 0 io:  [0x5000-0x5fff]
pci_bus 0000:0b: resource 1 mem: [0xd9e00000-0xd9efffff]
pci_bus 0000:0b: resource 2 pref mem [0xdcb00000-0xdcbfffff]
pci_bus 0000:0c: resource 0 io:  [0x9000-0x9fff]
pci_bus 0000:0c: resource 1 mem: [0xda200000-0xda2fffff]
pci_bus 0000:0c: resource 2 pref mem [0xdcf00000-0xdcffffff]
pci_bus 0000:0d: resource 0 io:  [0xd000-0xdfff]
pci_bus 0000:0d: resource 1 mem: [0xda600000-0xda6fffff]
pci_bus 0000:0d: resource 2 pref mem [0xdd300000-0xdd3fffff]
pci_bus 0000:0e: resource 1 mem: [0xdaa00000-0xdaafffff]
pci_bus 0000:0e: resource 2 pref mem [0xdd700000-0xdd7fffff]
pci_bus 0000:0f: resource 1 mem: [0xdae00000-0xdaefffff]
pci_bus 0000:0f: resource 2 pref mem [0xddb00000-0xddbfffff]
pci_bus 0000:10: resource 1 mem: [0xdb200000-0xdb2fffff]
pci_bus 0000:10: resource 2 pref mem [0xddf00000-0xddffffff]
pci_bus 0000:11: resource 1 mem: [0xdb600000-0xdb6fffff]
pci_bus 0000:11: resource 2 pref mem [0xde300000-0xde3fffff]
pci_bus 0000:12: resource 1 mem: [0xdba00000-0xdbafffff]
pci_bus 0000:12: resource 2 pref mem [0xde700000-0xde7fffff]
pci_bus 0000:13: resource 0 io:  [0x6000-0x6fff]
pci_bus 0000:13: resource 1 mem: [0xd9f00000-0xd9ffffff]
pci_bus 0000:13: resource 2 pref mem [0xdcc00000-0xdccfffff]
pci_bus 0000:14: resource 0 io:  [0xa000-0xafff]
pci_bus 0000:14: resource 1 mem: [0xda300000-0xda3fffff]
pci_bus 0000:14: resource 2 pref mem [0xdd000000-0xdd0fffff]
pci_bus 0000:15: resource 0 io:  [0xe000-0xefff]
pci_bus 0000:15: resource 1 mem: [0xda700000-0xda7fffff]
pci_bus 0000:15: resource 2 pref mem [0xdd400000-0xdd4fffff]
pci_bus 0000:16: resource 1 mem: [0xdab00000-0xdabfffff]
pci_bus 0000:16: resource 2 pref mem [0xdd800000-0xdd8fffff]
pci_bus 0000:17: resource 1 mem: [0xdaf00000-0xdaffffff]
pci_bus 0000:17: resource 2 pref mem [0xddc00000-0xddcfffff]
pci_bus 0000:18: resource 1 mem: [0xdb300000-0xdb3fffff]
pci_bus 0000:18: resource 2 pref mem [0xde000000-0xde0fffff]
pci_bus 0000:19: resource 1 mem: [0xdb700000-0xdb7fffff]
pci_bus 0000:19: resource 2 pref mem [0xde400000-0xde4fffff]
pci_bus 0000:1a: resource 1 mem: [0xdbb00000-0xdbbfffff]
pci_bus 0000:1a: resource 2 pref mem [0xde800000-0xde8fffff]
pci_bus 0000:1b: resource 0 io:  [0x7000-0x7fff]
pci_bus 0000:1b: resource 1 mem: [0xda000000-0xda0fffff]
pci_bus 0000:1b: resource 2 pref mem [0xdcd00000-0xdcdfffff]
pci_bus 0000:1c: resource 0 io:  [0xb000-0xbfff]
pci_bus 0000:1c: resource 1 mem: [0xda400000-0xda4fffff]
pci_bus 0000:1c: resource 2 pref mem [0xdd100000-0xdd1fffff]
pci_bus 0000:1d: resource 0 io:  [0xf000-0xffff]
pci_bus 0000:1d: resource 1 mem: [0xda800000-0xda8fffff]
pci_bus 0000:1d: resource 2 pref mem [0xdd500000-0xdd5fffff]
pci_bus 0000:1e: resource 1 mem: [0xdac00000-0xdacfffff]
pci_bus 0000:1e: resource 2 pref mem [0xdd900000-0xdd9fffff]
pci_bus 0000:1f: resource 1 mem: [0xdb000000-0xdb0fffff]
pci_bus 0000:1f: resource 2 pref mem [0xddd00000-0xdddfffff]
pci_bus 0000:20: resource 1 mem: [0xdb400000-0xdb4fffff]
pci_bus 0000:20: resource 2 pref mem [0xde100000-0xde1fffff]
pci_bus 0000:21: resource 1 mem: [0xdb800000-0xdb8fffff]
pci_bus 0000:21: resource 2 pref mem [0xde500000-0xde5fffff]
pci_bus 0000:22: resource 1 mem: [0xdbc00000-0xdbcfffff]
pci_bus 0000:22: resource 2 pref mem [0xde900000-0xde9fffff]
NET: Registered protocol family 2
IP route cache hash table entries: 16384 (order: 4, 65536 bytes)
TCP established hash table entries: 65536 (order: 7, 524288 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 65536 bind 65536)
TCP reno registered
NET: Registered protocol family 1
Trying to unpack rootfs image as initramfs...
Freeing initrd memory: 5058k freed
Simple Boot Flag at 0x36 set to 0x1
apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
apm: overridden by ACPI.
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
NTFS driver 2.1.29 [Flags: R/O].
msgmni has been set to 996
alg: No test for stdrng (krng)
async_tx: api initialized (sync-only)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:00:00.0: Limiting direct PCI/PCI transfers
pci 0000:00:0f.0: Boot video device
pcieport-driver 0000:00:15.0: irq 24 for MSI/MSI-X
pcieport-driver 0000:00:15.0: setting latency timer to 64
pcieport-driver 0000:00:15.1: irq 25 for MSI/MSI-X
pcieport-driver 0000:00:15.1: setting latency timer to 64
pcieport-driver 0000:00:15.2: irq 26 for MSI/MSI-X
pcieport-driver 0000:00:15.2: setting latency timer to 64
pcieport-driver 0000:00:15.3: irq 27 for MSI/MSI-X
pcieport-driver 0000:00:15.3: setting latency timer to 64
pcieport-driver 0000:00:15.4: irq 28 for MSI/MSI-X
pcieport-driver 0000:00:15.4: setting latency timer to 64
pcieport-driver 0000:00:15.5: irq 29 for MSI/MSI-X
pcieport-driver 0000:00:15.5: setting latency timer to 64
pcieport-driver 0000:00:15.6: irq 30 for MSI/MSI-X
pcieport-driver 0000:00:15.6: setting latency timer to 64
pcieport-driver 0000:00:15.7: irq 31 for MSI/MSI-X
pcieport-driver 0000:00:15.7: setting latency timer to 64
pcieport-driver 0000:00:16.0: irq 32 for MSI/MSI-X
pcieport-driver 0000:00:16.0: setting latency timer to 64
pcieport-driver 0000:00:16.1: irq 33 for MSI/MSI-X
pcieport-driver 0000:00:16.1: setting latency timer to 64
pcieport-driver 0000:00:16.2: irq 34 for MSI/MSI-X
pcieport-driver 0000:00:16.2: setting latency timer to 64
pcieport-driver 0000:00:16.3: irq 35 for MSI/MSI-X
pcieport-driver 0000:00:16.3: setting latency timer to 64
pcieport-driver 0000:00:16.4: irq 36 for MSI/MSI-X
pcieport-driver 0000:00:16.4: setting latency timer to 64
pcieport-driver 0000:00:16.5: irq 37 for MSI/MSI-X
pcieport-driver 0000:00:16.5: setting latency timer to 64
pcieport-driver 0000:00:16.6: irq 38 for MSI/MSI-X
pcieport-driver 0000:00:16.6: setting latency timer to 64
pcieport-driver 0000:00:16.7: irq 39 for MSI/MSI-X
pcieport-driver 0000:00:16.7: setting latency timer to 64
pcieport-driver 0000:00:17.0: irq 40 for MSI/MSI-X
pcieport-driver 0000:00:17.0: setting latency timer to 64
pcieport-driver 0000:00:17.1: irq 41 for MSI/MSI-X
pcieport-driver 0000:00:17.1: setting latency timer to 64
pcieport-driver 0000:00:17.2: irq 42 for MSI/MSI-X
pcieport-driver 0000:00:17.2: setting latency timer to 64
pcieport-driver 0000:00:17.3: irq 43 for MSI/MSI-X
pcieport-driver 0000:00:17.3: setting latency timer to 64
pcieport-driver 0000:00:17.4: irq 44 for MSI/MSI-X
pcieport-driver 0000:00:17.4: setting latency timer to 64
pcieport-driver 0000:00:17.5: irq 45 for MSI/MSI-X
pcieport-driver 0000:00:17.5: setting latency timer to 64
pcieport-driver 0000:00:17.6: irq 46 for MSI/MSI-X
pcieport-driver 0000:00:17.6: setting latency timer to 64
pcieport-driver 0000:00:17.7: irq 47 for MSI/MSI-X
pcieport-driver 0000:00:17.7: setting latency timer to 64
pcieport-driver 0000:00:18.0: irq 48 for MSI/MSI-X
pcieport-driver 0000:00:18.0: setting latency timer to 64
pcieport-driver 0000:00:18.1: irq 49 for MSI/MSI-X
pcieport-driver 0000:00:18.1: setting latency timer to 64
pcieport-driver 0000:00:18.2: irq 50 for MSI/MSI-X
pcieport-driver 0000:00:18.2: setting latency timer to 64
pcieport-driver 0000:00:18.3: irq 51 for MSI/MSI-X
pcieport-driver 0000:00:18.3: setting latency timer to 64
pcieport-driver 0000:00:18.4: irq 52 for MSI/MSI-X
pcieport-driver 0000:00:18.4: setting latency timer to 64
pcieport-driver 0000:00:18.5: irq 53 for MSI/MSI-X
pcieport-driver 0000:00:18.5: setting latency timer to 64
pcieport-driver 0000:00:18.6: irq 54 for MSI/MSI-X
pcieport-driver 0000:00:18.6: setting latency timer to 64
pcieport-driver 0000:00:18.7: irq 55 for MSI/MSI-X
pcieport-driver 0000:00:18.7: setting latency timer to 64
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
ACPI: AC Adapter [ACAD] (on-line)
input: Power Button as /class/input/input0
ACPI: Power Button [PWRF]
processor ACPI_CPU:00: registered as cooling_device0
ACPI: Processor [CP00] (supports 8 throttling states)
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:0a: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
brd: module loaded
loop: module loaded
Compaq SMART2 Driver (v 2.6.0)
HP CISS Driver (v 3.6.20)
input: Macintosh mouse button emulation as /class/input/input1
Uniform Multi-Platform E-IDE driver
piix 0000:00:07.1: IDE controller (0x8086:0x7111 rev 0x01)
piix 0000:00:07.1: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x10c0-0x10c7
    ide1: BM-DMA at 0x10c8-0x10cf
Probing IDE interface ide0...
hda: VMware Virtual IDE CDROM Drive, ATAPI CD/DVD-ROM drive
hdb: VMware Virtual IDE Hard Drive, ATA DISK drive
hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/33 mode selected
hdb: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hdb: UDMA/33 mode selected
Probing IDE interface ide1...
hdc: VMware Virtual IDE CDROM Drive, ATAPI CD/DVD-ROM drive
hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hdc: UDMA/33 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
ide_generic: please use "probe_mask=0x3f" module parameter for probing
all legacy ISA IDE ports
ide-gd driver 1.18
hdb: max request size: 128KiB
hdb: 209715200 sectors (107374 MB) w/32KiB Cache, CHS=65535/15/63
 hdb: hdb1 hdb2 < hdb5 hdb6 hdb7 hdb8 hdb9 >
ide-cd driver 5.00
ATAPI device hda:
  Error: Not ready -- (Sense key=0x02)
  (reserved error code) -- (asc=0x00, ascq=0x00)
  The failed "Mode Sense 10" packet command was:
  "5a 00 2a 00 00 00 00 00 18 00 00 00 98 be 44 df "
ATAPI device hda:
  Error: Not ready -- (Sense key=0x02)
  (reserved error code) -- (asc=0x00, ascq=0x00)
  The failed "Mode Sense 10" packet command was:
  "5a 00 2a 00 00 00 00 00 18 00 00 00 98 be 44 df "
ATAPI device hda:
  Error: Not ready -- (Sense key=0x02)
  (reserved error code) -- (asc=0x00, ascq=0x00)
  The failed "Mode Sense 10" packet command was:
  "5a 00 2a 00 00 00 00 00 18 00 00 00 98 be 44 df "
Uniform CD-ROM driver Revision: 3.20
ide-cd: hdc: ATAPI 48X DVD-ROM DVD-R/RAM CD-R/RW drive, 2048kB Cache
Loading iSCSI transport class v2.0-870.
iscsi: registered transport (tcp)
Loading Adaptec I2O RAID: Version 2.4 Build 5go
Detecting Adaptec I2O RAID controllers...
Adaptec aacraid driver 1.1-5[2461]-ms
aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
scsi: <fdomain> Detection failed (no card)
sym53c416.c: Version 1.0.0-ac
qlogicfas: no cards were found, please specify I/O address and IRQ
using iobase= and irq= options<6>QLogic Fibre Channel HBA Driver:
8.03.01-k1
iscsi: registered transport (qla4xxx)
QLogic iSCSI HBA Driver
Emulex LightPulse Fibre Channel SCSI driver 8.3.1
Copyright(c) 2004-2009 Emulex.  All rights reserved.
Failed initialization of WD-7000 SCSI card!
pci 0000:00:10.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
DC390: clustering now enabled by default. If you get problems load
       with "disable_clustering=1" and report to maintainers
megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
megasas: 00.00.04.01 Thu July 24 11:41:51 PST 2008
GDT-HA: Storage RAID Controller Driver. Version: 3.05
3ware Storage Controller device driver for Linux v1.26.02.002.
3ware 9000 Storage Controller device driver for Linux v2.26.02.012.
nsp32: loading...
ipr: IBM Power RAID SCSI Device Driver version: 2.4.2 (January 21, 2009)
RocketRAID 3xxx/4xxx Controller driver v1.3 (071203)
st: Version 20081215, fixed bufsize 32768, s/g segs 256
Driver 'st' needs updating - please use bus_type methods
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
Intel(R) PRO/1000 Network Driver - version 7.3.21-k3-NAPI
Copyright (c) 1999-2006 Intel Corporation.
Atheros(R) L2 Ethernet Driver - version 2.2.3
Copyright (c) 2007 Atheros Corporation.
jme: JMicron JMC2XX ethernet driver version 1.0.4
pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
pcnet32 0000:02:01.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
pcnet32: PCnet/PCI II 79C970A at 0x2000, 00:0c:29:59:fc:2c assigned IRQ 19.
eth0: registered as PCnet/PCI II 79C970A
pcnet32: 1 cards_found.
e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
I2O subsystem v1.325
i2o: max drivers = 8
I2O Configuration OSM v1.323
I2O Bus Adapter OSM v1.317
I2O Block Device OSM v1.325
I2O SCSI Peripheral OSM v1.316
I2O ProcFS OSM v1.316
Fusion MPT base driver 3.04.07
Copyright (c) 1999-2008 LSI Corporation
Fusion MPT SPI Host driver 3.04.07
mptbase: ioc0: Initiating bringup
ioc0: LSI53C1030 B0: Capabilities={Initiator}
scsi2 : ioc0: LSI53C1030 B0, FwRev=01032920h, Ports=1, MaxQ=128, IRQ=17
Fusion MPT FC Host driver 3.04.07
Fusion MPT SAS Host driver 3.04.07
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:02:03.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
ehci_hcd 0000:02:03.0: EHCI Host Controller
ehci_hcd 0000:02:03.0: new USB bus registered, assigned bus number 1
ehci_hcd 0000:02:03.0: cache line size of 32 is not supported
ehci_hcd 0000:02:03.0: irq 17, io mem 0xd8900000
ehci_hcd 0000:02:03.0: USB 2.0 started, EHCI 1.00
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
116x: driver isp116x-hcd, 03 Nov 2005
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:02:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:02:00.0: UHCI Host Controller
uhci_hcd 0000:02:00.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:02:00.0: irq 18, io base 0x000020c0
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
sl811: driver sl811-hcd, 19 May 2005
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usbcore: registered new interface driver ums-alauda
usbcore: registered new interface driver ums-datafab
usbcore: registered new interface driver ums-freecom
usbcore: registered new interface driver ums-isd200
usbcore: registered new interface driver ums-jumpshot
usbcore: registered new interface driver ums-karma
usbcore: registered new interface driver ums-sddr09
usbcore: registered new interface driver ums-sddr55
usbcore: registered new interface driver ums-usbat
PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:MOUS] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
md: linear personality registered for level -1
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
md: raid10 personality registered for level 10
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
md: multipath personality registered for level -4
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
Using IPI No-Shortcut mode
Freeing unused kernel memory: 432k freed
input: AT Translated Set 2 keyboard as /class/input/input2
fuse init (API version 7.11)
usb 1-1: new high speed USB device using ehci_hcd and address 2
usb 1-1: config 1 interface 0 altsetting 0 bulk endpoint 0x81 has
invalid maxpacket 64
usb 1-1: config 1 interface 0 altsetting 0 bulk endpoint 0x1 has
invalid maxpacket 64
usb 1-1: configuration #1 chosen from 1 choice
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with writeback data mode.
udevd version 124 started
Linux agpgart interface v0.103
agpgart-intel 0000:00:00.0: Intel 440BX Chipset
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0x0
piix4_smbus 0000:00:07.3: Host SMBus controller not enabled!
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, 114 bytes nvram
parport_pc 00:08: reported by Plug and Play ACPI
parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
cfg80211: Using static regulatory domain info
cfg80211: Regulatory domain: US
        (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
        (2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
        (5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
        (5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
        (5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
        (5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
        (5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
cfg80211: Calling CRDA for country: US
phy0 -> rt2500usb_init_eeprom: Error - Invalid RT chipset detected.
phy0 -> rt2x00lib_probe_dev: Error - Failed to allocate device.
usbcore: registered new interface driver rt2500usb
ENS1371 0000:02:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
input: ImPS/2 Generic Wheel Mouse as /class/input/input3
phy1: Selected rate control algorithm 'minstrel'
Registered led device: rt73usb-phy1::radio
Registered led device: rt73usb-phy1::assoc
Registered led device: rt73usb-phy1::quality
usbcore: registered new interface driver rt73usb
cfg80211: Regulatory domain changed to country: US
        (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
        (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
        (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
        (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
        (5490000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
        (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
lp0: using parport0 (interrupt-driven).
lp0: console ready
EXT3 FS on hdb5, internal journal
ip_tables: (C) 2000-2006 Netfilter Core Team
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hdb9, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hdb6, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
rt73usb 1-1:1.0: firmware: requesting rt73.bin
eth0: link up
eth0: link up
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ADDRCONF(NETDEV_UP): wlan0: link is not ready
eth0: no IPv6 routers present
ISO 9660 Extensions: Microsoft Joliet Level 3
ISO 9660 Extensions: RRIP_1991A
squashfs: version 4.0 (2009/01/31) Phillip Lougher
eth0: link up
eth0: no IPv6 routers present
Bluetooth: Core ver 2.15
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP ver 2.14
Bluetooth: L2CAP socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM ver 1.11
usbcore: deregistering interface driver rt2500usb
usbcore: deregistering interface driver rt73usb
NET: Unregistered protocol family 31
Bluetooth: Core ver 2.15
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP ver 2.14
Bluetooth: L2CAP socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM ver 1.11
NET: Unregistered protocol family 31
Generic kernel compatibility enabled based on linux-next next-20100113
cfg80211: Calling CRDA to update world regulatory domain
lib80211: common routines for IEEE802.11 drivers
lib80211_crypt: registered algorithm 'NULL'
libipw: 802.11 data/management/control stack, git-1.1.13
libipw: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
ipw2100: Intel(R) PRO/Wireless 2100 Network Driver, git-1.2.2
ipw2100: Copyright(c) 2003-2006 Intel Corporation
ipw2200: Intel(R) PRO/Wireless 2200/2915 Network Driver, 1.2.2kmprq
ipw2200: Copyright(c) 2003-2006 Intel Corporation
cfg80211: World regulatory domain updated:
    (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
    (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
    (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
    (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
    (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
    (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
usbcore: registered new interface driver usb8xxx
usbcore: registered new interface driver p54usb
usbcore: registered new interface driver zd1211rw
usbcore: registered new interface driver rtl8187
iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver
for Linux, in-tree:ds
iwl3945: Copyright(c) 2003-2010 Intel Corporation
iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:d
iwlagn: Copyright(c) 2003-2010 Intel Corporation
usbcore: registered new interface driver ar9170usb
phy0 -> rt2500usb_init_eeprom: Error - Invalid RT chipset detected.
phy0 -> rt2x00lib_probe_dev: Error - Failed to allocate device.
usbcore: registered new interface driver rt2500usb
phy1: Selected rate control algorithm 'minstrel'
Registered led device: rt73usb-phy1::radio
Registered led device: rt73usb-phy1::assoc
Registered led device: rt73usb-phy1::quality
usbcore: registered new interface driver rt73usb
usbcore: registered new interface driver cdc_ether
usbcore: registered new interface driver rndis_host
usbcore: registered new interface driver rndis_wlan
mac80211_hwsim: Initializing radio 0
phy2: Selected rate control algorithm 'minstrel'
phy2: hwaddr 02:00:00:00:00:00 registered
mac80211_hwsim: Initializing radio 1
phy3: Selected rate control algorithm 'minstrel'
phy3: hwaddr 02:00:00:00:01:00 registered
Atmel at76x USB Wireless LAN Driver 0.17 loading
usbcore: registered new interface driver at76c50x-usb
Bluetooth: Core ver 2.15
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: Generic Bluetooth USB driver ver 0.6
usbcore: registered new interface driver btusb
Bluetooth: L2CAP ver 2.14
Bluetooth: L2CAP socket layer initialized
Bluetooth: SCO (Voice Link) ver 0.6
Bluetooth: SCO socket layer initialized
Bluetooth: HIDP (Human Interface Emulation) ver 1.2
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM ver 1.11
Bluetooth: BNEP (Ethernet Emulation) ver 1.3
Bluetooth: BNEP filters: protocol multicast
b43: Unknown symbol ssb_pmu_set_ldo_paref
b43: Unknown symbol ssb_pmu_set_ldo_voltage
b43: Unknown symbol ssb_chipco_gpio_control
b43: Unknown symbol ssb_bus_sdiobus_register
b43: Unknown symbol ssb_bus_pcmciabus_register
Broadcom 43xx-legacy driver loaded [ Features: PLID, Firmware-ID: FW10 ]
Bridge firewalling registered
b43: Unknown symbol ssb_pmu_set_ldo_paref
b43: Unknown symbol ssb_pmu_set_ldo_voltage
b43: Unknown symbol ssb_chipco_gpio_control
b43: Unknown symbol ssb_bus_sdiobus_register
b43: Unknown symbol ssb_bus_pcmciabus_register
root@bt:/media/disk/build/compat-wireless-2010-04-23#

2010/4/23, Gábor Stefanik <netrolller.3d@gmail.com>:
> On Fri, Apr 23, 2010 at 2:20 AM, SECO <secowu@gmail.com> wrote:
>> & this is the full log
>>
>>
>> ./scripts/gen-compat-autoconf.sh config.mk >
>> include/linux/compat_autoconf.h
>> make -C /lib/modules/2.6.30.9/build M=/root/compat-wireless-2.6.34-rc4
>> modules
>> make[1]: Entering directory `/usr/src/linux-source-2.6.30.9'
>>
>>  WARNING: Symbol version dump
>> /usr/src/linux-source-2.6.30.9/Module.symvers
>>           is missing; modules will have no dependencies and modversions.
>>
>>  CC [M]  /root/compat-wireless-2.6.34-rc4/compat/main.o
>> ....
>>  CC [M]
>>  /root/compat-wireless-2.6.34-rc4/drivers/net/wireless/mac80211_hwsim.o
>> /root/compat-wireless-2.6.34-rc4/drivers/net/wireless/mac80211_hwsim.c: In
>> funct
>> ion ‘__check_fake_hw_scan’:
>> /root/compat-wireless-2.6.34-rc4/drivers/net/wireless/mac80211_hwsim.c:37:
>> warni
>> ng: return from incompatible pointer type
>> ...
>> /root/compat-wireless-2.6.34-rc4/drivers/net/wireless/b43/main.c: In
>> function ‘b43_request_firmware’:
>> /root/compat-wireless-2.6.34-rc4/drivers/net/wireless/b43/main.c:2271:
>> warning: format not a string literal and no format
>>  arguments
>> ...
>> /root/compat-wireless-2.6.34-rc4/drivers/net/wireless/b43/phy_n.c:442:
>> warning: ‘b43_nphy_rx_cal_phy_cleanup’ defined but
>>  not used
>> /root/compat-wireless-2.6.34-rc4/drivers/net/wireless/b43/phy_n.c:465:
>> warning: ‘b43_nphy_rx_cal_phy_setup’ defined but n
>> ot used
>> /root/compat-wireless-2.6.34-rc4/drivers/net/wireless/b43/phy_n.c:1462:
>> warning: ‘b43_nphy_bphy_init’ defined but not use
>> d
>> /root/compat-wireless-2.6.34-rc4/drivers/net/wireless/b43/phy_n.c: In
>> function ‘b43_nphy_spur_workaround’:
>> /root/compat-wireless-2.6.34-rc4/drivers/net/wireless/b43/phy_n.c:739:
>> warning: ‘channel’ may be used uninitialized in th
>> is function
>> /root/compat-wireless-2.6.34-rc4/drivers/net/wireless/b43/phy_n.c: In
>> function ‘b43_nphy_cal_tx_iq_lo’:
>> /root/compat-wireless-2.6.34-rc4/drivers/net/wireless/b43/phy_n.c:2519:
>> warning: ‘last’ may be used uninitialized in this
>>  function
>> /root/compat-wireless-2.6.34-rc4/drivers/net/wireless/b43/phy_n.c: In
>> function ‘b43_nphy_rev2_cal_rx_iq’:
>> /root/compat-wireless-2.6.34-rc4/drivers/net/wireless/b43/phy_n.c:2774:
>> warning: ‘cur_hpf2’ may be used uninitialized in
>> this function
>> /root/compat-wireless-2.6.34-rc4/drivers/net/wireless/b43/phy_n.c:2774:
>> warning: ‘cur_hpf1’ may be used uninitialized in
>> this function
>> ...
>> /root/compat-wireless-2.6.34-rc4/drivers/net/wireless/ipw2x00/libipw_wx.c:
>> In function ‘libipw_wx_set_encodeext’:
>> /root/compat-wireless-2.6.34-rc4/drivers/net/wireless/ipw2x00/libipw_wx.c:623:
>> warning: format not a string literal and n
>> o format arguments
>>  CC [M]
>>  /root/compat-wireless-2.6.34-rc4/drivers/net/wireless/ipw2x00/libipw_geo.o
>>  ...
>>  CC [M]
>>  /root/compat-wireless-2.6.34-rc4/drivers/net/wireless/iwlwifi/iwl-5000.o
>> /root/compat-wireless-2.6.34-rc4/drivers/net/wireless/iwlwifi/iwl-5000.c:
>> In function ‘iwl5000_gain_computation’:
>> /root/compat-wireless-2.6.34-rc4/drivers/net/wireless/iwlwifi/iwl-5000.c:189:
>> warning: comparison of distinct pointer typ
>> es lacks a cast
>>  CC [M]
>>  /root/compat-wireless-2.6.34-rc4/drivers/net/wireless/iwlwifi/iwl-6000.o
>>  CC [M]
>>  /root/compat-wireless-2.6.34-rc4/drivers/net/wireless/iwlwifi/iwl-1000.o
>>  CC [M]
>>  /root/compat-wireless-2.6.34-rc4/drivers/net/wireless/iwlwifi/iwl-core.o
>> /root/compat-wireless-2.6.34-rc4/drivers/net/wireless/iwlwifi/iwl-core.c:
>> In function ‘__check_bt_coex_active’:
>> /root/compat-wireless-2.6.34-rc4/drivers/net/wireless/iwlwifi/iwl-core.c:68:
>> warning: return from incompatible pointer ty
>> pe
>>  CC [M]
>>  /root/compat-wireless-2.6.34-rc4/drivers/net/wireless/iwlwifi/iwl-eeprom.o
>>  CC [M]
>>  /root/compat-wireless-2.6.34-rc4/drivers/net/wireless/iwlwifi/iwl-hcmd.o
>>  CC [M]
>>  /root/compat-wireless-2.6.34-rc4/drivers/net/wireless/iwlwifi/iwl-power.o
>> /root/compat-wireless-2.6.34-rc4/drivers/net/wireless/iwlwifi/iwl-power.c:
>> In function ‘__check_no_sleep_autoadjust’:
>> /root/compat-wireless-2.6.34-rc4/drivers/net/wireless/iwlwifi/iwl-power.c:58:
>> warning: return from incompatible pointer t
>> ype
>> ...
>>  CC [M]  /root/compat-wireless-2.6.34-rc4/net/bluetooth/hidp/core.o
>> /root/compat-wireless-2.6.34-rc4/net/bluetooth/hidp/core.c: In
>> function ‘hidp_setup_hid’:
>> /root/compat-wireless-2.6.34-rc4/net/bluetooth/hidp/core.c:872:
>> warning: assignment from incompatible pointer type
>>  CC [M]  /root/compat-wireless-2.6.34-rc4/net/bluetooth/hidp/sock.o
>> ...
>>  CC [M]  /root/compat-wireless-2.6.34-rc4/net/mac80211/main.o
>> /root/compat-wireless-2.6.34-rc4/net/mac80211/main.c: In function
>> ‘__check_ieee80211_disable_40mhz_24ghz’:
>> /root/compat-wireless-2.6.34-rc4/net/mac80211/main.c:39: warning:
>> return from incompatible pointer type
>>  CC [M]  /root/compat-wireless-2.6.34-rc4/net/mac80211/status.o
>>
>> sudo make install
>> ...
>> make -C /lib/modules/2.6.30.9/build M=/root/compat-wireless-2.6.34-rc4
>> modules
>> make[1]: Entering directory `/usr/src/linux-source-2.6.30.9'
>>
>>  WARNING: Symbol version dump
>> /usr/src/linux-source-2.6.30.9/Module.symvers
>>           is missing; modules will have no dependencies and modversions.
>>
>> .......
>>  INSTALL
>> /root/compat-wireless-2.6.34-rc4/net/wireless/lib80211_crypt_wep.ko
>>  DEPMOD  2.6.30.9
>> make[1]: Leaving directory `/usr/src/linux-source-2.6.30.9'
>> Updating Ubuntu's initramfs for 2.6.31-wl under /boot/ ...
>> Cannot find /lib/modules/2.6.31-wl
>> Will now run update-grub to ensure grub will find the new initramfs ...
>> Searching for GRUB installation directory ... found: /boot/grub
>> Searching for default file ... found: /boot/grub/default
>> Testing for an existing GRUB menu.lst file ... found: /boot/grub/menu.lst
>> Searching for splash image ... found: /boot/grub/splash.xpm.gz
>> Found kernel: /boot/vmlinuz-2.6.30.9
>> Found kernel: /boot/memtest86+.bin
>> Updating /boot/grub/menu.lst ... done
>>
>> depmod will prefer updates/ over kernel/ -- OK!
>>
>> Currently detected wireless subsystem modules:
>>
>> /lib/modules/2.6.30.9/updates/net/mac80211/mac80211.ko
>> /lib/modules/2.6.30.9/updates/net/wireless/cfg80211.ko
>> /lib/modules/2.6.30.9/updates/net/wireless/lib80211.ko
>> /lib/modules/2.6.30.9/updates/drivers/net/wireless/adm8211.ko
>> /lib/modules/2.6.30.9/updates/drivers/net/wireless/ath/ar9170/ar9170usb.ko
>> /lib/modules/2.6.30.9/updates/drivers/net/wireless/at76c50x-usb.ko
>> /lib/modules/2.6.30.9/updates/drivers/net/wireless/ath/ath.ko
>> /lib/modules/2.6.30.9/updates/drivers/net/wireless/ath/ath5k/ath5k.ko
>> /lib/modules/2.6.30.9/updates/drivers/net/wireless/ath/ath9k/ath9k.ko
>> /lib/modules/2.6.30.9/updates/drivers/net/wireless/b43/b43.ko
>> /lib/modules/2.6.30.9/updates/drivers/net/wireless/b43legacy/b43legacy.ko
>> /lib/modules/2.6.30.9/updates/drivers/net/usb/cdc_ether.ko
>> /lib/modules/2.6.30.9/updates/drivers/misc/eeprom/eeprom_93cx6.ko
>> /lib/modules/2.6.30.9/updates/drivers/net/wireless/ipw2x00/ipw2100.ko
>> /lib/modules/2.6.30.9/updates/drivers/net/wireless/ipw2x00/ipw2200.ko
>> /lib/modules/2.6.30.9/updates/drivers/net/wireless/iwlwifi/iwl3945.ko
>> /lib/modules/2.6.30.9/updates/drivers/net/wireless/iwlwifi/iwlagn.ko
>> /lib/modules/2.6.30.9/updates/drivers/net/wireless/iwlwifi/iwlcore.ko
>> /lib/modules/2.6.30.9/updates/net/wireless/lib80211_crypt_ccmp.ko
>> /lib/modules/2.6.30.9/updates/net/wireless/lib80211_crypt_tkip.ko
>> /lib/modules/2.6.30.9/updates/net/wireless/lib80211_crypt_wep.ko
>> /lib/modules/2.6.30.9/updates/drivers/net/wireless/libertas/libertas.ko
>> /lib/modules/2.6.30.9/updates/drivers/net/wireless/libertas/libertas_cs.ko
>> /lib/modules/2.6.30.9/updates/drivers/net/wireless/libertas/libertas_sdio.ko
>> /lib/modules/2.6.30.9/updates/drivers/net/wireless/libertas_tf/libertas_tf.ko
>> /lib/modules/2.6.30.9/updates/drivers/net/wireless/libertas_tf/libertas_tf_usb.ko
>> /lib/modules/2.6.30.9/updates/drivers/net/wireless/ipw2x00/libipw.ko
>> /lib/modules/2.6.30.9/updates/drivers/net/wireless/mac80211_hwsim.ko
>> /lib/modules/2.6.30.9/updates/drivers/net/wireless/mwl8k.ko
>> /lib/modules/2.6.30.9/updates/drivers/net/wireless/p54/p54common.ko
>> /lib/modules/2.6.30.9/updates/drivers/net/wireless/p54/p54pci.ko
>> /lib/modules/2.6.30.9/updates/drivers/net/wireless/p54/p54usb.ko
>> /lib/modules/2.6.30.9/updates/drivers/net/usb/rndis_host.ko
>> /lib/modules/2.6.30.9/updates/drivers/net/wireless/rndis_wlan.ko
>> /lib/modules/2.6.30.9/updates/drivers/net/wireless/rt2x00/rt2400pci.ko
>> /lib/modules/2.6.30.9/updates/drivers/net/wireless/rt2x00/rt2500pci.ko
>> /lib/modules/2.6.30.9/updates/drivers/net/wireless/rt2x00/rt2500usb.ko
>> /lib/modules/2.6.30.9/updates/drivers/net/wireless/rt2x00/rt2x00lib.ko
>> /lib/modules/2.6.30.9/updates/drivers/net/wireless/rt2x00/rt2x00pci.ko
>> /lib/modules/2.6.30.9/updates/drivers/net/wireless/rt2x00/rt2x00usb.ko
>> /lib/modules/2.6.30.9/updates/drivers/net/wireless/rt2x00/rt61pci.ko
>> /lib/modules/2.6.30.9/updates/drivers/net/wireless/rt2x00/rt73usb.ko
>> /lib/modules/2.6.30.9/updates/drivers/net/wireless/rtl818x/rtl8180.ko
>> /lib/modules/2.6.30.9/updates/drivers/net/wireless/rtl818x/rtl8187.ko
>> /lib/modules/2.6.30.9/updates/drivers/net/wireless/libertas/usb8xxx.ko
>> /lib/modules/2.6.30.9/updates/drivers/net/usb/usbnet.ko
>> /lib/modules/2.6.30.9/updates/drivers/net/wireless/zd1211rw/zd1211rw.ko
>>
>> Currently detected bluetooth subsystem modules:
>>
>> /lib/modules/2.6.30.9/updates/net/bluetooth/sco.ko
>> /lib/modules/2.6.30.9/updates/net/bluetooth/l2cap.ko
>> /lib/modules/2.6.30.9/updates/net/bluetooth/hidp/hidp.ko
>> /lib/modules/2.6.30.9/updates/net/bluetooth/rfcomm/rfcomm.ko
>> /lib/modules/2.6.30.9/updates/net/bluetooth/bnep/bnep.ko
>> /lib/modules/2.6.30.9/updates/drivers/bluetooth/btusb.ko
>> /lib/modules/2.6.30.9/updates/net/bluetooth/bluetooth.ko
>>
>> Now run:
>>
>> sudo make unload to unload both wireless and bluetooth modules
>> sudo make wlunload to unload wireless modules
>> sudo make btunload to unload bluetooth modules
>>
>> And then load the wireless or bluetooth module you need. If unsure reboot.
>> Alternatively use sudo make load/wlload/btload to load modules
>>
>> root@bt:~/compat-wireless-2.6.34-rc4#
>> root@bt:~/compat-wireless-2.6.34-rc4# sudo make unload
>> Stoping bluetooth service..
>> Stopping bluetooth: bluetoothd.
>> * bluetooth is not running.
>> Unloading ar9170usb...
>> Unloading rfcomm...
>> Unloading btusb...
>> root@bt:~/compat-wireless-2.6.34-rc4# sudo make wlunload
>> root@bt:~/compat-wireless-2.6.34-rc4# sudo make btunload
>> Stoping bluetooth service..
>> Stopping bluetooth: bluetoothd.
>> * bluetooth is not running.
>> Unloading rfcomm...
>> root@bt:~/compat-wireless-2.6.34-rc4#
>> root@bt:~/compat-wireless-2.6.34-rc4# sudo make load
>> Stoping bluetooth service..
>> Stopping bluetooth: bluetoothd.
>> * bluetooth is not running.
>> Unloading rfcomm...
>> Loading ipw2100...
>> Loading ipw2200...
>> Loading libertas_cs...
>> Loading usb8xxx...
>> Loading p54pci...
>> Loading p54usb...
>> Loading adm8211...
>> Loading zd1211rw...
>> Loading rtl8180...
>> Loading rtl8187...
>> Loading p54pci...
>> Loading p54usb...
>> Loading iwl3945...
>> Loading iwlagn...
>> Loading ath...
>> Loading ar9170usb...
>> Loading rtl8180...
>> Loading rtl8187...
>> Loading rt2400pci...
>> Loading rt2500pci...
>> Loading rt61pci...
>> Loading rt2500usb...
>> Loading rt73usb...
>> Loading rndis_wlan...
>> Loading at76_usb...
>> FATAL: Module at76_usb not found.
>> Loading mwl8k...
>> Loading mac80211_hwsim...
>> Loading at76c50x_usb...
>> Loading bluetooth...
>> Loading btusb...
>> Loading l2cap...
>> Loading sco...
>> Loading hidp...
>> Loading rfcomm...
>> Loading bnep...
>> Module ath_pci not detected -- this is fine
>> ath5k loaded successfully
>> ath9k loaded successfully
>> Module bcm43xx not detected -- this is fine
>> Module wl not detected -- this is fine
>> FATAL: Error inserting b43
>> (/lib/modules/2.6.30.9/updates/drivers/net/wireless/b43/b43.ko):
>> Unknown symbol in module, or unknown parameter (see dmesg)
>> b43 loaded successfully
>> b43legacy loaded successfully
>> Starting bluetooth service..
>> Starting bluetooth: bluetoothd.
>> bluetooth is running.
>>
>>
>> 2010/4/23, SECO <secowu@gmail.com>:
>>> Hi,Sir.
>>>
>>>    I use BT4,after Updated drivers, the original adpter bcm4311 can not
>>> be
>>> work.
>>> Not mention WN721 and WN821N .
>>> & log here
>>>
>>> root@bt:~# ln -s /usr/src/linux /lib/modules/2.6.30.9/build
>>> root@bt:~# wget
>>> http://wireless.kernel.org/download/compat-wireless-2.6/compat-wireless-2010-04-21.tar.bz2
>>> --2010-04-22 21:21:31--
>>> http://wireless.kernel.org/download/compat-wireless-2.6/compat-wireless-2010-04-21.tar.bz2
>>> Resolving wireless.kernel.org... 78.46.109.217
>>> Connecting to wireless.kernel.org|78.46.109.217|:80... connected.
>>> HTTP request sent, awaiting response... 200 OK
>>> Length: 2424098 (2.3M) [application/octet-stream]
>>> Saving to: `compat-wireless-2010-04-21.tar.bz2'
>>>
>>> 100%[==================================================================================================================>]
>>> 2,424,098   44.0K/s   in 56s
>>>
>>> 2010-04-22 21:22:29 (42.1 KB/s) - `compat-wireless-2010-04-21.tar.bz2'
>>> saved [2424098/2424098]
>>>
>>> root@bt:~# tar -xf compat-wireless-2010-04-21.tar.bz2
>>> root@bt:~# cd compat-wireless-2010-04-21.tar.bz22.make & make install
>>>
>>> Code:
>>> oot@bt:~/compat-wireless-2010-04-21# sudo make && sudo make install
>>> make -C /lib/modules/2.6.30.9/build M=/root/compat-wireless-2010-04-21
>>> modules
>>> make[1]: Entering directory `/usr/src/linux-source-2.6.30.9'
>>> ....
>>> CC [M]  /root/compat-wireless-2010-04-21/drivers/net/wireless/b43/main.o
>>> /root/compat-wireless-2010-04-21/drivers/net/wireless/b43/main.c: In
>>> function ‘b43_request_firmware’:
>>> /root/compat-wireless-2010-04-21/drivers/net/wireless/b43/main.c:2271:
>>> warning: format not a string literal and no format arguments
>>> ....
>>> root/compat-wireless-2010-04-21/drivers/net/wireless/b43/phy_n.c:465:
>>> warning: ‘b43_nphy_rx_cal_phy_cleanup’ defined but not used
>>> /root/compat-wireless-2010-04-21/drivers/net/wireless/b43/phy_n.c:488:
>>> warning: ‘b43_nphy_rx_cal_phy_setup’ defined but not used
>>> /root/compat-wireless-2010-04-21/drivers/net/wireless/b43/phy_n.c:1574:
>>> warning: ‘b43_nphy_bphy_init’ defined but not used
>>> /root/compat-wireless-2010-04-21/drivers/net/wireless/b43/phy_n.c: In
>>> function ‘b43_nphy_set_chanspec’:
>>> /root/compat-wireless-2010-04-21/drivers/net/wireless/b43/phy_n.c:3376:
>>> warning: ‘tabent_r3’ may be used uninitialized in this function
>>> /root/compat-wireless-2010-04-21/drivers/net/wireless/b43/phy_n.c: In
>>> function ‘b43_nphy_cal_tx_iq_lo’:
>>> /root/compat-wireless-2010-04-21/drivers/net/wireless/b43/phy_n.c:2631:
>>> warning: ‘last’ may be used uninitialized in this function
>>> /root/compat-wireless-2010-04-21/drivers/net/wireless/b43/phy_n.c: In
>>> function ‘b43_nphy_rev2_cal_rx_iq’:
>>> /root/compat-wireless-2010-04-21/drivers/net/wireless/b43/phy_n.c:2886:
>>> warning: ‘cur_hpf2’ may be used uninitialized in this function
>>> /root/compat-wireless-2010-04-21/drivers/net/wireless/b43/phy_n.c:2886:
>>> warning: ‘cur_hpf1’ may be used uninitialized in this function
>>> ...
>>> /root/compat-wireless-2010-04-21/drivers/net/wireless/b43/xmit.c: In
>>> function ‘b43_rx’:
>>> /root/compat-wireless-2010-04-21/drivers/net/wireless/b43/xmit.c:613:
>>> warning: ‘noise’ is deprecated (declared at
>>> /root/compat-wireless-2010-04-21/include/net/mac80211.h:564)
>>> ...
>>> /root/compat-wireless-2010-04-21/drivers/net/wireless/b43legacy/xmit.c:
>>> In function ‘b43legacy_rx’:
>>> /root/compat-wireless-2010-04-21/drivers/net/wireless/b43legacy/xmit.c:551:
>>> warning: ‘noise’ is deprecated (declared at
>>> /root/compat-wireless-2010-04-21/include/net/mac80211.h:564)
>>> ...
>>> /root/compat-wireless-2010-04-21/drivers/net/wireless/ipw2x00/libipw_wx.c:
>>> In function ‘libipw_wx_set_encodeext’:
>>> /root/compat-wireless-2010-04-21/drivers/net/wireless/ipw2x00/libipw_wx.c:623:
>>> warning: format not a string literal and no format arguments
>>> ...
>>> /root/compat-wireless-2010-04-21/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c:
>>> In function ‘iwlagn_gain_computation’:
>>> /root/compat-wireless-2010-04-21/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c:145:
>>> warning: comparison of distinct pointer types lacks a cast
>>> ...
>>> root/compat-wireless-2010-04-21/drivers/net/wireless/iwlwifi/iwl-core.c:
>>> In function ‘__check_bt_coex_active’:
>>> /root/compat-wireless-2010-04-21/drivers/net/wireless/iwlwifi/iwl-core.c:68:
>>> warning: return from incompatible pointer type
>>>   CC [M]
>>> /root/compat-wireless-2010-04-21/drivers/net/wireless/iwlwifi/iwl-eeprom.o
>>>   CC [M]
>>> /root/compat-wireless-2010-04-21/drivers/net/wireless/iwlwifi/iwl-hcmd.o
>>>   CC [M]
>>> /root/compat-wireless-2010-04-21/drivers/net/wireless/iwlwifi/iwl-power.o
>>> /root/compat-wireless-2010-04-21/drivers/net/wireless/iwlwifi/iwl-power.c:
>>> In function ‘__check_no_sleep_autoadjust’:
>>> /root/compat-wireless-2010-04-21/drivers/net/wireless/iwlwifi/iwl-power.c:58:
>>> warning: return from incompatible pointer type
>>> ....
>>> root/compat-wireless-2010-04-21/drivers/net/wireless/libertas/if_sdio.c:
>>> In function ‘if_sdio_probe’:
>>> /root/compat-wireless-2010-04-21/drivers/net/wireless/libertas/if_sdio.c:948:
>>> warning: unused variable ‘host’
>>>   CC [M]
>>> /root/compat-wireless-2010-04-21/drivers/net/wireless/libertas/if_usb.o
>>>   LD [M]
>>> /root/compat-wireless-2010-04-21/drivers/net/wireless/libertas/libertas.o
>>>   LD [M]
>>> /root/compat-wireless-2010-04-21/drivers/net/wireless/libertas/usb8xxx.o
>>>   LD [M]
>>> /root/compat-wireless-2010-04-21/drivers/net/wireless/libertas/libertas_cs.o
>>>   LD [M]
>>> /root/compat-wireless-2010-04-21/drivers/net/wireless/libertas/libertas_sdio.o
>>>   CC [M]
>>> /root/compat-wireless-2010-04-21/drivers/net/wireless/libertas_tf/main.o
>>> /root/compat-wireless-2010-04-21/drivers/net/wireless/libertas_tf/main.c:
>>> In function ‘lbtf_rx’:
>>> /root/compat-wireless-2010-04-21/drivers/net/wireless/libertas_tf/main.c:513:
>>> warning: ‘noise’ is deprecated (declared at
>>> /root/compat-wireless-2010-04-21/include/net/mac80211.h:564)
>>>   CC [M]  /root/compat-wireless-2010-
>>> ...
>>> root/compat-wireless-2010-04-21/drivers/net/wireless/p54/txrx.c: In
>>> function ‘p54_rx_data’:
>>> /root/compat-wireless-2010-04-21/drivers/net/wireless/p54/txrx.c:353:
>>> warning: ‘noise’ is deprecated (declared at
>>> /root/compat-wireless-2010-04-21/include/net/mac80211.h:564)
>>> ...
>>> /root/compat-wireless-2010-04-21/drivers/net/wireless/rt2x00/rt2x00dev.c:
>>> In function ‘rt2x00lib_rxdone’:
>>> /root/compat-wireless-2010-04-21/drivers/net/wireless/rt2x00/rt2x00dev.c:438:
>>> warning: ‘noise’ is deprecated (declared at
>>> /root/compat-wireless-2010-04-21/include/net/mac80211.h:564)
>>> ...
>>> /root/compat-wireless-2010-04-21/drivers/net/wireless/wl12xx/wl1251_rx.c:
>>> In function ‘wl1251_rx_status’:
>>> /root/compat-wireless-2010-04-21/drivers/net/wireless/wl12xx/wl1251_rx.c:81:
>>> warning: ‘noise’ is deprecated (declared at
>>> /root/compat-wireless-2010-04-21/include/net/mac80211.h:564)
>>> ...
>>> root/compat-wireless-2010-04-21/net/bluetooth/hidp/core.c: In function
>>> ‘hidp_setup_hid’:
>>> /root/compat-wireless-2010-04-21/net/bluetooth/hidp/core.c:872:
>>> warning: assignment from incompatible pointer type
>>> ....
>>> /root/compat-wireless-2010-04-21/net/mac80211/main.c: In function
>>> ‘__check_ieee80211_disable_40mhz_24ghz’:
>>> /root/compat-wireless-2010-04-21/net/mac80211/main.c:37: warning:
>>> return from incompatible pointer type
>>> ...& download ar9271.fw form herer
>>> '[PATCH 0/3] ath9k: add initial ar9271 support' - MARC
>>>
>>> Code:
>>>
>>> root@bt:~/compat-wireless-2010-04-21# make load
>>> Stoping bluetooth service..
>>> Stopping bluetooth: bluetoothd.
>>> * bluetooth is not running.
>>> Unloading b43...
>>> Unloading ar9170usb...
>>> Unloading lib80211...
>>> FATAL: Module lib80211 is in use.
>>> Unloading btusb...
>>> Loading ipw2100...
>>> Loading ipw2200...
>>> Loading libertas_cs...
>>> Loading usb8xxx...
>>> Loading p54pci...
>>> Loading p54usb...
>>> Loading adm8211...
>>> Loading zd1211rw...
>>> Loading rtl8180...
>>> Loading rtl8187...
>>> Loading p54pci...
>>> Loading p54usb...
>>> Loading iwl3945...
>>> Loading iwlagn...
>>> Loading ath...
>>> Loading ar9170usb...
>>> Loading rtl8180...
>>> Loading rtl8187...
>>> Loading rt2400pci...
>>> Loading rt2500pci...
>>> Loading rt61pci...
>>> Loading rt2500usb...
>>> Loading rt73usb...
>>> Loading rndis_wlan...
>>> Loading at76_usb...
>>> FATAL: Module at76_usb not found.
>>> Loading mwl8k...
>>> Loading mac80211_hwsim...
>>> Loading at76c50x_usb...
>>> Loading bluetooth...
>>> Loading btusb...
>>> Loading l2cap...
>>> Loading sco...
>>> Loading hidp...
>>> Loading rfcomm...
>>> Loading bnep...
>>> Module ath_pci not detected -- this is fine
>>> ath5k loaded successfully
>>> ath9k loaded successfully
>>> Module bcm43xx not detected -- this is fine
>>> Disabling wl ...        [OK]    Module disabled:
>>> /lib/modules/2.6.30.9/kernel/net/wireless/wl.ko
>>> FATAL: Error inserting b43
>>> (/lib/modules/2.6.30.9/updates/drivers/net/wireless/b43/b43.ko):
>>> Unknown symbol in module, or unknown parameter (see dmesg)
>>> b43 loaded successfully
>>> b43legacy loaded successfully
>>> Starting bluetooth service..
>>> Starting bluetooth: bluetoothd.
>>> bluetooth is running.
>>> root@bt:~/compat-wireless-2010-04-21# ifconfig
>>> eth0      Link encap:Ethernet  HWaddr 00:2a:4b:18:68:99
>>>           UP BROADCAST MULTICAST  MTU:1500  Metric:1
>>>           RX packets:0 errors:0 dropped:0 overruns:0 frame:0
>>>           TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
>>>           collisions:0 txqueuelen:1000
>>>           RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
>>>           Interrupt:16
>>>
>>> lo        Link encap:Local Loopback
>>>           inet addr:127.0.0.1  Mask:255.0.0.0
>>>           inet6 addr: ::1/128 Scope:Host
>>>           UP LOOPBACK RUNNING  MTU:16436  Metric:1
>>>           RX packets:218 errors:0 dropped:0 overruns:0 frame:0
>>>           TX packets:218 errors:0 dropped:0 overruns:0 carrier:0
>>>           collisions:0 txqueuelen:0
>>>           RX bytes:10928 (10.9 KB)  TX bytes:10928 (10.9 KB)
>>>
>>> wlan0     Link encap:Ethernet  HWaddr 02:01:20:00:60:00
>>>           UP BROADCAST MULTICAST  MTU:1500  Metric:1
>>>           RX packets:0 errors:0 dropped:0 overruns:0 frame:0
>>>           TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
>>>           collisions:0 txqueuelen:1000
>>>           RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
>>>
>>> root@bt:~/compat-wireless-2010-04-21# iwconfig
>>> lo        no wireless extensions.
>>>
>>> eth0      no wireless extensions.
>>>
>>> wlan0     IEEE 802.11abgn  Mode:Managed  Access Point: Not-Associated
>>>           Tx-Power=20 dBm
>>>           Retry  long limit:7   RTS thr:off   Fragment thr:off
>>>           Encryption key:off
>>>           Power Management:off
>>>
>>> wlan1     IEEE 802.11abgn  Mode:Managed  Access Point: Not-Associated
>>>           Tx-Power=0 dBm
>>>           Retry  long limit:7   RTS thr:off   Fragment thr:off
>>>           Encryption key:off
>>>           Power Management:off
>>>
>>> hwsim0    no wireless extensions.
>>>
>>> pan0      no wireless extensions.
>>>
>>> root@bt:~/compat-wireless-2010-04-21# ifconfig wlan0 up
>>> root@bt:~/compat-wireless-2010-04-21# iwlist wlan0 scan
>>> wlan0     No scan results
>>>
>>> root@bt:~/compat-wireless-2010-04-21# iwlist wlan1 scan
>>> wlan1     Interface doesn't support scanning : Network is down
>>>
>>> root@bt:~/compat-wireless-2010-04-21# ifconfig wlan1 up
>>> root@bt:~/compat-wireless-2010-04-21# iwlist wlan1 scan
>>> wlan1     No scan results
>>> root@bt:~/compat-wireless-2010-04-21/scripts# ./wlload.sh
>>> Loading ipw2100...
>>> Loading ipw2200...
>>> Loading libertas_cs...
>>> Loading usb8xxx...
>>> Loading p54pci...
>>> Loading p54usb...
>>> Loading adm8211...
>>> Loading zd1211rw...
>>> Loading rtl8180...
>>> Loading rtl8187...
>>> Loading p54pci...
>>> Loading p54usb...
>>> Loading iwl3945...
>>> Loading iwlagn...
>>> Loading ath...
>>> Loading ar9170usb...
>>> Loading rtl8180...
>>> Loading rtl8187...
>>> Loading rt2400pci...
>>> Loading rt2500pci...
>>> Loading rt61pci...
>>> Loading rt2500usb...
>>> Loading rt73usb...
>>> Loading rndis_wlan...
>>> Loading at76_usb...
>>> FATAL: Module at76_usb not found.
>>> Loading mwl8k...
>>> Loading mac80211_hwsim...
>>> Loading at76c50x_usb...
>>> Module ath_pci not detected -- this is fine
>>> ath5k loaded successfully
>>> ath9k loaded successfully
>>> Module bcm43xx not detected -- this is fine
>>> Module wl not detected -- this is fine
>>> FATAL: Error inserting b43
>>> (/lib/modules/2.6.30.9/updates/drivers/net/wireless/b43/b43.ko):
>>> Unknown symbol in module, or unknown parameter (see dmesg)
>
> Please post your dmesg output too.
>
>>> b43 loaded successfully
>>> b43legacy loaded successfully
>>> root@bt:~/compat-wireless-2010-04-21# rebootbcm4311 can not be work
>>> after update comapt-wireless u nder bt4 final.
>>> Last edited by Archangel-Amael; Today at 02:49 PM.
>>>  Edit Post    Reply    Reply With Quote
>>> --------------------------------------------------------------------------------
>>> --
>>> Best Regards
>>> --------------------
>>> SECO
>>>
>>> --------------------------------------------------------------------------------
>>> This information in this e-mail is confidential and may well also be
>>> legally privileged. It is intended solely for the addressee. If you
>>> have received it in error, you are on notice of its status. Please
>>> notify us immediately and then destroy this message. Please do not
>>> copy it or use it for any purposes, or disclose its contents to any
>>> other person: to do so could be a breach of confidence. Thank you for
>>> your co-operation.
>>> --------------------------------------------------------------------------------
>>>
>>
>>
>> --
>> Best Regards
>> --------------------
>> SECO
>>
>> --------------------------------------------------------------------------------
>> This information in this e-mail is confidential and may well also be
>> legally privileged. It is intended solely for the addressee. If you
>> have received it in error, you are on notice of its status. Please
>> notify us immediately and then destroy this message. Please do not
>> copy it or use it for any purposes, or disclose its contents to any
>> other person: to do so could be a breach of confidence. Thank you for
>> your co-operation.
>> --------------------------------------------------------------------------------
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
>
> --
> Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
>


-- 
Best Regards
--------------------
SECO

--------------------------------------------------------------------------------
This information in this e-mail is confidential and may well also be
legally privileged. It is intended solely for the addressee. If you
have received it in error, you are on notice of its status. Please
notify us immediately and then destroy this message. Please do not
copy it or use it for any purposes, or disclose its contents to any
other person: to do so could be a breach of confidence. Thank you for
your co-operation.
--------------------------------------------------------------------------------
