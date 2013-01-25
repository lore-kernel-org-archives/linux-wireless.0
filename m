Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:46007 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753680Ab3AYXQx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2013 18:16:53 -0500
Date: Sat, 26 Jan 2013 01:16:36 +0200
From: Felipe Balbi <balbi@ti.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
CC: <balbi@ti.com>, linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: brcm WARN() on v3.7.2
Message-ID: <20130125231636.GA5942@arwen.pp.htv.fi> (sfid-20130126_001702_844366_E7763D66)
Reply-To: <balbi@ti.com>
References: <5102F3DF.3040606@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n8g4imXOkfNTN/H1"
In-Reply-To: <5102F3DF.3040606@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jan 25, 2013 at 10:06:39PM +0100, Xose Vazquez Perez wrote:
> Felipe Balbi wrote:
>=20
> > I'm running Fedora 18 with v3.7.2 on her MacBookAir 11" and it turns out
> > that brcm is acting out, see below full dmesg. Any tips ? Is this fixed
> > already ?
>=20
> try kernel-3.7.4-204.fc18: http://koji.fedoraproject.org/koji/buildinfo?b=
uildID=3D380267
>=20
>=20
> * Wed Jan 23 2013 Justin M. Forbes <jforbes@redhat.com> - 3.7.4-204
> - brcmsmac fixes from upstream (rhbz 892428)

didn't help :-s I'll try to have a closer look on Monday.

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.7.4-204.fc18.x86_64 (mockbuild@bkernel01.phx=
2.fedoraproject.org) (gcc version 4.7.2 20121109 (Red Hat 4.7.2-8) (GCC) ) =
#1 SMP Wed Jan 23 16:44:29 UTC 2013
[    0.000000] Command line: BOOT_IMAGE=3D/vmlinuz-3.7.4-204.fc18.x86_64 ro=
ot=3D/dev/mapper/fedora-root ro rd.lvm.lv=3Dfedora/swap rd.md=3D0 rd.dm=3D0=
 rd.luks=3D0 vconsole.keymap=3Dus rd.lvm.lv=3Dfedora/root rhgb quiet LANG=
