Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54402 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752783AbdLEKYh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Dec 2017 05:24:37 -0500
Date: Tue, 5 Dec 2017 11:24:34 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>
Cc: johannes.berg@intel.com, linville@tuxdriver.com,
        linux-wireless@vger.kernel.org
Subject: 4.15.0-rc1-next-20171201: WARNING: .... at net/mac80211/agg-tx.c:315
Message-ID: <20171205102434.GA12780@amd> (sfid-20171205_112513_000468_DF5ED568)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="dDRMvlgZJXvWKvBx"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

This is quite annoying: repeated

[ 4169.591529] ---[ end trace e65d97cf1d20b84d ]---
[ 4169.591565] WARNING: CPU: 0 PID: 5472 at net/mac80211/agg-tx.c:315
___ieee80211_stop_tx_\
ba_session+0x158/0x1f0

Hardware is thinkpad x60. Git blame says cfcdbde35 introduced the
test.

									Pavel
								=09

[    0.000000] Linux version 4.15.0-rc1-next-20171201 (pavel@amd) (gcc vers=
ion 4.9.2 (Debian 4.9.2-10)) #4 SMP Sat Dec 2 11:25:11 CET 2017
[    0.000000] Disabled fast string operations
[    0.000000] x86/fpu: x87 FPU will use FXSAVE
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009efff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009f000-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000dc000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000bf6cffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bf6d0000-0x00000000bf6defff] ACPI =
data
[    0.000000] BIOS-e820: [mem 0x00000000bf6df000-0x00000000bf6fffff] ACPI =
NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf700000-0x00000000bfffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000f0000000-0x00000000f3ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec0ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed003ff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fed14000-0x00000000fed19fff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed8ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000ff800000-0x00000000ffffffff] reser=
ved
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] random: fast init done
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: LENOVO 17097HU/17097HU, BIOS 7BETD8WW (2.19 ) 03/31/2011
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xbf6d0 max_arch_pfn =3D 0x1000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-DBFFF uncachable
[    0.000000]   DC000-DFFFF write-back
[    0.000000]   E0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 080000000 mask FC0000000 write-back
[    0.000000]   2 base 0BF700000 mask FFFF00000 uncachable
[    0.000000]   3 base 0BF800000 mask FFF800000 uncachable
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86/PAT: PAT not supported by CPU.
[    0.000000] x86/PAT: Configuration [0-7]: WB  WT  UC- UC  WB  WT  UC- UC=
 =20
[    0.000000] initial memory mapped: [mem 0x00000000-0x05dfffff]
[    0.000000] Base memory trampoline at [(ptrval)] 9b000 size 16384
[    0.000000] BRK [0x0591a000, 0x0591afff] PGTABLE
[    0.000000] BRK [0x0591b000, 0x0591bfff] PGTABLE
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F67C0 000024 (v02 LENOVO)
[    0.000000] ACPI: XSDT 0x00000000BF6D191C 000084 (v01 LENOVO TP-7B    00=
002190  LTP 00000000)
[    0.000000] ACPI: FACP 0x00000000BF6D1A00 0000F4 (v03 LENOVO TP-7B    00=
002190 LNVO 00000001)
[    0.000000] ACPI BIOS Warning (bug): 32/64X length mismatch in FADT/Gpe0=
Block: 64/32 (20171110/tbfadt-603)
[    0.000000] ACPI BIOS Warning (bug): Optional FADT field Gpe1Block has v=
alid Address but zero Length: 0x000000000000102C/0x0 (20171110/tbfadt-658)
[    0.000000] ACPI: DSDT 0x00000000BF6D1D90 00CFB9 (v01 LENOVO TP-7B    00=
002190 MSFT 0100000E)
[    0.000000] ACPI: FACS 0x00000000BF6F4000 000040
[    0.000000] ACPI: FACS 0x00000000BF6F4000 000040
[    0.000000] ACPI: SSDT 0x00000000BF6D1BB4 0001DC (v01 LENOVO TP-7B    00=
002190 MSFT 0100000E)
[    0.000000] ACPI: ECDT 0x00000000BF6DED49 000052 (v01 LENOVO TP-7B    00=
002190 LNVO 00000001)
[    0.000000] ACPI: TCPA 0x00000000BF6DED9B 000032 (v02 LENOVO TP-7B    00=
002190 LNVO 00000001)
[    0.000000] ACPI: APIC 0x00000000BF6DEDCD 000068 (v01 LENOVO TP-7B    00=
002190 LNVO 00000001)
[    0.000000] ACPI: MCFG 0x00000000BF6DEE35 00003C (v01 LENOVO TP-7B    00=
002190 LNVO 00000001)
[    0.000000] ACPI: HPET 0x00000000BF6DEE71 000038 (v01 LENOVO TP-7B    00=
002190 LNVO 00000001)
[    0.000000] ACPI: BOOT 0x00000000BF6DEFD8 000028 (v01 LENOVO TP-7B    00=
002190  LTP 00000001)
[    0.000000] ACPI: SSDT 0x00000000BF6F2645 00025F (v01 LENOVO TP-7B    00=
002190 INTL 20050513)
[    0.000000] ACPI: SSDT 0x00000000BF6F28A4 0000A6 (v01 LENOVO TP-7B    00=
002190 INTL 20050513)
[    0.000000] ACPI: SSDT 0x00000000BF6F294A 0004F7 (v01 LENOVO TP-7B    00=
002190 INTL 20050513)
[    0.000000] ACPI: SSDT 0x00000000BF6F2E41 0001D8 (v01 LENOVO TP-7B    00=
002190 INTL 20050513)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 2170MB HIGHMEM available.
[    0.000000] 891MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 37bfe000
[    0.000000]   low ram: 0 - 37bfe000
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.000000]   Normal   [mem 0x0000000001000000-0x0000000037bfdfff]
[    0.000000]   HighMem  [mem 0x0000000037bfe000-0x00000000bf6cffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000001000-0x000000000009efff]
[    0.000000]   node   0: [mem 0x0000000000100000-0x00000000bf6cffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x00000000bf6cf=
fff]
[    0.000000] On node 0 totalpages: 783982
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 1752 pages used for memmap
[    0.000000]   Normal zone: 224254 pages, LIFO batch:31
[    0.000000]   HighMem zone: 555730 pages, LIFO batch:31
[    0.000000] Reserved but unavailable: 98 pages
[    0.000000] Using APIC driver default
[    0.000000] Reserving Intel graphics memory at 0x00000000bf800000-0x0000=
0000bfffffff
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dbfff]
[    0.000000] PM: Registered nosave memory: [mem 0x000dc000-0x000fffff]
[    0.000000] e820: [mem 0xc0000000-0xefffffff] available for PCI devices
[    0.000000] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0=
xffffffff, max_idle_ns: 7645519600211568 ns
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] percpu: Embedded 23 pages/cpu @(ptrval) s61672 r0 d32536 u94=
208
[    0.000000] pcpu-alloc: s61672 r0 d32536 u94208 alloc=3D23*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 782198
[    0.000000] Kernel command line: BOOT_IMAGE=3D(hd0,2)/fast/l/linux-next-=
32/arch/x86/boot/bzImage root=3D/dev/sda4 resume=3D/dev/sda1
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 by=
tes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00037bfe:000bf6d0)
[    0.000000] Initializing Movable for node 0 (00000000:00000000)
[    0.000000] Memory: 3084652K/3135928K available (12792K kernel code, 694=
K rwdata, 5080K rodata, 564K init, 6172K bss, 51276K reserved, 0K cma-reser=
ved, 2222920K highmem)
[    0.000000] virtual kernel memory layout:
    fixmap  : 0xffe47000 - 0xfffff000   (1760 kB)
    pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
    vmalloc : 0xf83fe000 - 0xffbfe000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf7bfe000   ( 891 MB)
      .init : 0xc524b000 - 0xc52d8000   ( 564 kB)
      .data : 0xc4c7e1df - 0xc5228a40   (5802 kB)
      .text : 0xc4000000 - 0xc4c7e1df   (12792 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=3D8 to nr_cpu_ids=3D2.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS: 2304, nr_irqs: 56, preallocated irqs: 16
[    0.000000] CPU 0 irqstacks, hard=3D(ptrval) soft=3D(ptrval)
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000]  memory used by lock dependency info: 4383 kB
[    0.000000]  per task-struct memory footprint: 1344 bytes
[    0.000000] ACPI: Core revision 20171110
[    0.000000] ACPI: 6 ACPI AML tables successfully acquired and loaded
[    0.000000] clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff, =
max_idle_ns: 133484882848 ns
[    0.000000] hpet clockevent registered
[    0.000000] APIC: Switch to symmetric I/O mode setup
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.020000] tsc: Fast TSC calibration using PIT
[    0.024000] tsc: Detected 1828.833 MHz processor
[    0.024000] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 3657.66 BogoMIPS (lpj=3D7315332)
[    0.024000] pid_max: default: 32768 minimum: 301
[    0.024000] Mount-cache hash table entries: 2048 (order: 1, 8192 bytes)
[    0.024000] Mountpoint-cache hash table entries: 2048 (order: 1, 8192 by=
tes)
[    0.028582] Disabled fast string operations
[    0.028679] CPU: Physical Processor ID: 0
[    0.028767] CPU: Processor Core ID: 0
[    0.028863] process: using mwait in idle threads
[    0.028967] Last level iTLB entries: 4KB 128, 2MB 0, 4MB 2
[    0.029067] Last level dTLB entries: 4KB 128, 2MB 0, 4MB 8, 1GB 0
[    0.029374] Freeing SMP alternatives memory: 44K
[    0.036000] smpboot: CPU0: Genuine Intel(R) CPU           T2400  @ 1.83G=
Hz (family: 0x6, model: 0xe, stepping: 0x8)
[    0.036000] Performance Events: Core events, core PMU driver.
[    0.036000] ... version:                1
[    0.036000] ... bit width:              40
[    0.036000] ... generic registers:      2
[    0.036000] ... value mask:             000000ffffffffff
[    0.036000] ... max period:             000000007fffffff
[    0.036000] ... fixed-purpose events:   0
[    0.036000] ... event mask:             0000000000000003
[    0.036000] Hierarchical SRCU implementation.
[    0.038094] NMI watchdog: Enabled. Permanently consumes one hw-PMU count=
er.
[    0.038319] smp: Bringing up secondary CPUs ...
[    0.040035] CPU 1 irqstacks, hard=3D9a3989fa soft=3Dfebb13fd
[    0.040041] x86: Booting SMP configuration:
[    0.040145] .... node  #0, CPUs:      #1
[    0.004000] Initializing CPU#1
[    0.004000] Disabled fast string operations
[    0.042770] TSC synchronization [CPU#0 -> CPU#1]:
[    0.043154] Measured 579788 cycles TSC warp between CPUs, turning off TS=
C clock.
[    0.043288] tsc: Marking TSC unstable due to check_tsc_sync_source failed
[    0.043525] smp: Brought up 1 node, 2 CPUs
[    0.043525] smpboot: Max logical packages: 1
[    0.043525] smpboot: Total of 2 processors activated (7315.33 BogoMIPS)
[    0.046715] devtmpfs: initialized
[    0.046715] PM: Registering ACPI NVS region [mem 0xbf6df000-0xbf6fffff] =
(135168 bytes)
[    0.048315] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xfffffff=
f, max_idle_ns: 7645041785100000 ns
[    0.048341] futex hash table entries: 512 (order: 3, 32768 bytes)
[    0.048573] NET: Registered protocol family 16
[    0.053534] cpuidle: using governor ladder
[    0.053793] cpuidle: using governor menu
[    0.054061] Simple Boot Flag at 0x35 set to 0x1
[    0.054061] ACPI FADT declares the system doesn't support PCIe ASPM, so =
disable it
[    0.054061] ACPI: bus type PCI registered
[    0.054197] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf0000000=
-0xf3ffffff] (base 0xf0000000)
[    0.054197] PCI: MMCONFIG at [mem 0xf0000000-0xf3ffffff] reserved in E820
[    0.054197] PCI: Using MMCONFIG for extended config space
[    0.054197] PCI: Using configuration type 1 for base access
[    0.056229] mtrr: your CPUs had inconsistent variable MTRR settings
[    0.056229] mtrr: probably your BIOS does not setup all CPUs.
[    0.056229] mtrr: corrected configuration.
[    0.176559] ACPI: Added _OSI(Module Device)
[    0.176660] ACPI: Added _OSI(Processor Device)
[    0.176755] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.176852] ACPI: Added _OSI(Processor Aggregator Device)
[    0.176984] ACPI: EC: EC started
[    0.177071] ACPI: EC: interrupt blocked
[    0.186481] ACPI: \: Used as first EC
[    0.186577] ACPI: \: GPE=3D0x1c, EC_CMD/EC_SC=3D0x66, EC_DATA=3D0x62
[    0.186686] ACPI: \: Used as boot ECDT EC to handle transactions
[    0.268807] ACPI: Dynamic OEM Table Load:
[    0.268934] ACPI: SSDT 0x00000000F56F1400 000240 (v01 PmRef  Cpu0Ist  00=
000100 INTL 20050513)
[    0.271271] ACPI: Dynamic OEM Table Load:
[    0.271397] ACPI: SSDT 0x00000000F5C2F000 00065A (v01 PmRef  Cpu0Cst  00=
000100 INTL 20050513)
[    0.278963] ACPI: Dynamic OEM Table Load:
[    0.278963] ACPI: SSDT 0x00000000F5D70300 0000C8 (v01 PmRef  Cpu1Ist  00=
000100 INTL 20050513)
[    0.279737] ACPI: Dynamic OEM Table Load:
[    0.279859] ACPI: SSDT 0x00000000F540BD80 000085 (v01 PmRef  Cpu1Cst  00=
000100 INTL 20050513)
[    0.285800] ACPI: Interpreter enabled
[    0.286035] ACPI: (supports S0 S3 S4 S5)
[    0.286137] ACPI: Using IOAPIC for interrupt routing
[    0.286456] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.288831] ACPI: Enabled 4 GPEs in block 00 to 1F
[    0.332594] ACPI: Power Resource [PUBS] (on)
[    0.337079] acpi PNP0C0A:01: ACPI dock station (docks/bays count: 1)
[    0.354129] acpi LNXIOBAY:00: ACPI dock station (docks/bays count: 2)
[    0.375138] acpi IBM0079:00: ACPI dock station (docks/bays count: 3)
[    0.379417] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    0.380913] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
[    0.382384] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
[    0.383855] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    0.385317] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
[    0.386787] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
[    0.388305] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
[    0.389775] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
[    0.390723] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.390855] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM Cloc=
kPM Segments]
[    0.392679] acpi PNP0A08:00: _OSC: not requesting OS control; OS require=
s [ExtendedConfig ASPM ClockPM MSI]
[    0.392860] acpi PNP0A08:00: [Firmware Info]: MMCONFIG for domain 0000 [=
bus 00-3f] only partially covers this bridge
[    0.393463] PCI host bridge to bus 0000:00
[    0.393564] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
[    0.393686] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[    0.393806] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f window]
[    0.393932] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3ff=
f window]
[    0.394057] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7ff=
f window]
[    0.394183] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbff=
f window]
[    0.394309] pci_bus 0000:00: root bus resource [mem 0xc0000000-0xfebffff=
f window]
[    0.394435] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed40ff=
f window]
[    0.394563] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.394720] pci 0000:00:00.0: [8086:27a0] type 00 class 0x060000
[    0.395497] pci 0000:00:02.0: [8086:27a2] type 00 class 0x030000
[    0.395534] pci 0000:00:02.0: reg 0x10: [mem 0xee100000-0xee17ffff]
[    0.395551] pci 0000:00:02.0: reg 0x14: [io  0x1800-0x1807]
[    0.395569] pci 0000:00:02.0: reg 0x18: [mem 0xd0000000-0xdfffffff pref]
[    0.395587] pci 0000:00:02.0: reg 0x1c: [mem 0xee200000-0xee23ffff]
[    0.396401] pci 0000:00:02.1: [8086:27a6] type 00 class 0x038000
[    0.396433] pci 0000:00:02.1: reg 0x10: [mem 0xee180000-0xee1fffff]
[    0.397251] pci 0000:00:1b.0: [8086:27d8] type 00 class 0x040300
[    0.397313] pci 0000:00:1b.0: reg 0x10: [mem 0xee240000-0xee243fff 64bit]
[    0.397536] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.398304] pci 0000:00:1c.0: [8086:27d0] type 01 class 0x060400
[    0.398545] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.399307] pci 0000:00:1c.1: [8086:27d2] type 01 class 0x060400
[    0.399549] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.400321] pci 0000:00:1c.2: [8086:27d4] type 01 class 0x060400
[    0.400562] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.401313] pci 0000:00:1c.3: [8086:27d6] type 01 class 0x060400
[    0.401554] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.402308] pci 0000:00:1d.0: [8086:27c8] type 00 class 0x0c0300
[    0.402411] pci 0000:00:1d.0: reg 0x20: [io  0x1820-0x183f]
[    0.403193] pci 0000:00:1d.1: [8086:27c9] type 00 class 0x0c0300
[    0.403296] pci 0000:00:1d.1: reg 0x20: [io  0x1840-0x185f]
[    0.404090] pci 0000:00:1d.2: [8086:27ca] type 00 class 0x0c0300
[    0.404193] pci 0000:00:1d.2: reg 0x20: [io  0x1860-0x187f]
[    0.404975] pci 0000:00:1d.3: [8086:27cb] type 00 class 0x0c0300
[    0.405078] pci 0000:00:1d.3: reg 0x20: [io  0x1880-0x189f]
[    0.405835] pci 0000:00:1d.7: [8086:27cc] type 00 class 0x0c0320
[    0.405884] pci 0000:00:1d.7: reg 0x10: [mem 0xee444000-0xee4443ff]
[    0.406080] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.406793] pci 0000:00:1e.0: [8086:2448] type 01 class 0x060401
[    0.407673] pci 0000:00:1f.0: [8086:27b9] type 00 class 0x060100
[    0.407879] pci 0000:00:1f.0: quirk: [io  0x1000-0x107f] claimed by ICH6=
 ACPI/GPIO/TCO
