Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47421 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030382Ab0B1Qkf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Feb 2010 11:40:35 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Dawid <quadri@tlen.pl>
Cc: 567212@bugs.debian.org, linux-wireless@vger.kernel.org
In-Reply-To: <4B62D7C9.9050904@tlen.pl>
References: <4B60D3DD.60802@tlen.pl> <1264721331.373.555.camel@localhost>
	 <4B62D7C9.9050904@tlen.pl>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-DRNEiISBF1XnQLMSlZFr"
Date: Sun, 28 Feb 2010 16:40:07 +0000
Message-ID: <1267375207.2282.23.camel@localhost>
Mime-Version: 1.0
Subject: Re: Bug#567212: rt73usb with 2.6.32-trunk kernel
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-DRNEiISBF1XnQLMSlZFr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dawid wrote:
> I use Edimax EW-7318USg  usb wifi adapter with rt73 chipset  - i use=20
> default rt73usb driver that is built in kernel and standard firmware=20
> from non-free repository package: firmware-ralink (0.22)  - on new=20
> 2.6.32 trunk kernel, connection is very unstable - i can connect to my=20
> access point but i get disconnected periodicly in about 6 to 10 seconds=20
> and get connected again afer about 4 seconds. This process repeats=20
> itself continously. I use WPAPSK autentication TKIP encryption in=20
> managed mode - with wpa_supplicant - encryption works but i guess=20
> becouse of such frequent disconnetions dhclient can't get IP and i can't=20
> connect to internet.
>=20
> On previous 2.6.30 kernel and same configuration, everything works fine=20
> and connection is stable.
>=20
> scanning with iwlist works on both kernels but on 2.6.32-trunk takes 2=20
> times longer.

Dawid wrote:
> I attached kern.log to this e-mail.  Last logs in this file were made on=20
> 2.6.32-trunk kernel to make wlan0 entries from this kernel, clearly seen=20
> at the end of the file.
>=20
>=20
> >
> > Were you using the rt73usb driver (from Debian kernel packages) or the
> > rt73 driver (from rt73-source or from Ralink)?
> >
> >  =20
> I'm using standard rt73usb driver from Debian kernel packages on both=20
> kernels 2.6.30 and 2.6.32 - and as i wrote before, described problem=20
> exist only in 2.6.32 . Now i'm forced to use 2.6.30 becouse on this=20
> kernel internet connection is possible.

I'm forwarding this to the linux-wireless list in the hope that someone
there will be able to investigate this.

Ben.

[...]
> Jan 29 13:18:39 siduxbox kernel: imklog 4.4.2, log source =3D /proc/kmsg =
started.
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] Initializing cgroup subsy=
s cpuset
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] Initializing cgroup subsy=
s cpu
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] Linux version 2.6.32-trun=
k-686 (Debian 2.6.32-5) (ben@decadent.org.uk) (gcc version 4.3.4 (Debian 4.=
3.4-6) ) #1 SMP Sun Jan 10 06:32:16 UTC 2010
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] KERNEL supported cpus:
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]   Intel GenuineIntel
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]   AMD AuthenticAMD
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]   NSC Geode by NSC
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]   Cyrix CyrixInstead
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]   Centaur CentaurHauls
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]   Transmeta GenuineTMx86
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]   Transmeta TransmetaCPU
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]   UMC UMC UMC UMC
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] BIOS-provided physical RA=
M map:
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]  BIOS-e820: 0000000000000=
000 - 000000000009fc00 (usable)
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]  BIOS-e820: 000000000009f=
c00 - 00000000000a0000 (reserved)
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]  BIOS-e820: 00000000000d0=
000 - 00000000000d8000 (reserved)
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]  BIOS-e820: 00000000000f0=
000 - 0000000000100000 (reserved)
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]  BIOS-e820: 0000000000100=
000 - 000000007fff0000 (usable)
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]  BIOS-e820: 000000007fff0=
000 - 000000007fff8000 (ACPI data)
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]  BIOS-e820: 000000007fff8=
000 - 0000000080000000 (ACPI NVS)
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]  BIOS-e820: 00000000fec00=
000 - 00000000fec01000 (reserved)
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]  BIOS-e820: 00000000fee00=
000 - 00000000fee01000 (reserved)
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]  BIOS-e820: 00000000fff00=
000 - 0000000100000000 (reserved)
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] DMI 2.3 present.
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] AMI BIOS detected: BIOS m=
ay corrupt low RAM, working around it.
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] e820 update range: 000000=
0000000000 - 0000000000010000 (usable) =3D=3D> (reserved)
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] last_pfn =3D 0x7fff0 max_=
arch_pfn =3D 0x100000
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] MTRR default type: uncach=
able
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] MTRR fixed ranges enabled=
:
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]   00000-9FFFF write-back
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]   A0000-BFFFF uncachable
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]   C0000-C7FFF write-prote=
ct
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]   C8000-EFFFF uncachable
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]   F0000-FFFFF write-prote=
ct
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] MTRR variable ranges enab=
led:
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]   0 base 000000000 mask F=
80000000 write-back
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]   1 base 0E0000000 mask F=
F8000000 write-combining
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]   2 disabled
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]   3 disabled
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]   4 disabled
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]   5 disabled
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]   6 disabled
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]   7 disabled
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] x86 PAT enabled: cpu 0, o=
ld 0x7040600070406, new 0x7010600070106
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] initial memory mapped : 0=
 - 01800000
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] init_memory_mapping: 0000=
000000000000-00000000373fe000
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]  0000000000 - 0000400000 =
page 4k
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]  0000400000 - 0037000000 =
page 2M
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]  0037000000 - 00373fe000 =
page 4k
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] kernel direct mapping tab=
les up to 373fe000 @ 10000-16000
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] RAMDISK: 37704000 - 37fef=
708
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] Allocated new RAMDISK: 00=
100000 - 009eb708
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] Move RAMDISK from 0000000=
037704000 - 0000000037fef707 to 00100000 - 009eb707
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] ACPI: RSDP 000f9f20 00014=
 (v00 AMI   )
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] ACPI: RSDT 7fff0000 0002C=
 (v01 AMIINT INTEL845 00000010 MSFT 00000097)
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] ACPI: FACP 7fff0030 00081=
 (v01 AMIINT INTEL845 00000011 MSFT 00000097)
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] ACPI: DSDT 7fff0120 03748=
 (v01  INTEL BROKDLEG 00001000 MSFT 0100000D)
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] ACPI: FACS 7fff8000 00040
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] ACPI: APIC 7fff00c0 0005C=
 (v01 AMIINT INTEL845 00000009 MSFT 00000097)
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] ACPI: Local APIC address =
0xfee00000
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] 1163MB HIGHMEM available.
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] 883MB LOWMEM available.
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]   mapped low ram: 0 - 373=
fe000
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]   low ram: 0 - 373fe000
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]   node 0 low ram: 0000000=
0 - 373fe000
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]   node 0 bootmap 00012000=
 - 00018e80
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] (9 early reservations) =
=3D=3D> bootmem [0000000000 - 00373fe000]
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]   #0 [0000000000 - 000000=
1000]   BIOS data page =3D=3D> [0000000000 - 0000001000]
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]   #1 [0000001000 - 000000=
2000]    EX TRAMPOLINE =3D=3D> [0000001000 - 0000002000]
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]   #2 [0000006000 - 000000=
7000]       TRAMPOLINE =3D=3D> [0000006000 - 0000007000]
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]   #3 [0001000000 - 00014a=
1334]    TEXT DATA BSS =3D=3D> [0001000000 - 00014a1334]
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]   #4 [000009fc00 - 000010=
0000]    BIOS reserved =3D=3D> [000009fc00 - 0000100000]
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]   #5 [00014a2000 - 00014a=
811c]              BRK =3D=3D> [00014a2000 - 00014a811c]
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]   #6 [0000010000 - 000001=
2000]          PGTABLE =3D=3D> [0000010000 - 0000012000]
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]   #7 [0000100000 - 00009e=
b708]      NEW RAMDISK =3D=3D> [0000100000 - 00009eb708]
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]   #8 [0000012000 - 000001=
9000]          BOOTMAP =3D=3D> [0000012000 - 0000019000]
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] found SMP MP-table at [c0=
0fb9f0] fb9f0
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] Zone PFN ranges:
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]   DMA      0x00000010 -> =
0x00001000
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]   Normal   0x00001000 -> =
0x000373fe
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]   HighMem  0x000373fe -> =
0x0007fff0
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] Movable zone start PFN fo=
r each node
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] early_node_map[2] active =
PFN ranges
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]     0: 0x00000010 -> 0x00=
00009f
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]     0: 0x00000100 -> 0x00=
07fff0
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] On node 0 totalpages: 524=
159
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] free_area_init_node: node=
 0, pgdat c138edc0, node_mem_map c14aa200
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]   DMA zone: 32 pages used=
 for memmap
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]   DMA zone: 0 pages reser=
ved
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]   DMA zone: 3951 pages, L=
IFO batch:0
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]   Normal zone: 1736 pages=
 used for memmap
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]   Normal zone: 220470 pag=
es, LIFO batch:31
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]   HighMem zone: 2328 page=
s used for memmap
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]   HighMem zone: 295642 pa=
ges, LIFO batch:31
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] Using APIC driver default
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] ACPI: PM-Timer IO Port: 0=
x808
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] ACPI: Local APIC address =
0xfee00000
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x01=
] lapic_id[0x00] enabled)
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x02=
] lapic_id[0x01] enabled)
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] ACPI: IOAPIC (id[0x02] ad=
dress[0xfec00000] gsi_base[0])
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] IOAPIC[0]: apic_id 2, ver=
sion 32, address 0xfec00000, GSI 0-23
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 =
bus_irq 0 global_irq 2 dfl dfl)
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 =
bus_irq 9 global_irq 9 high level)
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] ACPI: IRQ0 used by overri=
de.
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] ACPI: IRQ2 used by overri=
de.
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] ACPI: IRQ9 used by overri=
de.
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] Enabling APIC mode:  Flat=
.  Using 1 I/O APICs
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] Using ACPI (MADT) for SMP=
 configuration information
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] SMP: Allowing 2 CPUs, 0 h=
otplug CPUs
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] nr_irqs_gsi: 24
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] PM: Registered nosave mem=
ory: 000000000009f000 - 00000000000a0000
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] PM: Registered nosave mem=
ory: 00000000000a0000 - 00000000000d0000
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] PM: Registered nosave mem=
ory: 00000000000d0000 - 00000000000d8000
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] PM: Registered nosave mem=
ory: 00000000000d8000 - 00000000000f0000
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] PM: Registered nosave mem=
ory: 00000000000f0000 - 0000000000100000
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] Allocating PCI resources =
starting at 80000000 (gap: 80000000:7ec00000)
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] Booting paravirtualized k=
ernel on bare hardware
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] NR_CPUS:32 nr_cpumask_bit=
s:32 nr_cpu_ids:2 nr_node_ids:1
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] PERCPU: Embedded 14 pages=
/cpu @c2800000 s34072 r0 d23272 u2097152
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] pcpu-alloc: s34072 r0 d23=
272 u2097152 alloc=3D1*4194304
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] pcpu-alloc: [0] 0 1=20
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] Built 1 zonelists in Zone=
 order, mobility grouping on.  Total pages: 520063
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] Kernel command line: root=
=3DUUID=3D67cee1d1-ee34-4b62-921b-f5ef42807a5f ro quiet vga=3D791
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] PID hash table entries: 4=
096 (order: 2, 16384 bytes)
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] Dentry cache hash table e=
ntries: 131072 (order: 7, 524288 bytes)
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] Inode-cache hash table en=
tries: 65536 (order: 6, 262144 bytes)
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] Enabling fast FPU save an=
d restore... done.
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] Enabling unmasked SIMD FP=
U exception support... done.
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] Initializing CPU#0
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] Initializing HighMem for =
node 0 (000373fe:0007fff0)
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] Memory: 2064348k/2097088k=
 available (2414k kernel code, 31268k reserved, 1266k data, 368k init, 1191=
880k highmem)
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] virtual kernel memory lay=
out:
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]     fixmap  : 0xffd56000 =
- 0xfffff000   (2724 kB)
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]     pkmap   : 0xff400000 =
- 0xff800000   (4096 kB)
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]     vmalloc : 0xf7bfe000 =
- 0xff3fe000   ( 120 MB)
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]     lowmem  : 0xc0000000 =
- 0xf73fe000   ( 883 MB)
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]       .init : 0xc1399000 =
- 0xc13f5000   ( 368 kB)
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]       .data : 0xc125bb11 =
- 0xc1398560   (1266 kB)
> Jan 29 13:18:39 siduxbox kernel: [    0.000000]       .text : 0xc1000000 =
- 0xc125bb11   (2414 kB)
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] Checking if this processo=
r honours the WP bit even in supervisor mode...Ok.
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] SLUB: Genslabs=3D13, HWal=
ign=3D128, Order=3D0-3, MinObjects=3D0, CPUs=3D2, Nodes=3D1
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] Hierarchical RCU implemen=
tation.
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] NR_IRQS:1280
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] Console: colour dummy dev=
ice 80x25
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] console [tty0] enabled
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] Fast TSC calibration usin=
g PIT
> Jan 29 13:18:39 siduxbox kernel: [    0.000000] Detected 3073.861 MHz pro=
cessor.
> Jan 29 13:18:39 siduxbox kernel: [    0.004007] Calibrating delay loop (s=
kipped), value calculated using timer frequency.. 6147.72 BogoMIPS (lpj=3D1=
2295444)
> Jan 29 13:18:39 siduxbox kernel: [    0.004030] Security Framework initia=
lized
> Jan 29 13:18:39 siduxbox kernel: [    0.004040] SELinux:  Disabled at boo=
t.
> Jan 29 13:18:39 siduxbox kernel: [    0.004048] Mount-cache hash table en=
tries: 512
> Jan 29 13:18:39 siduxbox kernel: [    0.004243] Initializing cgroup subsy=
s ns
> Jan 29 13:18:39 siduxbox kernel: [    0.004249] Initializing cgroup subsy=
s cpuacct
> Jan 29 13:18:39 siduxbox kernel: [    0.004254] Initializing cgroup subsy=
s devices
> Jan 29 13:18:39 siduxbox kernel: [    0.004257] Initializing cgroup subsy=
s freezer
> Jan 29 13:18:39 siduxbox kernel: [    0.004260] Initializing cgroup subsy=
s net_cls
> Jan 29 13:18:39 siduxbox kernel: [    0.004291] CPU: Trace cache: 12K uop=
s, L1 D cache: 8K
> Jan 29 13:18:39 siduxbox kernel: [    0.004295] CPU: L2 cache: 512K
> Jan 29 13:18:39 siduxbox kernel: [    0.004298] CPU: Physical Processor I=
D: 0
> Jan 29 13:18:39 siduxbox kernel: [    0.004300] CPU: Processor Core ID: 0
> Jan 29 13:18:39 siduxbox kernel: [    0.004305] mce: CPU supports 4 MCE b=
anks
> Jan 29 13:18:39 siduxbox kernel: [    0.004317] CPU0: Thermal monitoring =
enabled (TM1)
> Jan 29 13:18:39 siduxbox kernel: [    0.004335] Performance Events: no PM=
U driver, software events only.
> Jan 29 13:18:39 siduxbox kernel: [    0.004343] Checking 'hlt' instructio=
n... OK.
> Jan 29 13:18:39 siduxbox kernel: [    0.021255] ACPI: Core revision 20090=
903
> Jan 29 13:18:39 siduxbox kernel: [    0.028559] ..TIMER: vector=3D0x30 ap=
ic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D-1
> Jan 29 13:18:39 siduxbox kernel: [    0.068820] CPU0: Intel(R) Pentium(R)=
 4 CPU 3.06GHz stepping 07