=3Den_US.UTF-8
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000008efff] usable
[    0.000000] BIOS-e820: [mem 0x000000000008f000-0x000000000008ffff] ACPI =
NVS
[    0.000000] BIOS-e820: [mem 0x0000000000090000-0x000000000009ffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000aeffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000af000000-0x00000000beffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000bf000000-0x00000000bf718fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bf719000-0x00000000bf938fff] ACPI =
NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf939000-0x00000000bf953fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bf954000-0x00000000bf96afff] ACPI =
data
[    0.000000] BIOS-e820: [mem 0x00000000bf96b000-0x00000000bf96dfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bf96e000-0x00000000bf99afff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000bf99b000-0x00000000bf9affff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bf9b0000-0x00000000bf9dafff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000bf9db000-0x00000000bfef8fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bfef9000-0x00000000bfefffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000d3200000-0x00000000d3200fff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000ffc00000-0x00000000ffffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000013fffffff] usable
[    0.000000] e820: update [mem 0x81bfa018-0x81c08c57] usable =3D=3D> usab=
le
[    0.000000] extended physical RAM map:
[    0.000000] reserve setup_data: [mem 0x0000000000000000-0x000000000008ef=
ff] usable
[    0.000000] reserve setup_data: [mem 0x000000000008f000-0x000000000008ff=
ff] ACPI NVS
[    0.000000] reserve setup_data: [mem 0x0000000000090000-0x000000000009ff=
ff] usable
[    0.000000] reserve setup_data: [mem 0x0000000000100000-0x0000000081bfa0=
17] usable
[    0.000000] reserve setup_data: [mem 0x0000000081bfa018-0x0000000081c08c=
57] usable
[    0.000000] reserve setup_data: [mem 0x0000000081c08c58-0x00000000aeffff=
ff] usable
[    0.000000] reserve setup_data: [mem 0x00000000af000000-0x00000000beffff=
ff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000bf000000-0x00000000bf718f=
ff] usable
[    0.000000] reserve setup_data: [mem 0x00000000bf719000-0x00000000bf938f=
ff] ACPI NVS
[    0.000000] reserve setup_data: [mem 0x00000000bf939000-0x00000000bf953f=
ff] usable
[    0.000000] reserve setup_data: [mem 0x00000000bf954000-0x00000000bf96af=
ff] ACPI data
[    0.000000] reserve setup_data: [mem 0x00000000bf96b000-0x00000000bf96df=
ff] usable
[    0.000000] reserve setup_data: [mem 0x00000000bf96e000-0x00000000bf99af=
ff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000bf99b000-0x00000000bf9aff=
ff] usable
[    0.000000] reserve setup_data: [mem 0x00000000bf9b0000-0x00000000bf9daf=
ff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000bf9db000-0x00000000bfef8f=
ff] usable
[    0.000000] reserve setup_data: [mem 0x00000000bfef9000-0x00000000bfefff=
ff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000d3200000-0x00000000d3200f=
ff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000ffc00000-0x00000000ffffff=
ff] reserved
[    0.000000] reserve setup_data: [mem 0x0000000100000000-0x000000013fffff=
ff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] efi: EFI v1.10 by Apple
[    0.000000] efi:  ACPI=3D0xbf96a000  ACPI 2.0=3D0xbf96a014  SMBIOS=3D0xb=
f71a000=20
[    0.000000] efi: mem00: type=3D7, attr=3D0xf, range=3D[0x000000000000000=
0-0x000000000008f000) (0MB)
[    0.000000] efi: mem01: type=3D10, attr=3D0xf, range=3D[0x000000000008f0=
00-0x0000000000090000) (0MB)
[    0.000000] efi: mem02: type=3D2, attr=3D0xf, range=3D[0x000000000009000=
0-0x0000000000092000) (0MB)
[    0.000000] efi: mem03: type=3D7, attr=3D0xf, range=3D[0x000000000009200=
0-0x00000000000a0000) (0MB)
[    0.000000] efi: mem04: type=3D7, attr=3D0xf, range=3D[0x000000000010000=
0-0x0000000001000000) (15MB)
[    0.000000] efi: mem05: type=3D2, attr=3D0xf, range=3D[0x000000000100000=
0-0x00000000023c9000) (19MB)
[    0.000000] efi: mem06: type=3D7, attr=3D0xf, range=3D[0x00000000023c900=
0-0x000000003e174000) (957MB)
[    0.000000] efi: mem07: type=3D2, attr=3D0xf, range=3D[0x000000003e17400=
0-0x0000000040000000) (30MB)
[    0.000000] efi: mem08: type=3D7, attr=3D0xf, range=3D[0x000000004000000=
0-0x0000000081bfa000) (1051MB)
[    0.000000] efi: mem09: type=3D2, attr=3D0xf, range=3D[0x0000000081bfa00=
0-0x00000000ad03a000) (692MB)
[    0.000000] efi: mem10: type=3D7, attr=3D0xf, range=3D[0x00000000ad03a00=
0-0x00000000ad03d000) (0MB)
[    0.000000] efi: mem11: type=3D4, attr=3D0xf, range=3D[0x00000000ad03d00=
0-0x00000000ad042000) (0MB)
[    0.000000] efi: mem12: type=3D2, attr=3D0xf, range=3D[0x00000000ad04200=
0-0x00000000ad1e1000) (1MB)
[    0.000000] efi: mem13: type=3D4, attr=3D0xf, range=3D[0x00000000ad1e100=
0-0x00000000aea71000) (24MB)
[    0.000000] efi: mem14: type=3D2, attr=3D0xf, range=3D[0x00000000aea7100=
0-0x00000000aea72000) (0MB)
[    0.000000] efi: mem15: type=3D4, attr=3D0xf, range=3D[0x00000000aea7200=
0-0x00000000af000000) (5MB)
[    0.000000] efi: mem16: type=3D4, attr=3D0xf, range=3D[0x00000000bf00000=
0-0x00000000bf6af000) (6MB)
[    0.000000] efi: mem17: type=3D7, attr=3D0xf, range=3D[0x00000000bf6af00=
0-0x00000000bf719000) (0MB)
[    0.000000] efi: mem18: type=3D10, attr=3D0xf, range=3D[0x00000000bf7190=
00-0x00000000bf939000) (2MB)
[    0.000000] efi: mem19: type=3D7, attr=3D0xf, range=3D[0x00000000bf93900=
0-0x00000000bf954000) (0MB)
[    0.000000] efi: mem20: type=3D9, attr=3D0xf, range=3D[0x00000000bf95400=
0-0x00000000bf96b000) (0MB)
[    0.000000] efi: mem21: type=3D7, attr=3D0xf, range=3D[0x00000000bf96b00=
0-0x00000000bf96e000) (0MB)
[    0.000000] efi: mem22: type=3D6, attr=3D0x800000000000000f, range=3D[0x=
00000000bf96e000-0x00000000bf99b000) (0MB)
[    0.000000] efi: mem23: type=3D7, attr=3D0xf, range=3D[0x00000000bf99b00=
0-0x00000000bf9b0000) (0MB)
[    0.000000] efi: mem24: type=3D5, attr=3D0x800000000000000f, range=3D[0x=
00000000bf9b0000-0x00000000bf9db000) (0MB)
[    0.000000] efi: mem25: type=3D7, attr=3D0xf, range=3D[0x00000000bf9db00=
0-0x00000000bfa64000) (0MB)
[    0.000000] efi: mem26: type=3D3, attr=3D0xf, range=3D[0x00000000bfa6400=
0-0x00000000bfd5f000) (2MB)
[    0.000000] efi: mem27: type=3D7, attr=3D0xf, range=3D[0x00000000bfd5f00=
0-0x00000000bfdb8000) (0MB)
[    0.000000] efi: mem28: type=3D1, attr=3D0xf, range=3D[0x00000000bfdb800=
0-0x00000000bfeef000) (1MB)
[    0.000000] efi: mem29: type=3D7, attr=3D0xf, range=3D[0x00000000bfeef00=
0-0x00000000bfef9000) (0MB)
[    0.000000] efi: mem30: type=3D0, attr=3D0xf, range=3D[0x00000000bfef900=
0-0x00000000bfeff000) (0MB)
[    0.000000] efi: mem31: type=3D6, attr=3D0x800000000000000f, range=3D[0x=
00000000bfeff000-0x00000000bff00000) (0MB)
[    0.000000] efi: mem32: type=3D7, attr=3D0xf, range=3D[0x000000010000000=
0-0x0000000140000000) (1024MB)
[    0.000000] efi: mem33: type=3D0, attr=3D0x8000000000000000, range=3D[0x=
00000000af000000-0x00000000bf000000) (256MB)
[    0.000000] efi: mem34: type=3D11, attr=3D0x8000000000000000, range=3D[0=
x00000000d3200000-0x00000000d3201000) (0MB)
[    0.000000] efi: mem35: type=3D11, attr=3D0x8000000000000000, range=3D[0=
x00000000ffc00000-0x00000000ffc80000) (0MB)
[    0.000000] efi: mem36: type=3D11, attr=3D0x8000000000000000, range=3D[0=
x00000000ffc80000-0x00000000ffca8000) (0MB)
[    0.000000] efi: mem37: type=3D11, attr=3D0x8000000000000000, range=3D[0=
x00000000ffca8000-0x00000000ffcca000) (0MB)
[    0.000000] efi: mem38: type=3D11, attr=3D0x8000000000000000, range=3D[0=
x00000000ffcca000-0x00000000ffffc000) (3MB)
[    0.000000] efi: mem39: type=3D11, attr=3D0x8000000000000000, range=3D[0=
x00000000ffffc000-0x0000000100000000) (0MB)
[    0.000000] DMI 2.4 present.
[    0.000000] DMI: Apple Inc. MacBookAir3,1/Mac-942452F5819B1C1B, BIOS    =
MBA31.88Z.0061.B07.1201241641 01/24/12
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn =3D 0x140000 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0C0000000 mask FC0000000 uncachable
[    0.000000]   1 base 0BFF00000 mask FFFF00000 uncachable
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] e820: last_pfn =3D 0xbfef9 max_arch_pfn =3D 0x400000000
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0xbfef8fff]
[    0.000000]  [mem 0x00000000-0xbfdfffff] page 2M
[    0.000000]  [mem 0xbfe00000-0xbfef8fff] page 4k
[    0.000000] kernel direct mapping tables up to 0xbfef8fff @ [mem 0x1fffb=
000-0x1fffffff]
[    0.000000] init_memory_mapping: [mem 0x100000000-0x13fffffff]
[    0.000000]  [mem 0x100000000-0x13fffffff] page 2M
[    0.000000] kernel direct mapping tables up to 0x13fffffff @ [mem 0xbfef=
7000-0xbfef8fff]
[    0.000000] RAMDISK: [mem 0x3e174000-0x3fffafff]
[    0.000000] ACPI: RSDP 00000000bf96a014 00024 (v02 APPLE )
[    0.000000] ACPI: XSDT 00000000bf96a1c0 00084 (v01 APPLE   Apple00 00000=
061      01000013)
[    0.000000] ACPI: FACP 00000000bf968000 000F4 (v04 APPLE   Apple00 00000=
061 Loki 0000005F)
[    0.000000] ACPI: DSDT 00000000bf95b000 0572C (v01 APPLE  MacBookA 00030=
001 INTL 20061109)
[    0.000000] ACPI: FACS 00000000bf71e000 00040
[    0.000000] ACPI: HPET 00000000bf967000 00038 (v01 APPLE   Apple00 00000=
001 Loki 0000005F)
[    0.000000] ACPI: APIC 00000000bf966000 00068 (v01 APPLE   Apple00 00000=
001 Loki 0000005F)
[    0.000000] ACPI: APIC 00000000bf965000 00068 (v02 APPLE   Apple00 00000=
001 Loki 0000005F)
[    0.000000] ACPI: ASF! 00000000bf963000 000A5 (v32 APPLE   Apple00 00000=
001 Loki 0000005F)
[    0.000000] ACPI: SBST 00000000bf962000 00030 (v01 APPLE   Apple00 00000=
001 Loki 0000005F)
[    0.000000] ACPI: ECDT 00000000bf961000 00053 (v01 APPLE   Apple00 00000=
001 Loki 0000005F)
[    0.000000] ACPI: SSDT 00000000bf958000 00107 (v01 APPLE  SataAhci 00001=
000 INTL 20061109)
[    0.000000] ACPI: SSDT 00000000bf957000 00024 (v01 APPLE     Apple 00001=
000 INTL 20061109)
[    0.000000] ACPI: SSDT 00000000bf955000 0008A (v01 APPLE  NoSDCard 00001=
000 INTL 20061109)
[    0.000000] ACPI: SSDT 00000000bf954000 004DC (v01  APPLE    CpuPm 00003=
000 INTL 20061109)
[    0.000000] ACPI: MCFG 00000000bf964000 0003C (v01 APPLE   Apple00 00000=
001 Loki 0000005F)
[    0.000000] ACPI: BIOS bug: multiple APIC/MADT found, using 0
[    0.000000] ACPI: If "acpi_apic_instance=3D2" works better, notify linux=
-acpi@vger.kernel.org
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000013fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x13fffffff]
[    0.000000]   NODE_DATA [mem 0x13ffec000-0x13fffffff]
[    0.000000]  [ffffea0000000000-ffffea0004ffffff] PMD -> [ffff88013b80000=
0-ffff88013f5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x13fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0008efff]
[    0.000000]   node   0: [mem 0x00090000-0x0009ffff]
[    0.000000]   node   0: [mem 0x00100000-0xaeffffff]
[    0.000000]   node   0: [mem 0xbf000000-0xbf718fff]
[    0.000000]   node   0: [mem 0xbf939000-0xbf953fff]
[    0.000000]   node   0: [mem 0xbf96b000-0xbf96dfff]
[    0.000000]   node   0: [mem 0xbf99b000-0xbf9affff]
[    0.000000]   node   0: [mem 0xbf9db000-0xbfef8fff]
[    0.000000]   node   0: [mem 0x100000000-0x13fffffff]
[    0.000000] On node 0 totalpages: 982009
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 8 pages reserved
[    0.000000]   DMA zone: 3911 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 16320 pages used for memmap
[    0.000000]   DMA32 zone: 699562 pages, LIFO batch:31
[    0.000000]   Normal zone: 4096 pages used for memmap
[    0.000000]   Normal zone: 258048 pages, LIFO batch:31
[    0.000000] tboot: non-0 tboot_addr but it is not of type E820_RESERVED
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 17, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000008f000 - 00000000000=
90000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000001=
00000
[    0.000000] PM: Registered nosave memory: 0000000081bfa000 - 0000000081b=
fb000
[    0.000000] PM: Registered nosave memory: 0000000081c08000 - 0000000081c=
09000
[    0.000000] PM: Registered nosave memory: 00000000af000000 - 00000000bf0=
00000
[    0.000000] PM: Registered nosave memory: 00000000bf719000 - 00000000bf9=
39000
[    0.000000] PM: Registered nosave memory: 00000000bf954000 - 00000000bf9=
6b000
[    0.000000] PM: Registered nosave memory: 00000000bf96e000 - 00000000bf9=
9b000
[    0.000000] PM: Registered nosave memory: 00000000bf9b0000 - 00000000bf9=
db000
[    0.000000] PM: Registered nosave memory: 00000000bfef9000 - 00000000bff=
00000
[    0.000000] PM: Registered nosave memory: 00000000bff00000 - 00000000d32=
00000
[    0.000000] PM: Registered nosave memory: 00000000d3200000 - 00000000d32=
01000
[    0.000000] PM: Registered nosave memory: 00000000d3201000 - 00000000ffc=
00000
[    0.000000] PM: Registered nosave memory: 00000000ffc00000 - 00000001000=
00000
[    0.000000] e820: [mem 0xd3201000-0xffbfffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:128 nr_cpumask_bits:128 nr_cpu_ids:2 n=
r_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88013fc00000 s84288 r8192=
 d22208 u1048576
[    0.000000] pcpu-alloc: s84288 r8192 d22208 u1048576 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1=20
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 961521
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=3D/vmlinuz-3.7.4-204.fc18.x8=
6_64 root=3D/dev/mapper/fedora-root ro rd.lvm.lv=3Dfedora/swap rd.md=3D0 rd=
=2Edm=3D0 rd.luks=3D0 vconsole.keymap=3Dus rd.lvm.lv=3Dfedora/root rhgb qui=
et LANG=3Den_US.UTF-8
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] xsave: enabled xstate_bv 0x3, cntxt size 0x240
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 3709932k/5242880k available (6407k kernel code, 1314=
844k absent, 218104k reserved, 6793k data, 1068k init)
[    0.000000] SLUB: Genslabs=3D15, HWalign=3D64, Order=3D0-3, MinObjects=
=3D0, CPUs=3D2, Nodes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=3D128 to nr_cpu_ids=3D2.
[    0.000000] NR_IRQS:8448 nr_irqs:512 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 16252928 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 1596.760 MHz processor
[    0.001005] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 3193.52 BogoMIPS (lpj=3D1596760)
[    0.001009] pid_max: default: 32768 minimum: 301
[    0.001037] init_memory_mapping: [mem 0xbfeff000-0xbfefffff]
[    0.001042]  [mem 0xbfeff000-0xbfefffff] page 4k
[    0.186363] Security Framework initialized
[    0.186377] SELinux:  Initializing.
[    0.186391] SELinux:  Starting in permissive mode
[    0.187043] Dentry cache hash table entries: 524288 (order: 10, 4194304 =
bytes)
[    0.189684] Inode-cache hash table entries: 262144 (order: 9, 2097152 by=
tes)
[    0.190911] Mount-cache hash table entries: 256
[    0.191261] Initializing cgroup subsys cpuacct
[    0.191265] Initializing cgroup subsys memory
[    0.191284] Initializing cgroup subsys devices
[    0.191286] Initializing cgroup subsys freezer
[    0.191288] Initializing cgroup subsys net_cls
[    0.191290] Initializing cgroup subsys blkio
[    0.191293] Initializing cgroup subsys perf_event
[    0.191337] CPU: Physical Processor ID: 0
[    0.191339] CPU: Processor Core ID: 0
[    0.191342] mce: CPU supports 6 MCE banks
[    0.191353] CPU0: Thermal monitoring enabled (TM2)
[    0.191358] process: using mwait in idle threads
[    0.191365] Last level iTLB entries: 4KB 128, 2MB 4, 4MB 4
Last level dTLB entries: 4KB 256, 2MB 0, 4MB 32
tlb_flushall_shift: -1
[    0.191530] Freeing SMP alternatives: 24k freed
[    0.193748] ACPI: Core revision 20120913
[    0.202518] ftrace: allocating 23748 entries in 93 pages
[    0.212566] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.223149] smpboot: CPU0: Intel(R) Core(TM)2 Duo CPU     U9600  @ 1.60G=
Hz (fam: 06, model: 17, stepping: 0a)
[    0.224000] Performance Events: PEBS fmt0+, 4-deep LBR, Core2 events, In=
tel PMU driver.
[    0.224000] ... version:                2
[    0.224000] ... bit width:              40
[    0.224000] ... generic registers:      2
[    0.224000] ... value mask:             000000ffffffffff
[    0.224000] ... max period:             000000007fffffff
[    0.224000] ... fixed-purpose events:   3
[    0.224000] ... event mask:             0000000700000003
[    0.225065] smpboot: Booting Node   0, Processors  #1 OK
[    0.237029] Brought up 2 CPUs
[    0.237036] smpboot: Total of 2 processors activated (6387.04 BogoMIPS)
[    0.237171] NMI watchdog: enabled on all CPUs, permanently consumes one =
hw-PMU counter.
[    0.239058] devtmpfs: initialized
[    0.239199] PM: Registering ACPI NVS region [mem 0x0008f000-0x0008ffff] =
(4096 bytes)
[    0.239199] PM: Registering ACPI NVS region [mem 0xbf719000-0xbf938fff] =
(2228224 bytes)
[    0.240973] atomic64 test passed for x86-64 platform with CX8 and with S=
SE
[    0.241004] RTC time: 23:12:29, date: 01/25/13
[    0.241064] NET: Registered protocol family 16
[    0.241314] ACPI FADT declares the system doesn't support PCIe ASPM, so =
disable it
[    0.241318] ACPI: bus type pci registered
[    0.241652] PCI: MMCONFIG for domain 0000 [bus 00-02] at [mem 0xf0000000=
-0xf02fffff] (base 0xf0000000)
[    0.241655] PCI: not using MMCONFIG
[    0.241658] PCI: Using configuration type 1 for base access
[    0.243044] bio: create slab <bio-0> at 0
[    0.243088] ACPI: Added _OSI(Module Device)
[    0.243088] ACPI: Added _OSI(Processor Device)
[    0.243088] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.243088] ACPI: Added _OSI(Processor Aggregator Device)
[    0.244630] ACPI: EC: EC description table is found, configuring boot EC
[    0.249174] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.249595] ACPI: SSDT 00000000bf71dc98 0023D (v01  APPLE  Cpu0Ist 00003=
000 INTL 20061109)
[    0.249981] ACPI: Dynamic OEM Table Load:
[    0.249985] ACPI: SSDT           (null) 0023D (v01  APPLE  Cpu0Ist 00003=
000 INTL 20061109)
[    0.250156] ACPI: SSDT 00000000bf71c618 005A6 (v01  APPLE  Cpu0Cst 00003=
001 INTL 20061109)
[    0.250526] ACPI: Dynamic OEM Table Load:
[    0.250529] ACPI: SSDT           (null) 005A6 (v01  APPLE  Cpu0Cst 00003=
001 INTL 20061109)
[    0.260263] ACPI: SSDT 00000000bf71df18 000C8 (v01  APPLE  Cpu1Ist 00003=
000 INTL 20061109)
[    0.260640] ACPI: Dynamic OEM Table Load:
[    0.260644] ACPI: SSDT           (null) 000C8 (v01  APPLE  Cpu1Ist 00003=
000 INTL 20061109)
[    0.260761] ACPI: SSDT 00000000bf71bf18 00085 (v01  APPLE  Cpu1Cst 00003=
000 INTL 20061109)
[    0.261136] ACPI: Dynamic OEM Table Load:
[    0.261140] ACPI: SSDT           (null) 00085 (v01  APPLE  Cpu1Cst 00003=
000 INTL 20061109)
[    0.270210] ACPI: Interpreter enabled
[    0.270215] ACPI: (supports S0 S3 S4 S5)
[    0.270236] ACPI: Using IOAPIC for interrupt routing
[    0.270257] PCI: MMCONFIG for domain 0000 [bus 00-02] at [mem 0xf0000000=
-0xf02fffff] (base 0xf0000000)
[    0.270568] PCI: MMCONFIG at [mem 0xf0000000-0xf02fffff] reserved in ACP=
I motherboard resources
[    0.282327] ACPI: EC: GPE =3D 0x57, I/O: command/status =3D 0x66, data =
=3D 0x62
[    0.282537] ACPI: No dock devices found.
[    0.282543] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.283112] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.283232] pci_root PNP0A08:00: [Firmware Info]: MMCONFIG for domain 00=
00 [bus 00-02] only partially covers this bridge
[    0.283271] PCI host bridge to bus 0000:00
[    0.283275] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.283279] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.283282] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.283285] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.283288] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000c3ff=
f]
[    0.283292] pci_bus 0000:00: root bus resource [mem 0x000c4000-0x000c7ff=
f]
[    0.283295] pci_bus 0000:00: root bus resource [mem 0x000c8000-0x000cbff=
f]
[    0.283298] pci_bus 0000:00: root bus resource [mem 0x000cc000-0x000cfff=
f]
[    0.283301] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3ff=
f]
[    0.283304] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7ff=
f]
[    0.283307] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbff=
f]
[    0.283310] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dfff=
f]
[    0.283313] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3ff=
f]
[    0.283316] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7ff=
f]
[    0.283319] pci_bus 0000:00: root bus resource [mem 0x000e8000-0x000ebff=
f]
[    0.283322] pci_bus 0000:00: root bus resource [mem 0x000ec000-0x000efff=
f]
[    0.283325] pci_bus 0000:00: root bus resource [mem 0x000f0000-0x000ffff=
f]
[    0.283328] pci_bus 0000:00: root bus resource [mem 0xc0000000-0xfebffff=
f]
[    0.283348] pci 0000:00:00.0: [10de:0d60] type 00 class 0x060000
[    0.283474] pci 0000:00:00.1: [10de:0d68] type 00 class 0x050000
[    0.283660] pci 0000:00:01.0: [10de:0d6d] type 00 class 0x050000
[    0.283838] pci 0000:00:01.1: [10de:0d6e] type 00 class 0x050000
[    0.284021] pci 0000:00:01.2: [10de:0d6f] type 00 class 0x050000
[    0.284202] pci 0000:00:01.3: [10de:0d70] type 00 class 0x050000
[    0.284385] pci 0000:00:02.0: [10de:0d71] type 00 class 0x050000
[    0.284563] pci 0000:00:02.1: [10de:0d72] type 00 class 0x050000
[    0.284742] pci 0000:00:03.0: [10de:0d80] type 00 class 0x060100
[    0.284754] pci 0000:00:03.0: reg 10: [io  0x2100-0x21ff]
[    0.284812] pci 0000:00:03.1: [10de:0d7b] type 00 class 0x050000
[    0.284910] pci 0000:00:03.2: [10de:0d79] type 00 class 0x0c0500
[    0.284927] pci 0000:00:03.2: reg 10: [io  0x2000-0x20ff]
[    0.284937] pci 0000:00:03.2: reg 14: [mem 0xd3286000-0xd3287fff]
[    0.284959] pci 0000:00:03.2: reg 20: [io  0x2240-0x227f]
[    0.284968] pci 0000:00:03.2: reg 24: [io  0x2200-0x223f]
[    0.285015] pci 0000:00:03.2: PME# supported from D3hot D3cold
[    0.285046] pci 0000:00:03.3: [10de:0d69] type 00 class 0x050000
[    0.285265] pci 0000:00:03.4: [10de:0d7a] type 00 class 0x0b4000
[    0.285289] pci 0000:00:03.4: reg 10: [mem 0xd3200000-0xd327ffff]
[    0.285446] pci 0000:00:04.0: [10de:0d9c] type 00 class 0x0c0310
[    0.285462] pci 0000:00:04.0: reg 10: [mem 0xd328a000-0xd328afff]
[    0.285524] pci 0000:00:04.0: supports D1 D2
[    0.285527] pci 0000:00:04.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.285547] pci 0000:00:04.1: [10de:0d9d] type 00 class 0x0c0320
[    0.285565] pci 0000:00:04.1: reg 10: [mem 0xd328b100-0xd328b1ff]
[    0.285637] pci 0000:00:04.1: supports D1 D2
[    0.285640] pci 0000:00:04.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.285671] pci 0000:00:06.0: [10de:0d9c] type 00 class 0x0c0310
[    0.285686] pci 0000:00:06.0: reg 10: [mem 0xd3289000-0xd3289fff]
[    0.285747] pci 0000:00:06.0: supports D1 D2
[    0.285750] pci 0000:00:06.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.285771] pci 0000:00:06.1: [10de:0d9d] type 00 class 0x0c0320
[    0.285788] pci 0000:00:06.1: reg 10: [mem 0xd328b000-0xd328b0ff]
[    0.285861] pci 0000:00:06.1: supports D1 D2
[    0.285863] pci 0000:00:06.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.285898] pci 0000:00:08.0: [10de:0d94] type 00 class 0x040300
[    0.285916] pci 0000:00:08.0: reg 10: [mem 0xd3280000-0xd3283fff]
[    0.285991] pci 0000:00:08.0: PME# supported from D3hot D3cold
[    0.286021] pci 0000:00:0a.0: [10de:0d88] type 00 class 0x010601
[    0.286038] pci 0000:00:0a.0: reg 10: [io  0x2298-0x229f]
[    0.286046] pci 0000:00:0a.0: reg 14: [io  0x22a4-0x22a7]
[    0.286055] pci 0000:00:0a.0: reg 18: [io  0x2290-0x2297]
[    0.286063] pci 0000:00:0a.0: reg 1c: [io  0x22a0-0x22a3]
[    0.286071] pci 0000:00:0a.0: reg 20: [io  0x2280-0x228f]
[    0.286080] pci 0000:00:0a.0: reg 24: [mem 0xd3284000-0xd3285fff]
[    0.286138] pci 0000:00:0b.0: [10de:0d75] type 00 class 0x050000
[    0.286155] pci 0000:00:0b.0: reg 10: [mem 0xd3288000-0xd3288fff]
[    0.286303] pci 0000:00:15.0: [10de:0d9b] type 01 class 0x060400
[    0.286583] pci 0000:00:15.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.286653] pci 0000:00:17.0: [10de:0d76] type 01 class 0x060400
[    0.286709] pci 0000:00:17.0: PME# supported from D0 D3hot D3cold
[    0.286958] pci 0000:01:00.0: [14e4:4353] type 00 class 0x028000
[    0.286982] pci 0000:01:00.0: reg 10: [mem 0xd3100000-0xd3103fff 64bit]
[    0.287105] pci 0000:01:00.0: supports D1 D2
[    0.287108] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
[    0.287177] pci 0000:00:15.0: PCI bridge to [bus 01]
[    0.287201] pci 0000:00:15.0:   bridge window [mem 0xd3100000-0xd31fffff]
[    0.287262] pci 0000:02:00.0: [10de:08a2] type 00 class 0x030000
[    0.287279] pci 0000:02:00.0: reg 10: [mem 0xd2000000-0xd2ffffff]
[    0.287290] pci 0000:02:00.0: reg 14: [mem 0xc0000000-0xcfffffff 64bit p=
ref]
[    0.287302] pci 0000:02:00.0: reg 1c: [mem 0xd0000000-0xd1ffffff 64bit p=
ref]
[    0.287310] pci 0000:02:00.0: reg 24: [io  0x1000-0x107f]
[    0.287319] pci 0000:02:00.0: reg 30: [mem 0xd3000000-0xd301ffff pref]
[    0.287383] pci 0000:00:17.0: PCI bridge to [bus 02]
[    0.287389] pci 0000:00:17.0:   bridge window [io  0x1000-0x1fff]
[    0.287393] pci 0000:00:17.0:   bridge window [mem 0xd2000000-0xd30fffff]
[    0.287399] pci 0000:00:17.0:   bridge window [mem 0xc0000000-0xd1ffffff=
 64bit pref]