[    0.408021] pci 0000:00:1f.0: quirk: [io  0x1180-0x11bf] claimed by ICH6=
 GPIO
[    0.408147] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 1600 (=
mask 007f)
[    0.408275] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 15e0 (=
mask 000f)
[    0.408403] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 1680 (=
mask 001f)
[    0.409246] pci 0000:00:1f.1: [8086:27df] type 00 class 0x01018a
[    0.409287] pci 0000:00:1f.1: reg 0x10: [io  0x0000-0x0007]
[    0.409310] pci 0000:00:1f.1: reg 0x14: [io  0x0000-0x0003]
[    0.409333] pci 0000:00:1f.1: reg 0x18: [io  0x0000-0x0007]
[    0.409355] pci 0000:00:1f.1: reg 0x1c: [io  0x0000-0x0003]
[    0.409378] pci 0000:00:1f.1: reg 0x20: [io  0x1810-0x181f]
[    0.409424] pci 0000:00:1f.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.409547] pci 0000:00:1f.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.409663] pci 0000:00:1f.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.409784] pci 0000:00:1f.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.410601] pci 0000:00:1f.2: [8086:27c5] type 00 class 0x010601
[    0.410650] pci 0000:00:1f.2: reg 0x10: [io  0x18d0-0x18d7]
[    0.410673] pci 0000:00:1f.2: reg 0x14: [io  0x18c4-0x18c7]
[    0.410696] pci 0000:00:1f.2: reg 0x18: [io  0x18c8-0x18cf]
[    0.410719] pci 0000:00:1f.2: reg 0x1c: [io  0x18c0-0x18c3]
[    0.410741] pci 0000:00:1f.2: reg 0x20: [io  0x18b0-0x18bf]
[    0.410765] pci 0000:00:1f.2: reg 0x24: [mem 0xee444400-0xee4447ff]
[    0.410885] pci 0000:00:1f.2: PME# supported from D3hot
[    0.411592] pci 0000:00:1f.3: [8086:27da] type 00 class 0x0c0500
[    0.411714] pci 0000:00:1f.3: reg 0x20: [io  0x18e0-0x18ff]
[    0.412789] pci 0000:02:00.0: [8086:109a] type 00 class 0x020000
[    0.412867] pci 0000:02:00.0: reg 0x10: [mem 0xee000000-0xee01ffff]
[    0.412926] pci 0000:02:00.0: reg 0x18: [io  0x2000-0x201f]
[    0.413242] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.424086] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.424197] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.424209] pci 0000:00:1c.0:   bridge window [mem 0xee000000-0xee0fffff]
[    0.424584] pci 0000:03:00.0: [8086:4227] type 00 class 0x028000
[    0.424708] pci 0000:03:00.0: reg 0x10: [mem 0xedf00000-0xedf00fff]
[    0.425286] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.436133] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.436245] pci 0000:00:1c.1:   bridge window [io  0x3000-0x4fff]
[    0.436257] pci 0000:00:1c.1:   bridge window [mem 0xec000000-0xedffffff]
[    0.436274] pci 0000:00:1c.1:   bridge window [mem 0xe4000000-0xe40fffff=
 64bit pref]
[    0.436519] pci 0000:00:1c.2: PCI bridge to [bus 04-0b]
[    0.436633] pci 0000:00:1c.2:   bridge window [io  0x5000-0x6fff]
[    0.436645] pci 0000:00:1c.2:   bridge window [mem 0xe8000000-0xe9ffffff]
[    0.436662] pci 0000:00:1c.2:   bridge window [mem 0xe4100000-0xe41fffff=
 64bit pref]
[    0.436919] pci 0000:00:1c.3: PCI bridge to [bus 0c-13]
[    0.437031] pci 0000:00:1c.3:   bridge window [io  0x7000-0x8fff]
[    0.437043] pci 0000:00:1c.3:   bridge window [mem 0xea000000-0xebffffff]
[    0.437059] pci 0000:00:1c.3:   bridge window [mem 0xe4200000-0xe42fffff=
 64bit pref]
[    0.437304] pci 0000:15:00.0: [1180:0476] type 02 class 0x060700
[    0.437354] pci 0000:15:00.0: reg 0x10: [mem 0xe4300000-0xe4300fff]
[    0.437471] pci 0000:15:00.0: supports D1 D2
[    0.437478] pci 0000:15:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.437913] pci 0000:15:00.1: [1180:0552] type 00 class 0x0c0010
[    0.437961] pci 0000:15:00.1: reg 0x10: [mem 0xe4301000-0xe43017ff]
[    0.438164] pci 0000:15:00.1: PME# supported from D0 D3hot D3cold
[    0.438507] pci 0000:15:00.2: [1180:0822] type 00 class 0x080500
[    0.438555] pci 0000:15:00.2: reg 0x10: [mem 0xe4301800-0xe43018ff]
[    0.438761] pci 0000:15:00.2: supports D1 D2
[    0.438769] pci 0000:15:00.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.439193] pci 0000:00:1e.0: PCI bridge to [bus 15-18] (subtractive dec=
ode)
[    0.439323] pci 0000:00:1e.0:   bridge window [io  0x9000-0xcfff]
[    0.439335] pci 0000:00:1e.0:   bridge window [mem 0xe4300000-0xe7ffffff]
[    0.439352] pci 0000:00:1e.0:   bridge window [mem 0xe0000000-0xe3ffffff=
 64bit pref]
[    0.439361] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7 window]=
 (subtractive decode)
[    0.439370] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff window]=
 (subtractive decode)
[    0.439378] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff=
 window] (subtractive decode)
[    0.439387] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000d3fff=
 window] (subtractive decode)
[    0.439395] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff=
 window] (subtractive decode)
[    0.439403] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff=
 window] (subtractive decode)
[    0.439412] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xfebfffff=
 window] (subtractive decode)
[    0.439420] pci 0000:00:1e.0:   bridge window [mem 0xfed40000-0xfed40fff=
 window] (subtractive decode)
[    0.439659] pci_bus 0000:16: busn_res: [bus 16-18] end is updated to 17
[    0.439735] pci_bus 0000:00: on NUMA node 0
[    0.449828] ACPI: EC: interrupt unblocked
[    0.449944] ACPI: EC: event unblocked
[    0.450054] ACPI: \_SB_.PCI0.LPC_.EC__: GPE=3D0x1c, EC_CMD/EC_SC=3D0x66,=
 EC_DATA=3D0x62
[    0.450191] ACPI: \_SB_.PCI0.LPC_.EC__: Used as boot DSDT EC to handle t=
ransactions and events
[    0.451231] pci 0000:00:02.0: vgaarb: setting as boot VGA device
[    0.451348] pci 0000:00:02.0: vgaarb: VGA device added: decodes=3Dio+mem=
,owns=3Dio+mem,locks=3Dnone
[    0.451532] pci 0000:00:02.0: vgaarb: bridge control possible
[    0.451635] vgaarb: loaded
[    0.452702] SCSI subsystem initialized
[    0.453305] libata version 3.00 loaded.
[    0.453685] ACPI: bus type USB registered
[    0.453995] usbcore: registered new interface driver usbfs
[    0.454217] usbcore: registered new interface driver hub
[    0.454430] usbcore: registered new device driver usb
[    0.454759] media: Linux media interface: v0.10
[    0.454950] Linux video capture interface: v2.00
[    0.455175] pps_core: LinuxPPS API ver. 1 registered
[    0.455274] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.455485] PTP clock support registered
[    0.456963] EDAC MC: Ver: 3.0.0
[    0.458414] Advanced Linux Sound Architecture Driver Initialized.
[    0.458797] PCI: Using ACPI for IRQ routing
[    0.462773] PCI: pci_cache_line_size set to 64 bytes
[    0.462990] e820: reserve RAM buffer [mem 0x0009f000-0x0009ffff]
[    0.463000] e820: reserve RAM buffer [mem 0xbf6d0000-0xbfffffff]
[    0.464091] Bluetooth: Core ver 2.22
[    0.464297] NET: Registered protocol family 31
[    0.464392] Bluetooth: HCI device and connection manager initialized
[    0.464523] Bluetooth: HCI socket layer initialized
[    0.464629] Bluetooth: L2CAP socket layer initialized
[    0.464796] Bluetooth: SCO socket layer initialized
[    0.465703] clocksource: Switched to clocksource hpet
[    0.466433] pnp: PnP ACPI init
[    0.470439] system 00:00: [mem 0x00000000-0x0009ffff] could not be reser=
ved
[    0.470573] system 00:00: [mem 0x000c0000-0x000c3fff] could not be reser=
ved
[    0.470702] system 00:00: [mem 0x000c4000-0x000c7fff] could not be reser=
ved
[    0.470827] system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
[    0.470951] system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
[    0.471076] system 00:00: [mem 0x000dc000-0x000dffff] could not be reser=
ved
[    0.471203] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reser=
ved
[    0.471331] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reser=
ved
[    0.471459] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reser=
ved
[    0.471587] system 00:00: [mem 0x000ec000-0x000effff] could not be reser=
ved
[    0.471715] system 00:00: [mem 0x000f0000-0x000fffff] could not be reser=
ved
[    0.471843] system 00:00: [mem 0x00100000-0xbfffffff] could not be reser=
ved
[    0.471971] system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reser=
ved
[    0.472130] system 00:00: [mem 0xfed41000-0xffffffff] could not be reser=
ved
[    0.472339] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.473218] system 00:01: [io  0x164e-0x164f] has been reserved
[    0.473339] system 00:01: [io  0x1000-0x107f] has been reserved
[    0.473459] system 00:01: [io  0x1180-0x11bf] has been reserved
[    0.473576] system 00:01: [io  0x0800-0x080f] has been reserved
[    0.473692] system 00:01: [io  0x15e0-0x15ef] has been reserved
[    0.473811] system 00:01: [io  0x1600-0x165f] could not be reserved
[    0.473931] system 00:01: [mem 0xf0000000-0xf3ffffff] has been reserved
[    0.474054] system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.474177] system 00:01: [mem 0xfed14000-0xfed17fff] has been reserved
[    0.474299] system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.474422] system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.474604] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.475153] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.475402] pnp 00:03: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.475664] pnp 00:04: Plug and Play ACPI device, IDs IBM3780 PNP0f13 (a=
ctive)
[    0.477025] pnp 00:05: [dma 3]
[    0.477367] pnp 00:05: Plug and Play ACPI device, IDs IBM0071 PNP0511 (a=
ctive)
[    0.477796] pnp 00:06: Plug and Play ACPI device, IDs ATM1200 PNP0c31 (a=
ctive)
[    0.481114] pnp: PnP ACPI: found 7 devices
[    0.538093] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, m=
ax_idle_ns: 2085701024 ns
[    0.538284] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff 6=
4bit pref] to [bus 02] add_size 200000 add_align 100000
[    0.538405] pci 0000:00:1c.0: BAR 9: assigned [mem 0xc0000000-0xc01fffff=
 64bit pref]
[    0.538534] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.538636] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.538750] pci 0000:00:1c.0:   bridge window [mem 0xee000000-0xee0fffff]
[    0.538868] pci 0000:00:1c.0:   bridge window [mem 0xc0000000-0xc01fffff=
 64bit pref]
[    0.538998] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.539099] pci 0000:00:1c.1:   bridge window [io  0x3000-0x4fff]
[    0.539214] pci 0000:00:1c.1:   bridge window [mem 0xec000000-0xedffffff]
[    0.539331] pci 0000:00:1c.1:   bridge window [mem 0xe4000000-0xe40fffff=
 64bit pref]
[    0.539460] pci 0000:00:1c.2: PCI bridge to [bus 04-0b]
[    0.539564] pci 0000:00:1c.2:   bridge window [io  0x5000-0x6fff]
[    0.539678] pci 0000:00:1c.2:   bridge window [mem 0xe8000000-0xe9ffffff]
[    0.539795] pci 0000:00:1c.2:   bridge window [mem 0xe4100000-0xe41fffff=
 64bit pref]
[    0.539924] pci 0000:00:1c.3: PCI bridge to [bus 0c-13]
[    0.540048] pci 0000:00:1c.3:   bridge window [io  0x7000-0x8fff]
[    0.540163] pci 0000:00:1c.3:   bridge window [mem 0xea000000-0xebffffff]
[    0.540280] pci 0000:00:1c.3:   bridge window [mem 0xe4200000-0xe42fffff=
 64bit pref]
[    0.540429] pci 0000:15:00.0: BAR 9: assigned [mem 0xe0000000-0xe3ffffff=
 pref]
[    0.540555] pci 0000:15:00.0: BAR 10: assigned [mem 0xc4000000-0xc7fffff=
f]
[    0.540671] pci 0000:15:00.0: BAR 7: assigned [io  0x9000-0x90ff]
[    0.540780] pci 0000:15:00.0: BAR 8: assigned [io  0x9400-0x94ff]
[    0.540903] pci 0000:15:00.0: CardBus bridge to [bus 16-17]
[    0.541007] pci 0000:15:00.0:   bridge window [io  0x9000-0x90ff]
[    0.541119] pci 0000:15:00.0:   bridge window [io  0x9400-0x94ff]
[    0.541231] pci 0000:15:00.0:   bridge window [mem 0xe0000000-0xe3ffffff=
 pref]
