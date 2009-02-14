Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39998 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751566AbZBNExR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2009 23:53:17 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 13 Feb 2009 20:53:16 -0800
Date: Fri, 13 Feb 2009 20:52:32 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Tony Vroon <tony@linx.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	reinette chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: IWL5300, 2.6.29-rc4, CRDA 1.0.1: Missing out 802.11A frequency
	ranges
Message-ID: <20090214045232.GA5769@tesla> (sfid-20090214_055350_404817_5CBEB15F)
References: <1234202993.21570.18.camel@localhost> <43e72e890902091020p65235e3ds833560974c785318@mail.gmail.com> <1234203811.21570.19.camel@localhost> <20090209183924.GA6069@tuxdriver.com> <1234207263.6694.1.camel@localhost> <1234208152.6694.4.camel@localhost> <20090210013941.GA4386@tesla> <1234230689.3793.15.camel@localhost> <20090210020708.GC4386@tesla> <1234379981.4789.7.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1234379981.4789.7.camel@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 11, 2009 at 11:19:41AM -0800, Tony Vroon wrote:
> Clear run, haven't touched iw, still no 802.11A spectrum. dmesg
> attached. Any suggestion for a workaround that will get me my networks
> back please? (Besides enabling the old regulatory options, which is
> scheduled to be taken away from me soon)
> 
> Regards,
> Tony V.