[    0.287422] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.287613] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.IXVE._PRT]
[    0.287748]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.287937]  pci0000:00: ACPI _OSC control (0x1d) granted
[    0.303940] ACPI: PCI Interrupt Link [LNK1] (IRQs *16 17 18 19 20 21 22 =
23)
[    0.304057] ACPI: PCI Interrupt Link [LNK2] (IRQs 16 *17 18 19 20 21 22 =
23)
[    0.304166] ACPI: PCI Interrupt Link [LNK3] (IRQs 16 17 *18 19 20 21 22 =
23)
[    0.304274] ACPI: PCI Interrupt Link [LNK4] (IRQs 16 17 18 *19 20 21 22 =
23)
[    0.304387] ACPI: PCI Interrupt Link [Z00J] (IRQs 16 17 18 19 20 *21 22 =
23)
[    0.304495] ACPI: PCI Interrupt Link [Z00K] (IRQs 16 17 18 19 20 *21 22 =
23)
[    0.304603] ACPI: PCI Interrupt Link [Z00L] (IRQs 16 17 18 19 20 *21 22 =
23)
[    0.304712] ACPI: PCI Interrupt Link [Z00M] (IRQs 16 17 18 19 20 *21 22 =
23)
[    0.304819] ACPI: PCI Interrupt Link [LSMB] (IRQs 16 17 18 19 20 21 *22 =
23)
[    0.304926] ACPI: PCI Interrupt Link [LUS0] (IRQs 16 *17 18 19 20 21 22 =
23)
[    0.305046] ACPI: PCI Interrupt Link [LUS2] (IRQs 16 *17 18 19 20 21 22 =
23)
[    0.305163] ACPI: PCI Interrupt Link [LMAC] (IRQs 16 *17 18 19 20 21 22 =
23)
[    0.305273] ACPI: PCI Interrupt Link [LAZA] (IRQs 16 17 18 19 *20 21 22 =
23)
[    0.305382] ACPI: PCI Interrupt Link [LGPU] (IRQs *16 17 18 19 20 21 22 =
23)
[    0.305486] ACPI: PCI Interrupt Link [LPID] (IRQs 16 17 18 19 20 21 22 2=
3) *0, disabled.
[    0.305594] ACPI: PCI Interrupt Link [LSI0] (IRQs 16 17 *18 19 20 21 22 =
23)
[    0.305700] ACPI: PCI Interrupt Link [Z000] (IRQs 16 17 *18 19 20 21 22 =
23)
[    0.305807] ACPI: PCI Interrupt Link [Z001] (IRQs 16 17 18 19 20 21 *22 =
23)
[    0.305910] ACPI: PCI Interrupt Link [LPMU] (IRQs 16 17 18 19 20 21 22 2=
3) *0, disabled.
[    0.306025] vgaarb: device added: PCI:0000:02:00.0,decodes=3Dio+mem,owns=
=3Dnone,locks=3Dnone
[    0.306028] vgaarb: loaded
[    0.306030] vgaarb: bridge control possible 0000:02:00.0
[    0.306126] SCSI subsystem initialized
[    0.306129] ACPI: bus type scsi registered
[    0.306139] libata version 3.00 loaded.
[    0.306139] ACPI: bus type usb registered
[    0.306139] usbcore: registered new interface driver usbfs
[    0.306139] usbcore: registered new interface driver hub
[    0.306139] usbcore: registered new device driver usb
[    0.306139] PCI: Using ACPI for IRQ routing
[    0.306139] PCI: pci_cache_line_size set to 64 bytes
[    0.306153] e820: reserve RAM buffer [mem 0x0008f000-0x0008ffff]
[    0.306156] e820: reserve RAM buffer [mem 0x81bfa018-0x83ffffff]
[    0.306158] e820: reserve RAM buffer [mem 0xaf000000-0xafffffff]
[    0.306160] e820: reserve RAM buffer [mem 0xbf719000-0xbfffffff]
[    0.306164] e820: reserve RAM buffer [mem 0xbf954000-0xbfffffff]
[    0.306167] e820: reserve RAM buffer [mem 0xbf96e000-0xbfffffff]
[    0.306170] e820: reserve RAM buffer [mem 0xbf9b0000-0xbfffffff]
[    0.306172] e820: reserve RAM buffer [mem 0xbfef9000-0xbfffffff]
[    0.306301] NetLabel: Initializing
[    0.306304] NetLabel:  domain hash size =3D 128
[    0.306305] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    0.306320] NetLabel:  unlabeled traffic allowed by default
[    0.306387] HPET: 4 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.306394] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31, 31
[    0.306400] hpet0: 4 comparators, 64-bit 25.000000 MHz counter
[    0.308015] Switching to clocksource hpet
[    0.317733] pnp: PnP ACPI init
[    0.317758] ACPI: bus type pnp registered
[    0.317906] pnp 00:00: [bus 00-ff]
[    0.317910] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.317918] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.317921] pnp 00:00: [io  0x0d00-0xffff window]
[    0.317924] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.317927] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    0.317930] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    0.317934] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    0.317937] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    0.317940] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    0.317943] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    0.317946] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    0.317949] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    0.317952] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    0.317955] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    0.317958] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    0.317961] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    0.317965] pnp 00:00: [mem 0x000f0000-0x000fffff window]
[    0.317968] pnp 00:00: [mem 0xc0000000-0xfebfffff window]
[    0.318043] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (a=
ctive)
[    0.318071] pnp 00:01: [mem 0x00000000-0xffffffffffffffff disabled]
[    0.318074] pnp 00:01: [mem 0xf0000000-0xf3ffffff]
[    0.318139] system 00:01: [mem 0xf0000000-0xf3ffffff] has been reserved
[    0.318145] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.318163] pnp 00:02: [io  0x0300-0x031f]
[    0.318180] pnp 00:02: [irq 6]
[    0.318210] pnp 00:02: Plug and Play ACPI device, IDs APP0001 (active)
[    0.318263] pnp 00:03: [io  0x0000-0x0008]
[    0.318266] pnp 00:03: [io  0x000a-0x000f]
[    0.318269] pnp 00:03: [io  0x0081-0x0083]
[    0.318272] pnp 00:03: [io  0x0087]
[    0.318275] pnp 00:03: [io  0x0089-0x008b]
[    0.318278] pnp 00:03: [io  0x008f]
[    0.318281] pnp 00:03: [io  0x00c0-0x00d1]
[    0.318284] pnp 00:03: [io  0x00d4-0x00df]
[    0.318287] pnp 00:03: [dma 4]
[    0.318314] pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.318386] pnp 00:04: [irq 0 disabled]
[    0.318395] pnp 00:04: [irq 8]
[    0.318398] pnp 00:04: [mem 0xfed00000-0xfed003ff]
[    0.318444] system 00:04: [mem 0xfed00000-0xfed003ff] has been reserved
[    0.318450] system 00:04: Plug and Play ACPI device, IDs PNP0103 PNP0c01=
 (active)