[    0.541352] pci 0000:15:00.0:   bridge window [mem 0xc4000000-0xc7ffffff]
[    0.541469] pci 0000:00:1e.0: PCI bridge to [bus 15-18]
[    0.541572] pci 0000:00:1e.0:   bridge window [io  0x9000-0xcfff]
[    0.541687] pci 0000:00:1e.0:   bridge window [mem 0xe4300000-0xe7ffffff]
[    0.541805] pci 0000:00:1e.0:   bridge window [mem 0xe0000000-0xe3ffffff=
 64bit pref]
[    0.541936] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
[    0.541943] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
[    0.541950] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff windo=
w]
[    0.541957] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff windo=
w]
[    0.541964] pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff windo=
w]
[    0.541971] pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff windo=
w]
[    0.541978] pci_bus 0000:00: resource 10 [mem 0xc0000000-0xfebfffff wind=
ow]
[    0.541985] pci_bus 0000:00: resource 11 [mem 0xfed40000-0xfed40fff wind=
ow]
[    0.541993] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
[    0.542000] pci_bus 0000:02: resource 1 [mem 0xee000000-0xee0fffff]
[    0.542007] pci_bus 0000:02: resource 2 [mem 0xc0000000-0xc01fffff 64bit=
 pref]
[    0.542014] pci_bus 0000:03: resource 0 [io  0x3000-0x4fff]
[    0.542021] pci_bus 0000:03: resource 1 [mem 0xec000000-0xedffffff]
[    0.542028] pci_bus 0000:03: resource 2 [mem 0xe4000000-0xe40fffff 64bit=
 pref]
[    0.542035] pci_bus 0000:04: resource 0 [io  0x5000-0x6fff]
[    0.542042] pci_bus 0000:04: resource 1 [mem 0xe8000000-0xe9ffffff]
[    0.542050] pci_bus 0000:04: resource 2 [mem 0xe4100000-0xe41fffff 64bit=
 pref]
[    0.542057] pci_bus 0000:0c: resource 0 [io  0x7000-0x8fff]
[    0.542064] pci_bus 0000:0c: resource 1 [mem 0xea000000-0xebffffff]
[    0.542071] pci_bus 0000:0c: resource 2 [mem 0xe4200000-0xe42fffff 64bit=
 pref]
[    0.542078] pci_bus 0000:15: resource 0 [io  0x9000-0xcfff]
[    0.542085] pci_bus 0000:15: resource 1 [mem 0xe4300000-0xe7ffffff]
[    0.542092] pci_bus 0000:15: resource 2 [mem 0xe0000000-0xe3ffffff 64bit=
 pref]
[    0.542099] pci_bus 0000:15: resource 4 [io  0x0000-0x0cf7 window]
[    0.542106] pci_bus 0000:15: resource 5 [io  0x0d00-0xffff window]
[    0.542113] pci_bus 0000:15: resource 6 [mem 0x000a0000-0x000bffff windo=
w]
[    0.542120] pci_bus 0000:15: resource 7 [mem 0x000d0000-0x000d3fff windo=
w]
[    0.542127] pci_bus 0000:15: resource 8 [mem 0x000d4000-0x000d7fff windo=
w]
[    0.542134] pci_bus 0000:15: resource 9 [mem 0x000d8000-0x000dbfff windo=
w]
[    0.542141] pci_bus 0000:15: resource 10 [mem 0xc0000000-0xfebfffff wind=
ow]
[    0.542148] pci_bus 0000:15: resource 11 [mem 0xfed40000-0xfed40fff wind=
ow]
[    0.542155] pci_bus 0000:16: resource 0 [io  0x9000-0x90ff]
[    0.542162] pci_bus 0000:16: resource 1 [io  0x9400-0x94ff]
[    0.542169] pci_bus 0000:16: resource 2 [mem 0xe0000000-0xe3ffffff pref]
[    0.542176] pci_bus 0000:16: resource 3 [mem 0xc4000000-0xc7ffffff]
[    0.542952] NET: Registered protocol family 2
[    0.544208] TCP established hash table entries: 8192 (order: 3, 32768 by=
tes)
[    0.544439] TCP bind hash table entries: 8192 (order: 6, 294912 bytes)
[    0.545445] TCP: Hash tables configured (established 8192 bind 8192)
[    0.546130] UDP hash table entries: 512 (order: 3, 40960 bytes)
[    0.546371] UDP-Lite hash table entries: 512 (order: 3, 40960 bytes)
[    0.546960] NET: Registered protocol family 1
[    0.547931] RPC: Registered named UNIX socket transport module.
[    0.548469] RPC: Registered udp transport module.
[    0.548569] RPC: Registered tcp transport module.
[    0.548669] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.550346] pci 0000:00:02.0: Video device with shadowed ROM at [mem 0x0=
00c0000-0x000dffff]
[    0.557029] PCI: CLS mismatch (64 !=3D 32), using 64 bytes
[    0.557644] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x1a5=
c8ef21d0, max_idle_ns: 440795209908 ns
[    0.562002] Initialise system trusted keyrings
[    0.562755] workingset: timestamp_bits=3D30 max_order=3D20 bucket_order=
=3D0
[    0.566356] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    0.567162] ntfs: driver 2.1.32 [Flags: R/W].
[    0.567646] fuse init (API version 7.26)
[    0.573787] Key type asymmetric registered
[    0.573901] Asymmetric key parser 'x509' registered
[    0.574978] bounce: pool size: 64 pages
[    0.575259] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 249)
[    0.575396] io scheduler noop registered
[    0.575488] io scheduler deadline registered
[    0.575640] io scheduler cfq registered (default)
[    0.575737] io scheduler mq-deadline registered
[    0.575892] io scheduler bfq registered
[    0.581714] intel_idle: does not run on family 6 model 14
[    0.582302] ACPI: Deprecated procfs I/F for AC is loaded, please retry w=
ith CONFIG_ACPI_PROCFS_POWER cleared
[    0.582767] ACPI: AC Adapter [AC] (off-line)
[    0.583462] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0=
D:00/input/input0
[    0.583900] ACPI: Lid Switch [LID]
[    0.584580] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0=
C0E:00/input/input1
[    0.584853] ACPI: Sleep Button [SLPB]
[    0.585423] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input2
[    0.585691] ACPI: Power Button [PWRF]
[    0.586563] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    0.599285] acpi device:01: registered as cooling_device0
[    0.600142] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08=
:00/LNXVIDEO:00/input/input3
[    0.626165] (NULL device *): hwmon_device_register() is deprecated. Plea=
se convert the driver to use hwmon_device_register_with_info().
[    0.627838] thermal LNXTHERM:00: registered as thermal_zone0
[    0.627955] ACPI: Thermal Zone [THM0] (30 C)
[    0.634439] thermal LNXTHERM:01: registered as thermal_zone1
[    0.634556] ACPI: Thermal Zone [THM1] (29 C)
[    0.635805] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.637394] serial8250: ttyS1 at I/O 0x2f8 (irq =3D 3, base_baud =3D 921=
600) is a NS16550A
[    0.641346] lp: driver loaded but no devices found
[    0.642106] Non-volatile memory driver v1.3
[    0.644168] intel_rng: FWH not detected
[    0.644431] Linux agpgart interface v0.103
[    0.646371] [drm] radeon kernel modesetting enabled.
[    0.647093] [drm] amdgpu kernel modesetting enabled.
[    0.650311] pci 0000:00:00.0: Intel 945GM Chipset
[    0.650498] pci 0000:00:00.0: detected gtt size: 262144K total, 262144K =
mappable
[    0.651622] pci 0000:00:00.0: detected 8192K stolen memory
[    0.651877] [drm] Memory usable by graphics device =3D 256M
[    0.652240] [drm] Replacing VGA console driver
[    0.654319] Console: switching to colour dummy device 80x25
[    0.657239] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    0.657301] [drm] Driver supports precise vblank timestamp query.
[    0.657376] resource sanity check: requesting [mem 0x000c0000-0x000dffff=
], which spans more than pnp 00:00 [mem 0x000c8000-0x000cbfff]
[    0.657500] caller pci_map_rom+0x58/0xf0 mapping multiple BARs
[    0.663110] i915 0000:00:02.0: vgaarb: changed VGA decodes: olddecodes=
=3Dio+mem,decodes=3Dio+mem:owns=3Dio+mem
[    0.665517] ACPI: Deprecated procfs I/F for battery is loaded, please re=
try with CONFIG_ACPI_PROCFS_POWER cleared
[    0.665655] ACPI: Battery Slot [BAT0] (battery present)
[    0.745922] [drm] RC6 disabled, disabling runtime PM support
[    0.746137] [drm] initialized overlay support
[    0.748523] [drm] Initialized i915 1.6.0 20171023 for 0000:00:02.0 on mi=
nor 0
[    0.750498] usbcore: registered new interface driver udl
[    0.772580] loop: module loaded
[    0.795170] fbcon: inteldrmfb (fb0) is primary device
[    0.808896] ahci 0000:00:1f.2: version 3.0
[    0.810214] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 1.5 Gbps =
0x1 impl SATA mode
[    0.810222] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part=
=20
[    0.814682] scsi host0: ahci
[    0.815689] scsi host1: ahci
[    0.816530] scsi host2: ahci
[    0.817367] scsi host3: ahci
[    0.817814] ata1: SATA max UDMA/133 abar m1024@0xee444400 port 0xee44450=
0 irq 16
[    0.817818] ata2: DUMMY
[    0.817821] ata3: DUMMY
[    0.817823] ata4: DUMMY
[    0.818118] ata_piix 0000:00:1f.1: version 2.13
[    0.824879] scsi host4: ata_piix
[    0.825734] scsi host5: ata_piix
[    0.826132] ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1810 irq=
 14
[    0.826137] ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1818 irq=
 15
[    0.826370] ata6: port disabled--ignoring
[    0.827767] tun: Universal TUN/TAP device driver, 1.6
[    0.828953] e1000e: Intel(R) PRO/1000 Network Driver - 3.2.6-k
[    0.828956] e1000e: Copyright(c) 1999 - 2015 Intel Corporation.
[    0.829048] e1000e 0000:02:00.0: Disabling ASPM  L1
[    0.829053] e1000e 0000:02:00.0: can't disable ASPM; OS doesn't have ASP=
M control
[    0.829691] e1000e 0000:02:00.0: Interrupt Throttling Rate (ints/sec) se=
t to dynamic conservative mode
[    0.969475] e1000e 0000:02:00.0 eth0: (PCI Express:2.5GT/s:Width x1) 00:=
16:d3:25:19:04
[    0.969481] e1000e 0000:02:00.0 eth0: Intel(R) PRO/1000 Network Connecti=
on
[    0.969563] e1000e 0000:02:00.0 eth0: MAC: 2, PHY: 2, PBA No: 005302-003
[    0.970058] PPP generic driver version 2.4.2
[    0.970504] PPP BSD Compression module registered
[    0.970508] PPP Deflate Compression module registered
[    0.970513] SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=
=3D256).
[    0.970515] CSLIP: code copyright 1989 Regents of the University of Cali=
fornia.
[    0.970687] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection=
 driver for Linux, in-tree:ds
[    0.970690] iwl3945: Copyright(c) 2003-2011 Intel Corporation
[    0.970692] iwl3945: hw_scan is disabled
[    0.971082] iwl3945 0000:03:00.0: can't disable ASPM; OS doesn't have AS=
PM control
[    1.026281] iwl3945 0000:03:00.0: Tunable channels: 11 802.11bg, 13 802.=
11a channels
[    1.026287] iwl3945 0000:03:00.0: Detected Intel Wireless WiFi Link 3945=
ABG
[    1.027866] ieee80211 phy0: Selected rate control algorithm 'iwl-3945-rs'
[    1.029580] Intel(R) Wireless WiFi driver for Linux
[    1.029582] Copyright(c) 2003- 2015 Intel Corporation
[    1.029949] usbcore: registered new interface driver ax88179_178a
[    1.030028] usbcore: registered new interface driver cdc_ether
[    1.030113] usbcore: registered new interface driver net1080
[    1.030191] usbcore: registered new interface driver cdc_subset
[    1.030269] usbcore: registered new interface driver zaurus
[    1.030373] usbcore: registered new interface driver cdc_ncm
[    1.030517] pci 0000:00:1e.0: enabling device (0005 -> 0007)
[    1.030939] yenta_cardbus 0000:15:00.0: CardBus bridge found [17aa:201c]
[    1.140254] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.222992] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succee=
ded
[    1.223000] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK=
) filtered out
[    1.223006] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filter=
ed out
[    1.266661] ata1.00: ATA-9: ST1000LM014-1EJ164, SM11, max UDMA/133
[    1.266667] ata1.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 31/3=
2), AA
[    1.311719] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succee=
ded
[    1.311727] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK=
) filtered out
[    1.311733] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filter=
ed out
[    1.355434] ata1.00: configured for UDMA/133
[    1.543942] Console: switching to colour frame buffer device 102x42
[    1.739324] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    1.744746] scsi 0:0:0:0: Direct-Access     ATA      ST1000LM014-1EJ1 SM=
11 PQ: 0 ANSI: 5
[    1.751307] sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 =
TB/932 GiB)
[    1.751373] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.760230] sd 0:0:0:0: [sda] 4096-byte physical blocks
[    1.764733] sd 0:0:0:0: [sda] Write Protect is off
[    1.769098] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.769624] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    1.777443]  sda: sda1 sda2 sda3 sda4
[    1.785442] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.925053] yenta_cardbus 0000:15:00.0: ISA IRQ mask 0x0cb8, PCI irq 16
[    1.929618] yenta_cardbus 0000:15:00.0: Socket status: 30000006
[    1.934164] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge window=
: [io  0x9000-0xcfff]
[    1.938608] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge window=
: [mem 0xe4300000-0xe7ffffff]
[    1.942956] pcmcia_socket pcmcia_socket0: cs: memory probe 0xe4300000-0x=
e7ffffff:
[    1.947361]  excluding 0xe4300000-0xe46cffff
[    1.951789] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge window=
: [mem 0xe0000000-0xe3ffffff 64bit pref]
[    1.956393] pcmcia_socket pcmcia_socket0: cs: memory probe 0xe0000000-0x=
e3ffffff:
[    1.961116]  excluding 0xe0000000-0xe3ffffff
[    1.967413] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.972066] ehci-pci: EHCI PCI platform driver
[    1.977567] ehci-pci 0000:00:1d.7: EHCI Host Controller
[    1.982731] ehci-pci 0000:00:1d.7: new USB bus registered, assigned bus =
number 1
[    1.987620] ehci-pci 0000:00:1d.7: debug port 1
[    1.996477] ehci-pci 0000:00:1d.7: cache line size of 64 is not supported
[    1.996570] ehci-pci 0000:00:1d.7: irq 19, io mem 0xee444000
[    2.016262] ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    2.022174] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    2.027230] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    2.032234] usb usb1: Product: EHCI Host Controller
[    2.037124] usb usb1: Manufacturer: Linux 4.15.0-rc1-next-20171201 ehci_=
hcd
[    2.042053] usb usb1: SerialNumber: 0000:00:1d.7
[    2.048316] hub 1-0:1.0: USB hub found
[    2.053313] hub 1-0:1.0: 8 ports detected
[    2.061573] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.066289] ohci-pci: OHCI PCI platform driver
[    2.071039] uhci_hcd: USB Universal Host Controller Interface driver
[    2.076722] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    2.081868] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus =
number 2
[    2.086681] uhci_hcd 0000:00:1d.0: detected 2 ports
[    2.091373] uhci_hcd 0000:00:1d.0: irq 16, io base 0x00001820
[    2.096742] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    2.101349] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    2.106029] usb usb2: Product: UHCI Host Controller
[    2.110639] usb usb2: Manufacturer: Linux 4.15.0-rc1-next-20171201 uhci_=
hcd
[    2.115289] usb usb2: SerialNumber: 0000:00:1d.0
[    2.120930] hub 2-0:1.0: USB hub found
[    2.125582] hub 2-0:1.0: 2 ports detected
[    2.132037] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    2.136946] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus =
number 3
[    2.141461] uhci_hcd 0000:00:1d.1: detected 2 ports
[    2.145959] uhci_hcd 0000:00:1d.1: irq 17, io base 0x00001840
[    2.151012] usb usb3: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    2.155422] usb usb3: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    2.159632] usb usb3: Product: UHCI Host Controller
[    2.163662] usb usb3: Manufacturer: Linux 4.15.0-rc1-next-20171201 uhci_=
hcd
[    2.167724] usb usb3: SerialNumber: 0000:00:1d.1
[    2.172854] hub 3-0:1.0: USB hub found
[    2.176953] hub 3-0:1.0: 2 ports detected
[    2.183010] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    2.187350] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus =
number 4
[    2.191360] uhci_hcd 0000:00:1d.2: detected 2 ports
[    2.195424] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001860
[    2.200140] usb usb4: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    2.204168] usb usb4: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    2.208188] usb usb4: Product: UHCI Host Controller
[    2.212114] usb usb4: Manufacturer: Linux 4.15.0-rc1-next-20171201 uhci_=
hcd
[    2.216115] usb usb4: SerialNumber: 0000:00:1d.2
[    2.221205] hub 4-0:1.0: USB hub found
[    2.225321] hub 4-0:1.0: 2 ports detected
[    2.231326] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    2.235789] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus =
number 5
[    2.239826] uhci_hcd 0000:00:1d.3: detected 2 ports
[    2.243819] uhci_hcd 0000:00:1d.3: irq 19, io base 0x00001880
[    2.248473] usb usb5: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    2.252429] usb usb5: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    2.256355] usb usb5: Product: UHCI Host Controller
[    2.260254] usb usb5: Manufacturer: Linux 4.15.0-rc1-next-20171201 uhci_=
hcd
[    2.264228] usb usb5: SerialNumber: 0000:00:1d.3
[    2.269276] hub 5-0:1.0: USB hub found
[    2.273361] hub 5-0:1.0: 2 ports detected
[    2.278836] usbcore: registered new interface driver cdc_acm
[    2.282589] cdc_acm: USB Abstract Control Model driver for USB modems an=
d ISDN adapters
[    2.286614] usbcore: registered new interface driver usblp
[    2.290727] usbcore: registered new interface driver usb-storage
[    2.294715] usbcore: registered new interface driver ums-sddr09
[    2.298768] usbcore: registered new interface driver usbserial_generic
[    2.302631] usbserial: USB Serial support registered for generic
[    2.306546] usbcore: registered new interface driver ch341
[    2.310401] usbserial: USB Serial support registered for ch341-uart
[    2.314331] usbcore: registered new interface driver ftdi_sio
[    2.318195] usbserial: USB Serial support registered for FTDI USB Serial=
 Device