> Jan 29 13:18:39 siduxbox kernel: [    0.072001] Booting processor 1 APIC =
0x1 ip 0x6000
> Jan 29 13:18:39 siduxbox kernel: [    0.008000] Initializing CPU#1
> Jan 29 13:18:39 siduxbox kernel: [    0.008000] Calibrating delay using t=
imer specific routine.. 6147.49 BogoMIPS (lpj=3D12294998)
> Jan 29 13:18:39 siduxbox kernel: [    0.008000] CPU: Trace cache: 12K uop=
s, L1 D cache: 8K
> Jan 29 13:18:39 siduxbox kernel: [    0.008000] CPU: L2 cache: 512K
> Jan 29 13:18:39 siduxbox kernel: [    0.008000] CPU: Physical Processor I=
D: 0
> Jan 29 13:18:39 siduxbox kernel: [    0.008000] CPU: Processor Core ID: 0
> Jan 29 13:18:39 siduxbox kernel: [    0.008000] CPU1: Thermal monitoring =
enabled (TM1)
> Jan 29 13:18:39 siduxbox kernel: [    0.156106] CPU1: Intel(R) Pentium(R)=
 4 CPU 3.06GHz stepping 07
> Jan 29 13:18:39 siduxbox kernel: [    0.156122] checking TSC synchronizat=
ion [CPU#0 -> CPU#1]: passed.
> Jan 29 13:18:39 siduxbox kernel: [    0.160119] Brought up 2 CPUs
> Jan 29 13:18:39 siduxbox kernel: [    0.160125] Total of 2 processors act=
ivated (12295.22 BogoMIPS).
> Jan 29 13:18:39 siduxbox kernel: [    0.160331] CPU0 attaching sched-doma=
in:
> Jan 29 13:18:39 siduxbox kernel: [    0.160337]  domain 0: span 0-1 level=
 SIBLING
> Jan 29 13:18:39 siduxbox kernel: [    0.160340]   groups: 0 (cpu_power =
=3D 589) 1 (cpu_power =3D 589)
> Jan 29 13:18:39 siduxbox kernel: [    0.160348]   domain 1: span 0-1 leve=
l MC
> Jan 29 13:18:39 siduxbox kernel: [    0.160351]    groups: 0-1 (cpu_power=
 =3D 1178)
> Jan 29 13:18:39 siduxbox kernel: [    0.160358] CPU1 attaching sched-doma=
in:
> Jan 29 13:18:39 siduxbox kernel: [    0.160360]  domain 0: span 0-1 level=
 SIBLING
> Jan 29 13:18:39 siduxbox kernel: [    0.160363]   groups: 1 (cpu_power =
=3D 589) 0 (cpu_power =3D 589)
> Jan 29 13:18:39 siduxbox kernel: [    0.160370]   domain 1: span 0-1 leve=
l MC
> Jan 29 13:18:39 siduxbox kernel: [    0.160373]    groups: 0-1 (cpu_power=
 =3D 1178)
> Jan 29 13:18:39 siduxbox kernel: [    0.160604] devtmpfs: initialized
> Jan 29 13:18:39 siduxbox kernel: [    0.161092] regulator: core version 0=
.5
> Jan 29 13:18:39 siduxbox kernel: [    0.161167] NET: Registered protocol =
family 16
> Jan 29 13:18:39 siduxbox kernel: [    0.161275] ACPI: bus type pci regist=
ered
> Jan 29 13:18:39 siduxbox kernel: [    0.162896] PCI: PCI BIOS revision 2.=
10 entry at 0xfdb81, last bus=3D2
> Jan 29 13:18:39 siduxbox kernel: [    0.162900] PCI: Using configuration =
type 1 for base access
> Jan 29 13:18:39 siduxbox kernel: [    0.163416] bio: create slab <bio-0> =
at 0
> Jan 29 13:18:39 siduxbox kernel: [    0.164305] ACPI: EC: Look up EC in D=
SDT
> Jan 29 13:18:39 siduxbox kernel: [    0.169719] ACPI: Interpreter enabled
> Jan 29 13:18:39 siduxbox kernel: [    0.169730] ACPI: (supports S0 S1 S4 =
S5)
> Jan 29 13:18:39 siduxbox kernel: [    0.169753] ACPI: Using IOAPIC for in=
terrupt routing
> Jan 29 13:18:39 siduxbox kernel: [    0.174542] ACPI: Power Resource [URP=
1] (off)
> Jan 29 13:18:39 siduxbox kernel: [    0.174577] ACPI: Power Resource [URP=
2] (off)
> Jan 29 13:18:39 siduxbox kernel: [    0.174610] ACPI: Power Resource [FDD=
P] (off)
> Jan 29 13:18:39 siduxbox kernel: [    0.174644] ACPI: Power Resource [LPT=
P] (off)
> Jan 29 13:18:39 siduxbox kernel: [    0.174799] ACPI: No dock devices fou=
nd.
> Jan 29 13:18:39 siduxbox kernel: [    0.174943] ACPI: PCI Root Bridge [PC=
I0] (0000:00)
> Jan 29 13:18:39 siduxbox kernel: [    0.174999] pci 0000:00:00.0: reg 10 =
32bit mmio pref: [0xe0000000-0xe7ffffff]
> Jan 29 13:18:39 siduxbox kernel: [    0.175153] pci 0000:00:1d.0: reg 20 =
io port: [0xe400-0xe41f]
> Jan 29 13:18:39 siduxbox kernel: [    0.175209] pci 0000:00:1d.1: reg 20 =
io port: [0xe800-0xe81f]
> Jan 29 13:18:39 siduxbox kernel: [    0.175265] pci 0000:00:1d.2: reg 20 =
io port: [0xec00-0xec1f]
> Jan 29 13:18:39 siduxbox kernel: [    0.175330] pci 0000:00:1d.7: reg 10 =
32bit mmio: [0xdffffc00-0xdfffffff]
> Jan 29 13:18:39 siduxbox kernel: [    0.175389] pci 0000:00:1d.7: PME# su=
pported from D0 D3hot D3cold
> Jan 29 13:18:39 siduxbox kernel: [    0.175395] pci 0000:00:1d.7: PME# di=
sabled
> Jan 29 13:18:39 siduxbox kernel: [    0.175449] * The chipset may have PM=
-Timer Bug. Due to workarounds for a bug,
> Jan 29 13:18:39 siduxbox kernel: [    0.175451] * this clock source is sl=
ow. If you are sure your timer does not have
> Jan 29 13:18:39 siduxbox kernel: [    0.175452] * this bug, please use "a=
cpi_pm_good" to disable the workaround
> Jan 29 13:18:39 siduxbox kernel: [    0.175496] pci 0000:00:1f.0: quirk: =
region 0800-087f claimed by ICH4 ACPI/GPIO/TCO
> Jan 29 13:18:39 siduxbox kernel: [    0.175500] pci 0000:00:1f.0: quirk: =
region 0400-043f claimed by ICH4 GPIO
> Jan 29 13:18:39 siduxbox kernel: [    0.175527] pci 0000:00:1f.1: reg 10 =
io port: [0x00-0x07]
> Jan 29 13:18:39 siduxbox kernel: [    0.175534] pci 0000:00:1f.1: reg 14 =
io port: [0x00-0x03]
> Jan 29 13:18:39 siduxbox kernel: [    0.175542] pci 0000:00:1f.1: reg 18 =
io port: [0x00-0x07]
> Jan 29 13:18:39 siduxbox kernel: [    0.175550] pci 0000:00:1f.1: reg 1c =
io port: [0x00-0x03]
> Jan 29 13:18:39 siduxbox kernel: [    0.175557] pci 0000:00:1f.1: reg 20 =
io port: [0xfc00-0xfc0f]
> Jan 29 13:18:39 siduxbox kernel: [    0.175565] pci 0000:00:1f.1: reg 24 =
32bit mmio: [0x000000-0x0003ff]
> Jan 29 13:18:39 siduxbox kernel: [    0.175619] pci 0000:00:1f.3: reg 20 =
io port: [0xc00-0xc1f]
> Jan 29 13:18:39 siduxbox kernel: [    0.175666] pci 0000:00:1f.5: reg 10 =
io port: [0xe000-0xe0ff]
> Jan 29 13:18:39 siduxbox kernel: [    0.175673] pci 0000:00:1f.5: reg 14 =
io port: [0xdc00-0xdc3f]
> Jan 29 13:18:39 siduxbox kernel: [    0.175681] pci 0000:00:1f.5: reg 18 =
32bit mmio: [0xdffffa00-0xdffffbff]
> Jan 29 13:18:39 siduxbox kernel: [    0.175689] pci 0000:00:1f.5: reg 1c =
32bit mmio: [0xdffff900-0xdffff9ff]
> Jan 29 13:18:39 siduxbox kernel: [    0.175720] pci 0000:00:1f.5: PME# su=
pported from D0 D3hot D3cold
> Jan 29 13:18:39 siduxbox kernel: [    0.175724] pci 0000:00:1f.5: PME# di=
sabled
> Jan 29 13:18:39 siduxbox kernel: [    0.175766] pci 0000:01:00.0: reg 10 =
32bit mmio: [0xdc000000-0xdcffffff]
> Jan 29 13:18:39 siduxbox kernel: [    0.175772] pci 0000:01:00.0: reg 14 =
32bit mmio pref: [0xd0000000-0xd7ffffff]
> Jan 29 13:18:39 siduxbox kernel: [    0.175779] pci 0000:01:00.0: reg 18 =
32bit mmio pref: [0xdba80000-0xdbafffff]
> Jan 29 13:18:39 siduxbox kernel: [    0.175796] pci 0000:01:00.0: reg 30 =
32bit mmio pref: [0xddde0000-0xdddfffff]
> Jan 29 13:18:39 siduxbox kernel: [    0.175853] pci 0000:00:01.0: bridge =
32bit mmio: [0xdbd00000-0xdddfffff]
> Jan 29 13:18:39 siduxbox kernel: [    0.175858] pci 0000:00:01.0: bridge =
32bit mmio pref: [0xcb900000-0xdbafffff]
> Jan 29 13:18:39 siduxbox kernel: [    0.175898] pci 0000:02:03.0: reg 10 =
io port: [0xcc00-0xccff]
> Jan 29 13:18:39 siduxbox kernel: [    0.175906] pci 0000:02:03.0: reg 14 =
32bit mmio: [0xdfefff00-0xdfefffff]
> Jan 29 13:18:39 siduxbox kernel: [    0.175931] pci 0000:02:03.0: reg 30 =
32bit mmio pref: [0xdfee0000-0xdfeeffff]
> Jan 29 13:18:39 siduxbox kernel: [    0.175951] pci 0000:02:03.0: support=
s D1 D2
> Jan 29 13:18:39 siduxbox kernel: [    0.175954] pci 0000:02:03.0: PME# su=
pported from D1 D2 D3hot D3cold
> Jan 29 13:18:39 siduxbox kernel: [    0.175959] pci 0000:02:03.0: PME# di=
sabled
> Jan 29 13:18:39 siduxbox kernel: [    0.176008] pci 0000:02:05.0: reg 10 =
32bit mmio: [0xde000000-0xdeffffff]
> Jan 29 13:18:39 siduxbox kernel: [    0.176101] pci 0000:00:1e.0: transpa=
rent bridge
> Jan 29 13:18:39 siduxbox kernel: [    0.176106] pci 0000:00:1e.0: bridge =
io port: [0xc000-0xcfff]
> Jan 29 13:18:39 siduxbox kernel: [    0.176111] pci 0000:00:1e.0: bridge =
32bit mmio: [0xdde00000-0xdfefffff]
> Jan 29 13:18:39 siduxbox kernel: [    0.176117] pci 0000:00:1e.0: bridge =
32bit mmio pref: [0xdbb00000-0xdbbfffff]
> Jan 29 13:18:39 siduxbox kernel: [    0.176130] pci_bus 0000:00: on NUMA =
node 0
> Jan 29 13:18:39 siduxbox kernel: [    0.176136] ACPI: PCI Interrupt Routi=
ng Table [\_SB_.PCI0._PRT]
> Jan 29 13:18:39 siduxbox kernel: [    0.176241] ACPI: PCI Interrupt Routi=
ng Table [\_SB_.PCI0.ICHB._PRT]
> Jan 29 13:18:39 siduxbox kernel: [    0.178553] ACPI: PCI Interrupt Link =
[LNKA] (IRQs 3 4 5 6 7 *10 11 12 14 15)
> Jan 29 13:18:39 siduxbox kernel: [    0.178663] ACPI: PCI Interrupt Link =
[LNKB] (IRQs 3 4 5 6 7 10 *11 12 14 15)
> Jan 29 13:18:39 siduxbox kernel: [    0.178772] ACPI: PCI Interrupt Link =
[LNKC] (IRQs 3 4 5 6 7 10 *11 12 14 15)
> Jan 29 13:18:39 siduxbox kernel: [    0.178933] ACPI: PCI Interrupt Link =
[LNKD] (IRQs 3 4 5 6 7 *10 11 12 14 15)
> Jan 29 13:18:39 siduxbox kernel: [    0.179041] ACPI: PCI Interrupt Link =
[LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
> Jan 29 13:18:39 siduxbox kernel: [    0.179151] ACPI: PCI Interrupt Link =
[LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
> Jan 29 13:18:39 siduxbox kernel: [    0.179260] ACPI: PCI Interrupt Link =
[LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
> Jan 29 13:18:39 siduxbox kernel: [    0.179422] ACPI: PCI Interrupt Link =
[LNKH] (IRQs 3 4 5 6 7 10 *11 12 14 15)
> Jan 29 13:18:39 siduxbox kernel: [    0.179553] vgaarb: device added: PCI=
:0000:01:00.0,decodes=3Dio+mem,owns=3Dio+mem,locks=3Dnone
> Jan 29 13:18:39 siduxbox kernel: [    0.179558] vgaarb: loaded
> Jan 29 13:18:39 siduxbox kernel: [    0.179661] PCI: Using ACPI for IRQ r=
outing
> Jan 29 13:18:39 siduxbox kernel: [    0.179854] Switching to clocksource =
tsc
> Jan 29 13:18:39 siduxbox kernel: [    0.179952] pnp: PnP ACPI init
> Jan 29 13:18:39 siduxbox kernel: [    0.179952] ACPI: bus type pnp regist=
ered
> Jan 29 13:18:39 siduxbox kernel: [    0.181362] pnp: PnP ACPI: found 13 d=
evices
> Jan 29 13:18:39 siduxbox kernel: [    0.181365] ACPI: ACPI bus type pnp u=
nregistered
> Jan 29 13:18:39 siduxbox kernel: [    0.181370] PnPBIOS: Disabled by ACPI=
 PNP
> Jan 29 13:18:39 siduxbox kernel: [    0.181386] system 00:01: ioport rang=
e 0x290-0x297 has been reserved
> Jan 29 13:18:39 siduxbox kernel: [    0.181390] system 00:01: ioport rang=
e 0x3f0-0x3f1 has been reserved
> Jan 29 13:18:39 siduxbox kernel: [    0.181394] system 00:01: ioport rang=
e 0x4d0-0x4d1 has been reserved
> Jan 29 13:18:39 siduxbox kernel: [    0.181399] system 00:01: iomem range=
 0xfee00000-0xfeefffff could not be reserved
> Jan 29 13:18:39 siduxbox kernel: [    0.216294] pci 0000:02:03.0: BAR 6: =
address space collision on of device [0xdfee0000-0xdfeeffff]
> Jan 29 13:18:39 siduxbox kernel: [    0.216324] pci 0000:00:01.0: PCI bri=
dge, secondary bus 0000:01
> Jan 29 13:18:39 siduxbox kernel: [    0.216327] pci 0000:00:01.0:   IO wi=
ndow: disabled
> Jan 29 13:18:39 siduxbox kernel: [    0.216333] pci 0000:00:01.0:   MEM w=
indow: 0xdbd00000-0xdddfffff
> Jan 29 13:18:39 siduxbox kernel: [    0.216338] pci 0000:00:01.0:   PREFE=
TCH window: 0xcb900000-0xdbafffff
> Jan 29 13:18:39 siduxbox kernel: [    0.216344] pci 0000:00:1e.0: PCI bri=
dge, secondary bus 0000:02
> Jan 29 13:18:39 siduxbox kernel: [    0.216349] pci 0000:00:1e.0:   IO wi=
ndow: 0xc000-0xcfff
> Jan 29 13:18:39 siduxbox kernel: [    0.216355] pci 0000:00:1e.0:   MEM w=
indow: 0xdde00000-0xdfefffff
> Jan 29 13:18:39 siduxbox kernel: [    0.216360] pci 0000:00:1e.0:   PREFE=
TCH window: 0xdbb00000-0xdbbfffff
> Jan 29 13:18:39 siduxbox kernel: [    0.216378] pci 0000:00:1e.0: setting=
 latency timer to 64
> Jan 29 13:18:39 siduxbox kernel: [    0.216384] pci_bus 0000:00: resource=
 0 io:  [0x00-0xffff]
> Jan 29 13:18:39 siduxbox kernel: [    0.216387] pci_bus 0000:00: resource=
 1 mem: [0x000000-0xffffffff]
> Jan 29 13:18:39 siduxbox kernel: [    0.216391] pci_bus 0000:01: resource=
 1 mem: [0xdbd00000-0xdddfffff]
> Jan 29 13:18:39 siduxbox kernel: [    0.216394] pci_bus 0000:01: resource=
 2 pref mem [0xcb900000-0xdbafffff]
> Jan 29 13:18:39 siduxbox kernel: [    0.216398] pci_bus 0000:02: resource=
 0 io:  [0xc000-0xcfff]
> Jan 29 13:18:39 siduxbox kernel: [    0.216401] pci_bus 0000:02: resource=
 1 mem: [0xdde00000-0xdfefffff]
> Jan 29 13:18:39 siduxbox kernel: [    0.216405] pci_bus 0000:02: resource=
 2 pref mem [0xdbb00000-0xdbbfffff]
> Jan 29 13:18:39 siduxbox kernel: [    0.216408] pci_bus 0000:02: resource=
 3 io:  [0x00-0xffff]
> Jan 29 13:18:39 siduxbox kernel: [    0.216411] pci_bus 0000:02: resource=
 4 mem: [0x000000-0xffffffff]
> Jan 29 13:18:39 siduxbox kernel: [    0.216455] NET: Registered protocol =
family 2
> Jan 29 13:18:39 siduxbox kernel: [    0.216570] IP route cache hash table=
 entries: 32768 (order: 5, 131072 bytes)
> Jan 29 13:18:39 siduxbox kernel: [    0.217060] TCP established hash tabl=
e entries: 131072 (order: 8, 1048576 bytes)
> Jan 29 13:18:39 siduxbox kernel: [    0.218183] TCP bind hash table entri=
es: 65536 (order: 7, 524288 bytes)
> Jan 29 13:18:39 siduxbox kernel: [    0.218929] TCP: Hash tables configur=
ed (established 131072 bind 65536)
> Jan 29 13:18:39 siduxbox kernel: [    0.218934] TCP reno registered
> Jan 29 13:18:39 siduxbox kernel: [    0.219114] NET: Registered protocol =
family 1
> Jan 29 13:18:39 siduxbox kernel: [    0.219242] pci 0000:01:00.0: Boot vi=
deo device
> Jan 29 13:18:39 siduxbox kernel: [    0.219333] Unpacking initramfs...
> Jan 29 13:18:39 siduxbox kernel: [    0.530691] Freeing initrd memory: 91=
33k freed
> Jan 29 13:18:39 siduxbox kernel: [    0.545395] audit: initializing netli=
nk socket (disabled)
> Jan 29 13:18:39 siduxbox kernel: [    0.545420] type=3D2000 audit(1264771=
101.544:1): initialized
> Jan 29 13:18:39 siduxbox kernel: [    0.545742] highmem bounce pool size:=
 64 pages
> Jan 29 13:18:39 siduxbox kernel: [    0.545749] HugeTLB registered 4 MB p=
age size, pre-allocated 0 pages
> Jan 29 13:18:39 siduxbox kernel: [    0.547528] VFS: Disk quotas dquot_6.=
5.2
> Jan 29 13:18:39 siduxbox kernel: [    0.547611] Dquot-cache hash table en=
tries: 1024 (order 0, 4096 bytes)
> Jan 29 13:18:39 siduxbox kernel: [    0.547710] msgmni has been set to 17=
23
> Jan 29 13:18:39 siduxbox kernel: [    0.547973] alg: No test for stdrng (=
krng)
> Jan 29 13:18:39 siduxbox kernel: [    0.548043] Block layer SCSI generic =
(bsg) driver version 0.4 loaded (major 253)
> Jan 29 13:18:39 siduxbox kernel: [    0.548047] io scheduler noop registe=
red
> Jan 29 13:18:39 siduxbox kernel: [    0.548049] io scheduler anticipatory=
 registered
> Jan 29 13:18:39 siduxbox kernel: [    0.548102] io scheduler deadline reg=
istered
> Jan 29 13:18:39 siduxbox kernel: [    0.548189] io scheduler cfq register=
ed (default)
> Jan 29 13:18:39 siduxbox kernel: [    0.548447] vesafb: framebuffer at 0x=
d0000000, mapped to 0xf7c80000, using 3072k, total 65536k
> Jan 29 13:18:39 siduxbox kernel: [    0.548451] vesafb: mode is 1024x768x=
16, linelength=3D2048, pages=3D1
> Jan 29 13:18:39 siduxbox kernel: [    0.548454] vesafb: protected mode in=
terface info at c000:f910
> Jan 29 13:18:39 siduxbox kernel: [    0.548457] vesafb: pmi: set display =
start =3D c00cf955, set palette =3D c00cf9da
> Jan 29 13:18:39 siduxbox kernel: [    0.548460] vesafb: pmi: ports =3D b4=
c3 b503 ba03 c003 c103 c403 c503 c603 c703 c803 c903 cc03 ce03 cf03 d003 d1=
03 d203 d303 d403 d503 da03 ff03=20
> Jan 29 13:18:39 siduxbox kernel: [    0.548482] vesafb: scrolling: redraw
> Jan 29 13:18:39 siduxbox kernel: [    0.548486] vesafb: Truecolor: size=
=3D0:5:6:5, shift=3D0:11:5:0
> Jan 29 13:18:39 siduxbox kernel: [    0.580536] Console: switching to col=
our frame buffer device 128x48
> Jan 29 13:18:39 siduxbox kernel: [    0.612414] fb0: VESA VGA frame buffe=
r device
> Jan 29 13:18:39 siduxbox kernel: [    0.612465] isapnp: Scanning for PnP =
cards...
> Jan 29 13:18:39 siduxbox kernel: [    0.922717] isapnp: No Plug & Play de=
vice found
> Jan 29 13:18:39 siduxbox kernel: [    0.924477] Serial: 8250/16550 driver=
, 4 ports, IRQ sharing enabled
> Jan 29 13:18:39 siduxbox kernel: [    0.924576] serial8250: ttyS0 at I/O =
0x3f8 (irq =3D 4) is a 16550A
> Jan 29 13:18:39 siduxbox kernel: [    0.924667] serial8250: ttyS1 at I/O =
0x2f8 (irq =3D 3) is a 16550A
> Jan 29 13:18:39 siduxbox kernel: [    0.925001] 00:09: ttyS0 at I/O 0x3f8=
 (irq =3D 4) is a 16550A
> Jan 29 13:18:39 siduxbox kernel: [    0.925139] 00:0a: ttyS1 at I/O 0x2f8=
 (irq =3D 3) is a 16550A
> Jan 29 13:18:39 siduxbox kernel: [    0.925307] PNP: PS/2 Controller [PNP=
0303:PS2K] at 0x60,0x64 irq 1
> Jan 29 13:18:39 siduxbox kernel: [    0.925310] PNP: PS/2 appears to have=
 AUX port disabled, if this is incorrect please boot with i8042.nopnp
> Jan 29 13:18:39 siduxbox kernel: [    0.926112] serio: i8042 KBD port at =
0x60,0x64 irq 1
> Jan 29 13:18:39 siduxbox kernel: [    0.926218] mice: PS/2 mouse device c=
ommon for all mice
> Jan 29 13:18:39 siduxbox kernel: [    0.926244] Driver 'rtc_cmos' needs u=
pdating - please use bus_type methods
> Jan 29 13:18:39 siduxbox kernel: [    0.926287] rtc_cmos 00:04: RTC can w=
ake from S4
> Jan 29 13:18:39 siduxbox kernel: [    0.926345] rtc_cmos 00:04: rtc core:=
 registered rtc_cmos as rtc0
> Jan 29 13:18:39 siduxbox kernel: [    0.926368] rtc0: alarms up to one mo=
nth, y3k, 114 bytes nvram
> Jan 29 13:18:39 siduxbox kernel: [    0.926383] cpuidle: using governor l=
adder
> Jan 29 13:18:39 siduxbox kernel: [    0.926386] cpuidle: using governor m=
enu
> Jan 29 13:18:39 siduxbox kernel: [    0.926392] No iBFT detected.
> Jan 29 13:18:39 siduxbox kernel: [    0.926880] TCP cubic registered
> Jan 29 13:18:39 siduxbox kernel: [    0.927032] NET: Registered protocol =
family 10
> Jan 29 13:18:39 siduxbox kernel: [    0.927634] lo: Disabled Privacy Exte=
nsions
> Jan 29 13:18:39 siduxbox kernel: [    0.928089] Mobile IPv6
> Jan 29 13:18:39 siduxbox kernel: [    0.928092] NET: Registered protocol =
family 17
> Jan 29 13:18:39 siduxbox kernel: [    0.928115] Using IPI No-Shortcut mod=
e
> Jan 29 13:18:39 siduxbox kernel: [    0.928221] registered taskstats vers=
ion 1
> Jan 29 13:18:39 siduxbox kernel: [    0.928482] rtc_cmos 00:04: setting s=
ystem clock to 2010-01-29 13:18:23 UTC (1264771103)
> Jan 29 13:18:39 siduxbox kernel: [    0.928549] Freeing unused kernel mem=
ory: 368k freed
> Jan 29 13:18:39 siduxbox kernel: [    0.929094] Write protecting the kern=
el text: 2416k
> Jan 29 13:18:39 siduxbox kernel: [    0.929121] Write protecting the kern=
el read-only data: 872k
> Jan 29 13:18:39 siduxbox kernel: [    0.946088] input: AT Translated Set =
2 keyboard as /devices/platform/i8042/serio0/input/input0
> Jan 29 13:18:39 siduxbox kernel: [    1.278603] input: Power Button as /d=
evices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
> Jan 29 13:18:39 siduxbox kernel: [    1.278632] ACPI: Power Button [PWRB]
> Jan 29 13:18:39 siduxbox kernel: [    1.278874] input: Power Button as /d=
evices/LNXSYSTM:00/LNXPWRBN:00/input/input2
> Jan 29 13:18:39 siduxbox kernel: [    1.278886] ACPI: Power Button [PWRF]
> Jan 29 13:18:39 siduxbox kernel: [    1.279465] usbcore: registered new i=
nterface driver usbfs
> Jan 29 13:18:39 siduxbox kernel: [    1.279504] usbcore: registered new i=
nterface driver hub
> Jan 29 13:18:39 siduxbox kernel: [    1.279553] usbcore: registered new d=
evice driver usb
> Jan 29 13:18:39 siduxbox kernel: [    1.282593] ehci_hcd: USB 2.0 'Enhanc=
ed' Host Controller (EHCI) Driver
> Jan 29 13:18:39 siduxbox kernel: [    1.282668] ehci_hcd 0000:00:1d.7: PC=
I INT D -> GSI 23 (level, low) -> IRQ 23
> Jan 29 13:18:39 siduxbox kernel: [    1.282713] ehci_hcd 0000:00:1d.7: se=
tting latency timer to 64
> Jan 29 13:18:39 siduxbox kernel: [    1.282725] ehci_hcd 0000:00:1d.7: EH=
CI Host Controller
> Jan 29 13:18:39 siduxbox kernel: [    1.282815] ehci_hcd 0000:00:1d.7: ne=
w USB bus registered, assigned bus number 1
> Jan 29 13:18:39 siduxbox kernel: [    1.282895] ehci_hcd 0000:00:1d.7: de=
bug port 1
> Jan 29 13:18:39 siduxbox kernel: [    1.286800] ehci_hcd 0000:00:1d.7: ca=
che line size of 128 is not supported
> Jan 29 13:18:39 siduxbox kernel: [    1.297415] ehci_hcd 0000:00:1d.7: ir=
q 23, io mem 0xdffffc00
> Jan 29 13:18:39 siduxbox kernel: [    1.301330] Linux agpgart interface v=
0.103
> Jan 29 13:18:39 siduxbox kernel: [    1.312033] ehci_hcd 0000:00:1d.7: US=
B 2.0 started, EHCI 1.00
> Jan 29 13:18:39 siduxbox kernel: [    1.312093] usb usb1: New USB device =
found, idVendor=3D1d6b, idProduct=3D0002
> Jan 29 13:18:39 siduxbox kernel: [    1.312098] usb usb1: New USB device =
strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
> Jan 29 13:18:39 siduxbox kernel: [    1.312103] usb usb1: Product: EHCI H=
ost Controller
> Jan 29 13:18:39 siduxbox kernel: [    1.312107] usb usb1: Manufacturer: L=
inux 2.6.32-trunk-686 ehci_hcd
> Jan 29 13:18:39 siduxbox kernel: [    1.312111] usb usb1: SerialNumber: 0=
000:00:1d.7
> Jan 29 13:18:39 siduxbox kernel: [    1.312375] usb usb1: configuration #=
1 chosen from 1 choice
> Jan 29 13:18:39 siduxbox kernel: [    1.312498] hub 1-0:1.0: USB hub foun=
d
> Jan 29 13:18:39 siduxbox kernel: [    1.312514] hub 1-0:1.0: 6 ports dete=
cted
> Jan 29 13:18:39 siduxbox kernel: [    1.314387] Uniform Multi-Platform E-=
IDE driver
> Jan 29 13:18:39 siduxbox kernel: [    1.319922] 8139too Fast Ethernet dri=
ver 0.9.28
> Jan 29 13:18:39 siduxbox kernel: [    1.320214] 8139too 0000:02:03.0: PCI=
 INT A -> GSI 19 (level, low) -> IRQ 19
> Jan 29 13:18:39 siduxbox kernel: [    1.321863] eth0: RealTek RTL8139 at =
0xcc00, 00:c1:26:11:00:f7, IRQ 19
> Jan 29 13:18:39 siduxbox kernel: [    1.322995] Floppy drive(s): fd0 is 1=
.44M
> Jan 29 13:18:39 siduxbox kernel: [    1.325576] piix 0000:00:1f.1: IDE co=
ntroller (0x8086:0x24cb rev 0x02)
> Jan 29 13:18:39 siduxbox kernel: [    1.325617] PIIX_IDE 0000:00:1f.1: PC=
I INT A -> GSI 18 (level, low) -> IRQ 18
> Jan 29 13:18:39 siduxbox kernel: [    1.325670] piix 0000:00:1f.1: not 10=
0% native mode: will probe irqs later
> Jan 29 13:18:39 siduxbox kernel: [    1.325680]     ide0: BM-DMA at 0xfc0=
0-0xfc07
> Jan 29 13:18:39 siduxbox kernel: [    1.325695]     ide1: BM-DMA at 0xfc0=
8-0xfc0f
> Jan 29 13:18:39 siduxbox kernel: [    1.325706] Probing IDE interface ide=
0...
> Jan 29 13:18:39 siduxbox kernel: [    1.334146] 8139cp: 10/100 PCI Ethern=
et driver v1.3 (Mar 22, 2004)
> Jan 29 13:18:39 siduxbox kernel: [    1.340920] FDC 0 is a post-1991 8207=
7
> Jan 29 13:18:39 siduxbox kernel: [    1.395302] uhci_hcd: USB Universal H=
ost Controller Interface driver
> Jan 29 13:18:39 siduxbox kernel: [    1.612162] hda: ST340016A, ATA DISK =
drive
> Jan 29 13:18:39 siduxbox kernel: [    1.624014] usb 1-2: new high speed U=
SB device using ehci_hcd and address 2
> Jan 29 13:18:39 siduxbox kernel: [    1.895204] usb 1-2: New USB device f=
ound, idVendor=3D7392, idProduct=3D7318
> Jan 29 13:18:39 siduxbox kernel: [    1.895208] usb 1-2: New USB device s=
trings: Mfr=3D1, Product=3D2, SerialNumber=3D0
> Jan 29 13:18:39 siduxbox kernel: [    1.895212] usb 1-2: Product: 802.11 =
bg WLAN
> Jan 29 13:18:39 siduxbox kernel: [    1.895214] usb 1-2: Manufacturer: Ra=
link
> Jan 29 13:18:39 siduxbox kernel: [    1.895337] usb 1-2: configuration #1=
 chosen from 1 choice
> Jan 29 13:18:39 siduxbox kernel: [    1.948016] hdb: ST3200827A, ATA DISK=
 drive
> Jan 29 13:18:39 siduxbox kernel: [    1.948085] hda: host max PIO4 wanted=
 PIO255(auto-tune) selected PIO4
> Jan 29 13:18:39 siduxbox kernel: [    1.948333] hda: UDMA/100 mode select=
ed
> Jan 29 13:18:39 siduxbox kernel: [    1.948416] hdb: host max PIO4 wanted=
 PIO255(auto-tune) selected PIO4
> Jan 29 13:18:39 siduxbox kernel: [    1.948563] hdb: UDMA/100 mode select=
ed
> Jan 29 13:18:39 siduxbox kernel: [    1.948762] Probing IDE interface ide=
1...
> Jan 29 13:18:39 siduxbox kernel: [    2.684164] hdc: Optiarc DVD RW AD-71=
70A, ATAPI CD/DVD-ROM drive
> Jan 29 13:18:39 siduxbox kernel: [    3.356065] hdc: host max PIO4 wanted=
 PIO255(auto-tune) selected PIO4
> Jan 29 13:18:39 siduxbox kernel: [    3.356219] hdc: host side 80-wire ca=
ble detection failed, limiting max speed to UDMA33
> Jan 29 13:18:39 siduxbox kernel: [    3.356222] hdc: UDMA/33 mode selecte=
d
> Jan 29 13:18:39 siduxbox kernel: [    3.356395] ide0 at 0x1f0-0x1f7,0x3f6=
 on irq 14
> Jan 29 13:18:39 siduxbox kernel: [    3.381104] ide1 at 0x170-0x177,0x376=
 on irq 15
> Jan 29 13:18:39 siduxbox kernel: [    3.382105] agpgart-intel 0000:00:00.=
0: Intel 830M Chipset
> Jan 29 13:18:39 siduxbox kernel: [    3.388254] agpgart-intel 0000:00:00.=
0: AGP aperture is 128M @ 0xe0000000
> Jan 29 13:18:39 siduxbox kernel: [    3.388439] uhci_hcd 0000:00:1d.0: PC=
I INT A -> GSI 16 (level, low) -> IRQ 16
> Jan 29 13:18:39 siduxbox kernel: [    3.388457] uhci_hcd 0000:00:1d.0: se=
tting latency timer to 64
> Jan 29 13:18:39 siduxbox kernel: [    3.388463] uhci_hcd 0000:00:1d.0: UH=
CI Host Controller
> Jan 29 13:18:39 siduxbox kernel: [    3.388493] uhci_hcd 0000:00:1d.0: ne=
w USB bus registered, assigned bus number 2
> Jan 29 13:18:39 siduxbox kernel: [    3.388550] uhci_hcd 0000:00:1d.0: ir=
q 16, io base 0x0000e400
> Jan 29 13:18:39 siduxbox kernel: [    3.388630] usb usb2: New USB device =
found, idVendor=3D1d6b, idProduct=3D0001
> Jan 29 13:18:39 siduxbox kernel: [    3.388635] usb usb2: New USB device =
strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
> Jan 29 13:18:39 siduxbox kernel: [    3.388640] usb usb2: Product: UHCI H=
ost Controller
> Jan 29 13:18:39 siduxbox kernel: [    3.388644] usb usb2: Manufacturer: L=
inux 2.6.32-trunk-686 uhci_hcd
> Jan 29 13:18:39 siduxbox kernel: [    3.388649] usb usb2: SerialNumber: 0=
000:00:1d.0
> Jan 29 13:18:39 siduxbox kernel: [    3.388829] usb usb2: configuration #=
1 chosen from 1 choice
> Jan 29 13:18:39 siduxbox kernel: [    3.388908] hub 2-0:1.0: USB hub foun=
d
> Jan 29 13:18:39 siduxbox kernel: [    3.388928] hub 2-0:1.0: 2 ports dete=
cted
> Jan 29 13:18:39 siduxbox kernel: [    3.389073] uhci_hcd 0000:00:1d.1: PC=
I INT B -> GSI 19 (level, low) -> IRQ 19
> Jan 29 13:18:39 siduxbox kernel: [    3.389089] uhci_hcd 0000:00:1d.1: se=
tting latency timer to 64
> Jan 29 13:18:39 siduxbox kernel: [    3.389095] uhci_hcd 0000:00:1d.1: UH=
CI Host Controller
> Jan 29 13:18:39 siduxbox kernel: [    3.389117] uhci_hcd 0000:00:1d.1: ne=
w USB bus registered, assigned bus number 3
> Jan 29 13:18:39 siduxbox kernel: [    3.389172] uhci_hcd 0000:00:1d.1: ir=
q 19, io base 0x0000e800
> Jan 29 13:18:39 siduxbox kernel: [    3.389237] usb usb3: New USB device =
found, idVendor=3D1d6b, idProduct=3D0001
> Jan 29 13:18:39 siduxbox kernel: [    3.389243] usb usb3: New USB device =
strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
> Jan 29 13:18:39 siduxbox kernel: [    3.389247] usb usb3: Product: UHCI H=
ost Controller
> Jan 29 13:18:39 siduxbox kernel: [    3.389251] usb usb3: Manufacturer: L=
inux 2.6.32-trunk-686 uhci_hcd
> Jan 29 13:18:39 siduxbox kernel: [    3.389255] usb usb3: SerialNumber: 0=
000:00:1d.1
> Jan 29 13:18:39 siduxbox kernel: [    3.389390] usb usb3: configuration #=
1 chosen from 1 choice
> Jan 29 13:18:39 siduxbox kernel: [    3.389453] hub 3-0:1.0: USB hub foun=
d
> Jan 29 13:18:39 siduxbox kernel: [    3.389470] hub 3-0:1.0: 2 ports dete=
cted
> Jan 29 13:18:39 siduxbox kernel: [    3.389591] uhci_hcd 0000:00:1d.2: PC=
I INT C -> GSI 18 (level, low) -> IRQ 18
> Jan 29 13:18:39 siduxbox kernel: [    3.389606] uhci_hcd 0000:00:1d.2: se=
tting latency timer to 64
> Jan 29 13:18:39 siduxbox kernel: [    3.389612] uhci_hcd 0000:00:1d.2: UH=
CI Host Controller
> Jan 29 13:18:39 siduxbox kernel: [    3.389632] uhci_hcd 0000:00:1d.2: ne=
w USB bus registered, assigned bus number 4
> Jan 29 13:18:39 siduxbox kernel: [    3.389682] uhci_hcd 0000:00:1d.2: ir=
q 18, io base 0x0000ec00
> Jan 29 13:18:39 siduxbox kernel: [    3.389755] usb usb4: New USB device =
found, idVendor=3D1d6b, idProduct=3D0001
> Jan 29 13:18:39 siduxbox kernel: [    3.389760] usb usb4: New USB device =
strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
> Jan 29 13:18:39 siduxbox kernel: [    3.389764] usb usb4: Product: UHCI H=
ost Controller
> Jan 29 13:18:39 siduxbox kernel: [    3.389768] usb usb4: Manufacturer: L=
inux 2.6.32-trunk-686 uhci_hcd
> Jan 29 13:18:39 siduxbox kernel: [    3.389772] usb usb4: SerialNumber: 0=
000:00:1d.2
> Jan 29 13:18:39 siduxbox kernel: [    3.389967] usb usb4: configuration #=
1 chosen from 1 choice
> Jan 29 13:18:39 siduxbox kernel: [    3.390052] hub 4-0:1.0: USB hub foun=
d
> Jan 29 13:18:39 siduxbox kernel: [    3.390076] hub 4-0:1.0: 2 ports dete=
cted
> Jan 29 13:18:39 siduxbox kernel: [    3.416643] SCSI subsystem initialize=
d
> Jan 29 13:18:39 siduxbox kernel: [    3.439094] libata version 3.00 loade=
d.
> Jan 29 13:18:39 siduxbox kernel: [    3.456044] ide-gd driver 1.18
> Jan 29 13:18:39 siduxbox kernel: [    3.456100] hda: max request size: 12=
8KiB
> Jan 29 13:18:39 siduxbox kernel: [    3.456340] hda: 78165360 sectors (40=
020 MB) w/2048KiB Cache, CHS=3D65535/16/63
> Jan 29 13:18:39 siduxbox kernel: [    3.456347] hda: cache flushes not su=
pported
> Jan 29 13:18:39 siduxbox kernel: [    3.456435]  hda:
> Jan 29 13:18:39 siduxbox kernel: [    3.459239] ide-cd driver 5.00
> Jan 29 13:18:39 siduxbox kernel: [    3.468436]  hda1 hda2
> Jan 29 13:18:39 siduxbox kernel: [    3.469451] hdb: max request size: 51=
2KiB
> Jan 29 13:18:39 siduxbox kernel: [    3.515076] hdb: 390721968 sectors (2=
00049 MB) w/8192KiB Cache, CHS=3D24321/255/63
> Jan 29 13:18:39 siduxbox kernel: [    3.539449] hdb: cache flushes suppor=
ted
> Jan 29 13:18:39 siduxbox kernel: [    3.539528]  hdb: hdb1 hdb2 hdb3 hdb4
> Jan 29 13:18:39 siduxbox kernel: [    3.556283] ide-cd: hdc: ATAPI 48X DV=
D-ROM DVD-R/RAM CD-R/RW drive, 2048kB Cache
> Jan 29 13:18:39 siduxbox kernel: [    3.556293] Uniform CD-ROM driver Rev=
ision: 3.20
> Jan 29 13:18:39 siduxbox kernel: [    3.701033] usb 4-1: new low speed US=
B device using uhci_hcd and address 2
> Jan 29 13:18:39 siduxbox kernel: [    3.876624] usb 4-1: New USB device f=
ound, idVendor=3D046d, idProduct=3Dc00e
> Jan 29 13:18:39 siduxbox kernel: [    3.876630] usb 4-1: New USB device s=
trings: Mfr=3D1, Product=3D2, SerialNumber=3D0
> Jan 29 13:18:39 siduxbox kernel: [    3.876633] usb 4-1: Product: USB-PS/=
2 Optical Mouse
> Jan 29 13:18:39 siduxbox kernel: [    3.876636] usb 4-1: Manufacturer: Lo=
gitech
> Jan 29 13:18:39 siduxbox kernel: [    3.876773] usb 4-1: configuration #1=
 chosen from 1 choice
> Jan 29 13:18:39 siduxbox kernel: [    3.894025] usbcore: registered new i=
nterface driver hiddev
> Jan 29 13:18:39 siduxbox kernel: [    3.907057] input: Logitech USB-PS/2 =
Optical Mouse as /devices/pci0000:00/0000:00:1d.2/usb4/4-1/4-1:1.0/input/in=
put3
> Jan 29 13:18:39 siduxbox kernel: [    3.907241] generic-usb 0003:046D:C00=
E.0001: input,hidraw0: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse=
] on usb-0000:00:1d.2-1/input0
> Jan 29 13:18:39 siduxbox kernel: [    3.907281] usbcore: registered new i=
nterface driver usbhid
> Jan 29 13:18:39 siduxbox kernel: [    3.907335] usbhid: v2.6:USB HID core=
 driver
> Jan 29 13:18:39 siduxbox kernel: [    4.147834] device-mapper: uevent: ve=
rsion 1.0.3
> Jan 29 13:18:39 siduxbox kernel: [    4.148437] device-mapper: ioctl: 4.1=
5.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
> Jan 29 13:18:39 siduxbox kernel: [    4.425405] PM: Starting manual resum=
e from disk
> Jan 29 13:18:39 siduxbox kernel: [    4.493355] EXT4-fs (hdb2): mounted f=
ilesystem with ordered data mode
> Jan 29 13:18:39 siduxbox kernel: [    6.545826] udev: starting version 15=
0
> Jan 29 13:18:39 siduxbox kernel: [    8.223120] processor LNXCPU:00: regi=
stered as cooling_device0
> Jan 29 13:18:39 siduxbox kernel: [    8.225421] processor LNXCPU:01: regi=
stered as cooling_device1
> Jan 29 13:18:39 siduxbox kernel: [    8.449763] input: PC Speaker as /dev=
ices/platform/pcspkr/input/input4
> Jan 29 13:18:39 siduxbox kernel: [    8.476739] intel_rng: FWH not detect=
ed
> Jan 29 13:18:39 siduxbox kernel: [    8.523732] pci_hotplug: PCI Hot Plug=
 PCI Core version: 0.5
> Jan 29 13:18:39 siduxbox kernel: [    9.196829] cfg80211: Using static re=
gulatory domain info
> Jan 29 13:18:39 siduxbox kernel: [    9.196835] cfg80211: Regulatory doma=
in: US
> Jan 29 13:18:39 siduxbox kernel: [    9.196838] 	(start_freq - end_freq @=
 bandwidth), (max_antenna_gain, max_eirp)
> Jan 29 13:18:39 siduxbox kernel: [    9.196844] 	(2402000 KHz - 2472000 K=
Hz @ 40000 KHz), (600 mBi, 2700 mBm)
> Jan 29 13:18:39 siduxbox kernel: [    9.196849] 	(5170000 KHz - 5190000 K=
Hz @ 40000 KHz), (600 mBi, 2300 mBm)
> Jan 29 13:18:39 siduxbox kernel: [    9.196854] 	(5190000 KHz - 5210000 K=
Hz @ 40000 KHz), (600 mBi, 2300 mBm)
> Jan 29 13:18:39 siduxbox kernel: [    9.196859] 	(5210000 KHz - 5230000 K=
Hz @ 40000 KHz), (600 mBi, 2300 mBm)
> Jan 29 13:18:39 siduxbox kernel: [    9.196864] 	(5230000 KHz - 5330000 K=
Hz @ 40000 KHz), (600 mBi, 2300 mBm)
> Jan 29 13:18:39 siduxbox kernel: [    9.196869] 	(5735000 KHz - 5835000 K=
Hz @ 40000 KHz), (600 mBi, 3000 mBm)
> Jan 29 13:18:39 siduxbox kernel: [    9.197032] cfg80211: Calling CRDA fo=
r country: US
> Jan 29 13:18:39 siduxbox kernel: [    9.221255] i801_smbus 0000:00:1f.3: =
PCI INT B -> GSI 17 (level, low) -> IRQ 17
> Jan 29 13:18:39 siduxbox kernel: [    9.221263] ACPI: I/O resource 0000:0=
0:1f.3 [0xc00-0xc1f] conflicts with ACPI region SMOV [0xc00-0xc06]
> Jan 29 13:18:39 siduxbox kernel: [    9.247216] ACPI: If an ACPI driver i=
s available for this device, you should use it instead of the native driver
> Jan 29 13:18:39 siduxbox kernel: [    9.247571] shpchp: Standard Hot Plug=
 PCI Controller Driver version: 0.4
> Jan 29 13:18:39 siduxbox kernel: [    9.544461] cfg80211: Regulatory doma=
in changed to country: US
> Jan 29 13:18:39 siduxbox kernel: [    9.544467] 	(start_freq - end_freq @=
 bandwidth), (max_antenna_gain, max_eirp)
> Jan 29 13:18:39 siduxbox kernel: [    9.544471] 	(2402000 KHz - 2472000 K=
Hz @ 40000 KHz), (300 mBi, 2700 mBm)
> Jan 29 13:18:39 siduxbox kernel: [    9.544475] 	(5170000 KHz - 5250000 K=
Hz @ 40000 KHz), (300 mBi, 1700 mBm)
> Jan 29 13:18:39 siduxbox kernel: [    9.544479] 	(5250000 KHz - 5330000 K=
Hz @ 40000 KHz), (300 mBi, 2000 mBm)
> Jan 29 13:18:39 siduxbox kernel: [    9.544482] 	(5490000 KHz - 5710000 K=
Hz @ 40000 KHz), (300 mBi, 2000 mBm)
> Jan 29 13:18:39 siduxbox kernel: [    9.544486] 	(5735000 KHz - 5835000 K=
Hz @ 40000 KHz), (300 mBi, 3000 mBm)
> Jan 29 13:18:39 siduxbox kernel: [    9.627180] gameport: NS558 PnP Gamep=
ort is pnp00:0c/gameport0, io 0x200, speed 903kHz
> Jan 29 13:18:39 siduxbox kernel: [    9.627825] parport_pc 00:0b: reporte=
d by Plug and Play ACPI
> Jan 29 13:18:39 siduxbox kernel: [    9.627938] parport0: PC-style at 0x3=
78 (0x778), irq 7 [PCSPP,TRISTATE,EPP]
> Jan 29 13:18:39 siduxbox kernel: [   10.051788] Linux video capture inter=
face: v2.00
> Jan 29 13:18:39 siduxbox kernel: [   10.254301] cx88/0: cx2388x v4l2 driv=
er version 0.0.7 loaded
> Jan 29 13:18:39 siduxbox kernel: [   10.254374] cx8800 0000:02:05.0: PCI =
INT A -> GSI 17 (level, low) -> IRQ 17
> Jan 29 13:18:39 siduxbox kernel: [   10.255076] cx88[0]: subsystem: 107d:=
6611, board: Leadtek Winfast 2000XP Expert [card=3D5,autodetected], fronten=
d(s): 0
> Jan 29 13:18:39 siduxbox kernel: [   10.255082] cx88[0]: TV tuner type 44=
, Radio tuner type -1
> Jan 29 13:18:39 siduxbox kernel: [   10.302746] Intel ICH 0000:00:1f.5: P=
CI INT B -> GSI 17 (level, low) -> IRQ 17
> Jan 29 13:18:39 siduxbox kernel: [   10.302861] Intel ICH 0000:00:1f.5: s=
etting latency timer to 64
> Jan 29 13:18:39 siduxbox kernel: [   10.430844] All bytes are equal. It i=
s not a TEA5767
> Jan 29 13:18:39 siduxbox kernel: [   10.430939] tuner 0-0060: chip found =
@ 0xc0 (cx88[0])
> Jan 29 13:18:39 siduxbox kernel: [   10.450638] tuner 0-0043: chip found =
@ 0x86 (cx88[0])
> Jan 29 13:18:39 siduxbox kernel: [   10.470882] tda9887 0-0043: creating =
new instance
> Jan 29 13:18:39 siduxbox kernel: [   10.470888] tda9887 0-0043: tda988[5/=
6/7] found
> Jan 29 13:18:39 siduxbox kernel: [   10.482255] phy0: Selected rate contr=
ol algorithm 'minstrel'
> Jan 29 13:18:39 siduxbox kernel: [   10.483405] Registered led device: rt=
73usb-phy0::radio
> Jan 29 13:18:39 siduxbox kernel: [   10.483436] Registered led device: rt=
73usb-phy0::assoc
> Jan 29 13:18:39 siduxbox kernel: [   10.483465] Registered led device: rt=
73usb-phy0::quality
> Jan 29 13:18:39 siduxbox kernel: [   10.483949] usbcore: registered new i=
nterface driver rt73usb
> Jan 29 13:18:39 siduxbox kernel: [   10.522773] cx88[0]: Leadtek Winfast =
2000XP Expert config: tuner=3D38, eeprom[0]=3D0x01
> Jan 29 13:18:39 siduxbox kernel: [   10.614077] tuner-simple 0-0060: crea=
ting new instance
> Jan 29 13:18:39 siduxbox kernel: [   10.614083] tuner-simple 0-0060: type=
 set to 38 (Philips PAL/SECAM multi (FM1216ME MK3))
> Jan 29 13:18:39 siduxbox kernel: [   10.617474] input: cx88 IR (Leadtek W=
infast 2000XP as /devices/pci0000:00/0000:00:1e.0/0000:02:05.0/input/input5
> Jan 29 13:18:39 siduxbox kernel: [   10.617593] cx88[0]/0: found at 0000:=
02:05.0, rev: 5, irq: 17, latency: 32, mmio: 0xde000000
> Jan 29 13:18:39 siduxbox kernel: [   10.617609] IRQ 17/cx88[0]: IRQF_DISA=
BLED is not guaranteed on shared IRQs
> Jan 29 13:18:39 siduxbox kernel: [   10.617699] cx88[0]/0: registered dev=
ice video0 [v4l2]
> Jan 29 13:18:39 siduxbox kernel: [   10.617768] cx88[0]/0: registered dev=
ice vbi0
> Jan 29 13:18:39 siduxbox kernel: [   10.617834] cx88[0]/0: registered dev=
ice radio0
> Jan 29 13:18:39 siduxbox kernel: [   10.632082] intel8x0_measure_ac97_clo=
ck: measured 55587 usecs (2679 samples)
> Jan 29 13:18:39 siduxbox kernel: [   10.632090] intel8x0: clocking to 480=
00
> Jan 29 13:18:39 siduxbox kernel: [   10.677638] cfg80211: Calling CRDA fo=
r country: PL
> Jan 29 13:18:39 siduxbox kernel: [   10.680824] cfg80211: Regulatory doma=
in changed to country: PL
> Jan 29 13:18:39 siduxbox kernel: [   10.680829] 	(start_freq - end_freq @=
 bandwidth), (max_antenna_gain, max_eirp)
> Jan 29 13:18:39 siduxbox kernel: [   10.680835] 	(2402000 KHz - 2482000 K=
Hz @ 40000 KHz), (N/A, 2000 mBm)
> Jan 29 13:18:39 siduxbox kernel: [   10.680840] 	(5170000 KHz - 5250000 K=
Hz @ 40000 KHz), (N/A, 2000 mBm)
> Jan 29 13:18:39 siduxbox kernel: [   10.680845] 	(5250000 KHz - 5330000 K=
Hz @ 40000 KHz), (N/A, 2000 mBm)
> Jan 29 13:18:39 siduxbox kernel: [   10.680850] 	(5490000 KHz - 5710000 K=
Hz @ 40000 KHz), (N/A, 2700 mBm)
> Jan 29 13:18:39 siduxbox kernel: [   11.164966] Adding 1052216k swap on /=
dev/hdb1.  Priority:-1 extents:1 across:1052216k=20
> Jan 29 13:18:39 siduxbox kernel: [   14.278956] FAT: utf8 is not a recomm=
ended IO charset for FAT filesystems, filesystem will be case sensitive!
> Jan 29 13:18:39 siduxbox kernel: [   14.444203] EXT4-fs (hda2): mounted f=
ilesystem with ordered data mode
> Jan 29 13:18:39 siduxbox kernel: [   14.525621] EXT4-fs (hdb3): mounted f=
ilesystem with ordered data mode
> Jan 29 13:18:39 siduxbox kernel: [   14.678738] kjournald starting.  Comm=
it interval 5 seconds
> Jan 29 13:18:39 siduxbox kernel: [   14.678853] EXT3 FS on hdb4, internal=
 journal
> Jan 29 13:18:39 siduxbox kernel: [   14.678859] EXT3-fs: mounted filesyst=
em with ordered data mode.
> Jan 29 13:18:39 siduxbox kernel: [   15.992451] fuse init (API version 7.=
13)
> Jan 29 13:18:40 siduxbox kernel: [   17.858294] lp0: using parport0 (inte=
rrupt-driven).
> Jan 29 13:18:40 siduxbox kernel: [   17.978595] ppdev: user-space paralle=
l port driver
> Jan 29 13:18:43 siduxbox kernel: [   21.117492] Bluetooth: Core ver 2.15
> Jan 29 13:18:43 siduxbox kernel: [   21.118059] NET: Registered protocol =
family 31
> Jan 29 13:18:43 siduxbox kernel: [   21.118062] Bluetooth: HCI device and=
 connection manager initialized
> Jan 29 13:18:43 siduxbox kernel: [   21.118066] Bluetooth: HCI socket lay=
er initialized
> Jan 29 13:18:43 siduxbox kernel: [   21.154257] Bluetooth: L2CAP ver 2.14
> Jan 29 13:18:43 siduxbox kernel: [   21.154262] Bluetooth: L2CAP socket l=
ayer initialized
> Jan 29 13:18:43 siduxbox kernel: [   21.179793] Bluetooth: RFCOMM TTY lay=
er initialized
> Jan 29 13:18:43 siduxbox kernel: [   21.179800] Bluetooth: RFCOMM socket =
layer initialized
> Jan 29 13:18:43 siduxbox kernel: [   21.179803] Bluetooth: RFCOMM ver 1.1=
1
> Jan 29 13:18:43 siduxbox kernel: [   21.226286] Bluetooth: BNEP (Ethernet=
 Emulation) ver 1.3
> Jan 29 13:18:43 siduxbox kernel: [   21.226291] Bluetooth: BNEP filters: =
protocol multicast
> Jan 29 13:18:43 siduxbox kernel: [   21.303490] Bridge firewalling regist=
ered
> Jan 29 13:18:44 siduxbox kernel: [   21.438033] Bluetooth: SCO (Voice Lin=
k) ver 0.6
> Jan 29 13:18:44 siduxbox kernel: [   21.438040] Bluetooth: SCO socket lay=
er initialized
> Jan 29 13:18:45 siduxbox kernel: [   22.621141] rt73usb 1-2:1.0: firmware=
: requesting rt73.bin
> Jan 29 13:18:45 siduxbox kernel: [   22.749871] ADDRCONF(NETDEV_UP): wlan=
0: link is not ready
> Jan 29 13:18:46 siduxbox kernel: [   23.751769] wlan0: deauthenticating f=
rom 00:17:9a:6a:3f:8f by local choice (reason=3D3)
> Jan 29 13:18:46 siduxbox kernel: [   23.754716] wlan0: direct probe to AP=
 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:18:46 siduxbox kernel: [   23.757122] wlan0: direct probe respo=
nded
> Jan 29 13:18:46 siduxbox kernel: [   23.757129] wlan0: authenticate with =
AP 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:18:46 siduxbox kernel: [   23.758958] wlan0: authenticated
> Jan 29 13:18:46 siduxbox kernel: [   23.758985] wlan0: associate with AP =
00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:18:46 siduxbox kernel: [   23.761223] wlan0: RX AssocResp from =
00:17:9a:6a:3f:8f (capab=3D0x431 status=3D0 aid=3D1)
> Jan 29 13:18:46 siduxbox kernel: [   23.761227] wlan0: associated
> Jan 29 13:18:46 siduxbox kernel: [   23.773891] ADDRCONF(NETDEV_CHANGE): =
wlan0: link becomes ready
> Jan 29 13:18:49 siduxbox kernel: [   27.280157] wlan0: disassociated from=
 00:17:9a:6a:3f:8f (Reason: 3)
> Jan 29 13:18:49 siduxbox kernel: [   27.308074] wlan0: deauthenticating f=
rom 00:17:9a:6a:3f:8f by local choice (reason=3D3)
> Jan 29 13:18:50 siduxbox kernel: [   28.377730] wlan0: direct probe to AP=
 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:18:50 siduxbox kernel: [   28.381998] wlan0: direct probe respo=
nded
> Jan 29 13:18:50 siduxbox kernel: [   28.382003] wlan0: authenticate with =
AP 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:18:50 siduxbox kernel: [   28.383597] wlan0: authenticated
> Jan 29 13:18:50 siduxbox kernel: [   28.383620] wlan0: associate with AP =
00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:18:50 siduxbox kernel: [   28.385862] wlan0: RX ReassocResp fro=
m 00:17:9a:6a:3f:8f (capab=3D0x431 status=3D0 aid=3D1)
> Jan 29 13:18:50 siduxbox kernel: [   28.385865] wlan0: associated
> Jan 29 13:18:54 siduxbox kernel: [   32.378432] wlan0: disassociated from=
 00:17:9a:6a:3f:8f (Reason: 3)
> Jan 29 13:18:55 siduxbox kernel: [   32.432292] wlan0: deauthenticating f=
rom 00:17:9a:6a:3f:8f by local choice (reason=3D3)
> Jan 29 13:18:56 siduxbox kernel: [   33.501752] wlan0: direct probe to AP=
 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:18:56 siduxbox kernel: [   33.506022] wlan0: direct probe respo=
nded
> Jan 29 13:18:56 siduxbox kernel: [   33.506028] wlan0: authenticate with =
AP 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:18:56 siduxbox kernel: [   33.507618] wlan0: authenticated
> Jan 29 13:18:56 siduxbox kernel: [   33.507642] wlan0: associate with AP =
00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:18:56 siduxbox kernel: [   33.509885] wlan0: RX ReassocResp fro=
m 00:17:9a:6a:3f:8f (capab=3D0x431 status=3D0 aid=3D1)
> Jan 29 13:18:56 siduxbox kernel: [   33.509888] wlan0: associated
> Jan 29 13:18:56 siduxbox kernel: [   33.896109] CPU0 attaching NULL sched=
-domain.
> Jan 29 13:18:56 siduxbox kernel: [   33.896117] CPU1 attaching NULL sched=
-domain.
> Jan 29 13:18:56 siduxbox kernel: [   33.924065] CPU0 attaching sched-doma=
in:
> Jan 29 13:18:56 siduxbox kernel: [   33.924070]  domain 0: span 0-1 level=
 SIBLING
> Jan 29 13:18:56 siduxbox kernel: [   33.924074]   groups: 0 (cpu_power =
=3D 589) 1 (cpu_power =3D 589)
> Jan 29 13:18:56 siduxbox kernel: [   33.924081]   domain 1: span 0-1 leve=
l MC
> Jan 29 13:18:56 siduxbox kernel: [   33.924084]    groups: 0-1 (cpu_power=
 =3D 1178)
> Jan 29 13:18:56 siduxbox kernel: [   33.924091] CPU1 attaching sched-doma=
in:
> Jan 29 13:18:56 siduxbox kernel: [   33.924093]  domain 0: span 0-1 level=
 SIBLING
> Jan 29 13:18:56 siduxbox kernel: [   33.924096]   groups: 1 (cpu_power =
=3D 589) 0 (cpu_power =3D 589)
> Jan 29 13:18:56 siduxbox kernel: [   33.924103]   domain 1: span 0-1 leve=
l MC
> Jan 29 13:18:56 siduxbox kernel: [   33.924106]    groups: 0-1 (cpu_power=
 =3D 1178)
> Jan 29 13:18:56 siduxbox kernel: [   34.040016] wlan0: no IPv6 routers pr=
esent
> Jan 29 13:19:00 siduxbox kernel: [   37.528877] wlan0: disassociated from=
 00:17:9a:6a:3f:8f (Reason: 3)
> Jan 29 13:19:00 siduxbox kernel: [   37.552106] wlan0: deauthenticating f=
rom 00:17:9a:6a:3f:8f by local choice (reason=3D3)
> Jan 29 13:19:01 siduxbox kernel: [   38.622176] wlan0: direct probe to AP=
 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:19:01 siduxbox kernel: [   38.626588] wlan0: direct probe respo=
nded
> Jan 29 13:19:01 siduxbox kernel: [   38.626597] wlan0: authenticate with =
AP 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:19:01 siduxbox kernel: [   38.628196] wlan0: authenticated
> Jan 29 13:19:01 siduxbox kernel: [   38.628253] wlan0: associate with AP =
00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:19:01 siduxbox kernel: [   38.630440] wlan0: RX ReassocResp fro=
m 00:17:9a:6a:3f:8f (capab=3D0x431 status=3D0 aid=3D1)
> Jan 29 13:19:01 siduxbox kernel: [   38.630446] wlan0: associated
> Jan 29 13:19:05 siduxbox kernel: [   42.627988] wlan0: disassociated from=
 00:17:9a:6a:3f:8f (Reason: 3)
> Jan 29 13:19:05 siduxbox kernel: [   42.652067] wlan0: deauthenticating f=
rom 00:17:9a:6a:3f:8f by local choice (reason=3D3)
> Jan 29 13:19:06 siduxbox kernel: [   43.726322] wlan0: direct probe to AP=
 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:19:06 siduxbox kernel: [   43.730976] wlan0: direct probe respo=
nded
> Jan 29 13:19:06 siduxbox kernel: [   43.730984] wlan0: authenticate with =
AP 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:19:06 siduxbox kernel: [   43.732722] wlan0: authenticated
> Jan 29 13:19:06 siduxbox kernel: [   43.732771] wlan0: associate with AP =
00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:19:06 siduxbox kernel: [   43.734983] wlan0: RX ReassocResp fro=
m 00:17:9a:6a:3f:8f (capab=3D0x431 status=3D0 aid=3D1)
> Jan 29 13:19:06 siduxbox kernel: [   43.734991] wlan0: associated
> Jan 29 13:19:10 siduxbox kernel: [   47.726814] wlan0: disassociated from=
 00:17:9a:6a:3f:8f (Reason: 3)
> Jan 29 13:19:10 siduxbox kernel: [   47.756243] wlan0: deauthenticating f=
rom 00:17:9a:6a:3f:8f by local choice (reason=3D3)
> Jan 29 13:19:11 siduxbox kernel: [   48.833821] wlan0: direct probe to AP=
 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:19:11 siduxbox kernel: [   48.838088] wlan0: direct probe respo=
nded
> Jan 29 13:19:11 siduxbox kernel: [   48.838093] wlan0: authenticate with =
AP 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:19:11 siduxbox kernel: [   48.839687] wlan0: authenticated
> Jan 29 13:19:11 siduxbox kernel: [   48.839710] wlan0: associate with AP =
00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:19:11 siduxbox kernel: [   48.841951] wlan0: RX ReassocResp fro=
m 00:17:9a:6a:3f:8f (capab=3D0x431 status=3D0 aid=3D1)
> Jan 29 13:19:11 siduxbox kernel: [   48.841955] wlan0: associated
> Jan 29 13:19:15 siduxbox kernel: [   52.825869] wlan0: disassociated from=
 00:17:9a:6a:3f:8f (Reason: 3)
> Jan 29 13:19:15 siduxbox kernel: [   52.852027] wlan0: deauthenticating f=
rom 00:17:9a:6a:3f:8f by local choice (reason=3D3)
> Jan 29 13:19:16 siduxbox kernel: [   53.922356] wlan0: direct probe to AP=
 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:19:16 siduxbox kernel: [   53.926488] wlan0: direct probe respo=
nded
> Jan 29 13:19:16 siduxbox kernel: [   53.926493] wlan0: authenticate with =
AP 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:19:16 siduxbox kernel: [   53.928227] wlan0: authenticated
> Jan 29 13:19:16 siduxbox kernel: [   53.928254] wlan0: associate with AP =
00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:19:16 siduxbox kernel: [   53.930471] wlan0: RX ReassocResp fro=
m 00:17:9a:6a:3f:8f (capab=3D0x431 status=3D0 aid=3D1)
> Jan 29 13:19:16 siduxbox kernel: [   53.930475] wlan0: associated
> Jan 29 13:19:20 siduxbox kernel: [   57.925304] wlan0: disassociated from=
 00:17:9a:6a:3f:8f (Reason: 3)
> Jan 29 13:19:20 siduxbox kernel: [   57.956069] wlan0: deauthenticating f=
rom 00:17:9a:6a:3f:8f by local choice (reason=3D3)
> Jan 29 13:19:21 siduxbox kernel: [   59.042025] wlan0: direct probe to AP=
 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:19:21 siduxbox kernel: [   59.046685] wlan0: direct probe respo=
nded
> Jan 29 13:19:21 siduxbox kernel: [   59.046695] wlan0: authenticate with =
AP 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:19:21 siduxbox kernel: [   59.048512] wlan0: authenticated
> Jan 29 13:19:21 siduxbox kernel: [   59.048566] wlan0: associate with AP =
00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:19:21 siduxbox kernel: [   59.050798] wlan0: RX ReassocResp fro=
m 00:17:9a:6a:3f:8f (capab=3D0x431 status=3D0 aid=3D1)
> Jan 29 13:19:21 siduxbox kernel: [   59.050804] wlan0: associated
> Jan 29 13:19:25 siduxbox kernel: [   63.074565] wlan0: disassociated from=
 00:17:9a:6a:3f:8f (Reason: 3)
> Jan 29 13:19:25 siduxbox kernel: [   63.100113] wlan0: deauthenticating f=
rom 00:17:9a:6a:3f:8f by local choice (reason=3D3)
> Jan 29 13:19:26 siduxbox kernel: [   64.181762] wlan0: direct probe to AP=
 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:19:26 siduxbox kernel: [   64.186061] wlan0: direct probe respo=
nded
> Jan 29 13:19:26 siduxbox kernel: [   64.186068] wlan0: authenticate with =
AP 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:19:26 siduxbox kernel: [   64.188821] wlan0: authenticated
> Jan 29 13:19:26 siduxbox kernel: [   64.188864] wlan0: associate with AP =
00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:19:26 siduxbox kernel: [   64.191063] wlan0: RX ReassocResp fro=
m 00:17:9a:6a:3f:8f (capab=3D0x431 status=3D0 aid=3D1)
> Jan 29 13:19:26 siduxbox kernel: [   64.191069] wlan0: associated
> Jan 29 13:19:30 siduxbox kernel: [   68.174099] wlan0: disassociated from=
 00:17:9a:6a:3f:8f (Reason: 3)
> Jan 29 13:19:30 siduxbox kernel: [   68.200026] wlan0: deauthenticating f=
rom 00:17:9a:6a:3f:8f by local choice (reason=3D3)
> Jan 29 13:19:31 siduxbox kernel: [   69.269792] wlan0: direct probe to AP=
 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:19:31 siduxbox kernel: [   69.274057] wlan0: direct probe respo=
nded
> Jan 29 13:19:31 siduxbox kernel: [   69.274062] wlan0: authenticate with =
AP 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:19:31 siduxbox kernel: [   69.275783] wlan0: authenticated
> Jan 29 13:19:31 siduxbox kernel: [   69.275806] wlan0: associate with AP =
00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:19:31 siduxbox kernel: [   69.278047] wlan0: RX ReassocResp fro=
m 00:17:9a:6a:3f:8f (capab=3D0x431 status=3D0 aid=3D1)
> Jan 29 13:19:31 siduxbox kernel: [   69.278051] wlan0: associated
> Jan 29 13:19:35 siduxbox kernel: [   73.273250] wlan0: disassociated from=
 00:17:9a:6a:3f:8f (Reason: 3)
> Jan 29 13:19:35 siduxbox kernel: [   73.300026] wlan0: deauthenticating f=
rom 00:17:9a:6a:3f:8f by local choice (reason=3D3)
> Jan 29 13:19:36 siduxbox kernel: [   74.374071] wlan0: direct probe to AP=
 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:19:36 siduxbox kernel: [   74.378329] wlan0: direct probe respo=
nded
> Jan 29 13:19:36 siduxbox kernel: [   74.378334] wlan0: authenticate with =
AP 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:19:36 siduxbox kernel: [   74.379935] wlan0: authenticated
> Jan 29 13:19:36 siduxbox kernel: [   74.379958] wlan0: associate with AP =
00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:19:36 siduxbox kernel: [   74.382199] wlan0: RX ReassocResp fro=
m 00:17:9a:6a:3f:8f (capab=3D0x431 status=3D0 aid=3D1)
> Jan 29 13:19:36 siduxbox kernel: [   74.382203] wlan0: associated
> Jan 29 13:19:40 siduxbox kernel: [   77.425243] CPU0 attaching NULL sched=
-domain.
> Jan 29 13:19:40 siduxbox kernel: [   77.425252] CPU1 attaching NULL sched=
-domain.
> Jan 29 13:19:40 siduxbox kernel: [   77.453496] CPU0 attaching sched-doma=
in:
> Jan 29 13:19:40 siduxbox kernel: [   77.453501]  domain 0: span 0-1 level=
 SIBLING
> Jan 29 13:19:40 siduxbox kernel: [   77.453505]   groups: 0 (cpu_power =
=3D 589) 1 (cpu_power =3D 589)
> Jan 29 13:19:40 siduxbox kernel: [   77.453513]   domain 1: span 0-1 leve=
l MC
> Jan 29 13:19:40 siduxbox kernel: [   77.453516]    groups: 0-1 (cpu_power=
 =3D 1178)
> Jan 29 13:19:40 siduxbox kernel: [   77.453523] CPU1 attaching sched-doma=
in:
> Jan 29 13:19:40 siduxbox kernel: [   77.453525]  domain 0: span 0-1 level=
 SIBLING
> Jan 29 13:19:40 siduxbox kernel: [   77.453529]   groups: 1 (cpu_power =
=3D 589) 0 (cpu_power =3D 589)
> Jan 29 13:19:40 siduxbox kernel: [   77.453536]   domain 1: span 0-1 leve=
l MC
> Jan 29 13:19:40 siduxbox kernel: [   77.453539]    groups: 0-1 (cpu_power=
 =3D 1178)
> Jan 29 13:19:40 siduxbox kernel: [   78.373430] wlan0: disassociated from=
 00:17:9a:6a:3f:8f (Reason: 3)
> Jan 29 13:19:40 siduxbox kernel: [   78.404040] wlan0: deauthenticating f=
rom 00:17:9a:6a:3f:8f by local choice (reason=3D3)
> Jan 29 13:19:42 siduxbox kernel: [   79.495340] wlan0: direct probe to AP=
 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:19:42 siduxbox kernel: [   79.499598] wlan0: direct probe respo=
nded
> Jan 29 13:19:42 siduxbox kernel: [   79.499603] wlan0: authenticate with =
AP 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:19:42 siduxbox kernel: [   79.501219] wlan0: authenticated
> Jan 29 13:19:42 siduxbox kernel: [   79.501246] wlan0: associate with AP =
00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:19:42 siduxbox kernel: [   79.503458] wlan0: RX ReassocResp fro=
m 00:17:9a:6a:3f:8f (capab=3D0x431 status=3D0 aid=3D1)
> Jan 29 13:19:42 siduxbox kernel: [   79.503461] wlan0: associated
> Jan 29 13:19:46 siduxbox kernel: [   83.522283] wlan0: disassociated from=
 00:17:9a:6a:3f:8f (Reason: 3)
> Jan 29 13:19:46 siduxbox kernel: [   83.552027] wlan0: deauthenticating f=
rom 00:17:9a:6a:3f:8f by local choice (reason=3D3)
> Jan 29 13:19:47 siduxbox kernel: [   84.649978] wlan0: direct probe to AP=
 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:19:47 siduxbox kernel: [   84.654261] wlan0: direct probe respo=
nded
> Jan 29 13:19:47 siduxbox kernel: [   84.654267] wlan0: authenticate with =
AP 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:19:47 siduxbox kernel: [   84.655933] wlan0: authenticated
> Jan 29 13:19:47 siduxbox kernel: [   84.655984] wlan0: associate with AP =
00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:19:47 siduxbox kernel: [   84.658140] wlan0: RX ReassocResp fro=
m 00:17:9a:6a:3f:8f (capab=3D0x431 status=3D0 aid=3D1)
> Jan 29 13:19:47 siduxbox kernel: [   84.658145] wlan0: associated
> Jan 29 13:19:51 siduxbox kernel: [   88.671396] wlan0: disassociated from=
 00:17:9a:6a:3f:8f (Reason: 3)
> Jan 29 13:19:51 siduxbox kernel: [   88.696046] wlan0: deauthenticating f=
rom 00:17:9a:6a:3f:8f by local choice (reason=3D3)
> Jan 29 13:19:52 siduxbox kernel: [   89.774124] wlan0: direct probe to AP=
 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:19:52 siduxbox kernel: [   89.778385] wlan0: direct probe respo=
nded
> Jan 29 13:19:52 siduxbox kernel: [   89.778390] wlan0: authenticate with =
AP 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:19:52 siduxbox kernel: [   89.779987] wlan0: authenticated
> Jan 29 13:19:52 siduxbox kernel: [   89.780037] wlan0: associate with AP =
00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:19:52 siduxbox kernel: [   89.782262] wlan0: RX ReassocResp fro=
m 00:17:9a:6a:3f:8f (capab=3D0x431 status=3D0 aid=3D1)
> Jan 29 13:19:52 siduxbox kernel: [   89.782266] wlan0: associated
> Jan 29 13:19:56 siduxbox kernel: [   93.770589] wlan0: disassociated from=
 00:17:9a:6a:3f:8f (Reason: 3)
> Jan 29 13:19:56 siduxbox kernel: [   93.800031] wlan0: deauthenticating f=
rom 00:17:9a:6a:3f:8f by local choice (reason=3D3)
> Jan 29 13:19:57 siduxbox kernel: [   94.869773] wlan0: direct probe to AP=
 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:19:57 siduxbox kernel: [   94.874049] wlan0: direct probe respo=
nded
> Jan 29 13:19:57 siduxbox kernel: [   94.874055] wlan0: authenticate with =
AP 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:19:57 siduxbox kernel: [   94.875641] wlan0: authenticated
> Jan 29 13:19:57 siduxbox kernel: [   94.875666] wlan0: associate with AP =
00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:19:57 siduxbox kernel: [   94.877919] wlan0: RX ReassocResp fro=
m 00:17:9a:6a:3f:8f (capab=3D0x431 status=3D0 aid=3D1)
> Jan 29 13:19:57 siduxbox kernel: [   94.877923] wlan0: associated
> Jan 29 13:20:01 siduxbox kernel: [   98.870095] wlan0: disassociated from=
 00:17:9a:6a:3f:8f (Reason: 3)
> Jan 29 13:20:01 siduxbox kernel: [   98.896027] wlan0: deauthenticating f=
rom 00:17:9a:6a:3f:8f by local choice (reason=3D3)
> Jan 29 13:20:02 siduxbox kernel: [   99.969802] wlan0: direct probe to AP=
 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:20:02 siduxbox kernel: [   99.974076] wlan0: direct probe respo=
nded
> Jan 29 13:20:02 siduxbox kernel: [   99.974082] wlan0: authenticate with =
AP 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:20:02 siduxbox kernel: [   99.975667] wlan0: authenticated
> Jan 29 13:20:02 siduxbox kernel: [   99.975691] wlan0: associate with AP =
00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:20:02 siduxbox kernel: [   99.977943] wlan0: RX ReassocResp fro=
m 00:17:9a:6a:3f:8f (capab=3D0x431 status=3D0 aid=3D1)
> Jan 29 13:20:02 siduxbox kernel: [   99.977947] wlan0: associated
> Jan 29 13:20:06 siduxbox kernel: [  103.969940] wlan0: disassociated from=
 00:17:9a:6a:3f:8f (Reason: 3)
> Jan 29 13:20:06 siduxbox kernel: [  103.996088] wlan0: deauthenticating f=
rom 00:17:9a:6a:3f:8f by local choice (reason=3D3)
> Jan 29 13:20:07 siduxbox kernel: [  105.069829] wlan0: direct probe to AP=
 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:20:07 siduxbox kernel: [  105.074107] wlan0: direct probe respo=
nded
> Jan 29 13:20:07 siduxbox kernel: [  105.074113] wlan0: authenticate with =
AP 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:20:07 siduxbox kernel: [  105.075726] wlan0: authenticated
> Jan 29 13:20:07 siduxbox kernel: [  105.075758] wlan0: associate with AP =
00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:20:07 siduxbox kernel: [  105.077978] wlan0: RX ReassocResp fro=
m 00:17:9a:6a:3f:8f (capab=3D0x431 status=3D0 aid=3D1)
> Jan 29 13:20:07 siduxbox kernel: [  105.077983] wlan0: associated
> Jan 29 13:20:11 siduxbox kernel: [  109.069404] wlan0: disassociated from=
 00:17:9a:6a:3f:8f (Reason: 3)
> Jan 29 13:20:11 siduxbox kernel: [  109.096029] wlan0: deauthenticating f=
rom 00:17:9a:6a:3f:8f by local choice (reason=3D3)
> Jan 29 13:20:12 siduxbox kernel: [  110.166855] wlan0: direct probe to AP=
 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:20:12 siduxbox kernel: [  110.171115] wlan0: direct probe respo=
nded
> Jan 29 13:20:12 siduxbox kernel: [  110.171121] wlan0: authenticate with =
AP 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:20:12 siduxbox kernel: [  110.172744] wlan0: authenticated
> Jan 29 13:20:12 siduxbox kernel: [  110.172775] wlan0: associate with AP =
00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:20:12 siduxbox kernel: [  110.174973] wlan0: RX ReassocResp fro=
m 00:17:9a:6a:3f:8f (capab=3D0x431 status=3D0 aid=3D1)
> Jan 29 13:20:12 siduxbox kernel: [  110.174976] wlan0: associated
> Jan 29 13:20:16 siduxbox kernel: [  114.168553] wlan0: disassociated from=
 00:17:9a:6a:3f:8f (Reason: 3)
> Jan 29 13:20:16 siduxbox kernel: [  114.196024] wlan0: deauthenticating f=
rom 00:17:9a:6a:3f:8f by local choice (reason=3D3)
> Jan 29 13:20:17 siduxbox kernel: [  115.273876] wlan0: direct probe to AP=
 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:20:17 siduxbox kernel: [  115.278154] wlan0: direct probe respo=
nded
> Jan 29 13:20:17 siduxbox kernel: [  115.278160] wlan0: authenticate with =
AP 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:20:17 siduxbox kernel: [  115.280885] wlan0: authenticated
> Jan 29 13:20:17 siduxbox kernel: [  115.280914] wlan0: associate with AP =
00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:20:17 siduxbox kernel: [  115.283119] wlan0: RX ReassocResp fro=
m 00:17:9a:6a:3f:8f (capab=3D0x431 status=3D0 aid=3D1)
> Jan 29 13:20:17 siduxbox kernel: [  115.283123] wlan0: associated
> Jan 29 13:20:21 siduxbox kernel: [  119.267447] wlan0: disassociated from=
 00:17:9a:6a:3f:8f (Reason: 3)
> Jan 29 13:20:21 siduxbox kernel: [  119.292025] wlan0: deauthenticating f=
rom 00:17:9a:6a:3f:8f by local choice (reason=3D3)
> Jan 29 13:20:22 siduxbox kernel: [  120.361782] wlan0: direct probe to AP=
 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:20:22 siduxbox kernel: [  120.365947] wlan0: direct probe respo=
nded
> Jan 29 13:20:22 siduxbox kernel: [  120.365953] wlan0: authenticate with =
AP 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:20:22 siduxbox kernel: [  120.369471] wlan0: authenticated
> Jan 29 13:20:22 siduxbox kernel: [  120.369502] wlan0: associate with AP =
00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:20:22 siduxbox kernel: [  120.371651] wlan0: RX ReassocResp fro=
m 00:17:9a:6a:3f:8f (capab=3D0x431 status=3D0 aid=3D1)
> Jan 29 13:20:22 siduxbox kernel: [  120.371655] wlan0: associated
> Jan 29 13:20:26 siduxbox kernel: [  124.366612] wlan0: disassociated from=
 00:17:9a:6a:3f:8f (Reason: 3)
> Jan 29 13:20:26 siduxbox kernel: [  124.392026] wlan0: deauthenticating f=
rom 00:17:9a:6a:3f:8f by local choice (reason=3D3)
> Jan 29 13:20:28 siduxbox kernel: [  125.466557] wlan0: direct probe to AP=
 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:20:28 siduxbox kernel: [  125.470692] wlan0: direct probe respo=
nded
> Jan 29 13:20:28 siduxbox kernel: [  125.470699] wlan0: authenticate with =
AP 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:20:28 siduxbox kernel: [  125.472458] wlan0: authenticated
> Jan 29 13:20:28 siduxbox kernel: [  125.472487] wlan0: associate with AP =
00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:20:28 siduxbox kernel: [  125.474675] wlan0: RX ReassocResp fro=
m 00:17:9a:6a:3f:8f (capab=3D0x431 status=3D0 aid=3D1)
> Jan 29 13:20:28 siduxbox kernel: [  125.474678] wlan0: associated
> Jan 29 13:20:32 siduxbox kernel: [  129.466134] wlan0: disassociated from=
 00:17:9a:6a:3f:8f (Reason: 3)
> Jan 29 13:20:32 siduxbox kernel: [  129.492049] wlan0: deauthenticating f=
rom 00:17:9a:6a:3f:8f by local choice (reason=3D3)
> Jan 29 13:20:33 siduxbox kernel: [  130.561834] wlan0: direct probe to AP=
 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:20:33 siduxbox kernel: [  130.566122] wlan0: direct probe respo=
nded
> Jan 29 13:20:33 siduxbox kernel: [  130.566129] wlan0: authenticate with =
AP 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:20:33 siduxbox kernel: [  130.567699] wlan0: authenticated
> Jan 29 13:20:33 siduxbox kernel: [  130.567724] wlan0: associate with AP =
00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:20:33 siduxbox kernel: [  130.569981] wlan0: RX ReassocResp fro=
m 00:17:9a:6a:3f:8f (capab=3D0x431 status=3D0 aid=3D1)
> Jan 29 13:20:33 siduxbox kernel: [  130.569985] wlan0: associated
> Jan 29 13:20:37 siduxbox kernel: [  134.565384] wlan0: disassociated from=
 00:17:9a:6a:3f:8f (Reason: 3)
> Jan 29 13:20:37 siduxbox kernel: [  134.588093] wlan0: deauthenticating f=
rom 00:17:9a:6a:3f:8f by local choice (reason=3D3)
> Jan 29 13:20:38 siduxbox kernel: [  135.671249] wlan0: direct probe to AP=
 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:20:38 siduxbox kernel: [  135.675671] wlan0: direct probe respo=
nded
> Jan 29 13:20:38 siduxbox kernel: [  135.675679] wlan0: authenticate with =
AP 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:20:38 siduxbox kernel: [  135.677340] wlan0: authenticated
> Jan 29 13:20:38 siduxbox kernel: [  135.677380] wlan0: associate with AP =
00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:20:38 siduxbox kernel: [  135.679553] wlan0: RX ReassocResp fro=
m 00:17:9a:6a:3f:8f (capab=3D0x431 status=3D0 aid=3D1)
> Jan 29 13:20:38 siduxbox kernel: [  135.679560] wlan0: associated
> Jan 29 13:20:42 siduxbox kernel: [  139.664797] wlan0: disassociated from=
 00:17:9a:6a:3f:8f (Reason: 3)
> Jan 29 13:20:42 siduxbox kernel: [  139.692027] wlan0: deauthenticating f=
rom 00:17:9a:6a:3f:8f by local choice (reason=3D3)
> Jan 29 13:20:43 siduxbox kernel: [  140.777752] wlan0: direct probe to AP=
 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:20:43 siduxbox kernel: [  140.782035] wlan0: direct probe respo=
nded
> Jan 29 13:20:43 siduxbox kernel: [  140.782041] wlan0: authenticate with =
AP 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:20:43 siduxbox kernel: [  140.783621] wlan0: authenticated
> Jan 29 13:20:43 siduxbox kernel: [  140.783645] wlan0: associate with AP =
00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:20:43 siduxbox kernel: [  140.785901] wlan0: RX ReassocResp fro=
m 00:17:9a:6a:3f:8f (capab=3D0x431 status=3D0 aid=3D1)
> Jan 29 13:20:43 siduxbox kernel: [  140.785906] wlan0: associated
> Jan 29 13:20:47 siduxbox kernel: [  144.814436] wlan0: disassociated from=
 00:17:9a:6a:3f:8f (Reason: 3)
> Jan 29 13:20:47 siduxbox kernel: [  144.840039] wlan0: deauthenticating f=
rom 00:17:9a:6a:3f:8f by local choice (reason=3D3)
> Jan 29 13:20:48 siduxbox kernel: [  145.921771] wlan0: direct probe to AP=
 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:20:48 siduxbox kernel: [  145.926049] wlan0: direct probe respo=
nded
> Jan 29 13:20:48 siduxbox kernel: [  145.926055] wlan0: authenticate with =
AP 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:20:48 siduxbox kernel: [  145.927637] wlan0: authenticated
> Jan 29 13:20:48 siduxbox kernel: [  145.927661] wlan0: associate with AP =
00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:20:48 siduxbox kernel: [  145.929922] wlan0: RX ReassocResp fro=
m 00:17:9a:6a:3f:8f (capab=3D0x431 status=3D0 aid=3D1)
> Jan 29 13:20:48 siduxbox kernel: [  145.929926] wlan0: associated
> Jan 29 13:20:52 siduxbox kernel: [  149.913629] wlan0: disassociated from=
 00:17:9a:6a:3f:8f (Reason: 3)
> Jan 29 13:20:52 siduxbox kernel: [  149.940083] wlan0: deauthenticating f=
rom 00:17:9a:6a:3f:8f by local choice (reason=3D3)
> Jan 29 13:20:53 siduxbox kernel: [  151.029933] wlan0: direct probe to AP=
 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:20:53 siduxbox kernel: [  151.034254] wlan0: direct probe respo=
nded
> Jan 29 13:20:53 siduxbox kernel: [  151.034262] wlan0: authenticate with =
AP 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:20:53 siduxbox kernel: [  151.035848] wlan0: authenticated
> Jan 29 13:20:53 siduxbox kernel: [  151.035882] wlan0: associate with AP =
00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:20:53 siduxbox kernel: [  151.038261] wlan0: RX ReassocResp fro=
m 00:17:9a:6a:3f:8f (capab=3D0x431 status=3D0 aid=3D1)
> Jan 29 13:20:53 siduxbox kernel: [  151.038270] wlan0: associated
> Jan 29 13:20:57 siduxbox kernel: [  155.063162] wlan0: disassociated from=
 00:17:9a:6a:3f:8f (Reason: 3)
> Jan 29 13:20:57 siduxbox kernel: [  155.108033] wlan0: deauthenticating f=
rom 00:17:9a:6a:3f:8f by local choice (reason=3D3)
> Jan 29 13:20:58 siduxbox kernel: [  156.177807] wlan0: direct probe to AP=
 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:20:58 siduxbox kernel: [  156.182087] wlan0: direct probe respo=
nded
> Jan 29 13:20:58 siduxbox kernel: [  156.182094] wlan0: authenticate with =
AP 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:20:58 siduxbox kernel: [  156.183676] wlan0: authenticated
> Jan 29 13:20:58 siduxbox kernel: [  156.183702] wlan0: associate with AP =
00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:20:58 siduxbox kernel: [  156.185958] wlan0: RX ReassocResp fro=
m 00:17:9a:6a:3f:8f (capab=3D0x431 status=3D0 aid=3D1)
> Jan 29 13:20:58 siduxbox kernel: [  156.185963] wlan0: associated
> Jan 29 13:21:02 siduxbox kernel: [  160.212309] wlan0: disassociated from=
 00:17:9a:6a:3f:8f (Reason: 3)
> Jan 29 13:21:02 siduxbox kernel: [  160.236059] wlan0: deauthenticating f=
rom 00:17:9a:6a:3f:8f by local choice (reason=3D3)
> Jan 29 13:21:03 siduxbox kernel: [  161.309703] wlan0: direct probe to AP=
 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:21:03 siduxbox kernel: [  161.313986] wlan0: direct probe respo=
nded
> Jan 29 13:21:03 siduxbox kernel: [  161.313991] wlan0: authenticate with =
AP 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:21:03 siduxbox kernel: [  161.315568] wlan0: authenticated
> Jan 29 13:21:03 siduxbox kernel: [  161.315594] wlan0: associate with AP =
00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:21:03 siduxbox kernel: [  161.317867] wlan0: RX ReassocResp fro=
m 00:17:9a:6a:3f:8f (capab=3D0x431 status=3D0 aid=3D1)
> Jan 29 13:21:03 siduxbox kernel: [  161.317872] wlan0: associated
> Jan 29 13:21:07 siduxbox kernel: [  165.311779] wlan0: disassociated from=
 00:17:9a:6a:3f:8f (Reason: 3)
> Jan 29 13:21:07 siduxbox kernel: [  165.336038] wlan0: deauthenticating f=
rom 00:17:9a:6a:3f:8f by local choice (reason=3D3)
> Jan 29 13:21:08 siduxbox kernel: [  166.421766] wlan0: direct probe to AP=
 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:21:08 siduxbox kernel: [  166.426347] wlan0: direct probe respo=
nded
> Jan 29 13:21:08 siduxbox kernel: [  166.426367] wlan0: authenticate with =
AP 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:21:08 siduxbox kernel: [  166.427909] wlan0: authenticated
> Jan 29 13:21:08 siduxbox kernel: [  166.428057] wlan0: associate with AP =
00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:21:09 siduxbox kernel: [  166.430276] wlan0: RX ReassocResp fro=
m 00:17:9a:6a:3f:8f (capab=3D0x431 status=3D0 aid=3D1)
> Jan 29 13:21:09 siduxbox kernel: [  166.430281] wlan0: associated
> Jan 29 13:21:13 siduxbox kernel: [  170.460914] wlan0: disassociated from=
 00:17:9a:6a:3f:8f (Reason: 3)
> Jan 29 13:21:13 siduxbox kernel: [  170.484214] wlan0: deauthenticating f=
rom 00:17:9a:6a:3f:8f by local choice (reason=3D3)
> Jan 29 13:21:14 siduxbox kernel: [  171.561743] wlan0: direct probe to AP=
 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:21:14 siduxbox kernel: [  171.565913] wlan0: direct probe respo=
nded
> Jan 29 13:21:14 siduxbox kernel: [  171.565919] wlan0: authenticate with =
AP 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:21:14 siduxbox kernel: [  171.567609] wlan0: authenticated
> Jan 29 13:21:14 siduxbox kernel: [  171.567634] wlan0: associate with AP =
00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:21:14 siduxbox kernel: [  171.570016] wlan0: RX ReassocResp fro=
m 00:17:9a:6a:3f:8f (capab=3D0x431 status=3D0 aid=3D1)
> Jan 29 13:21:14 siduxbox kernel: [  171.570021] wlan0: associated
> Jan 29 13:21:18 siduxbox kernel: [  175.560069] wlan0: disassociated from=
 00:17:9a:6a:3f:8f (Reason: 3)
> Jan 29 13:21:18 siduxbox kernel: [  175.588051] wlan0: deauthenticating f=
rom 00:17:9a:6a:3f:8f by local choice (reason=3D3)
> Jan 29 13:21:19 siduxbox kernel: [  176.665767] wlan0: direct probe to AP=
 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:21:19 siduxbox kernel: [  176.669921] wlan0: direct probe respo=
nded
> Jan 29 13:21:19 siduxbox kernel: [  176.669927] wlan0: authenticate with =
AP 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:21:19 siduxbox kernel: [  176.671633] wlan0: authenticated
> Jan 29 13:21:19 siduxbox kernel: [  176.671658] wlan0: associate with AP =
00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:21:19 siduxbox kernel: [  176.673913] wlan0: RX ReassocResp fro=
m 00:17:9a:6a:3f:8f (capab=3D0x431 status=3D0 aid=3D1)
> Jan 29 13:21:19 siduxbox kernel: [  176.673917] wlan0: associated
> Jan 29 13:21:23 siduxbox kernel: [  180.659598] wlan0: disassociated from=
 00:17:9a:6a:3f:8f (Reason: 3)
> Jan 29 13:21:23 siduxbox kernel: [  180.700067] wlan0: deauthenticating f=
rom 00:17:9a:6a:3f:8f by local choice (reason=3D3)
> Jan 29 13:21:24 siduxbox kernel: [  181.779789] wlan0: direct probe to AP=
 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:21:24 siduxbox kernel: [  181.784427] wlan0: direct probe respo=
nded
> Jan 29 13:21:24 siduxbox kernel: [  181.784432] wlan0: authenticate with =
AP 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:21:24 siduxbox kernel: [  181.786031] wlan0: authenticated
> Jan 29 13:21:24 siduxbox kernel: [  181.786053] wlan0: associate with AP =
00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:21:24 siduxbox kernel: [  181.788669] wlan0: RX ReassocResp fro=
m 00:17:9a:6a:3f:8f (capab=3D0x431 status=3D0 aid=3D1)
> Jan 29 13:21:24 siduxbox kernel: [  181.788680] wlan0: associated
> Jan 29 13:21:28 siduxbox kernel: [  185.808742] wlan0: disassociated from=
 00:17:9a:6a:3f:8f (Reason: 3)
> Jan 29 13:21:28 siduxbox kernel: [  185.836031] wlan0: deauthenticating f=
rom 00:17:9a:6a:3f:8f by local choice (reason=3D3)
> Jan 29 13:21:29 siduxbox kernel: [  186.905811] wlan0: direct probe to AP=
 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:21:29 siduxbox kernel: [  186.910085] wlan0: direct probe respo=
nded
> Jan 29 13:21:29 siduxbox kernel: [  186.910091] wlan0: authenticate with =
AP 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:21:29 siduxbox kernel: [  186.911675] wlan0: authenticated
> Jan 29 13:21:29 siduxbox kernel: [  186.911700] wlan0: associate with AP =
00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:21:29 siduxbox kernel: [  186.913958] wlan0: RX ReassocResp fro=
m 00:17:9a:6a:3f:8f (capab=3D0x431 status=3D0 aid=3D1)
> Jan 29 13:21:29 siduxbox kernel: [  186.913962] wlan0: associated
> Jan 29 13:21:33 siduxbox kernel: [  190.908516] wlan0: disassociated from=
 00:17:9a:6a:3f:8f (Reason: 3)
> Jan 29 13:21:33 siduxbox kernel: [  190.936024] wlan0: deauthenticating f=
rom 00:17:9a:6a:3f:8f by local choice (reason=3D3)
> Jan 29 13:21:34 siduxbox kernel: [  192.015348] wlan0: direct probe to AP=
 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:21:34 siduxbox kernel: [  192.019729] wlan0: direct probe respo=
nded
> Jan 29 13:21:34 siduxbox kernel: [  192.019736] wlan0: authenticate with =
AP 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:21:34 siduxbox kernel: [  192.021361] wlan0: authenticated
> Jan 29 13:21:34 siduxbox kernel: [  192.021393] wlan0: associate with AP =
00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:21:34 siduxbox kernel: [  192.023590] wlan0: RX ReassocResp fro=
m 00:17:9a:6a:3f:8f (capab=3D0x431 status=3D0 aid=3D1)
> Jan 29 13:21:34 siduxbox kernel: [  192.023594] wlan0: associated
> Jan 29 13:21:38 siduxbox kernel: [  196.007435] wlan0: disassociated from=
 00:17:9a:6a:3f:8f (Reason: 3)
> Jan 29 13:21:38 siduxbox kernel: [  196.032027] wlan0: deauthenticating f=
rom 00:17:9a:6a:3f:8f by local choice (reason=3D3)
> Jan 29 13:21:39 siduxbox kernel: [  197.110488] wlan0: direct probe to AP=
 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:21:39 siduxbox kernel: [  197.114873] wlan0: direct probe respo=
nded
> Jan 29 13:21:39 siduxbox kernel: [  197.114879] wlan0: authenticate with =
AP 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:21:39 siduxbox kernel: [  197.116502] wlan0: authenticated
> Jan 29 13:21:39 siduxbox kernel: [  197.116532] wlan0: associate with AP =
00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:21:39 siduxbox kernel: [  197.118733] wlan0: RX ReassocResp fro=
m 00:17:9a:6a:3f:8f (capab=3D0x431 status=3D0 aid=3D1)
> Jan 29 13:21:39 siduxbox kernel: [  197.118736] wlan0: associated
> Jan 29 13:21:43 siduxbox kernel: [  201.106917] wlan0: disassociated from=
 00:17:9a:6a:3f:8f (Reason: 3)
> Jan 29 13:21:43 siduxbox kernel: [  201.132027] wlan0: deauthenticating f=
rom 00:17:9a:6a:3f:8f by local choice (reason=3D3)
> Jan 29 13:21:44 siduxbox kernel: [  202.201791] wlan0: direct probe to AP=
 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:21:44 siduxbox kernel: [  202.206166] wlan0: direct probe respo=
nded
> Jan 29 13:21:44 siduxbox kernel: [  202.206172] wlan0: authenticate with =
AP 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:21:44 siduxbox kernel: [  202.207912] wlan0: authenticated
> Jan 29 13:21:44 siduxbox kernel: [  202.207944] wlan0: associate with AP =
00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:21:44 siduxbox kernel: [  202.210160] wlan0: RX ReassocResp fro=
m 00:17:9a:6a:3f:8f (capab=3D0x431 status=3D0 aid=3D1)
> Jan 29 13:21:44 siduxbox kernel: [  202.210164] wlan0: associated
> Jan 29 13:21:48 siduxbox kernel: [  206.206375] wlan0: disassociated from=
 00:17:9a:6a:3f:8f (Reason: 3)
> Jan 29 13:21:48 siduxbox kernel: [  206.232135] wlan0: deauthenticating f=
rom 00:17:9a:6a:3f:8f by local choice (reason=3D3)
> Jan 29 13:21:49 siduxbox kernel: [  207.329785] wlan0: direct probe to AP=
 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:21:49 siduxbox kernel: [  207.334059] wlan0: direct probe respo=
nded
> Jan 29 13:21:49 siduxbox kernel: [  207.334065] wlan0: authenticate with =
AP 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:21:49 siduxbox kernel: [  207.335649] wlan0: authenticated
> Jan 29 13:21:49 siduxbox kernel: [  207.335674] wlan0: associate with AP =
00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:21:49 siduxbox kernel: [  207.337967] wlan0: RX ReassocResp fro=
m 00:17:9a:6a:3f:8f (capab=3D0x431 status=3D0 aid=3D1)
> Jan 29 13:21:49 siduxbox kernel: [  207.337976] wlan0: associated
> Jan 29 13:21:53 siduxbox kernel: [  211.355585] wlan0: disassociated from=
 00:17:9a:6a:3f:8f (Reason: 3)
> Jan 29 13:21:53 siduxbox kernel: [  211.380029] wlan0: deauthenticating f=
rom 00:17:9a:6a:3f:8f by local choice (reason=3D3)
> Jan 29 13:21:55 siduxbox kernel: [  212.449802] wlan0: direct probe to AP=
 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:21:55 siduxbox kernel: [  212.454092] wlan0: direct probe respo=
nded
> Jan 29 13:21:55 siduxbox kernel: [  212.454098] wlan0: authenticate with =
AP 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:21:55 siduxbox kernel: [  212.455670] wlan0: authenticated
> Jan 29 13:21:55 siduxbox kernel: [  212.455695] wlan0: associate with AP =
00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:21:55 siduxbox kernel: [  212.457951] wlan0: RX ReassocResp fro=
m 00:17:9a:6a:3f:8f (capab=3D0x431 status=3D0 aid=3D1)
> Jan 29 13:21:55 siduxbox kernel: [  212.457955] wlan0: associated
> Jan 29 13:21:59 siduxbox kernel: [  216.454989] wlan0: disassociated from=
 00:17:9a:6a:3f:8f (Reason: 3)
> Jan 29 13:21:59 siduxbox kernel: [  216.480237] wlan0: deauthenticating f=
rom 00:17:9a:6a:3f:8f by local choice (reason=3D3)
> Jan 29 13:22:00 siduxbox kernel: [  217.549826] wlan0: direct probe to AP=
 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:22:00 siduxbox kernel: [  217.553992] wlan0: direct probe respo=
nded
> Jan 29 13:22:00 siduxbox kernel: [  217.553999] wlan0: authenticate with =
AP 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:22:00 siduxbox kernel: [  217.555696] wlan0: authenticated
> Jan 29 13:22:00 siduxbox kernel: [  217.555722] wlan0: associate with AP =
00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:22:00 siduxbox kernel: [  217.557979] wlan0: RX ReassocResp fro=
m 00:17:9a:6a:3f:8f (capab=3D0x431 status=3D0 aid=3D1)
> Jan 29 13:22:00 siduxbox kernel: [  217.557983] wlan0: associated
> Jan 29 13:22:04 siduxbox kernel: [  221.554284] wlan0: disassociated from=
 00:17:9a:6a:3f:8f (Reason: 3)
> Jan 29 13:22:04 siduxbox kernel: [  221.580029] wlan0: deauthenticating f=
rom 00:17:9a:6a:3f:8f by local choice (reason=3D3)
> Jan 29 13:22:05 siduxbox kernel: [  222.649728] wlan0: direct probe to AP=
 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:22:05 siduxbox kernel: [  222.653897] wlan0: direct probe respo=
nded
> Jan 29 13:22:05 siduxbox kernel: [  222.653903] wlan0: authenticate with =
AP 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:22:05 siduxbox kernel: [  222.655597] wlan0: authenticated
> Jan 29 13:22:05 siduxbox kernel: [  222.655623] wlan0: associate with AP =
00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:22:05 siduxbox kernel: [  222.658002] wlan0: RX ReassocResp fro=
m 00:17:9a:6a:3f:8f (capab=3D0x431 status=3D0 aid=3D1)
> Jan 29 13:22:05 siduxbox kernel: [  222.658006] wlan0: associated
> Jan 29 13:22:09 siduxbox kernel: [  226.653724] wlan0: disassociated from=
 00:17:9a:6a:3f:8f (Reason: 3)
> Jan 29 13:22:09 siduxbox kernel: [  226.676044] wlan0: deauthenticating f=
rom 00:17:9a:6a:3f:8f by local choice (reason=3D3)
> Jan 29 13:22:10 siduxbox kernel: [  227.753758] wlan0: direct probe to AP=
 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:22:10 siduxbox kernel: [  227.758156] wlan0: direct probe respo=
nded
> Jan 29 13:22:10 siduxbox kernel: [  227.758163] wlan0: authenticate with =
AP 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:22:10 siduxbox kernel: [  227.759873] wlan0: authenticated
> Jan 29 13:22:10 siduxbox kernel: [  227.759898] wlan0: associate with AP =
00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:22:10 siduxbox kernel: [  227.762152] wlan0: RX ReassocResp fro=
m 00:17:9a:6a:3f:8f (capab=3D0x431 status=3D0 aid=3D1)
> Jan 29 13:22:10 siduxbox kernel: [  227.762157] wlan0: associated
> Jan 29 13:22:14 siduxbox kernel: [  231.753207] wlan0: disassociated from=
 00:17:9a:6a:3f:8f (Reason: 3)
> Jan 29 13:22:14 siduxbox kernel: [  231.780027] wlan0: deauthenticating f=
rom 00:17:9a:6a:3f:8f by local choice (reason=3D3)
> Jan 29 13:22:15 siduxbox kernel: [  232.865913] wlan0: direct probe to AP=
 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:22:15 siduxbox kernel: [  232.870726] wlan0: direct probe respo=
nded
> Jan 29 13:22:15 siduxbox kernel: [  232.870735] wlan0: authenticate with =
AP 00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:22:15 siduxbox kernel: [  232.872448] wlan0: authenticated
> Jan 29 13:22:15 siduxbox kernel: [  232.872500] wlan0: associate with AP =
00:17:9a:6a:3f:8f (try 1)
> Jan 29 13:22:15 siduxbox kernel: [  232.874559] wlan0: RX ReassocResp fro=
m 00:17:9a:6a:3f:8f (capab=3D0x431 status=3D0 aid=3D1)
> Jan 29 13:22:15 siduxbox kernel: [  232.874564] wlan0: associated

--=20
Ben Hutchings
Horngren's Observation:
                   Among economists, the real world is often a special case=
.

--=-DRNEiISBF1XnQLMSlZFr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUAS4qcXee/yOyVhhEJAQIDWA/9Fj4x/KqG/uZgOx4lN1eIwQK0EB+M5py/
iPlUYWZJwF7T/43BEkBXLo7bitEdAdxl4PCm8cNZkXc2ZrjcFAb9IWt18AaTuMX7
5VjZeHSoxqr9Z6Gt2NMu+Ky4J/k7/qqfjCTk7y5W6Gxpi/V56roMeaeMsXZacb/D
SwUVdMsDrUm+1aepCsNsy+tjKYOMHC9fMZjGbl29O47BMmLI3I+o4+uDpo3pwmME
7yKKmozanZZcYhirVECGafMEziR2ZoOvUTWkeg5Dbh6tUFg/xgdSTR1WYHuIdcO7
WwsrW2HcDtOwDj48DM2i5ZnY9F+UgqvHB/rKUfuXFIOdLeAMYzJ/8OiDPiucQCP9
ro6QDQYIpvwWYYxc+C+AQ+miEtvyhsoQMu4PdANLZzIrgbN2LZwcwsPpR3L+BLT3
qKGk5NLfZpWDBA44paw59e+bIhi/avQFrTknOAAhxL/MY1DTAuBuZ+EWedepRGWv
Vx7UKx/NwHqanc3uMOgJx1LsmeNjIuhiQtcCSS22BD59LxR8az0SaefyZeNObjfI
LHx66jjhruHyHA56D4zUH51I+hGTTiJtGXfhlpVjvvbthASUf07CEu9Z1NHlQQo1
YXK30Mdh4cr7xIK2aMCoraAB4EPQ/CLpCaXYYKnj0LKFZknugqMx6jiIx+qxDc9D
r7UPgjoA7mc=
=dcCl
-----END PGP SIGNATURE-----

--=-DRNEiISBF1XnQLMSlZFr--