[    0.318464] pnp 00:05: [io  0x00f0-0x00f1]
[    0.318472] pnp 00:05: [irq 13]
[    0.318499] pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.318646] pnp 00:06: [io  0x0400-0x047f]
[    0.318650] pnp 00:06: [io  0x0480-0x04ff]
[    0.318653] pnp 00:06: [io  0x0500-0x057f]
[    0.318656] pnp 00:06: [io  0x0580-0x05ff]
[    0.318658] pnp 00:06: [io  0x0800-0x087f]
[    0.318661] pnp 00:06: [io  0x0880-0x08ff]
[    0.318664] pnp 00:06: [io  0x0010-0x001f]
[    0.318671] pnp 00:06: [io  0x0022-0x003f]
[    0.318673] pnp 00:06: [io  0x0044-0x005f]
[    0.318676] pnp 00:06: [io  0x0063]
[    0.318679] pnp 00:06: [io  0x0065]
[    0.318682] pnp 00:06: [io  0x0067-0x006f]
[    0.318684] pnp 00:06: [io  0x0072-0x0073]
[    0.318687] pnp 00:06: [io  0x0074-0x007f]
[    0.318690] pnp 00:06: [io  0x0091-0x0093]
[    0.318693] pnp 00:06: [io  0x0097-0x009f]
[    0.318696] pnp 00:06: [io  0x00a2-0x00bf]
[    0.318699] pnp 00:06: [io  0x00e0-0x00ef]
[    0.318701] pnp 00:06: [io  0x04d0-0x04d1]
[    0.318704] pnp 00:06: [io  0x0080]
[    0.318707] pnp 00:06: [io  0x0295-0x0296]
[    0.318766] system 00:06: [io  0x0400-0x047f] has been reserved
[    0.318769] system 00:06: [io  0x0480-0x04ff] has been reserved
[    0.318773] system 00:06: [io  0x0500-0x057f] has been reserved
[    0.318776] system 00:06: [io  0x0580-0x05ff] has been reserved
[    0.318780] system 00:06: [io  0x0800-0x087f] has been reserved
[    0.318783] system 00:06: [io  0x0880-0x08ff] has been reserved
[    0.318787] system 00:06: [io  0x04d0-0x04d1] has been reserved
[    0.318791] system 00:06: [io  0x0295-0x0296] has been reserved
[    0.318796] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.318807] pnp 00:07: [io  0x0070-0x0077]
[    0.318838] pnp 00:07: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.324544] ACPI: EC: GPE storm detected, transactions will use polling =
mode
[    0.368063] pnp: PnP ACPI: found 8 devices
[    0.368066] ACPI: ACPI bus type pnp unregistered
[    0.375541] pci 0000:00:15.0: PCI bridge to [bus 01]
[    0.375557] pci 0000:00:15.0:   bridge window [mem 0xd3100000-0xd31fffff]
[    0.375581] pci 0000:00:17.0: PCI bridge to [bus 02]
[    0.375584] pci 0000:00:17.0:   bridge window [io  0x1000-0x1fff]
[    0.375590] pci 0000:00:17.0:   bridge window [mem 0xd2000000-0xd30fffff]
[    0.375595] pci 0000:00:17.0:   bridge window [mem 0xc0000000-0xd1ffffff=
 64bit pref]
[    0.375789] ACPI: PCI Interrupt Link [Z00J] enabled at IRQ 21
[    0.375811] pci 0000:00:17.0: setting latency timer to 64
[    0.375816] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.375819] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.375823] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.375826] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000c3fff]
[    0.375829] pci_bus 0000:00: resource 8 [mem 0x000c4000-0x000c7fff]
[    0.375832] pci_bus 0000:00: resource 9 [mem 0x000c8000-0x000cbfff]
[    0.375835] pci_bus 0000:00: resource 10 [mem 0x000cc000-0x000cffff]
[    0.375838] pci_bus 0000:00: resource 11 [mem 0x000d0000-0x000d3fff]
[    0.375841] pci_bus 0000:00: resource 12 [mem 0x000d4000-0x000d7fff]
[    0.375844] pci_bus 0000:00: resource 13 [mem 0x000d8000-0x000dbfff]
[    0.375847] pci_bus 0000:00: resource 14 [mem 0x000dc000-0x000dffff]
[    0.375850] pci_bus 0000:00: resource 15 [mem 0x000e0000-0x000e3fff]
[    0.375853] pci_bus 0000:00: resource 16 [mem 0x000e4000-0x000e7fff]
[    0.375856] pci_bus 0000:00: resource 17 [mem 0x000e8000-0x000ebfff]
[    0.375859] pci_bus 0000:00: resource 18 [mem 0x000ec000-0x000effff]
[    0.375862] pci_bus 0000:00: resource 19 [mem 0x000f0000-0x000fffff]
[    0.375865] pci_bus 0000:00: resource 20 [mem 0xc0000000-0xfebfffff]
[    0.375869] pci_bus 0000:01: resource 1 [mem 0xd3100000-0xd31fffff]
[    0.375872] pci_bus 0000:02: resource 0 [io  0x1000-0x1fff]
[    0.375875] pci_bus 0000:02: resource 1 [mem 0xd2000000-0xd30fffff]
[    0.375879] pci_bus 0000:02: resource 2 [mem 0xc0000000-0xd1ffffff 64bit=
 pref]