[    2.322271] usbcore: registered new interface driver option
[    2.326191] usbserial: USB Serial support registered for GSM modem (1-po=
rt)
[    2.330391] usbcore: registered new interface driver pl2303
[    2.334479] usbserial: USB Serial support registered for pl2303
[    2.338637] usbcore: registered new interface driver ti_usb_3410_5052
[    2.342775] usbserial: USB Serial support registered for TI USB 3410 1 p=
ort adapter
[    2.347011] usbserial: USB Serial support registered for TI USB 5052 2 p=
ort adapter
[    2.351144] ftdi_elan: driver ftdi-elan
[    2.355241] usbcore: registered new interface driver ftdi-elan
[    2.359675] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    2.373460] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.377706] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.383397] mousedev: PS/2 mouse device common for all mice
[    2.389604] input: PC Speaker as /devices/platform/pcspkr/input/input4
[    2.394974] rtc_cmos 00:02: RTC can wake from S4
[    2.399870] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    2.404239] rtc_cmos 00:02: alarms up to one month, y3k, 114 bytes nvram=
, hpet irqs
[    2.408883] usbcore: registered new interface driver uvcvideo
[    2.413219] USB Video Class driver (1.1.1)
[    2.417473] gspca_main: v2.14.0 registered
[    2.421805] usbcore: registered new interface driver sq930x
[    2.427886] device-mapper: ioctl: 4.37.0-ioctl (2017-09-20) initialised:=
 dm-devel@redhat.com
[    2.432344] Bluetooth: HCI UART driver ver 2.3
[    2.436701] Bluetooth: HCI UART protocol H4 registered
[    2.441040] Bluetooth: HCI UART protocol BCSP registered
[    2.445691] usbcore: registered new interface driver btusb
[    2.450264] sdhci: Secure Digital Host Controller Interface driver
[    2.454594] sdhci: Copyright(c) Pierre Ossman
[    2.458905] sdhci-pci 0000:15:00.2: SDHCI controller found [1180:0822] (=
rev 18)
[    2.463934] sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doe=
sn't fully claim to support it.
[    2.468638] sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doe=
sn't fully claim to support it.
[    2.474091] mmc0: SDHCI controller on PCI [0000:15:00.2] using DMA
[    2.479120] sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doe=
sn't fully claim to support it.
[    2.479147] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input5
[    2.483013] hidraw: raw HID events driver (C) Jiri Kosina
[    2.485121] usbcore: registered new interface driver usbhid
[    2.485123] usbhid: USB HID core driver
[    2.491112] thinkpad_acpi: ThinkPad ACPI Extras v0.25
[    2.491114] thinkpad_acpi: http://ibm-acpi.sf.net/
[    2.491117] thinkpad_acpi: ThinkPad BIOS 7BETD8WW (2.19 ), EC 7BHT40WW-1=
=2E13
[    2.491120] thinkpad_acpi: Lenovo ThinkPad X60, model 17097HU
[    2.524735] thinkpad_acpi: ACPI backlight control delay disabled
[    2.529734] thinkpad_acpi: radio switch found; radios are enabled
[    2.534442] thinkpad_acpi: This ThinkPad has standard ACPI backlight bri=
ghtness control, supported by the ACPI video driver
[    2.543863] thinkpad_acpi: Disabling thinkpad-acpi brightness events by =
default...
[    2.566151] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is u=
nblocked
[    2.574809] thinkpad_acpi: warning: userspace override of important firm=
ware LEDs is enabled
[    2.582624] thinkpad_acpi: Standard ACPI backlight interface available, =
not loading native one
[    2.587634] thinkpad_acpi: volume: disabled as there is no ALSA support =
in this kernel
[    2.593517] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_=
acpi/input/input7
[    2.607808] snd_hda_intel 0000:00:1b.0: probe_mask set to 0x1 for device=
 17aa:2010
[    2.613399] usbcore: registered new interface driver snd-usb-audio
[    2.618826] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    2.626138] ip_tables: (C) 2000-2006 Netfilter Core Team
[    2.633037] NET: Registered protocol family 17
[    2.638288] Bluetooth: RFCOMM TTY layer initialized
[    2.643380] Bluetooth: RFCOMM socket layer initialized
[    2.648306] Bluetooth: RFCOMM ver 1.11
[    2.653057] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    2.653080] usb 5-1: new full-speed USB device number 2 using uhci_hcd
[    2.662910] Bluetooth: BNEP filters: protocol multicast
[    2.667887] Bluetooth: BNEP socket layer initialized
[    2.672776] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[    2.677678] Bluetooth: HIDP socket layer initialized
[    2.683275] microcode: sig=3D0x6e8, pf=3D0x20, revision=3D0x39
[    2.688739] microcode: Microcode Update Driver: v2.2.
[    2.688750] Using IPI No-Shortcut mode
[    2.700683] Loading compiled-in X.509 certificates
[    2.707586] Key type encrypted registered
[    2.712793] snd_hda_codec_analog hdaudioC0D0: autoconfig for AD1981: lin=
e_outs=3D1 (0x5/0x0/0x0/0x0/0x0) type:speaker
[    2.713812] rtc_cmos 00:02: setting system clock to 2017-12-03 11:36:51 =
UTC (1512301011)
[    2.723406] snd_hda_codec_analog hdaudioC0D0:    speaker_outs=3D0 (0x0/0=
x0/0x0/0x0/0x0)
[    2.723579] cfg80211: Loading compiled-in X.509 certificates for regulat=
ory database
[    2.726053] cfg80211: Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
[    2.726526] platform regulatory.0: Direct firmware load for regulatory.d=
b failed with error -2
[    2.726549] cfg80211: failed to load regulatory.db
[    2.738083] snd_hda_codec_analog hdaudioC0D0:    hp_outs=3D0 (0x0/0x0/0x=
0/0x0/0x0)
[    2.740116] PM: Image not found (code -22)
[    2.740135] ALSA device list:
[    2.740137]   No soundcards found.
[    2.751854] snd_hda_codec_analog hdaudioC0D0:    mono: mono_out=3D0x0
[    2.751859] snd_hda_codec_analog hdaudioC0D0:    inputs:
[    2.751866] snd_hda_codec_analog hdaudioC0D0:      Mic=3D0x8
[    2.751872] snd_hda_codec_analog hdaudioC0D0:      CD=3D0x19
[    2.861871] usb 5-1: New USB device found, idVendor=3D0a5c, idProduct=3D=
2110
[    2.866538] usb 5-1: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D0
[    2.871094] usb 5-1: Product: BCM2045B
[    2.875492] usb 5-1: Manufacturer: Broadcom Corp
[    3.186385] psmouse serio1: trackpoint: IBM TrackPoint firmware: 0x0e, b=
uttons: 3/3
[    3.208545] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/seri=
o1/input/input8
[    3.217627] md: Waiting for all devices to be available before autodetect
[    3.221069] md: If you don't use raid, use raid=3Dnoautodetect
[    3.225433] md: Autodetecting RAID arrays.
[    3.228071] md: autorun ...
[    3.230630] md: ... autorun DONE.
[    3.234006] EXT4-fs (sda4): couldn't mount as ext3 due to feature incomp=
atibilities
[    3.248094] EXT4-fs (sda4): mounted filesystem with ordered data mode. O=
pts: (null)
[    3.251663] VFS: Mounted root (ext4 filesystem) readonly on device 8:4.
[    3.255840] devtmpfs: mounted
[    3.261237] Freeing unused kernel memory: 564K
[    3.264011] Write protecting the kernel text: 12796k
[    3.266980] Write protecting the kernel read-only data: 5104k
[    3.269620] NX-protecting the kernel data: 7684k
[    3.272921] x86/mm: Checked W+X mappings: passed, no W+X pages found.
[    3.275610] rodata_test: all tests were successful
[    3.545078] systemd[1]: systemd 215 running in system mode. (+PAM +AUDIT=
 +SELINUX +IMA +SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ -SECCOMP -APPARMOR)