> Linux version 2.6.29-rc4-00026-gf06da26 (root@amalthea) (gcc version 4.3.3 (Gentoo 4.3.3 p1.0, pie-10.1.5) ) #1 SMP Mon Feb 9 18:55:10 GMT 2009
> Command line: auto BOOT_IMAGE=2.6.29-rc4-0002 rw root=0 video=vesafb:ywrap,pmipal,mtrr
> KERNEL supported cpus:
>   Intel GenuineIntel
>   AMD AuthenticAMD
>   Centaur CentaurHauls
> BIOS-provided physical RAM map:
>  BIOS-e820: 0000000000000000 - 000000000009d400 (usable)
>  BIOS-e820: 000000000009d400 - 00000000000a0000 (reserved)
>  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
>  BIOS-e820: 0000000000100000 - 00000000bce51000 (usable)
>  BIOS-e820: 00000000bce51000 - 00000000bce57000 (reserved)
>  BIOS-e820: 00000000bce57000 - 00000000bd058000 (usable)
>  BIOS-e820: 00000000bd058000 - 00000000bd0af000 (reserved)
>  BIOS-e820: 00000000bd0af000 - 00000000bd1a8000 (usable)
>  BIOS-e820: 00000000bd1a8000 - 00000000bd4af000 (reserved)
>  BIOS-e820: 00000000bd4af000 - 00000000bd4d8000 (usable)
>  BIOS-e820: 00000000bd4d8000 - 00000000bd4df000 (reserved)
>  BIOS-e820: 00000000bd4df000 - 00000000bd535000 (usable)
>  BIOS-e820: 00000000bd535000 - 00000000bd57f000 (ACPI NVS)
>  BIOS-e820: 00000000bd57f000 - 00000000bd5e4000 (usable)
>  BIOS-e820: 00000000bd5e4000 - 00000000bd5fd000 (ACPI data)
>  BIOS-e820: 00000000bd5fd000 - 00000000bd600000 (usable)
>  BIOS-e820: 00000000bd600000 - 00000000c0000000 (reserved)
>  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
>  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
>  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
>  BIOS-e820: 00000000fed10000 - 00000000fed14000 (reserved)
>  BIOS-e820: 00000000fed18000 - 00000000fed1a000 (reserved)
>  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
>  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
>  BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
> DMI 2.4 present.
> last_pfn = 0xbd600 max_arch_pfn = 0x100000000
> x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> init_memory_mapping: 0000000000000000-00000000bd600000
>  0000000000 - 00bd600000 page 2M
> kernel direct mapping tables up to bd600000 @ 8000-c000
> last_map_addr: bd600000 end: bd600000
> ACPI: RSDP 000F53D0, 0024 (r2 FUJ   )
> ACPI: XSDT BD5F3434, 0074 (r1 FSC    PC        1160000 FUJ       100)
> ACPI: FACP BD5E6000, 00F4 (r3 FSC    PC        1160000 FUJ       100)
> FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN (4)
> ACPI: DSDT BD5E7000, 8CFF (r1 FUJ    FJNB1E6   1160000 FUJ       100)
> ACPI: FACS BD56EFC0, 0040
> ACPI: SSDT BD5FC1DF, 034F (r1 FUJ    FJNB1E6   1160000 FUJ       100)
> ACPI: HPET BD5FC622, 0038 (r1 FUJ    FJNB1E6   1160000 FUJ       100)
> ACPI: MCFG BD5FC65A, 003C (r1 FUJ    FJNB1E6   1160000 FUJ       100)
> ACPI: SSDT BD5FC696, 042F (r1 FUJ    FJNB1E6   1160000 FUJ       100)
> ACPI: SSDT BD5FCAC5, 02C1 (r1 FUJ    FJNB1E6   1160000 FUJ       100)
> ACPI: APIC BD5FCD86, 0068 (r1 FUJ    FJNB1E6   1160000 FUJ       100)
> ACPI: BOOT BD5FCDEE, 0028 (r1 FUJ    FJNB1E6   1160000 FUJ       100)
> ACPI: SLIC BD5FCE16, 0176 (r1 FSC    PC        1160000 FUJ       100)
> ACPI: SSDT BD5E5000, 04E6 (r1  PmRef    CpuPm     3000 INTL 20050624)
> ACPI: Local APIC address 0xfee00000
> (5 early reservations) ==> bootmem [0000000000 - 00bd600000]
>   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
>   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
>   #2 [0000200000 - 00009f3dec]    TEXT DATA BSS ==> [0000200000 - 00009f3dec]
>   #3 [000009d400 - 0000100000]    BIOS reserved ==> [000009d400 - 0000100000]
>   #4 [0000008000 - 000000a000]          PGTABLE ==> [0000008000 - 000000a000]
>  [ffffe20000000000-ffffe200029fffff] PMD -> [ffff880001200000-ffff880003bfffff] on node 0
> Zone PFN ranges:
>   DMA      0x00000000 -> 0x00001000
>   DMA32    0x00001000 -> 0x00100000
>   Normal   0x00100000 -> 0x00100000
> Movable zone start PFN for each node
> early_node_map[8] active PFN ranges
>     0: 0x00000000 -> 0x0000009d
>     0: 0x00000100 -> 0x000bce51
>     0: 0x000bce57 -> 0x000bd058
>     0: 0x000bd0af -> 0x000bd1a8
>     0: 0x000bd4af -> 0x000bd4d8
>     0: 0x000bd4df -> 0x000bd535
>     0: 0x000bd57f -> 0x000bd5e4
>     0: 0x000bd5fd -> 0x000bd600
> On node 0 totalpages: 774607
>   DMA zone: 56 pages used for memmap
>   DMA zone: 2138 pages reserved
>   DMA zone: 1803 pages, LIFO batch:0
>   DMA32 zone: 10549 pages used for memmap
>   DMA32 zone: 760061 pages, LIFO batch:31
> ACPI: PM-Timer IO Port: 0x408
> ACPI: Local APIC address 0xfee00000
> ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
> ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
> ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
> ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
> IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
> ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
> ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> ACPI: IRQ0 used by override.
> ACPI: IRQ2 used by override.
> ACPI: IRQ9 used by override.
> Using ACPI (MADT) for SMP configuration information
> ACPI: HPET id: 0x8086a201 base: 0xfed00000
> SMP: Allowing 2 CPUs, 0 hotplug CPUs
> Allocating PCI resources starting at c2000000 (gap: c0000000:20000000)
> NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
> PERCPU: Allocating 49152 bytes of per cpu data
> Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 761864
> Kernel command line: auto BOOT_IMAGE=2.6.29-rc4-0002 rw root=0 video=vesafb:ywrap,pmipal,mtrr
> Initializing CPU#0
> PID hash table entries: 4096 (order: 12, 32768 bytes)
> Extended CMOS year: 2000
> Fast TSC calibration using PIT
> Detected 2526.896 MHz processor.
> Console: colour VGA+ 80x25
> console [tty0] enabled
> Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
> Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
> Checking aperture...
> No AGP bridge found
> Memory: 3040120k/3102720k available (4161k kernel code, 4292k absent, 57580k reserved, 1977k data, 1428k init)
> SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
> hpet clockevent registered
> HPET: 4 timers in total, 0 timers will be used for per-cpu timer
> Calibrating delay loop (skipped), value calculated using timer frequency.. 5055.36 BogoMIPS (lpj=8422986)
> Mount-cache hash table entries: 256
> CPU: L1 I cache: 32K, L1 D cache: 32K
> CPU: L2 cache: 6144K
> [ds] using Core 2/Atom configuration
> CPU: Physical Processor ID: 0
> CPU: Processor Core ID: 0
> CPU0: Thermal monitoring enabled (TM2)
> using mwait in idle threads.
> Freeing SMP alternatives: 37k freed
> ACPI: Core revision 20081204
> Setting APIC routing to flat
> ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> CPU0: Intel(R) Core(TM)2 Duo CPU     T9400  @ 2.53GHz stepping 06
> Booting processor 1 APIC 0x1 ip 0x6000
> Initializing CPU#1
> Calibrating delay using timer specific routine.. 5056.56 BogoMIPS (lpj=8423304)
> CPU: L1 I cache: 32K, L1 D cache: 32K
> CPU: L2 cache: 6144K
> [ds] using Core 2/Atom configuration
> CPU: Physical Processor ID: 0
> CPU: Processor Core ID: 1
> CPU1: Thermal monitoring enabled (TM2)
> x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
> CPU1: Intel(R) Core(TM)2 Duo CPU     T9400  @ 2.53GHz stepping 06
> checking TSC synchronization [CPU#0 -> CPU#1]: passed.
> Brought up 2 CPUs
> Total of 2 processors activated (10111.93 BogoMIPS).
> net_namespace: 960 bytes
> NET: Registered protocol family 16
> ACPI: bus type pci registered
> PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
> PCI: MCFG area at e0000000 reserved in E820
> PCI: Using MMCONFIG at e0000000 - efffffff
> PCI: Using configuration type 1 for base access
> mtrr: your CPUs had inconsistent variable MTRR settings
> mtrr: probably your BIOS does not setup all CPUs.
> mtrr: corrected configuration.
> bio: create slab <bio-0> at 0
> ACPI: EC: Look up EC in DSDT
> ACPI: SSDT BD56E965, 03F1 (r1 FUJ    FJNB1E6   1160000 FUJ       100)
> ACPI: Interpreter enabled
> ACPI: (supports S0 S5)
> ACPI: Using IOAPIC for interrupt routing
> ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
> ACPI: EC: driver started in poll mode
> ACPI: ACPI Dock Station Driver: 2 docks/bays found
> ACPI: PCI Root Bridge [PCI0] (0000:00)
> pci 0000:00:02.0: reg 10 64bit mmio: [0xf0000000-0xf03fffff]
> pci 0000:00:02.0: reg 18 64bit mmio: [0xd0000000-0xdfffffff]
> pci 0000:00:02.0: reg 20 io port: [0x1800-0x1807]
> pci 0000:00:02.1: reg 10 64bit mmio: [0xf0400000-0xf04fffff]
> pci 0000:00:1a.0: reg 20 io port: [0x1820-0x183f]
> pci 0000:00:1a.1: reg 20 io port: [0x1840-0x185f]
> pci 0000:00:1a.2: reg 20 io port: [0x1860-0x187f]
> pci 0000:00:1a.7: reg 10 32bit mmio: [0xf0a04800-0xf0a04bff]
> pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
> pci 0000:00:1a.7: PME# disabled
> pci 0000:00:1b.0: reg 10 64bit mmio: [0xf0a00000-0xf0a03fff]
> pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
> pci 0000:00:1b.0: PME# disabled
> pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
> pci 0000:00:1c.0: PME# disabled
> pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
> pci 0000:00:1c.2: PME# disabled
> pci 0000:00:1d.0: reg 20 io port: [0x1880-0x189f]
> pci 0000:00:1d.1: reg 20 io port: [0x18a0-0x18bf]
> pci 0000:00:1d.2: reg 20 io port: [0x18c0-0x18df]
> pci 0000:00:1d.7: reg 10 32bit mmio: [0xf0a04c00-0xf0a04fff]
> pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
> pci 0000:00:1d.7: PME# disabled
> pci 0000:00:1f.2: reg 10 io port: [0x1818-0x181f]
> pci 0000:00:1f.2: reg 14 io port: [0x180c-0x180f]
> pci 0000:00:1f.2: reg 18 io port: [0x1810-0x1817]
> pci 0000:00:1f.2: reg 1c io port: [0x1808-0x180b]
> pci 0000:00:1f.2: reg 20 io port: [0x18e0-0x18ff]
> pci 0000:00:1f.2: reg 24 32bit mmio: [0xf0a04000-0xf0a047ff]
> pci 0000:00:1f.2: PME# supported from D3hot
> pci 0000:00:1f.2: PME# disabled
> pci 0000:00:1f.3: reg 10 64bit mmio: [0x000000-0x0000ff]
> pci 0000:00:1f.3: reg 20 io port: [0x1c00-0x1c1f]
> pci 0000:08:00.0: reg 10 64bit mmio: [0xf0500000-0xf0503fff]
> pci 0000:08:00.0: reg 18 io port: [0x2000-0x20ff]
> pci 0000:08:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
> pci 0000:08:00.0: supports D1 D2
> pci 0000:08:00.0: PME# supported from D0 D1 D2 D3hot D3cold
> pci 0000:08:00.0: PME# disabled
> pci 0000:00:1c.0: bridge io port: [0x2000-0x2fff]
> pci 0000:00:1c.0: bridge 32bit mmio: [0xf0500000-0xf05fffff]
> pci 0000:18:00.0: reg 10 64bit mmio: [0xf0600000-0xf0601fff]
> pci 0000:18:00.0: PME# supported from D0 D3hot D3cold
> pci 0000:18:00.0: PME# disabled
> pci 0000:00:1c.2: bridge 32bit mmio: [0xf0600000-0xf06fffff]
> pci 0000:38:03.0: reg 10 32bit mmio: [0x000000-0x000fff]
> pci 0000:38:03.0: supports D1 D2
> pci 0000:38:03.0: PME# supported from D0 D1 D2 D3hot D3cold
> pci 0000:38:03.0: PME# disabled
> pci 0000:38:03.2: reg 10 32bit mmio: [0xf0700000-0xf07000ff]
> pci 0000:38:03.2: supports D1 D2
> pci 0000:38:03.2: PME# supported from D0 D1 D2 D3hot D3cold
> pci 0000:38:03.2: PME# disabled
> pci 0000:38:03.3: reg 10 32bit mmio: [0xf0701000-0xf0701fff]
> pci 0000:38:03.3: supports D1 D2
> pci 0000:38:03.3: PME# supported from D0 D1 D2 D3hot D3cold
> pci 0000:38:03.3: PME# disabled
> pci 0000:38:03.4: reg 10 32bit mmio: [0xf0702000-0xf0702fff]
> pci 0000:38:03.4: reg 14 32bit mmio: [0xf0700800-0xf0700fff]
> pci 0000:38:03.4: supports D1 D2
> pci 0000:38:03.4: PME# supported from D0 D1 D2 D3hot
> pci 0000:38:03.4: PME# disabled
> pci 0000:00:1e.0: transparent bridge
> pci 0000:00:1e.0: bridge 32bit mmio: [0xf0700000-0xf07fffff]
> pci_bus 0000:00: on NUMA node 0
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
> ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
> ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12 14 15)
> ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
> ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *11 12 14 15)
> ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
> ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
> ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
> ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 *11 12 14 15)
> SCSI subsystem initialized
> libata version 3.00 loaded.
> usbcore: registered new interface driver usbfs
> usbcore: registered new interface driver hub
> usbcore: registered new device driver usb
> PCI: Using ACPI for IRQ routing
> Bluetooth: Core ver 2.14
> NET: Registered protocol family 31
> Bluetooth: HCI device and connection manager initialized
> Bluetooth: HCI socket layer initialized
> cfg80211: Calling CRDA to update world regulatory domain
> cfg80211: calling CRDA failed - unable to update world regulatory domain, using static definition

OK please use the new patch series I am about to post to test why this is
happening. And I am perplexed as to why you have 5 GHz disabled because
wiphy->custom_regulatory is enabled for intel the iwlagn driver and upon
wiphy registration we have a check to see if this is set and if the last
regulatory hint came from the core, if this is true we don't update the
wiphy's channels based on the regulatory domain:

        if (!last_request)
                return true;
        if (setby == REGDOM_SET_BY_CORE &&
                  wiphy->custom_regulatory)
                return true

Please run with my latest patch series or wait until it gets merged,
we'll be able to do a trace of your udev even failing to call CRDA
and the core initialization will be much easier to read.

  Luis