[    0.375933] NET: Registered protocol family 2
[    0.377213] TCP established hash table entries: 524288 (order: 11, 83886=
08 bytes)
[    0.381795] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.382414] TCP: Hash tables configured (established 524288 bind 65536)
[    0.382504] TCP: reno registered
[    0.382520] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.382571] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.382736] NET: Registered protocol family 1
[    0.383099] ACPI: PCI Interrupt Link [LUS0] enabled at IRQ 17
[    0.434205] ACPI: PCI Interrupt Link [LUS2] enabled at IRQ 23
[    0.434405] ACPI: PCI Interrupt Link [Z000] enabled at IRQ 18
[    0.485196] ACPI: PCI Interrupt Link [Z001] enabled at IRQ 22
[    0.485336] PCI: CLS 256 bytes, default 64
[    0.485410] Unpacking initramfs...
[    1.345382] Freeing initrd memory: 31260k freed
[    1.363365] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.363373] software IO TLB [mem 0xa903d000-0xad03cfff] (64MB) mapped at=
 [ffff8800a903d000-ffff8800ad03cfff]
[    1.364195] Initialise module verification
[    1.364260] audit: initializing netlink socket (disabled)
[    1.364279] type=3D2000 audit(1359155550.364:1): initialized
[    1.397525] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.399895] VFS: Disk quotas dquot_6.5.2
[    1.399959] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.400591] msgmni has been set to 7386
[    1.400683] SELinux:  Registering netfilter hooks
[    1.401385] alg: No test for stdrng (krng)
[    1.401395] NET: Registered protocol family 38
[    1.401400] Key type asymmetric registered
[    1.401403] Asymmetric key parser 'x509' registered
[    1.401453] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 252)
[    1.401489] io scheduler noop registered
[    1.401492] io scheduler deadline registered
[    1.401503] io scheduler cfq registered (default)
[    1.401818] pcieport 0000:00:15.0: irq 40 for MSI/MSI-X
[    1.402061] pcieport 0000:00:15.0: Signaling PME through PCIe PME interr=
upt
[    1.402065] pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
[    1.402075] pcie_pme 0000:00:15.0:pcie01: service driver pcie_pme loaded
[    1.402095] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.402119] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.402121] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    1.402587] efifb: probing for efifb
[    1.404194] efifb: framebuffer at 0xc0010000, mapped to 0xffffc900017800=
00, using 6144k, total 6144k
[    1.404197] efifb: mode is 1366x768x32, linelength=3D8192, pages=3D1
[    1.404199] efifb: scrolling: redraw
[    1.404202] efifb: Truecolor: size=3D8:8:8:8, shift=3D24:16:8:0
[    1.404304] Console: switching to colour frame buffer device 170x48
[    1.408470] fb0: EFI VGA frame buffer device
[    1.408479] intel_idle: does not run on family 6 model 23
[    1.408560] ACPI: AC Adapter [ADP1] (on-line)
[    1.408684] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0=
D:00/input/input0
[    1.408705] ACPI: Lid Switch [LID0]
[    1.408759] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0=
C0C:00/input/input1
[    1.408764] ACPI: Power Button [PWRB]
[    1.408813] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0=
C0E:00/input/input2
[    1.408816] ACPI: Sleep Button [SLPB]
[    1.408884] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input3
[    1.408888] ACPI: Power Button [PWRF]
[    1.409132] ACPI: Requesting acpi_cpufreq
[    1.410671] Monitor-Mwait will be used to enter C-1 state
[    1.410679] Monitor-Mwait will be used to enter C-2 state
[    1.410684] Monitor-Mwait will be used to enter C-3 state
[    1.410688] tsc: Marking TSC unstable due to TSC halts in idle
[    1.410701] ACPI: acpi_idle registered with cpuidle
[    1.507123] GHES: HEST is not enabled!
[    1.507219] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.507894] Non-volatile memory driver v1.3
[    1.507897] Linux agpgart interface v0.103
[    1.508961] loop: module loaded
[    1.509059] ahci 0000:00:0a.0: version 3.0
[    1.509241] ACPI: PCI Interrupt Link [LSI0] enabled at IRQ 20
[    1.509310] ahci 0000:00:0a.0: irq 41 for MSI/MSI-X
[    1.509348] ahci 0000:00:0a.0: AHCI 0001.0300 32 slots 1 ports 3 Gbps 0x=
1 impl SATA mode
[    1.509353] ahci 0000:00:0a.0: flags: 64bit ncq sntf pm led pio slum par=
t apst=20
[    1.509359] ahci 0000:00:0a.0: setting latency timer to 64
[    1.509588] scsi0 : ahci
[    1.509661] ata1: SATA max UDMA/133 abar m8192@0xd3284000 port 0xd328410=
0 irq 41
[    1.509777] libphy: Fixed MDIO Bus: probed
[    1.509842] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.509874] ehci_hcd 0000:00:04.1: setting latency timer to 64
[    1.509878] ehci_hcd 0000:00:04.1: EHCI Host Controller
[    1.509938] ehci_hcd 0000:00:04.1: new USB bus registered, assigned bus =
number 1
[    1.509951] ehci_hcd 0000:00:04.1: debug port 1
[    1.509976] ehci_hcd 0000:00:04.1: disable lpm/ppcd for nvidia mcp89
[    1.530022] ehci_hcd 0000:00:04.1: cache line size of 256 is not support=
ed
[    1.530041] ehci_hcd 0000:00:04.1: irq 23, io mem 0xd328b100
[    1.536021] ehci_hcd 0000:00:04.1: USB 2.0 started, EHCI 1.10
[    1.536061] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    1.536065] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    1.536068] usb usb1: Product: EHCI Host Controller
[    1.536071] usb usb1: Manufacturer: Linux 3.7.4-204.fc18.x86_64 ehci_hcd
[    1.536074] usb usb1: SerialNumber: 0000:00:04.1
[    1.536217] hub 1-0:1.0: USB hub found
[    1.536223] hub 1-0:1.0: 6 ports detected
[    1.536760] ehci_hcd 0000:00:06.1: setting latency timer to 64
[    1.536765] ehci_hcd 0000:00:06.1: EHCI Host Controller
[    1.536815] ehci_hcd 0000:00:06.1: new USB bus registered, assigned bus =
number 2
[    1.536826] ehci_hcd 0000:00:06.1: debug port 1
[    1.536844] ehci_hcd 0000:00:06.1: disable lpm/ppcd for nvidia mcp89
[    1.557025] ehci_hcd 0000:00:06.1: cache line size of 256 is not support=
ed
[    1.557047] ehci_hcd 0000:00:06.1: irq 22, io mem 0xd328b000
[    1.563027] ehci_hcd 0000:00:06.1: USB 2.0 started, EHCI 1.10
[    1.563057] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    1.563061] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    1.563064] usb usb2: Product: EHCI Host Controller
[    1.563067] usb usb2: Manufacturer: Linux 3.7.4-204.fc18.x86_64 ehci_hcd
[    1.563070] usb usb2: SerialNumber: 0000:00:06.1
[    1.563209] hub 2-0:1.0: USB hub found
[    1.563214] hub 2-0:1.0: 6 ports detected
[    1.563722] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.563751] ohci_hcd 0000:00:04.0: setting latency timer to 64
[    1.563755] ohci_hcd 0000:00:04.0: OHCI Host Controller
[    1.563810] ohci_hcd 0000:00:04.0: new USB bus registered, assigned bus =
number 3
[    1.563837] ohci_hcd 0000:00:04.0: irq 17, io mem 0xd328a000
[    1.616038] usb usb3: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    1.616042] usb usb3: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    1.616045] usb usb3: Product: OHCI Host Controller
[    1.616048] usb usb3: Manufacturer: Linux 3.7.4-204.fc18.x86_64 ohci_hcd
[    1.616051] usb usb3: SerialNumber: 0000:00:04.0
[    1.616189] hub 3-0:1.0: USB hub found
[    1.616196] hub 3-0:1.0: 6 ports detected
[    1.616718] ohci_hcd 0000:00:06.0: setting latency timer to 64
[    1.616723] ohci_hcd 0000:00:06.0: OHCI Host Controller
[    1.616783] ohci_hcd 0000:00:06.0: new USB bus registered, assigned bus =
number 4
[    1.616813] ohci_hcd 0000:00:06.0: irq 18, io mem 0xd3289000
[    1.669049] usb usb4: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    1.669054] usb usb4: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    1.669057] usb usb4: Product: OHCI Host Controller
[    1.669061] usb usb4: Manufacturer: Linux 3.7.4-204.fc18.x86_64 ohci_hcd
[    1.669064] usb usb4: SerialNumber: 0000:00:06.0
[    1.669202] hub 4-0:1.0: USB hub found
[    1.669209] hub 4-0:1.0: 6 ports detected
[    1.669712] uhci_hcd: USB Universal Host Controller Interface driver
[    1.669797] usbcore: registered new interface driver usbserial
[    1.669808] usbcore: registered new interface driver usbserial_generic
[    1.669820] usbserial: USB Serial support registered for generic
[    1.669875] mousedev: PS/2 mouse device common for all mice
[    1.670160] rtc_cmos 00:07: RTC can wake from S4
[    1.670426] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    1.670478] rtc0: alarms up to one year, y3k, 242 bytes nvram, hpet irqs
[    1.670602] device-mapper: uevent: version 1.0.3
[    1.670693] device-mapper: ioctl: 4.23.0-ioctl (2012-07-25) initialised:=
 dm-devel@redhat.com