[    3.572386] systemd[1]: Detected architecture 'x86'.
[    3.648445] usb 5-2: new full-speed USB device number 3 using uhci_hcd
[    3.679930] systemd[1]: Failed to insert module 'ipv6'
[    3.687405] systemd[1]: Set hostname to <amd>.
[    3.846875] usb 5-2: New USB device found, idVendor=3D0483, idProduct=3D=
2016
[    3.851228] usb 5-2: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D0
[    3.855618] usb 5-2: Product: Biometric Coprocessor
[    3.859923] usb 5-2: Manufacturer: STMicroelectronics
[    4.734282] systemd[1]: Binding to IPv6 address not available since kern=
el does not support IPv6.
[    4.739012] systemd[1]: [/lib/systemd/system/gpsd.socket:6] Failed to pa=
rse address value, ignoring: [::1]:2947
[    4.762140] systemd[1]: Starting Forward Password Requests to Wall Direc=
tory Watch.
[    4.766555] systemd[1]: Started Forward Password Requests to Wall Direct=
ory Watch.
[    4.770274] systemd[1]: Starting Remote File Systems (Pre).
[    4.779674] systemd[1]: Reached target Remote File Systems (Pre).
[    5.497363] systemd-udevd[2361]: starting version 215
[    5.597026] random: crng init done
[    6.739516] EXT4-fs (sda4): re-mounted. Opts: errors=3Dremount-ro
[    6.926260] e1000e 0000:02:00.0 eth1: renamed from eth0
[    6.948650] systemd-udevd[2417]: renamed network interface eth0 to eth1
[    8.667003] Adding 2097148k swap on /dev/sda1.  Priority:-2 extents:1 ac=
ross:2097148k=20
[    8.865853] EXT4-fs (sda2): mounted filesystem with ordered data mode. O=
pts: errors=3Dremount-ro
[    9.017908] systemd-journald[2357]: Received request to flush runtime jo=
urnal from PID 1
[   13.560375] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recov=
ery directory
[   13.577779] NFSD: starting 90-second grace period (net f0000099)
[   15.152815] iwl3945 0000:03:00.0: loaded firmware version 15.32.2.9
[ 1022.529024] PM: suspend entry (deep)
[ 1022.529036] PM: Syncing filesystems ... done.
[ 1022.556423] Freezing user space processes ... (elapsed 0.007 seconds) do=
ne.
[ 1022.564615] OOM killer disabled.
[ 1022.564622] Freezing remaining freezable tasks ... (elapsed 0.003 second=
s) done.
[ 1022.568432] Suspending console(s) (use no_console_suspend to debug)
[ 1022.592863] e1000e: EEE TX LPI TIMER: 00000000
[ 1022.604222] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[ 1022.605053] sd 0:0:0:0: [sda] Stopping disk
[ 1022.938555] PM: suspend devices took 0.368 seconds
[ 1023.092557] ACPI: Preparing to enter system sleep state S3
[ 1023.436202] ACPI: EC: event blocked
[ 1023.436207] ACPI: EC: EC stopped
[ 1023.436211] PM: Saving platform NVS memory
[ 1023.436522] Disabling non-boot CPUs ...
[ 1023.454094] IRQ 17: no longer affine to CPU1
[ 1023.455119] smpboot: CPU 1 is now offline
[ 1023.456795] ACPI: Low-level resume complete
[ 1023.456795] ACPI: EC: EC started
[ 1023.456795] PM: Restoring platform NVS memory
[ 1023.457412] Enabling non-boot CPUs ...
[ 1023.459934] x86: Booting SMP configuration:
[ 1023.459941] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 1023.455104] Initializing CPU#1
[ 1023.455104] Disabled fast string operations
[ 1023.508594]  cache: parent cpu1 should not be sleeping
[ 1023.540605] CPU1 is up
[ 1023.542952] ACPI: Waking up from system sleep state S3
[ 1024.326930] ACPI: EC: event unblocked
[ 1024.328638] usb usb5: root hub lost power or was reset
[ 1024.329123] sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doe=
sn't fully claim to support it.
[ 1024.329138] sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doe=
sn't fully claim to support it.
[ 1024.335756] ata6: port disabled--ignoring
[ 1024.336315] sd 0:0:0:0: [sda] Starting disk
[ 1024.336751] usb usb2: root hub lost power or was reset
[ 1024.336978] usb usb3: root hub lost power or was reset
[ 1024.337213] usb usb4: root hub lost power or was reset
[ 1024.644128] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[ 1024.645447] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succee=
ded
[ 1024.645455] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK=
) filtered out
[ 1024.645463] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filter=
ed out
[ 1024.647353] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succee=
ded
[ 1024.647362] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK=
) filtered out
[ 1024.647369] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filter=
ed out
[ 1024.647842] ata1.00: configured for UDMA/133
[ 1024.692224] usb 5-2: reset full-speed USB device number 3 using uhci_hcd
[ 1024.980165] usb 5-1: reset full-speed USB device number 2 using uhci_hcd
[ 1027.813205] thinkpad_acpi: ACPI backlight control delay disabled
[ 1027.828339] usb 5-1:1.0: rebind failed: -517
[ 1027.828484] usb 5-1:1.1: rebind failed: -517
[ 1027.830479] PM: resume devices took 3.504 seconds
[ 1027.831091] OOM killer enabled.
[ 1027.831102] Restarting tasks ... done.
[ 1027.849522] video LNXVIDEO:00: Restoring backlight state
[ 1027.888313] PM: suspend exit
[ 1027.986028] e1000e: eth1 NIC Link is Down
[ 1090.037395] PM: suspend entry (deep)
[ 1090.037406] PM: Syncing filesystems ... done.
[ 1090.052955] Freezing user space processes ... (elapsed 0.007 seconds) do=
ne.
[ 1090.060539] OOM killer disabled.
[ 1090.060546] Freezing remaining freezable tasks ... (elapsed 0.003 second=
s) done.
[ 1090.064495] Suspending console(s) (use no_console_suspend to debug)
[ 1090.088068] e1000e: EEE TX LPI TIMER: 00000000
[ 1090.108199] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[ 1090.109087] sd 0:0:0:0: [sda] Stopping disk
[ 1090.408469] PM: suspend devices took 0.344 seconds
[ 1090.560566] ACPI: Preparing to enter system sleep state S3
[ 1090.904203] ACPI: EC: event blocked
[ 1090.904207] ACPI: EC: EC stopped
[ 1090.904212] PM: Saving platform NVS memory
[ 1090.904543] Disabling non-boot CPUs ...
[ 1090.922318] smpboot: CPU 1 is now offline
[ 1090.924026] ACPI: Low-level resume complete
[ 1090.924026] ACPI: EC: EC started
[ 1090.924026] PM: Restoring platform NVS memory
[ 1090.924203] Enabling non-boot CPUs ...
[ 1090.926741] x86: Booting SMP configuration:
[ 1090.926748] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 1090.922299] Initializing CPU#1
[ 1090.922299] Disabled fast string operations
[ 1090.976589]  cache: parent cpu1 should not be sleeping
[ 1091.008733] CPU1 is up
[ 1091.011061] ACPI: Waking up from system sleep state S3
[ 1091.798389] ACPI: EC: event unblocked
[ 1091.800463] usb usb5: root hub lost power or was reset
[ 1091.801277] sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doe=
sn't fully claim to support it.
[ 1091.801293] sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doe=
sn't fully claim to support it.
[ 1091.805838] usb usb2: root hub lost power or was reset
[ 1091.806093] usb usb3: root hub lost power or was reset
[ 1091.806143] sd 0:0:0:0: [sda] Starting disk
[ 1091.807148] usb usb4: root hub lost power or was reset
[ 1091.810254] ata6: port disabled--ignoring
[ 1092.116084] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[ 1092.117373] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succee=
ded
[ 1092.117382] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK=
) filtered out
[ 1092.117389] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filter=
ed out
[ 1092.119208] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succee=
ded
[ 1092.119217] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK=
) filtered out
[ 1092.119224] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filter=
ed out
[ 1092.119689] ata1.00: configured for UDMA/133
[ 1092.164249] usb 5-2: reset full-speed USB device number 3 using uhci_hcd
[ 1092.452167] usb 5-1: reset full-speed USB device number 2 using uhci_hcd
[ 1095.264821] thinkpad_acpi: ACPI backlight control delay disabled
[ 1095.279669] usb 5-1:1.0: rebind failed: -517
[ 1095.279812] usb 5-1:1.1: rebind failed: -517
[ 1095.281841] PM: resume devices took 3.484 seconds
[ 1095.282406] OOM killer enabled.
[ 1095.282417] Restarting tasks ... done.
[ 1095.289715] video LNXVIDEO:00: Restoring backlight state
[ 1095.344418] PM: suspend exit
[ 1095.434348] e1000e: eth1 NIC Link is Down
[ 1166.583281] PM: suspend entry (deep)
[ 1166.583293] PM: Syncing filesystems ... done.
[ 1166.606123] Freezing user space processes ... (elapsed 0.010 seconds) do=
ne.
[ 1166.616508] OOM killer disabled.
[ 1166.616515] Freezing remaining freezable tasks ... (elapsed 0.003 second=
s) done.
[ 1166.620575] Suspending console(s) (use no_console_suspend to debug)
[ 1166.646198] e1000e: EEE TX LPI TIMER: 00000000
[ 1166.662383] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[ 1166.662729] sd 0:0:0:0: [sda] Stopping disk
[ 1166.980403] PM: suspend devices took 0.360 seconds
[ 1167.132579] ACPI: Preparing to enter system sleep state S3
[ 1167.476201] ACPI: EC: event blocked
[ 1167.476206] ACPI: EC: EC stopped
[ 1167.476211] PM: Saving platform NVS memory
[ 1167.476527] Disabling non-boot CPUs ...
[ 1167.494316] smpboot: CPU 1 is now offline
[ 1167.495501] ACPI: Low-level resume complete
[ 1167.495501] ACPI: EC: EC started
[ 1167.495501] PM: Restoring platform NVS memory
[ 1167.495918] Enabling non-boot CPUs ...
[ 1167.498482] x86: Booting SMP configuration:
[ 1167.498489] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 1167.494300] Initializing CPU#1
[ 1167.494300] Disabled fast string operations
[ 1167.548586]  cache: parent cpu1 should not be sleeping
[ 1167.580728] CPU1 is up
[ 1167.583074] ACPI: Waking up from system sleep state S3
[ 1168.366332] ACPI: EC: event unblocked
[ 1168.368373] usb usb5: root hub lost power or was reset
[ 1168.368717] sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doe=
sn't fully claim to support it.
[ 1168.368732] sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doe=
sn't fully claim to support it.
[ 1168.373024] sd 0:0:0:0: [sda] Starting disk
[ 1168.375765] usb usb2: root hub lost power or was reset
[ 1168.377713] usb usb3: root hub lost power or was reset
[ 1168.378592] usb usb4: root hub lost power or was reset
[ 1168.381435] ata6: port disabled--ignoring
[ 1168.688089] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[ 1168.689387] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succee=
ded
[ 1168.689395] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK=
) filtered out
[ 1168.689402] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filter=
ed out
[ 1168.691247] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succee=
ded
[ 1168.691255] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK=
) filtered out
[ 1168.691262] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filter=
ed out
[ 1168.691749] ata1.00: configured for UDMA/133
[ 1168.728187] usb 5-1: reset full-speed USB device number 2 using uhci_hcd
[ 1169.008220] usb 5-2: reset full-speed USB device number 3 using uhci_hcd
[ 1171.840751] thinkpad_acpi: ACPI backlight control delay disabled
[ 1171.855590] usb 5-1:1.0: rebind failed: -517
[ 1171.855734] usb 5-1:1.1: rebind failed: -517
[ 1171.857710] PM: resume devices took 3.492 seconds
[ 1171.858590] OOM killer enabled.
[ 1171.858596] Restarting tasks ... done.
[ 1171.886390] video LNXVIDEO:00: Restoring backlight state
[ 1171.914815] PM: suspend exit
[ 1171.967653] sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doe=
sn't fully claim to support it.
[ 1172.005857] e1000e: eth1 NIC Link is Down
[ 1172.019528] sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doe=
sn't fully claim to support it.
[ 1172.073694] sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doe=
sn't fully claim to support it.
[ 1172.137835] sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doe=
sn't fully claim to support it.
[ 1175.426125] iwl3945 0000:03:00.0: Card state received: HW:Kill SW:On
[ 1175.433458] iwl3945 0000:03:00.0: Not sending command - RF KILL
[ 1175.433475] iwl3945 0000:03:00.0: Error sending C_RXON: enqueue_hcmd fai=
led: -5
[ 1175.433486] iwl3945 0000:03:00.0: Error setting new configuration (-5).
[ 1175.437925] iwl3945 0000:03:00.0: Master Disable Timed Out, 100 usec
[ 1175.447157] usb 5-1: USB disconnect, device number 2
[ 1176.460092] usb 5-1: new full-speed USB device number 4 using uhci_hcd
[ 1176.645347] usb 5-1: New USB device found, idVendor=3D0a5c, idProduct=3D=
2110
[ 1176.645361] usb 5-1: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D0
[ 1176.645372] usb 5-1: Product: BCM2045B
[ 1176.645382] usb 5-1: Manufacturer: Broadcom Corp
[ 2655.255667] PM: suspend entry (deep)
[ 2655.255684] PM: Syncing filesystems ... done.
[ 2655.434301] Freezing user space processes ... (elapsed 0.006 seconds) do=
ne.
[ 2655.440575] OOM killer disabled.
[ 2655.440585] Freezing remaining freezable tasks ... (elapsed 0.003 second=
s) done.
[ 2655.444567] Suspending console(s) (use no_console_suspend to debug)
[ 2655.470584] e1000e: EEE TX LPI TIMER: 00000000
[ 2655.496385] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[ 2655.496732] sd 0:0:0:0: [sda] Stopping disk
[ 2655.792569] PM: suspend devices took 0.348 seconds
[ 2655.948743] ACPI: Preparing to enter system sleep state S3
[ 2656.292259] ACPI: EC: event blocked
[ 2656.292265] ACPI: EC: EC stopped
[ 2656.292272] PM: Saving platform NVS memory
[ 2656.292672] Disabling non-boot CPUs ...
[ 2656.310680] smpboot: CPU 1 is now offline
[ 2656.312031] ACPI: Low-level resume complete
[ 2656.312031] ACPI: EC: EC started
[ 2656.312031] PM: Restoring platform NVS memory
[ 2656.312554] Enabling non-boot CPUs ...
[ 2656.315097] x86: Booting SMP configuration:
[ 2656.315105] smpboot: Booting Node 0 Processor 1 APIC 0x1
[ 2656.310657] Initializing CPU#1
[ 2656.310657] Disabled fast string operations
[ 2656.364911]  cache: parent cpu1 should not be sleeping
[ 2656.396609] CPU1 is up
[ 2656.398951] ACPI: Waking up from system sleep state S3
[ 2657.106475] thinkpad_acpi: EMERGENCY WAKEUP: battery almost empty
[ 2657.266584] usb usb5: root hub lost power or was reset
[ 2657.266886] sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doe=
sn't fully claim to support it.
[ 2657.266901] sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doe=
sn't fully claim to support it.
[ 2657.269874] ACPI: EC: event unblocked
[ 2657.274794] usb usb2: root hub lost power or was reset
[ 2657.275477] sd 0:0:0:0: [sda] Starting disk
[ 2657.276598] ata6: port disabled--ignoring
[ 2657.276697] usb usb3: root hub lost power or was reset
[ 2657.276995] usb usb4: root hub lost power or was reset
[ 2657.584092] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[ 2657.585362] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succee=
ded
[ 2657.585371] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK=
) filtered out
[ 2657.585378] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filter=
ed out
[ 2657.587157] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succee=
ded
[ 2657.587165] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK=
) filtered out
[ 2657.587172] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filter=
ed out
[ 2657.587669] ata1.00: configured for UDMA/133
[ 2657.628179] usb 5-1: reset full-speed USB device number 4 using uhci_hcd
[ 2657.916210] usb 5-2: reset full-speed USB device number 3 using uhci_hcd
[ 2660.657184] thinkpad_acpi: ACPI backlight control delay disabled
[ 2660.672071] usb 5-1:1.0: rebind failed: -517
[ 2660.672216] usb 5-1:1.1: rebind failed: -517
[ 2660.674231] PM: resume devices took 3.408 seconds
[ 2660.674889] OOM killer enabled.
[ 2660.674900] Restarting tasks ... done.
[ 2660.689079] video LNXVIDEO:00: Restoring backlight state
[ 2660.716298] PM: suspend exit
[ 2660.760258] sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doe=
sn't fully claim to support it.
[ 2660.805940] e1000e: eth1 NIC Link is Down
[ 2660.815147] sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doe=
sn't fully claim to support it.
[ 2660.882695] sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doe=
sn't fully claim to support it.
[ 2660.964317] sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doe=
sn't fully claim to support it.
[ 2663.265787] wlan0: authenticate with 00:00:00:00:00:01
[ 2663.267774] wlan0: send auth to 00:00:00:00:00:01 (try 1/3)
[ 2663.269892] wlan0: authenticated
[ 2663.272172] wlan0: associate with 00:00:00:00:00:01 (try 1/3)
[ 2663.276426] wlan0: RX AssocResp from 00:00:00:00:00:01 (capab=3D0x401 st=
atus=3D0 aid=3D2)
[ 2663.278937] wlan0: associated
[ 4169.580374] WARNING: CPU: 0 PID: 5472 at net/mac80211/agg-tx.c:315 ___ie=
ee80211_stop_tx_ba_session+0x158/0x1f0
[ 4169.580387] Modules linked in:
[ 4169.580405] CPU: 0 PID: 5472 Comm: kworker/u4:0 Not tainted 4.15.0-rc1-n=
ext-20171201 #4
[ 4169.580415] Hardware name: LENOVO 17097HU/17097HU, BIOS 7BETD8WW (2.19 )=
 03/31/2011
[ 4169.580426] Workqueue: phy0 ieee80211_iface_work
[ 4169.580443] task: af30dd45 task.stack: a076399a
[ 4169.580455] EIP: ___ieee80211_stop_tx_ba_session+0x158/0x1f0
[ 4169.580464] EFLAGS: 00210246 CPU: 0
[ 4169.580474] EAX: 00000000 EBX: f5f3d000 ECX: f405c614 EDX: f405c000
[ 4169.580483] ESI: 00000000 EDI: 00000003 EBP: f25a5d98 ESP: f25a5d70
[ 4169.580493]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 4169.580503] CR0: 80050033 CR2: 08295018 CR3: 052e6000 CR4: 000006b0
[ 4169.580513] Call Trace:
[ 4169.580527]  ieee80211_sta_tear_down_BA_sessions+0x6e/0xd0
[ 4169.580538]  __sta_info_destroy_part1+0x3d/0x1f0
[ 4169.580549]  __sta_info_flush+0xf7/0x150
[ 4169.580563]  ieee80211_set_disassoc+0xbc/0x410
[ 4169.580575]  ieee80211_sta_connection_lost+0x30/0x60
[ 4169.580586]  ieee80211_sta_work+0x1b1/0xfc0
[ 4169.580599]  ? __lock_acquire.isra.27+0x4d3/0x8c0
[ 4169.580612]  ? skb_dequeue+0x40/0x60
[ 4169.580623]  ieee80211_iface_work+0x2c8/0x300
[ 4169.580636]  process_one_work+0x158/0x330
[ 4169.580647]  ? process_one_work+0x102/0x330
[ 4169.580658]  worker_thread+0x39/0x3b0
[ 4169.580670]  kthread+0xe4/0x110
[ 4169.580680]  ? process_one_work+0x330/0x330
[ 4169.580691]  ? kthread_create_on_node+0x20/0x20
[ 4169.580701]  ? kthread_create_on_node+0x20/0x20
[ 4169.580713]  ret_from_fork+0x19/0x24
[ 4169.580722] Code: 5d c3 90 c7 45 e4 03 00 00 00 e9 21 ff ff ff 8d 74 26 =
00 8d 83 b0 05 00 00 ba ff ff ff ff e8 60 06 46 ff 85 c0 0f 85 ec fe ff ff =
<0f> ff e9 e5 fe ff ff 90 8b 45 d8 e8 78 34 05 00 83 ff 03 75 5b
[ 4169.581093] ---[ end trace e65d97cf1d20b83f ]---
[ 4169.581142] WARNING: CPU: 0 PID: 5472 at net/mac80211/agg-tx.c:315 ___ie=
ee80211_stop_tx_ba_session+0x158/0x1f0
[ 4169.581150] Modules linked in:
[ 4169.581166] CPU: 0 PID: 5472 Comm: kworker/u4:0 Tainted: G        W     =
   4.15.0-rc1-next-20171201 #4
