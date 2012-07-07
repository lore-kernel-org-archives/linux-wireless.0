Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nessie.weebeastie.net ([220.233.7.36]:41063 "EHLO
	bunyip.billabong.weebeastie.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750918Ab2GGMp3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Jul 2012 08:45:29 -0400
Date: Sat, 7 Jul 2012 22:17:21 +1000
From: CaT <cat@zip.com.au>
To: ilw@linux.intel.com, wey-yi.w.guy@intel.com,
	johannes.berg@intel.com
Cc: linux-wireless@vger.kernel.org
Subject: wireless card losing connectivity/traffic passing ability
Message-ID: <20120707121721.GJ13221@zip.com.au> (sfid-20120707_144549_481549_F4E1D301)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="5vNYLRcllDrimb99"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Been getting this for a long while now but today it got to the point where
I gave up and plugged in an ethernet cable. Normally it eventually recovers
after I toggle the wireless on/off switch on my laptop. This time it would
only do so for a brief moment.

Currently running 3.4.4 but, as stated, this has been happening for a very
long time. The dmesg is attached and there's even a kernel trace in there.

The effect is that even though NetworkManager detects the card and gives
signal strength and thinks there's a connection, no traffic makes it through.
The other thing that happens is that the connection drops out and it fails
to reconnect completely.

Happy to answer all questions and try stuff. Laptop involved is an x220
and the card is:

03:00.0 Network controller: Intel Corporation Centrino Advanced-N 6205 (rev 34)

The kernel is monolithic.

-- 
  "A search of his car uncovered pornography, a homemade sex aid, women's 
  stockings and a Jack Russell terrier."
    - http://www.dailytelegraph.com.au/news/wacky/indeed/story-e6frev20-1111118083480

--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=meh

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.4.4-local.20120627-224004 (root@pet) (gcc version 4.7.0 (Debian 4.7.0-8) ) #28 SMP PREEMPT Wed Jun 27 22:45:06 EST 2012
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz root=/dev/mapper/b-root ro pcie_aspm=force thinkpad_acpi.fan_control=1
[    0.000000] Disabled fast string operations
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009d800 (usable)
[    0.000000]  BIOS-e820: 000000000009d800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 0000000020000000 (usable)
[    0.000000]  BIOS-e820: 0000000020000000 - 0000000020200000 (reserved)
[    0.000000]  BIOS-e820: 0000000020200000 - 0000000040000000 (usable)
[    0.000000]  BIOS-e820: 0000000040000000 - 0000000040200000 (reserved)
[    0.000000]  BIOS-e820: 0000000040200000 - 00000000da99f000 (usable)
[    0.000000]  BIOS-e820: 00000000da99f000 - 00000000dae9f000 (reserved)
[    0.000000]  BIOS-e820: 00000000dae9f000 - 00000000daf9f000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000daf9f000 - 00000000dafff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000dafff000 - 00000000db000000 (usable)
[    0.000000]  BIOS-e820: 00000000db000000 - 00000000dfa00000 (reserved)
[    0.000000]  BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed08000 - 00000000fed09000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed10000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffd20000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000021e600000 (usable)
[    0.000000]  BIOS-e820: 000000021e600000 - 000000021e800000 (reserved)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.6 present.
[    0.000000] DMI: LENOVO 4290CTO/4290CTO, BIOS 8DET59WW (1.29 ) 04/02/2012
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x21e600 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0FFC00000 mask FFFC00000 write-protect
[    0.000000]   1 base 000000000 mask F80000000 write-back
[    0.000000]   2 base 080000000 mask FC0000000 write-back
[    0.000000]   3 base 0C0000000 mask FE0000000 write-back
[    0.000000]   4 base 0DC000000 mask FFC000000 uncachable
[    0.000000]   5 base 0DB000000 mask FFF000000 uncachable
[    0.000000]   6 base 100000000 mask F00000000 write-back
[    0.000000]   7 base 200000000 mask FE0000000 write-back
[    0.000000]   8 base 21F000000 mask FFF000000 uncachable
[    0.000000]   9 base 21E800000 mask FFF800000 uncachable
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] last_pfn = 0xdb000 max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-00000000db000000
[    0.000000]  0000000000 - 00db000000 page 2M
[    0.000000] kernel direct mapping tables up to db000000 @ 1fffb000-20000000
[    0.000000] init_memory_mapping: 0000000100000000-000000021e600000
[    0.000000]  0100000000 - 021e600000 page 2M
[    0.000000] kernel direct mapping tables up to 21e600000 @ da995000-da99f000
[    0.000000] ACPI: RSDP 00000000000f00e0 00024 (v02 LENOVO)
[    0.000000] ACPI: XSDT 00000000daffe120 000AC (v01 LENOVO TP-8D    00001290 PTEC 00000002)
[    0.000000] ACPI: FACP 00000000dafe7000 000F4 (v04 LENOVO TP-8D    00001290 PTL  00000002)
[    0.000000] ACPI: DSDT 00000000dafea000 0F716 (v01 LENOVO TP-8D    00001290 INTL 20061109)
[    0.000000] ACPI: FACS 00000000daf2d000 00040
[    0.000000] ACPI: SLIC 00000000daffd000 00176 (v01 LENOVO TP-8D    00001290 PTEC 00000001)
[    0.000000] ACPI: SSDT 00000000daffc000 00249 (v01 LENOVO TP-SSDT2 00000200 INTL 20061109)
[    0.000000] ACPI: SSDT 00000000daffb000 00033 (v01 LENOVO TP-SSDT1 00000100 INTL 20061109)
[    0.000000] ACPI: SSDT 00000000daffa000 007D1 (v01 LENOVO SataAhci 00001000 INTL 20061109)
[    0.000000] ACPI: HPET 00000000dafe6000 00038 (v01 LENOVO TP-8D    00001290 PTL  00000002)
[    0.000000] ACPI: APIC 00000000dafe5000 00098 (v01 LENOVO TP-8D    00001290 PTL  00000002)
[    0.000000] ACPI: MCFG 00000000dafe4000 0003C (v01 LENOVO TP-8D    00001290 PTL  00000002)
[    0.000000] ACPI: ECDT 00000000dafe3000 00052 (v01 LENOVO TP-8D    00001290 PTL  00000002)
[    0.000000] ACPI: ASF! 00000000dafe9000 000A5 (v32 LENOVO TP-8D    00001290 PTL  00000002)
[    0.000000] ACPI: TCPA 00000000dafe2000 00032 (v02    PTL   LENOVO 06040000 LNVO 00000001)
[    0.000000] ACPI: SSDT 00000000dafe1000 00A69 (v01  PmRef  Cpu0Ist 00003000 INTL 20061109)
[    0.000000] ACPI: SSDT 00000000dafe0000 00996 (v01  PmRef    CpuPm 00003000 INTL 20061109)
[    0.000000] ACPI: DMAR 00000000dafdf000 000E8 (v01 INTEL      SNB  00000001 INTL 00000001)
[    0.000000] ACPI: UEFI 00000000dafde000 0003E (v01 LENOVO TP-8D    00001290 PTL  00000002)
[    0.000000] ACPI: UEFI 00000000dafdd000 00042 (v01 PTL      COMBUF 00000001 PTL  00000001)
[    0.000000] ACPI: UEFI 00000000dafdc000 00292 (v01 LENOVO TP-8D    00001290 PTL  00000002)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea00077fffff] PMD -> [ffff880215c00000-ffff88021cdfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0021e600
[    0.000000] Movable zone start PFN for each node
[    0.000000] Early memory PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009d
[    0.000000]     0: 0x00000100 -> 0x00020000
[    0.000000]     0: 0x00020200 -> 0x00040000
[    0.000000]     0: 0x00040200 -> 0x000da99f
[    0.000000]     0: 0x000dafff -> 0x000db000
[    0.000000]     0: 0x00100000 -> 0x0021e600
[    0.000000] On node 0 totalpages: 2067245
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3920 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 875992 pages, LIFO batch:31
[    0.000000]   Normal zone: 16037 pages used for memmap
[    0.000000]   Normal zone: 1156955 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] 8 Processors exceeds NR_CPUS limit of 4
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 0000000020000000 - 0000000020200000
[    0.000000] PM: Registered nosave memory: 0000000040000000 - 0000000040200000
[    0.000000] PM: Registered nosave memory: 00000000da99f000 - 00000000dae9f000
[    0.000000] PM: Registered nosave memory: 00000000dae9f000 - 00000000daf9f000
[    0.000000] PM: Registered nosave memory: 00000000daf9f000 - 00000000dafff000
[    0.000000] PM: Registered nosave memory: 00000000db000000 - 00000000dfa00000
[    0.000000] PM: Registered nosave memory: 00000000dfa00000 - 00000000f8000000
[    0.000000] PM: Registered nosave memory: 00000000f8000000 - 00000000fc000000
[    0.000000] PM: Registered nosave memory: 00000000fc000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec01000
[    0.000000] PM: Registered nosave memory: 00000000fec01000 - 00000000fed08000
[    0.000000] PM: Registered nosave memory: 00000000fed08000 - 00000000fed09000
[    0.000000] PM: Registered nosave memory: 00000000fed09000 - 00000000fed10000
[    0.000000] PM: Registered nosave memory: 00000000fed10000 - 00000000fed1a000
[    0.000000] PM: Registered nosave memory: 00000000fed1a000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ffd20000
[    0.000000] PM: Registered nosave memory: 00000000ffd20000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at dfa00000 (gap: dfa00000:18600000)
[    0.000000] setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88021e200000 s77888 r8192 d24512 u524288
[    0.000000] pcpu-alloc: s77888 r8192 d24512 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2036867
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz root=/dev/mapper/b-root ro pcie_aspm=force thinkpad_acpi.fan_control=1
[    0.000000] PCIe ASPM is forcibly enabled
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.000000] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000000] xsave/xrstor: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 8054068k/8886272k available (7505k kernel code, 617292k absent, 214912k reserved, 3709k data, 7136k init)
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] NR_IRQS:4352 nr_irqs:712 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.004000] Detected 2691.064 MHz processor.
[    0.000002] Calibrating delay loop (skipped), value calculated using timer frequency.. 5382.12 BogoMIPS (lpj=10764256)
[    0.000118] pid_max: default: 32768 minimum: 301
[    0.000223] Mount-cache hash table entries: 256
[    0.000432] Initializing cgroup subsys cpuacct
[    0.000489] Initializing cgroup subsys devices
[    0.000547] Initializing cgroup subsys freezer
[    0.000604] Initializing cgroup subsys blkio
[    0.000664] Initializing cgroup subsys perf_event
[    0.000722] Initializing cgroup subsys net_prio
[    0.000803] Disabled fast string operations
[    0.000859] CPU: Physical Processor ID: 0
[    0.000924] CPU: Processor Core ID: 0
[    0.000983] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.000984] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.001103] mce: CPU supports 7 MCE banks
[    0.001167] CPU0: Thermal monitoring enabled (TM1)
[    0.001229] using mwait in idle threads.
[    0.001339] ACPI: Core revision 20120320
[    0.018556] DMAR: Host address width 36
[    0.018613] DMAR: DRHD base: 0x000000fed90000 flags: 0x0
[    0.018676] IOMMU 0: reg_base_addr fed90000 ver 1:0 cap c0000020e60262 ecap f0101a
[    0.018750] DMAR: DRHD base: 0x000000fed91000 flags: 0x1
[    0.018812] IOMMU 1: reg_base_addr fed91000 ver 1:0 cap c9008020660262 ecap f0105a
[    0.018886] DMAR: RMRR base: 0x000000dacd5000 end: 0x000000dacebfff
[    0.018947] DMAR: RMRR base: 0x000000db800000 end: 0x000000df9fffff
[    0.019077] IOAPIC id 2 under DRHD base  0xfed91000 IOMMU 1
[    0.019136] HPET id 0 under DRHD base 0xfed91000
[    0.019193] HPET id 0 under DRHD base 0xfed91000
[    0.019252] HPET id 0 under DRHD base 0xfed91000
[    0.019310] HPET id 0 under DRHD base 0xfed91000
[    0.019368] HPET id 0 under DRHD base 0xfed91000
[    0.019426] HPET id 0 under DRHD base 0xfed91000
[    0.019483] HPET id 0 under DRHD base 0xfed91000
[    0.019541] HPET id 0 under DRHD base 0xfed91000
[    0.019845] Enabled IRQ remapping in x2apic mode
[    0.019903] Enabling x2apic
[    0.019957] Enabled x2apic
[    0.021341] Switched APIC routing to cluster x2apic.
[    0.021836] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.061526] CPU0: Intel(R) Core(TM) i7-2620M CPU @ 2.70GHz stepping 07
[    0.168688] Performance Events: PEBS fmt1+, 16-deep LBR, SandyBridge events, Intel PMU driver.
[    0.168922] PEBS disabled due to CPU errata.
[    0.168980] ... version:                3
[    0.169037] ... bit width:              48
[    0.169095] ... generic registers:      4
[    0.169152] ... value mask:             0000ffffffffffff
[    0.169211] ... max period:             000000007fffffff
[    0.169270] ... fixed-purpose events:   3
[    0.169327] ... event mask:             000000070000000f
[    0.192690] Booting Node   0, Processors  #1
[    0.203734] Disabled fast string operations
[    0.212675]  #2
[    0.223776] Disabled fast string operations
[    0.232648]  #3 Ok.
[    0.243763] Disabled fast string operations
[    0.245861] Brought up 4 CPUs
[    0.245974] Total of 4 processors activated (21528.51 BogoMIPS).
[    0.249018] devtmpfs: initialized
[    0.249404] PM: Registering ACPI NVS region [mem 0xdae9f000-0xdaf9efff] (1048576 bytes)
[    0.249532] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    0.249648] NET: Registered protocol family 16
[    0.249960] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.250035] ACPI: bus type pci registered
[    0.250306] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.250383] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.256802] PCI: Using configuration type 1 for base access
[    0.259613] bio: create slab <bio-0> at 0
[    0.259753] ACPI: Added _OSI(Module Device)
[    0.259812] ACPI: Added _OSI(Processor Device)
[    0.259870] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.259928] ACPI: Added _OSI(Processor Aggregator Device)
[    0.261669] ACPI: EC: EC description table is found, configuring boot EC
[    0.267087] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.270093] ACPI: SSDT 00000000dae8c018 008C0 (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
[    0.270680] ACPI: Dynamic OEM Table Load:
[    0.270816] ACPI: SSDT           (null) 008C0 (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
[    0.271216] ACPI: SSDT 00000000dae8da98 00303 (v01  PmRef    ApIst 00003000 INTL 20061109)
[    0.271835] ACPI: Dynamic OEM Table Load:
[    0.271970] ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20061109)
[    0.272234] ACPI: SSDT 00000000dae8bd98 00119 (v01  PmRef    ApCst 00003000 INTL 20061109)
[    0.272811] ACPI: Dynamic OEM Table Load:
[    0.272945] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20061109)
[    0.273659] ACPI: Interpreter enabled
[    0.273717] ACPI: (supports S0 S3 S4 S5)
[    0.273947] ACPI: Using IOAPIC for interrupt routing
[    0.276710] ACPI: Power Resource [PUBS] (on)
[    0.279916] ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
[    0.281099] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    0.281161] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.281337] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
[    0.281415] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.281477] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.281538] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.281613] pci_root PNP0A08:00: host bridge window [mem 0xdfa00000-0xfebfffff]
[    0.281686] pci_root PNP0A08:00: host bridge window [mem 0xfed40000-0xfed4bfff]
[    0.281785] PCI host bridge to bus 0000:00
[    0.281843] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.281905] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.281966] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.282028] pci_bus 0000:00: root bus resource [mem 0xdfa00000-0xfebfffff]
[    0.282090] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed4bfff]
[    0.282159] pci 0000:00:00.0: [8086:0104] type 00 class 0x060000
[    0.282195] pci 0000:00:02.0: [8086:0126] type 00 class 0x030000
[    0.282205] pci 0000:00:02.0: reg 10: [mem 0xf0000000-0xf03fffff 64bit]
[    0.282211] pci 0000:00:02.0: reg 18: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.282215] pci 0000:00:02.0: reg 20: [io  0x5000-0x503f]
[    0.282268] pci 0000:00:16.0: [8086:1c3a] type 00 class 0x078000
[    0.282292] pci 0000:00:16.0: reg 10: [mem 0xf2625000-0xf262500f 64bit]
[    0.282368] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.282402] pci 0000:00:19.0: [8086:1502] type 00 class 0x020000
[    0.282420] pci 0000:00:19.0: reg 10: [mem 0xf2600000-0xf261ffff]
[    0.282428] pci 0000:00:19.0: reg 14: [mem 0xf262b000-0xf262bfff]
[    0.282437] pci 0000:00:19.0: reg 18: [io  0x5080-0x509f]
[    0.282499] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.282526] pci 0000:00:1a.0: [8086:1c2d] type 00 class 0x0c0320
[    0.282547] pci 0000:00:1a.0: reg 10: [mem 0xf262a000-0xf262a3ff]
[    0.282637] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.282665] pci 0000:00:1b.0: [8086:1c20] type 00 class 0x040300
[    0.282680] pci 0000:00:1b.0: reg 10: [mem 0xf2620000-0xf2623fff 64bit]
[    0.282747] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.282778] pci 0000:00:1c.0: [8086:1c10] type 01 class 0x060400
[    0.282909] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.282948] pci 0000:00:1c.1: [8086:1c12] type 01 class 0x060400
[    0.283077] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.283118] pci 0000:00:1c.3: [8086:1c16] type 01 class 0x060400
[    0.283248] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.283286] pci 0000:00:1c.4: [8086:1c18] type 01 class 0x060400
[    0.283364] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.283393] pci 0000:00:1c.6: [8086:1c1c] type 01 class 0x060400
[    0.283470] pci 0000:00:1c.6: PME# supported from D0 D3hot D3cold
[    0.283502] pci 0000:00:1d.0: [8086:1c26] type 00 class 0x0c0320
[    0.283523] pci 0000:00:1d.0: reg 10: [mem 0xf2629000-0xf26293ff]
[    0.283613] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.283641] pci 0000:00:1f.0: [8086:1c4f] type 00 class 0x060100
[    0.283767] pci 0000:00:1f.2: [8086:1c03] type 00 class 0x010601
[    0.283785] pci 0000:00:1f.2: reg 10: [io  0x50a8-0x50af]
[    0.283793] pci 0000:00:1f.2: reg 14: [io  0x50b4-0x50b7]
[    0.283802] pci 0000:00:1f.2: reg 18: [io  0x50a0-0x50a7]
[    0.283810] pci 0000:00:1f.2: reg 1c: [io  0x50b0-0x50b3]
[    0.283818] pci 0000:00:1f.2: reg 20: [io  0x5060-0x507f]
[    0.283826] pci 0000:00:1f.2: reg 24: [mem 0xf2628000-0xf26287ff]
[    0.283870] pci 0000:00:1f.2: PME# supported from D3hot
[    0.283891] pci 0000:00:1f.3: [8086:1c22] type 00 class 0x0c0500
[    0.283907] pci 0000:00:1f.3: reg 10: [mem 0xf2624000-0xf26240ff 64bit]
[    0.283928] pci 0000:00:1f.3: reg 20: [io  0xefa0-0xefbf]
[    0.284026] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.284331] pci 0000:03:00.0: [8086:0085] type 00 class 0x028000
[    0.284478] pci 0000:03:00.0: reg 10: [mem 0xf2500000-0xf2501fff 64bit]
[    0.285196] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.292676] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.292743] pci 0000:00:1c.1:   bridge window [mem 0xf2500000-0xf25fffff]
[    0.292822] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.292884] pci 0000:00:1c.3:   bridge window [io  0x4000-0x4fff]
[    0.292890] pci 0000:00:1c.3:   bridge window [mem 0xf1d00000-0xf24fffff]
[    0.292899] pci 0000:00:1c.3:   bridge window [mem 0xf0400000-0xf0bfffff 64bit pref]
[    0.293102] pci 0000:0d:00.0: [1180:e823] type 00 class 0x088001
[    0.293120] pci 0000:0d:00.0: MMC controller base frequency changed to 50Mhz.
[    0.293414] pci 0000:0d:00.0: reg 10: [mem 0xf1500000-0xf15000ff]
[    0.293610] pci 0000:0d:00.0: supports D1 D2
[    0.293612] pci 0000:0d:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.300625] pci 0000:00:1c.4: PCI bridge to [bus 0d-0d]
[    0.300702] pci 0000:00:1c.4:   bridge window [io  0x3000-0x3fff]
[    0.300707] pci 0000:00:1c.4:   bridge window [mem 0xf1500000-0xf1cfffff]
[    0.300713] pci 0000:00:1c.4:   bridge window [mem 0xf0c00000-0xf13fffff 64bit pref]
[    0.300785] pci 0000:0e:00.0: [1033:0194] type 00 class 0x0c0330
[    0.300811] pci 0000:0e:00.0: reg 10: [mem 0xf1400000-0xf1401fff 64bit]
[    0.300944] pci 0000:0e:00.0: PME# supported from D0 D3hot D3cold
[    0.308532] pci 0000:00:1c.6: PCI bridge to [bus 0e-0e]
[    0.308630] pci 0000:00:1c.6:   bridge window [mem 0xf1400000-0xf14fffff]
[    0.308683] pci_bus 0000:00: on NUMA node 0
[    0.308685] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.308783] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    0.308810] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP2._PRT]
[    0.308836] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP4._PRT]
[    0.308864] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP5._PRT]
[    0.308893] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP7._PRT]
[    0.309012]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.309220]  pci0000:00: ACPI _OSC request failed (AE_SUPPORT), returned control mask: 0x0d
[    0.309295] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.311558] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    0.312061] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 *7 9 10 11)
[    0.312563] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *7 9 10 11)
[    0.313061] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    0.313557] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 *10 11)
[    0.314048] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.314636] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
[    0.315134] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 *10 11)
[    0.315652] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.315734] vgaarb: loaded
[    0.315788] vgaarb: bridge control possible 0000:00:02.0
[    0.315946] SCSI subsystem initialized
[    0.316016] libata version 3.00 loaded.
[    0.316056] usbcore: registered new interface driver usbfs
[    0.316129] usbcore: registered new interface driver hub
[    0.316211] usbcore: registered new device driver usb
[    0.316289] Linux video capture interface: v2.00
[    0.316572] wmi: Mapper loaded
[    0.316643] Advanced Linux Sound Architecture Driver Version 1.0.25.
[    0.316704] PCI: Using ACPI for IRQ routing
[    0.318397] PCI: pci_cache_line_size set to 64 bytes
[    0.318838] reserve RAM buffer: 000000000009d800 - 000000000009ffff 
[    0.318840] reserve RAM buffer: 00000000da99f000 - 00000000dbffffff 
[    0.318842] reserve RAM buffer: 00000000db000000 - 00000000dbffffff 
[    0.318844] reserve RAM buffer: 000000021e600000 - 000000021fffffff 
[    0.318921] Bluetooth: Core ver 2.16
[    0.318983] NET: Registered protocol family 31
[    0.319040] Bluetooth: HCI device and connection manager initialized
[    0.319101] Bluetooth: HCI socket layer initialized
[    0.319158] Bluetooth: L2CAP socket layer initialized
[    0.319218] Bluetooth: SCO socket layer initialized
[    0.319313] cfg80211: Calling CRDA to update world regulatory domain
[    0.319592] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.320004] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.322078] Switching to clocksource hpet
[    0.325023] pnp: PnP ACPI init
[    0.325089] ACPI: bus type pnp registered
[    0.325487] pnp 00:00: [mem 0x00000000-0x0009ffff]
[    0.325489] pnp 00:00: [mem 0x000c0000-0x000c3fff]
[    0.325491] pnp 00:00: [mem 0x000c4000-0x000c7fff]
[    0.325492] pnp 00:00: [mem 0x000c8000-0x000cbfff]
[    0.325494] pnp 00:00: [mem 0x000cc000-0x000cffff]
[    0.325495] pnp 00:00: [mem 0x000d0000-0x000d3fff]
[    0.325497] pnp 00:00: [mem 0x000d4000-0x000d7fff]
[    0.325499] pnp 00:00: [mem 0x000d8000-0x000dbfff]
[    0.325500] pnp 00:00: [mem 0x000dc000-0x000dffff]
[    0.325502] pnp 00:00: [mem 0x000e0000-0x000e3fff]
[    0.325503] pnp 00:00: [mem 0x000e4000-0x000e7fff]
[    0.325505] pnp 00:00: [mem 0x000e8000-0x000ebfff]
[    0.325506] pnp 00:00: [mem 0x000ec000-0x000effff]
[    0.325508] pnp 00:00: [mem 0x000f0000-0x000fffff]
[    0.325510] pnp 00:00: [mem 0x00100000-0xdf9fffff]
[    0.325511] pnp 00:00: [mem 0xfec00000-0xfed3ffff]
[    0.325513] pnp 00:00: [mem 0xfed4c000-0xffffffff]
[    0.325557] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.325620] system 00:00: [mem 0x000c0000-0x000c3fff] could not be reserved
[    0.325687] system 00:00: [mem 0x000c4000-0x000c7fff] could not be reserved
[    0.325751] system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
[    0.325815] system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
[    0.325877] system 00:00: [mem 0x000d0000-0x000d3fff] has been reserved
[    0.325939] system 00:00: [mem 0x000d4000-0x000d7fff] has been reserved
[    0.326002] system 00:00: [mem 0x000d8000-0x000dbfff] has been reserved
[    0.326064] system 00:00: [mem 0x000dc000-0x000dffff] has been reserved
[    0.326132] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
[    0.326195] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
[    0.326258] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
[    0.326320] system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
[    0.326383] system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
[    0.326445] system 00:00: [mem 0x00100000-0xdf9fffff] could not be reserved
[    0.326508] system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
[    0.326571] system 00:00: [mem 0xfed4c000-0xffffffff] could not be reserved
[    0.326635] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.326652] pnp 00:01: [bus 00-fe]
[    0.326654] pnp 00:01: [io  0x0cf8-0x0cff]
[    0.326657] pnp 00:01: [io  0x0000-0x0cf7 window]
[    0.326658] pnp 00:01: [io  0x0d00-0xffff window]
[    0.326660] pnp 00:01: [mem 0x000a0000-0x000bffff window]
[    0.326662] pnp 00:01: [mem 0x000c0000-0x000c3fff window]
[    0.326664] pnp 00:01: [mem 0x000c4000-0x000c7fff window]
[    0.326665] pnp 00:01: [mem 0x000c8000-0x000cbfff window]
[    0.326667] pnp 00:01: [mem 0x000cc000-0x000cffff window]
[    0.326669] pnp 00:01: [mem 0x000d0000-0x000d3fff window]
[    0.326670] pnp 00:01: [mem 0x000d4000-0x000d7fff window]
[    0.326672] pnp 00:01: [mem 0x000d8000-0x000dbfff window]
[    0.326674] pnp 00:01: [mem 0x000dc000-0x000dffff window]
[    0.326675] pnp 00:01: [mem 0x000e0000-0x000e3fff window]
[    0.326677] pnp 00:01: [mem 0x000e4000-0x000e7fff window]
[    0.326679] pnp 00:01: [mem 0x000e8000-0x000ebfff window]
[    0.326680] pnp 00:01: [mem 0x000ec000-0x000effff window]
[    0.326682] pnp 00:01: [mem 0xdfa00000-0xfebfffff window]
[    0.326684] pnp 00:01: [mem 0xfed40000-0xfed4bfff window]
[    0.326730] pnp 00:01: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.326784] pnp 00:02: [io  0x0010-0x001f]
[    0.326785] pnp 00:02: [io  0x0090-0x009f]
[    0.326787] pnp 00:02: [io  0x0024-0x0025]
[    0.326788] pnp 00:02: [io  0x0028-0x0029]
[    0.326790] pnp 00:02: [io  0x002c-0x002d]
[    0.326791] pnp 00:02: [io  0x0030-0x0031]
[    0.326793] pnp 00:02: [io  0x0034-0x0035]
[    0.326794] pnp 00:02: [io  0x0038-0x0039]
[    0.326796] pnp 00:02: [io  0x003c-0x003d]
[    0.326797] pnp 00:02: [io  0x00a4-0x00a5]
[    0.326798] pnp 00:02: [io  0x00a8-0x00a9]
[    0.326800] pnp 00:02: [io  0x00ac-0x00ad]
[    0.326801] pnp 00:02: [io  0x00b0-0x00b5]
[    0.326803] pnp 00:02: [io  0x00b8-0x00b9]
[    0.326805] pnp 00:02: [io  0x00bc-0x00bd]
[    0.326806] pnp 00:02: [io  0x0050-0x0053]
[    0.326808] pnp 00:02: [io  0x0072-0x0077]
[    0.326809] pnp 00:02: [io  0x0400-0x047f]
[    0.326811] pnp 00:02: [io  0x0500-0x057f]
[    0.326812] pnp 00:02: [io  0x0800-0x080f]
[    0.326813] pnp 00:02: [io  0x15e0-0x15ef]
[    0.326815] pnp 00:02: [io  0x1600-0x167f]
[    0.326816] pnp 00:02: [mem 0xf8000000-0xfbffffff]
[    0.326818] pnp 00:02: [mem 0x00000000-0x00000fff]
[    0.326820] pnp 00:02: [mem 0xfed1c000-0xfed1ffff]
[    0.326821] pnp 00:02: [mem 0xfed10000-0xfed13fff]
[    0.326823] pnp 00:02: [mem 0xfed18000-0xfed18fff]
[    0.326824] pnp 00:02: [mem 0xfed19000-0xfed19fff]
[    0.326826] pnp 00:02: [mem 0xfed45000-0xfed4bfff]
[    0.326873] system 00:02: [io  0x0400-0x047f] has been reserved
[    0.326934] system 00:02: [io  0x0500-0x057f] has been reserved
[    0.326995] system 00:02: [io  0x0800-0x080f] has been reserved
[    0.327056] system 00:02: [io  0x15e0-0x15ef] has been reserved
[    0.327116] system 00:02: [io  0x1600-0x167f] has been reserved
[    0.327177] system 00:02: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.327239] system 00:02: [mem 0x00000000-0x00000fff] could not be reserved
[    0.327302] system 00:02: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.327364] system 00:02: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.327426] system 00:02: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.327487] system 00:02: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.327550] system 00:02: [mem 0xfed45000-0xfed4bfff] has been reserved
[    0.327611] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.327649] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    0.327672] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.327679] pnp 00:04: [io  0x0000-0x000f]
[    0.327681] pnp 00:04: [io  0x0080-0x008f]
[    0.327682] pnp 00:04: [io  0x00c0-0x00df]
[    0.327684] pnp 00:04: [dma 4]
[    0.327705] pnp 00:04: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.327712] pnp 00:05: [io  0x0061]
[    0.327733] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.327740] pnp 00:06: [io  0x00f0]
[    0.327750] pnp 00:06: [irq 13]
[    0.327772] pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.327779] pnp 00:07: [io  0x0070-0x0071]
[    0.327785] pnp 00:07: [irq 8]
[    0.327806] pnp 00:07: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.327813] pnp 00:08: [io  0x0060]
[    0.327815] pnp 00:08: [io  0x0064]
[    0.327820] pnp 00:08: [irq 1]
[    0.327842] pnp 00:08: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.327853] pnp 00:09: [irq 12]
[    0.327877] pnp 00:09: Plug and Play ACPI device, IDs LEN0020 PNP0f13 (active)
[    0.327906] pnp 00:0a: [mem 0xfed40000-0xfed44fff]
[    0.327930] pnp 00:0a: Plug and Play ACPI device, IDs SMO1200 PNP0c31 (active)
[    0.328443] pnp: PnP ACPI: found 11 devices
[    0.328502] ACPI: ACPI bus type pnp unregistered
[    0.334892] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.334968] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.335033] pci 0000:00:1c.1:   bridge window [mem 0xf2500000-0xf25fffff]
[    0.335105] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.335166] pci 0000:00:1c.3:   bridge window [io  0x4000-0x4fff]
[    0.335232] pci 0000:00:1c.3:   bridge window [mem 0xf1d00000-0xf24fffff]
[    0.335298] pci 0000:00:1c.3:   bridge window [mem 0xf0400000-0xf0bfffff 64bit pref]
[    0.335379] pci 0000:00:1c.4: PCI bridge to [bus 0d-0d]
[    0.335440] pci 0000:00:1c.4:   bridge window [io  0x3000-0x3fff]
[    0.335503] pci 0000:00:1c.4:   bridge window [mem 0xf1500000-0xf1cfffff]
[    0.335567] pci 0000:00:1c.4:   bridge window [mem 0xf0c00000-0xf13fffff 64bit pref]
[    0.335646] pci 0000:00:1c.6: PCI bridge to [bus 0e-0e]
[    0.335709] pci 0000:00:1c.6:   bridge window [mem 0xf1400000-0xf14fffff]
[    0.335826] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.335828] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.335829] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.335831] pci_bus 0000:00: resource 7 [mem 0xdfa00000-0xfebfffff]
[    0.335833] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed4bfff]
[    0.335835] pci_bus 0000:03: resource 1 [mem 0xf2500000-0xf25fffff]
[    0.335837] pci_bus 0000:05: resource 0 [io  0x4000-0x4fff]
[    0.335839] pci_bus 0000:05: resource 1 [mem 0xf1d00000-0xf24fffff]
[    0.335840] pci_bus 0000:05: resource 2 [mem 0xf0400000-0xf0bfffff 64bit pref]
[    0.335842] pci_bus 0000:0d: resource 0 [io  0x3000-0x3fff]
[    0.335844] pci_bus 0000:0d: resource 1 [mem 0xf1500000-0xf1cfffff]
[    0.335846] pci_bus 0000:0d: resource 2 [mem 0xf0c00000-0xf13fffff 64bit pref]
[    0.335848] pci_bus 0000:0e: resource 1 [mem 0xf1400000-0xf14fffff]
[    0.335933] NET: Registered protocol family 2
[    0.336051] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.337165] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.337744] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.337925] TCP: Hash tables configured (established 262144 bind 65536)
[    0.337987] TCP: reno registered
[    0.338043] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.338142] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    0.338297] NET: Registered protocol family 1
[    0.338464] RPC: Registered named UNIX socket transport module.
[    0.338524] RPC: Registered udp transport module.
[    0.339897] RPC: Registered tcp transport module.
[    0.339955] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.340024] pci 0000:00:02.0: Boot video device
[    0.340039] pci 0000:00:1a.0: power state changed by ACPI to D0
[    0.340102] pci 0000:00:1a.0: power state changed by ACPI to D0
[    0.340215] pci 0000:00:1d.0: power state changed by ACPI to D0
[    0.340277] pci 0000:00:1d.0: power state changed by ACPI to D0
[    0.340551] PCI: CLS 64 bytes, default 64
[    0.345561] DMAR: No ATSR found
[    0.345655] IOMMU 0 0xfed90000: using Queued invalidation
[    0.345714] IOMMU 1 0xfed91000: using Queued invalidation
[    0.345775] IOMMU: Setting RMRR:
[    0.345841] IOMMU: Setting identity map for device 0000:00:02.0 [0xdb800000 - 0xdf9fffff]
[    0.346310] IOMMU: Setting identity map for device 0000:00:1d.0 [0xdacd5000 - 0xdacebfff]
[    0.346403] IOMMU: Setting identity map for device 0000:00:1a.0 [0xdacd5000 - 0xdacebfff]
[    0.346487] IOMMU: Prepare 0-16MiB unity mapping for LPC
[    0.346551] IOMMU: Setting identity map for device 0000:00:1f.0 [0x0 - 0xffffff]
[    0.346924] PCI-DMA: Intel(R) Virtualization Technology for Directed I/O
[    0.350052] sha1_ssse3: Using AVX optimized SHA-1 implementation
[    0.350296] audit: initializing netlink socket (disabled)
[    0.350364] type=2000 audit(1341670497.236:1): initialized
[    0.350640] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.351428] NFS: Registering the id_resolver key type
[    0.351590] nfs4filelayout_init: NFSv4 File Layout Driver Registering...
[    0.351735] fuse init (API version 7.18)
[    0.351884] msgmni has been set to 15859
[    0.353136] NET: Registered protocol family 38
[    0.353218] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.353311] io scheduler noop registered
[    0.353369] io scheduler deadline registered
[    0.353450] io scheduler cfq registered (default)
[    0.353870] crc32: CRC_LE_BITS = 64, CRC_BE BITS = 64
[    0.353929] crc32: self tests passed, processed 225944 bytes in 179073 nsec
[    0.354187] crc32c: CRC_LE_BITS = 64
[    0.354245] crc32c: self tests passed, processed 225944 bytes in 97778 nsec
[    0.354693] intel_idle: MWAIT substates: 0x21120
[    0.354694] intel_idle: v0.4 model 0x2A
[    0.354695] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.354909] ACPI: Deprecated procfs I/F for AC is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    0.355191] ACPI: AC Adapter [AC] (on-line)
[    0.355383] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
[    0.355662] ACPI: Lid Switch [LID]
[    0.355752] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
[    0.355829] ACPI: Sleep Button [SLPB]
[    0.355924] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    0.355998] ACPI: Power Button [PWRF]
[    0.356198] ACPI: Requesting acpi_cpufreq
[    0.361304] thermal LNXTHERM:00: registered as thermal_zone0
[    0.361364] ACPI: Thermal Zone [THM0] (34 C)
[    0.361481] GHES: HEST is not enabled!
[    0.361809] Non-volatile memory driver v1.3
[    0.361890] Linux agpgart interface v0.103
[    0.362058] agpgart-intel 0000:00:00.0: Intel Sandybridge Chipset
[    0.362279] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[    0.363539] agpgart-intel 0000:00:00.0: detected 65536K stolen memory
[    0.363738] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
[    0.363920] tpm_tis 00:0a: 1.2 TPM (device-id 0x0, rev-id 78)
[    0.376530] ACPI: Deprecated procfs I/F for battery is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    0.376615] ACPI: Battery Slot [BAT0] (battery present)
[    0.391105] ACPI: Deprecated procfs I/F for battery is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    0.391188] ACPI: Battery Slot [BAT1] (battery present)
[    0.422058] tpm_tis 00:0a: A TPM error (6) occurred attempting to read a pcr value
[    0.422175] tpm_tis 00:0a: TPM is disabled/deactivated (0x6)
[    0.422256] ramoops: platform device not found, using module parameters
[    0.422333] ramoops: The memory size and the record size must be non-zero
[    0.422397] ramoops: probe of ramoops failed with error -22
[    0.422486] [drm] Initialized drm 1.1.0 20060810
[    0.422565] i915 0000:00:02.0: power state changed by ACPI to D0
[    0.422626] i915 0000:00:02.0: power state changed by ACPI to D0
[    0.422885] i915 0000:00:02.0: setting latency timer to 64
[    0.455807] mtrr: no more MTRRs available
[    0.455864] [drm] MTRR allocation failed.  Graphics performance may suffer.
[    0.456066] i915 0000:00:02.0: irq 42 for MSI/MSI-X
[    0.456073] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    0.456135] [drm] Driver supports precise vblank timestamp query.
[    0.456238] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    0.795599] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[    1.048965] fbcon: inteldrmfb (fb0) is primary device
[    1.343556] Console: switching to colour frame buffer device 170x48
[    1.344844] Refined TSC clocksource calibration: 2691.259 MHz.
[    1.344847] Switching to clocksource tsc
[    1.346670] fb0: inteldrmfb frame buffer device
[    1.346671] drm: registered panic notifier
[    1.349016] acpi device:01: registered as cooling_device4
[    1.349159] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input3
[    1.349210] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    1.349273] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    1.349863] loop: module loaded
[    1.350169] drbd: initialized. Version: 8.3.11 (api:88/proto:86-96)
[    1.350203] drbd: built-in
[    1.350221] drbd: registered as block device major 147
[    1.350251] drbd: minor_table @ 0xffff88021466e2c0
[    1.350335] ahci 0000:00:1f.2: version 3.0
[    1.350382] ahci 0000:00:1f.2: irq 43 for MSI/MSI-X
[    1.350442] ahci: SSS flag set, parallel bus scan disabled
[    1.364836] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x13 impl SATA mode
[    1.364947] ahci 0000:00:1f.2: flags: 64bit ncq sntf ilck stag pm led clo pio slum part ems sxs apst 
[    1.364996] ahci 0000:00:1f.2: setting latency timer to 64
[    1.381212] scsi0 : ahci
[    1.381302] scsi1 : ahci
[    1.382406] scsi2 : ahci
[    1.383487] scsi3 : ahci
[    1.384551] scsi4 : ahci
[    1.385598] scsi5 : ahci
[    1.387146] ata1: SATA max UDMA/133 abar m2048@0xf2628000 port 0xf2628100 irq 43
[    1.388156] ata2: SATA max UDMA/133 abar m2048@0xf2628000 port 0xf2628180 irq 43
[    1.389158] ata3: DUMMY
[    1.390137] ata4: DUMMY
[    1.391102] ata5: SATA max UDMA/133 abar m2048@0xf2628000 port 0xf2628300 irq 43
[    1.392095] ata6: DUMMY
[    1.393287] HSI/SSI char device loaded
[    1.394409] tun: Universal TUN/TAP device driver, 1.6
[    1.395397] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    1.396420] e1000e: Intel(R) PRO/1000 Network Driver - 1.9.5-k
[    1.397412] e1000e: Copyright(c) 1999 - 2012 Intel Corporation.
[    1.398418] e1000e 0000:00:19.0: setting latency timer to 64
[    1.398479] e1000e 0000:00:19.0: (unregistered net_device): Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    1.399533] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[    1.645608] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GT/s:Width x1) f0:de:f1:7f:40:cb
[    1.646636] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    1.647682] e1000e 0000:00:19.0: eth0: MAC: 10, PHY: 11, PBA No: 1000FF-0FF
[    1.648708] PPP generic driver version 2.4.2
[    1.649734] PPP BSD Compression module registered
[    1.650734] PPP Deflate Compression module registered
[    1.652184] PPP MPPE Compression module registered
[    1.653219] NET: Registered protocol family 24
[    1.654235] Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:d
[    1.655257] Copyright(c) 2003-2012 Intel Corporation
[    1.656380] iwlwifi 0000:03:00.0: pci_resource_len = 0x00002000
[    1.657419] iwlwifi 0000:03:00.0: pci_resource_base = ffffc9000007c000
[    1.658448] iwlwifi 0000:03:00.0: HW Revision ID = 0x34
[    1.659551] iwlwifi 0000:03:00.0: irq 45 for MSI/MSI-X
[    1.659621] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.660659] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    1.661662] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    1.662661] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    1.662664] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    1.663649] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    1.664666] ehci_hcd 0000:00:1a.0: debug port 2
[    1.669507] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[    1.669522] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xf262a000
[    1.680393] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    1.681458] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.682436] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.683409] usb usb1: Product: EHCI Host Controller
[    1.684363] usb usb1: Manufacturer: Linux 3.4.4-local.20120627-224004 ehci_hcd
[    1.685321] usb usb1: SerialNumber: 0000:00:1a.0
[    1.686354] hub 1-0:1.0: USB hub found
[    1.687333] hub 1-0:1.0: 3 ports detected
[    1.688384] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    1.689399] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    1.690420] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    1.690423] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    1.691418] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    1.692467] ehci_hcd 0000:00:1d.0: debug port 2
[    1.697332] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[    1.697345] ehci_hcd 0000:00:1d.0: irq 23, io mem 0xf2629000
[    1.708360] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    1.709453] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    1.710448] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.711449] usb usb2: Product: EHCI Host Controller
[    1.712350] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.712669] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    1.712671] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    1.712673] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    1.712939] ata1.00: ATA-8: INTEL SSDSA2BW160G3L, 4PC1LE04, max UDMA/133
[    1.712941] ata1.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    1.713263] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    1.713265] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    1.713267] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    1.713533] ata1.00: configured for UDMA/133
[    1.713622] scsi 0:0:0:0: Direct-Access     ATA      INTEL SSDSA2BW16 4PC1 PQ: 0 ANSI: 5
[    1.713728] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.713737] sd 0:0:0:0: [sda] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[    1.713815] sd 0:0:0:0: [sda] Write Protect is off
[    1.713817] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.713837] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.714194]  sda: sda1 sda2 sda3 sda4
[    1.714448] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.727451] usb usb2: Manufacturer: Linux 3.4.4-local.20120627-224004 ehci_hcd
[    1.728495] usb usb2: SerialNumber: 0000:00:1d.0
[    1.729595] hub 2-0:1.0: USB hub found
[    1.730615] hub 2-0:1.0: 3 ports detected
[    1.731696] uhci_hcd: USB Universal Host Controller Interface driver
[    1.732792] xhci_hcd 0000:0e:00.0: xHCI Host Controller
[    1.733833] xhci_hcd 0000:0e:00.0: new USB bus registered, assigned bus number 3
[    1.735063] xhci_hcd 0000:0e:00.0: irq 18, io mem 0xf1400000
[    1.736159] xhci_hcd 0000:0e:00.0: irq 46 for MSI/MSI-X
[    1.736164] xhci_hcd 0000:0e:00.0: irq 47 for MSI/MSI-X
[    1.736168] xhci_hcd 0000:0e:00.0: irq 48 for MSI/MSI-X
[    1.736173] xhci_hcd 0000:0e:00.0: irq 49 for MSI/MSI-X
[    1.736177] xhci_hcd 0000:0e:00.0: irq 50 for MSI/MSI-X
[    1.736294] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    1.737355] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.738415] usb usb3: Product: xHCI Host Controller
[    1.739460] usb usb3: Manufacturer: Linux 3.4.4-local.20120627-224004 xhci_hcd
[    1.740523] usb usb3: SerialNumber: 0000:0e:00.0
[    1.741614] xHCI xhci_add_endpoint called for root hub
[    1.741616] xHCI xhci_check_bandwidth called for root hub
[    1.741634] hub 3-0:1.0: USB hub found
[    1.742676] hub 3-0:1.0: 2 ports detected
[    1.743763] xhci_hcd 0000:0e:00.0: xHCI Host Controller
[    1.744802] xhci_hcd 0000:0e:00.0: new USB bus registered, assigned bus number 4
[    1.745873] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
[    1.746922] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.747984] usb usb4: Product: xHCI Host Controller
[    1.749053] usb usb4: Manufacturer: Linux 3.4.4-local.20120627-224004 xhci_hcd
[    1.750122] usb usb4: SerialNumber: 0000:0e:00.0
[    1.751232] xHCI xhci_add_endpoint called for root hub
[    1.751233] xHCI xhci_check_bandwidth called for root hub
[    1.751251] hub 4-0:1.0: USB hub found
[    1.752321] hub 4-0:1.0: 2 ports detected
[    1.753478] usbcore: registered new interface driver cdc_acm
[    1.754546] cdc_acm: USB Abstract Control Model driver for USB modems and ISDN adapters
[    1.755641] usbcore: registered new interface driver uas
[    1.756724] Initializing USB Mass Storage driver...
[    1.757819] usbcore: registered new interface driver usb-storage
[    1.758893] USB Mass Storage support registered.
[    1.759991] usbcore: registered new interface driver usbserial
[    1.761078] usbcore: registered new interface driver usbserial_generic
[    1.762149] USB Serial support registered for generic
[    1.763207] usbserial: USB Serial Driver core
[    1.764272] usbcore: registered new interface driver ftdi_sio
[    1.765337] USB Serial support registered for FTDI USB Serial Device
[    1.766411] ftdi_sio: v1.6.0:USB FTDI Serial Converters Driver
[    1.767467] usbcore: registered new interface driver option
[    1.768523] USB Serial support registered for GSM modem (1-port)
[    1.769625] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    1.773891] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.774957] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.776081] mousedev: PS/2 mouse device common for all mice
[    1.777354] rtc_cmos 00:07: RTC can wake from S4
[    1.778500] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    1.779563] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    1.780706] lirc_dev: IR Remote Control driver registered, major 251 
[    1.781770] IR NEC protocol handler initialized
[    1.782826] IR RC5(x) protocol handler initialized
[    1.783879] IR RC6 protocol handler initialized
[    1.784938] IR JVC protocol handler initialized
[    1.786003] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
[    1.787068] IR Sony protocol handler initialized
[    1.788199] IR RC5 (streamzap) protocol handler initialized
[    1.789245] IR SANYO protocol handler initialized
[    1.790287] IR MCE Keyboard/mouse protocol handler initialized
[    1.791343] IR LIRC bridge handler initialized
[    1.792395] gspca_main: v2.14.0 registered
[    1.794384] usbcore: registered new interface driver uvcvideo
[    1.795445] USB Video Class driver (1.1.1)
[    1.796623] device-mapper: uevent: version 1.0.3
[    1.797733] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised: dm-devel@redhat.com
[    1.798874] usbcore: registered new interface driver btusb
[    1.800055] EDAC MC: Ver: 2.1.0
[    1.801238] EDAC DEBUG: edac_sysfs_setup_mc_kset: edac_sysfs_setup_mc_kset()
[    1.801255] EDAC DEBUG: edac_sysfs_setup_mc_kset: edac_sysfs_setup_mc_kset() Registered '.../edac/mc' kobject
[    1.801272] EDAC DEBUG: i7core_init: MC: drivers/edac/i7core_edac.c: i7core_init()
[    1.801288] EDAC DEBUG: sbridge_init: MC: drivers/edac/sb_edac.c: sbridge_init()
[    1.801378] cpuidle: using governor ladder
[    1.802517] cpuidle: using governor menu
[    1.803571] sdhci: Secure Digital Host Controller Interface driver
[    1.804632] sdhci: Copyright(c) Pierre Ossman
[    1.805684] sdhci-pci 0000:0d:00.0: SDHCI controller found [1180:e823] (rev 4)
[    1.807023] Registered led device: mmc0::
[    1.808301] mmc0: SDHCI controller on PCI [0000:0d:00.0] using DMA
[    1.809927] EFI Variables Facility v0.08 2004-May-17
[    1.811160] usbcore: registered new interface driver usbhid
[    1.812211] usbhid: USB HID core driver
[    1.813434] thinkpad_acpi: ThinkPad ACPI Extras v0.24
[    1.814608] thinkpad_acpi: http://ibm-acpi.sf.net/
[    1.815649] thinkpad_acpi: ThinkPad BIOS 8DET59WW (1.29 ), EC unknown
[    1.816703] thinkpad_acpi: Lenovo ThinkPad X220, model 4290CTO
[    1.818320] thinkpad_acpi: detected a 8-level brightness capable ThinkPad
[    1.819543] thinkpad_acpi: radio switch found; radios are enabled
[    1.820850] thinkpad_acpi: possible tablet mode switch found; ThinkPad in laptop mode
[    1.823841] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is unblocked
[    1.826165] thinkpad_acpi: rfkill switch tpacpi_wwan_sw: radio is unblocked
[    1.827507] Registered led device: tpacpi::thinklight
[    1.827529] Registered led device: tpacpi::power
[    1.827542] Registered led device: tpacpi::standby
[    1.827554] Registered led device: tpacpi::thinkvantage
[    1.827560] thinkpad_acpi: Standard ACPI backlight interface available, not loading native one
[    1.828732] thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
[    1.830722] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input5
[    1.832753] snd_hda_intel 0000:00:1b.0: irq 51 for MSI/MSI-X
[    1.996029] usb 1-1: new high-speed USB device number 2 using ehci_hcd
[    2.010489] mmc0: new ultra high speed SDR50 SDXC card at address e624
[    2.011723] mmcblk0: mmc0:e624 SU64G 59.4 GiB 
[    2.028420]  mmcblk0:
[    2.040010] ata2: SATA link down (SStatus 0 SControl 300)
[    2.128777] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
[    2.129849] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.131370] hub 1-1:1.0: USB hub found
[    2.132661] hub 1-1:1.0: 6 ports detected
[    2.247764] usb 2-1: new high-speed USB device number 2 using ehci_hcd
[    2.359611] ata5: SATA link down (SStatus 0 SControl 300)
[    2.375408] input: HDA Intel PCH HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input6
[    2.376609] input: HDA Intel PCH HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input7
[    2.377736] input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
[    2.379633] Netfilter messages via NETLINK v0.30.
[    2.379875] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
[    2.379878] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.380019] hub 2-1:1.0: USB hub found
[    2.380121] hub 2-1:1.0: 8 ports detected
[    2.384933] nfnl_acct: registering with nfnetlink.
[    2.385971] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    2.387144] ctnetlink v0.93: registering with nfnetlink.
[    2.388200] NF_TPROXY: Transparent proxy support initialized, version 4.1.0
[    2.389271] NF_TPROXY: Copyright (c) 2006-2007 BalaBit IT Ltd.
[    2.390395] xt_time: kernel timezone is -0000
[    2.391467] ip_set: protocol 6
[    2.392702] ip_tables: (C) 2000-2006 Netfilter Core Team
[    2.393850] ipt_CLUSTERIP: ClusterIP Version 0.8 loaded successfully
[    2.394912] arp_tables: (C) 2002 David S. Miller
[    2.396012] TCP: cubic registered
[    2.397052] Initializing XFRM netlink socket
[    2.398264] NET: Registered protocol family 10
[    2.399648] Mobile IPv6
[    2.400689] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    2.401903] IPv6 over IPv4 tunneling driver
[    2.403152] NET: Registered protocol family 17
[    2.404203] NET: Registered protocol family 15
[    2.405309] Bridge firewalling registered
[    2.406325] Ebtables v2.0 registered
[    2.407403] Bluetooth: RFCOMM TTY layer initialized
[    2.408420] Bluetooth: RFCOMM socket layer initialized
[    2.409414] Bluetooth: RFCOMM ver 1.11
[    2.410384] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    2.411345] Bluetooth: BNEP filters: protocol multicast
[    2.412297] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[    2.413273] 8021q: 802.1Q VLAN Support v1.8
[    2.414225] lib80211: common routines for IEEE802.11 drivers
[    2.415183] lib80211_crypt: registered algorithm 'NULL'
[    2.415185] Registering the dns_resolver key type
[    2.416385] registered taskstats version 1
[    2.419379] rtc_cmos 00:07: setting system clock to 2012-07-07 14:14:59 UTC (1341670499)
[    2.428567] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    2.429556] EDD information not available.
[    2.430570] Initializing network drop monitor service
[    2.431801] ALSA device list:
[    2.433060]   #0: HDA Intel PCH at 0xf2620000 irq 51
[    2.434286]   #29: ThinkPad Console Audio Control at EC reg 0x30, fw unknown
[    2.438895] Freeing unused kernel memory: 7136k freed
[    2.451629] usb 1-1.3: new full-speed USB device number 3 using ehci_hcd
[    2.499878] Sat Jul  7 14:14:59 2012:   5 logical volume(s) in volume group "b" now active
[    2.507153] EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: (null)
[    2.534147] Sat Jul  7 14:14:59 2012: Switching root to '/dev/mapper/b-root' and initiating '/sbin/init'...
[    2.545769] usb 1-1.3: New USB device found, idVendor=147e, idProduct=2016
[    2.549366] usb 1-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.552631] usb 1-1.3: Product: Biometric Coprocessor
[    2.555859] usb 1-1.3: Manufacturer: UPEK
[    2.631344] usb 1-1.4: new full-speed USB device number 4 using ehci_hcd
[    2.688628] psmouse serio1: synaptics: Touchpad model: 1, fw: 8.0, id: 0x1e2b1, caps: 0xd001a3/0x940300/0x120c00
[    2.692384] psmouse serio1: synaptics: serio: Synaptics pass-through port at isa0060/serio1/input0
[    2.728724] usb 1-1.4: New USB device found, idVendor=0a5c, idProduct=217f
[    2.732089] usb 1-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    2.735683] usb 1-1.4: Product: Broadcom Bluetooth Device
[    2.739422] usb 1-1.4: Manufacturer: Broadcom Corp
[    2.743111] usb 1-1.4: SerialNumber: CCAF78E7B559
[    2.749699] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input9
[    2.815287] usb 1-1.6: new high-speed USB device number 5 using ehci_hcd
[    2.917661] usb 1-1.6: New USB device found, idVendor=04f2, idProduct=b217
[    2.919157] usb 1-1.6: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.920575] usb 1-1.6: Product: Integrated Camera
[    2.921993] usb 1-1.6: Manufacturer: Chicony Electronics Co., Ltd.
[    2.924208] uvcvideo: Found UVC 1.00 device Integrated Camera (04f2:b217)
[    2.927267] input: Integrated Camera as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.6/1-1.6:1.0/input/input10
[    2.961604] iwlwifi 0000:03:00.0: loaded firmware version 17.168.5.3 build 42301
[    2.962060] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUG enabled
[    2.964924] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUGFS disabled
[    2.966489] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TRACING enabled
[    2.968050] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE enabled
[    2.969603] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_P2P disabled
[    2.971186] iwlwifi 0000:03:00.0: Detected Intel(R) Centrino(R) Advanced-N 6205 AGN, REV=0xB0
[    2.972596] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
[    2.982819] iwlwifi 0000:03:00.0: device EEPROM VER=0x715, CALIB=0x6
[    2.983921] iwlwifi 0000:03:00.0: Device SKU: 0x1F0
[    2.984983] iwlwifi 0000:03:00.0: Valid Tx ant: 0x3, Valid Rx ant: 0x3
[    2.986057] iwlwifi 0000:03:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
[    2.987168] Registered led device: phy0-led
[    2.987224] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[    2.998941] usb 2-1.4: new high-speed USB device number 3 using ehci_hcd
[    3.099976] usb 2-1.4: New USB device found, idVendor=0bdb, idProduct=1911
[    3.103757] usb 2-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    3.107503] usb 2-1.4: Product: F5521gw
[    3.107508] usb 2-1.4: Manufacturer: Lenovo
[    3.107511] usb 2-1.4: SerialNumber: D4AFA81F2EED28D0
[    3.141989] cdc_acm 2-1.4:1.1: ttyACM0: USB ACM device
[    3.149545] cdc_acm 2-1.4:1.3: ttyACM1: USB ACM device
[    3.159007] cdc_acm 2-1.4:1.9: ttyACM2: USB ACM device
[    3.275760] EXT4-fs (dm-0): re-mounted. Opts: (null)
[    3.326973] EXT4-fs (dm-0): re-mounted. Opts: discard,errors=remount-ro
[    3.913211] Adding 974844k swap on /dev/mapper/b-swap.  Priority:-1 extents:1 across:974844k SS
[    3.969222] EXT4-fs (dm-1): mounted filesystem with ordered data mode. Opts: discard
[    3.974876] EXT4-fs (dm-3): mounted filesystem with ordered data mode. Opts: discard
[    3.980921] EXT4-fs (dm-4): mounted filesystem with ordered data mode. Opts: discard
[    5.449201] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[    5.505522] input: ACPI Virtual Keyboard Device as /devices/virtual/input/input11
[    5.551451] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[    5.552026] ADDRCONF(NETDEV_UP): eth0: link is not ready
[    5.555988] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
[    5.557411] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[    5.846647] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
[    5.846773] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[    5.964775] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[    8.730513] psmouse serio2: trackpoint: IBM TrackPoint firmware: 0x0e, buttons: 3/3
[    8.982232] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/serio2/input/input12
[   12.303077] wlan0: authenticate with 00:04:ed:94:ea:de
[   12.322819] wlan0: send auth to 00:04:ed:94:ea:de (try 1/3)
[   12.324784] wlan0: authenticated
[   12.326756] wlan0: associate with 00:04:ed:94:ea:de (try 1/3)
[   12.334107] wlan0: RX AssocResp from 00:04:ed:94:ea:de (capab=0x411 status=0 aid=2)
[   12.334118] wlan0: associated
[   12.343335] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   36.452690] generic-bluetooth 0005:046D:B006.0001: unknown main item tag 0x0
[   36.452907] input: Dell BT Travel Mouse as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.4/1-1.4:1.0/bluetooth/hci0/hci0:11/input13
[   36.453245] generic-bluetooth 0005:046D:B006.0001: input,hidraw0: BLUETOOTH HID v1.24 Mouse [Dell BT Travel Mouse] on CC:AF:78:E7:B5:59
[  693.771596] process `skype' is using obsolete setsockopt SO_BSDCOMPAT
[ 2726.163121] generic-bluetooth 0005:046D:B006.0002: unknown main item tag 0x0
[ 2726.163453] input: Dell BT Travel Mouse as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.4/1-1.4:1.0/bluetooth/hci0/hci0:12/input14
[ 2726.165184] generic-bluetooth 0005:046D:B006.0002: input,hidraw0: BLUETOOTH HID v1.24 Mouse [Dell BT Travel Mouse] on CC:AF:78:E7:B5:59
[11637.087633] blockdev: sending ioctl 125d to a partition!
[11637.087644] blockdev: sending ioctl 125d to a partition!
[11637.092785] blockdev: sending ioctl 125d to a partition!
[11637.092789] blockdev: sending ioctl 125d to a partition!
[24395.829385] cfg80211: Calling CRDA to update world regulatory domain
[24399.060578] wlan0: authenticate with 00:04:ed:94:ea:de
[24399.062767] wlan0: send auth to 00:04:ed:94:ea:de (try 1/3)
[24399.264556] wlan0: send auth to 00:04:ed:94:ea:de (try 2/3)
[24399.468283] wlan0: send auth to 00:04:ed:94:ea:de (try 3/3)
[24399.672034] wlan0: authentication with 00:04:ed:94:ea:de timed out
[24399.672949] iwlwifi 0000:03:00.0: ACTIVATE a non DRIVER active station id 0 addr 00:04:ed:94:ea:de
[24402.930148] wlan0: authenticate with 00:04:ed:94:ea:de
[24402.932576] wlan0: direct probe to 00:04:ed:94:ea:de (try 1/3)
[24403.135580] wlan0: direct probe to 00:04:ed:94:ea:de (try 2/3)
[24403.339314] wlan0: direct probe to 00:04:ed:94:ea:de (try 3/3)
[24403.543046] wlan0: authentication with 00:04:ed:94:ea:de timed out
[24403.547483] iwlwifi 0000:03:00.0: ACTIVATE a non DRIVER active station id 0 addr 00:04:ed:94:ea:de
[24415.025546] wlan0: authenticate with 00:04:ed:94:ea:de
[24415.026469] wlan0: send auth to 00:04:ed:94:ea:de (try 1/3)
[24415.028414] wlan0: authenticated
[24415.032236] wlan0: associate with 00:04:ed:94:ea:de (try 1/3)
[24415.039577] wlan0: RX AssocResp from 00:04:ed:94:ea:de (capab=0x411 status=0 aid=2)
[24415.039587] wlan0: associated
[24463.762850] wlan0: deauthenticated from 00:04:ed:94:ea:de (Reason: 3)
[24463.777848] cfg80211: Calling CRDA to update world regulatory domain
[24467.056260] wlan0: authenticate with 00:04:ed:94:ea:de
[24467.058207] wlan0: send auth to 00:04:ed:94:ea:de (try 1/3)
[24467.060177] wlan0: authenticated
[24467.061319] wlan0: associate with 00:04:ed:94:ea:de (try 1/3)
[24467.068740] wlan0: RX AssocResp from 00:04:ed:94:ea:de (capab=0x411 status=0 aid=2)
[24467.068751] wlan0: associated
[24614.711577] cfg80211: Calling CRDA to update world regulatory domain
[24618.161784] wlan0: authenticate with 00:04:ed:94:ea:de
[24618.163758] wlan0: send auth to 00:04:ed:94:ea:de (try 1/3)
[24618.366726] wlan0: send auth to 00:04:ed:94:ea:de (try 2/3)
[24618.570438] wlan0: send auth to 00:04:ed:94:ea:de (try 3/3)
[24618.774205] wlan0: authentication with 00:04:ed:94:ea:de timed out
[24618.775071] iwlwifi 0000:03:00.0: ACTIVATE a non DRIVER active station id 0 addr 00:04:ed:94:ea:de
[24622.031768] wlan0: authenticate with 00:04:ed:94:ea:de
[24622.034007] wlan0: direct probe to 00:04:ed:94:ea:de (try 1/3)
[24622.237744] wlan0: direct probe to 00:04:ed:94:ea:de (try 2/3)
[24622.441427] wlan0: direct probe to 00:04:ed:94:ea:de (try 3/3)
[24622.645221] wlan0: authentication with 00:04:ed:94:ea:de timed out
[24622.646044] iwlwifi 0000:03:00.0: ACTIVATE a non DRIVER active station id 0 addr 00:04:ed:94:ea:de
[24625.926468] wlan0: authenticate with 00:04:ed:94:ea:de
[24625.928885] wlan0: direct probe to 00:04:ed:94:ea:de (try 1/3)
[24626.128744] wlan0: direct probe to 00:04:ed:94:ea:de (try 2/3)
[24626.332480] wlan0: direct probe to 00:04:ed:94:ea:de (try 3/3)
[24626.536182] wlan0: authentication with 00:04:ed:94:ea:de timed out
[24626.541547] iwlwifi 0000:03:00.0: ACTIVATE a non DRIVER active station id 0 addr 00:04:ed:94:ea:de
[24629.845501] wlan0: authenticate with 00:04:ed:94:ea:de
[24629.847430] wlan0: direct probe to 00:04:ed:94:ea:de (try 1/3)
[24630.047704] wlan0: direct probe to 00:04:ed:94:ea:de (try 2/3)
[24630.251438] wlan0: direct probe to 00:04:ed:94:ea:de (try 3/3)
[24630.455134] wlan0: authentication with 00:04:ed:94:ea:de timed out
[24630.500167] iwlwifi 0000:03:00.0: ACTIVATE a non DRIVER active station id 0 addr 00:04:ed:94:ea:de
[24633.747073] wlan0: authenticate with 00:04:ed:94:ea:de
[24633.749282] wlan0: direct probe to 00:04:ed:94:ea:de (try 1/3)
[24633.950645] wlan0: direct probe to 00:04:ed:94:ea:de (try 2/3)
[24634.154368] wlan0: direct probe to 00:04:ed:94:ea:de (try 3/3)
[24634.358155] wlan0: authentication with 00:04:ed:94:ea:de timed out
[24634.358979] iwlwifi 0000:03:00.0: ACTIVATE a non DRIVER active station id 0 addr 00:04:ed:94:ea:de
[24637.590992] wlan0: authenticate with 00:04:ed:94:ea:de
[24637.593272] wlan0: direct probe to 00:04:ed:94:ea:de (try 1/3)
[24637.793741] wlan0: direct probe to 00:04:ed:94:ea:de (try 2/3)
[24637.997474] wlan0: direct probe to 00:04:ed:94:ea:de (try 3/3)
[24638.201165] wlan0: authentication with 00:04:ed:94:ea:de timed out
[24638.202019] iwlwifi 0000:03:00.0: ACTIVATE a non DRIVER active station id 0 addr 00:04:ed:94:ea:de
[24641.477601] wlan0: authenticate with 00:04:ed:94:ea:de
[24641.479898] wlan0: direct probe to 00:04:ed:94:ea:de (try 1/3)
[24641.680739] wlan0: direct probe to 00:04:ed:94:ea:de (try 2/3)
[24641.884426] wlan0: direct probe to 00:04:ed:94:ea:de (try 3/3)
[24642.088173] wlan0: authentication with 00:04:ed:94:ea:de timed out
[24642.093007] iwlwifi 0000:03:00.0: ACTIVATE a non DRIVER active station id 0 addr 00:04:ed:94:ea:de
[24653.574333] wlan0: authenticate with 00:04:ed:94:ea:de
[24653.576322] wlan0: send auth to 00:04:ed:94:ea:de (try 1/3)
[24653.578797] wlan0: authenticated
[24653.581413] wlan0: associate with 00:04:ed:94:ea:de (try 1/3)
[24653.588798] wlan0: RX AssocResp from 00:04:ed:94:ea:de (capab=0x411 status=0 aid=2)
[24653.588809] wlan0: associated
[24662.352325] iwlwifi 0000:03:00.0: RF_KILL bit toggled to disable radio.
[24662.353222] wlan0: deauthenticating from 00:04:ed:94:ea:de by local choice (reason=3)
[24662.354219] iwlwifi 0000:03:00.0: Not sending command - RF KILL
[24662.354592] iwlwifi 0000:03:00.0: Not sending command - RF KILL
[24662.354871] HW problem - can not stop rx aggregation for tid 0
[24662.354900] iwlwifi 0000:03:00.0: Not sending command - RF KILL
[24662.354908] HW problem - can not stop rx aggregation for tid 1
[24662.354925] iwlwifi 0000:03:00.0: Not sending command - RF KILL
[24662.354933] HW problem - can not stop rx aggregation for tid 3
[24662.354950] iwlwifi 0000:03:00.0: Not sending command - RF KILL
[24662.354957] HW problem - can not stop rx aggregation for tid 6
[24662.360144] iwlwifi 0000:03:00.0: Not sending command - RF KILL
[24662.360148] ieee80211 phy0: failed to remove key (0, 00:04:ed:94:ea:de) from hardware (-5)
[24662.360155] usb 1-1.4: USB disconnect, device number 4
[24662.374122] iwlwifi 0000:03:00.0: Not sending command - RF KILL
[24662.374137] iwlwifi 0000:03:00.0: Not sending command - RF KILL
[24662.374151] iwlwifi 0000:03:00.0: Not sending command - RF KILL
[24662.374179] iwlwifi 0000:03:00.0: Not sending command - RF KILL
[24662.374192] iwlwifi 0000:03:00.0: Not sending command - RF KILL
[24662.378067] iwlwifi 0000:03:00.0: Not sending command - RF KILL
[24662.378073] ieee80211 phy0: failed to remove key (1, ff:ff:ff:ff:ff:ff) from hardware (-5)
[24662.378151] cfg80211: Calling CRDA to update world regulatory domain
[24662.382119] iwlwifi 0000:03:00.0: Not sending command - RF KILL
[24662.382137] iwlwifi 0000:03:00.0: Not sending command - RF KILL
[24667.273847] iwlwifi 0000:03:00.0: RF_KILL bit toggled to enable radio.
[24667.278442] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
[24667.278599] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[24667.412175] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[24667.687678] usb 1-1.4: new full-speed USB device number 6 using ehci_hcd
[24667.793042] usb 1-1.4: New USB device found, idVendor=0a5c, idProduct=217f
[24667.793054] usb 1-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[24667.793061] usb 1-1.4: Product: Broadcom Bluetooth Device
[24667.793066] usb 1-1.4: Manufacturer: Broadcom Corp
[24667.793071] usb 1-1.4: SerialNumber: CCAF78E7B559
[24673.761495] wlan0: authenticate with 00:04:ed:94:ea:de
[24673.763483] wlan0: send auth to 00:04:ed:94:ea:de (try 1/3)
[24673.777762] wlan0: authenticated
[24673.779460] wlan0: associate with 00:04:ed:94:ea:de (try 1/3)
[24673.787895] wlan0: RX AssocResp from 00:04:ed:94:ea:de (capab=0x411 status=0 aid=2)
[24673.787906] wlan0: associated
[24673.795777] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[24710.224669] cfg80211: Calling CRDA to update world regulatory domain
[24799.469068] wlan0: authenticate with 00:04:ed:39:c2:d5
[24799.488828] wlan0: send auth to 00:04:ed:39:c2:d5 (try 1/3)
[24799.490724] wlan0: authenticated
[24799.493599] wlan0: associate with 00:04:ed:39:c2:d5 (try 1/3)
[24799.500941] wlan0: RX AssocResp from 00:04:ed:39:c2:d5 (capab=0x411 status=0 aid=1)
[24799.500952] wlan0: associated
[24825.821213] wlan0: deauthenticated from 00:04:ed:39:c2:d5 (Reason: 3)
[24825.831949] cfg80211: Calling CRDA for country: AU
[24829.162728] wlan0: authenticate with 00:04:ed:39:c2:d5
[24829.164790] wlan0: send auth to 00:04:ed:39:c2:d5 (try 1/3)
[24829.166727] wlan0: authenticated
[24829.167395] wlan0: associate with 00:04:ed:39:c2:d5 (try 1/3)
[24829.174783] wlan0: RX AssocResp from 00:04:ed:39:c2:d5 (capab=0x411 status=0 aid=1)
[24829.174794] wlan0: associated
[24899.992591] wlan0: deauthenticating from 00:04:ed:39:c2:d5 by local choice (reason=3)
[24900.006234] cfg80211: Calling CRDA to update world regulatory domain
[24903.286407] wlan0: authenticate with 00:04:ed:94:ea:de
[24903.306175] wlan0: send auth to 00:04:ed:94:ea:de (try 1/3)
[24903.308974] wlan0: authenticated
[24903.312045] wlan0: associate with 00:04:ed:94:ea:de (try 1/3)
[24903.319425] wlan0: RX AssocResp from 00:04:ed:94:ea:de (capab=0x411 status=0 aid=2)
[24903.319436] wlan0: associated
[25127.064021] cfg80211: Calling CRDA to update world regulatory domain
[25131.561765] wlan0: authenticate with 00:04:ed:94:ea:de
[25131.563834] wlan0: send auth to 00:04:ed:94:ea:de (try 1/3)
[25131.765876] wlan0: send auth to 00:04:ed:94:ea:de (try 2/3)
[25131.969615] wlan0: send auth to 00:04:ed:94:ea:de (try 3/3)
[25132.173311] wlan0: authentication with 00:04:ed:94:ea:de timed out
[25132.174177] iwlwifi 0000:03:00.0: ACTIVATE a non DRIVER active station id 0 addr 00:04:ed:94:ea:de
[25135.413390] wlan0: authenticate with 00:04:ed:94:ea:de
[25135.415512] wlan0: direct probe to 00:04:ed:94:ea:de (try 1/3)
[25135.616929] wlan0: direct probe to 00:04:ed:94:ea:de (try 2/3)
[25135.820668] wlan0: direct probe to 00:04:ed:94:ea:de (try 3/3)
[25136.024403] wlan0: authentication with 00:04:ed:94:ea:de timed out
[25136.025355] iwlwifi 0000:03:00.0: ACTIVATE a non DRIVER active station id 0 addr 00:04:ed:94:ea:de
[25139.261355] wlan0: authenticate with 00:04:ed:94:ea:de
[25139.263578] wlan0: direct probe to 00:04:ed:94:ea:de (try 1/3)
[25139.463977] wlan0: direct probe to 00:04:ed:94:ea:de (try 2/3)
[25139.667709] wlan0: direct probe to 00:04:ed:94:ea:de (try 3/3)
[25139.871457] wlan0: authentication with 00:04:ed:94:ea:de timed out
[25139.872352] iwlwifi 0000:03:00.0: ACTIVATE a non DRIVER active station id 0 addr 00:04:ed:94:ea:de
[25143.134616] wlan0: authenticate with 00:04:ed:94:ea:de
[25143.136767] wlan0: direct probe to 00:04:ed:94:ea:de (try 1/3)
[25143.338985] wlan0: direct probe to 00:04:ed:94:ea:de (try 2/3)
[25143.542723] wlan0: direct probe to 00:04:ed:94:ea:de (try 3/3)
[25143.746415] wlan0: authentication with 00:04:ed:94:ea:de timed out
[25143.751395] iwlwifi 0000:03:00.0: ACTIVATE a non DRIVER active station id 0 addr 00:04:ed:94:ea:de
[25147.032223] wlan0: authenticate with 00:04:ed:94:ea:de
[25147.034296] wlan0: direct probe to 00:04:ed:94:ea:de (try 1/3)
[25147.237974] wlan0: direct probe to 00:04:ed:94:ea:de (try 2/3)
[25147.441703] wlan0: direct probe to 00:04:ed:94:ea:de (try 3/3)
[25147.645387] wlan0: authentication with 00:04:ed:94:ea:de timed out
[25147.646238] iwlwifi 0000:03:00.0: ACTIVATE a non DRIVER active station id 0 addr 00:04:ed:94:ea:de
[25150.882072] wlan0: authenticate with 00:04:ed:94:ea:de
[25150.883886] wlan0: direct probe to 00:04:ed:94:ea:de (try 1/3)
[25151.084983] wlan0: direct probe to 00:04:ed:94:ea:de (try 2/3)
[25151.288758] wlan0: direct probe to 00:04:ed:94:ea:de (try 3/3)
[25151.492491] wlan0: authentication with 00:04:ed:94:ea:de timed out
[25151.493375] iwlwifi 0000:03:00.0: ACTIVATE a non DRIVER active station id 0 addr 00:04:ed:94:ea:de
[25154.746788] wlan0: authenticate with 00:04:ed:94:ea:de
[25154.747614] wlan0: direct probe to 00:04:ed:94:ea:de (try 1/3)
[25154.948059] wlan0: direct probe to 00:04:ed:94:ea:de (try 2/3)
[25155.151788] wlan0: direct probe to 00:04:ed:94:ea:de (try 3/3)
[25155.355482] wlan0: authentication with 00:04:ed:94:ea:de timed out
[25155.356391] iwlwifi 0000:03:00.0: ACTIVATE a non DRIVER active station id 0 addr 00:04:ed:94:ea:de
[25158.604371] wlan0: authenticate with 00:04:ed:94:ea:de
[25158.606469] wlan0: direct probe to 00:04:ed:94:ea:de (try 1/3)
[25158.807089] wlan0: direct probe to 00:04:ed:94:ea:de (try 2/3)
[25159.010782] wlan0: direct probe to 00:04:ed:94:ea:de (try 3/3)
[25159.214566] wlan0: authentication with 00:04:ed:94:ea:de timed out
[25159.215442] iwlwifi 0000:03:00.0: ACTIVATE a non DRIVER active station id 0 addr 00:04:ed:94:ea:de
[25507.419932] wlan0: authenticate with 00:04:ed:94:ea:de
[25507.422096] wlan0: send auth to 00:04:ed:94:ea:de (try 1/3)
[25507.424218] wlan0: authenticated
[25507.426782] wlan0: associate with 00:04:ed:94:ea:de (try 1/3)
[25507.434078] wlan0: RX AssocResp from 00:04:ed:94:ea:de (capab=0x411 status=0 aid=2)
[25507.434089] wlan0: associated
[25626.469916] cfg80211: Calling CRDA to update world regulatory domain
[25629.742695] wlan0: authenticate with 00:04:ed:94:ea:de
[25629.744687] wlan0: send auth to 00:04:ed:94:ea:de (try 1/3)
[25629.945189] wlan0: send auth to 00:04:ed:94:ea:de (try 2/3)
[25630.148917] wlan0: send auth to 00:04:ed:94:ea:de (try 3/3)
[25630.352662] wlan0: authentication with 00:04:ed:94:ea:de timed out
[25630.353535] iwlwifi 0000:03:00.0: ACTIVATE a non DRIVER active station id 0 addr 00:04:ed:94:ea:de
[25633.637113] wlan0: authenticate with 00:04:ed:94:ea:de
[25633.639230] wlan0: direct probe to 00:04:ed:94:ea:de (try 1/3)
[25633.840175] wlan0: direct probe to 00:04:ed:94:ea:de (try 2/3)
[25634.043904] wlan0: direct probe to 00:04:ed:94:ea:de (try 3/3)
[25634.177697] iwlwifi 0000:03:00.0: RF_KILL bit toggled to disable radio.
[25634.184582] iwlwifi 0000:03:00.0: Not sending command - RF KILL
[25634.191754] iwlwifi 0000:03:00.0: Not sending command - RF KILL
[25634.191765] iwlwifi 0000:03:00.0: Not sending command - RF KILL
[25634.368063] usb 1-1.4: USB disconnect, device number 6
[25637.760892] iwlwifi 0000:03:00.0: RF_KILL bit toggled to enable radio.
[25637.765170] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
[25637.765327] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[25637.899580] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[25638.174929] usb 1-1.4: new full-speed USB device number 7 using ehci_hcd
[25638.280238] usb 1-1.4: New USB device found, idVendor=0a5c, idProduct=217f
[25638.280250] usb 1-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[25638.280257] usb 1-1.4: Product: Broadcom Bluetooth Device
[25638.280263] usb 1-1.4: Manufacturer: Broadcom Corp
[25638.280267] usb 1-1.4: SerialNumber: CCAF78E7B559
[25644.250102] wlan0: authenticate with 00:04:ed:94:ea:de
[25644.252187] wlan0: direct probe to 00:04:ed:94:ea:de (try 1/3)
[25644.454511] wlan0: send auth to 00:04:ed:94:ea:de (try 2/3)
[25644.455817] wlan0: authenticated
[25644.458509] wlan0: associate with 00:04:ed:94:ea:de (try 1/3)
[25644.465801] wlan0: RX AssocResp from 00:04:ed:94:ea:de (capab=0x411 status=0 aid=1)
[25644.465812] wlan0: associated
[25644.474901] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[25700.166898] cfg80211: Calling CRDA to update world regulatory domain
[25703.423035] wlan0: authenticate with 00:04:ed:94:ea:de
[25703.424908] wlan0: send auth to 00:04:ed:94:ea:de (try 1/3)
[25703.626379] wlan0: send auth to 00:04:ed:94:ea:de (try 2/3)
[25703.830110] wlan0: send auth to 00:04:ed:94:ea:de (try 3/3)
[25704.033851] wlan0: authentication with 00:04:ed:94:ea:de timed out
[25704.034750] iwlwifi 0000:03:00.0: ACTIVATE a non DRIVER active station id 0 addr 00:04:ed:94:ea:de
[25707.316950] wlan0: authenticate with 00:04:ed:94:ea:de
[25707.319024] wlan0: direct probe to 00:04:ed:94:ea:de (try 1/3)
[25707.521370] wlan0: direct probe to 00:04:ed:94:ea:de (try 2/3)
[25707.725097] wlan0: direct probe to 00:04:ed:94:ea:de (try 3/3)
[25707.928843] wlan0: authentication with 00:04:ed:94:ea:de timed out
[25707.929727] iwlwifi 0000:03:00.0: ACTIVATE a non DRIVER active station id 0 addr 00:04:ed:94:ea:de
[25719.389761] wlan0: authenticate with 00:04:ed:94:ea:de
[25719.392986] wlan0: direct probe to 00:04:ed:94:ea:de (try 1/3)
[25719.593777] wlan0: direct probe to 00:04:ed:94:ea:de (try 2/3)
[25719.797573] wlan0: direct probe to 00:04:ed:94:ea:de (try 3/3)
[25720.001300] wlan0: authentication with 00:04:ed:94:ea:de timed out
[25720.002216] iwlwifi 0000:03:00.0: ACTIVATE a non DRIVER active station id 0 addr 00:04:ed:94:ea:de
[25723.282223] wlan0: authenticate with 00:04:ed:94:ea:de
[25723.284138] wlan0: direct probe to 00:04:ed:94:ea:de (try 1/3)
[25723.484787] wlan0: direct probe to 00:04:ed:94:ea:de (try 2/3)
[25723.688560] wlan0: direct probe to 00:04:ed:94:ea:de (try 3/3)
[25723.892261] wlan0: authentication with 00:04:ed:94:ea:de timed out
[25723.897204] iwlwifi 0000:03:00.0: ACTIVATE a non DRIVER active station id 0 addr 00:04:ed:94:ea:de
[25727.204739] wlan0: authenticate with 00:04:ed:94:ea:de
[25727.206759] wlan0: direct probe to 00:04:ed:94:ea:de (try 1/3)
[25727.407778] wlan0: direct probe to 00:04:ed:94:ea:de (try 2/3)
[25727.611512] wlan0: direct probe to 00:04:ed:94:ea:de (try 3/3)
[25727.815196] wlan0: authentication with 00:04:ed:94:ea:de timed out
[25727.816057] iwlwifi 0000:03:00.0: ACTIVATE a non DRIVER active station id 0 addr 00:04:ed:94:ea:de
[25731.091591] wlan0: authenticate with 00:04:ed:94:ea:de
[25731.093646] wlan0: direct probe to 00:04:ed:94:ea:de (try 1/3)
[25731.294745] wlan0: direct probe to 00:04:ed:94:ea:de (try 2/3)
[25731.498517] wlan0: direct probe to 00:04:ed:94:ea:de (try 3/3)
[25731.702250] wlan0: authentication with 00:04:ed:94:ea:de timed out
[25731.703132] iwlwifi 0000:03:00.0: ACTIVATE a non DRIVER active station id 0 addr 00:04:ed:94:ea:de
[25734.961923] wlan0: authenticate with 00:04:ed:94:ea:de
[25734.964039] wlan0: direct probe to 00:04:ed:94:ea:de (try 1/3)
[25735.165797] wlan0: direct probe to 00:04:ed:94:ea:de (try 2/3)
[25735.369510] wlan0: direct probe to 00:04:ed:94:ea:de (try 3/3)
[25735.573224] wlan0: authentication with 00:04:ed:94:ea:de timed out
[25735.578169] iwlwifi 0000:03:00.0: ACTIVATE a non DRIVER active station id 0 addr 00:04:ed:94:ea:de
[25738.902619] wlan0: authenticate with 00:04:ed:94:ea:de
[25738.904602] wlan0: direct probe to 00:04:ed:94:ea:de (try 1/3)
[25739.104679] wlan0: direct probe to 00:04:ed:94:ea:de (try 2/3)
[25739.308465] wlan0: direct probe to 00:04:ed:94:ea:de (try 3/3)
[25739.512193] wlan0: authentication with 00:04:ed:94:ea:de timed out
[25739.513060] iwlwifi 0000:03:00.0: ACTIVATE a non DRIVER active station id 0 addr 00:04:ed:94:ea:de
[25748.328574] wlan0: authenticate with 00:04:ed:39:c2:d5
[25748.348477] wlan0: send auth to 00:04:ed:39:c2:d5 (try 1/3)
[25748.350428] wlan0: authenticated
[25748.352807] wlan0: associate with 00:04:ed:39:c2:d5 (try 1/3)
[25748.360156] wlan0: RX AssocResp from 00:04:ed:39:c2:d5 (capab=0x411 status=0 aid=1)
[25748.360167] wlan0: associated
[25810.392953] iwlwifi 0000:03:00.0: Queue 2 stuck for 10000 ms.
[25810.392964] iwlwifi 0000:03:00.0: Current SW read_ptr 224 write_ptr 254
[25810.392998] iwlwifi 0000:03:00.0: Current HW read_ptr 224 write_ptr 254
[25810.393004] iwlwifi 0000:03:00.0: On demand firmware reload
[25810.395338] iwlwifi 0000:03:00.0: Failing on timeout while stopping DMA channel 1 [0x07fd0001]
[25810.396465] ieee80211 phy0: Hardware restart was requested
[25810.396523] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
[25810.396654] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[25831.091884] wlan0: deauthenticating from 00:04:ed:39:c2:d5 by local choice (reason=3)
[25831.104715] cfg80211: Calling CRDA to update world regulatory domain
[25834.340623] wlan0: authenticate with 00:04:ed:94:ea:de
[25834.360388] wlan0: direct probe to 00:04:ed:94:ea:de (try 1/3)
[25834.561910] wlan0: direct probe to 00:04:ed:94:ea:de (try 2/3)
[25834.765643] wlan0: direct probe to 00:04:ed:94:ea:de (try 3/3)
[25834.969380] wlan0: authentication with 00:04:ed:94:ea:de timed out
[25834.970288] iwlwifi 0000:03:00.0: ACTIVATE a non DRIVER active station id 0 addr 00:04:ed:94:ea:de
[25838.226145] wlan0: authenticate with 00:04:ed:94:ea:de
[25838.229268] wlan0: direct probe to 00:04:ed:94:ea:de (try 1/3)
[25838.432874] wlan0: direct probe to 00:04:ed:94:ea:de (try 2/3)
[25838.636658] wlan0: direct probe to 00:04:ed:94:ea:de (try 3/3)
[25838.840346] wlan0: authentication with 00:04:ed:94:ea:de timed out
[25838.842290] iwlwifi 0000:03:00.0: ACTIVATE a non DRIVER active station id 0 addr 00:04:ed:94:ea:de
[25842.099263] wlan0: authenticate with 00:04:ed:94:ea:de
[25842.101341] wlan0: direct probe to 00:04:ed:94:ea:de (try 1/3)
[25842.303943] wlan0: direct probe to 00:04:ed:94:ea:de (try 2/3)
[25842.507677] wlan0: direct probe to 00:04:ed:94:ea:de (try 3/3)
[25842.711416] wlan0: authentication with 00:04:ed:94:ea:de timed out
[25842.716395] iwlwifi 0000:03:00.0: ACTIVATE a non DRIVER active station id 0 addr 00:04:ed:94:ea:de
[25845.992305] wlan0: authenticate with 00:04:ed:94:ea:de
[25845.994381] wlan0: direct probe to 00:04:ed:94:ea:de (try 1/3)
[25846.194932] wlan0: direct probe to 00:04:ed:94:ea:de (try 2/3)
[25846.398674] wlan0: direct probe to 00:04:ed:94:ea:de (try 3/3)
[25846.602376] wlan0: authentication with 00:04:ed:94:ea:de timed out
[25846.607317] iwlwifi 0000:03:00.0: ACTIVATE a non DRIVER active station id 0 addr 00:04:ed:94:ea:de
[25849.883496] wlan0: authenticate with 00:04:ed:94:ea:de
[25849.887850] wlan0: direct probe to 00:04:ed:94:ea:de (try 1/3)
[25850.089932] wlan0: direct probe to 00:04:ed:94:ea:de (try 2/3)
[25850.293663] wlan0: direct probe to 00:04:ed:94:ea:de (try 3/3)
[25850.497404] wlan0: authentication with 00:04:ed:94:ea:de timed out
[25850.498288] iwlwifi 0000:03:00.0: ACTIVATE a non DRIVER active station id 0 addr 00:04:ed:94:ea:de
[25853.733330] wlan0: authenticate with 00:04:ed:94:ea:de
[25853.735531] wlan0: direct probe to 00:04:ed:94:ea:de (try 1/3)
[25853.936973] wlan0: direct probe to 00:04:ed:94:ea:de (try 2/3)
[25854.140715] wlan0: direct probe to 00:04:ed:94:ea:de (try 3/3)
[25854.344458] wlan0: authentication with 00:04:ed:94:ea:de timed out
[25854.345383] iwlwifi 0000:03:00.0: ACTIVATE a non DRIVER active station id 0 addr 00:04:ed:94:ea:de
[25867.105461] wlan0: authenticate with 00:04:ed:94:ea:de
[25867.107500] wlan0: direct probe to 00:04:ed:94:ea:de (try 1/3)
[25867.307768] wlan0: direct probe to 00:04:ed:94:ea:de (try 2/3)
[25867.511504] wlan0: direct probe to 00:04:ed:94:ea:de (try 3/3)
[25867.715248] wlan0: authentication with 00:04:ed:94:ea:de timed out
[25867.716125] iwlwifi 0000:03:00.0: ACTIVATE a non DRIVER active station id 0 addr 00:04:ed:94:ea:de
[25867.716152] ------------[ cut here ]------------
[25867.716169] WARNING: at drivers/net/wireless/iwlwifi/iwl-agn-sta.c:809 iwl_send_lq_cmd+0x24d/0x265()
[25867.716176] Hardware name: 4290CTO
[25867.716179] Modules linked in:
[25867.716189] Pid: 14958, comm: kworker/u:3 Not tainted 3.4.4-local.20120627-224004 #28
[25867.716194] Call Trace:
[25867.716207]  [<ffffffff8107ea03>] ? warn_slowpath_common+0x76/0x8a
[25867.716218]  [<ffffffff8144d908>] ? iwl_send_lq_cmd+0x24d/0x265
[25867.716229]  [<ffffffff8144dc65>] ? iwl_restore_stations+0x1bc/0x283
[25867.716241]  [<ffffffff81455a10>] ? iwlagn_commit_rxon+0x479/0x6af
[25867.716251]  [<ffffffff81447ea8>] ? iwlagn_set_rxon_chain+0x1b4/0x1f0
[25867.716260]  [<ffffffff814562c8>] ? iwlagn_bss_info_changed+0x2bf/0x512
[25867.716272]  [<ffffffff816f8db3>] ? ieee80211_bss_info_change_notify+0x199/0x22f
[25867.716285]  [<ffffffff81724216>] ? ieee80211_destroy_auth_data+0x44/0x65
[25867.716293]  [<ffffffff81727748>] ? ieee80211_sta_work+0x9f/0x8b0
[25867.716303]  [<ffffffff810a2463>] ? get_parent_ip+0x9/0x1b
[25867.716310]  [<ffffffff810a24e7>] ? sub_preempt_count+0x72/0x98
[25867.716319]  [<ffffffff8174e39d>] ? _raw_spin_unlock_irqrestore+0x10/0x2c
[25867.716327]  [<ffffffff81582630>] ? skb_dequeue+0x50/0x58
[25867.716337]  [<ffffffff810947d1>] ? process_one_work+0x1d0/0x3a3
[25867.716345]  [<ffffffff81092260>] ? cwq_activate_first_delayed+0x9c/0xcd
[25867.716355]  [<ffffffff817040c4>] ? ieee80211_netdev_select_queue+0xc/0xc
[25867.716363]  [<ffffffff81094ca3>] ? worker_thread+0x163/0x243
[25867.716372]  [<ffffffff81094b40>] ? rescuer_thread+0x177/0x177
[25867.716381]  [<ffffffff81097db9>] ? kthread+0x7d/0x85
[25867.716391]  [<ffffffff81750154>] ? kernel_thread_helper+0x4/0x10
[25867.716402]  [<ffffffff81097d3c>] ? kthread_freezable_should_stop+0x41/0x41
[25867.716410]  [<ffffffff81750150>] ? gs_change+0xb/0xb
[25867.716415] ---[ end trace f733293d31d9354a ]---
[25870.947840] wlan0: authenticate with 00:04:ed:94:ea:de
[25870.949857] wlan0: direct probe to 00:04:ed:94:ea:de (try 1/3)
[25871.150830] wlan0: direct probe to 00:04:ed:94:ea:de (try 2/3)
[25871.354562] wlan0: direct probe to 00:04:ed:94:ea:de (try 3/3)
[25871.558303] wlan0: authentication with 00:04:ed:94:ea:de timed out
[25871.559179] iwlwifi 0000:03:00.0: ACTIVATE a non DRIVER active station id 0 addr 00:04:ed:94:ea:de
[25871.559206] ------------[ cut here ]------------
[25871.559222] WARNING: at drivers/net/wireless/iwlwifi/iwl-agn-sta.c:809 iwl_send_lq_cmd+0x24d/0x265()
[25871.559228] Hardware name: 4290CTO
[25871.559232] Modules linked in:
[25871.559241] Pid: 15300, comm: kworker/u:0 Tainted: G        W    3.4.4-local.20120627-224004 #28
[25871.559247] Call Trace:
[25871.559259]  [<ffffffff8107ea03>] ? warn_slowpath_common+0x76/0x8a
[25871.559270]  [<ffffffff8144d908>] ? iwl_send_lq_cmd+0x24d/0x265
[25871.559281]  [<ffffffff8144dc65>] ? iwl_restore_stations+0x1bc/0x283
[25871.559293]  [<ffffffff81455a10>] ? iwlagn_commit_rxon+0x479/0x6af
[25871.559303]  [<ffffffff81447ea8>] ? iwlagn_set_rxon_chain+0x1b4/0x1f0
[25871.559312]  [<ffffffff814562c8>] ? iwlagn_bss_info_changed+0x2bf/0x512
[25871.559324]  [<ffffffff816f8db3>] ? ieee80211_bss_info_change_notify+0x199/0x22f
[25871.559337]  [<ffffffff81724216>] ? ieee80211_destroy_auth_data+0x44/0x65
[25871.559345]  [<ffffffff81727748>] ? ieee80211_sta_work+0x9f/0x8b0
[25871.559354]  [<ffffffff810a2463>] ? get_parent_ip+0x9/0x1b
[25871.559362]  [<ffffffff810a24e7>] ? sub_preempt_count+0x72/0x98
[25871.559370]  [<ffffffff8174e39d>] ? _raw_spin_unlock_irqrestore+0x10/0x2c
[25871.559378]  [<ffffffff81582630>] ? skb_dequeue+0x50/0x58
[25871.559388]  [<ffffffff810947d1>] ? process_one_work+0x1d0/0x3a3
[25871.559396]  [<ffffffff81092260>] ? cwq_activate_first_delayed+0x9c/0xcd
[25871.559405]  [<ffffffff817040c4>] ? ieee80211_netdev_select_queue+0xc/0xc
[25871.559414]  [<ffffffff81094ca3>] ? worker_thread+0x163/0x243
[25871.559422]  [<ffffffff81094b40>] ? rescuer_thread+0x177/0x177
[25871.559432]  [<ffffffff81097db9>] ? kthread+0x7d/0x85
[25871.559441]  [<ffffffff81750154>] ? kernel_thread_helper+0x4/0x10
[25871.559451]  [<ffffffff81097d3c>] ? kthread_freezable_should_stop+0x41/0x41
[25871.559460]  [<ffffffff81750150>] ? gs_change+0xb/0xb
[25871.559465] ---[ end trace f733293d31d9354b ]---
[25874.839735] wlan0: authenticate with 00:04:ed:94:ea:de
[25874.841495] wlan0: direct probe to 00:04:ed:94:ea:de (try 1/3)
[25875.041826] wlan0: direct probe to 00:04:ed:94:ea:de (try 2/3)
[25875.245554] wlan0: direct probe to 00:04:ed:94:ea:de (try 3/3)
[25875.449292] wlan0: authentication with 00:04:ed:94:ea:de timed out
[25875.450179] iwlwifi 0000:03:00.0: ACTIVATE a non DRIVER active station id 0 addr 00:04:ed:94:ea:de
[25875.450207] ------------[ cut here ]------------
[25875.450224] WARNING: at drivers/net/wireless/iwlwifi/iwl-agn-sta.c:809 iwl_send_lq_cmd+0x24d/0x265()
[25875.450230] Hardware name: 4290CTO
[25875.450234] Modules linked in:
[25875.450244] Pid: 14958, comm: kworker/u:3 Tainted: G        W    3.4.4-local.20120627-224004 #28
[25875.450249] Call Trace:
[25875.450262]  [<ffffffff8107ea03>] ? warn_slowpath_common+0x76/0x8a
[25875.450273]  [<ffffffff8144d908>] ? iwl_send_lq_cmd+0x24d/0x265
[25875.450284]  [<ffffffff8144dc65>] ? iwl_restore_stations+0x1bc/0x283
[25875.450296]  [<ffffffff81455a10>] ? iwlagn_commit_rxon+0x479/0x6af
[25875.450306]  [<ffffffff81447ea8>] ? iwlagn_set_rxon_chain+0x1b4/0x1f0
[25875.450315]  [<ffffffff814562c8>] ? iwlagn_bss_info_changed+0x2bf/0x512
[25875.450327]  [<ffffffff816f8db3>] ? ieee80211_bss_info_change_notify+0x199/0x22f
[25875.450341]  [<ffffffff81724216>] ? ieee80211_destroy_auth_data+0x44/0x65
[25875.450349]  [<ffffffff81727748>] ? ieee80211_sta_work+0x9f/0x8b0
[25875.450358]  [<ffffffff810a2463>] ? get_parent_ip+0x9/0x1b
[25875.450366]  [<ffffffff810a24e7>] ? sub_preempt_count+0x72/0x98
[25875.450374]  [<ffffffff8174e39d>] ? _raw_spin_unlock_irqrestore+0x10/0x2c
[25875.450383]  [<ffffffff81582630>] ? skb_dequeue+0x50/0x58
[25875.450393]  [<ffffffff8174c422>] ? mutex_lock+0xf/0x1f
[25875.450403]  [<ffffffff810947d1>] ? process_one_work+0x1d0/0x3a3
[25875.450411]  [<ffffffff81092260>] ? cwq_activate_first_delayed+0x9c/0xcd
[25875.450420]  [<ffffffff817040c4>] ? ieee80211_netdev_select_queue+0xc/0xc
[25875.450429]  [<ffffffff81094ca3>] ? worker_thread+0x163/0x243
[25875.450437]  [<ffffffff81094b40>] ? rescuer_thread+0x177/0x177
[25875.450447]  [<ffffffff81097db9>] ? kthread+0x7d/0x85
[25875.450456]  [<ffffffff81750154>] ? kernel_thread_helper+0x4/0x10
[25875.450467]  [<ffffffff81097d3c>] ? kthread_freezable_should_stop+0x41/0x41
[25875.450475]  [<ffffffff81750150>] ? gs_change+0xb/0xb
[25875.450481] ---[ end trace f733293d31d9354c ]---
[25878.727902] wlan0: authenticate with 00:04:ed:94:ea:de
[25878.730001] wlan0: direct probe to 00:04:ed:94:ea:de (try 1/3)
[25878.932817] wlan0: direct probe to 00:04:ed:94:ea:de (try 2/3)
[25879.136548] wlan0: direct probe to 00:04:ed:94:ea:de (try 3/3)
[25879.340282] wlan0: authentication with 00:04:ed:94:ea:de timed out
[25879.341319] iwlwifi 0000:03:00.0: ACTIVATE a non DRIVER active station id 0 addr 00:04:ed:94:ea:de
[25879.341349] ------------[ cut here ]------------
[25879.341365] WARNING: at drivers/net/wireless/iwlwifi/iwl-agn-sta.c:809 iwl_send_lq_cmd+0x24d/0x265()
[25879.341372] Hardware name: 4290CTO
[25879.341376] Modules linked in:
[25879.341385] Pid: 15300, comm: kworker/u:0 Tainted: G        W    3.4.4-local.20120627-224004 #28
[25879.341391] Call Trace:
[25879.341404]  [<ffffffff8107ea03>] ? warn_slowpath_common+0x76/0x8a
[25879.341415]  [<ffffffff8144d908>] ? iwl_send_lq_cmd+0x24d/0x265
[25879.341426]  [<ffffffff8144dc65>] ? iwl_restore_stations+0x1bc/0x283
[25879.341438]  [<ffffffff81455a10>] ? iwlagn_commit_rxon+0x479/0x6af
[25879.341448]  [<ffffffff81447ea8>] ? iwlagn_set_rxon_chain+0x1b4/0x1f0
[25879.341457]  [<ffffffff814562c8>] ? iwlagn_bss_info_changed+0x2bf/0x512
[25879.341470]  [<ffffffff816f8db3>] ? ieee80211_bss_info_change_notify+0x199/0x22f
[25879.341483]  [<ffffffff81724216>] ? ieee80211_destroy_auth_data+0x44/0x65
[25879.341491]  [<ffffffff81727748>] ? ieee80211_sta_work+0x9f/0x8b0
[25879.341500]  [<ffffffff810a2463>] ? get_parent_ip+0x9/0x1b
[25879.341508]  [<ffffffff810a24e7>] ? sub_preempt_count+0x72/0x98
[25879.341517]  [<ffffffff8174e39d>] ? _raw_spin_unlock_irqrestore+0x10/0x2c
[25879.341525]  [<ffffffff81582630>] ? skb_dequeue+0x50/0x58
[25879.341535]  [<ffffffff810947d1>] ? process_one_work+0x1d0/0x3a3
[25879.341543]  [<ffffffff81092260>] ? cwq_activate_first_delayed+0x9c/0xcd
[25879.341552]  [<ffffffff817040c4>] ? ieee80211_netdev_select_queue+0xc/0xc
[25879.341561]  [<ffffffff81094ca3>] ? worker_thread+0x163/0x243
[25879.341569]  [<ffffffff81094b40>] ? rescuer_thread+0x177/0x177
[25879.341579]  [<ffffffff81097db9>] ? kthread+0x7d/0x85
[25879.341588]  [<ffffffff81750154>] ? kernel_thread_helper+0x4/0x10
[25879.341599]  [<ffffffff81097d3c>] ? kthread_freezable_should_stop+0x41/0x41
[25879.341607]  [<ffffffff81750150>] ? gs_change+0xb/0xb
[25879.341613] ---[ end trace f733293d31d9354d ]---
[25882.622147] wlan0: authenticate with 00:04:ed:94:ea:de
[25882.624053] wlan0: direct probe to 00:04:ed:94:ea:de (try 1/3)
[25882.827751] wlan0: direct probe to 00:04:ed:94:ea:de (try 2/3)
[25883.031492] wlan0: direct probe to 00:04:ed:94:ea:de (try 3/3)
[25883.235278] wlan0: authentication with 00:04:ed:94:ea:de timed out
[25883.236157] iwlwifi 0000:03:00.0: ACTIVATE a non DRIVER active station id 0 addr 00:04:ed:94:ea:de
[25883.236185] ------------[ cut here ]------------
[25883.236202] WARNING: at drivers/net/wireless/iwlwifi/iwl-agn-sta.c:809 iwl_send_lq_cmd+0x24d/0x265()
[25883.236208] Hardware name: 4290CTO
[25883.236212] Modules linked in:
[25883.236222] Pid: 14958, comm: kworker/u:3 Tainted: G        W    3.4.4-local.20120627-224004 #28
[25883.236228] Call Trace:
[25883.236240]  [<ffffffff8107ea03>] ? warn_slowpath_common+0x76/0x8a
[25883.236251]  [<ffffffff8144d908>] ? iwl_send_lq_cmd+0x24d/0x265
[25883.236261]  [<ffffffff8144dc65>] ? iwl_restore_stations+0x1bc/0x283
[25883.236274]  [<ffffffff81455a10>] ? iwlagn_commit_rxon+0x479/0x6af
[25883.236284]  [<ffffffff81447ea8>] ? iwlagn_set_rxon_chain+0x1b4/0x1f0
[25883.236293]  [<ffffffff814562c8>] ? iwlagn_bss_info_changed+0x2bf/0x512
[25883.236305]  [<ffffffff816f8db3>] ? ieee80211_bss_info_change_notify+0x199/0x22f
[25883.236319]  [<ffffffff81724216>] ? ieee80211_destroy_auth_data+0x44/0x65
[25883.236327]  [<ffffffff81727748>] ? ieee80211_sta_work+0x9f/0x8b0
[25883.236337]  [<ffffffff810a2463>] ? get_parent_ip+0x9/0x1b
[25883.236344]  [<ffffffff810a24e7>] ? sub_preempt_count+0x72/0x98
[25883.236353]  [<ffffffff8174e39d>] ? _raw_spin_unlock_irqrestore+0x10/0x2c
[25883.236361]  [<ffffffff81582630>] ? skb_dequeue+0x50/0x58
[25883.236371]  [<ffffffff810947d1>] ? process_one_work+0x1d0/0x3a3
[25883.236379]  [<ffffffff81092260>] ? cwq_activate_first_delayed+0x9c/0xcd
[25883.236389]  [<ffffffff817040c4>] ? ieee80211_netdev_select_queue+0xc/0xc
[25883.236398]  [<ffffffff81094ca3>] ? worker_thread+0x163/0x243
[25883.236406]  [<ffffffff81094b40>] ? rescuer_thread+0x177/0x177
[25883.236416]  [<ffffffff81097db9>] ? kthread+0x7d/0x85
[25883.236425]  [<ffffffff81750154>] ? kernel_thread_helper+0x4/0x10
[25883.236436]  [<ffffffff81097d3c>] ? kthread_freezable_should_stop+0x41/0x41
[25883.236444]  [<ffffffff81750150>] ? gs_change+0xb/0xb
[25883.236450] ---[ end trace f733293d31d9354e ]---
[25886.538000] wlan0: authenticate with 00:04:ed:94:ea:de
[25886.540201] wlan0: direct probe to 00:04:ed:94:ea:de (try 1/3)
[25886.742763] wlan0: direct probe to 00:04:ed:94:ea:de (try 2/3)
[25886.946498] wlan0: direct probe to 00:04:ed:94:ea:de (try 3/3)
[25887.150191] wlan0: authentication with 00:04:ed:94:ea:de timed out
[25887.151054] iwlwifi 0000:03:00.0: ACTIVATE a non DRIVER active station id 0 addr 00:04:ed:94:ea:de
[25887.151079] ------------[ cut here ]------------
[25887.151096] WARNING: at drivers/net/wireless/iwlwifi/iwl-agn-sta.c:809 iwl_send_lq_cmd+0x24d/0x265()
[25887.151102] Hardware name: 4290CTO
[25887.151106] Modules linked in:
[25887.151115] Pid: 15300, comm: kworker/u:0 Tainted: G        W    3.4.4-local.20120627-224004 #28
[25887.151121] Call Trace:
[25887.151134]  [<ffffffff8107ea03>] ? warn_slowpath_common+0x76/0x8a
[25887.151144]  [<ffffffff8144d908>] ? iwl_send_lq_cmd+0x24d/0x265
[25887.151155]  [<ffffffff8144dc65>] ? iwl_restore_stations+0x1bc/0x283
[25887.151168]  [<ffffffff81455a10>] ? iwlagn_commit_rxon+0x479/0x6af
[25887.151178]  [<ffffffff81447ea8>] ? iwlagn_set_rxon_chain+0x1b4/0x1f0
[25887.151187]  [<ffffffff814562c8>] ? iwlagn_bss_info_changed+0x2bf/0x512
[25887.151200]  [<ffffffff816f8db3>] ? ieee80211_bss_info_change_notify+0x199/0x22f
[25887.151213]  [<ffffffff81724216>] ? ieee80211_destroy_auth_data+0x44/0x65
[25887.151221]  [<ffffffff81727748>] ? ieee80211_sta_work+0x9f/0x8b0
[25887.151231]  [<ffffffff810a2463>] ? get_parent_ip+0x9/0x1b
[25887.151238]  [<ffffffff810a24e7>] ? sub_preempt_count+0x72/0x98
[25887.151247]  [<ffffffff8174e39d>] ? _raw_spin_unlock_irqrestore+0x10/0x2c
[25887.151255]  [<ffffffff81582630>] ? skb_dequeue+0x50/0x58
[25887.151266]  [<ffffffff810947d1>] ? process_one_work+0x1d0/0x3a3
[25887.151273]  [<ffffffff81092260>] ? cwq_activate_first_delayed+0x9c/0xcd
[25887.151283]  [<ffffffff817040c4>] ? ieee80211_netdev_select_queue+0xc/0xc
[25887.151292]  [<ffffffff81094ca3>] ? worker_thread+0x163/0x243
[25887.151300]  [<ffffffff81094b40>] ? rescuer_thread+0x177/0x177
[25887.151309]  [<ffffffff81097db9>] ? kthread+0x7d/0x85
[25887.151319]  [<ffffffff81750154>] ? kernel_thread_helper+0x4/0x10
[25887.151329]  [<ffffffff81097d3c>] ? kthread_freezable_should_stop+0x41/0x41
[25887.151338]  [<ffffffff81750150>] ? gs_change+0xb/0xb
[25887.151343] ---[ end trace f733293d31d9354f ]---
[25898.056519] wlan0: authenticate with 00:04:ed:94:ea:de
[25898.058445] wlan0: direct probe to 00:04:ed:94:ea:de (try 1/3)
[25898.259905] wlan0: direct probe to 00:04:ed:94:ea:de (try 2/3)
[25898.463678] wlan0: direct probe to 00:04:ed:94:ea:de (try 3/3)
[25898.667477] wlan0: authentication with 00:04:ed:94:ea:de timed out
[25898.672339] iwlwifi 0000:03:00.0: ACTIVATE a non DRIVER active station id 0 addr 00:04:ed:94:ea:de
[25898.672368] ------------[ cut here ]------------
[25898.672385] WARNING: at drivers/net/wireless/iwlwifi/iwl-agn-sta.c:809 iwl_send_lq_cmd+0x24d/0x265()
[25898.672391] Hardware name: 4290CTO
[25898.672395] Modules linked in:
[25898.672405] Pid: 14958, comm: kworker/u:3 Tainted: G        W    3.4.4-local.20120627-224004 #28
[25898.672410] Call Trace:
[25898.672423]  [<ffffffff8107ea03>] ? warn_slowpath_common+0x76/0x8a
[25898.672433]  [<ffffffff8144d908>] ? iwl_send_lq_cmd+0x24d/0x265
[25898.672444]  [<ffffffff8144dc65>] ? iwl_restore_stations+0x1bc/0x283
[25898.672457]  [<ffffffff81455a10>] ? iwlagn_commit_rxon+0x479/0x6af
[25898.672467]  [<ffffffff81447ea8>] ? iwlagn_set_rxon_chain+0x1b4/0x1f0
[25898.672475]  [<ffffffff814562c8>] ? iwlagn_bss_info_changed+0x2bf/0x512
[25898.672488]  [<ffffffff816f8db3>] ? ieee80211_bss_info_change_notify+0x199/0x22f
[25898.672501]  [<ffffffff81724216>] ? ieee80211_destroy_auth_data+0x44/0x65
[25898.672509]  [<ffffffff81727748>] ? ieee80211_sta_work+0x9f/0x8b0
[25898.672518]  [<ffffffff810a2463>] ? get_parent_ip+0x9/0x1b
[25898.672526]  [<ffffffff810a24e7>] ? sub_preempt_count+0x72/0x98
[25898.672535]  [<ffffffff8174e39d>] ? _raw_spin_unlock_irqrestore+0x10/0x2c
[25898.672543]  [<ffffffff81582630>] ? skb_dequeue+0x50/0x58
[25898.672554]  [<ffffffff810947d1>] ? process_one_work+0x1d0/0x3a3
[25898.672562]  [<ffffffff81092260>] ? cwq_activate_first_delayed+0x9c/0xcd
[25898.672571]  [<ffffffff817040c4>] ? ieee80211_netdev_select_queue+0xc/0xc
[25898.672580]  [<ffffffff81094ca3>] ? worker_thread+0x163/0x243
[25898.672588]  [<ffffffff81094b40>] ? rescuer_thread+0x177/0x177
[25898.672598]  [<ffffffff81097db9>] ? kthread+0x7d/0x85
[25898.672607]  [<ffffffff81750154>] ? kernel_thread_helper+0x4/0x10
[25898.672618]  [<ffffffff81097d3c>] ? kthread_freezable_should_stop+0x41/0x41
[25898.672626]  [<ffffffff81750150>] ? gs_change+0xb/0xb
[25898.672632] ---[ end trace f733293d31d93550 ]---
[25901.954816] wlan0: authenticate with 00:04:ed:94:ea:de
[25901.956789] wlan0: direct probe to 00:04:ed:94:ea:de (try 1/3)
[25902.158951] wlan0: direct probe to 00:04:ed:94:ea:de (try 2/3)
[25902.362636] wlan0: direct probe to 00:04:ed:94:ea:de (try 3/3)
[25902.566366] wlan0: authentication with 00:04:ed:94:ea:de timed out
[25902.567418] iwlwifi 0000:03:00.0: ACTIVATE a non DRIVER active station id 0 addr 00:04:ed:94:ea:de
[25902.567456] ------------[ cut here ]------------
[25902.567472] WARNING: at drivers/net/wireless/iwlwifi/iwl-agn-sta.c:809 iwl_send_lq_cmd+0x24d/0x265()
[25902.567478] Hardware name: 4290CTO
[25902.567482] Modules linked in:
[25902.567492] Pid: 15300, comm: kworker/u:0 Tainted: G        W    3.4.4-local.20120627-224004 #28
[25902.567498] Call Trace:
[25902.567510]  [<ffffffff8107ea03>] ? warn_slowpath_common+0x76/0x8a
[25902.567520]  [<ffffffff8144d908>] ? iwl_send_lq_cmd+0x24d/0x265
[25902.567531]  [<ffffffff8144dc65>] ? iwl_restore_stations+0x1bc/0x283
[25902.567544]  [<ffffffff81455a10>] ? iwlagn_commit_rxon+0x479/0x6af
[25902.567554]  [<ffffffff81447ea8>] ? iwlagn_set_rxon_chain+0x1b4/0x1f0
[25902.567563]  [<ffffffff814562c8>] ? iwlagn_bss_info_changed+0x2bf/0x512
[25902.567576]  [<ffffffff816f8db3>] ? ieee80211_bss_info_change_notify+0x199/0x22f
[25902.567589]  [<ffffffff81724216>] ? ieee80211_destroy_auth_data+0x44/0x65
[25902.567597]  [<ffffffff81727748>] ? ieee80211_sta_work+0x9f/0x8b0
[25902.567607]  [<ffffffff810a2463>] ? get_parent_ip+0x9/0x1b
[25902.567614]  [<ffffffff810a24e7>] ? sub_preempt_count+0x72/0x98
[25902.567623]  [<ffffffff8174e39d>] ? _raw_spin_unlock_irqrestore+0x10/0x2c
[25902.567631]  [<ffffffff81582630>] ? skb_dequeue+0x50/0x58
[25902.567642]  [<ffffffff810947d1>] ? process_one_work+0x1d0/0x3a3
[25902.567650]  [<ffffffff81092260>] ? cwq_activate_first_delayed+0x9c/0xcd
[25902.567659]  [<ffffffff817040c4>] ? ieee80211_netdev_select_queue+0xc/0xc
[25902.567668]  [<ffffffff81094ca3>] ? worker_thread+0x163/0x243
[25902.567676]  [<ffffffff81094b40>] ? rescuer_thread+0x177/0x177
[25902.567686]  [<ffffffff81097db9>] ? kthread+0x7d/0x85
[25902.567695]  [<ffffffff81750154>] ? kernel_thread_helper+0x4/0x10
[25902.567706]  [<ffffffff81097d3c>] ? kthread_freezable_should_stop+0x41/0x41
[25902.567714]  [<ffffffff81750150>] ? gs_change+0xb/0xb
[25902.567720] ---[ end trace f733293d31d93551 ]---
[25905.842811] wlan0: authenticate with 00:04:ed:94:ea:de
[25905.844729] wlan0: direct probe to 00:04:ed:94:ea:de (try 1/3)
[25906.045927] wlan0: direct probe to 00:04:ed:94:ea:de (try 2/3)
[25906.249628] wlan0: direct probe to 00:04:ed:94:ea:de (try 3/3)
[25906.453407] wlan0: authentication with 00:04:ed:94:ea:de timed out
[25906.454301] iwlwifi 0000:03:00.0: ACTIVATE a non DRIVER active station id 0 addr 00:04:ed:94:ea:de
[25906.454328] ------------[ cut here ]------------
[25906.454346] WARNING: at drivers/net/wireless/iwlwifi/iwl-agn-sta.c:809 iwl_send_lq_cmd+0x24d/0x265()
[25906.454352] Hardware name: 4290CTO
[25906.454356] Modules linked in:
[25906.454366] Pid: 15300, comm: kworker/u:0 Tainted: G        W    3.4.4-local.20120627-224004 #28
[25906.454371] Call Trace:
[25906.454384]  [<ffffffff8107ea03>] ? warn_slowpath_common+0x76/0x8a
[25906.454395]  [<ffffffff8144d908>] ? iwl_send_lq_cmd+0x24d/0x265
[25906.454406]  [<ffffffff8144dc65>] ? iwl_restore_stations+0x1bc/0x283
[25906.454419]  [<ffffffff81455a10>] ? iwlagn_commit_rxon+0x479/0x6af
[25906.454428]  [<ffffffff81447ea8>] ? iwlagn_set_rxon_chain+0x1b4/0x1f0
[25906.454437]  [<ffffffff814562c8>] ? iwlagn_bss_info_changed+0x2bf/0x512
[25906.454450]  [<ffffffff816f8db3>] ? ieee80211_bss_info_change_notify+0x199/0x22f
[25906.454463]  [<ffffffff81724216>] ? ieee80211_destroy_auth_data+0x44/0x65
[25906.454471]  [<ffffffff81727748>] ? ieee80211_sta_work+0x9f/0x8b0
[25906.454480]  [<ffffffff810a2463>] ? get_parent_ip+0x9/0x1b
[25906.454488]  [<ffffffff810a24e7>] ? sub_preempt_count+0x72/0x98
[25906.454497]  [<ffffffff8174e39d>] ? _raw_spin_unlock_irqrestore+0x10/0x2c
[25906.454505]  [<ffffffff81582630>] ? skb_dequeue+0x50/0x58
[25906.454516]  [<ffffffff810947d1>] ? process_one_work+0x1d0/0x3a3
[25906.454523]  [<ffffffff81092260>] ? cwq_activate_first_delayed+0x9c/0xcd
[25906.454533]  [<ffffffff817040c4>] ? ieee80211_netdev_select_queue+0xc/0xc
[25906.454542]  [<ffffffff81094ca3>] ? worker_thread+0x163/0x243
[25906.454550]  [<ffffffff81094b40>] ? rescuer_thread+0x177/0x177
[25906.454560]  [<ffffffff81097db9>] ? kthread+0x7d/0x85
[25906.454569]  [<ffffffff81750154>] ? kernel_thread_helper+0x4/0x10
[25906.454580]  [<ffffffff81097d3c>] ? kthread_freezable_should_stop+0x41/0x41
[25906.454588]  [<ffffffff81750150>] ? gs_change+0xb/0xb
[25906.454594] ---[ end trace f733293d31d93552 ]---
[25909.710583] wlan0: authenticate with 00:04:ed:94:ea:de
[25909.712561] wlan0: direct probe to 00:04:ed:94:ea:de (try 1/3)
[25909.912954] wlan0: direct probe to 00:04:ed:94:ea:de (try 2/3)
[25910.116643] wlan0: direct probe to 00:04:ed:94:ea:de (try 3/3)
[25910.320423] wlan0: authentication with 00:04:ed:94:ea:de timed out
[25910.325316] iwlwifi 0000:03:00.0: ACTIVATE a non DRIVER active station id 0 addr 00:04:ed:94:ea:de
[25910.325345] ------------[ cut here ]------------
[25910.325361] WARNING: at drivers/net/wireless/iwlwifi/iwl-agn-sta.c:809 iwl_send_lq_cmd+0x24d/0x265()
[25910.325368] Hardware name: 4290CTO
[25910.325371] Modules linked in:
[25910.325381] Pid: 15300, comm: kworker/u:0 Tainted: G        W    3.4.4-local.20120627-224004 #28
[25910.325387] Call Trace:
[25910.325400]  [<ffffffff8107ea03>] ? warn_slowpath_common+0x76/0x8a
[25910.325410]  [<ffffffff8144d908>] ? iwl_send_lq_cmd+0x24d/0x265
[25910.325421]  [<ffffffff8144dc65>] ? iwl_restore_stations+0x1bc/0x283
[25910.325434]  [<ffffffff81455a10>] ? iwlagn_commit_rxon+0x479/0x6af
[25910.325444]  [<ffffffff81447ea8>] ? iwlagn_set_rxon_chain+0x1b4/0x1f0
[25910.325453]  [<ffffffff814562c8>] ? iwlagn_bss_info_changed+0x2bf/0x512
[25910.325465]  [<ffffffff816f8db3>] ? ieee80211_bss_info_change_notify+0x199/0x22f
[25910.325478]  [<ffffffff81724216>] ? ieee80211_destroy_auth_data+0x44/0x65
[25910.325486]  [<ffffffff81727748>] ? ieee80211_sta_work+0x9f/0x8b0
[25910.325496]  [<ffffffff810a2463>] ? get_parent_ip+0x9/0x1b
[25910.325504]  [<ffffffff810a24e7>] ? sub_preempt_count+0x72/0x98
[25910.325512]  [<ffffffff8174e39d>] ? _raw_spin_unlock_irqrestore+0x10/0x2c
[25910.325521]  [<ffffffff81582630>] ? skb_dequeue+0x50/0x58
[25910.325531]  [<ffffffff810947d1>] ? process_one_work+0x1d0/0x3a3
[25910.325539]  [<ffffffff81092260>] ? cwq_activate_first_delayed+0x9c/0xcd
[25910.325549]  [<ffffffff817040c4>] ? ieee80211_netdev_select_queue+0xc/0xc
[25910.325558]  [<ffffffff81094ca3>] ? worker_thread+0x163/0x243
[25910.325566]  [<ffffffff81094b40>] ? rescuer_thread+0x177/0x177
[25910.325575]  [<ffffffff81097db9>] ? kthread+0x7d/0x85
[25910.325585]  [<ffffffff81750154>] ? kernel_thread_helper+0x4/0x10
[25910.325595]  [<ffffffff81097d3c>] ? kthread_freezable_should_stop+0x41/0x41
[25910.325604]  [<ffffffff81750150>] ? gs_change+0xb/0xb
[25910.325610] ---[ end trace f733293d31d93553 ]---
[25913.602705] wlan0: authenticate with 00:04:ed:94:ea:de
[25913.604780] wlan0: direct probe to 00:04:ed:94:ea:de (try 1/3)
[25913.807930] wlan0: direct probe to 00:04:ed:94:ea:de (try 2/3)
[25914.011671] wlan0: direct probe to 00:04:ed:94:ea:de (try 3/3)
[25914.215376] wlan0: authentication with 00:04:ed:94:ea:de timed out
[25914.216262] iwlwifi 0000:03:00.0: ACTIVATE a non DRIVER active station id 0 addr 00:04:ed:94:ea:de
[25914.216298] ------------[ cut here ]------------
[25914.216315] WARNING: at drivers/net/wireless/iwlwifi/iwl-agn-sta.c:809 iwl_send_lq_cmd+0x24d/0x265()
[25914.216321] Hardware name: 4290CTO
[25914.216325] Modules linked in:
[25914.216335] Pid: 14958, comm: kworker/u:3 Tainted: G        W    3.4.4-local.20120627-224004 #28
[25914.216341] Call Trace:
[25914.216354]  [<ffffffff8107ea03>] ? warn_slowpath_common+0x76/0x8a
[25914.216364]  [<ffffffff8144d908>] ? iwl_send_lq_cmd+0x24d/0x265
[25914.216375]  [<ffffffff8144dc65>] ? iwl_restore_stations+0x1bc/0x283
[25914.216387]  [<ffffffff81455a10>] ? iwlagn_commit_rxon+0x479/0x6af
[25914.216397]  [<ffffffff81447ea8>] ? iwlagn_set_rxon_chain+0x1b4/0x1f0
[25914.216406]  [<ffffffff814562c8>] ? iwlagn_bss_info_changed+0x2bf/0x512
[25914.216418]  [<ffffffff816f8db3>] ? ieee80211_bss_info_change_notify+0x199/0x22f
[25914.216431]  [<ffffffff81724216>] ? ieee80211_destroy_auth_data+0x44/0x65
[25914.216439]  [<ffffffff81727748>] ? ieee80211_sta_work+0x9f/0x8b0
[25914.216449]  [<ffffffff810a2463>] ? get_parent_ip+0x9/0x1b
[25914.216456]  [<ffffffff810a24e7>] ? sub_preempt_count+0x72/0x98
[25914.216465]  [<ffffffff8174e39d>] ? _raw_spin_unlock_irqrestore+0x10/0x2c
[25914.216473]  [<ffffffff81582630>] ? skb_dequeue+0x50/0x58
[25914.216483]  [<ffffffff810947d1>] ? process_one_work+0x1d0/0x3a3
[25914.216491]  [<ffffffff81092260>] ? cwq_activate_first_delayed+0x9c/0xcd
[25914.216501]  [<ffffffff817040c4>] ? ieee80211_netdev_select_queue+0xc/0xc
[25914.216510]  [<ffffffff81094ca3>] ? worker_thread+0x163/0x243
[25914.216518]  [<ffffffff81094b40>] ? rescuer_thread+0x177/0x177
[25914.216527]  [<ffffffff81097db9>] ? kthread+0x7d/0x85
[25914.216537]  [<ffffffff81750154>] ? kernel_thread_helper+0x4/0x10
[25914.216547]  [<ffffffff81097d3c>] ? kthread_freezable_should_stop+0x41/0x41
[25914.216556]  [<ffffffff81750150>] ? gs_change+0xb/0xb
[25914.216561] ---[ end trace f733293d31d93554 ]---
[25917.476784] wlan0: authenticate with 00:04:ed:94:ea:de
[25917.478906] wlan0: direct probe to 00:04:ed:94:ea:de (try 1/3)
[25917.678931] wlan0: direct probe to 00:04:ed:94:ea:de (try 2/3)
[25917.882659] wlan0: direct probe to 00:04:ed:94:ea:de (try 3/3)
[25918.086431] wlan0: authentication with 00:04:ed:94:ea:de timed out
[25918.087226] iwlwifi 0000:03:00.0: ACTIVATE a non DRIVER active station id 0 addr 00:04:ed:94:ea:de
[25918.087249] ------------[ cut here ]------------
[25918.087265] WARNING: at drivers/net/wireless/iwlwifi/iwl-agn-sta.c:809 iwl_send_lq_cmd+0x24d/0x265()
[25918.087271] Hardware name: 4290CTO
[25918.087275] Modules linked in:
[25918.087285] Pid: 15300, comm: kworker/u:0 Tainted: G        W    3.4.4-local.20120627-224004 #28
[25918.087291] Call Trace:
[25918.087303]  [<ffffffff8107ea03>] ? warn_slowpath_common+0x76/0x8a
[25918.087314]  [<ffffffff8144d908>] ? iwl_send_lq_cmd+0x24d/0x265
[25918.087325]  [<ffffffff8144dc65>] ? iwl_restore_stations+0x1bc/0x283
[25918.087337]  [<ffffffff81455a10>] ? iwlagn_commit_rxon+0x479/0x6af
[25918.087347]  [<ffffffff81447ea8>] ? iwlagn_set_rxon_chain+0x1b4/0x1f0
[25918.087356]  [<ffffffff814562c8>] ? iwlagn_bss_info_changed+0x2bf/0x512
[25918.087368]  [<ffffffff816f8db3>] ? ieee80211_bss_info_change_notify+0x199/0x22f
[25918.087381]  [<ffffffff81724216>] ? ieee80211_destroy_auth_data+0x44/0x65
[25918.087389]  [<ffffffff81727748>] ? ieee80211_sta_work+0x9f/0x8b0
[25918.087399]  [<ffffffff810a2463>] ? get_parent_ip+0x9/0x1b
[25918.087406]  [<ffffffff810a24e7>] ? sub_preempt_count+0x72/0x98
[25918.087415]  [<ffffffff8174e39d>] ? _raw_spin_unlock_irqrestore+0x10/0x2c
[25918.087423]  [<ffffffff81582630>] ? skb_dequeue+0x50/0x58
[25918.087433]  [<ffffffff810947d1>] ? process_one_work+0x1d0/0x3a3
[25918.087441]  [<ffffffff81092260>] ? cwq_activate_first_delayed+0x9c/0xcd
[25918.087451]  [<ffffffff817040c4>] ? ieee80211_netdev_select_queue+0xc/0xc
[25918.087459]  [<ffffffff81094ca3>] ? worker_thread+0x163/0x243
[25918.087467]  [<ffffffff81094b40>] ? rescuer_thread+0x177/0x177
[25918.087477]  [<ffffffff81097db9>] ? kthread+0x7d/0x85
[25918.087486]  [<ffffffff81750154>] ? kernel_thread_helper+0x4/0x10
[25918.087497]  [<ffffffff81097d3c>] ? kthread_freezable_should_stop+0x41/0x41
[25918.087505]  [<ffffffff81750150>] ? gs_change+0xb/0xb
[25918.087511] ---[ end trace f733293d31d93555 ]---
[25930.014298] wlan0: authenticate with 00:04:ed:39:c2:d5
[25930.034027] wlan0: send auth to 00:04:ed:39:c2:d5 (try 1/3)
[25930.035168] wlan0: authenticated
[25930.039058] wlan0: associate with 00:04:ed:39:c2:d5 (try 1/3)
[25930.046281] wlan0: RX AssocResp from 00:04:ed:39:c2:d5 (capab=0x411 status=0 aid=1)
[25930.046292] wlan0: associated
[25936.328606] wlan0: deauthenticated from 00:04:ed:39:c2:d5 (Reason: 3)
[25936.343110] cfg80211: Calling CRDA for country: AU
[25939.629510] wlan0: authenticate with 00:04:ed:39:c2:d5
[25939.631738] wlan0: send auth to 00:04:ed:39:c2:d5 (try 1/3)
[25939.634325] wlan0: authenticated
[25939.634850] wlan0: associate with 00:04:ed:39:c2:d5 (try 1/3)
[25939.642660] wlan0: RX AssocResp from 00:04:ed:39:c2:d5 (capab=0x411 status=0 aid=1)
[25939.642672] wlan0: associated
[25967.793366] iwlwifi 0000:03:00.0: RF_KILL bit toggled to disable radio.
[25967.794134] wlan0: deauthenticating from 00:04:ed:39:c2:d5 by local choice (reason=3)
[25967.794157] iwlwifi 0000:03:00.0: Not sending command - RF KILL
[25967.794167] HW problem - can not stop rx aggregation for tid 0
[25967.803020] iwlwifi 0000:03:00.0: Not sending command - RF KILL
[25967.803032] ieee80211 phy0: failed to remove key (0, 00:04:ed:39:c2:d5) from hardware (-5)
[25967.810424] iwlwifi 0000:03:00.0: Not sending command - RF KILL
[25967.810430] iwlwifi 0000:03:00.0: Not sending command - RF KILL
[25967.810434] iwlwifi 0000:03:00.0: Not sending command - RF KILL
[25967.814441] iwlwifi 0000:03:00.0: Not sending command - RF KILL
[25967.814445] ieee80211 phy0: failed to remove key (1, ff:ff:ff:ff:ff:ff) from hardware (-5)
[25967.814454] iwlwifi 0000:03:00.0: Not sending command - RF KILL
[25967.814458] iwlwifi 0000:03:00.0: Not sending command - RF KILL
[25967.814682] cfg80211: Calling CRDA to update world regulatory domain
[25967.818557] iwlwifi 0000:03:00.0: Not sending command - RF KILL
[25967.818570] iwlwifi 0000:03:00.0: Not sending command - RF KILL
[25968.014468] usb 1-1.4: USB disconnect, device number 7
[25971.496353] iwlwifi 0000:03:00.0: RF_KILL bit toggled to enable radio.
[25971.500390] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
[25971.500550] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[25971.630300] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[25971.909752] usb 1-1.4: new full-speed USB device number 8 using ehci_hcd
[25972.015255] usb 1-1.4: New USB device found, idVendor=0a5c, idProduct=217f
[25972.015267] usb 1-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[25972.015274] usb 1-1.4: Product: Broadcom Bluetooth Device
[25972.015279] usb 1-1.4: Manufacturer: Broadcom Corp
[25972.015284] usb 1-1.4: SerialNumber: CCAF78E7B559
[25977.962645] wlan0: authenticate with 00:04:ed:39:c2:d5
[25977.964843] wlan0: send auth to 00:04:ed:39:c2:d5 (try 1/3)
[25977.965960] wlan0: authenticated
[25977.969438] wlan0: associate with 00:04:ed:39:c2:d5 (try 1/3)
[25977.976734] wlan0: RX AssocResp from 00:04:ed:39:c2:d5 (capab=0x411 status=0 aid=1)
[25977.976745] wlan0: associated
[25977.983495] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[25987.651146] wlan0: deauthenticating from 00:04:ed:39:c2:d5 by local choice (reason=3)
[25987.661187] cfg80211: Calling CRDA for country: AU
[25988.379950] wlan0: no IPv6 routers present
[25990.925735] wlan0: authenticate with 00:04:ed:94:ea:de
[25990.945702] wlan0: direct probe to 00:04:ed:94:ea:de (try 1/3)
[25991.148433] wlan0: direct probe to 00:04:ed:94:ea:de (try 2/3)
[25991.352165] wlan0: direct probe to 00:04:ed:94:ea:de (try 3/3)
[25991.555965] wlan0: authentication with 00:04:ed:94:ea:de timed out
[25991.556858] iwlwifi 0000:03:00.0: ACTIVATE a non DRIVER active station id 0 addr 00:04:ed:94:ea:de
[25994.811806] wlan0: authenticate with 00:04:ed:94:ea:de
[25994.813808] wlan0: direct probe to 00:04:ed:94:ea:de (try 1/3)
[25995.015394] wlan0: direct probe to 00:04:ed:94:ea:de (try 2/3)
[25995.219195] wlan0: direct probe to 00:04:ed:94:ea:de (try 3/3)
[25995.422924] wlan0: authentication with 00:04:ed:94:ea:de timed out
[25995.423804] iwlwifi 0000:03:00.0: ACTIVATE a non DRIVER active station id 0 addr 00:04:ed:94:ea:de
[25998.727481] wlan0: authenticate with 00:04:ed:94:ea:de
[25998.729450] wlan0: direct probe to 00:04:ed:94:ea:de (try 1/3)
[25998.930380] wlan0: direct probe to 00:04:ed:94:ea:de (try 2/3)
[25999.134156] wlan0: direct probe to 00:04:ed:94:ea:de (try 3/3)
[25999.337881] wlan0: authentication with 00:04:ed:94:ea:de timed out
[25999.338757] iwlwifi 0000:03:00.0: ACTIVATE a non DRIVER active station id 0 addr 00:04:ed:94:ea:de
[26002.617092] wlan0: authenticate with 00:04:ed:94:ea:de
[26002.619166] wlan0: direct probe to 00:04:ed:94:ea:de (try 1/3)
[26002.821408] wlan0: direct probe to 00:04:ed:94:ea:de (try 2/3)
[26003.025142] wlan0: direct probe to 00:04:ed:94:ea:de (try 3/3)
[26003.228893] wlan0: authentication with 00:04:ed:94:ea:de timed out
[26003.229767] iwlwifi 0000:03:00.0: ACTIVATE a non DRIVER active station id 0 addr 00:04:ed:94:ea:de
[26004.429127] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
[26004.429745] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[26006.465321] wlan0: authenticate with 00:04:ed:94:ea:de
[26006.467364] wlan0: direct probe to 00:04:ed:94:ea:de (try 1/3)
[26006.668418] wlan0: direct probe to 00:04:ed:94:ea:de (try 2/3)
[26006.872181] wlan0: direct probe to 00:04:ed:94:ea:de (try 3/3)
[26007.075928] wlan0: authentication with 00:04:ed:94:ea:de timed out
[26007.076811] iwlwifi 0000:03:00.0: ACTIVATE a non DRIVER active station id 0 addr 00:04:ed:94:ea:de
[26010.353288] wlan0: authenticate with 00:04:ed:94:ea:de
[26010.355269] wlan0: direct probe to 00:04:ed:94:ea:de (try 1/3)
[26010.555464] wlan0: direct probe to 00:04:ed:94:ea:de (try 2/3)
[26010.759146] wlan0: direct probe to 00:04:ed:94:ea:de (try 3/3)
[26010.962889] wlan0: authentication with 00:04:ed:94:ea:de timed out
[26010.967866] iwlwifi 0000:03:00.0: ACTIVATE a non DRIVER active station id 0 addr 00:04:ed:94:ea:de
[26020.930873] wlan0: authenticate with 00:04:ed:39:c2:d5
[26020.950485] wlan0: send auth to 00:04:ed:39:c2:d5 (try 1/3)
[26020.952494] wlan0: authenticated
[26020.954089] wlan0: associate with 00:04:ed:39:c2:d5 (try 1/3)
[26020.961364] wlan0: RX AssocResp from 00:04:ed:39:c2:d5 (capab=0x411 status=0 aid=1)
[26020.961374] wlan0: associated

--5vNYLRcllDrimb99--