[    1.670838] cpuidle: using governor ladder
[    1.670903] cpuidle: using governor menu
[    1.671269] EFI Variables Facility v0.08 2004-May-17
[    1.814210] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.885161] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filter=
ed out
[    1.885229] ata1.00: ATA-8: APPLE SSD TS128C, CJAA0201, max UDMA/100
[    1.885232] ata1.00: 236978176 sectors, multi 16: LBA48=20
[    1.895158] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filter=
ed out
[    1.895217] ata1.00: configured for UDMA/100
[    1.952308] usbcore: registered new interface driver usbhid
[    1.952311] usbhid: USB HID core driver
[    1.952342] drop_monitor: Initializing network drop monitor service
[    1.952448] ip_tables: (C) 2000-2006 Netfilter Core Team
[    1.952494] TCP: cubic registered
[    1.952497] Initializing XFRM netlink socket
[    1.952647] NET: Registered protocol family 10
[    1.952874] mip6: Mobile IPv6
[    1.952878] NET: Registered protocol family 17
[    1.953308] PM: Hibernation image not present or could not be loaded.
[    1.953311] Loading module verification certificates
[    1.954863] MODSIGN: Loaded cert 'Fedora kernel signing key: a5c8adf0039=
400029ed2a19f36cec62183cc1480'
[    1.954883] registered taskstats version 1
[    1.955977]   Magic number: 13:456:252
[    1.956157] rtc_cmos 00:07: setting system clock to 2013-01-25 23:12:31 =
UTC (1359155551)
[    2.042101] usb 1-6: new high-speed USB device number 4 using ehci_hcd
[    2.171364] usb 1-6: New USB device found, idVendor=3D05ac, idProduct=3D=
850a
[    2.171376] usb 1-6: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D3
[    2.171383] usb 1-6: Product: Built-in iSight
[    2.171389] usb 1-6: Manufacturer: Apple Inc.
[    2.171395] usb 1-6: SerialNumber: CCGB1CTXMGDF9KF0
[    2.398484] ACPI: Battery Slot [BAT0] (battery present)
[    2.398905] scsi 0:0:0:0: Direct-Access     ATA      APPLE SSD TS128C CJ=
AA PQ: 0 ANSI: 5
[    2.399288] sd 0:0:0:0: [sda] 236978176 512-byte logical blocks: (121 GB=
/113 GiB)
[    2.399389] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.399450] sd 0:0:0:0: [sda] Write Protect is off
[    2.399459] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.399510] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    2.402095]  sda: sda1 sda2 sda3
[    2.402903] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.407329] Freeing unused kernel memory: 1068k freed
[    2.408097] Write protecting the kernel read-only data: 12288k
[    2.422370] Freeing unused kernel memory: 1772k freed
[    2.429094] Freeing unused kernel memory: 1404k freed
[    2.644052] usb 3-3: new full-speed USB device number 2 using ohci_hcd
[    2.767367] systemd[1]: systemd 197 running in system mode. (+PAM +LIBWR=
AP +AUDIT +SELINUX +IMA +SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ)
[    2.767884] systemd[1]: Running in initial RAM disk.
[    2.768328] systemd[1]: No hostname configured.
[    2.768345] systemd[1]: Set hostname to <localhost>.
[    2.768676] systemd[1]: Initializing machine ID from random generator.
[    2.795568] systemd[1]: Starting Encrypted Volumes.
[    2.795614] systemd[1]: Reached target Encrypted Volumes.
[    2.795780] systemd[1]: Starting udev Kernel Socket.
[    2.795869] systemd[1]: Listening on udev Kernel Socket.
[    2.796047] systemd[1]: Starting udev Control Socket.
[    2.796139] systemd[1]: Listening on udev Control Socket.
[    2.796170] systemd[1]: Starting Journal Socket.
[    2.796315] systemd[1]: Listening on Journal Socket.
[    2.796350] systemd[1]: Starting dracut cmdline hook...
[    2.813396] systemd[1]: Started Load Kernel Modules.
[    2.813454] systemd[1]: Starting Journal Service...
[    2.827402] systemd[1]: Started Journal Service.
[    2.827822] systemd[1]: Starting Sockets.
[    2.827861] systemd[1]: Reached target Sockets.
[    2.827898] systemd[1]: Starting Swap.
[    2.827928] systemd[1]: Reached target Swap.
[    2.827955] systemd[1]: Starting Local File Systems.
[    2.827986] systemd[1]: Reached target Local File Systems.
[    2.845037] usb 3-3: New USB device found, idVendor=3D05ac, idProduct=3D=
0242
[    2.845043] usb 3-3: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D0
[    2.845047] usb 3-3: Product: Apple Internal Keyboard / Trackpad
[    2.845050] usb 3-3: Manufacturer: Apple Inc.
[    2.860888] input: Apple Inc. Apple Internal Keyboard / Trackpad as /dev=
ices/pci0000:00/0000:00:04.0/usb3/3-3/3-3:1.0/input/input4
[    2.861018] apple 0003:05AC:0242.0001: input,hidraw0: USB HID v1.11 Keyb=
oard [Apple Inc. Apple Internal Keyboard / Trackpad] on usb-0000:00:04.0-3/=
input0
[    2.873105] apple 0003:05AC:0242.0002: hidraw1: USB HID v1.11 Device [Ap=
ple Inc. Apple Internal Keyboard / Trackpad] on usb-0000:00:04.0-3/input1
[    3.041740] RPC: Registered named UNIX socket transport module.
[    3.041745] RPC: Registered udp transport module.
[    3.041747] RPC: Registered tcp transport module.
[    3.041749] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    3.110664] systemd-udevd[152]: starting version 197
[    3.141041] usb 3-5: new full-speed USB device number 3 using ohci_hcd
[    3.302541] [Firmware Bug]: ACPI(IGPU) defines _DOD but not _DOS
[    3.302669] ACPI: Video Device [IGPU] (multi-head: yes  rom: no  post: n=
o)
[    3.302736] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08=
:00/device:2a/LNXVIDEO:00/input/input5
[    3.323606] [drm] Initialized drm 1.1.0 20060810
[    3.341518] wmi: Mapper loaded
[    3.344050] usb 3-5: New USB device found, idVendor=3D0a5c, idProduct=3D=
4500
[    3.344068] usb 3-5: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D0
[    3.344072] usb 3-5: Product: BRCM2070 Hub
[    3.344075] usb 3-5: Manufacturer: Apple Inc.
[    3.365534] hub 3-5:1.0: USB hub found
[    3.367037] hub 3-5:1.0: 3 ports detected
[    3.371784] checking generic (c0010000 600000) vs hw (c0000000 10000000)
[    3.371789] fb: conflicting fb hw usage nouveaufb vs EFI VGA - removing =
generic driver
[    2.399548] ACPI: Invalid Power Resource to register!
[    3.371830] Console: switching=20
[    3.371832] to colour dummy device 80x25
[    3.372039] nouveau 0000:02:00.0: setting latency timer to 64
[    3.372092] nouveau 0000:02:00.0: enabling device (0006 -> 0007)
[    3.372975] ACPI: PCI Interrupt Link [LGPU] enabled at IRQ 16
[    3.374939] nouveau  [  DEVICE][0000:02:00.0] BOOT0  : 0x0af100a2
[    3.374944] nouveau  [  DEVICE][0000:02:00.0] Chipset: MCP89 (NVAF)
[    3.374948] nouveau  [  DEVICE][0000:02:00.0] Family : NV50
[    3.379205] nouveau  [   VBIOS][0000:02:00.0] checking PRAMIN for image.=
=2E.
[    3.440348] nouveau  [   VBIOS][0000:02:00.0] ... appears to be valid
[    3.440364] nouveau  [   VBIOS][0000:02:00.0] using image from PRAMIN
[    3.440523] nouveau  [   VBIOS][0000:02:00.0] BIT signature found
[    3.440528] nouveau  [   VBIOS][0000:02:00.0] version 70.89.13.00
[    3.460965] nouveau  [     MXM][0000:02:00.0] no VBIOS data, nothing to =
do
[    3.544024] nouveau  [     PFB][0000:02:00.0] RAM type: stolen system me=
mory
[    3.544027] nouveau  [     PFB][0000:02:00.0] RAM size: 256 MiB
[    3.737053] usb 3-5.1: new full-speed USB device number 4 using ohci_hcd
[    3.837045] usb 3-5.1: New USB device found, idVendor=3D05ac, idProduct=
=3D820a
[    3.837050] usb 3-5.1: New USB device strings: Mfr=3D0, Product=3D0, Ser=
ialNumber=3D0
[    3.847448] input: HID 05ac:820a as /devices/pci0000:00/0000:00:04.0/usb=
3/3-5/3-5.1/3-5.1:1.0/input/input6
[    3.847550] hid-generic 0003:05AC:820A.0003: input,hidraw2: USB HID v1.1=
1 Keyboard [HID 05ac:820a] on usb-0000:00:04.0-5.1/input0
[    3.917044] usb 3-5.2: new full-speed USB device number 5 using ohci_hcd
[    4.017070] usb 3-5.2: New USB device found, idVendor=3D05ac, idProduct=
=3D820b
[    4.017080] usb 3-5.2: New USB device strings: Mfr=3D0, Product=3D0, Ser=
ialNumber=3D0
[    4.027368] input: HID 05ac:820b as /devices/pci0000:00/0000:00:04.0/usb=
3/3-5/3-5.2/3-5.2:1.0/input/input7
[    4.027496] hid-generic 0003:05AC:820B.0004: input,hidraw3: USB HID v1.1=
1 Mouse [HID 05ac:820b] on usb-0000:00:04.0-5.2/input0
[    4.097049] usb 3-5.3: new full-speed USB device number 6 using ohci_hcd
[    4.194091] nouveau W[    PCE0][0000:02:00.0] disabled, PCE0=3D1 to enab=
le
[    4.194243] [TTM] Zone  kernel: Available graphics memory: 1893108 kiB
[    4.194246] [TTM] Initializing pool allocator
[    4.194252] [TTM] Initializing DMA pool allocator
[    4.196493] nouveau  [     DRM] VRAM: 256 MiB
[    4.196498] nouveau  [     DRM] GART: 512 MiB
[    4.196504] nouveau  [     DRM] BIT BIOS found
[    4.196508] nouveau  [     DRM] Bios version 70.89.13.00
[    4.196513] nouveau  [     DRM] TMDS table version 2.0
[    4.196516] nouveau  [     DRM] DCB version 4.0
[    4.196519] nouveau  [     DRM] DCB outp 00: 040001b6 0f220010
[    4.196523] nouveau  [     DRM] DCB outp 01: 020112a6 0f220010
[    4.196525] nouveau  [     DRM] DCB outp 02: 02011262 00020010
[    4.196528] nouveau  [     DRM] DCB conn 00: 00002047
[    4.196532] nouveau  [     DRM] DCB conn 01: 00101146
[    4.207041] usb 3-5.3: New USB device found, idVendor=3D05ac, idProduct=
=3D821b
[    4.207046] usb 3-5.3: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[    4.207050] usb 3-5.3: Product: Bluetooth USB Host Controller
[    4.207053] usb 3-5.3: Manufacturer: Apple Inc.
[    4.209493] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    4.209496] [drm] No driver support for vblank timestamp query.
[    5.388754] nouveau  [     DRM] 4 available performance level(s)
[    5.388761] nouveau  [     DRM] 0: core 405MHz shader 405MHz memory 405M=
Hz voltage 900mV
[    5.388766] nouveau  [     DRM] 1: core 450MHz shader 810MHz memory 450M=
Hz voltage 900mV
[    5.388771] nouveau  [     DRM] 2: core 450MHz shader 810MHz memory 450M=
Hz voltage 900mV
[    5.388775] nouveau  [     DRM] 3: core 450MHz shader 950MHz memory 450M=
Hz voltage 900mV
[    5.388779] nouveau  [     DRM] c: core 405MHz shader 810MHz
[    5.389007] [sched_delayed] sched: RT throttling activated
[    5.489302] nouveau  [     DRM] MM: using M2MF for buffer copies
[    5.533072] nouveau  [     DRM] allocated 1366x768 fb: 0x50000, bo ffff8=
80133267400
[    5.533176] fbcon: nouveaufb (fb0) is primary device
[    5.576320] Console: switching to colour frame buffer device 170x48
[    5.578601] fb0: nouveaufb frame buffer device
[    5.578604] drm: registered panic notifier
[    5.578609] [drm] Initialized nouveau 1.1.0 20120801 for 0000:02:00.0 on=
 minor 0
