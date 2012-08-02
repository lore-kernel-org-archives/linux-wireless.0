Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout4.freenet.de ([195.4.92.94]:48212 "EHLO mout4.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915Ab2HBC7R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2012 22:59:17 -0400
Message-ID: <5019EC7D.5030208@01019freenet.de> (sfid-20120802_045958_757354_FE322E6F)
Date: Thu, 02 Aug 2012 04:57:01 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: Emmanuel Grumbach <egrumbach@gmail.com>
CC: "Ch. Hanisch" <ch-hanisch@t-online.de>,
	linux-wireless@vger.kernel.org
Subject: Re: No WLAN on DELL XPS L702x with Ubuntu 12.04LTS (64Bit)
References: <5016F03F.1020508@t-online.de> <5016F59E.9070101@01019freenet.de> <CANUX_P2CZW5ji--KkXoyBZUuZfOqkPk_A8Ui9tw4rNeuY=mebQ@mail.gmail.com>
In-Reply-To: <CANUX_P2CZW5ji--KkXoyBZUuZfOqkPk_A8Ui9tw4rNeuY=mebQ@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------030007050002000100050600"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030007050002000100050600
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi Emmanuel,

unfortunately, Christian doesn't know how to handle a mailing list.
That's why I'm forwarding his answers for the list and may be for you, too.

He wrote, too, that the installation of compat-wireless (unfortunately,
he didn't told me which version), didn't changed the situation.

I attached for him the output of
options iwlwifi debug=0xffffffff

The last part of it:

[  675.594758] iwlwifi 0000:03:00.0: Failed to run INIT ucode: -5
[  675.594863] iwlwifi 0000:03:00.0: Unable to initialize device.

I hope this debug output can help you to find the problem!


Emmanuel Grumbach wrote:
>>>
>>> on an DELL XPS L702x under Ubuntu 12.04LTS (64Bit) the WLAN is not working.
>>> The network manager show the message
>>> "device is no ready"
>>
> 
> How long does the boot take? (From the time you press the power button
> until you see the message in the logs).
> 
> Can you please add a file (let's say iwlwifi.conf) in
> /etc/modprobe.conf with content:
> options iwlwifi debug=0xffffffff
> 
> And send the output.
> 
> Is this a laptop from a big corporate?

The Laptop is original from DELL produced in china.

03:00.0 0280: 8086:0083
	Subsystem: 8086:1325
	Flags: bus master, fast devsel, latency 0, IRQ 55
	Memory at f4300000 (64-bit, non-prefetchable) [size=8K]
	Capabilities: [c8] Power Management version 3
	Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
	Capabilities: [e0] Express Endpoint, MSI 00
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [140] Device Serial Number 74-e5-0b-ff-ff-0e-b6-6c
	Kernel driver in use: iwlwifi
	Kernel modules: iwlwifi



Thanks Emmanuel,
Kind regards,
Andreas

--------------030007050002000100050600
Content-Type: text/plain; charset=UTF-8;
 name="dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg.txt"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.2.0-27-generic (buildd@allspice) (gcc version 4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5) ) #43-Ubuntu SMP Fri Jul 6 14:25:57 UTC 2012 (Ubuntu 3.2.0-27.43-generic 3.2.21)
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.2.0-27-generic root=UUID=5a81ec71-ad7b-4d69-a845-1be56721365b ro quiet splash
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] Disabled fast string operations
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009d800 (usable)
[    0.000000]  BIOS-e820: 000000000009d800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bac8f000 (usable)
[    0.000000]  BIOS-e820: 00000000bac8f000 - 00000000bade2000 (reserved)
[    0.000000]  BIOS-e820: 00000000bade2000 - 00000000badea000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000badea000 - 00000000baf1f000 (reserved)
[    0.000000]  BIOS-e820: 00000000baf1f000 - 00000000baf9f000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000baf9f000 - 00000000bafff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bafff000 - 00000000bb000000 (usable)
[    0.000000]  BIOS-e820: 00000000bb000000 - 00000000bfa00000 (reserved)
[    0.000000]  BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed08000 - 00000000fed09000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed10000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffd80000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000013e9ff000 (usable)
[    0.000000]  BIOS-e820: 000000013e9ff000 - 000000013fe00000 (reserved)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.6 present.
[    0.000000] DMI: Dell Inc.          Dell System XPS L702X/0XN71K, BIOS A17 02/22/2012
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x13e9ff max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0FFC00000 mask FFFC00000 write-protect
[    0.000000]   1 base 000000000 mask F80000000 write-back
[    0.000000]   2 base 080000000 mask FC0000000 write-back
[    0.000000]   3 base 0BC000000 mask FFC000000 uncachable
[    0.000000]   4 base 0BB000000 mask FFF000000 uncachable
[    0.000000]   5 base 100000000 mask FC0000000 write-back
[    0.000000]   6 base 13FE00000 mask FFFE00000 uncachable
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] last_pfn = 0xbb000 max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-00000000bb000000
[    0.000000]  0000000000 - 00bb000000 page 2M
[    0.000000] kernel direct mapping tables up to bb000000 @ 1fffc000-20000000
[    0.000000] init_memory_mapping: 0000000100000000-000000013e9ff000
[    0.000000]  0100000000 - 013e800000 page 2M
[    0.000000]  013e800000 - 013e9ff000 page 4k
[    0.000000] kernel direct mapping tables up to 13e9ff000 @ bac88000-bac8f000
[    0.000000] RAMDISK: 35772000 - 36bb1000
[    0.000000] ACPI: RSDP 00000000000f00e0 00024 (v02 DELL  )
[    0.000000] ACPI: XSDT 00000000baffe120 00094 (v01 DELL    QA09    00000002 LOHR 00000002)
[    0.000000] ACPI: FACP 00000000bafef000 000F4 (v03 DELL    QA09    00000002 PTL  00000002)
[    0.000000] ACPI: DSDT 00000000baff2000 09178 (v02 DELL    SNB-CPT 00000000 INTL 20061109)
[    0.000000] ACPI: FACS 00000000baf40000 00040
[    0.000000] ACPI: SLIC 00000000baffd000 00176 (v01 DELL    QA09    00000002 LOHR 00000001)
[    0.000000] ACPI: SSDT 00000000baffc000 00166 (v01 DELL   PtidDevc 00001000 INTL 20061109)
[    0.000000] ACPI: ASF! 00000000baff1000 000A5 (v32 DELL    QA09    00000002 PTL  00000002)
[    0.000000] ACPI: HPET 00000000bafee000 00038 (v01 DELL    QA09    00000002 PTL  00000002)
[    0.000000] ACPI: APIC 00000000bafed000 00098 (v01 DELL    QA09    00000002 PTL  00000002)
[    0.000000] ACPI: MCFG 00000000bafec000 0003C (v01 DELL    QA09    00000002 PTL  00000002)
[    0.000000] ACPI: SSDT 00000000bafea000 012AD (v01 NvORef NvOptTbl 00001000 INTL 20061109)
[    0.000000] ACPI: SSDT 00000000bafe9000 0094E (v01  PmRef  Cpu0Ist 00003000 INTL 20061109)
[    0.000000] ACPI: SSDT 00000000bafe8000 00996 (v01  PmRef    CpuPm 00003000 INTL 20061109)
[    0.000000] ACPI: UEFI 00000000bafe7000 0003E (v01 DELL    QA09    00000002 PTL  00000002)
[    0.000000] ACPI: UEFI 00000000bafe6000 00042 (v01 PTL      COMBUF 00000001 PTL  00000001)
[    0.000000] ACPI: DMAR 00000000bafe5000 000E8 (v01 INTEL      SNB  00000001 INTL 00000001)
[    0.000000] ACPI: UEFI 00000000bafe4000 0026A (v01 DELL    QA09    00000002 PTL  00000002)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000013e9ff000
[    0.000000] Initmem setup node 0 0000000000000000-000000013e9ff000
[    0.000000]   NODE_DATA [000000013e9fa000 - 000000013e9fefff]
[    0.000000]  [ffffea0000000000-ffffea0004ffffff] PMD -> [ffff88013a000000-ffff88013dffffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0013e9ff
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[4] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009d
[    0.000000]     0: 0x00000100 -> 0x000bac8f
[    0.000000]     0: 0x000bafff -> 0x000bb000
[    0.000000]     0: 0x00100000 -> 0x0013e9ff
[    0.000000] On node 0 totalpages: 1021468
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3912 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 16320 pages used for memmap
[    0.000000]   DMA32 zone: 744656 pages, LIFO batch:31
[    0.000000]   Normal zone: 4008 pages used for memmap
[    0.000000]   Normal zone: 252503 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
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
[    0.000000] SMP: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bac8f000 - 00000000bade2000
[    0.000000] PM: Registered nosave memory: 00000000bade2000 - 00000000badea000
[    0.000000] PM: Registered nosave memory: 00000000badea000 - 00000000baf1f000
[    0.000000] PM: Registered nosave memory: 00000000baf1f000 - 00000000baf9f000
[    0.000000] PM: Registered nosave memory: 00000000baf9f000 - 00000000bafff000
[    0.000000] PM: Registered nosave memory: 00000000bb000000 - 00000000bfa00000
[    0.000000] PM: Registered nosave memory: 00000000bfa00000 - 00000000f8000000
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
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ffd80000
[    0.000000] PM: Registered nosave memory: 00000000ffd80000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at bfa00000 (gap: bfa00000:38600000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88013e600000 s83072 r8192 d23424 u262144
[    0.000000] pcpu-alloc: s83072 r8192 d23424 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1001071
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.2.0-27-generic root=UUID=5a81ec71-ad7b-4d69-a845-1be56721365b ro quiet splash
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave/xrstor: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 3916820k/5220348k available (6556k kernel code, 1134476k absent, 169052k reserved, 6644k data, 920k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] NR_IRQS:16640 nr_irqs:744 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 33554432 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.004000] Detected 2195.080 MHz processor.
[    0.000002] Calibrating delay loop (skipped), value calculated using timer frequency.. 4390.16 BogoMIPS (lpj=8780320)
[    0.000006] pid_max: default: 32768 minimum: 301
[    0.000028] Security Framework initialized
[    0.000041] AppArmor: AppArmor initialized
[    0.000042] Yama: becoming mindful.
[    0.000461] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.001392] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.001784] Mount-cache hash table entries: 256
[    0.001889] Initializing cgroup subsys cpuacct
[    0.001894] Initializing cgroup subsys memory
[    0.001901] Initializing cgroup subsys devices
[    0.001903] Initializing cgroup subsys freezer
[    0.001905] Initializing cgroup subsys blkio
[    0.001910] Initializing cgroup subsys perf_event
[    0.001935] Disabled fast string operations
[    0.001938] CPU: Physical Processor ID: 0
[    0.001939] CPU: Processor Core ID: 0
[    0.001943] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.001944] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.001947] mce: CPU supports 9 MCE banks
[    0.001959] CPU0: Thermal monitoring handled by SMI
[    0.001968] using mwait in idle threads.
[    0.003929] ACPI: Core revision 20110623
[    0.075237] ftrace: allocating 26993 entries in 106 pages
[    0.084002] DMAR: Host address width 36
[    0.084005] DMAR: DRHD base: 0x000000fed90000 flags: 0x0
[    0.084011] IOMMU 0: reg_base_addr fed90000 ver 1:0 cap c0000020e60262 ecap f0101a
[    0.084013] DMAR: DRHD base: 0x000000fed91000 flags: 0x1
[    0.084018] IOMMU 1: reg_base_addr fed91000 ver 1:0 cap c9008020660262 ecap f0105a
[    0.084019] DMAR: RMRR base: 0x000000bae1d000 end: 0x000000bae33fff
[    0.084021] DMAR: RMRR base: 0x000000bb800000 end: 0x000000bf9fffff
[    0.084092] IOAPIC id 2 under DRHD base  0xfed91000 IOMMU 1
[    0.084093] HPET id 0 under DRHD base 0xfed91000
[    0.084094] HPET id 0 under DRHD base 0xfed91000
[    0.084096] HPET id 0 under DRHD base 0xfed91000
[    0.084097] HPET id 0 under DRHD base 0xfed91000
[    0.084098] HPET id 0 under DRHD base 0xfed91000
[    0.084099] HPET id 0 under DRHD base 0xfed91000
[    0.084100] HPET id 0 under DRHD base 0xfed91000
[    0.084101] HPET id 0 under DRHD base 0xfed91000
[    0.084341] Enabled IRQ remapping in x2apic mode
[    0.084342] Enabling x2apic
[    0.084343] Enabled x2apic
[    0.084360] Switched APIC routing to cluster x2apic.
[    0.084783] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.124425] CPU0: Intel(R) Core(TM) i7-2720QM CPU @ 2.20GHz stepping 07
[    0.232110] Performance Events: PEBS fmt1+, SandyBridge events, Intel PMU driver.
[    0.232115] PEBS disabled due to CPU errata.
[    0.232117] ... version:                3
[    0.232118] ... bit width:              48
[    0.232119] ... generic registers:      4
[    0.232121] ... value mask:             0000ffffffffffff
[    0.232122] ... max period:             000000007fffffff
[    0.232123] ... fixed-purpose events:   3
[    0.232124] ... event mask:             000000070000000f
[    0.232293] NMI watchdog enabled, takes one hw-pmu counter.
[    0.232366] Booting Node   0, Processors  #1
[    0.232369] smpboot cpu 1: start_ip = 98000
[    0.320019] Disabled fast string operations
[    0.320037] CPU1: Thermal monitoring handled by SMI
[    0.340081] NMI watchdog enabled, takes one hw-pmu counter.
[    0.340168]  #2
[    0.340170] smpboot cpu 2: start_ip = 98000
[    0.427895] Disabled fast string operations
[    0.427912] CPU2: Thermal monitoring handled by SMI
[    0.447957] NMI watchdog enabled, takes one hw-pmu counter.
[    0.448036]  #3
[    0.448037] smpboot cpu 3: start_ip = 98000
[    0.535769] Disabled fast string operations
[    0.535786] CPU3: Thermal monitoring handled by SMI
[    0.555818] NMI watchdog enabled, takes one hw-pmu counter.
[    0.555894]  #4
[    0.555895] smpboot cpu 4: start_ip = 98000
[    0.643646] Disabled fast string operations
[    0.643663] CPU4: Thermal monitoring handled by SMI
[    0.663777] NMI watchdog enabled, takes one hw-pmu counter.
[    0.663861]  #5
[    0.663862] smpboot cpu 5: start_ip = 98000
[    0.751521] Disabled fast string operations
[    0.751538] CPU5: Thermal monitoring handled by SMI
[    0.771644] NMI watchdog enabled, takes one hw-pmu counter.
[    0.771724]  #6
[    0.771725] smpboot cpu 6: start_ip = 98000
[    0.859397] Disabled fast string operations
[    0.859415] CPU6: Thermal monitoring handled by SMI
[    0.879505] NMI watchdog enabled, takes one hw-pmu counter.
[    0.879582]  #7 Ok.
[    0.879584] smpboot cpu 7: start_ip = 98000
[    0.967273] Disabled fast string operations
[    0.967289] CPU7: Thermal monitoring handled by SMI
[    0.987365] NMI watchdog enabled, takes one hw-pmu counter.
[    0.987393] Brought up 8 CPUs
[    0.987395] Total of 8 processors activated (35118.97 BogoMIPS).
[    0.995706] devtmpfs: initialized
[    0.996409] EVM: security.selinux
[    0.996410] EVM: security.SMACK64
[    0.996411] EVM: security.capability
[    0.996434] PM: Registering ACPI NVS region at bade2000 (32768 bytes)
[    0.996436] PM: Registering ACPI NVS region at baf1f000 (524288 bytes)
[    0.997168] print_constraints: dummy: 
[    0.997198] RTC time: 19:14:19, date: 08/01/12
[    0.997228] NET: Registered protocol family 16
[    0.997320] ACPI: bus type pci registered
[    0.997323] Trying to unpack rootfs image as initramfs...
[    0.997386] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.997389] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    1.008707] PCI: Using configuration type 1 for base access
[    1.009501] bio: create slab <bio-0> at 0
[    1.009567] ACPI: Added _OSI(Module Device)
[    1.009568] ACPI: Added _OSI(Processor Device)
[    1.009570] ACPI: Added _OSI(3.0 _SCP Extensions)
[    1.009572] ACPI: Added _OSI(Processor Aggregator Device)
[    1.011148] ACPI: EC: Look up EC in DSDT
[    1.012658] ACPI: Executed 1 blocks of module-level executable AML code
[    1.083188] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    1.083662] ACPI: SSDT 00000000baf10718 0067C (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
[    1.084063] ACPI: Dynamic OEM Table Load:
[    1.084065] ACPI: SSDT           (null) 0067C (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
[    1.099330] ACPI: SSDT 00000000baf11a98 00303 (v01  PmRef    ApIst 00003000 INTL 20061109)
[    1.099758] ACPI: Dynamic OEM Table Load:
[    1.099760] ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20061109)
[    1.131190] ACPI: SSDT 00000000baf0fd98 00119 (v01  PmRef    ApCst 00003000 INTL 20061109)
[    1.131593] ACPI: Dynamic OEM Table Load:
[    1.131595] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20061109)
[    1.163156] ACPI: Interpreter enabled
[    1.163161] ACPI: (supports S0 S3 S4 S5)
[    1.163182] ACPI: Using IOAPIC for interrupt routing
[    1.167949] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
[    1.168097] ACPI: No dock devices found.
[    1.168099] HEST: Table not found.
[    1.168101] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    1.168396] \_SB_.PCI0:_OSC invalid UUID
[    1.168397] _OSC request data:1 8 1f 
[    1.168401] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    1.168902] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    1.168904] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    1.168906] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    1.168909] pci_root PNP0A08:00: host bridge window [mem 0xbfa00000-0xfeafffff]
[    1.168911] pci_root PNP0A08:00: host bridge window [mem 0xfed40000-0xfed44fff]
[    1.168922] pci 0000:00:00.0: [8086:0104] type 0 class 0x000600
[    1.168960] pci 0000:00:01.0: [8086:0101] type 1 class 0x000604
[    1.168993] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    1.168996] pci 0000:00:01.0: PME# disabled
[    1.169016] pci 0000:00:02.0: [8086:0126] type 0 class 0x000300
[    1.169026] pci 0000:00:02.0: reg 10: [mem 0xf2400000-0xf27fffff 64bit]
[    1.169033] pci 0000:00:02.0: reg 18: [mem 0xe0000000-0xefffffff 64bit pref]
[    1.169038] pci 0000:00:02.0: reg 20: [io  0x5000-0x503f]
[    1.169094] pci 0000:00:16.0: [8086:1c3a] type 0 class 0x000780
[    1.169118] pci 0000:00:16.0: reg 10: [mem 0xf4405000-0xf440500f 64bit]
[    1.169197] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    1.169201] pci 0000:00:16.0: PME# disabled
[    1.169236] pci 0000:00:1a.0: [8086:1c2d] type 0 class 0x000c03
[    1.169258] pci 0000:00:1a.0: reg 10: [mem 0xf440a000-0xf440a3ff]
[    1.169352] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    1.169356] pci 0000:00:1a.0: PME# disabled
[    1.169383] pci 0000:00:1b.0: [8086:1c20] type 0 class 0x000403
[    1.169398] pci 0000:00:1b.0: reg 10: [mem 0xf4400000-0xf4403fff 64bit]
[    1.169470] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    1.169474] pci 0000:00:1b.0: PME# disabled
[    1.169497] pci 0000:00:1c.0: [8086:1c10] type 1 class 0x000604
[    1.169579] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    1.169583] pci 0000:00:1c.0: PME# disabled
[    1.169608] pci 0000:00:1c.1: [8086:1c12] type 1 class 0x000604
[    1.169690] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    1.169694] pci 0000:00:1c.1: PME# disabled
[    1.169721] pci 0000:00:1c.3: [8086:1c16] type 1 class 0x000604
[    1.169803] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    1.169808] pci 0000:00:1c.3: PME# disabled
[    1.169832] pci 0000:00:1c.4: [8086:1c18] type 1 class 0x000604
[    1.169915] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    1.169919] pci 0000:00:1c.4: PME# disabled
[    1.169943] pci 0000:00:1c.5: [8086:1c1a] type 1 class 0x000604
[    1.170025] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    1.170029] pci 0000:00:1c.5: PME# disabled
[    1.170062] pci 0000:00:1d.0: [8086:1c26] type 0 class 0x000c03
[    1.170084] pci 0000:00:1d.0: reg 10: [mem 0xf4409000-0xf44093ff]
[    1.170177] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    1.170182] pci 0000:00:1d.0: PME# disabled
[    1.170208] pci 0000:00:1f.0: [8086:1c4b] type 0 class 0x000601
[    1.170337] pci 0000:00:1f.2: [8086:1c03] type 0 class 0x000106
[    1.170356] pci 0000:00:1f.2: reg 10: [io  0x5088-0x508f]
[    1.170365] pci 0000:00:1f.2: reg 14: [io  0x5094-0x5097]
[    1.170374] pci 0000:00:1f.2: reg 18: [io  0x5080-0x5087]
[    1.170382] pci 0000:00:1f.2: reg 1c: [io  0x5090-0x5093]
[    1.170391] pci 0000:00:1f.2: reg 20: [io  0x5060-0x507f]
[    1.170400] pci 0000:00:1f.2: reg 24: [mem 0xf4408000-0xf44087ff]
[    1.170447] pci 0000:00:1f.2: PME# supported from D3hot
[    1.170451] pci 0000:00:1f.2: PME# disabled
[    1.170470] pci 0000:00:1f.3: [8086:1c22] type 0 class 0x000c05
[    1.170486] pci 0000:00:1f.3: reg 10: [mem 0xf4404000-0xf44040ff 64bit]
[    1.170509] pci 0000:00:1f.3: reg 20: [io  0xefa0-0xefbf]
[    1.170570] pci 0000:01:00.0: [10de:0dcd] type 0 class 0x000300
[    1.170578] pci 0000:01:00.0: reg 10: [mem 0xf0000000-0xf1ffffff]
[    1.170588] pci 0000:01:00.0: reg 14: [mem 0xc0000000-0xcfffffff 64bit pref]
[    1.170597] pci 0000:01:00.0: reg 1c: [mem 0xd0000000-0xd3ffffff 64bit pref]
[    1.170603] pci 0000:01:00.0: reg 24: [io  0x4000-0x407f]
[    1.170610] pci 0000:01:00.0: reg 30: [mem 0xfff80000-0xffffffff pref]
[    1.175034] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    1.175037] pci 0000:00:01.0:   bridge window [io  0x4000-0x4fff]
[    1.175040] pci 0000:00:01.0:   bridge window [mem 0xf0000000-0xf20fffff]
[    1.175044] pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xd3ffffff 64bit pref]
[    1.175140] pci 0000:02:00.0: [1131:7231] type 0 class 0x000480
[    1.175177] pci 0000:02:00.0: reg 10: [mem 0xf2800000-0xf2bfffff 64bit]
[    1.175207] pci 0000:02:00.0: reg 18: [mem 0xf2c00000-0xf2ffffff 64bit]
[    1.175365] pci 0000:02:00.0: supports D1 D2
[    1.175367] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot
[    1.175373] pci 0000:02:00.0: PME# disabled
[    1.183062] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    1.183069] pci 0000:00:1c.0:   bridge window [mem 0xf2800000-0xf2ffffff]
[    1.183160] pci 0000:03:00.0: [8086:0083] type 0 class 0x000280
[    1.183206] pci 0000:03:00.0: reg 10: [mem 0xf4300000-0xf4301fff 64bit]
[    1.183428] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    1.183436] pci 0000:03:00.0: PME# disabled
[    1.191030] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    1.191036] pci 0000:00:1c.1:   bridge window [mem 0xf4300000-0xf43fffff]
[    1.191117] pci 0000:04:00.0: [1033:0194] type 0 class 0x000c03
[    1.191145] pci 0000:04:00.0: reg 10: [mem 0xf4200000-0xf4201fff 64bit]
[    1.191285] pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
[    1.191290] pci 0000:04:00.0: PME# disabled
[    1.199014] pci 0000:00:1c.3: PCI bridge to [bus 04-04]
[    1.199021] pci 0000:00:1c.3:   bridge window [mem 0xf4200000-0xf42fffff]
[    1.199075] pci 0000:00:1c.4: PCI bridge to [bus 05-09]
[    1.199079] pci 0000:00:1c.4:   bridge window [io  0x3000-0x3fff]
[    1.199084] pci 0000:00:1c.4:   bridge window [mem 0xf3900000-0xf41fffff]
[    1.199092] pci 0000:00:1c.4:   bridge window [mem 0xf3000000-0xf37fffff 64bit pref]
[    1.199163] pci 0000:0a:00.0: [10ec:8168] type 0 class 0x000200
[    1.199184] pci 0000:0a:00.0: reg 10: [io  0x2000-0x20ff]
[    1.199220] pci 0000:0a:00.0: reg 18: [mem 0xf3804000-0xf3804fff 64bit pref]
[    1.199242] pci 0000:0a:00.0: reg 20: [mem 0xf3800000-0xf3803fff 64bit pref]
[    1.199338] pci 0000:0a:00.0: supports D1 D2
[    1.199340] pci 0000:0a:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.199346] pci 0000:0a:00.0: PME# disabled
[    1.207004] pci 0000:00:1c.5: PCI bridge to [bus 0a-0a]
[    1.207009] pci 0000:00:1c.5:   bridge window [io  0x2000-0x2fff]
[    1.207018] pci 0000:00:1c.5:   bridge window [mem 0xf3800000-0xf38fffff 64bit pref]
[    1.207050] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.207158] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    1.207189] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    1.207220] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
[    1.207248] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP05._PRT]
[    1.207290] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP06._PRT]
[    1.207325] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG0._PRT]
[    1.207392] \_SB_.PCI0:_OSC invalid UUID
[    1.207393] _OSC request data:1 1f 1f 
[    1.207397]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    1.207424] \_SB_.PCI0:_OSC invalid UUID
[    1.207426] _OSC request data:1 0 1d 
[    1.207429]  pci0000:00: ACPI _OSC request failed (AE_ERROR), returned control mask: 0x1d
[    1.207431] ACPI _OSC control for PCIe not granted, disabling ASPM
[    1.210106] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 10 *11 12 14 15)
[    1.210151] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 *6 10 11 12 14 15)
[    1.210195] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 *10 11 12 14 15)
[    1.210238] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 *10 11 12 14 15)
[    1.210282] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 10 11 12 14 15) *0, disabled.
[    1.210325] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 10 11 12 14 15) *0, disabled.
[    1.210367] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 10 *11 12 14 15)
[    1.210408] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 *5 6 10 11 12 14 15)
[    1.210506] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    1.210514] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=none,locks=none
[    1.210517] vgaarb: loaded
[    1.210518] vgaarb: bridge control possible 0000:01:00.0
[    1.210519] vgaarb: no bridge control possible 0000:00:02.0
[    1.210599] i2c-core: driver [aat2870] using legacy suspend method
[    1.210601] i2c-core: driver [aat2870] using legacy resume method
[    1.210655] SCSI subsystem initialized
[    1.210698] libata version 3.00 loaded.
[    1.210734] usbcore: registered new interface driver usbfs
[    1.210742] usbcore: registered new interface driver hub
[    1.210761] usbcore: registered new device driver usb
[    1.210828] PCI: Using ACPI for IRQ routing
[    1.212380] PCI: pci_cache_line_size set to 64 bytes
[    1.212473] reserve RAM buffer: 000000000009d800 - 000000000009ffff 
[    1.212476] reserve RAM buffer: 00000000bac8f000 - 00000000bbffffff 
[    1.212478] reserve RAM buffer: 00000000bb000000 - 00000000bbffffff 
[    1.212480] reserve RAM buffer: 000000013e9ff000 - 000000013fffffff 
[    1.212562] NetLabel: Initializing
[    1.212564] NetLabel:  domain hash size = 128
[    1.212565] NetLabel:  protocols = UNLABELED CIPSOv4
[    1.212574] NetLabel:  unlabeled traffic allowed by default
[    1.212616] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    1.212622] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    1.214634] Switching to clocksource hpet
[    1.219856] AppArmor: AppArmor Filesystem Enabled
[    1.219875] pnp: PnP ACPI init
[    1.219889] ACPI: bus type pnp registered
[    1.220181] pnp 00:00: [bus 00-3e]
[    1.220184] pnp 00:00: [io  0x0000-0x0cf7 window]
[    1.220186] pnp 00:00: [io  0x0cf8-0x0cff]
[    1.220187] pnp 00:00: [io  0x0d00-0xffff window]
[    1.220189] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    1.220191] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    1.220193] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    1.220194] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    1.220196] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    1.220198] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    1.220200] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    1.220201] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    1.220203] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    1.220205] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    1.220206] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    1.220208] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    1.220210] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    1.220211] pnp 00:00: [mem 0x000f0000-0x000fffff window]
[    1.220213] pnp 00:00: [mem 0xbfa00000-0xfeafffff window]
[    1.220215] pnp 00:00: [mem 0xfed40000-0xfed44fff window]
[    1.220275] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    1.220287] pnp 00:01: [io  0x0000-0x001f]
[    1.220289] pnp 00:01: [io  0x0081-0x0091]
[    1.220290] pnp 00:01: [io  0x0093-0x009f]
[    1.220291] pnp 00:01: [io  0x00c0-0x00df]
[    1.220294] pnp 00:01: [dma 4]
[    1.220313] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    1.220381] pnp 00:02: [mem 0xfed00000-0xfed003ff]
[    1.220401] pnp 00:02: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.220410] pnp 00:03: [io  0x00f0]
[    1.220423] pnp 00:03: [irq 13]
[    1.220440] pnp 00:03: Plug and Play ACPI device, IDs PNP0c04 (active)
[    1.220450] pnp 00:04: [io  0x002e-0x002f]
[    1.220451] pnp 00:04: [io  0x004e-0x004f]
[    1.220453] pnp 00:04: [io  0x0061]
[    1.220454] pnp 00:04: [io  0x0063]
[    1.220455] pnp 00:04: [io  0x0065]
[    1.220457] pnp 00:04: [io  0x0067]
[    1.220458] pnp 00:04: [io  0x0068]
[    1.220459] pnp 00:04: [io  0x006c]
[    1.220460] pnp 00:04: [io  0x0070]
[    1.220462] pnp 00:04: [io  0x0080]
[    1.220463] pnp 00:04: [io  0x0092]
[    1.220464] pnp 00:04: [io  0x00b2-0x00b3]
[    1.220466] pnp 00:04: [io  0x0680-0x069f]
[    1.220467] pnp 00:04: [io  0x1000-0x1003]
[    1.220470] pnp 00:04: [io  0x1004-0x1013]
[    1.220472] pnp 00:04: [io  0xffff]
[    1.220473] pnp 00:04: [io  0x0400-0x0453]
[    1.220474] pnp 00:04: [io  0x0458-0x047f]
[    1.220476] pnp 00:04: [io  0x0500-0x057f]
[    1.220477] pnp 00:04: [io  0x164e-0x164f]
[    1.220523] system 00:04: [io  0x0680-0x069f] has been reserved
[    1.220525] system 00:04: [io  0x1000-0x1003] has been reserved
[    1.220527] system 00:04: [io  0x1004-0x1013] has been reserved
[    1.220529] system 00:04: [io  0xffff] has been reserved
[    1.220531] system 00:04: [io  0x0400-0x0453] has been reserved
[    1.220533] system 00:04: [io  0x0458-0x047f] has been reserved
[    1.220535] system 00:04: [io  0x0500-0x057f] has been reserved
[    1.220537] system 00:04: [io  0x164e-0x164f] has been reserved
[    1.220539] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.220547] pnp 00:05: [io  0x0070-0x0077]
[    1.220553] pnp 00:05: [irq 8]
[    1.220573] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.220596] pnp 00:06: [io  0x0454-0x0457]
[    1.220625] system 00:06: [io  0x0454-0x0457] has been reserved
[    1.220628] system 00:06: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    1.220660] pnp 00:07: [io  0x0060]
[    1.220662] pnp 00:07: [io  0x0064]
[    1.220669] pnp 00:07: [irq 1]
[    1.220689] pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.220719] pnp 00:08: [irq 12]
[    1.220740] pnp 00:08: Plug and Play ACPI device, IDs DLL04b8 PNP0f13 (active)
[    1.220829] pnp 00:09: [mem 0xfed1c000-0xfed1ffff]
[    1.220830] pnp 00:09: [mem 0xfed10000-0xfed17fff]
[    1.220832] pnp 00:09: [mem 0xfed18000-0xfed18fff]
[    1.220834] pnp 00:09: [mem 0xfed19000-0xfed19fff]
[    1.220835] pnp 00:09: [mem 0xf8000000-0xfbffffff]
[    1.220837] pnp 00:09: [mem 0xfed20000-0xfed3ffff]
[    1.220838] pnp 00:09: [mem 0xfed90000-0xfed93fff]
[    1.220840] pnp 00:09: [mem 0xfed45000-0xfed8ffff]
[    1.220841] pnp 00:09: [mem 0xff000000-0xffffffff]
[    1.220843] pnp 00:09: [mem 0xfee00000-0xfeefffff]
[    1.220844] pnp 00:09: [mem 0xfffff000-0xffffffff]
[    1.220858] pnp 00:09: disabling [mem 0xfffff000-0xffffffff] because it overlaps 0000:01:00.0 BAR 6 [mem 0xfff80000-0xffffffff pref]
[    1.220886] system 00:09: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    1.220888] system 00:09: [mem 0xfed10000-0xfed17fff] has been reserved
[    1.220890] system 00:09: [mem 0xfed18000-0xfed18fff] has been reserved
[    1.220892] system 00:09: [mem 0xfed19000-0xfed19fff] has been reserved
[    1.220895] system 00:09: [mem 0xf8000000-0xfbffffff] has been reserved
[    1.220897] system 00:09: [mem 0xfed20000-0xfed3ffff] has been reserved
[    1.220899] system 00:09: [mem 0xfed90000-0xfed93fff] has been reserved
[    1.220901] system 00:09: [mem 0xfed45000-0xfed8ffff] has been reserved
[    1.220903] system 00:09: [mem 0xff000000-0xffffffff] could not be reserved
[    1.220905] system 00:09: [mem 0xfee00000-0xfeefffff] could not be reserved
[    1.220908] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.221018] pnp 00:0a: [irq 20]
[    1.221051] pnp 00:0a: Plug and Play ACPI device, IDs SMO8800 (active)
[    1.221160] pnp: PnP ACPI: found 11 devices
[    1.221161] ACPI: ACPI bus type pnp unregistered
[    1.227521] pci 0000:01:00.0: no compatible bridge window for [mem 0xfff80000-0xffffffff pref]
[    1.227526] PCI: max bus depth: 1 pci_try_num: 2
[    1.227574] pci 0000:01:00.0: BAR 6: assigned [mem 0xf2000000-0xf207ffff pref]
[    1.227577] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    1.227579] pci 0000:00:01.0:   bridge window [io  0x4000-0x4fff]
[    1.227582] pci 0000:00:01.0:   bridge window [mem 0xf0000000-0xf20fffff]
[    1.227585] pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xd3ffffff 64bit pref]
[    1.227588] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    1.227594] pci 0000:00:1c.0:   bridge window [mem 0xf2800000-0xf2ffffff]
[    1.227603] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    1.227608] pci 0000:00:1c.1:   bridge window [mem 0xf4300000-0xf43fffff]
[    1.227617] pci 0000:00:1c.3: PCI bridge to [bus 04-04]
[    1.227622] pci 0000:00:1c.3:   bridge window [mem 0xf4200000-0xf42fffff]
[    1.227631] pci 0000:00:1c.4: PCI bridge to [bus 05-09]
[    1.227634] pci 0000:00:1c.4:   bridge window [io  0x3000-0x3fff]
[    1.227640] pci 0000:00:1c.4:   bridge window [mem 0xf3900000-0xf41fffff]
[    1.227644] pci 0000:00:1c.4:   bridge window [mem 0xf3000000-0xf37fffff 64bit pref]
[    1.227651] pci 0000:00:1c.5: PCI bridge to [bus 0a-0a]
[    1.227654] pci 0000:00:1c.5:   bridge window [io  0x2000-0x2fff]
[    1.227662] pci 0000:00:1c.5:   bridge window [mem 0xf3800000-0xf38fffff 64bit pref]
[    1.227680] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.227683] pci 0000:00:01.0: setting latency timer to 64
[    1.227690] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.227694] pci 0000:00:1c.0: setting latency timer to 64
[    1.227705] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    1.227709] pci 0000:00:1c.1: setting latency timer to 64
[    1.227720] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    1.227725] pci 0000:00:1c.3: setting latency timer to 64
[    1.227731] pci 0000:00:1c.4: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.227736] pci 0000:00:1c.4: setting latency timer to 64
[    1.227743] pci 0000:00:1c.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    1.227747] pci 0000:00:1c.5: setting latency timer to 64
[    1.227751] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.227753] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.227755] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.227757] pci_bus 0000:00: resource 7 [mem 0xbfa00000-0xfeafffff]
[    1.227759] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed44fff]
[    1.227761] pci_bus 0000:01: resource 0 [io  0x4000-0x4fff]
[    1.227762] pci_bus 0000:01: resource 1 [mem 0xf0000000-0xf20fffff]
[    1.227764] pci_bus 0000:01: resource 2 [mem 0xc0000000-0xd3ffffff 64bit pref]
[    1.227767] pci_bus 0000:02: resource 1 [mem 0xf2800000-0xf2ffffff]
[    1.227769] pci_bus 0000:03: resource 1 [mem 0xf4300000-0xf43fffff]
[    1.227771] pci_bus 0000:04: resource 1 [mem 0xf4200000-0xf42fffff]
[    1.227772] pci_bus 0000:05: resource 0 [io  0x3000-0x3fff]
[    1.227774] pci_bus 0000:05: resource 1 [mem 0xf3900000-0xf41fffff]
[    1.227776] pci_bus 0000:05: resource 2 [mem 0xf3000000-0xf37fffff 64bit pref]
[    1.227779] pci_bus 0000:0a: resource 0 [io  0x2000-0x2fff]
[    1.227780] pci_bus 0000:0a: resource 2 [mem 0xf3800000-0xf38fffff 64bit pref]
[    1.227809] NET: Registered protocol family 2
[    1.227946] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    1.229300] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    1.230633] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    1.230789] TCP: Hash tables configured (established 524288 bind 65536)
[    1.230791] TCP reno registered
[    1.230803] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    1.230822] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    1.230902] NET: Registered protocol family 1
[    1.230915] pci 0000:00:02.0: Boot video device
[    1.230930] pci 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.230959] pci 0000:00:1a.0: PCI INT A disabled
[    1.230992] pci 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    1.231021] pci 0000:00:1d.0: PCI INT A disabled
[    1.231059] pci 0000:04:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    1.231095] pci 0000:04:00.0: PCI INT A disabled
[    1.231103] PCI: CLS 64 bytes, default 64
[    1.231107] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.231109] Placing 64MB software IO TLB between ffff8800b6c88000 - ffff8800bac88000
[    1.231111] software IO TLB at phys 0xb6c88000 - 0xbac88000
[    1.231669] audit: initializing netlink socket (disabled)
[    1.231676] type=2000 audit(1343848458.944:1): initialized
[    1.259884] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.270750] VFS: Disk quotas dquot_6.5.2
[    1.270795] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.271202] fuse init (API version 7.17)
[    1.271274] msgmni has been set to 7650
[    1.271565] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    1.271588] io scheduler noop registered
[    1.271589] io scheduler deadline registered
[    1.271615] io scheduler cfq registered (default)
[    1.271695] pcieport 0000:00:01.0: setting latency timer to 64
[    1.271723] pcieport 0000:00:01.0: irq 42 for MSI/MSI-X
[    1.271988] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.272006] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.272048] intel_idle: MWAIT substates: 0x21120
[    1.272050] intel_idle: v0.4 model 0x2A
[    1.272051] intel_idle: lapic_timer_reliable_states 0xffffffff
[    1.355340] Freeing initrd memory: 20732k freed
[    1.370662] ACPI: Deprecated procfs I/F for AC is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    1.470541] ACPI: AC Adapter [ADP0] (on-line)
[    1.470623] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    1.470627] ACPI: Power Button [PWRB]
[    1.470658] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
[    1.470661] ACPI: Sleep Button [SLPB]
[    1.470696] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input2
[    1.471270] ACPI: Lid Switch [LID0]
[    1.471306] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    1.471308] ACPI: Power Button [PWRF]
[    1.472810] thermal LNXTHERM:00: registered as thermal_zone0
[    1.472813] ACPI: Thermal Zone [TZ00] (64 C)
[    1.472973] thermal LNXTHERM:01: registered as thermal_zone1
[    1.472975] ACPI: Thermal Zone [TZ01] (64 C)
[    1.472996] ACPI: Deprecated procfs I/F for battery is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    1.473003] ACPI: Battery Slot [BAT0] (battery absent)
[    1.473021] ERST: Table is not found!
[    1.473022] GHES: HEST is not enabled!
[    1.473036] ACPI: Battery Slot [BAT0] (battery absent)
[    1.473101] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    1.490833] Linux agpgart interface v0.103
[    1.490915] agpgart-intel 0000:00:00.0: Intel Sandybridge Chipset
[    1.491032] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[    1.492461] agpgart-intel 0000:00:00.0: detected 65536K stolen memory
[    1.492573] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
[    1.493731] brd: module loaded
[    1.494321] loop: module loaded
[    1.494423] ahci 0000:00:1f.2: version 3.0
[    1.494449] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.494495] ahci 0000:00:1f.2: irq 43 for MSI/MSI-X
[    1.494522] ahci: SSS flag set, parallel bus scan disabled
[    1.510476] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x33 impl SATA mode
[    1.510493] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ems sxs apst 
[    1.510499] ahci 0000:00:1f.2: setting latency timer to 64
[    1.534827] scsi0 : ahci
[    1.534895] scsi1 : ahci
[    1.534950] scsi2 : ahci
[    1.535005] scsi3 : ahci
[    1.535064] scsi4 : ahci
[    1.535117] scsi5 : ahci
[    1.535226] ata1: SATA max UDMA/133 abar m2048@0xf4408000 port 0xf4408100 irq 43
[    1.535230] ata2: SATA max UDMA/133 abar m2048@0xf4408000 port 0xf4408180 irq 43
[    1.535232] ata3: DUMMY
[    1.535233] ata4: DUMMY
[    1.535236] ata5: SATA max UDMA/133 abar m2048@0xf4408000 port 0xf4408300 irq 43
[    1.535239] ata6: SATA max UDMA/133 abar m2048@0xf4408000 port 0xf4408380 irq 43
[    1.535505] Fixed MDIO Bus: probed
[    1.535520] tun: Universal TUN/TAP device driver, 1.6
[    1.535522] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    1.535562] PPP generic driver version 2.4.2
[    1.535643] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.535657] ehci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.535671] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    1.535674] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    1.535715] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    1.535740] ehci_hcd 0000:00:1a.0: debug port 2
[    1.539633] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[    1.539645] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xf440a000
[    1.554397] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    1.554533] hub 1-0:1.0: USB hub found
[    1.554537] hub 1-0:1.0: 2 ports detected
[    1.554589] ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    1.554602] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    1.554605] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    1.554641] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    1.554663] ehci_hcd 0000:00:1d.0: debug port 2
[    1.558533] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[    1.558544] ehci_hcd 0000:00:1d.0: irq 23, io mem 0xf4409000
[    1.574366] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    1.574497] hub 2-0:1.0: USB hub found
[    1.574500] hub 2-0:1.0: 2 ports detected
[    1.574548] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.574558] uhci_hcd: USB Universal Host Controller Interface driver
[    1.574584] xhci_hcd 0000:04:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    1.574600] xhci_hcd 0000:04:00.0: setting latency timer to 64
[    1.574604] xhci_hcd 0000:04:00.0: xHCI Host Controller
[    1.574641] xhci_hcd 0000:04:00.0: new USB bus registered, assigned bus number 3
[    1.574811] xhci_hcd 0000:04:00.0: irq 19, io mem 0xf4200000
[    1.574875] xhci_hcd 0000:04:00.0: irq 44 for MSI/MSI-X
[    1.574881] xhci_hcd 0000:04:00.0: irq 45 for MSI/MSI-X
[    1.574885] xhci_hcd 0000:04:00.0: irq 46 for MSI/MSI-X
[    1.574890] xhci_hcd 0000:04:00.0: irq 47 for MSI/MSI-X
[    1.574894] xhci_hcd 0000:04:00.0: irq 48 for MSI/MSI-X
[    1.574898] xhci_hcd 0000:04:00.0: irq 49 for MSI/MSI-X
[    1.574902] xhci_hcd 0000:04:00.0: irq 50 for MSI/MSI-X
[    1.574906] xhci_hcd 0000:04:00.0: irq 51 for MSI/MSI-X
[    1.575089] xHCI xhci_add_endpoint called for root hub
[    1.575090] xHCI xhci_check_bandwidth called for root hub
[    1.575111] hub 3-0:1.0: USB hub found
[    1.575118] hub 3-0:1.0: 2 ports detected
[    1.575164] xhci_hcd 0000:04:00.0: xHCI Host Controller
[    1.575197] xhci_hcd 0000:04:00.0: new USB bus registered, assigned bus number 4
[    1.578271] xHCI xhci_add_endpoint called for root hub
[    1.578272] xHCI xhci_check_bandwidth called for root hub
[    1.578291] hub 4-0:1.0: USB hub found
[    1.578308] hub 4-0:1.0: 2 ports detected
[    1.626380] usbcore: registered new interface driver libusual
[    1.626409] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    1.630761] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.630766] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.630865] mousedev: PS/2 mouse device common for all mice
[    1.631024] rtc_cmos 00:05: RTC can wake from S4
[    1.631123] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    1.631150] rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    1.631211] device-mapper: uevent: version 1.0.3
[    1.631268] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised: dm-devel@redhat.com
[    1.631464] cpuidle: using governor ladder
[    1.631766] cpuidle: using governor menu
[    1.631768] EFI Variables Facility v0.08 2004-May-17
[    1.631937] TCP cubic registered
[    1.632015] NET: Registered protocol family 10
[    1.632365] NET: Registered protocol family 17
[    1.632369] Registering the dns_resolver key type
[    1.632482] PM: Hibernation image not present or could not be loaded.
[    1.632490] registered taskstats version 1
[    1.640812] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
[    1.644119]   Magic number: 8:270:242
[    1.644228] rtc_cmos 00:05: setting system clock to 2012-08-01 19:14:19 UTC (1343848459)
[    1.645873] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    1.645874] EDD information not available.
[    1.854160] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.866153] usb 1-1: new high-speed USB device number 2 using ehci_hcd
[    1.877062] ata1.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
[    1.998834] hub 1-1:1.0: USB hub found
[    1.999008] hub 1-1:1.0: 6 ports detected
[    2.109885] usb 2-1: new high-speed USB device number 2 using ehci_hcd
[    2.152291] ata1.00: ATA-8: ST9500423AS, 0001DEM1, max UDMA/133
[    2.152301] ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    2.153884] ata1.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
[    2.154183] ata1.00: configured for UDMA/133
[    2.154349] scsi 0:0:0:0: Direct-Access     ATA      ST9500423AS      0001 PQ: 0 ANSI: 5
[    2.154551] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.154574] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    2.154576] sd 0:0:0:0: [sda] 4096-byte physical blocks
[    2.154853] sd 0:0:0:0: [sda] Write Protect is off
[    2.154856] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.155006] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.174455]  sda: sda1 sda2 sda3
[    2.175403] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.229714] Refined TSC clocksource calibration: 2195.013 MHz.
[    2.229728] Switching to clocksource tsc
[    2.242575] hub 2-1:1.0: USB hub found
[    2.242734] hub 2-1:1.0: 8 ports detected
[    2.353599] usb 3-1: new full-speed USB device number 2 using xhci_hcd
[    2.473446] ata2: SATA link down (SStatus 0 SControl 300)
[    2.477618] usb 1-1.4: new high-speed USB device number 3 using ehci_hcd
[    2.641437] usb 2-1.1: new high-speed USB device number 3 using ehci_hcd
[    2.736830] Initializing USB Mass Storage driver...
[    2.736941] scsi6 : usb-storage 2-1.1:1.0
[    2.736992] usbcore: registered new interface driver usb-storage
[    2.736993] USB Mass Storage support registered.
[    2.793111] ata5: SATA link down (SStatus 0 SControl 300)
[    2.805257] usb 2-1.2: new high-speed USB device number 4 using ehci_hcd
[    2.899845] usb-storage 2-1.2:1.0: Quirks match for vid 152d pid 2329: 8020
[    2.899971] scsi7 : usb-storage 2-1.2:1.0
[    3.112764] ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.124298] ata6.00: ATAPI: TSSTcorp DVD+/-RW TS-L633J, D500, max UDMA/100
[    3.139274] ata6.00: configured for UDMA/100
[    3.147258] scsi 5:0:0:0: CD-ROM            TSSTcorp DVD+-RW TS-L633J D500 PQ: 0 ANSI: 5
[    3.156816] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    3.156835] cdrom: Uniform CD-ROM driver Revision: 3.20
[    3.157021] sr 5:0:0:0: Attached scsi CD-ROM sr0
[    3.157173] sr 5:0:0:0: Attached scsi generic sg1 type 5
[    3.158443] Freeing unused kernel memory: 920k freed
[    3.158537] Write protecting the kernel read-only data: 12288k
[    3.162221] Freeing unused kernel memory: 1616k freed
[    3.164972] Freeing unused kernel memory: 1200k freed
[    3.178497] udevd[136]: starting version 175
[    3.393472] [drm] Initialized drm 1.1.0 20060810
[    3.396337] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    3.396366] r8169 0000:0a:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    3.396398] r8169 0000:0a:00.0: setting latency timer to 64
[    3.396465] r8169 0000:0a:00.0: irq 52 for MSI/MSI-X
[    3.396776] r8169 0000:0a:00.0: eth0: RTL8168e/8111e at 0xffffc90000672000, 14:fe:b5:bc:6c:89, XID 0c200000 IRQ 52
[    3.396778] r8169 0000:0a:00.0: eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
[    3.397313] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.397317] i915 0000:00:02.0: setting latency timer to 64
[    3.414461] input: A4TECH USB Device as /devices/pci0000:00/0000:00:1c.3/0000:04:00.0/usb3/3-1/3-1:1.0/input/input5
[    3.414754] generic-usb 0003:09DA:9090.0001: input,hiddev0,hidraw0: USB HID v1.11 Keyboard [A4TECH USB Device] on usb-0000:04:00.0-1/input0
[    3.432342] input: A4TECH USB Device as /devices/pci0000:00/0000:00:1c.3/0000:04:00.0/usb3/3-1/3-1:1.1/input/input6
[    3.432527] generic-usb 0003:09DA:9090.0002: input,hidraw1: USB HID v1.11 Mouse [A4TECH USB Device] on usb-0000:04:00.0-1/input1
[    3.432539] usbcore: registered new interface driver usbhid
[    3.432540] usbhid: USB HID core driver
[    3.442082] i915 0000:00:02.0: irq 53 for MSI/MSI-X
[    3.442086] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    3.442087] [drm] Driver supports precise vblank timestamp query.
[    3.442177] [drm:intel_dsm_platform_mux_info] *ERROR* MUX INFO call failed
[    3.442206] [drm:intel_dsm_platform_mux_info] *ERROR* MUX INFO call failed
[    3.442218] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=none:owns=io+mem
[    3.442219] vgaarb: transferring owner from PCI:0000:00:02.0 to PCI:0000:01:00.0
[    3.733062] scsi 6:0:0:0: Direct-Access     Seagate  FreeAgent Go     0142 PQ: 0 ANSI: 4
[    3.733879] sd 6:0:0:0: Attached scsi generic sg2 type 0
[    3.734429] sd 6:0:0:0: [sdb] 625142446 512-byte logical blocks: (320 GB/298 GiB)
[    3.734992] sd 6:0:0:0: [sdb] Write Protect is off
[    3.734994] sd 6:0:0:0: [sdb] Mode Sense: 1c 00 00 00
[    3.735621] sd 6:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.739127]  sdb: sdb1
[    3.743415] sd 6:0:0:0: [sdb] Attached SCSI disk
[    3.896887] scsi 7:0:0:0: Direct-Access     WDC WD32 00BEVT-22ZCT0         PQ: 0 ANSI: 2 CCS
[    3.897726] sd 7:0:0:0: Attached scsi generic sg3 type 0
[    3.898223] sd 7:0:0:0: [sdc] 625142448 512-byte logical blocks: (320 GB/298 GiB)
[    3.899009] sd 7:0:0:0: [sdc] Write Protect is off
[    3.899015] sd 7:0:0:0: [sdc] Mode Sense: 34 00 00 00
[    3.899896] sd 7:0:0:0: [sdc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    4.006657]  sdc: sdc1 sdc2 < sdc5 sdc6 sdc7 sdc8 > sdc3
[    4.013989] sd 7:0:0:0: [sdc] Attached SCSI disk
[    4.052654] fbcon: inteldrmfb (fb0) is primary device
[    4.325587] Console: switching to colour frame buffer device 200x56
[    4.327965] fb0: inteldrmfb frame buffer device
[    4.327967] drm: registered panic notifier
[    4.328113] [Firmware Bug]: ACPI(PEGP) defines _DOD but not _DOS
[    4.556123] acpi device:2f: registered as cooling_device8
[    4.556158] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:2c/LNXVIDEO:00/input/input7
[    4.556202] ACPI: Video Device [PEGP] (multi-head: yes  rom: yes  post: no)
[    4.607841] acpi device:31: registered as cooling_device9
[    4.607976] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:01/input/input8
[    4.608014] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    4.608036] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[   10.403135] EXT4-fs (sdc1): INFO: recovery required on readonly filesystem
[   10.403138] EXT4-fs (sdc1): write access will be enabled during recovery
[   10.715286] EXT4-fs (sdc1): recovery complete
[   10.716447] EXT4-fs (sdc1): mounted filesystem with ordered data mode. Opts: (null)
[   30.987491] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   31.051197] udevd[596]: starting version 175
[   31.054899] usbcore: registered new interface driver usblp
[   31.056907] lp: driver loaded but no devices found
[   31.077162] Adding 7522300k swap on /dev/sdc6.  Priority:-1 extents:1 across:7522300k 
[   31.268534] wmi: Mapper loaded
[   31.273009] mei: module is from the staging directory, the quality is unknown, you have been warned.
[   31.273253] mei 0000:00:16.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   31.273259] mei 0000:00:16.0: setting latency timer to 64
[   31.273309] mei 0000:00:16.0: irq 54 for MSI/MSI-X
[   31.275539] cfg80211: Calling CRDA to update world regulatory domain
[   31.283007] Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
[   31.283010] Copyright(c) 2003-2011 Intel Corporation
[   31.283053] iwlwifi 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   31.283063] iwlwifi 0000:03:00.0: setting latency timer to 64
[   31.283088] iwlwifi 0000:03:00.0: pci_resource_len = 0x00002000
[   31.283090] iwlwifi 0000:03:00.0: pci_resource_base = ffffc900050a0000
[   31.283092] iwlwifi 0000:03:00.0: HW Revision ID = 0x0
[   31.283177] iwlwifi 0000:03:00.0: irq 55 for MSI/MSI-X
[   31.283215] iwlwifi 0000:03:00.0: Detected Intel(R) Centrino(R) Wireless-N 1000 BGN, REV=0x6C
[   31.283264] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[   31.304161] iwlwifi 0000:03:00.0: device EEPROM VER=0x15d, CALIB=0x6
[   31.304164] iwlwifi 0000:03:00.0: Device SKU: 0X50
[   31.304166] iwlwifi 0000:03:00.0: Valid Tx ant: 0X1, Valid Rx ant: 0X3
[   31.304189] iwlwifi 0000:03:00.0: Tunable channels: 13 802.11bg, 0 802.11a channels
[   31.311370] Linux video capture interface: v2.00
[   31.311926] uvcvideo: Found UVC 1.00 device Laptop_Integrated_Webcam_2HDM (0408:2fb1)
[   31.313474] snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[   31.313534] snd_hda_intel 0000:00:1b.0: irq 56 for MSI/MSI-X
[   31.313557] snd_hda_intel 0000:00:1b.0: setting latency timer to 64
[   31.320121] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[   31.336145] input: Dell WMI hotkeys as /devices/virtual/input/input9
[   31.339302] uvcvideo: No streaming interface found for terminal 6.
[   31.339348] input: Laptop_Integrated_Webcam_2HDM as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.4/1-1.4:1.0/input/input10
[   31.339415] usbcore: registered new interface driver uvcvideo
[   31.339418] USB Video Class driver (1.1.1)
[   31.340327] cfg80211: World regulatory domain updated:
[   31.340330] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   31.340332] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   31.340333] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   31.340335] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   31.340336] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   31.340338] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   31.358015] iwlwifi 0000:03:00.0: loaded firmware version 39.31.5.1 build 35138
[   31.358124] Registered led device: phy0-led
[   31.358141] cfg80211: Ignoring regulatory request Set by core since the driver uses its own custom regulatory domain
[   31.359820] type=1400 audit(1343841289.245:2): apparmor="STATUS" operation="profile_load" name="/sbin/dhclient" pid=854 comm="apparmor_parser"
[   31.360081] type=1400 audit(1343841289.245:3): apparmor="STATUS" operation="profile_load" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=854 comm="apparmor_parser"
[   31.360230] type=1400 audit(1343841289.245:4): apparmor="STATUS" operation="profile_load" name="/usr/lib/connman/scripts/dhclient-script" pid=854 comm="apparmor_parser"
[   31.361895] udevd[614]: renamed network interface eth0 to eth1
[   31.364297] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[   31.397925] udevd[614]: renamed network interface wlan0 to wlan1
[   31.862782] hda_codec: ALC665: SKU not ready 0x598301f0
[   31.870041] HDMI status: Codec=3 Pin=6 Presence_Detect=0 ELD_Valid=0
[   31.870092] input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[   31.870147] input: HDA Intel PCH Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
[   31.870207] input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input13
[   31.870269] input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input14
[   32.049993] psmouse serio1: synaptics: Touchpad model: 1, fw: 7.4, id: 0x1e0b1, caps: 0xd04773/0xa40000/0x8a0400
[   32.093749] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input15
[   32.450214] EXT4-fs (sdc1): re-mounted. Opts: errors=remount-ro
[   33.990345] EXT4-fs (sdc5): mounted filesystem with ordered data mode. Opts: user_xattr
[   35.086361] init: failsafe main process (1080) killed by TERM signal
[   35.979516] Bluetooth: Core ver 2.16
[   35.979530] NET: Registered protocol family 31
[   35.979531] Bluetooth: HCI device and connection manager initialized
[   35.979532] Bluetooth: HCI socket layer initialized
[   35.979533] Bluetooth: L2CAP socket layer initialized
[   35.979536] Bluetooth: SCO socket layer initialized
[   35.980794] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   35.980796] Bluetooth: BNEP filters: protocol multicast
[   35.993095] ppdev: user-space parallel port driver
[   35.998956] Bluetooth: RFCOMM TTY layer initialized
[   35.998960] Bluetooth: RFCOMM socket layer initialized
[   35.998961] Bluetooth: RFCOMM ver 1.11
[   36.005644] type=1400 audit(1343841293.897:5): apparmor="STATUS" operation="profile_load" name="/usr/lib/cups/backend/cups-pdf" pid=1158 comm="apparmor_parser"
[   36.005957] type=1400 audit(1343841293.897:6): apparmor="STATUS" operation="profile_load" name="/usr/sbin/cupsd" pid=1158 comm="apparmor_parser"
[   36.015796] type=1400 audit(1343841293.905:7): apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient" pid=1192 comm="apparmor_parser"
[   36.016054] type=1400 audit(1343841293.905:8): apparmor="STATUS" operation="profile_load" name="/usr/sbin/mysqld" pid=1197 comm="apparmor_parser"
[   36.016083] type=1400 audit(1343841293.905:9): apparmor="STATUS" operation="profile_replace" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=1192 comm="apparmor_parser"
[   36.016105] type=1400 audit(1343841293.905:10): apparmor="STATUS" operation="profile_load" name="/usr/lib/lightdm/lightdm/lightdm-guest-session-wrapper" pid=1191 comm="apparmor_parser"
[   36.016265] type=1400 audit(1343841293.905:11): apparmor="STATUS" operation="profile_replace" name="/usr/lib/connman/scripts/dhclient-script" pid=1192 comm="apparmor_parser"
[   36.151253] bbswitch: version 0.4.2
[   36.151261] bbswitch: Found integrated VGA device 0000:00:02.0: \_SB_.PCI0.GFX0
[   36.151270] bbswitch: Found discrete VGA device 0000:01:00.0: \_SB_.PCI0.PEG0.PEGP
[   36.151575] bbswitch: detected an Optimus _DSM function
[   36.151582] bbswitch: Succesfully loaded. Discrete card 0000:01:00.0 is on
[   36.153318] bbswitch: disabling discrete graphics
[   36.153601] bbswitch: Result of Optimus _DSM call: 11000059
[   36.162014] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[   36.179146] iwlwifi 0000:03:00.0: Microcode SW error detected.  Restarting 0x82000000.
[   36.179150] iwlwifi 0000:03:00.0: Loaded firmware version: 39.31.5.1 build 35138
[   36.179235] iwlwifi 0000:03:00.0: Start IWL Error Log Dump:
[   36.179236] iwlwifi 0000:03:00.0: Status: 0x00040224, count: 5
[   36.179238] iwlwifi 0000:03:00.0: 0x00000005 | SYSASSERT                   
[   36.179239] iwlwifi 0000:03:00.0: 0x00016E00 | uPc
[   36.179240] iwlwifi 0000:03:00.0: 0x00016E00 | branchlink1
[   36.179241] iwlwifi 0000:03:00.0: 0x00016E00 | branchlink2
[   36.179243] iwlwifi 0000:03:00.0: 0x00000000 | interruptlink1
[   36.179244] iwlwifi 0000:03:00.0: 0x00000000 | interruptlink2
[   36.179245] iwlwifi 0000:03:00.0: 0x00000000 | data1
[   36.179246] iwlwifi 0000:03:00.0: 0x00000000 | data2
[   36.179247] iwlwifi 0000:03:00.0: 0x00000616 | line
[   36.179248] iwlwifi 0000:03:00.0: 0x00018BC9 | beacon time
[   36.179249] iwlwifi 0000:03:00.0: 0x00000437 | tsf low
[   36.179250] iwlwifi 0000:03:00.0: 0x00000000 | tsf hi
[   36.179251] iwlwifi 0000:03:00.0: 0x00000000 | time gp1
[   36.179252] iwlwifi 0000:03:00.0: 0x0000043B | time gp2
[   36.179253] iwlwifi 0000:03:00.0: 0x00000000 | time gp3
[   36.179254] iwlwifi 0000:03:00.0: 0x0001271F | uCode version
[   36.179256] iwlwifi 0000:03:00.0: 0x0000006C | hw version
[   36.179257] iwlwifi 0000:03:00.0: 0x00880300 | board version
[   36.179258] iwlwifi 0000:03:00.0: 0x00000000 | hcmd
[   36.179259] iwlwifi 0000:03:00.0: CSR values:
[   36.179260] iwlwifi 0000:03:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
[   36.179265] iwlwifi 0000:03:00.0:        CSR_HW_IF_CONFIG_REG: 0X00880300
[   36.179270] iwlwifi 0000:03:00.0:          CSR_INT_COALESCING: 0X00000040
[   36.179275] iwlwifi 0000:03:00.0:                     CSR_INT: 0X80000000
[   36.179279] iwlwifi 0000:03:00.0:                CSR_INT_MASK: 0X00000000
[   36.179283] iwlwifi 0000:03:00.0:           CSR_FH_INT_STATUS: 0X40010000
[   36.179288] iwlwifi 0000:03:00.0:                 CSR_GPIO_IN: 0X00000000
[   36.179292] iwlwifi 0000:03:00.0:                   CSR_RESET: 0X00000000
[   36.179297] iwlwifi 0000:03:00.0:                CSR_GP_CNTRL: 0X080403c5
[   36.179302] iwlwifi 0000:03:00.0:                  CSR_HW_REV: 0X0000006c
[   36.179306] iwlwifi 0000:03:00.0:              CSR_EEPROM_REG: 0Xc63f3885
[   36.179311] iwlwifi 0000:03:00.0:               CSR_EEPROM_GP: 0X90000001
[   36.179315] iwlwifi 0000:03:00.0:              CSR_OTP_GP_REG: 0X00210801
[   36.179320] iwlwifi 0000:03:00.0:                 CSR_GIO_REG: 0X00080046
[   36.179324] iwlwifi 0000:03:00.0:            CSR_GP_UCODE_REG: 0X00000000
[   36.179329] iwlwifi 0000:03:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[   36.179334] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[   36.179339] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[   36.179344] iwlwifi 0000:03:00.0:                 CSR_LED_REG: 0X00000018
[   36.179348] iwlwifi 0000:03:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
[   36.179352] iwlwifi 0000:03:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[   36.179356] iwlwifi 0000:03:00.0:             CSR_ANA_PLL_CFG: 0X00880300
[   36.179360] iwlwifi 0000:03:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[   36.179365] iwlwifi 0000:03:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
[   36.179367] iwlwifi 0000:03:00.0: FH register values:
[   36.179380] iwlwifi 0000:03:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X1336ff00
[   36.179394] iwlwifi 0000:03:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X01336fe0
[   36.179409] iwlwifi 0000:03:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
[   36.179424] iwlwifi 0000:03:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80819104
[   36.179437] iwlwifi 0000:03:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[   36.179452] iwlwifi 0000:03:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
[   36.179467] iwlwifi 0000:03:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[   36.179480] iwlwifi 0000:03:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
[   36.179495] iwlwifi 0000:03:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
[   36.179552] iwlwifi 0000:03:00.0: Start IWL Event Log Dump: display last 5 entries
[   36.179572] iwlwifi 0000:03:00.0: EVT_LOGT:0000000000:0x0000028c:0117
[   36.179583] iwlwifi 0000:03:00.0: EVT_LOGT:0000000021:0x00000000:1208
[   36.179595] iwlwifi 0000:03:00.0: EVT_LOGT:0000001004:0x00000001:0071
[   36.179605] iwlwifi 0000:03:00.0: EVT_LOGT:0000001080:0x00000002:0071
[   36.179617] iwlwifi 0000:03:00.0: EVT_LOGT:0000001086:0x00000000:0125
[   36.179932] iwlwifi 0000:03:00.0: Failed to run INIT ucode: -5
[   36.180011] iwlwifi 0000:03:00.0: Unable to initialize device.
[   36.180080] ieee80211 phy0: Hardware restart was requested
[   36.180090] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[   36.193007] init: kdm main process (1269) killed by TERM signal
[   36.323837] r8169 0000:0a:00.0: eth1: link down
[   36.324083] ADDRCONF(NETDEV_UP): eth1: link is not ready
[   36.324239] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[   36.339543] iwlwifi 0000:03:00.0: Microcode SW error detected.  Restarting 0x82000000.
[   36.339548] iwlwifi 0000:03:00.0: Loaded firmware version: 39.31.5.1 build 35138
[   36.339627] iwlwifi 0000:03:00.0: Start IWL Error Log Dump:
[   36.339630] iwlwifi 0000:03:00.0: Status: 0x00040224, count: 5
[   36.339632] iwlwifi 0000:03:00.0: 0x00000005 | SYSASSERT                   
[   36.339634] iwlwifi 0000:03:00.0: 0x00016E00 | uPc
[   36.339636] iwlwifi 0000:03:00.0: 0x00016E00 | branchlink1
[   36.339638] iwlwifi 0000:03:00.0: 0x00016E00 | branchlink2
[   36.339639] iwlwifi 0000:03:00.0: 0x00000000 | interruptlink1
[   36.339641] iwlwifi 0000:03:00.0: 0x00000000 | interruptlink2
[   36.339643] iwlwifi 0000:03:00.0: 0x00000000 | data1
[   36.339644] iwlwifi 0000:03:00.0: 0x00000000 | data2
[   36.339646] iwlwifi 0000:03:00.0: 0x00000616 | line
[   36.339647] iwlwifi 0000:03:00.0: 0x00018BC8 | beacon time
[   36.339649] iwlwifi 0000:03:00.0: 0x00000438 | tsf low
[   36.339650] iwlwifi 0000:03:00.0: 0x00000000 | tsf hi
[   36.339652] iwlwifi 0000:03:00.0: 0x00000000 | time gp1
[   36.339653] iwlwifi 0000:03:00.0: 0x0000043C | time gp2
[   36.339655] iwlwifi 0000:03:00.0: 0x00000000 | time gp3
[   36.339657] iwlwifi 0000:03:00.0: 0x0001271F | uCode version
[   36.339658] iwlwifi 0000:03:00.0: 0x0000006C | hw version
[   36.339660] iwlwifi 0000:03:00.0: 0x00880300 | board version
[   36.339662] iwlwifi 0000:03:00.0: 0x00000000 | hcmd
[   36.339663] iwlwifi 0000:03:00.0: CSR values:
[   36.339665] iwlwifi 0000:03:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
[   36.339670] iwlwifi 0000:03:00.0:        CSR_HW_IF_CONFIG_REG: 0X00880300
[   36.339675] iwlwifi 0000:03:00.0:          CSR_INT_COALESCING: 0X00000040
[   36.339680] iwlwifi 0000:03:00.0:                     CSR_INT: 0X80000000
[   36.339684] iwlwifi 0000:03:00.0:                CSR_INT_MASK: 0X00000000
[   36.339689] iwlwifi 0000:03:00.0:           CSR_FH_INT_STATUS: 0X40010000
[   36.339694] iwlwifi 0000:03:00.0:                 CSR_GPIO_IN: 0X00000000
[   36.339699] iwlwifi 0000:03:00.0:                   CSR_RESET: 0X00000000
[   36.339704] iwlwifi 0000:03:00.0:                CSR_GP_CNTRL: 0X080403c5
[   36.339709] iwlwifi 0000:03:00.0:                  CSR_HW_REV: 0X0000006c
[   36.339714] iwlwifi 0000:03:00.0:              CSR_EEPROM_REG: 0Xc63f3885
[   36.339719] iwlwifi 0000:03:00.0:               CSR_EEPROM_GP: 0X90000001
[   36.339724] iwlwifi 0000:03:00.0:              CSR_OTP_GP_REG: 0X00210801
[   36.339729] iwlwifi 0000:03:00.0:                 CSR_GIO_REG: 0X00080046
[   36.339733] iwlwifi 0000:03:00.0:            CSR_GP_UCODE_REG: 0X00000000
[   36.339738] iwlwifi 0000:03:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[   36.339742] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[   36.339747] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[   36.339751] iwlwifi 0000:03:00.0:                 CSR_LED_REG: 0X00000018
[   36.339756] iwlwifi 0000:03:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
[   36.339761] iwlwifi 0000:03:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[   36.339765] iwlwifi 0000:03:00.0:             CSR_ANA_PLL_CFG: 0X00000000
[   36.339770] iwlwifi 0000:03:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[   36.339775] iwlwifi 0000:03:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
[   36.339776] iwlwifi 0000:03:00.0: FH register values:
[   36.339790] iwlwifi 0000:03:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X1336ff00
[   36.339804] iwlwifi 0000:03:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X01336fe0
[   36.339818] iwlwifi 0000:03:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
[   36.339832] iwlwifi 0000:03:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80819104
[   36.339846] iwlwifi 0000:03:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[   36.339860] iwlwifi 0000:03:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
[   36.339874] iwlwifi 0000:03:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[   36.339888] iwlwifi 0000:03:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
[   36.339901] iwlwifi 0000:03:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
[   36.339956] iwlwifi 0000:03:00.0: Start IWL Event Log Dump: display last 5 entries
[   36.339976] iwlwifi 0000:03:00.0: EVT_LOGT:0000000000:0x0000028c:0117
[   36.339987] iwlwifi 0000:03:00.0: EVT_LOGT:0000000021:0x00000000:1208
[   36.339998] iwlwifi 0000:03:00.0: EVT_LOGT:0000001005:0x00000001:0071
[   36.340009] iwlwifi 0000:03:00.0: EVT_LOGT:0000001081:0x00000002:0071
[   36.340020] iwlwifi 0000:03:00.0: EVT_LOGT:0000001087:0x00000000:0125
[   36.340618] iwlwifi 0000:03:00.0: Failed to run INIT ucode: -5
[   36.340698] iwlwifi 0000:03:00.0: Unable to initialize device.
[   36.340785] ieee80211 phy0: Hardware restart was requested
[   36.340940] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[   36.356366] iwlwifi 0000:03:00.0: Microcode SW error detected.  Restarting 0x82000000.
[   36.356369] iwlwifi 0000:03:00.0: Loaded firmware version: 39.31.5.1 build 35138
[   36.356457] iwlwifi 0000:03:00.0: Start IWL Error Log Dump:
[   36.356458] iwlwifi 0000:03:00.0: Status: 0x00040224, count: 5
[   36.356460] iwlwifi 0000:03:00.0: 0x00000005 | SYSASSERT                   
[   36.356461] iwlwifi 0000:03:00.0: 0x00016E00 | uPc
[   36.356462] iwlwifi 0000:03:00.0: 0x00016E00 | branchlink1
[   36.356463] iwlwifi 0000:03:00.0: 0x00016E00 | branchlink2
[   36.356464] iwlwifi 0000:03:00.0: 0x00000000 | interruptlink1
[   36.356465] iwlwifi 0000:03:00.0: 0x00000000 | interruptlink2
[   36.356466] iwlwifi 0000:03:00.0: 0x00000000 | data1
[   36.356467] iwlwifi 0000:03:00.0: 0x00000000 | data2
[   36.356468] iwlwifi 0000:03:00.0: 0x00000616 | line
[   36.356469] iwlwifi 0000:03:00.0: 0x00018BCA | beacon time
[   36.356470] iwlwifi 0000:03:00.0: 0x00000436 | tsf low
[   36.356471] iwlwifi 0000:03:00.0: 0x00000000 | tsf hi
[   36.356472] iwlwifi 0000:03:00.0: 0x00000000 | time gp1
[   36.356473] iwlwifi 0000:03:00.0: 0x0000043A | time gp2
[   36.356474] iwlwifi 0000:03:00.0: 0x00000000 | time gp3
[   36.356475] iwlwifi 0000:03:00.0: 0x0001271F | uCode version
[   36.356476] iwlwifi 0000:03:00.0: 0x0000006C | hw version
[   36.356477] iwlwifi 0000:03:00.0: 0x00880300 | board version
[   36.356478] iwlwifi 0000:03:00.0: 0x00000000 | hcmd
[   36.356479] iwlwifi 0000:03:00.0: CSR values:
[   36.356480] iwlwifi 0000:03:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
[   36.356485] iwlwifi 0000:03:00.0:        CSR_HW_IF_CONFIG_REG: 0X00880300
[   36.356490] iwlwifi 0000:03:00.0:          CSR_INT_COALESCING: 0X00000040
[   36.356494] iwlwifi 0000:03:00.0:                     CSR_INT: 0X80000000
[   36.356499] iwlwifi 0000:03:00.0:                CSR_INT_MASK: 0X00000000
[   36.356503] iwlwifi 0000:03:00.0:           CSR_FH_INT_STATUS: 0X40010000
[   36.356507] iwlwifi 0000:03:00.0:                 CSR_GPIO_IN: 0X00000000
[   36.356512] iwlwifi 0000:03:00.0:                   CSR_RESET: 0X00000000
[   36.356516] iwlwifi 0000:03:00.0:                CSR_GP_CNTRL: 0X080403c5
[   36.356520] iwlwifi 0000:03:00.0:                  CSR_HW_REV: 0X0000006c
[   36.356524] iwlwifi 0000:03:00.0:              CSR_EEPROM_REG: 0Xc63f3885
[   36.356529] iwlwifi 0000:03:00.0:               CSR_EEPROM_GP: 0X90000001
[   36.356534] iwlwifi 0000:03:00.0:              CSR_OTP_GP_REG: 0X00210801
[   36.356537] iwlwifi 0000:03:00.0:                 CSR_GIO_REG: 0X00080046
[   36.356542] iwlwifi 0000:03:00.0:            CSR_GP_UCODE_REG: 0X00000000
[   36.356546] iwlwifi 0000:03:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[   36.356550] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[   36.356555] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[   36.356559] iwlwifi 0000:03:00.0:                 CSR_LED_REG: 0X00000018
[   36.356563] iwlwifi 0000:03:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
[   36.356567] iwlwifi 0000:03:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[   36.356572] iwlwifi 0000:03:00.0:             CSR_ANA_PLL_CFG: 0X00000000
[   36.356576] iwlwifi 0000:03:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[   36.356580] iwlwifi 0000:03:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
[   36.356581] iwlwifi 0000:03:00.0: FH register values:
[   36.356596] iwlwifi 0000:03:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X1336ff00
[   36.356610] iwlwifi 0000:03:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X01336fe0
[   36.356623] iwlwifi 0000:03:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
[   36.356637] iwlwifi 0000:03:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80819104
[   36.356650] iwlwifi 0000:03:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[   36.356665] iwlwifi 0000:03:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
[   36.356678] iwlwifi 0000:03:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[   36.356691] iwlwifi 0000:03:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
[   36.356705] iwlwifi 0000:03:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
[   36.356761] iwlwifi 0000:03:00.0: Start IWL Event Log Dump: display last 5 entries
[   36.356780] iwlwifi 0000:03:00.0: EVT_LOGT:0000000000:0x0000028c:0117
[   36.356790] iwlwifi 0000:03:00.0: EVT_LOGT:0000000021:0x00000000:1208
[   36.356801] iwlwifi 0000:03:00.0: EVT_LOGT:0000001003:0x00000001:0071
[   36.356812] iwlwifi 0000:03:00.0: EVT_LOGT:0000001079:0x00000002:0071
[   36.356825] iwlwifi 0000:03:00.0: EVT_LOGT:0000001085:0x00000000:0125
[   36.357138] iwlwifi 0000:03:00.0: Failed to run INIT ucode: -5
[   36.357200] iwlwifi 0000:03:00.0: Unable to initialize device.
[   36.357261] ieee80211 phy0: Hardware restart was requested
[   36.357355] ADDRCONF(NETDEV_UP): eth1: link is not ready
[   36.381804] init: gdm main process (1295) killed by TERM signal
[   36.476099] pci 0000:01:00.0: power state changed by ACPI to D3
[   49.282221] vboxdrv: Found 8 processor cores.
[   49.282485] vboxdrv: fAsync=0 offMin=0x188 offMax=0x1448
[   49.282525] vboxdrv: TSC mode is 'synchronous', kernel timer mode is 'normal'.
[   49.282526] vboxdrv: Successfully loaded version 4.1.18 (interface 0x00190000).
[   49.488390] vboxpci: IOMMU not found (not registered)
[   50.244235] init: plymouth-stop pre-start process (2216) terminated with status 1
[   51.388051] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[   51.407506] iwlwifi 0000:03:00.0: Microcode SW error detected.  Restarting 0x82000000.
[   51.407511] iwlwifi 0000:03:00.0: Loaded firmware version: 39.31.5.1 build 35138
[   51.407615] iwlwifi 0000:03:00.0: Start IWL Error Log Dump:
[   51.407618] iwlwifi 0000:03:00.0: Status: 0x00040224, count: 5
[   51.407621] iwlwifi 0000:03:00.0: 0x00000005 | SYSASSERT                   
[   51.407625] iwlwifi 0000:03:00.0: 0x00016E00 | uPc
[   51.407628] iwlwifi 0000:03:00.0: 0x00016E00 | branchlink1
[   51.407631] iwlwifi 0000:03:00.0: 0x00016E00 | branchlink2
[   51.407633] iwlwifi 0000:03:00.0: 0x00000000 | interruptlink1
[   51.407637] iwlwifi 0000:03:00.0: 0x00000000 | interruptlink2
[   51.407640] iwlwifi 0000:03:00.0: 0x00000000 | data1
[   51.407642] iwlwifi 0000:03:00.0: 0x00000000 | data2
[   51.407645] iwlwifi 0000:03:00.0: 0x00000616 | line
[   51.407648] iwlwifi 0000:03:00.0: 0x00018BC8 | beacon time
[   51.407651] iwlwifi 0000:03:00.0: 0x00000438 | tsf low
[   51.407654] iwlwifi 0000:03:00.0: 0x00000000 | tsf hi
[   51.407656] iwlwifi 0000:03:00.0: 0x00000000 | time gp1
[   51.407659] iwlwifi 0000:03:00.0: 0x0000043C | time gp2
[   51.407662] iwlwifi 0000:03:00.0: 0x00000000 | time gp3
[   51.407665] iwlwifi 0000:03:00.0: 0x0001271F | uCode version
[   51.407668] iwlwifi 0000:03:00.0: 0x0000006C | hw version
[   51.407671] iwlwifi 0000:03:00.0: 0x00880300 | board version
[   51.407674] iwlwifi 0000:03:00.0: 0x00000000 | hcmd
[   51.407677] iwlwifi 0000:03:00.0: CSR values:
[   51.407680] iwlwifi 0000:03:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
[   51.407686] iwlwifi 0000:03:00.0:        CSR_HW_IF_CONFIG_REG: 0X00880300
[   51.407693] iwlwifi 0000:03:00.0:          CSR_INT_COALESCING: 0X00000040
[   51.407700] iwlwifi 0000:03:00.0:                     CSR_INT: 0X80000000
[   51.407706] iwlwifi 0000:03:00.0:                CSR_INT_MASK: 0X00000000
[   51.407714] iwlwifi 0000:03:00.0:           CSR_FH_INT_STATUS: 0X40010000
[   51.407720] iwlwifi 0000:03:00.0:                 CSR_GPIO_IN: 0X00000000
[   51.407727] iwlwifi 0000:03:00.0:                   CSR_RESET: 0X00000000
[   51.407734] iwlwifi 0000:03:00.0:                CSR_GP_CNTRL: 0X080403c5
[   51.407741] iwlwifi 0000:03:00.0:                  CSR_HW_REV: 0X0000006c
[   51.407748] iwlwifi 0000:03:00.0:              CSR_EEPROM_REG: 0Xc63f3885
[   51.407755] iwlwifi 0000:03:00.0:               CSR_EEPROM_GP: 0X90000001
[   51.407762] iwlwifi 0000:03:00.0:              CSR_OTP_GP_REG: 0X00210801
[   51.407768] iwlwifi 0000:03:00.0:                 CSR_GIO_REG: 0X00080046
[   51.407774] iwlwifi 0000:03:00.0:            CSR_GP_UCODE_REG: 0X00000000
[   51.407781] iwlwifi 0000:03:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[   51.407788] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[   51.407795] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[   51.407802] iwlwifi 0000:03:00.0:                 CSR_LED_REG: 0X00000018
[   51.407809] iwlwifi 0000:03:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
[   51.407814] iwlwifi 0000:03:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[   51.407820] iwlwifi 0000:03:00.0:             CSR_ANA_PLL_CFG: 0X00000000
[   51.407824] iwlwifi 0000:03:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[   51.407833] iwlwifi 0000:03:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
[   51.407835] iwlwifi 0000:03:00.0: FH register values:
[   51.407850] iwlwifi 0000:03:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X1336ff00
[   51.407867] iwlwifi 0000:03:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X01336fe0
[   51.407883] iwlwifi 0000:03:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
[   51.407898] iwlwifi 0000:03:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80819104
[   51.407915] iwlwifi 0000:03:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[   51.407934] iwlwifi 0000:03:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
[   51.407950] iwlwifi 0000:03:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[   51.407967] iwlwifi 0000:03:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
[   51.407982] iwlwifi 0000:03:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
[   51.408043] iwlwifi 0000:03:00.0: Start IWL Event Log Dump: display last 5 entries
[   51.408065] iwlwifi 0000:03:00.0: EVT_LOGT:0000000000:0x0000028c:0117
[   51.408078] iwlwifi 0000:03:00.0: EVT_LOGT:0000000021:0x00000000:1208
[   51.408090] iwlwifi 0000:03:00.0: EVT_LOGT:0000001005:0x00000001:0071
[   51.408103] iwlwifi 0000:03:00.0: EVT_LOGT:0000001081:0x00000002:0071
[   51.408115] iwlwifi 0000:03:00.0: EVT_LOGT:0000001087:0x00000000:0125
[   51.408785] iwlwifi 0000:03:00.0: Failed to run INIT ucode: -5
[   51.408869] iwlwifi 0000:03:00.0: Unable to initialize device.
[   51.408970] ieee80211 phy0: Hardware restart was requested
[   53.304104] kjournald starting.  Commit interval 5 seconds
[   53.305121] EXT3-fs (sdc8): using internal journal
[   53.305142] EXT3-fs (sdc8): mounted filesystem with ordered data mode
[   53.878416] kjournald starting.  Commit interval 5 seconds
[   53.878469] EXT3-fs (sdc7): warning: maximal mount count reached, running e2fsck is recommended
[   53.879075] EXT3-fs (sdc7): using internal journal
[   53.879079] EXT3-fs (sdc7): mounted filesystem with ordered data mode
[   54.166855] kjournald starting.  Commit interval 5 seconds
[   54.167614] EXT3-fs (sdc3): using internal journal
[   54.167617] EXT3-fs (sdc3): mounted filesystem with ordered data mode
[   56.235154] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[   56.250787] iwlwifi 0000:03:00.0: Microcode SW error detected.  Restarting 0x82000000.
[   56.250799] iwlwifi 0000:03:00.0: Loaded firmware version: 39.31.5.1 build 35138
[   56.250892] iwlwifi 0000:03:00.0: Start IWL Error Log Dump:
[   56.250893] iwlwifi 0000:03:00.0: Status: 0x00040224, count: 5
[   56.250895] iwlwifi 0000:03:00.0: 0x00000005 | SYSASSERT                   
[   56.250896] iwlwifi 0000:03:00.0: 0x00016E00 | uPc
[   56.250897] iwlwifi 0000:03:00.0: 0x00016E00 | branchlink1
[   56.250898] iwlwifi 0000:03:00.0: 0x00016E00 | branchlink2
[   56.250899] iwlwifi 0000:03:00.0: 0x00000000 | interruptlink1
[   56.250900] iwlwifi 0000:03:00.0: 0x00000000 | interruptlink2
[   56.250901] iwlwifi 0000:03:00.0: 0x00000000 | data1
[   56.250902] iwlwifi 0000:03:00.0: 0x00000000 | data2
[   56.250903] iwlwifi 0000:03:00.0: 0x00000616 | line
[   56.250904] iwlwifi 0000:03:00.0: 0x00018BC9 | beacon time
[   56.250905] iwlwifi 0000:03:00.0: 0x00000437 | tsf low
[   56.250906] iwlwifi 0000:03:00.0: 0x00000000 | tsf hi
[   56.250907] iwlwifi 0000:03:00.0: 0x00000000 | time gp1
[   56.250908] iwlwifi 0000:03:00.0: 0x0000043B | time gp2
[   56.250909] iwlwifi 0000:03:00.0: 0x00000000 | time gp3
[   56.250910] iwlwifi 0000:03:00.0: 0x0001271F | uCode version
[   56.250911] iwlwifi 0000:03:00.0: 0x0000006C | hw version
[   56.250912] iwlwifi 0000:03:00.0: 0x00880300 | board version
[   56.250913] iwlwifi 0000:03:00.0: 0x00000000 | hcmd
[   56.250914] iwlwifi 0000:03:00.0: CSR values:
[   56.250915] iwlwifi 0000:03:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
[   56.250920] iwlwifi 0000:03:00.0:        CSR_HW_IF_CONFIG_REG: 0X00880300
[   56.250923] iwlwifi 0000:03:00.0:          CSR_INT_COALESCING: 0X00000040
[   56.250928] iwlwifi 0000:03:00.0:                     CSR_INT: 0X80000000
[   56.250932] iwlwifi 0000:03:00.0:                CSR_INT_MASK: 0X00000000
[   56.250936] iwlwifi 0000:03:00.0:           CSR_FH_INT_STATUS: 0X40010000
[   56.250940] iwlwifi 0000:03:00.0:                 CSR_GPIO_IN: 0X00000000
[   56.250944] iwlwifi 0000:03:00.0:                   CSR_RESET: 0X00000000
[   56.250949] iwlwifi 0000:03:00.0:                CSR_GP_CNTRL: 0X080403c5
[   56.250953] iwlwifi 0000:03:00.0:                  CSR_HW_REV: 0X0000006c
[   56.250958] iwlwifi 0000:03:00.0:              CSR_EEPROM_REG: 0Xc63f3885
[   56.250963] iwlwifi 0000:03:00.0:               CSR_EEPROM_GP: 0X90000001
[   56.250967] iwlwifi 0000:03:00.0:              CSR_OTP_GP_REG: 0X00210801
[   56.250971] iwlwifi 0000:03:00.0:                 CSR_GIO_REG: 0X00080046
[   56.250975] iwlwifi 0000:03:00.0:            CSR_GP_UCODE_REG: 0X00000000
[   56.250979] iwlwifi 0000:03:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[   56.250982] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[   56.250986] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[   56.250991] iwlwifi 0000:03:00.0:                 CSR_LED_REG: 0X00000018
[   56.250994] iwlwifi 0000:03:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
[   56.250998] iwlwifi 0000:03:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[   56.251002] iwlwifi 0000:03:00.0:             CSR_ANA_PLL_CFG: 0X00000000
[   56.251006] iwlwifi 0000:03:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[   56.251010] iwlwifi 0000:03:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
[   56.251012] iwlwifi 0000:03:00.0: FH register values:
[   56.251024] iwlwifi 0000:03:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X1336ff00
[   56.251037] iwlwifi 0000:03:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X01336fe0
[   56.251050] iwlwifi 0000:03:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
[   56.251062] iwlwifi 0000:03:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80819104
[   56.251076] iwlwifi 0000:03:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[   56.251090] iwlwifi 0000:03:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
[   56.251102] iwlwifi 0000:03:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[   56.251115] iwlwifi 0000:03:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
[   56.251128] iwlwifi 0000:03:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
[   56.251181] iwlwifi 0000:03:00.0: Start IWL Event Log Dump: display last 5 entries
[   56.251200] iwlwifi 0000:03:00.0: EVT_LOGT:0000000000:0x0000028c:0117
[   56.251211] iwlwifi 0000:03:00.0: EVT_LOGT:0000000021:0x00000000:1208
[   56.251222] iwlwifi 0000:03:00.0: EVT_LOGT:0000001004:0x00000001:0071
[   56.251232] iwlwifi 0000:03:00.0: EVT_LOGT:0000001080:0x00000002:0071
[   56.251242] iwlwifi 0000:03:00.0: EVT_LOGT:0000001086:0x00000000:0125
[   56.251546] iwlwifi 0000:03:00.0: Failed to run INIT ucode: -5
[   56.251623] iwlwifi 0000:03:00.0: Unable to initialize device.
[   56.251707] ieee80211 phy0: Hardware restart was requested
[   61.231571] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[   61.247056] iwlwifi 0000:03:00.0: Microcode SW error detected.  Restarting 0x82000000.
[   61.247059] iwlwifi 0000:03:00.0: Loaded firmware version: 39.31.5.1 build 35138
[   61.247147] iwlwifi 0000:03:00.0: Start IWL Error Log Dump:
[   61.247148] iwlwifi 0000:03:00.0: Status: 0x00040224, count: 5
[   61.247150] iwlwifi 0000:03:00.0: 0x00000005 | SYSASSERT                   
[   61.247151] iwlwifi 0000:03:00.0: 0x00016E00 | uPc
[   61.247152] iwlwifi 0000:03:00.0: 0x00016E00 | branchlink1
[   61.247154] iwlwifi 0000:03:00.0: 0x00016E00 | branchlink2
[   61.247155] iwlwifi 0000:03:00.0: 0x00000000 | interruptlink1
[   61.247156] iwlwifi 0000:03:00.0: 0x00000000 | interruptlink2
[   61.247157] iwlwifi 0000:03:00.0: 0x00000000 | data1
[   61.247158] iwlwifi 0000:03:00.0: 0x00000000 | data2
[   61.247159] iwlwifi 0000:03:00.0: 0x00000616 | line
[   61.247160] iwlwifi 0000:03:00.0: 0x00018BC8 | beacon time
[   61.247161] iwlwifi 0000:03:00.0: 0x00000438 | tsf low
[   61.247162] iwlwifi 0000:03:00.0: 0x00000000 | tsf hi
[   61.247163] iwlwifi 0000:03:00.0: 0x00000000 | time gp1
[   61.247164] iwlwifi 0000:03:00.0: 0x0000043C | time gp2
[   61.247165] iwlwifi 0000:03:00.0: 0x00000000 | time gp3
[   61.247167] iwlwifi 0000:03:00.0: 0x0001271F | uCode version
[   61.247168] iwlwifi 0000:03:00.0: 0x0000006C | hw version
[   61.247169] iwlwifi 0000:03:00.0: 0x00880300 | board version
[   61.247170] iwlwifi 0000:03:00.0: 0x00000000 | hcmd
[   61.247171] iwlwifi 0000:03:00.0: CSR values:
[   61.247172] iwlwifi 0000:03:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
[   61.247177] iwlwifi 0000:03:00.0:        CSR_HW_IF_CONFIG_REG: 0X00880300
[   61.247182] iwlwifi 0000:03:00.0:          CSR_INT_COALESCING: 0X00000040
[   61.247186] iwlwifi 0000:03:00.0:                     CSR_INT: 0X80000000
[   61.247191] iwlwifi 0000:03:00.0:                CSR_INT_MASK: 0X00000000
[   61.247196] iwlwifi 0000:03:00.0:           CSR_FH_INT_STATUS: 0X40010000
[   61.247201] iwlwifi 0000:03:00.0:                 CSR_GPIO_IN: 0X00000000
[   61.247206] iwlwifi 0000:03:00.0:                   CSR_RESET: 0X00000000
[   61.247210] iwlwifi 0000:03:00.0:                CSR_GP_CNTRL: 0X080403c5
[   61.247215] iwlwifi 0000:03:00.0:                  CSR_HW_REV: 0X0000006c
[   61.247220] iwlwifi 0000:03:00.0:              CSR_EEPROM_REG: 0Xc63f3885
[   61.247224] iwlwifi 0000:03:00.0:               CSR_EEPROM_GP: 0X90000001
[   61.247229] iwlwifi 0000:03:00.0:              CSR_OTP_GP_REG: 0X00210801
[   61.247233] iwlwifi 0000:03:00.0:                 CSR_GIO_REG: 0X00080046
[   61.247238] iwlwifi 0000:03:00.0:            CSR_GP_UCODE_REG: 0X00000000
[   61.247243] iwlwifi 0000:03:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[   61.247247] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[   61.247252] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[   61.247257] iwlwifi 0000:03:00.0:                 CSR_LED_REG: 0X00000018
[   61.247261] iwlwifi 0000:03:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
[   61.247266] iwlwifi 0000:03:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[   61.247271] iwlwifi 0000:03:00.0:             CSR_ANA_PLL_CFG: 0X00000000
[   61.247275] iwlwifi 0000:03:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[   61.247280] iwlwifi 0000:03:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
[   61.247282] iwlwifi 0000:03:00.0: FH register values:
[   61.247296] iwlwifi 0000:03:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X1336ff00
[   61.247311] iwlwifi 0000:03:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X01336fe0
[   61.247325] iwlwifi 0000:03:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
[   61.247340] iwlwifi 0000:03:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80819104
[   61.247361] iwlwifi 0000:03:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[   61.247375] iwlwifi 0000:03:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
[   61.247390] iwlwifi 0000:03:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[   61.247403] iwlwifi 0000:03:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
[   61.247418] iwlwifi 0000:03:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
[   61.247478] iwlwifi 0000:03:00.0: Start IWL Event Log Dump: display last 5 entries
[   61.247497] iwlwifi 0000:03:00.0: EVT_LOGT:0000000000:0x0000028c:0117
[   61.247509] iwlwifi 0000:03:00.0: EVT_LOGT:0000000021:0x00000000:1208
[   61.247520] iwlwifi 0000:03:00.0: EVT_LOGT:0000001005:0x00000001:0071
[   61.247532] iwlwifi 0000:03:00.0: EVT_LOGT:0000001081:0x00000002:0071
[   61.247552] iwlwifi 0000:03:00.0: EVT_LOGT:0000001087:0x00000000:0125
[   61.247876] iwlwifi 0000:03:00.0: Failed to run INIT ucode: -5
[   61.247955] iwlwifi 0000:03:00.0: Unable to initialize device.
[   61.248040] ieee80211 phy0: Hardware restart was requested
[   66.225700] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[   66.241481] iwlwifi 0000:03:00.0: Microcode SW error detected.  Restarting 0x82000000.
[   66.241493] iwlwifi 0000:03:00.0: Loaded firmware version: 39.31.5.1 build 35138
[   66.241600] iwlwifi 0000:03:00.0: Start IWL Error Log Dump:
[   66.241601] iwlwifi 0000:03:00.0: Status: 0x00040224, count: 5
[   66.241603] iwlwifi 0000:03:00.0: 0x00000005 | SYSASSERT                   
[   66.241604] iwlwifi 0000:03:00.0: 0x00016E00 | uPc
[   66.241605] iwlwifi 0000:03:00.0: 0x00016E00 | branchlink1
[   66.241606] iwlwifi 0000:03:00.0: 0x00016E00 | branchlink2
[   66.241608] iwlwifi 0000:03:00.0: 0x00000000 | interruptlink1
[   66.241609] iwlwifi 0000:03:00.0: 0x00000000 | interruptlink2
[   66.241610] iwlwifi 0000:03:00.0: 0x00000000 | data1
[   66.241611] iwlwifi 0000:03:00.0: 0x00000000 | data2
[   66.241612] iwlwifi 0000:03:00.0: 0x00000616 | line
[   66.241613] iwlwifi 0000:03:00.0: 0x00018BC8 | beacon time
[   66.241614] iwlwifi 0000:03:00.0: 0x00000438 | tsf low
[   66.241615] iwlwifi 0000:03:00.0: 0x00000000 | tsf hi
[   66.241616] iwlwifi 0000:03:00.0: 0x00000000 | time gp1
[   66.241617] iwlwifi 0000:03:00.0: 0x0000043C | time gp2
[   66.241618] iwlwifi 0000:03:00.0: 0x00000000 | time gp3
[   66.241619] iwlwifi 0000:03:00.0: 0x0001271F | uCode version
[   66.241621] iwlwifi 0000:03:00.0: 0x0000006C | hw version
[   66.241622] iwlwifi 0000:03:00.0: 0x00880300 | board version
[   66.241623] iwlwifi 0000:03:00.0: 0x00000000 | hcmd
[   66.241624] iwlwifi 0000:03:00.0: CSR values:
[   66.241625] iwlwifi 0000:03:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
[   66.241631] iwlwifi 0000:03:00.0:        CSR_HW_IF_CONFIG_REG: 0X00880300
[   66.241636] iwlwifi 0000:03:00.0:          CSR_INT_COALESCING: 0X00000040
[   66.241640] iwlwifi 0000:03:00.0:                     CSR_INT: 0X80000000
[   66.241645] iwlwifi 0000:03:00.0:                CSR_INT_MASK: 0X00000000
[   66.241650] iwlwifi 0000:03:00.0:           CSR_FH_INT_STATUS: 0X40010000
[   66.241655] iwlwifi 0000:03:00.0:                 CSR_GPIO_IN: 0X00000000
[   66.241660] iwlwifi 0000:03:00.0:                   CSR_RESET: 0X00000000
[   66.241665] iwlwifi 0000:03:00.0:                CSR_GP_CNTRL: 0X080403c5
[   66.241670] iwlwifi 0000:03:00.0:                  CSR_HW_REV: 0X0000006c
[   66.241675] iwlwifi 0000:03:00.0:              CSR_EEPROM_REG: 0Xc63f3885
[   66.241680] iwlwifi 0000:03:00.0:               CSR_EEPROM_GP: 0X90000001
[   66.241685] iwlwifi 0000:03:00.0:              CSR_OTP_GP_REG: 0X00210801
[   66.241690] iwlwifi 0000:03:00.0:                 CSR_GIO_REG: 0X00080046
[   66.241695] iwlwifi 0000:03:00.0:            CSR_GP_UCODE_REG: 0X00000000
[   66.241700] iwlwifi 0000:03:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[   66.241704] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[   66.241709] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[   66.241714] iwlwifi 0000:03:00.0:                 CSR_LED_REG: 0X00000018
[   66.241719] iwlwifi 0000:03:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
[   66.241724] iwlwifi 0000:03:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[   66.241729] iwlwifi 0000:03:00.0:             CSR_ANA_PLL_CFG: 0X00000000
[   66.241734] iwlwifi 0000:03:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[   66.241739] iwlwifi 0000:03:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
[   66.241740] iwlwifi 0000:03:00.0: FH register values:
[   66.241756] iwlwifi 0000:03:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X1336ff00
[   66.241771] iwlwifi 0000:03:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X01336fe0
[   66.241786] iwlwifi 0000:03:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
[   66.241801] iwlwifi 0000:03:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80819104
[   66.241817] iwlwifi 0000:03:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[   66.241832] iwlwifi 0000:03:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
[   66.241848] iwlwifi 0000:03:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[   66.241863] iwlwifi 0000:03:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
[   66.241878] iwlwifi 0000:03:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
[   66.241941] iwlwifi 0000:03:00.0: Start IWL Event Log Dump: display last 5 entries
[   66.241961] iwlwifi 0000:03:00.0: EVT_LOGT:0000000000:0x0000028c:0117
[   66.241973] iwlwifi 0000:03:00.0: EVT_LOGT:0000000021:0x00000000:1208
[   66.241985] iwlwifi 0000:03:00.0: EVT_LOGT:0000001005:0x00000001:0071
[   66.241998] iwlwifi 0000:03:00.0: EVT_LOGT:0000001081:0x00000002:0071
[   66.242010] iwlwifi 0000:03:00.0: EVT_LOGT:0000001087:0x00000000:0125
[   66.242345] iwlwifi 0000:03:00.0: Failed to run INIT ucode: -5
[   66.242434] iwlwifi 0000:03:00.0: Unable to initialize device.
[   66.242519] ieee80211 phy0: Hardware restart was requested
[   67.070582] audit_printk_skb: 55 callbacks suppressed
[   67.070585] type=1400 audit(1343841324.997:30): apparmor="DENIED" operation="open" parent=2486 profile="/usr/lib/telepathy/mission-control-5" name="/usr/share/gvfs/remote-volume-monitors/" pid=2487 comm="mission-control" requested_mask="r" denied_mask="r" fsuid=1001 ouid=0
[   71.219216] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[   71.234827] iwlwifi 0000:03:00.0: Microcode SW error detected.  Restarting 0x82000000.
[   71.234838] iwlwifi 0000:03:00.0: Loaded firmware version: 39.31.5.1 build 35138
[   71.234945] iwlwifi 0000:03:00.0: Start IWL Error Log Dump:
[   71.234946] iwlwifi 0000:03:00.0: Status: 0x00040224, count: 5
[   71.234948] iwlwifi 0000:03:00.0: 0x00000005 | SYSASSERT                   
[   71.234949] iwlwifi 0000:03:00.0: 0x00016E00 | uPc
[   71.234950] iwlwifi 0000:03:00.0: 0x00016E00 | branchlink1
[   71.234951] iwlwifi 0000:03:00.0: 0x00016E00 | branchlink2
[   71.234952] iwlwifi 0000:03:00.0: 0x00000000 | interruptlink1
[   71.234953] iwlwifi 0000:03:00.0: 0x00000000 | interruptlink2
[   71.234954] iwlwifi 0000:03:00.0: 0x00000000 | data1
[   71.234955] iwlwifi 0000:03:00.0: 0x00000000 | data2
[   71.234956] iwlwifi 0000:03:00.0: 0x00000616 | line
[   71.234957] iwlwifi 0000:03:00.0: 0x00018BCA | beacon time
[   71.234958] iwlwifi 0000:03:00.0: 0x00000436 | tsf low
[   71.234959] iwlwifi 0000:03:00.0: 0x00000000 | tsf hi
[   71.234960] iwlwifi 0000:03:00.0: 0x00000000 | time gp1
[   71.234961] iwlwifi 0000:03:00.0: 0x0000043A | time gp2
[   71.234962] iwlwifi 0000:03:00.0: 0x00000000 | time gp3
[   71.234963] iwlwifi 0000:03:00.0: 0x0001271F | uCode version
[   71.234964] iwlwifi 0000:03:00.0: 0x0000006C | hw version
[   71.234965] iwlwifi 0000:03:00.0: 0x00880300 | board version
[   71.234966] iwlwifi 0000:03:00.0: 0x00000000 | hcmd
[   71.234967] iwlwifi 0000:03:00.0: CSR values:
[   71.234968] iwlwifi 0000:03:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
[   71.234973] iwlwifi 0000:03:00.0:        CSR_HW_IF_CONFIG_REG: 0X00880300
[   71.234978] iwlwifi 0000:03:00.0:          CSR_INT_COALESCING: 0X00000040
[   71.234983] iwlwifi 0000:03:00.0:                     CSR_INT: 0X80000000
[   71.234988] iwlwifi 0000:03:00.0:                CSR_INT_MASK: 0X00000000
[   71.234993] iwlwifi 0000:03:00.0:           CSR_FH_INT_STATUS: 0X40010000
[   71.234998] iwlwifi 0000:03:00.0:                 CSR_GPIO_IN: 0X00000000
[   71.235003] iwlwifi 0000:03:00.0:                   CSR_RESET: 0X00000000
[   71.235008] iwlwifi 0000:03:00.0:                CSR_GP_CNTRL: 0X080403c5
[   71.235012] iwlwifi 0000:03:00.0:                  CSR_HW_REV: 0X0000006c
[   71.235017] iwlwifi 0000:03:00.0:              CSR_EEPROM_REG: 0Xc63f3885
[   71.235022] iwlwifi 0000:03:00.0:               CSR_EEPROM_GP: 0X90000001
[   71.235027] iwlwifi 0000:03:00.0:              CSR_OTP_GP_REG: 0X00210801
[   71.235032] iwlwifi 0000:03:00.0:                 CSR_GIO_REG: 0X00080046
[   71.235037] iwlwifi 0000:03:00.0:            CSR_GP_UCODE_REG: 0X00000000
[   71.235042] iwlwifi 0000:03:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[   71.235046] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[   71.235051] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[   71.235056] iwlwifi 0000:03:00.0:                 CSR_LED_REG: 0X00000018
[   71.235061] iwlwifi 0000:03:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
[   71.235066] iwlwifi 0000:03:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[   71.235071] iwlwifi 0000:03:00.0:             CSR_ANA_PLL_CFG: 0X00000000
[   71.235076] iwlwifi 0000:03:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[   71.235080] iwlwifi 0000:03:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
[   71.235082] iwlwifi 0000:03:00.0: FH register values:
[   71.235097] iwlwifi 0000:03:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X1336ff00
[   71.235112] iwlwifi 0000:03:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X01336fe0
[   71.235127] iwlwifi 0000:03:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
[   71.235142] iwlwifi 0000:03:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80819104
[   71.235158] iwlwifi 0000:03:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[   71.235173] iwlwifi 0000:03:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
[   71.235188] iwlwifi 0000:03:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[   71.235204] iwlwifi 0000:03:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
[   71.235219] iwlwifi 0000:03:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
[   71.235281] iwlwifi 0000:03:00.0: Start IWL Event Log Dump: display last 5 entries
[   71.235301] iwlwifi 0000:03:00.0: EVT_LOGT:0000000000:0x0000028c:0117
[   71.235313] iwlwifi 0000:03:00.0: EVT_LOGT:0000000021:0x00000000:1208
[   71.235325] iwlwifi 0000:03:00.0: EVT_LOGT:0000001003:0x00000001:0071
[   71.235337] iwlwifi 0000:03:00.0: EVT_LOGT:0000001079:0x00000002:0071
[   71.235349] iwlwifi 0000:03:00.0: EVT_LOGT:0000001085:0x00000000:0125
[   71.235687] iwlwifi 0000:03:00.0: Failed to run INIT ucode: -5
[   71.235751] iwlwifi 0000:03:00.0: Unable to initialize device.
[   71.235820] ieee80211 phy0: Hardware restart was requested
[  271.021326] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[  271.037759] iwlwifi 0000:03:00.0: Microcode SW error detected.  Restarting 0x82000000.
[  271.037772] iwlwifi 0000:03:00.0: Loaded firmware version: 39.31.5.1 build 35138
[  271.037872] iwlwifi 0000:03:00.0: Start IWL Error Log Dump:
[  271.037878] iwlwifi 0000:03:00.0: Status: 0x00040224, count: 5
[  271.037883] iwlwifi 0000:03:00.0: 0x00000005 | SYSASSERT                   
[  271.037888] iwlwifi 0000:03:00.0: 0x00016E00 | uPc
[  271.037893] iwlwifi 0000:03:00.0: 0x00016E00 | branchlink1
[  271.037897] iwlwifi 0000:03:00.0: 0x00016E00 | branchlink2
[  271.037901] iwlwifi 0000:03:00.0: 0x00000000 | interruptlink1
[  271.037905] iwlwifi 0000:03:00.0: 0x00000000 | interruptlink2
[  271.037909] iwlwifi 0000:03:00.0: 0x00000000 | data1
[  271.037913] iwlwifi 0000:03:00.0: 0x00000000 | data2
[  271.037917] iwlwifi 0000:03:00.0: 0x00000616 | line
[  271.037921] iwlwifi 0000:03:00.0: 0x00018BC8 | beacon time
[  271.037925] iwlwifi 0000:03:00.0: 0x00000438 | tsf low
[  271.037929] iwlwifi 0000:03:00.0: 0x00000000 | tsf hi
[  271.037933] iwlwifi 0000:03:00.0: 0x00000000 | time gp1
[  271.037937] iwlwifi 0000:03:00.0: 0x0000043C | time gp2
[  271.037941] iwlwifi 0000:03:00.0: 0x00000000 | time gp3
[  271.037946] iwlwifi 0000:03:00.0: 0x0001271F | uCode version
[  271.037950] iwlwifi 0000:03:00.0: 0x0000006C | hw version
[  271.037954] iwlwifi 0000:03:00.0: 0x00880300 | board version
[  271.037958] iwlwifi 0000:03:00.0: 0x00000000 | hcmd
[  271.037962] iwlwifi 0000:03:00.0: CSR values:
[  271.037966] iwlwifi 0000:03:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
[  271.037976] iwlwifi 0000:03:00.0:        CSR_HW_IF_CONFIG_REG: 0X00880300
[  271.037985] iwlwifi 0000:03:00.0:          CSR_INT_COALESCING: 0X00000040
[  271.037994] iwlwifi 0000:03:00.0:                     CSR_INT: 0X80000000
[  271.038003] iwlwifi 0000:03:00.0:                CSR_INT_MASK: 0X00000000
[  271.038013] iwlwifi 0000:03:00.0:           CSR_FH_INT_STATUS: 0X40010000
[  271.038021] iwlwifi 0000:03:00.0:                 CSR_GPIO_IN: 0X00000000
[  271.038030] iwlwifi 0000:03:00.0:                   CSR_RESET: 0X00000000
[  271.038039] iwlwifi 0000:03:00.0:                CSR_GP_CNTRL: 0X080403c5
[  271.038048] iwlwifi 0000:03:00.0:                  CSR_HW_REV: 0X0000006c
[  271.038056] iwlwifi 0000:03:00.0:              CSR_EEPROM_REG: 0Xc63f3885
[  271.038065] iwlwifi 0000:03:00.0:               CSR_EEPROM_GP: 0X90000001
[  271.038074] iwlwifi 0000:03:00.0:              CSR_OTP_GP_REG: 0X00210801
[  271.038082] iwlwifi 0000:03:00.0:                 CSR_GIO_REG: 0X00080046
[  271.038091] iwlwifi 0000:03:00.0:            CSR_GP_UCODE_REG: 0X00000000
[  271.038100] iwlwifi 0000:03:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[  271.038108] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[  271.038117] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[  271.038126] iwlwifi 0000:03:00.0:                 CSR_LED_REG: 0X00000018
[  271.038134] iwlwifi 0000:03:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
[  271.038142] iwlwifi 0000:03:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[  271.038151] iwlwifi 0000:03:00.0:             CSR_ANA_PLL_CFG: 0X00000000
[  271.038160] iwlwifi 0000:03:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[  271.038168] iwlwifi 0000:03:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
[  271.038173] iwlwifi 0000:03:00.0: FH register values:
[  271.038193] iwlwifi 0000:03:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X1336ff00
[  271.038213] iwlwifi 0000:03:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X01336fe0
[  271.038233] iwlwifi 0000:03:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
[  271.038253] iwlwifi 0000:03:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80819104
[  271.038273] iwlwifi 0000:03:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[  271.038296] iwlwifi 0000:03:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
[  271.038319] iwlwifi 0000:03:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[  271.038342] iwlwifi 0000:03:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
[  271.038364] iwlwifi 0000:03:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
[  271.038433] iwlwifi 0000:03:00.0: Start IWL Event Log Dump: display last 5 entries
[  271.038459] iwlwifi 0000:03:00.0: EVT_LOGT:0000000000:0x0000028c:0117
[  271.038476] iwlwifi 0000:03:00.0: EVT_LOGT:0000000021:0x00000000:1208
[  271.038491] iwlwifi 0000:03:00.0: EVT_LOGT:0000001005:0x00000001:0071
[  271.038507] iwlwifi 0000:03:00.0: EVT_LOGT:0000001081:0x00000002:0071
[  271.038523] iwlwifi 0000:03:00.0: EVT_LOGT:0000001087:0x00000000:0125
[  271.038920] iwlwifi 0000:03:00.0: Failed to run INIT ucode: -5
[  271.039025] iwlwifi 0000:03:00.0: Unable to initialize device.
[  271.039156] ieee80211 phy0: Hardware restart was requested
[  475.791935] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[  475.808222] iwlwifi 0000:03:00.0: Microcode SW error detected.  Restarting 0x82000000.
[  475.808234] iwlwifi 0000:03:00.0: Loaded firmware version: 39.31.5.1 build 35138
[  475.808333] iwlwifi 0000:03:00.0: Start IWL Error Log Dump:
[  475.808339] iwlwifi 0000:03:00.0: Status: 0x00040224, count: 5
[  475.808345] iwlwifi 0000:03:00.0: 0x00000005 | SYSASSERT                   
[  475.808350] iwlwifi 0000:03:00.0: 0x00016E00 | uPc
[  475.808354] iwlwifi 0000:03:00.0: 0x00016E00 | branchlink1
[  475.808358] iwlwifi 0000:03:00.0: 0x00016E00 | branchlink2
[  475.808363] iwlwifi 0000:03:00.0: 0x00000000 | interruptlink1
[  475.808367] iwlwifi 0000:03:00.0: 0x00000000 | interruptlink2
[  475.808371] iwlwifi 0000:03:00.0: 0x00000000 | data1
[  475.808375] iwlwifi 0000:03:00.0: 0x00000000 | data2
[  475.808379] iwlwifi 0000:03:00.0: 0x00000616 | line
[  475.808383] iwlwifi 0000:03:00.0: 0x00018BC9 | beacon time
[  475.808387] iwlwifi 0000:03:00.0: 0x00000437 | tsf low
[  475.808391] iwlwifi 0000:03:00.0: 0x00000000 | tsf hi
[  475.808395] iwlwifi 0000:03:00.0: 0x00000000 | time gp1
[  475.808399] iwlwifi 0000:03:00.0: 0x0000043B | time gp2
[  475.808403] iwlwifi 0000:03:00.0: 0x00000000 | time gp3
[  475.808407] iwlwifi 0000:03:00.0: 0x0001271F | uCode version
[  475.808411] iwlwifi 0000:03:00.0: 0x0000006C | hw version
[  475.808416] iwlwifi 0000:03:00.0: 0x00880300 | board version
[  475.808420] iwlwifi 0000:03:00.0: 0x00000000 | hcmd
[  475.808424] iwlwifi 0000:03:00.0: CSR values:
[  475.808428] iwlwifi 0000:03:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
[  475.808438] iwlwifi 0000:03:00.0:        CSR_HW_IF_CONFIG_REG: 0X00880300
[  475.808447] iwlwifi 0000:03:00.0:          CSR_INT_COALESCING: 0X00000040
[  475.808456] iwlwifi 0000:03:00.0:                     CSR_INT: 0X80000000
[  475.808465] iwlwifi 0000:03:00.0:                CSR_INT_MASK: 0X00000000
[  475.808474] iwlwifi 0000:03:00.0:           CSR_FH_INT_STATUS: 0X40010000
[  475.808483] iwlwifi 0000:03:00.0:                 CSR_GPIO_IN: 0X00000000
[  475.808491] iwlwifi 0000:03:00.0:                   CSR_RESET: 0X00000000
[  475.808500] iwlwifi 0000:03:00.0:                CSR_GP_CNTRL: 0X080403c5
[  475.808508] iwlwifi 0000:03:00.0:                  CSR_HW_REV: 0X0000006c
[  475.808517] iwlwifi 0000:03:00.0:              CSR_EEPROM_REG: 0Xc63f3885
[  475.808526] iwlwifi 0000:03:00.0:               CSR_EEPROM_GP: 0X90000001
[  475.808535] iwlwifi 0000:03:00.0:              CSR_OTP_GP_REG: 0X00210801
[  475.808543] iwlwifi 0000:03:00.0:                 CSR_GIO_REG: 0X00080046
[  475.808552] iwlwifi 0000:03:00.0:            CSR_GP_UCODE_REG: 0X00000000
[  475.808561] iwlwifi 0000:03:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[  475.808569] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[  475.808578] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[  475.808587] iwlwifi 0000:03:00.0:                 CSR_LED_REG: 0X00000018
[  475.808595] iwlwifi 0000:03:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
[  475.808604] iwlwifi 0000:03:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[  475.808612] iwlwifi 0000:03:00.0:             CSR_ANA_PLL_CFG: 0X00000000
[  475.808621] iwlwifi 0000:03:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[  475.808630] iwlwifi 0000:03:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
[  475.808634] iwlwifi 0000:03:00.0: FH register values:
[  475.808653] iwlwifi 0000:03:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X1336ff00
[  475.808673] iwlwifi 0000:03:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X01336fe0
[  475.808693] iwlwifi 0000:03:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
[  475.808713] iwlwifi 0000:03:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80819104
[  475.808732] iwlwifi 0000:03:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[  475.808752] iwlwifi 0000:03:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
[  475.808772] iwlwifi 0000:03:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[  475.808791] iwlwifi 0000:03:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
[  475.808811] iwlwifi 0000:03:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
[  475.808880] iwlwifi 0000:03:00.0: Start IWL Event Log Dump: display last 5 entries
[  475.808906] iwlwifi 0000:03:00.0: EVT_LOGT:0000000000:0x0000028c:0117
[  475.808922] iwlwifi 0000:03:00.0: EVT_LOGT:0000000021:0x00000000:1208
[  475.808939] iwlwifi 0000:03:00.0: EVT_LOGT:0000001004:0x00000001:0071
[  475.808955] iwlwifi 0000:03:00.0: EVT_LOGT:0000001080:0x00000002:0071
[  475.808971] iwlwifi 0000:03:00.0: EVT_LOGT:0000001086:0x00000000:0125
[  475.809389] iwlwifi 0000:03:00.0: Failed to run INIT ucode: -5
[  475.809506] iwlwifi 0000:03:00.0: Unable to initialize device.
[  475.809634] ieee80211 phy0: Hardware restart was requested
[  675.577322] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[  675.593589] iwlwifi 0000:03:00.0: Microcode SW error detected.  Restarting 0x82000000.
[  675.593602] iwlwifi 0000:03:00.0: Loaded firmware version: 39.31.5.1 build 35138
[  675.593701] iwlwifi 0000:03:00.0: Start IWL Error Log Dump:
[  675.593707] iwlwifi 0000:03:00.0: Status: 0x00040224, count: 5
[  675.593713] iwlwifi 0000:03:00.0: 0x00000005 | SYSASSERT                   
[  675.593718] iwlwifi 0000:03:00.0: 0x00016E00 | uPc
[  675.593723] iwlwifi 0000:03:00.0: 0x00016E00 | branchlink1
[  675.593727] iwlwifi 0000:03:00.0: 0x00016E00 | branchlink2
[  675.593731] iwlwifi 0000:03:00.0: 0x00000000 | interruptlink1
[  675.593735] iwlwifi 0000:03:00.0: 0x00000000 | interruptlink2
[  675.593739] iwlwifi 0000:03:00.0: 0x00000000 | data1
[  675.593743] iwlwifi 0000:03:00.0: 0x00000000 | data2
[  675.593747] iwlwifi 0000:03:00.0: 0x00000616 | line
[  675.593751] iwlwifi 0000:03:00.0: 0x00018BC8 | beacon time
[  675.593756] iwlwifi 0000:03:00.0: 0x00000438 | tsf low
[  675.593761] iwlwifi 0000:03:00.0: 0x00000000 | tsf hi
[  675.593767] iwlwifi 0000:03:00.0: 0x00000000 | time gp1
[  675.593773] iwlwifi 0000:03:00.0: 0x0000043C | time gp2
[  675.593780] iwlwifi 0000:03:00.0: 0x00000000 | time gp3
[  675.593787] iwlwifi 0000:03:00.0: 0x0001271F | uCode version
[  675.593795] iwlwifi 0000:03:00.0: 0x0000006C | hw version
[  675.593803] iwlwifi 0000:03:00.0: 0x00880300 | board version
[  675.593809] iwlwifi 0000:03:00.0: 0x00000000 | hcmd
[  675.593815] iwlwifi 0000:03:00.0: CSR values:
[  675.593822] iwlwifi 0000:03:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
[  675.593839] iwlwifi 0000:03:00.0:        CSR_HW_IF_CONFIG_REG: 0X00880300
[  675.593851] iwlwifi 0000:03:00.0:          CSR_INT_COALESCING: 0X00000040
[  675.593860] iwlwifi 0000:03:00.0:                     CSR_INT: 0X80000000
[  675.593869] iwlwifi 0000:03:00.0:                CSR_INT_MASK: 0X00000000
[  675.593878] iwlwifi 0000:03:00.0:           CSR_FH_INT_STATUS: 0X40010000
[  675.593886] iwlwifi 0000:03:00.0:                 CSR_GPIO_IN: 0X00000000
[  675.593895] iwlwifi 0000:03:00.0:                   CSR_RESET: 0X00000000
[  675.593904] iwlwifi 0000:03:00.0:                CSR_GP_CNTRL: 0X080403c5
[  675.593912] iwlwifi 0000:03:00.0:                  CSR_HW_REV: 0X0000006c
[  675.593921] iwlwifi 0000:03:00.0:              CSR_EEPROM_REG: 0Xc63f3885
[  675.593930] iwlwifi 0000:03:00.0:               CSR_EEPROM_GP: 0X90000001
[  675.593939] iwlwifi 0000:03:00.0:              CSR_OTP_GP_REG: 0X00210801
[  675.593947] iwlwifi 0000:03:00.0:                 CSR_GIO_REG: 0X00080046
[  675.593956] iwlwifi 0000:03:00.0:            CSR_GP_UCODE_REG: 0X00000000
[  675.593965] iwlwifi 0000:03:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[  675.593973] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[  675.593982] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[  675.593991] iwlwifi 0000:03:00.0:                 CSR_LED_REG: 0X00000018
[  675.593999] iwlwifi 0000:03:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
[  675.594008] iwlwifi 0000:03:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[  675.594017] iwlwifi 0000:03:00.0:             CSR_ANA_PLL_CFG: 0X00000000
[  675.594026] iwlwifi 0000:03:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[  675.594034] iwlwifi 0000:03:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
[  675.594039] iwlwifi 0000:03:00.0: FH register values:
[  675.594059] iwlwifi 0000:03:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X1336ff00
[  675.594079] iwlwifi 0000:03:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X01336fe0
[  675.594099] iwlwifi 0000:03:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
[  675.594119] iwlwifi 0000:03:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80819104
[  675.594138] iwlwifi 0000:03:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[  675.594158] iwlwifi 0000:03:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
[  675.594178] iwlwifi 0000:03:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[  675.594198] iwlwifi 0000:03:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
[  675.594218] iwlwifi 0000:03:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
[  675.594286] iwlwifi 0000:03:00.0: Start IWL Event Log Dump: display last 5 entries
[  675.594313] iwlwifi 0000:03:00.0: EVT_LOGT:0000000000:0x0000028c:0117
[  675.594329] iwlwifi 0000:03:00.0: EVT_LOGT:0000000021:0x00000000:1208
[  675.594345] iwlwifi 0000:03:00.0: EVT_LOGT:0000001005:0x00000001:0071
[  675.594361] iwlwifi 0000:03:00.0: EVT_LOGT:0000001081:0x00000002:0071
[  675.594377] iwlwifi 0000:03:00.0: EVT_LOGT:0000001087:0x00000000:0125
[  675.594758] iwlwifi 0000:03:00.0: Failed to run INIT ucode: -5
[  675.594863] iwlwifi 0000:03:00.0: Unable to initialize device.
[  675.594986] ieee80211 phy0: Hardware restart was requested

--------------030007050002000100050600--