[ 4169.581175] Hardware name: LENOVO 17097HU/17097HU, BIOS 7BETD8WW (2.19 )=
 03/31/2011
[ 4169.581186] Workqueue: phy0 ieee80211_iface_work
[ 4169.581201] task: af30dd45 task.stack: a076399a
[ 4169.581212] EIP: ___ieee80211_stop_tx_ba_session+0x158/0x1f0
[ 4169.581221] EFLAGS: 00210246 CPU: 0
[ 4169.581231] EAX: 00000000 EBX: f5f3d000 ECX: f405c614 EDX: f405c000
[ 4169.581240] ESI: 00000001 EDI: 00000003 EBP: f25a5d98 ESP: f25a5d70
[ 4169.581250]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 4169.581259] CR0: 80050033 CR2: 08295018 CR3: 052e6000 CR4: 000006b0
[ 4169.581268] Call Trace:
[ 4169.581281]  ieee80211_sta_tear_down_BA_sessions+0x6e/0xd0
[ 4169.581292]  __sta_info_destroy_part1+0x3d/0x1f0
[ 4169.581302]  __sta_info_flush+0xf7/0x150
[ 4169.581315]  ieee80211_set_disassoc+0xbc/0x410
[ 4169.581326]  ieee80211_sta_connection_lost+0x30/0x60
[ 4169.581337]  ieee80211_sta_work+0x1b1/0xfc0
[ 4169.581348]  ? __lock_acquire.isra.27+0x4d3/0x8c0
[ 4169.581359]  ? skb_dequeue+0x40/0x60
[ 4169.581370]  ieee80211_iface_work+0x2c8/0x300
[ 4169.581382]  process_one_work+0x158/0x330
[ 4169.581392]  ? process_one_work+0x102/0x330
[ 4169.581404]  worker_thread+0x39/0x3b0
[ 4169.581414]  kthread+0xe4/0x110
[ 4169.581425]  ? process_one_work+0x330/0x330
[ 4169.581436]  ? kthread_create_on_node+0x20/0x20
[ 4169.581446]  ? kthread_create_on_node+0x20/0x20
[ 4169.581457]  ret_from_fork+0x19/0x24
[ 4169.581466] Code: 5d c3 90 c7 45 e4 03 00 00 00 e9 21 ff ff ff 8d 74 26 =
00 8d 83 b0 05 00 00 ba ff ff ff ff e8 60 06 46 ff 85 c0 0f 85 ec fe ff ff =
<0f> ff e9 e5 fe ff ff 90 8b 45 d8 e8 78 34 05 00 83 ff 03 75 5b
[ 4169.581836] ---[ end trace e65d97cf1d20b840 ]---
[ 4169.581884] WARNING: CPU: 0 PID: 5472 at net/mac80211/agg-tx.c:315 ___ie=
ee80211_stop_tx_ba_session+0x158/0x1f0
[ 4169.581892] Modules linked in:
[ 4169.581908] CPU: 0 PID: 5472 Comm: kworker/u4:0 Tainted: G        W     =
   4.15.0-rc1-next-20171201 #4
[ 4169.581917] Hardware name: LENOVO 17097HU/17097HU, BIOS 7BETD8WW (2.19 )=
 03/31/2011
[ 4169.581928] Workqueue: phy0 ieee80211_iface_work
[ 4169.581943] task: af30dd45 task.stack: a076399a
[ 4169.581954] EIP: ___ieee80211_stop_tx_ba_session+0x158/0x1f0
[ 4169.581962] EFLAGS: 00210246 CPU: 0
[ 4169.581972] EAX: 00000000 EBX: f5f3d000 ECX: f405c614 EDX: f405c000
[ 4169.581981] ESI: 00000002 EDI: 00000003 EBP: f25a5d98 ESP: f25a5d70
[ 4169.581991]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 4169.582001] CR0: 80050033 CR2: 08295018 CR3: 052e6000 CR4: 000006b0
[ 4169.582010] Call Trace:
[ 4169.582022]  ieee80211_sta_tear_down_BA_sessions+0x6e/0xd0
[ 4169.582033]  __sta_info_destroy_part1+0x3d/0x1f0
[ 4169.582043]  __sta_info_flush+0xf7/0x150
[ 4169.582056]  ieee80211_set_disassoc+0xbc/0x410
[ 4169.582067]  ieee80211_sta_connection_lost+0x30/0x60
[ 4169.582078]  ieee80211_sta_work+0x1b1/0xfc0
[ 4169.582089]  ? __lock_acquire.isra.27+0x4d3/0x8c0
[ 4169.582100]  ? skb_dequeue+0x40/0x60
[ 4169.582111]  ieee80211_iface_work+0x2c8/0x300
[ 4169.582123]  process_one_work+0x158/0x330
[ 4169.582134]  ? process_one_work+0x102/0x330
[ 4169.582145]  worker_thread+0x39/0x3b0
[ 4169.582156]  kthread+0xe4/0x110
[ 4169.582166]  ? process_one_work+0x330/0x330
[ 4169.582177]  ? kthread_create_on_node+0x20/0x20
[ 4169.582187]  ? kthread_create_on_node+0x20/0x20
[ 4169.582198]  ret_from_fork+0x19/0x24
[ 4169.582207] Code: 5d c3 90 c7 45 e4 03 00 00 00 e9 21 ff ff ff 8d 74 26 =
00 8d 83 b0 05 00 00 ba ff ff ff ff e8 60 06 46 ff 85 c0 0f 85 ec fe ff ff =
<0f> ff e9 e5 fe ff ff 90 8b 45 d8 e8 78 34 05 00 83 ff 03 75 5b
[ 4169.582577] ---[ end trace e65d97cf1d20b841 ]---
[ 4169.582624] WARNING: CPU: 0 PID: 5472 at net/mac80211/agg-tx.c:315 ___ie=
ee80211_stop_tx_ba_session+0x158/0x1f0
[ 4169.582633] Modules linked in:
[ 4169.582648] CPU: 0 PID: 5472 Comm: kworker/u4:0 Tainted: G        W     =
   4.15.0-rc1-next-20171201 #4
[ 4169.582657] Hardware name: LENOVO 17097HU/17097HU, BIOS 7BETD8WW (2.19 )=
 03/31/2011
[ 4169.582668] Workqueue: phy0 ieee80211_iface_work
[ 4169.582683] task: af30dd45 task.stack: a076399a
[ 4169.582694] EIP: ___ieee80211_stop_tx_ba_session+0x158/0x1f0
[ 4169.582703] EFLAGS: 00210246 CPU: 0
[ 4169.582712] EAX: 00000000 EBX: f5f3d000 ECX: f405c614 EDX: f405c000
[ 4169.582722] ESI: 00000003 EDI: 00000003 EBP: f25a5d98 ESP: f25a5d70
[ 4169.582731]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 4169.582741] CR0: 80050033 CR2: 08295018 CR3: 052e6000 CR4: 000006b0
[ 4169.582750] Call Trace:
[ 4169.582762]  ieee80211_sta_tear_down_BA_sessions+0x6e/0xd0
[ 4169.582773]  __sta_info_destroy_part1+0x3d/0x1f0
[ 4169.582784]  __sta_info_flush+0xf7/0x150
[ 4169.582796]  ieee80211_set_disassoc+0xbc/0x410
[ 4169.582807]  ieee80211_sta_connection_lost+0x30/0x60
[ 4169.582818]  ieee80211_sta_work+0x1b1/0xfc0
[ 4169.582829]  ? __lock_acquire.isra.27+0x4d3/0x8c0
[ 4169.582840]  ? skb_dequeue+0x40/0x60
[ 4169.582851]  ieee80211_iface_work+0x2c8/0x300
[ 4169.582863]  process_one_work+0x158/0x330
[ 4169.582874]  ? process_one_work+0x102/0x330
[ 4169.582885]  worker_thread+0x39/0x3b0
[ 4169.582896]  kthread+0xe4/0x110
[ 4169.582907]  ? process_one_work+0x330/0x330
[ 4169.582917]  ? kthread_create_on_node+0x20/0x20
[ 4169.582927]  ? kthread_create_on_node+0x20/0x20
[ 4169.582938]  ret_from_fork+0x19/0x24
[ 4169.582947] Code: 5d c3 90 c7 45 e4 03 00 00 00 e9 21 ff ff ff 8d 74 26 =
00 8d 83 b0 05 00 00 ba ff ff ff ff e8 60 06 46 ff 85 c0 0f 85 ec fe ff ff =
<0f> ff e9 e5 fe ff ff 90 8b 45 d8 e8 78 34 05 00 83 ff 03 75 5b
[ 4169.583317] ---[ end trace e65d97cf1d20b842 ]---
[ 4169.583364] WARNING: CPU: 0 PID: 5472 at net/mac80211/agg-tx.c:315 ___ie=
ee80211_stop_tx_ba_session+0x158/0x1f0
[ 4169.583373] Modules linked in:
[ 4169.583389] CPU: 0 PID: 5472 Comm: kworker/u4:0 Tainted: G        W     =
   4.15.0-rc1-next-20171201 #4
[ 4169.583398] Hardware name: LENOVO 17097HU/17097HU, BIOS 7BETD8WW (2.19 )=
 03/31/2011
[ 4169.583408] Workqueue: phy0 ieee80211_iface_work
[ 4169.583423] task: af30dd45 task.stack: a076399a
[ 4169.583434] EIP: ___ieee80211_stop_tx_ba_session+0x158/0x1f0
[ 4169.583443] EFLAGS: 00210246 CPU: 0
[ 4169.583452] EAX: 00000000 EBX: f5f3d000 ECX: f405c614 EDX: f405c000
[ 4169.583462] ESI: 00000004 EDI: 00000003 EBP: f25a5d98 ESP: f25a5d70
[ 4169.583471]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 4169.583481] CR0: 80050033 CR2: 08295018 CR3: 052e6000 CR4: 000006b0
[ 4169.583490] Call Trace:
[ 4169.583502]  ieee80211_sta_tear_down_BA_sessions+0x6e/0xd0
[ 4169.583513]  __sta_info_destroy_part1+0x3d/0x1f0
[ 4169.583524]  __sta_info_flush+0xf7/0x150
[ 4169.583536]  ieee80211_set_disassoc+0xbc/0x410
[ 4169.583547]  ieee80211_sta_connection_lost+0x30/0x60
[ 4169.583558]  ieee80211_sta_work+0x1b1/0xfc0
[ 4169.583569]  ? __lock_acquire.isra.27+0x4d3/0x8c0
[ 4169.583581]  ? skb_dequeue+0x40/0x60
[ 4169.583592]  ieee80211_iface_work+0x2c8/0x300
[ 4169.583603]  process_one_work+0x158/0x330
[ 4169.583614]  ? process_one_work+0x102/0x330
[ 4169.583625]  worker_thread+0x39/0x3b0
[ 4169.583636]  kthread+0xe4/0x110
[ 4169.583647]  ? process_one_work+0x330/0x330
[ 4169.583657]  ? kthread_create_on_node+0x20/0x20
[ 4169.583667]  ? kthread_create_on_node+0x20/0x20
[ 4169.583678]  ret_from_fork+0x19/0x24
[ 4169.583687] Code: 5d c3 90 c7 45 e4 03 00 00 00 e9 21 ff ff ff 8d 74 26 =
00 8d 83 b0 05 00 00 ba ff ff ff ff e8 60 06 46 ff 85 c0 0f 85 ec fe ff ff =
<0f> ff e9 e5 fe ff ff 90 8b 45 d8 e8 78 34 05 00 83 ff 03 75 5b
[ 4169.584031] ---[ end trace e65d97cf1d20b843 ]---
[ 4169.584198] WARNING: CPU: 0 PID: 5472 at net/mac80211/agg-tx.c:315 ___ie=
ee80211_stop_tx_ba_session+0x158/0x1f0
[ 4169.584212] Modules linked in:
[ 4169.584239] CPU: 0 PID: 5472 Comm: kworker/u4:0 Tainted: G        W     =
   4.15.0-rc1-next-20171201 #4
[ 4169.584254] Hardware name: LENOVO 17097HU/17097HU, BIOS 7BETD8WW (2.19 )=
 03/31/2011
[ 4169.584270] Workqueue: phy0 ieee80211_iface_work
[ 4169.584294] task: af30dd45 task.stack: a076399a
[ 4169.584310] EIP: ___ieee80211_stop_tx_ba_session+0x158/0x1f0
[ 4169.584325] EFLAGS: 00210246 CPU: 0
[ 4169.584340] EAX: 00000000 EBX: f5f3d000 ECX: f405c614 EDX: f405c000
[ 4169.584354] ESI: 00000005 EDI: 00000003 EBP: f25a5d98 ESP: f25a5d70
[ 4169.584370]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 4169.584384] CR0: 80050033 CR2: 08295018 CR3: 052e6000 CR4: 000006b0
[ 4169.584397] Call Trace:
[ 4169.584415]  ieee80211_sta_tear_down_BA_sessions+0x6e/0xd0
[ 4169.584431]  __sta_info_destroy_part1+0x3d/0x1f0
[ 4169.584447]  __sta_info_flush+0xf7/0x150
[ 4169.584466]  ieee80211_set_disassoc+0xbc/0x410
[ 4169.584482]  ieee80211_sta_connection_lost+0x30/0x60
[ 4169.584498]  ieee80211_sta_work+0x1b1/0xfc0
[ 4169.584514]  ? __lock_acquire.isra.27+0x4d3/0x8c0
[ 4169.584532]  ? skb_dequeue+0x40/0x60
[ 4169.584543]  ieee80211_iface_work+0x2c8/0x300
[ 4169.584555]  process_one_work+0x158/0x330
[ 4169.584566]  ? process_one_work+0x102/0x330
[ 4169.584577]  worker_thread+0x39/0x3b0
[ 4169.584588]  kthread+0xe4/0x110
[ 4169.584598]  ? process_one_work+0x330/0x330
[ 4169.584609]  ? kthread_create_on_node+0x20/0x20
[ 4169.584619]  ? kthread_create_on_node+0x20/0x20
[ 4169.584630]  ret_from_fork+0x19/0x24
[ 4169.584639] Code: 5d c3 90 c7 45 e4 03 00 00 00 e9 21 ff ff ff 8d 74 26 =
00 8d 83 b0 05 00 00 ba ff ff ff ff e8 60 06 46 ff 85 c0 0f 85 ec fe ff ff =
<0f> ff e9 e5 fe ff ff 90 8b 45 d8 e8 78 34 05 00 83 ff 03 75 5b
[ 4169.585009] ---[ end trace e65d97cf1d20b844 ]---
[ 4169.585057] WARNING: CPU: 0 PID: 5472 at net/mac80211/agg-tx.c:315 ___ie=
ee80211_stop_tx_ba_session+0x158/0x1f0
[ 4169.585065] Modules linked in:
[ 4169.585081] CPU: 0 PID: 5472 Comm: kworker/u4:0 Tainted: G        W     =
   4.15.0-rc1-next-20171201 #4