[    5.718328] bio: create slab <bio-1> at 1
[    5.797363] EXT4-fs (dm-1): mounted filesystem with ordered data mode. O=
pts: (null)
[    5.891448] EXT4-fs (dm-1): mounted filesystem with ordered data mode. O=
pts: (null)
[    6.267334] systemd-journald[56]: Received SIGTERM
[    6.405217] type=3D1404 audit(1359155555.948:2): enforcing=3D1 old_enfor=
cing=3D0 auid=3D4294967295 ses=3D4294967295
[    6.463845] SELinux: 2048 avtab hash slots, 94354 rules.
[    6.487848] SELinux: 2048 avtab hash slots, 94354 rules.
[    6.775847] SELinux:  9 users, 15 roles, 4357 types, 236 bools, 1 sens, =
1024 cats
[    6.775853] SELinux:  83 classes, 94354 rules
[    6.783237] SELinux:  Completing initialization.
[    6.783241] SELinux:  Setting up existing superblocks.
[    6.783251] SELinux: initialized (dev sysfs, type sysfs), uses genfs_con=
texts
[    6.783258] SELinux: initialized (dev rootfs, type rootfs), uses genfs_c=
ontexts
[    6.783277] SELinux: initialized (dev bdev, type bdev), uses genfs_conte=
xts
[    6.783284] SELinux: initialized (dev proc, type proc), uses genfs_conte=
xts
[    6.783298] SELinux: initialized (dev tmpfs, type tmpfs), uses transitio=
n SIDs
[    6.783325] SELinux: initialized (dev devtmpfs, type devtmpfs), uses tra=
nsition SIDs
[    6.784508] SELinux: initialized (dev sockfs, type sockfs), uses task SI=
Ds
[    6.784515] SELinux: initialized (dev debugfs, type debugfs), uses genfs=
_contexts
[    6.786935] SELinux: initialized (dev pipefs, type pipefs), uses task SI=
Ds
[    6.786945] SELinux: initialized (dev anon_inodefs, type anon_inodefs), =
uses genfs_contexts
[    6.786950] SELinux: initialized (dev devpts, type devpts), uses transit=
ion SIDs
[    6.786974] SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses t=
ransition SIDs
[    6.786986] SELinux: initialized (dev mqueue, type mqueue), uses transit=
ion SIDs
[    6.786996] SELinux: initialized (dev selinuxfs, type selinuxfs), uses g=
enfs_contexts
[    6.787037] SELinux: initialized (dev sysfs, type sysfs), uses genfs_con=
texts
[    6.787994] SELinux: initialized (dev securityfs, type securityfs), uses=
 genfs_contexts
[    6.788000] SELinux: initialized (dev efivarfs, type efivarfs), uses gen=
fs_contexts
[    6.788033] SELinux: initialized (dev tmpfs, type tmpfs), uses transitio=
n SIDs
[    6.788042] SELinux: initialized (dev tmpfs, type tmpfs), uses transitio=
n SIDs
[    6.788191] SELinux: initialized (dev tmpfs, type tmpfs), uses transitio=
n SIDs
[    6.788235] SELinux: initialized (dev cgroup, type cgroup), uses genfs_c=
ontexts
[    6.788242] SELinux: initialized (dev cgroup, type cgroup), uses genfs_c=
ontexts
[    6.788256] SELinux: initialized (dev cgroup, type cgroup), uses genfs_c=
ontexts
[    6.788298] SELinux: initialized (dev cgroup, type cgroup), uses genfs_c=
ontexts
[    6.788315] SELinux: initialized (dev cgroup, type cgroup), uses genfs_c=
ontexts
[    6.788324] SELinux: initialized (dev cgroup, type cgroup), uses genfs_c=
ontexts
[    6.788331] SELinux: initialized (dev cgroup, type cgroup), uses genfs_c=
ontexts
[    6.788338] SELinux: initialized (dev cgroup, type cgroup), uses genfs_c=
ontexts
[    6.788354] SELinux: initialized (dev cgroup, type cgroup), uses genfs_c=
ontexts
[    6.788362] SELinux: initialized (dev rpc_pipefs, type rpc_pipefs), uses=
 genfs_contexts
[    6.788379] SELinux: initialized (dev dm-1, type ext4), uses xattr
[    6.823428] type=3D1403 audit(1359155556.366:3): policy loaded auid=3D42=
94967295 ses=3D4294967295
[    6.836130] systemd[1]: Successfully loaded SELinux policy in 436ms 408u=
s.
[    6.902141] systemd[1]: Relabelled /dev and /run in 36ms 284us.
[    7.166735] SELinux: initialized (dev autofs, type autofs), uses genfs_c=
ontexts
[    7.179236] SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses t=
ransition SIDs
[    7.194042] SELinux: initialized (dev tmpfs, type tmpfs), uses transitio=
n SIDs
[    7.278949] systemd-udevd[387]: starting version 197
[    7.318396] EXT4-fs (dm-1): re-mounted. Opts: (null)
[    7.403433] SELinux: initialized (dev configfs, type configfs), uses gen=
fs_contexts
[    7.479986] tun: Universal TUN/TAP device driver, 1.6
[    7.479992] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    7.567056] bcma: bus0: Found chip with id 0xA8D8, rev 0x01 and package =
0x08
[    7.567079] bcma: bus0: Core 0 found: ChipCommon (manuf 0x4BF, id 0x800,=
 rev 0x22, class 0x0)
[    7.567097] bcma: bus0: Core 1 found: IEEE 802.11 (manuf 0x4BF, id 0x812=
, rev 0x17, class 0x0)
[    7.567130] bcma: bus0: Core 2 found: PCIe (manuf 0x4BF, id 0x820, rev 0=
x0F, class 0x0)
[    7.605696] bcma: bus0: Bus registered
[    7.606236] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    7.673226] microcode: CPU0 sig=3D0x1067a, pf=3D0x80, revision=3D0xa07
[    7.677242] media: Linux media interface: v0.10
[    7.678008] microcode: CPU0 updated to revision 0xa0b, date =3D 2010-09-=
28
[    7.696083] Linux video capture interface: v2.00
[    7.718948] uvcvideo: Found UVC 1.00 device Built-in iSight (05ac:850a)
[    7.723855] microcode: CPU1 sig=3D0x1067a, pf=3D0x80, revision=3D0xa07
[    7.724009] microcode: CPU1 updated to revision 0xa0b, date =3D 2010-09-=
28
[    7.733421] input: Built-in iSight as /devices/pci0000:00/0000:00:04.1/u=
sb1/1-6/1-6:1.0/input/input8
[    7.733663] usbcore: registered new interface driver uvcvideo
[    7.733666] USB Video Class driver (1.1.1)
[    7.734176] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    7.817178] Bluetooth: Core ver 2.16
[    7.817205] NET: Registered protocol family 31
[    7.817207] Bluetooth: HCI device and connection manager initialized
[    7.817219] Bluetooth: HCI socket layer initialized
[    7.817222] Bluetooth: L2CAP socket layer initialized
[    7.817231] Bluetooth: SCO socket layer initialized
[    7.828268] usbcore: registered new interface driver btusb
[    7.860170] usb 3-5.1: USB disconnect, device number 4
[    7.883587] input: bcm5974 as /devices/pci0000:00/0000:00:04.0/usb3/3-3/=
3-3:1.2/input/input9
[    7.883958] usbcore: registered new interface driver bcm5974
[    7.957892] cfg80211: Calling CRDA to update world regulatory domain
[    7.986256] snd_hda_intel 0000:00:08.0: enabling device (0000 -> 0002)
[    7.986475] ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 19
[    7.986494] hda_intel: Disabling MSI
[    7.986497] hda_intel: position_fix set to 1 for device 10de:cb89
[    7.986547] snd_hda_intel 0000:00:08.0: setting latency timer to 64
[    8.000454] usb 3-5.2: USB disconnect, device number 5
[    8.002345] ALSA sound/pci/hda/hda_intel.c:1628 Enable delay in RIRB han=
dling
[    8.045195] applesmc: key=3D322 fan=3D1 temp=3D27 index=3D26 acc=3D0 lux=
=3D0 kbd=3D0
[    8.053376] brcmsmac bcma0:0: mfg 4bf core 812 rev 23 class 0 irq 21
[    8.071122] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
[    8.101561] Adding 3801084k swap on /dev/mapper/fedora-swap.  Priority:-=
1 extents:1 across:3801084k SS
[    8.115925] cfg80211: World regulatory domain updated:
[    8.115931] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenn=
a_gain, max_eirp)
[    8.115935] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mB=
i, 2000 mBm)
[    8.115938] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mB=
i, 2000 mBm)
[    8.115941] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mB=
i, 2000 mBm)
[    8.115943] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mB=
i, 2000 mBm)
[    8.115946] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mB=
i, 2000 mBm)
[    8.194410] EXT4-fs (sda2): mounted filesystem with ordered data mode. O=
pts: (null)
[    8.194635] SELinux: initialized (dev sda2, type ext4), uses xattr
[    8.238657] SELinux: initialized (dev sda1, type hfsplus), uses genfs_co=
ntexts
[    8.353790] ALSA sound/pci/hda/hda_auto_parser.c:318 autoconfig: line_ou=
ts=3D2 (0xb/0xa/0x0/0x0/0x0) type:speaker
[    8.353797] ALSA sound/pci/hda/hda_auto_parser.c:322    speaker_outs=3D0=
 (0x0/0x0/0x0/0x0/0x0)
[    8.353801] ALSA sound/pci/hda/hda_auto_parser.c:326    hp_outs=3D1 (0x9=
/0x0/0x0/0x0/0x0)
[    8.353804] ALSA sound/pci/hda/hda_auto_parser.c:327    mono: mono_out=
=3D0x0
[    8.353807] ALSA sound/pci/hda/hda_auto_parser.c:330    dig-out=3D0x10/0=
x0
[    8.353809] ALSA sound/pci/hda/hda_auto_parser.c:331    inputs:
[    8.353813] ALSA sound/pci/hda/hda_auto_parser.c:335      Mic=3D0xd
[    8.590273] input: HDA NVidia HDMI/DP,pcm=3D8 as /devices/pci0000:00/000=
0:00:08.0/sound/card0/input10
[    8.590516] input: HDA NVidia HDMI/DP,pcm=3D7 as /devices/pci0000:00/000=
0:00:08.0/sound/card0/input11
[    8.590728] input: HDA NVidia HDMI/DP,pcm=3D3 as /devices/pci0000:00/000=
0:00:08.0/sound/card0/input12
[    8.590885] input: HDA NVidia Headphone as /devices/pci0000:00/0000:00:0=
8.0/sound/card0/input13
[    9.014335] EXT4-fs (dm-2): mounted filesystem with ordered data mode. O=
pts: (null)
[    9.014348] SELinux: initialized (dev dm-2, type ext4), uses xattr
[    9.209783] systemd-journald[401]: Received SIGUSR1
[    9.639078] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    9.639083] Bluetooth: BNEP filters: protocol multicast
[    9.639095] Bluetooth: BNEP socket layer initialized
[    9.804170] Bluetooth: RFCOMM TTY layer initialized
[    9.804190] Bluetooth: RFCOMM socket layer initialized
[    9.804192] Bluetooth: RFCOMM ver 1.11
[   10.011477] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   10.020372] Loading iSCSI transport class v2.0-870.
[   10.050317] Ebtables v2.0 registered
[   10.067435] iscsi: registered transport (tcp)
[   10.180557] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: fal=
se (implement)
[   10.180571] ieee80211 phy0: brcms_ops_config: change power-save mode: fa=
lse (implement)
[   10.183295] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   10.235601] iscsi: registered transport (iser)
[   10.275942] libcxgbi:libcxgbi_init_module: tag itt 0x1fff, 13 bits, age =
0xf, 4 bits.
[   10.275948] libcxgbi:ddp_setup_host_page_size: system PAGE 4096, ddp idx=
 0.
[   10.277661] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   10.306515] Chelsio T3 iSCSI Driver cxgb3i v2.0.0 (Jun. 2010)
[   10.309036] iscsi: registered transport (cxgb3i)
[   10.353105] Chelsio T4 iSCSI Driver cxgb4i v0.9.1 (Aug. 2010)
[   10.353242] iscsi: registered transport (cxgb4i)
[   10.372209] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.14 (Sep 30=
, 2012)
[   10.383026] Broadcom NetXtreme II iSCSI Driver bnx2i v2.7.2.2 (Apr 25, 2=
012)
[   10.383489] iscsi: registered transport (bnx2i)
[   10.405985] iscsi: registered transport (be2iscsi)
[   10.405991] In beiscsi_module_init, tt=3Dffffffffa070b000
[   10.895320] nouveau W[    PCE0][0000:02:00.0] disabled, PCE0=3D1 to enab=
le
[   11.859045] nouveau W[    PCE0][0000:02:00.0] disabled, PCE0=3D1 to enab=
le
[   13.360563] nouveau W[    PCE0][0000:02:00.0] disabled, PCE0=3D1 to enab=
le
[   18.045623] CE: hpet increased min_delta_ns to 11520 nsec
[   18.181096] wlan0: authenticate with 10:9a:dd:89:4c:84
[   18.193000] wlan0: direct probe to 10:9a:dd:89:4c:84 (try 1/3)
[   18.259295] CE: hpet increased min_delta_ns to 17280 nsec
[   18.259433] CE: hpet increased min_delta_ns to 25920 nsec
[   18.394057] wlan0: send auth to 10:9a:dd:89:4c:84 (try 2/3)
[   18.394467] wlan0: authenticated
[   18.395050] wlan0: associate with 10:9a:dd:89:4c:84 (try 1/3)
[   18.397777] wlan0: RX AssocResp from 10:9a:dd:89:4c:84 (capab=3D0x511 st=
atus=3D0 aid=3D3)
[   18.398221] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associ=
ated
[   18.398233] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: e=
nabled true, count 0 (implement)
[   18.398237] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: tru=
e (implement)
[   18.398262] wlan0: associated
[   18.398346] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   18.398470] cfg80211: Calling CRDA for country: FI
[   18.408602] cfg80211: Regulatory domain changed to country: FI
[   18.408608] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenn=
a_gain, max_eirp)
[   18.408611] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2=
000 mBm)
[   18.408614] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2=
000 mBm)
[   18.408616] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2=
000 mBm)
[   18.408619] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2=
700 mBm)
[   18.458090] wlan0: Limiting TX power to 30 (30 - 0) dBm as advertised by=
 10:9a:dd:89:4c:84
[   18.568738] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: e=
nabled true, count 1 (implement)
[   21.152455] cgroup: libvirtd (1270) created nested cgroup for controller=
 "memory" which has incomplete hierarchy support. Nested cgroups may change=
 behavior in the future.
[   21.152459] cgroup: "memory" requires setting use_hierarchy to 1 on the =
root.
[   21.152546] cgroup: libvirtd (1270) created nested cgroup for controller=
 "devices" which has incomplete hierarchy support. Nested cgroups may chang=
e behavior in the future.
[   21.152595] cgroup: libvirtd (1270) created nested cgroup for controller=
 "freezer" which has incomplete hierarchy support. Nested cgroups may chang=
e behavior in the future.
[   21.152644] cgroup: libvirtd (1270) created nested cgroup for controller=
 "blkio" which has incomplete hierarchy support. Nested cgroups may change =
behavior in the future.
[   27.563648] fuse init (API version 7.20)
[   27.585846] SELinux: initialized (dev fuse, type fuse), uses genfs_conte=
xts
[   27.613321] SELinux: initialized (dev fusectl, type fusectl), uses genfs=
_contexts
[   29.112123] nouveau W[    PCE0][0000:02:00.0] disabled, PCE0=3D1 to enab=
le
[   38.604064] ------------[ cut here ]------------
[   38.604098] WARNING: at drivers/net/wireless/brcm80211/brcmsmac/main.c:7=
993 brcms_c_wait_for_tx_completion+0x99/0xb0 [brcmsmac]()
[   38.604100] Hardware name: MacBookAir3,1
[   38.604102] Modules linked in: fuse ebtable_nat ipt_MASQUERADE nf_conntr=
ack_netbios_ns nf_conntrack_broadcast ip6table_mangle ip6t_REJECT nf_conntr=
ack_ipv6 nf_defrag_ipv6 iptable_nat nf_nat_ipv4 nf_nat iptable_mangle be2is=
csi iscsi_boot_sysfs bnx2i cnic uio cxgb4i nf_conntrack_ipv4 cxgb4 nf_defra=
g_ipv4 cxgb3i xt_conntrack cxgb3 mdio libcxgbi nf_conntrack ib_iser rdma_cm=
 ib_addr iw_cm ib_cm ib_sa ib_mad ib_core iscsi_tcp ebtable_filter libiscsi=
_tcp ebtables libiscsi scsi_transport_iscsi ip6table_filter ip6_tables rfco=
mm bnep snd_hda_codec_hdmi snd_hda_codec_cirrus nls_utf8 hfsplus arc4 brcms=
mac cordic brcmutil mac80211 snd_hda_intel snd_hda_codec cfg80211 snd_hwdep=
 snd_seq snd_seq_device bcm5974 btusb bluetooth rfkill applesmc input_polld=
ev snd_pcm coretemp uvcvideo videobuf2_vmalloc videobuf2_memops
[   38.604161]  videobuf2_core videodev media microcode snd_page_alloc snd_=
timer shpchp snd bcma soundcore vhost_net tun apple_bl macvtap macvlan kvm_=
intel kvm uinput nouveau mxm_wmi wmi i2c_algo_bit drm_kms_helper ttm drm i2=
c_core video sunrpc
[   38.604189] Pid: 44, comm: kworker/u:1 Not tainted 3.7.4-204.fc18.x86_64=
 #1
[   38.604192] Call Trace:
[   38.604202]  [<ffffffff8105e67f>] warn_slowpath_common+0x7f/0xc0
[   38.604206]  [<ffffffff8105e6da>] warn_slowpath_null+0x1a/0x20
[   38.604219]  [<ffffffffa04cdc99>] brcms_c_wait_for_tx_completion+0x99/0x=
b0 [brcmsmac]
[   38.604229]  [<ffffffffa04c06bb>] brcms_ops_flush+0x3b/0x60 [brcmsmac]
[   38.604259]  [<ffffffffa04767ed>] ieee80211_mgd_probe_ap_send+0x13d/0x20=
0 [mac80211]
[   38.604274]  [<ffffffffa03e85ee>] ? cfg80211_cqm_rssi_notify+0x2e/0x40 [=
cfg80211]
[   38.604293]  [<ffffffffa0474b91>] ? ieee80211_cqm_rssi_notify+0x41/0xa0 =
[mac80211]
[   38.604312]  [<ffffffffa0476e5c>] ieee80211_mgd_probe_ap.part.25+0x12c/0=
x150 [mac80211]
[   38.604331]  [<ffffffffa0476eaa>] ieee80211_sta_monitor_work+0x2a/0x30 [=
mac80211]
[   38.604337]  [<ffffffff8107a487>] process_one_work+0x147/0x490
[   38.604355]  [<ffffffffa0476e80>] ? ieee80211_mgd_probe_ap.part.25+0x150=
/0x150 [mac80211]
[   38.604360]  [<ffffffff8107cd1e>] worker_thread+0x15e/0x450
[   38.604364]  [<ffffffff8107cbc0>] ? busy_worker_rebind_fn+0x110/0x110
[   38.604369]  [<ffffffff81081c80>] kthread+0xc0/0xd0
[   38.604375]  [<ffffffff81010000>] ? ftrace_raw_event_xen_mmu_flush_tlb_o=
thers+0x50/0xe0
[   38.604379]  [<ffffffff81081bc0>] ? kthread_create_on_node+0x120/0x120
[   38.604385]  [<ffffffff8163dfac>] ret_from_fork+0x7c/0xb0
[   38.604389]  [<ffffffff81081bc0>] ? kthread_create_on_node+0x120/0x120
[   38.604392] ---[ end trace aab1c94ad65a5b11 ]---
[   70.980129] SELinux: initialized (dev binfmt_misc, type binfmt_misc), us=
es genfs_contexts
[   99.170951] nouveau W[    PCE0][0000:02:00.0] disabled, PCE0=3D1 to enab=
le

--=20
balbi

--n8g4imXOkfNTN/H1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRAxJUAAoJEIaOsuA1yqREQ4sP/2WuDt2cySY+a0tmbRVdaTuC
anX2e/GAFqp48JwDMqPTgyTq2W1PTWFn6XUqQbbj30A1H42EN+letkqD1j9e83Nx
irrzip7MgaOOx+Ot1mXeAQEsdWA1UOwcLCmj2bGlk5XoQIMETYHJZBgXZNEoyzRW
7piqT8hoeOQ+YMhCzExS0LYo1x53WSqFscX3w5ljyRC2/0PAn8fIWCTqXn40xPaf
irYvQ1qYxcT372fLV7KQBYVvznwsuZMZxFrmZEtiUKaW7C97PytWP0oOaxzA6ECD
sjEw8VCMJ+/YuqHwCkmwUnEzWhOfBUXZydysqbp5TsHU1MrcoTEyUI1fVeBRiulO
FfNb475lcePN3YG30EmKu0wAWExTzdraiT0vYfgzlFBWzP8ic3Yn5Nbx/l2fKlZQ
oUB5X51eGVT8YIEaXHsGZlHSvvwmfp8zKYsxxxCB562LRIZEyVlblrVG4I3Lri6X
CjnSuCZnUtaZfvL61sycUIUMTovPoD9Wruz+IHOyGWx1roOMMKgg52IsUt978F/i
3Ho/1BHYhZGFjzqvKhppfBd5qfwgRE6kzjkWw2lUUqr0sG468UfKBuNtSRMFMAE3
mhg3UrrLeEs0rrxe8HZM1vkBVvdCJ7YBIr2fYFPu34e3B8T7B69tYboHukUwha0A
+Cr4AgiqYw1WdjVVBWiI
=5rft
-----END PGP SIGNATURE-----

--n8g4imXOkfNTN/H1--