[ 4169.585090] Hardware name: LENOVO 17097HU/17097HU, BIOS 7BETD8WW (2.19 )=
 03/31/2011
[ 4169.585101] Workqueue: phy0 ieee80211_iface_work
[ 4169.585116] task: af30dd45 task.stack: a076399a
[ 4169.585127] EIP: ___ieee80211_stop_tx_ba_session+0x158/0x1f0
[ 4169.585136] EFLAGS: 00210246 CPU: 0
[ 4169.585145] EAX: 00000000 EBX: f5f3d000 ECX: f405c614 EDX: f405c000
[ 4169.585154] ESI: 00000006 EDI: 00000003 EBP: f25a5d98 ESP: f25a5d70
[ 4169.585164]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 4169.585174] CR0: 80050033 CR2: 08295018 CR3: 052e6000 CR4: 000006b0
[ 4169.585183] Call Trace:
[ 4169.585195]  ieee80211_sta_tear_down_BA_sessions+0x6e/0xd0
[ 4169.585206]  __sta_info_destroy_part1+0x3d/0x1f0
[ 4169.585216]  __sta_info_flush+0xf7/0x150
[ 4169.585229]  ieee80211_set_disassoc+0xbc/0x410
[ 4169.585240]  ieee80211_sta_connection_lost+0x30/0x60
[ 4169.585251]  ieee80211_sta_work+0x1b1/0xfc0
[ 4169.585262]  ? __lock_acquire.isra.27+0x4d3/0x8c0
[ 4169.585273]  ? skb_dequeue+0x40/0x60
[ 4169.585284]  ieee80211_iface_work+0x2c8/0x300
[ 4169.585296]  process_one_work+0x158/0x330
[ 4169.585307]  ? process_one_work+0x102/0x330
[ 4169.585318]  worker_thread+0x39/0x3b0
[ 4169.585329]  kthread+0xe4/0x110
[ 4169.585340]  ? process_one_work+0x330/0x330
[ 4169.585350]  ? kthread_create_on_node+0x20/0x20
[ 4169.585360]  ? kthread_create_on_node+0x20/0x20
[ 4169.585371]  ret_from_fork+0x19/0x24
[ 4169.585380] Code: 5d c3 90 c7 45 e4 03 00 00 00 e9 21 ff ff ff 8d 74 26 =
00 8d 83 b0 05 00 00 ba ff ff ff ff e8 60 06 46 ff 85 c0 0f 85 ec fe ff ff =
<0f> ff e9 e5 fe ff ff 90 8b 45 d8 e8 78 34 05 00 83 ff 03 75 5b
[ 4169.585791] ---[ end trace e65d97cf1d20b845 ]---
[ 4169.585839] WARNING: CPU: 0 PID: 5472 at net/mac80211/agg-tx.c:315 ___ie=
ee80211_stop_tx_ba_session+0x158/0x1f0
[ 4169.585848] Modules linked in:
[ 4169.585864] CPU: 0 PID: 5472 Comm: kworker/u4:0 Tainted: G        W     =
   4.15.0-rc1-next-20171201 #4
[ 4169.585873] Hardware name: LENOVO 17097HU/17097HU, BIOS 7BETD8WW (2.19 )=
 03/31/2011
[ 4169.585884] Workqueue: phy0 ieee80211_iface_work
[ 4169.585899] task: af30dd45 task.stack: a076399a
[ 4169.585909] EIP: ___ieee80211_stop_tx_ba_session+0x158/0x1f0
[ 4169.585918] EFLAGS: 00210246 CPU: 0
[ 4169.585928] EAX: 00000000 EBX: f5f3d000 ECX: f405c614 EDX: f405c000
[ 4169.585937] ESI: 00000007 EDI: 00000003 EBP: f25a5d98 ESP: f25a5d70
[ 4169.585947]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 4169.585956] CR0: 80050033 CR2: 08295018 CR3: 052e6000 CR4: 000006b0
[ 4169.585965] Call Trace:
[ 4169.585978]  ieee80211_sta_tear_down_BA_sessions+0x6e/0xd0
[ 4169.585988]  __sta_info_destroy_part1+0x3d/0x1f0
[ 4169.585999]  __sta_info_flush+0xf7/0x150
[ 4169.586011]  ieee80211_set_disassoc+0xbc/0x410
[ 4169.586023]  ieee80211_sta_connection_lost+0x30/0x60
[ 4169.586033]  ieee80211_sta_work+0x1b1/0xfc0
[ 4169.586045]  ? __lock_acquire.isra.27+0x4d3/0x8c0
[ 4169.586056]  ? skb_dequeue+0x40/0x60
[ 4169.586067]  ieee80211_iface_work+0x2c8/0x300
[ 4169.586079]  process_one_work+0x158/0x330
[ 4169.586089]  ? process_one_work+0x102/0x330
[ 4169.586101]  worker_thread+0x39/0x3b0
[ 4169.586111]  kthread+0xe4/0x110
[ 4169.586122]  ? process_one_work+0x330/0x330
[ 4169.586132]  ? kthread_create_on_node+0x20/0x20
[ 4169.586143]  ? kthread_create_on_node+0x20/0x20
[ 4169.586154]  ret_from_fork+0x19/0x24
[ 4169.586163] Code: 5d c3 90 c7 45 e4 03 00 00 00 e9 21 ff ff ff 8d 74 26 =
00 8d 83 b0 05 00 00 ba ff ff ff ff e8 60 06 46 ff 85 c0 0f 85 ec fe ff ff =
<0f> ff e9 e5 fe ff ff 90 8b 45 d8 e8 78 34 05 00 83 ff 03 75 5b
[ 4169.586532] ---[ end trace e65d97cf1d20b846 ]---
[ 4169.586580] WARNING: CPU: 0 PID: 5472 at net/mac80211/agg-tx.c:315 ___ie=
ee80211_stop_tx_ba_session+0x158/0x1f0
[ 4169.586589] Modules linked in:
[ 4169.586605] CPU: 0 PID: 5472 Comm: kworker/u4:0 Tainted: G        W     =
   4.15.0-rc1-next-20171201 #4
[ 4169.586614] Hardware name: LENOVO 17097HU/17097HU, BIOS 7BETD8WW (2.19 )=
 03/31/2011
[ 4169.586624] Workqueue: phy0 ieee80211_iface_work
[ 4169.586639] task: af30dd45 task.stack: a076399a
[ 4169.586650] EIP: ___ieee80211_stop_tx_ba_session+0x158/0x1f0
[ 4169.586659] EFLAGS: 00210246 CPU: 0
[ 4169.586669] EAX: 00000000 EBX: f5f3d000 ECX: f405c614 EDX: f405c000
[ 4169.586678] ESI: 00000008 EDI: 00000003 EBP: f25a5d98 ESP: f25a5d70
[ 4169.586688]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 4169.586697] CR0: 80050033 CR2: 08295018 CR3: 052e6000 CR4: 000006b0
[ 4169.586706] Call Trace:
[ 4169.586718]  ieee80211_sta_tear_down_BA_sessions+0x6e/0xd0
[ 4169.586729]  __sta_info_destroy_part1+0x3d/0x1f0
[ 4169.586740]  __sta_info_flush+0xf7/0x150
[ 4169.586752]  ieee80211_set_disassoc+0xbc/0x410
[ 4169.586764]  ieee80211_sta_connection_lost+0x30/0x60
[ 4169.586774]  ieee80211_sta_work+0x1b1/0xfc0
[ 4169.586786]  ? __lock_acquire.isra.27+0x4d3/0x8c0
[ 4169.586797]  ? skb_dequeue+0x40/0x60
[ 4169.586808]  ieee80211_iface_work+0x2c8/0x300
[ 4169.586819]  process_one_work+0x158/0x330
[ 4169.586830]  ? process_one_work+0x102/0x330
[ 4169.586842]  worker_thread+0x39/0x3b0
[ 4169.586852]  kthread+0xe4/0x110
[ 4169.586863]  ? process_one_work+0x330/0x330
[ 4169.586873]  ? kthread_create_on_node+0x20/0x20
[ 4169.586883]  ? kthread_create_on_node+0x20/0x20
[ 4169.586894]  ret_from_fork+0x19/0x24
[ 4169.586903] Code: 5d c3 90 c7 45 e4 03 00 00 00 e9 21 ff ff ff 8d 74 26 =
00 8d 83 b0 05 00 00 ba ff ff ff ff e8 60 06 46 ff 85 c0 0f 85 ec fe ff ff =
<0f> ff e9 e5 fe ff ff 90 8b 45 d8 e8 78 34 05 00 83 ff 03 75 5b
[ 4169.587273] ---[ end trace e65d97cf1d20b847 ]---
[ 4169.587321] WARNING: CPU: 0 PID: 5472 at net/mac80211/agg-tx.c:315 ___ie=
ee80211_stop_tx_ba_session+0x158/0x1f0
[ 4169.587329] Modules linked in:
[ 4169.587345] CPU: 0 PID: 5472 Comm: kworker/u4:0 Tainted: G        W     =
   4.15.0-rc1-next-20171201 #4
[ 4169.587354] Hardware name: LENOVO 17097HU/17097HU, BIOS 7BETD8WW (2.19 )=
 03/31/2011
[ 4169.587365] Workqueue: phy0 ieee80211_iface_work
[ 4169.587380] task: af30dd45 task.stack: a076399a
[ 4169.587391] EIP: ___ieee80211_stop_tx_ba_session+0x158/0x1f0
[ 4169.587400] EFLAGS: 00210246 CPU: 0
[ 4169.587409] EAX: 00000000 EBX: f5f3d000 ECX: f405c614 EDX: f405c000
[ 4169.587418] ESI: 00000009 EDI: 00000003 EBP: f25a5d98 ESP: f25a5d70
[ 4169.587428]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 4169.587438] CR0: 80050033 CR2: 08295018 CR3: 052e6000 CR4: 000006b0
[ 4169.587447] Call Trace:
[ 4169.587459]  ieee80211_sta_tear_down_BA_sessions+0x6e/0xd0
[ 4169.587470]  __sta_info_destroy_part1+0x3d/0x1f0
[ 4169.587480]  __sta_info_flush+0xf7/0x150
[ 4169.587493]  ieee80211_set_disassoc+0xbc/0x410
[ 4169.587504]  ieee80211_sta_connection_lost+0x30/0x60
[ 4169.587515]  ieee80211_sta_work+0x1b1/0xfc0
[ 4169.587526]  ? __lock_acquire.isra.27+0x4d3/0x8c0
[ 4169.587537]  ? skb_dequeue+0x40/0x60
[ 4169.587548]  ieee80211_iface_work+0x2c8/0x300
[ 4169.587560]  process_one_work+0x158/0x330
[ 4169.587571]  ? process_one_work+0x102/0x330
[ 4169.587582]  worker_thread+0x39/0x3b0
[ 4169.587593]  kthread+0xe4/0x110
[ 4169.587603]  ? process_one_work+0x330/0x330
[ 4169.587614]  ? kthread_create_on_node+0x20/0x20
[ 4169.587624]  ? kthread_create_on_node+0x20/0x20
[ 4169.587635]  ret_from_fork+0x19/0x24
[ 4169.587644] Code: 5d c3 90 c7 45 e4 03 00 00 00 e9 21 ff ff ff 8d 74 26 =
00 8d 83 b0 05 00 00 ba ff ff ff ff e8 60 06 46 ff 85 c0 0f 85 ec fe ff ff =
<0f> ff e9 e5 fe ff ff 90 8b 45 d8 e8 78 34 05 00 83 ff 03 75 5b
[ 4169.588014] ---[ end trace e65d97cf1d20b848 ]---
[ 4169.588125] WARNING: CPU: 0 PID: 5472 at net/mac80211/agg-tx.c:315 ___ie=
ee80211_stop_tx_ba_session+0x158/0x1f0
[ 4169.588134] Modules linked in:
[ 4169.588156] CPU: 0 PID: 5472 Comm: kworker/u4:0 Tainted: G        W     =
   4.15.0-rc1-next-20171201 #4
[ 4169.588170] Hardware name: LENOVO 17097HU/17097HU, BIOS 7BETD8WW (2.19 )=
 03/31/2011
[ 4169.588186] Workqueue: phy0 ieee80211_iface_work
[ 4169.588211] task: af30dd45 task.stack: a076399a
[ 4169.588229] EIP: ___ieee80211_stop_tx_ba_session+0x158/0x1f0
[ 4169.588243] EFLAGS: 00210246 CPU: 0
[ 4169.588258] EAX: 00000000 EBX: f5f3d000 ECX: f405c614 EDX: f405c000
[ 4169.588273] ESI: 0000000a EDI: 00000003 EBP: f25a5d98 ESP: f25a5d70
[ 4169.588288]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 4169.588302] CR0: 80050033 CR2: 08295018 CR3: 052e6000 CR4: 000006b0
[ 4169.588317] Call Trace:
[ 4169.588335]  ieee80211_sta_tear_down_BA_sessions+0x6e/0xd0
[ 4169.588350]  __sta_info_destroy_part1+0x3d/0x1f0
[ 4169.588366]  __sta_info_flush+0xf7/0x150
[ 4169.588383]  ieee80211_set_disassoc+0xbc/0x410
[ 4169.588400]  ieee80211_sta_connection_lost+0x30/0x60
[ 4169.588412]  ieee80211_sta_work+0x1b1/0xfc0
[ 4169.588423]  ? __lock_acquire.isra.27+0x4d3/0x8c0
[ 4169.588434]  ? skb_dequeue+0x40/0x60
[ 4169.588445]  ieee80211_iface_work+0x2c8/0x300
[ 4169.588457]  process_one_work+0x158/0x330
[ 4169.588468]  ? process_one_work+0x102/0x330
[ 4169.588479]  worker_thread+0x39/0x3b0
[ 4169.588490]  kthread+0xe4/0x110
[ 4169.588500]  ? process_one_work+0x330/0x330
[ 4169.588511]  ? kthread_create_on_node+0x20/0x20
[ 4169.588521]  ? kthread_create_on_node+0x20/0x20
[ 4169.588532]  ret_from_fork+0x19/0x24
[ 4169.588541] Code: 5d c3 90 c7 45 e4 03 00 00 00 e9 21 ff ff ff 8d 74 26 =
00 8d 83 b0 05 00 00 ba ff ff ff ff e8 60 06 46 ff 85 c0 0f 85 ec fe ff ff =
<0f> ff e9 e5 fe ff ff 90 8b 45 d8 e8 78 34 05 00 83 ff 03 75 5b
[ 4169.588911] ---[ end trace e65d97cf1d20b849 ]---
[ 4169.588959] WARNING: CPU: 0 PID: 5472 at net/mac80211/agg-tx.c:315 ___ie=
ee80211_stop_tx_ba_session+0x158/0x1f0
[ 4169.588968] Modules linked in:
[ 4169.588984] CPU: 0 PID: 5472 Comm: kworker/u4:0 Tainted: G        W     =
   4.15.0-rc1-next-20171201 #4
[ 4169.588993] Hardware name: LENOVO 17097HU/17097HU, BIOS 7BETD8WW (2.19 )=
 03/31/2011
[ 4169.589003] Workqueue: phy0 ieee80211_iface_work
[ 4169.589018] task: af30dd45 task.stack: a076399a
[ 4169.589029] EIP: ___ieee80211_stop_tx_ba_session+0x158/0x1f0
[ 4169.589043] EFLAGS: 00210246 CPU: 0
[ 4169.589057] EAX: 00000000 EBX: f5f3d000 ECX: f405c614 EDX: f405c000
[ 4169.589073] ESI: 0000000b EDI: 00000003 EBP: f25a5d98 ESP: f25a5d70
[ 4169.589086]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 4169.589095] CR0: 80050033 CR2: 08295018 CR3: 052e6000 CR4: 000006b0
[ 4169.589104] Call Trace:
[ 4169.589117]  ieee80211_sta_tear_down_BA_sessions+0x6e/0xd0
[ 4169.589128]  __sta_info_destroy_part1+0x3d/0x1f0
[ 4169.589138]  __sta_info_flush+0xf7/0x150
[ 4169.589150]  ieee80211_set_disassoc+0xbc/0x410
[ 4169.589162]  ieee80211_sta_connection_lost+0x30/0x60
[ 4169.589172]  ieee80211_sta_work+0x1b1/0xfc0
[ 4169.589184]  ? __lock_acquire.isra.27+0x4d3/0x8c0
[ 4169.589195]  ? skb_dequeue+0x40/0x60
[ 4169.589206]  ieee80211_iface_work+0x2c8/0x300
[ 4169.589217]  process_one_work+0x158/0x330
[ 4169.589233]  ? process_one_work+0x102/0x330
[ 4169.589250]  worker_thread+0x39/0x3b0
[ 4169.589262]  kthread+0xe4/0x110
[ 4169.589273]  ? process_one_work+0x330/0x330
[ 4169.589284]  ? kthread_create_on_node+0x20/0x20
[ 4169.589294]  ? kthread_create_on_node+0x20/0x20
[ 4169.589305]  ret_from_fork+0x19/0x24
[ 4169.589314] Code: 5d c3 90 c7 45 e4 03 00 00 00 e9 21 ff ff ff 8d 74 26 =
00 8d 83 b0 05 00 00 ba ff ff ff ff e8 60 06 46 ff 85 c0 0f 85 ec fe ff ff =
<0f> ff e9 e5 fe ff ff 90 8b 45 d8 e8 78 34 05 00 83 ff 03 75 5b
[ 4169.589689] ---[ end trace e65d97cf1d20b84a ]---
[ 4169.589737] WARNING: CPU: 0 PID: 5472 at net/mac80211/agg-tx.c:315 ___ie=
ee80211_stop_tx_ba_session+0x158/0x1f0
[ 4169.589745] Modules linked in:
[ 4169.589761] CPU: 0 PID: 5472 Comm: kworker/u4:0 Tainted: G        W     =
   4.15.0-rc1-next-20171201 #4
[ 4169.589770] Hardware name: LENOVO 17097HU/17097HU, BIOS 7BETD8WW (2.19 )=
 03/31/2011
[ 4169.589781] Workqueue: phy0 ieee80211_iface_work
[ 4169.589796] task: af30dd45 task.stack: a076399a
[ 4169.589807] EIP: ___ieee80211_stop_tx_ba_session+0x158/0x1f0
[ 4169.589816] EFLAGS: 00210246 CPU: 0
[ 4169.589825] EAX: 00000000 EBX: f5f3d000 ECX: f405c614 EDX: f405c000
[ 4169.589835] ESI: 0000000c EDI: 00000003 EBP: f25a5d98 ESP: f25a5d70
[ 4169.589844]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 4169.589854] CR0: 80050033 CR2: 08295018 CR3: 052e6000 CR4: 000006b0
[ 4169.589863] Call Trace:
[ 4169.589875]  ieee80211_sta_tear_down_BA_sessions+0x6e/0xd0
[ 4169.589886]  __sta_info_destroy_part1+0x3d/0x1f0
[ 4169.589897]  __sta_info_flush+0xf7/0x150
[ 4169.589909]  ieee80211_set_disassoc+0xbc/0x410
[ 4169.589920]  ieee80211_sta_connection_lost+0x30/0x60
[ 4169.589931]  ieee80211_sta_work+0x1b1/0xfc0
[ 4169.589942]  ? __lock_acquire.isra.27+0x4d3/0x8c0
[ 4169.589953]  ? skb_dequeue+0x40/0x60
[ 4169.589964]  ieee80211_iface_work+0x2c8/0x300
[ 4169.589976]  process_one_work+0x158/0x330
[ 4169.589987]  ? process_one_work+0x102/0x330
[ 4169.589998]  worker_thread+0x39/0x3b0
[ 4169.590009]  kthread+0xe4/0x110
[ 4169.590019]  ? process_one_work+0x330/0x330
[ 4169.590030]  ? kthread_create_on_node+0x20/0x20
[ 4169.590040]  ? kthread_create_on_node+0x20/0x20
[ 4169.590051]  ret_from_fork+0x19/0x24
[ 4169.590060] Code: 5d c3 90 c7 45 e4 03 00 00 00 e9 21 ff ff ff 8d 74 26 =
00 8d 83 b0 05 00 00 ba ff ff ff ff e8 60 06 46 ff 85 c0 0f 85 ec fe ff ff =
<0f> ff e9 e5 fe ff ff 90 8b 45 d8 e8 78 34 05 00 83 ff 03 75 5b
[ 4169.590417] ---[ end trace e65d97cf1d20b84b ]---
[ 4169.590453] WARNING: CPU: 0 PID: 5472 at net/mac80211/agg-tx.c:315 ___ie=
ee80211_stop_tx_ba_session+0x158/0x1f0
[ 4169.590459] Modules linked in:
[ 4169.590471] CPU: 0 PID: 5472 Comm: kworker/u4:0 Tainted: G        W     =
   4.15.0-rc1-next-20171201 #4
[ 4169.590478] Hardware name: LENOVO 17097HU/17097HU, BIOS 7BETD8WW (2.19 )=
 03/31/2011
[ 4169.590486] Workqueue: phy0 ieee80211_iface_work
[ 4169.590497] task: af30dd45 task.stack: a076399a
[ 4169.590506] EIP: ___ieee80211_stop_tx_ba_session+0x158/0x1f0
[ 4169.590512] EFLAGS: 00210246 CPU: 0
[ 4169.590519] EAX: 00000000 EBX: f5f3d000 ECX: f405c614 EDX: f405c000
[ 4169.590526] ESI: 0000000d EDI: 00000003 EBP: f25a5d98 ESP: f25a5d70
[ 4169.590534]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 4169.590541] CR0: 80050033 CR2: 08295018 CR3: 052e6000 CR4: 000006b0
[ 4169.590548] Call Trace:
[ 4169.590557]  ieee80211_sta_tear_down_BA_sessions+0x6e/0xd0
[ 4169.590565]  __sta_info_destroy_part1+0x3d/0x1f0
[ 4169.590573]  __sta_info_flush+0xf7/0x150
[ 4169.590582]  ieee80211_set_disassoc+0xbc/0x410
[ 4169.590591]  ieee80211_sta_connection_lost+0x30/0x60
[ 4169.590599]  ieee80211_sta_work+0x1b1/0xfc0
[ 4169.590607]  ? __lock_acquire.isra.27+0x4d3/0x8c0
[ 4169.590615]  ? skb_dequeue+0x40/0x60
[ 4169.590624]  ieee80211_iface_work+0x2c8/0x300
[ 4169.590632]  process_one_work+0x158/0x330
[ 4169.590641]  ? process_one_work+0x102/0x330
[ 4169.590649]  worker_thread+0x39/0x3b0
[ 4169.590657]  kthread+0xe4/0x110
[ 4169.590665]  ? process_one_work+0x330/0x330
[ 4169.590673]  ? kthread_create_on_node+0x20/0x20
[ 4169.590681]  ? kthread_create_on_node+0x20/0x20
[ 4169.590689]  ret_from_fork+0x19/0x24
[ 4169.590696] Code: 5d c3 90 c7 45 e4 03 00 00 00 e9 21 ff ff ff 8d 74 26 =
00 8d 83 b0 05 00 00 ba ff ff ff ff e8 60 06 46 ff 85 c0 0f 85 ec fe ff ff =
<0f> ff e9 e5 fe ff ff 90 8b 45 d8 e8 78 34 05 00 83 ff 03 75 5b
[ 4169.590973] ---[ end trace e65d97cf1d20b84c ]---
[ 4169.591009] WARNING: CPU: 0 PID: 5472 at net/mac80211/agg-tx.c:315 ___ie=
ee80211_stop_tx_ba_session+0x158/0x1f0
[ 4169.591015] Modules linked in:
[ 4169.591027] CPU: 0 PID: 5472 Comm: kworker/u4:0 Tainted: G        W     =
   4.15.0-rc1-next-20171201 #4
[ 4169.591034] Hardware name: LENOVO 17097HU/17097HU, BIOS 7BETD8WW (2.19 )=
 03/31/2011
[ 4169.591042] Workqueue: phy0 ieee80211_iface_work
[ 4169.591053] task: af30dd45 task.stack: a076399a
[ 4169.591061] EIP: ___ieee80211_stop_tx_ba_session+0x158/0x1f0
[ 4169.591068] EFLAGS: 00210246 CPU: 0
[ 4169.591075] EAX: 00000000 EBX: f5f3d000 ECX: f405c614 EDX: f405c000
[ 4169.591082] ESI: 0000000e EDI: 00000003 EBP: f25a5d98 ESP: f25a5d70
[ 4169.591089]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 4169.591097] CR0: 80050033 CR2: 08295018 CR3: 052e6000 CR4: 000006b0
[ 4169.591103] Call Trace:
[ 4169.591112]  ieee80211_sta_tear_down_BA_sessions+0x6e/0xd0
[ 4169.591120]  __sta_info_destroy_part1+0x3d/0x1f0
[ 4169.591129]  __sta_info_flush+0xf7/0x150
[ 4169.591138]  ieee80211_set_disassoc+0xbc/0x410
[ 4169.591146]  ieee80211_sta_connection_lost+0x30/0x60
[ 4169.591154]  ieee80211_sta_work+0x1b1/0xfc0
[ 4169.591163]  ? __lock_acquire.isra.27+0x4d3/0x8c0
[ 4169.591171]  ? skb_dequeue+0x40/0x60
[ 4169.591179]  ieee80211_iface_work+0x2c8/0x300
[ 4169.591188]  process_one_work+0x158/0x330
[ 4169.591197]  ? process_one_work+0x102/0x330
[ 4169.591205]  worker_thread+0x39/0x3b0
[ 4169.591213]  kthread+0xe4/0x110
[ 4169.591221]  ? process_one_work+0x330/0x330
[ 4169.591229]  ? kthread_create_on_node+0x20/0x20
[ 4169.591237]  ? kthread_create_on_node+0x20/0x20
[ 4169.591245]  ret_from_fork+0x19/0x24
[ 4169.591252] Code: 5d c3 90 c7 45 e4 03 00 00 00 e9 21 ff ff ff 8d 74 26 =
00 8d 83 b0 05 00 00 ba ff ff ff ff e8 60 06 46 ff 85 c0 0f 85 ec fe ff ff =
<0f> ff e9 e5 fe ff ff 90 8b 45 d8 e8 78 34 05 00 83 ff 03 75 5b
[ 4169.591529] ---[ end trace e65d97cf1d20b84d ]---
[ 4169.591565] WARNING: CPU: 0 PID: 5472 at net/mac80211/agg-tx.c:315 ___ie=
ee80211_stop_tx_ba_session+0x158/0x1f0
[ 4169.591571] Modules linked in:
[ 4169.591583] CPU: 0 PID: 5472 Comm: kworker/u4:0 Tainted: G        W     =
   4.15.0-rc1-next-20171201 #4
[ 4169.591590] Hardware name: LENOVO 17097HU/17097HU, BIOS 7BETD8WW (2.19 )=
 03/31/2011
[ 4169.591598] Workqueue: phy0 ieee80211_iface_work
[ 4169.591609] task: af30dd45 task.stack: a076399a
[ 4169.591617] EIP: ___ieee80211_stop_tx_ba_session+0x158/0x1f0
[ 4169.591624] EFLAGS: 00210246 CPU: 0
[ 4169.591631] EAX: 00000000 EBX: f5f3d000 ECX: f405c614 EDX: f405c000
[ 4169.591638] ESI: 0000000f EDI: 00000003 EBP: f25a5d98 ESP: f25a5d70
[ 4169.591645]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 4169.591653] CR0: 80050033 CR2: 08295018 CR3: 052e6000 CR4: 000006b0
[ 4169.591660] Call Trace:
[ 4169.591669]  ieee80211_sta_tear_down_BA_sessions+0x6e/0xd0
[ 4169.591677]  __sta_info_destroy_part1+0x3d/0x1f0
[ 4169.591685]  __sta_info_flush+0xf7/0x150
[ 4169.591694]  ieee80211_set_disassoc+0xbc/0x410
[ 4169.591702]  ieee80211_sta_connection_lost+0x30/0x60
[ 4169.591711]  ieee80211_sta_work+0x1b1/0xfc0
[ 4169.591719]  ? __lock_acquire.isra.27+0x4d3/0x8c0
[ 4169.591727]  ? skb_dequeue+0x40/0x60
[ 4169.591736]  ieee80211_iface_work+0x2c8/0x300
[ 4169.591744]  process_one_work+0x158/0x330
[ 4169.591752]  ? process_one_work+0x102/0x330
[ 4169.591761]  worker_thread+0x39/0x3b0
[ 4169.591769]  kthread+0xe4/0x110
[ 4169.591777]  ? process_one_work+0x330/0x330
[ 4169.591785]  ? kthread_create_on_node+0x20/0x20
[ 4169.591792]  ? kthread_create_on_node+0x20/0x20
[ 4169.591801]  ret_from_fork+0x19/0x24
[ 4169.591807] Code: 5d c3 90 c7 45 e4 03 00 00 00 e9 21 ff ff ff 8d 74 26 =
00 8d 83 b0 05 00 00 ba ff ff ff ff e8 60 06 46 ff 85 c0 0f 85 ec fe ff ff =
<0f> ff e9 e5 fe ff ff 90 8b 45 d8 e8 78 34 05 00 83 ff 03 75 5b
[ 4169.592055] ---[ end trace e65d97cf1d20b84e ]---
[ 4171.884754] wlan0: authenticate with 00:00:00:00:00:01
[ 4171.884987] wlan0: send auth to 00:00:00:00:00:01 (try 1/3)
[ 4171.887065] wlan0: authenticated
[ 4171.889394] wlan0: associate with 00:00:00:00:00:01 (try 1/3)
[ 4171.892343] wlan0: RX AssocResp from 00:00:00:00:00:01 (capab=3D0x401 st=
atus=3D0 aid=3D2)
[ 4171.895412] wlan0: associated

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--dDRMvlgZJXvWKvBx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlomc+EACgkQMOfwapXb+vIgtACaA64LpAbeK3bZ6oHjoh12Dokw
8DgAoJyLF9t3f0DEw+7lgvyIp1TaZcNE
=g6Om
-----END PGP SIGNATURE-----

--dDRMvlgZJXvWKvBx--
