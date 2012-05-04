Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from latitanza.investici.org ([82.94.249.234]:27333 "EHLO
	latitanza.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433Ab2EDGgD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 May 2012 02:36:03 -0400
Date: Fri, 4 May 2012 08:36:45 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Venkataraman, Meenakshi" <meenakshi.venkataraman@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iwlwifi warn_slowpath with 3.*
Message-ID: <20120504063644.GA2912@ritirata.org> (sfid-20120504_083613_438419_E95BD89E)
References: <CANUX_P0UYx_-PS8BUGO10Cwrm6LuhMu4Vyhad4RL-Jn6YqE-Pg@mail.gmail.com>
 <20120502153914.GA9285@tuxdriver.com>
 <20120502162100.GA2528@ritirata.org>
 <20120503065351.GB2307@ritirata.org>
 <CANUX_P03yeuU7gpXbdPVeUBnco4Cz8v78e00x+SgYbhD5K8B5w@mail.gmail.com>
 <CANUX_P0zRjSy9LOVzkWtboqAsvkD4O6EcEXLo11W1Sbb307OJQ@mail.gmail.com>
 <20120503200948.GC11326@ritirata.org>
 <CANUX_P0DL+_V8RO-CNXQx=oHF0T-opO=uw-ukYOjjVgo_OyfUw@mail.gmail.com>
 <20120504002136.GA4201@ritirata.org>
 <CANUX_P1Ji6H0zaA_kMHx2F1AD+czB=XtrDhjEvR8t1aCDpZhUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="St7VIuEGZ6dlpu13"
In-Reply-To: <CANUX_P1Ji6H0zaA_kMHx2F1AD+czB=XtrDhjEvR8t1aCDpZhUQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--St7VIuEGZ6dlpu13
Content-Type: multipart/mixed; boundary="cNdxnHkX5QqsyA0e"
Content-Disposition: inline


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

ops... my fault

On Fri, May 04, 2012 at 08:11:54 +0300, Emmanuel Grumbach wrote:
> nothing attaced
>=20
> Emmanuel Grumbach
> egrumbach@gmail.com
>=20
>=20
> On Fri, May 4, 2012 at 3:21 AM, Antonio Quartulli <ordex@autistici.org> w=
rote:
> > mhmmm I attached dmesg again. Do you really need messages?
> >
> > Cheers,
> >
> >
> > On Thu, May 03, 2012 at 11:17:14 +0300, Emmanuel Grumbach wrote:
> >> ooops
> >>
> >>
> >> here it is
> >>
> >>
> >>
> >> Emmanuel Grumbach
> >> egrumbach@gmail.com
> >>
> >>
> >> On Thu, May 3, 2012 at 11:09 PM, Antonio Quartulli <ordex@autistici.or=
g> wrote:
> >> > On Thu, May 03, 2012 at 10:55:12PM +0300, Emmanuel Grumbach wrote:
> >> >> Hi
> >> >>
> >> >> can you please apply the patch attached against wireless-testing ?
> >> >
> >> > which patch? If you refer to the patch attached to the bugreport, it=
 doesn't
> >> > apply on wireless-testing.
> >> >
> >> >
> >> > Cheers,
> >> >
> >> >>
> >> >> You will have quite a lot of prints, so you will probably need to s=
end
> >> >> /var/log/syslog or messages
> >> >>
> >> >>
> >> >> Thanks
> >> >>
> >> >> Emmanuel Grumbach
> >> >> egrumbach@gmail.com
> >> >>
> >> >>
> >> >> On Thu, May 3, 2012 at 10:04 PM, Emmanuel Grumbach <egrumbach@gmail=
=2Ecom> wrote:
> >> >> > Please enable CONFIG_FRAME_POINTERS
> >> >> > Emmanuel Grumbach
> >> >> > egrumbach@gmail.com
> >> >> >
> >> >> >
> >> >> > On Thu, May 3, 2012 at 9:53 AM, Antonio Quartulli <ordex@autistic=
i.org> wrote:
> >> >> >> On Wed, May 02, 2012 at 06:21:02PM +0200, Antonio Quartulli wrot=
e:
> >> >> >>> On Wed, May 02, 2012 at 11:39:14AM -0400, John W. Linville wrot=
e:
> >> >> >>> > On Wed, May 02, 2012 at 10:08:46AM +0300, Emmanuel Grumbach w=
rote:
> >> >> >>> > > On Wed, May 2, 2012 at 12:19 AM, Venkataraman, Meenakshi
> >> >> >>> > > <meenakshi.venkataraman@intel.com> wrote:
> >> >> >>> > > > Hi Antonio,
> >> >> >>> > > >
> >> >> >>> > > >>> it seems so. It happens at least once at boot time.
> >> >> >>> > > >>> I will try wireless-testing and see what happens. Then =
I will apply your patch.
> >> >> >>> > > >>
> >> >> >>> > > >>The problem is there either with wireless-testing and with
> >> >> >>> > > >>wireless-testing+your_patch.
> >> >> >>> > > >>
> >> >> >>> > > >>If it can somehow help, I also got several stack trace re=
garding intel_iova
> >> >> >>> > > >>functions. But then the I got kernel panic and I was not =
able to copy the
> >> >> >>> > > >>messages.
> >> >> >>> > > >
> >> >> >>> > > > [MV] Depending on how you set it up, perhaps the stack tr=
ace was saved in one of the syslog files in /var/log/...
> >> >> >>> > > >
> >> >> >>> > > > Thanks!
> >> >> >>> > > > Meenakshi
> >> >> >>> > > >
> >> >> >>> > >
> >> >> >>> > > Can you please re-run with debug=3D1 and send the whole log=
 ?
> >> >> >>> > > This will give a better indication on when the issue occurs.
> >> >> >>> >
> >> >> >>> > Does this help?
> >> >> >>> >
> >> >> >>> > =C2=A0 =C2=A0 https://bugzilla.redhat.com/show_bug.cgi?id=3D8=
15998#c18
> >> >> >>>
> >> >> >>> I applied patch in comment 17 on linux-3.3.4. IT didn't help bu=
t this time I got
> >> >> >>> the WARNING even with debug=3D1. Log is attached.
> >> >> >>>
> >> >> >>
> >> >> >>
> >> >> >> Is there any particular kernel debugging option I could enable t=
o make the log
> >> >> >> more verbose?
> >> >> >>
> >> >> >>
> >> >> >> Cheers,
> >> >> >>
> >> >> >>
> >> >> >>
> >> >> >> --
> >> >> >> Antonio Quartulli
> >> >> >>
> >> >> >> ..each of us alone is worth nothing..
> >> >> >> Ernesto "Che" Guevara
> >> >
> >> > --
> >> > Antonio Quartulli
> >> >
> >> > ..each of us alone is worth nothing..
> >> > Ernesto "Che" Guevara
> >
> >
> >
> > --
> > Antonio Quartulli
> >
> > ..each of us alone is worth nothing..
> > Ernesto "Che" Guevara
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename=dmesg
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 3.4.0-rc5-wl+ (ordex@eagle4) (gcc version 4.6.=
3 (Gentoo 4.6.3 p1.0, pie-0.5.1) ) #25 SMP PREEMPT Thu May 3 23:37:39 CEST =
2012
[    0.000000] Command line: root=3D/dev/sda5 console=3Dtty1 resume=3D/dev/=
sda3 init=3D/usr/bin/systemd
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009a800 (usable)
[    0.000000]  BIOS-e820: 000000000009a800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 0000000020000000 (usable)
[    0.000000]  BIOS-e820: 0000000020000000 - 0000000020200000 (reserved)
[    0.000000]  BIOS-e820: 0000000020200000 - 0000000040000000 (usable)
[    0.000000]  BIOS-e820: 0000000040000000 - 0000000040200000 (reserved)
[    0.000000]  BIOS-e820: 0000000040200000 - 00000000caa83000 (usable)
[    0.000000]  BIOS-e820: 00000000caa83000 - 00000000caac7000 (reserved)
[    0.000000]  BIOS-e820: 00000000caac7000 - 00000000cadb7000 (usable)
[    0.000000]  BIOS-e820: 00000000cadb7000 - 00000000cade7000 (reserved)
[    0.000000]  BIOS-e820: 00000000cade7000 - 00000000cafe7000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cafe7000 - 00000000cafff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cafff000 - 00000000cb000000 (usable)
[    0.000000]  BIOS-e820: 00000000cb800000 - 00000000cfa00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffc00000 - 00000000ffc20000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000012f000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.6 present.
[    0.000000] DMI: Dell Inc. Latitude E5420/0675PR, BIOS A01 04/20/2011
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usab=
le) =3D=3D> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usab=
le)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn =3D 0x12f000 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 080000000 mask FC0000000 write-back
[    0.000000]   2 base 0C0000000 mask FF8000000 write-back
[    0.000000]   3 base 0C8000000 mask FFC000000 write-back
[    0.000000]   4 base 0CB000000 mask FFF000000 uncachable
[    0.000000]   5 base 100000000 mask FE0000000 write-back
[    0.000000]   6 base 120000000 mask FF0000000 write-back
[    0.000000]   7 base 12F000000 mask FFF000000 uncachable
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] e820 update range: 00000000cb000000 - 0000000100000000 (usab=
le) =3D=3D> (reserved)
[    0.000000] last_pfn =3D 0xcb000 max_arch_pfn =3D 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000f1ff0] f1ff0
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff880000095000] 95000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-00000000cb000000
[    0.000000]  0000000000 - 00cb000000 page 2M
[    0.000000] kernel direct mapping tables up to cb000000 @ 1fffb000-20000=
000
[    0.000000] init_memory_mapping: 0000000100000000-000000012f000000
[    0.000000]  0100000000 - 012f000000 page 2M
[    0.000000] kernel direct mapping tables up to 12f000000 @ cadb1000-cadb=
7000
[    0.000000] ACPI: RSDP 00000000000fe300 00024 (v02 DELL  )
[    0.000000] ACPI: XSDT 00000000caffde18 0007C (v01 DELL    CBX3    06222=
004 MSFT 00010013)
[    0.000000] ACPI: FACP 00000000caf87d98 000F4 (v04 DELL    CBX3    06222=
004 MSFT 00010013)
[    0.000000] ACPI Warning: 32/64 FACS address mismatch in FADT - two FACS=
 tables! (20120320/tbfadt-378)
[    0.000000] ACPI Warning: 32/64X FACS address mismatch in FADT - 0xCAFE4=
E40/0x00000000CAFE4D40, using 32 (20120320/tbfadt-502)
[    0.000000] ACPI: DSDT 00000000caf7e018 0864E (v02 INT430 SYSFexxx 00001=
001 INTL 20090903)
[    0.000000] ACPI: FACS 00000000cafe4e40 00040
[    0.000000] ACPI: APIC 00000000caffcf18 000CC (v02 DELL    CBX3    06222=
004 MSFT 00010013)
[    0.000000] ACPI: TCPA 00000000cafe5d18 00032 (v02                 00000=
000      00000000)
[    0.000000] ACPI: ASF! 00000000cafe4a18 000A0 (v32 INTEL  Montevin 00000=
001 TFSM 000F4240)
[    0.000000] ACPI: MCFG 00000000cafe5c98 0003C (v01 DELL   SNDYBRDG 06222=
004 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000cafe5c18 00038 (v01 A M I   PCHHPET 06222=
004 AMI. 00000003)
[    0.000000] ACPI: BOOT 00000000cafe5b98 00028 (v01 DELL   CBX3     06222=
004 AMI  00010013)
[    0.000000] ACPI: SSDT 00000000caf7d818 007C2 (v01  PmRef  Cpu0Ist 00003=
000 INTL 20090903)
[    0.000000] ACPI: SSDT 00000000caf7c018 00996 (v01  PmRef    CpuPm 00003=
000 INTL 20090903)
[    0.000000] ACPI: DMAR 00000000caf87c18 000E8 (v01 INTEL      SNB  00000=
001 INTL 00000001)
[    0.000000] ACPI: SLIC 00000000caf88a18 00176 (v03 DELL    CBX3    06222=
004 MSFT 00010013)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000012f000000
[    0.000000] Initmem setup node 0 0000000000000000-000000012f000000
[    0.000000]   NODE_DATA [000000012eff5000 - 000000012effffff]
[    0.000000]  [ffffea0000000000-ffffea0004bfffff] PMD -> [ffff88012a60000=
0-ffff88012e5fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0012f000
[    0.000000] Movable zone start PFN for each node
[    0.000000] Early memory PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009a
[    0.000000]     0: 0x00000100 -> 0x00020000
[    0.000000]     0: 0x00020200 -> 0x00040000
[    0.000000]     0: 0x00040200 -> 0x000caa83
[    0.000000]     0: 0x000caac7 -> 0x000cadb7
[    0.000000]     0: 0x000cafff -> 0x000cb000
[    0.000000]     0: 0x00100000 -> 0x0012f000
[    0.000000] On node 0 totalpages: 1022206
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3909 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 16320 pages used for memmap
[    0.000000]   DMA32 zone: 809396 pages, LIFO batch:31
[    0.000000]   Normal zone: 3008 pages used for memmap
[    0.000000]   Normal zone: 189504 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x04] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x05] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x06] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x08] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x09] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x0a] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x0b] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x0c] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x0d] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x0e] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x0f] disabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] 16 Processors exceeds NR_CPUS limit of 4
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009a000 - 00000000000=
9b000
[    0.000000] PM: Registered nosave memory: 000000000009b000 - 00000000000=
a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000=
e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 00000000001=
00000
[    0.000000] PM: Registered nosave memory: 0000000020000000 - 00000000202=
00000
[    0.000000] PM: Registered nosave memory: 0000000040000000 - 00000000402=
00000
[    0.000000] PM: Registered nosave memory: 00000000caa83000 - 00000000caa=
c7000
[    0.000000] PM: Registered nosave memory: 00000000cadb7000 - 00000000cad=
e7000
[    0.000000] PM: Registered nosave memory: 00000000cade7000 - 00000000caf=
e7000
[    0.000000] PM: Registered nosave memory: 00000000cafe7000 - 00000000caf=
ff000
[    0.000000] PM: Registered nosave memory: 00000000cb000000 - 00000000cb8=
00000
[    0.000000] PM: Registered nosave memory: 00000000cb800000 - 00000000cfa=
00000
[    0.000000] PM: Registered nosave memory: 00000000cfa00000 - 00000000fed=
1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed=
20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000ffc=
00000
[    0.000000] PM: Registered nosave memory: 00000000ffc00000 - 00000000ffc=
20000
[    0.000000] PM: Registered nosave memory: 00000000ffc20000 - 00000001000=
00000
[    0.000000] Allocating PCI resources starting at cfa00000 (gap: cfa00000=
:2f31c000)
[    0.000000] setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 25 pages/cpu @ffff88012ec00000 s72512 r8192=
 d21696 u524288
[    0.000000] pcpu-alloc: s72512 r8192 d21696 u524288 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3=20
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 1002809
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=3D/dev/sda5 console=3Dtty1 resume=
=3D/dev/sda3 init=3D/usr/bin/systemd
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave/xrstor: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 3946504k/4964352k available (4636k kernel code, 8755=
28k absent, 142320k reserved, 3997k data, 564k init)
[    0.000000] SLUB: Genslabs=3D15, HWalign=3D64, Order=3D0-3, MinObjects=
=3D0, CPUs=3D4, Nodes=3D1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	Dump stacks of tasks blocking RCU-preempt GP.
[    0.000000] NR_IRQS:4352 nr_irqs:712 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty1] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.001000] Detected 2494.323 MHz processor.
[    0.000002] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 4988.64 BogoMIPS (lpj=3D2494323)
[    0.000146] pid_max: default: 32768 minimum: 301
[    0.000239] Security Framework initialized
[    0.000527] Dentry cache hash table entries: 524288 (order: 10, 4194304 =
bytes)
[    0.001436] Inode-cache hash table entries: 262144 (order: 9, 2097152 by=
tes)
[    0.001849] Mount-cache hash table entries: 256
[    0.002048] Initializing cgroup subsys freezer
[    0.002137] CPU: Physical Processor ID: 0
[    0.002206] CPU: Processor Core ID: 0
[    0.002291] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.002292] ENERGY_PERF_BIAS: View and update with x86_energy_perf_polic=
y(8)
[    0.002439] mce: CPU supports 7 MCE banks
[    0.002517] CPU0: Thermal monitoring enabled (TM1)
[    0.002593] using mwait in idle threads.
[    0.002726] ACPI: Core revision 20120320
[    0.006850] DMAR: Host address width 36
[    0.006921] DMAR: DRHD base: 0x000000fed90000 flags: 0x0
[    0.006998] IOMMU 0: reg_base_addr fed90000 ver 1:0 cap c0000020e60262 e=
cap f0101a
[    0.007100] DMAR: DRHD base: 0x000000fed91000 flags: 0x1
[    0.007176] IOMMU 1: reg_base_addr fed91000 ver 1:0 cap c9008020660262 e=
cap f0105a
[    0.007287] DMAR: RMRR base: 0x000000cadc6000 end: 0x000000cadd5fff
[    0.007361] DMAR: RMRR base: 0x000000cb800000 end: 0x000000cf9fffff
[    0.007505] IOAPIC id 2 under DRHD base  0xfed91000 IOMMU 1
[    0.007578] HPET id 0 under DRHD base 0xfed91000
[    0.007650] HPET id 0 under DRHD base 0xfed91000
[    0.007722] HPET id 0 under DRHD base 0xfed91000
[    0.007793] HPET id 0 under DRHD base 0xfed91000
[    0.007866] HPET id 0 under DRHD base 0xfed91000
[    0.007938] HPET id 0 under DRHD base 0xfed91000
[    0.008009] HPET id 0 under DRHD base 0xfed91000
[    0.008080] HPET id 0 under DRHD base 0xfed91000
[    0.008342] Enabled IRQ remapping in xapic mode
[    0.009081] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.019143] CPU0: Intel(R) Core(TM) i5-2520M CPU @ 2.50GHz stepping 07
[    0.121078] Performance Events: PEBS fmt1+, 16-deep LBR, SandyBridge eve=
nts, Intel PMU driver.
[    0.121336] PEBS disabled due to CPU errata.
[    0.121888] ... version:                3
[    0.121958] ... bit width:              48
[    0.122029] ... generic registers:      4
[    0.122101] ... value mask:             0000ffffffffffff
[    0.122174] ... max period:             000000007fffffff
[    0.122247] ... fixed-purpose events:   3
[    0.122318] ... event mask:             000000070000000f
[    0.134088] Booting Node   0, Processors  #1 #2 #3 Ok.
[    0.181341] Brought up 4 CPUs
[    0.181414] Total of 4 processors activated (19954.58 BogoMIPS).
[    0.184185] devtmpfs: initialized
[    0.184403] PM: Registering ACPI NVS region [mem 0xcade7000-0xcafe6fff] =
(2097152 bytes)
[    0.184534] Dell Latitude E5420 series board detected. Selecting PCI-met=
hod for reboots.
[    0.184680] NET: Registered protocol family 16
[    0.184813] kworker/u:0 used greatest stack depth: 6488 bytes left
[    0.184892] kworker/u:0 used greatest stack depth: 5480 bytes left
[    0.185167] ACPI FADT declares the system doesn't support PCIe ASPM, so =
disable it
[    0.185269] ACPI: bus type pci registered
[    0.185419] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000=
-0xfbffffff] (base 0xf8000000)
[    0.185525] PCI: not using MMCONFIG
[    0.185595] PCI: Using configuration type 1 for base access
[    0.185672] dmi type 0xB1 record - unknown flag
[    0.188859] bio: create slab <bio-0> at 0
[    0.189005] ACPI: Added _OSI(Module Device)
[    0.189079] ACPI: Added _OSI(Processor Device)
[    0.189150] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.189223] ACPI: Added _OSI(Processor Aggregator Device)
[    0.190805] ACPI: EC: Look up EC in DSDT
[    0.194669] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.200545] ACPI: SSDT 00000000cadd7718 0067C (v01  PmRef  Cpu0Cst 00003=
001 INTL 20090903)
[    0.201116] ACPI: Dynamic OEM Table Load:
[    0.201263] ACPI: SSDT           (null) 0067C (v01  PmRef  Cpu0Cst 00003=
001 INTL 20090903)
[    0.201658] ACPI: SSDT 00000000cadd8a98 00303 (v01  PmRef    ApIst 00003=
000 INTL 20090903)
[    0.202257] ACPI: Dynamic OEM Table Load:
[    0.202404] ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst 00003=
000 INTL 20090903)
[    0.202675] ACPI: SSDT 00000000cadd6d98 00119 (v01  PmRef    ApCst 00003=
000 INTL 20090903)
[    0.203244] ACPI: Dynamic OEM Table Load:
[    0.203392] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003=
000 INTL 20090903)
[    0.204981] ACPI: Interpreter enabled
[    0.205053] ACPI: (supports S0 S3 S4 S5)
[    0.205294] ACPI: Using IOAPIC for interrupt routing
[    0.205384] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000=
-0xfbffffff] (base 0xf8000000)
[    0.205837] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in ACP=
I motherboard resources
[    0.231235] ACPI: EC: GPE =3D 0x10, I/O: command/status =3D 0x934, data =
=3D 0x930
[    0.231830] ACPI: No dock devices found.
[    0.231904] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.232274] \_SB_.PCI0:_OSC invalid UUID
[    0.232275] _OSC request data:1 8 1f=20
[    0.232280] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    0.232771] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.232846] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.232926] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x00=
0bffff]
[    0.233028] pci_root PNP0A08:00: host bridge window [mem 0xcfa00000-0xfe=
afffff]
[    0.233129] pci_root PNP0A08:00: host bridge window [mem 0xfed40000-0xfe=
d44fff]
[    0.233280] PCI host bridge to bus 0000:00
[    0.233352] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.233426] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.233501] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.233577] pci_bus 0000:00: root bus resource [mem 0xcfa00000-0xfeaffff=
f]
[    0.233653] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed44ff=
f]
[    0.233736] pci 0000:00:00.0: [8086:0104] type 00 class 0x060000
[    0.233773] pci 0000:00:02.0: [8086:0126] type 00 class 0x030000
[    0.233784] pci 0000:00:02.0: reg 10: [mem 0xe2800000-0xe2bfffff 64bit]
[    0.233790] pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff 64bit p=
ref]
[    0.233794] pci 0000:00:02.0: reg 20: [io  0x8000-0x803f]
[    0.233848] pci 0000:00:16.0: [8086:1c3a] type 00 class 0x078000
[    0.233872] pci 0000:00:16.0: reg 10: [mem 0xe5480000-0xe548000f 64bit]
[    0.233953] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.233989] pci 0000:00:1a.0: [8086:1c2d] type 00 class 0x0c0320
[    0.234011] pci 0000:00:1a.0: reg 10: [mem 0xe5450000-0xe54503ff]
[    0.234102] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.234130] pci 0000:00:1b.0: [8086:1c20] type 00 class 0x040300
[    0.234146] pci 0000:00:1b.0: reg 10: [mem 0xe5440000-0xe5443fff 64bit]
[    0.234215] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.234246] pci 0000:00:1c.0: [8086:1c10] type 01 class 0x060400
[    0.234380] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.234419] pci 0000:00:1c.1: [8086:1c12] type 01 class 0x060400
[    0.234549] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.234589] pci 0000:00:1c.2: [8086:1c14] type 01 class 0x060400
[    0.234719] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.234759] pci 0000:00:1c.5: [8086:1c1a] type 01 class 0x060400
[    0.234843] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.234870] pci 0000:00:1c.6: [8086:1c1c] type 01 class 0x060400
[    0.234959] pci 0000:00:1c.6: PME# supported from D0 D3hot D3cold
[    0.234994] pci 0000:00:1d.0: [8086:1c26] type 00 class 0x0c0320
[    0.235016] pci 0000:00:1d.0: reg 10: [mem 0xe5430000-0xe54303ff]
[    0.235107] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.235135] pci 0000:00:1f.0: [8086:1c49] type 00 class 0x060100
[    0.235265] pci 0000:00:1f.2: [8086:1c03] type 00 class 0x010601
[    0.235285] pci 0000:00:1f.2: reg 10: [io  0x80b0-0x80b7]
[    0.235294] pci 0000:00:1f.2: reg 14: [io  0x80a0-0x80a3]
[    0.235302] pci 0000:00:1f.2: reg 18: [io  0x8090-0x8097]
[    0.235310] pci 0000:00:1f.2: reg 1c: [io  0x8080-0x8083]
[    0.235319] pci 0000:00:1f.2: reg 20: [io  0x8060-0x807f]
[    0.235327] pci 0000:00:1f.2: reg 24: [mem 0xe5420000-0xe54207ff]
[    0.235373] pci 0000:00:1f.2: PME# supported from D3hot
[    0.235393] pci 0000:00:1f.3: [8086:1c22] type 00 class 0x0c0500
[    0.235409] pci 0000:00:1f.3: reg 10: [mem 0xe5410000-0xe54100ff 64bit]
[    0.235431] pci 0000:00:1f.3: reg 20: [io  0x8040-0x805f]
[    0.235532] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
[    0.235847] pci 0000:02:00.0: [8086:0082] type 00 class 0x028000
[    0.236012] pci 0000:02:00.0: reg 10: [mem 0xe5300000-0xe5301fff 64bit]
[    0.236715] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.239052] pci 0000:00:1c.1: PCI bridge to [bus 02-02]
[    0.239132] pci 0000:00:1c.1:   bridge window [mem 0xe5300000-0xe53fffff]
[    0.240934] pci 0000:03:00.0: [1217:8134] type 02 class 0x060700
[    0.240977] pci 0000:03:00.0: reg 10: [mem 0xe4030000-0xe4030fff]
[    0.241050] pci 0000:03:00.0: supports D1 D2
[    0.241051] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.241105] pci 0000:00:1c.2: PCI bridge to [bus 03-08]
[    0.241182] pci 0000:00:1c.2:   bridge window [io  0x6000-0x7fff]
[    0.241186] pci 0000:00:1c.2:   bridge window [mem 0xe2c00000-0xe40fffff]
[    0.241193] pci 0000:00:1c.2:   bridge window [mem 0xe0000000-0xe13fffff=
 64bit pref]
[    0.241336] pci 0000:09:00.0: [1217:13f7] type 00 class 0x0c0010
[    0.241371] pci 0000:09:00.0: reg 10: [mem 0xe5230000-0xe5230fff]
[    0.241616] pci 0000:09:00.0: supports D1 D2
[    0.241617] pci 0000:09:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.241702] pci 0000:09:00.1: [1217:8321] type 00 class 0x080501
[    0.241736] pci 0000:09:00.1: reg 10: [mem 0xe5220000-0xe52201ff]
[    0.241988] pci 0000:09:00.1: supports D1 D2
[    0.241989] pci 0000:09:00.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.242073] pci 0000:09:00.2: [1217:8331] type 00 class 0x018000
[    0.242107] pci 0000:09:00.2: reg 10: [mem 0xe5210000-0xe52103ff]
[    0.242154] pci 0000:09:00.2: reg 18: [mem 0xe5200000-0xe52003ff]
[    0.242360] pci 0000:09:00.2: supports D1 D2
[    0.242362] pci 0000:09:00.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.243971] pci 0000:00:1c.5: PCI bridge to [bus 09-09]
[    0.244064] pci 0000:00:1c.5:   bridge window [mem 0xe5200000-0xe52fffff]
[    0.244312] pci 0000:0a:00.0: [14e4:1681] type 00 class 0x020000
[    0.244352] pci 0000:0a:00.0: reg 10: [mem 0xe4110000-0xe411ffff 64bit]
[    0.244383] pci 0000:0a:00.0: reg 18: [mem 0xe4100000-0xe410ffff 64bit]
[    0.244574] pci 0000:0a:00.0: PME# supported from D3hot D3cold
[    0.245943] pci 0000:00:1c.6: PCI bridge to [bus 0a-11]
[    0.246039] pci 0000:00:1c.6:   bridge window [io  0x2000-0x5fff]
[    0.246043] pci 0000:00:1c.6:   bridge window [mem 0xe4100000-0xe51fffff]
[    0.246051] pci 0000:00:1c.6:   bridge window [mem 0xe1400000-0xe24fffff=
 64bit pref]
[    0.246077] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.246175] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.246202] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.246233] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP06._PRT]
[    0.246259] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP07._PRT]
[    0.246292] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
[    0.246355] \_SB_.PCI0:_OSC invalid UUID
[    0.246356] _OSC request data:1 1f 1f=20
[    0.246360]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.246458] \_SB_.PCI0:_OSC invalid UUID
[    0.246459] _OSC request data:1 0 1d=20
[    0.246462]  pci0000:00: ACPI _OSC request failed (AE_ERROR), returned c=
ontrol mask: 0x1d
[    0.246564] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.249768] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 1=
5) *11
[    0.250405] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 11 12 14 1=
5) *10
[    0.251039] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 *3 4 5 6 7 10 12 14 =
15)
[    0.251603] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *11 12 14 =
15)
[    0.252169] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 1=
5) *0, disabled.
[    0.252839] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 1=
5) *0, disabled.
[    0.253511] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 *5 6 7 10 12 14 =
15)
[    0.254076] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 11 12 14 1=
5) *0, disabled.
[    0.254833] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.254947] vgaarb: loaded
[    0.255016] vgaarb: bridge control possible 0000:00:02.0
[    0.255188] SCSI subsystem initialized
[    0.255329] libata version 3.00 loaded.
[    0.255635] wmi: Mapper loaded
[    0.255722] PCI: Using ACPI for IRQ routing
[    0.257913] PCI: pci_cache_line_size set to 64 bytes
[    0.258069] reserve RAM buffer: 000000000009a800 - 000000000009ffff=20
[    0.258071] reserve RAM buffer: 00000000caa83000 - 00000000cbffffff=20
[    0.258074] reserve RAM buffer: 00000000cadb7000 - 00000000cbffffff=20
[    0.258076] reserve RAM buffer: 00000000cb000000 - 00000000cbffffff=20
[    0.258078] reserve RAM buffer: 000000012f000000 - 000000012fffffff=20
[    0.258229] NetLabel: Initializing
[    0.258301] NetLabel:  domain hash size =3D 128
[    0.258371] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    0.258451] NetLabel:  unlabeled traffic allowed by default
[    0.258595] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.259019] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.261108] Switching to clocksource hpet
[    0.261247] pnp: PnP ACPI init
[    0.261325] ACPI: bus type pnp registered
[    0.261631] pnp 00:00: [bus 00-3e]
[    0.261634] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.261635] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.261637] pnp 00:00: [io  0x0d00-0xffff window]
[    0.261639] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.261641] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    0.261642] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    0.261644] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    0.261646] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    0.261647] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    0.261649] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    0.261650] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    0.261652] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    0.261654] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    0.261655] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    0.261657] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    0.261659] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    0.261660] pnp 00:00: [mem 0x000f0000-0x000fffff window]
[    0.261663] pnp 00:00: [mem 0xcfa00000-0xfeafffff window]
[    0.261665] pnp 00:00: [mem 0xfed40000-0xfed44fff window]
[    0.261730] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (a=
ctive)
[    0.261742] pnp 00:01: [io  0x0000-0x001f]
[    0.261744] pnp 00:01: [io  0x0081-0x0091]
[    0.261745] pnp 00:01: [io  0x0093-0x009f]
[    0.261747] pnp 00:01: [io  0x00c0-0x00df]
[    0.261749] pnp 00:01: [dma 4]
[    0.261790] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.261797] pnp 00:02: [mem 0xff000000-0xffffffff]
[    0.261836] pnp 00:02: Plug and Play ACPI device, IDs INT0800 (active)
[    0.261912] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    0.261968] system 00:03: [mem 0xfed00000-0xfed003ff] has been reserved
[    0.262046] system 00:03: Plug and Play ACPI device, IDs PNP0103 PNP0c01=
 (active)
[    0.262055] pnp 00:04: [io  0x00f0]
[    0.262066] pnp 00:04: [irq 13]
[    0.262107] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.262116] pnp 00:05: [io  0x002e-0x002f]
[    0.262118] pnp 00:05: [io  0x004e-0x004f]
[    0.262119] pnp 00:05: [io  0x0061]
[    0.262121] pnp 00:05: [io  0x0063]
[    0.262122] pnp 00:05: [io  0x0065]
[    0.262123] pnp 00:05: [io  0x0067]
[    0.262124] pnp 00:05: [io  0x0070]
[    0.262126] pnp 00:05: [io  0x0080]
[    0.262127] pnp 00:05: [io  0x0092]
[    0.262128] pnp 00:05: [io  0x00b2-0x00b3]
[    0.262130] pnp 00:05: [io  0x0680-0x069f]
[    0.262131] pnp 00:05: [io  0x1000-0x100f]
[    0.262133] pnp 00:05: [io  0xffff]
[    0.262134] pnp 00:05: [io  0xffff]
[    0.262135] pnp 00:05: [io  0x0400-0x047f]
[    0.262137] pnp 00:05: [io  0x0500-0x057f]
[    0.262138] pnp 00:05: [io  0x164e-0x164f]
[    0.262198] system 00:05: [io  0x0680-0x069f] has been reserved
[    0.262315] system 00:05: [io  0x1000-0x100f] has been reserved
[    0.262390] system 00:05: [io  0xffff] has been reserved
[    0.262463] system 00:05: [io  0xffff] has been reserved
[    0.262536] system 00:05: [io  0x0400-0x047f] has been reserved
[    0.262611] system 00:05: [io  0x0500-0x057f] has been reserved
[    0.262685] system 00:05: [io  0x164e-0x164f] has been reserved
[    0.262760] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.262768] pnp 00:06: [io  0x0070-0x0077]
[    0.262775] pnp 00:06: [irq 8]
[    0.262819] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.262828] pnp 00:07: [io  0x0060]
[    0.262829] pnp 00:07: [io  0x0064]
[    0.262835] pnp 00:07: [irq 1]
[    0.262881] pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.263776] pnp 00:08: Plug and Play ACPI device, IDs PNP0401 (disabled)
[    0.263789] pnp 00:09: [irq 12]
[    0.263837] pnp 00:09: Plug and Play ACPI device, IDs DLL049b PNP0f13 (a=
ctive)
[    0.263946] pnp 00:0a: [mem 0xfed1c000-0xfed1ffff]
[    0.263948] pnp 00:0a: [mem 0xfed10000-0xfed17fff]
[    0.263949] pnp 00:0a: [mem 0xfed18000-0xfed18fff]
[    0.263951] pnp 00:0a: [mem 0xfed19000-0xfed19fff]
[    0.263952] pnp 00:0a: [mem 0xf8000000-0xfbffffff]
[    0.263954] pnp 00:0a: [mem 0xfed20000-0xfed3ffff]
[    0.263955] pnp 00:0a: [mem 0xfed90000-0xfed93fff]
[    0.263957] pnp 00:0a: [mem 0xfed45000-0xfed8ffff]
[    0.263958] pnp 00:0a: [mem 0xff000000-0xffffffff]
[    0.263960] pnp 00:0a: [mem 0xfee00000-0xfeefffff]
[    0.263962] pnp 00:0a: [mem 0x00000000-0xffffffffffffffff disabled]
[    0.263963] pnp 00:0a: [mem 0x00000000-0xffffffffffffffff disabled]
[    0.264033] system 00:0a: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.264110] system 00:0a: [mem 0xfed10000-0xfed17fff] has been reserved
[    0.264186] system 00:0a: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.264298] system 00:0a: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.264375] system 00:0a: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.264451] system 00:0a: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.264527] system 00:0a: [mem 0xfed90000-0xfed93fff] has been reserved
[    0.264602] system 00:0a: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.264678] system 00:0a: [mem 0xff000000-0xffffffff] could not be reser=
ved
[    0.264754] system 00:0a: [mem 0xfee00000-0xfeefffff] has been reserved
[    0.264829] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.264890] pnp 00:0b: [irq 23]
[    0.264946] pnp 00:0b: Plug and Play ACPI device, IDs SMO8800 (active)
[    0.266405] pnp 00:0c: [mem 0x20000000-0x201fffff]
[    0.266407] pnp 00:0c: [mem 0x40000000-0x401fffff]
[    0.266486] system 00:0c: [mem 0x20000000-0x201fffff] has been reserved
[    0.266564] system 00:0c: [mem 0x40000000-0x401fffff] has been reserved
[    0.266640] system 00:0c: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.266648] pnp: PnP ACPI: found 13 devices
[    0.266720] ACPI: ACPI bus type pnp unregistered
[    0.275104] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
[    0.275196] pci 0000:00:1c.1: PCI bridge to [bus 02-02]
[    0.275273] pci 0000:00:1c.1:   bridge window [mem 0xe5300000-0xe53fffff]
[    0.275356] pci 0000:03:00.0: res[15]=3D[mem 0x04000000-0x03ffffff pref]=
 get_res_add_size add_size 4000000
[    0.275358] pci 0000:03:00.0: res[16]=3D[mem 0x04000000-0x03ffffff] get_=
res_add_size add_size 4000000
[    0.275361] pci 0000:03:00.0: res[13]=3D[io  0x0100-0x00ff] get_res_add_=
size add_size 100
[    0.275363] pci 0000:03:00.0: res[14]=3D[io  0x0100-0x00ff] get_res_add_=
size add_size 100
[    0.275367] pci 0000:03:00.0: BAR 15: can't assign mem pref (size 0x4000=
000)
[    0.275444] pci 0000:03:00.0: BAR 16: can't assign mem (size 0x4000000)
[    0.275519] pci 0000:03:00.0: BAR 13: assigned [io  0x6000-0x60ff]
[    0.275594] pci 0000:03:00.0: BAR 14: assigned [io  0x6400-0x64ff]
[    0.275670] pci 0000:03:00.0: BAR 16: can't assign mem (size 0x4000000)
[    0.275747] pci 0000:03:00.0: BAR 15: can't assign mem pref (size 0x4000=
000)
[    0.275822] pci 0000:03:00.0: BAR 14: assigned [io  0x6000-0x60ff]
[    0.275897] pci 0000:03:00.0: BAR 13: assigned [io  0x6400-0x64ff]
[    0.275970] pci 0000:03:00.0: CardBus bridge to [bus 04-07]
[    0.276043] pci 0000:03:00.0:   bridge window [io  0x6400-0x64ff]
[    0.276123] pci 0000:03:00.0:   bridge window [io  0x6000-0x60ff]
[    0.276209] pci 0000:00:1c.2: PCI bridge to [bus 03-08]
[    0.276284] pci 0000:00:1c.2:   bridge window [io  0x6000-0x7fff]
[    0.276375] pci 0000:00:1c.2:   bridge window [mem 0xe2c00000-0xe40fffff]
[    0.276454] pci 0000:00:1c.2:   bridge window [mem 0xe0000000-0xe13fffff=
 64bit pref]
[    0.276562] pci 0000:00:1c.5: PCI bridge to [bus 09-09]
[    0.276638] pci 0000:00:1c.5:   bridge window [mem 0xe5200000-0xe52fffff]
[    0.276721] pci 0000:00:1c.6: PCI bridge to [bus 0a-11]
[    0.276796] pci 0000:00:1c.6:   bridge window [io  0x2000-0x5fff]
[    0.276874] pci 0000:00:1c.6:   bridge window [mem 0xe4100000-0xe51fffff]
[    0.276953] pci 0000:00:1c.6:   bridge window [mem 0xe1400000-0xe24fffff=
 64bit pref]
[    0.277102] pci 0000:03:00.0: setting latency timer to 64
[    0.277118] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.277120] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.277121] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.277123] pci_bus 0000:00: resource 7 [mem 0xcfa00000-0xfeafffff]
[    0.277125] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed44fff]
[    0.277127] pci_bus 0000:02: resource 1 [mem 0xe5300000-0xe53fffff]
[    0.277129] pci_bus 0000:03: resource 0 [io  0x6000-0x7fff]
[    0.277131] pci_bus 0000:03: resource 1 [mem 0xe2c00000-0xe40fffff]
[    0.277132] pci_bus 0000:03: resource 2 [mem 0xe0000000-0xe13fffff 64bit=
 pref]
[    0.277134] pci_bus 0000:04: resource 0 [io  0x6400-0x64ff]
[    0.277136] pci_bus 0000:04: resource 1 [io  0x6000-0x60ff]
[    0.277138] pci_bus 0000:09: resource 1 [mem 0xe5200000-0xe52fffff]
[    0.277140] pci_bus 0000:0a: resource 0 [io  0x2000-0x5fff]
[    0.277141] pci_bus 0000:0a: resource 1 [mem 0xe4100000-0xe51fffff]
[    0.277143] pci_bus 0000:0a: resource 2 [mem 0xe1400000-0xe24fffff 64bit=
 pref]
[    0.277170] NET: Registered protocol family 2
[    0.277340] IP route cache hash table entries: 131072 (order: 8, 1048576=
 bytes)
[    0.278030] TCP established hash table entries: 524288 (order: 11, 83886=
08 bytes)
[    0.279309] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.279519] TCP: Hash tables configured (established 524288 bind 65536)
[    0.279594] TCP: reno registered
[    0.279673] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.279764] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.279899] NET: Registered protocol family 1
[    0.279979] pci 0000:00:02.0: Boot video device
[    0.280298] PCI: CLS 64 bytes, default 64
[    0.280317] DMAR: No ATSR found
[    0.280418] IOMMU 0 0xfed90000: using Queued invalidation
[    0.280491] IOMMU 1 0xfed91000: using Queued invalidation
[    0.280564] IOMMU: Setting RMRR:
[    0.280641] IOMMU: Setting identity map for device 0000:00:02.0 [0xcb800=
000 - 0xcf9fffff]
[    0.281115] IOMMU: Setting identity map for device 0000:00:1d.0 [0xcadc6=
000 - 0xcadd5fff]
[    0.281251] IOMMU: Setting identity map for device 0000:00:1a.0 [0xcadc6=
000 - 0xcadd5fff]
[    0.281843] IOMMU: Prepare 0-16MiB unity mapping for LPC
[    0.281922] IOMMU: Setting identity map for device 0000:00:1f.0 [0x0 - 0=
xffffff]
[    0.282273] PCI-DMA: Intel(R) Virtualization Technology for Directed I/O
[    0.282363] ------------[ cut here ]------------
[    0.282438] WARNING: at drivers/pci/search.c:44 pci_find_upstream_pcie_b=
ridge+0x5e/0x70()
[    0.282541] Hardware name: Latitude E5420
[    0.282612] Modules linked in:
[    0.282720] Pid: 1, comm: swapper/0 Not tainted 3.4.0-rc5-wl+ #25
[    0.282795] Call Trace:
[    0.282867]  [<ffffffff8103279a>] warn_slowpath_common+0x7a/0xb0
[    0.282942]  [<ffffffff810327e5>] warn_slowpath_null+0x15/0x20
[    0.283017]  [<ffffffff811fb34e>] pci_find_upstream_pcie_bridge+0x5e/0x70
[    0.283095]  [<ffffffff81377727>] intel_iommu_device_group+0x77/0x100
[    0.283172]  [<ffffffff81371fc5>] add_iommu_group+0x35/0x60
[    0.283254]  [<ffffffff81371f90>] ? bus_set_iommu+0x50/0x50
[    0.283331]  [<ffffffff812ebb0e>] bus_for_each_dev+0x4e/0x80
[    0.283405]  [<ffffffff81371f7b>] bus_set_iommu+0x3b/0x50
[    0.283481]  [<ffffffff818adbc9>] intel_iommu_init+0xa55/0xae4
[    0.283557]  [<ffffffff810fb996>] ? sys_mkdirat+0x76/0xd0
[    0.283634]  [<ffffffff818860b7>] ? memblock_find_dma_reserve+0x13d/0x13d
[    0.283710]  [<ffffffff818860ca>] pci_iommu_init+0x13/0x3e
[    0.283784]  [<ffffffff810001ca>] do_one_initcall+0x3a/0x160
[    0.283859]  [<ffffffff81882c13>] kernel_init+0x143/0x1c7
[    0.283934]  [<ffffffff81882589>] ? do_early_param+0x87/0x87
[    0.284009]  [<ffffffff814844d4>] kernel_thread_helper+0x4/0x10
[    0.284084]  [<ffffffff81882ad0>] ? start_kernel+0x2ed/0x2ed
[    0.284158]  [<ffffffff814844d0>] ? gs_change+0xb/0xb
[    0.284240] ---[ end trace e93713a9d40cd06c ]---
[    0.286000] Simple Boot Flag at 0xf3 set to 0x1
[    0.287015] microcode: CPU0 sig=3D0x206a7, pf=3D0x10, revision=3D0x15
[    0.287095] microcode: CPU1 sig=3D0x206a7, pf=3D0x10, revision=3D0x15
[    0.287186] microcode: CPU2 sig=3D0x206a7, pf=3D0x10, revision=3D0x15
[    0.287274] microcode: CPU3 sig=3D0x206a7, pf=3D0x10, revision=3D0x15
[    0.287417] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    0.288045] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.291060] VFS: Disk quotas dquot_6.5.2
[    0.291271] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.291871] msgmni has been set to 7836
[    0.292320] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 253)
[    0.292425] io scheduler noop registered (default)
[    0.292968] intel_idle: MWAIT substates: 0x21120
[    0.292969] intel_idle: v0.4 model 0x2A
[    0.292970] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.293639] ACPI: AC Adapter [AC] (on-line)
[    0.294152] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:=
00/input/input0
[    0.294556] ACPI: Lid Switch [LID]
[    0.294684] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0=
C:00/input/input1
[    0.294790] ACPI: Power Button [PBTN]
[    0.294915] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0=
E:00/input/input2
[    0.295018] ACPI: Sleep Button [SBTN]
[    0.295140] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input3
[    0.295298] ACPI: Power Button [PWRF]
[    0.295477] ACPI: Requesting acpi_cpufreq
[    0.310310] thermal LNXTHERM:00: registered as thermal_zone0
[    0.310385] ACPI: Thermal Zone [THM] (25 C)
[    0.310694] GHES: HEST is not enabled!
[    0.310860] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.312991] Non-volatile memory driver v1.3
[    0.313124] Linux agpgart interface v0.103
[    0.313362] agpgart-intel 0000:00:00.0: Intel Sandybridge Chipset
[    0.313622] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K tota=
l, 262144K mappable
[    0.315116] agpgart-intel 0000:00:00.0: detected 65536K stolen memory
[    0.315416] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    0.315599] [drm] Initialized drm 1.1.0 20060810
[    0.315975] i915 0000:00:02.0: setting latency timer to 64
[    0.319777] ACPI: Battery Slot [BAT0] (battery present)
[    0.381975] i915 0000:00:02.0: irq 42 for MSI/MSI-X
[    0.381983] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    0.382070] [drm] Driver supports precise vblank timestamp query.
[    0.382180] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=
=3Dio+mem,decodes=3Dio+mem:owns=3Dio+mem
[    0.730482] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[    0.881135] fbcon: inteldrmfb (fb0) is primary device
[    1.285895] Refined TSC clocksource calibration: 2494.333 MHz.
[    1.285903] Switching to clocksource tsc
[    1.377584] Console: switching to colour frame buffer device 170x96
[    1.380291] fb0: inteldrmfb frame buffer device
[    1.380303] drm: registered panic notifier
[    1.396818] acpi device:36: registered as cooling_device4
[    1.403358] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:0=
0/LNXVIDEO:00/input/input4
[    1.403385] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    1.403433] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on mi=
nor 0
[    1.404855] brd: module loaded
[    1.405010] ahci 0000:00:1f.2: version 3.0
[    1.405070] ahci 0000:00:1f.2: irq 43 for MSI/MSI-X
[    1.405098] ahci: SSS flag set, parallel bus scan disabled
[    1.415774] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x=
3b impl SATA mode
[    1.415819] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio=
 slum part ems sxs apst=20
[    1.415844] ahci 0000:00:1f.2: setting latency timer to 64
[    1.424397] scsi0 : ahci
[    1.424488] scsi1 : ahci
[    1.424568] scsi2 : ahci
[    1.424650] scsi3 : ahci
[    1.424747] scsi4 : ahci
[    1.424838] scsi5 : ahci
[    1.425169] ata2: SATA max UDMA/133 abar m2048@0xe5420000 port 0xe542010=
0 irq 43
[    1.425191] ata3: SATA max UDMA/133 abar m2048@0xe5420000 port 0xe542018=
0 irq 43
[    1.425210] ata4: DUMMY
[    1.425221] ata5: SATA max UDMA/133 abar m2048@0xe5420000 port 0xe542028=
0 irq 43
[    1.425241] ata6: SATA max UDMA/133 abar m2048@0xe5420000 port 0xe542030=
0 irq 43
[    1.425261] ata7: SATA max UDMA/133 abar m2048@0xe5420000 port 0xe542038=
0 irq 43
[    1.425511] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0=
x60,0x64 irq 1,12
[    1.425783] i8042: Warning: Keylock active
[    1.427037] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.427058] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.427187] mousedev: PS/2 mouse device common for all mice
[    1.427444] rtc_cmos 00:06: RTC can wake from S4
[    1.427610] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    1.427666] rtc0: alarms up to one year, y3k, 242 bytes nvram, hpet irqs
[    1.427735] ACPI Warning: 0x0000000000008040-0x000000000000805f SystemIO=
 conflicts with Region \_SB_.PCI0.SBUS.SMBI 1 (20120320/utaddress-251)
[    1.427774] ACPI: If an ACPI driver is available for this device, you sh=
ould use it instead of the native driver
[    1.427955] EDAC MC: Ver: 2.1.0
[    1.428309] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input5
[    1.428531] cpuidle: using governor ladder
[    1.428623] cpuidle: using governor menu
[    1.428862] EFI Variables Facility v0.08 2004-May-17
[    1.429332] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    1.443699] input: Dell WMI hotkeys as /devices/virtual/input/input6
[    1.443816] dell_wmi_aio: No known WMI GUID found
[    1.443879] intel_oaktrail: Platform not recognized (You could try the m=
odule's force-parameter)
[    1.444019] TCP: cubic registered
[    1.444034] TCP: vegas registered
[    1.444044] TCP: yeah registered
[    1.444054] Initializing XFRM netlink socket
[    1.444374] NET: Registered protocol family 10
[    1.444575] NET: Registered protocol family 17
[    1.444591] Registering the dns_resolver key type
[    1.444795] PM: Checking hibernation image partition /dev/sda3
[    1.729417] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.731722] ata2.00: ACPI cmd 00/00:00:00:00:00:a0 (unknown) rejected by=
 device (Stat=3D0x51 Err=3D0x04)
[    1.774277] ata2.00: ATA-8: ST9320423AS, D005SDM1, max UDMA/133
[    1.774300] ata2.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    1.777580] ata2.00: ACPI cmd 00/00:00:00:00:00:a0 (unknown) rejected by=
 device (Stat=3D0x51 Err=3D0x04)
[    1.778040] ata2.00: configured for UDMA/133
[    1.779525] scsi 0:0:0:0: Direct-Access     ATA      ST9320423AS      D0=
05 PQ: 0 ANSI: 5
[    1.779908] sd 0:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB=
/298 GiB)
[    1.779973] sd 0:0:0:0: [sda] Write Protect is off
[    1.779989] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.779994] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.780009] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    1.840218]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[    1.841397] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.083874] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.093761] ata3.00: ATAPI: TSSTcorp DVD+/-RW TS-L633J, D400, max UDMA/1=
00
[    2.104215] ata3.00: configured for UDMA/100
[    2.110631] scsi 1:0:0:0: CD-ROM            TSSTcorp DVD+-RW TS-L633J D4=
00 PQ: 0 ANSI: 5
[    2.121220] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 =
cdda tray
[    2.121247] cdrom: Uniform CD-ROM driver Revision: 3.20
[    2.121622] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    2.121721] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    2.426503] ata5: SATA link down (SStatus 0 SControl 300)
[    2.732118] ata6: SATA link down (SStatus 0 SControl 300)
[    3.037724] ata7: SATA link down (SStatus 0 SControl 300)
[    3.038933] PM: Hibernation image partition 8:3 present
[    3.038935] PM: Looking for hibernation image.
[    3.039427] PM: Image not found (code -22)
[    3.039429] PM: Hibernation image not present or could not be loaded.
[    3.039438] registered taskstats version 1
[    3.189591] EXT4-fs (sda5): couldn't mount as ext3 due to feature incomp=
atibilities
[    3.197795] EXT4-fs (sda5): couldn't mount as ext2 due to feature incomp=
atibilities
[    3.202949] EXT4-fs (sda5): INFO: recovery required on readonly filesyst=
em
[    3.204062] EXT4-fs (sda5): write access will be enabled during recovery
[    3.512260] EXT4-fs (sda5): recovery complete
[    3.518172] EXT4-fs (sda5): mounted filesystem with ordered data mode. O=
pts: (null)
[    3.519342] VFS: Mounted root (ext4 filesystem) readonly on device 8:5.
[    3.521267] Freeing unused kernel memory: 564k freed
[    3.522445] Write protecting the kernel read-only data: 8192k
[    3.527251] Freeing unused kernel memory: 1488k freed
[    3.529990] Freeing unused kernel memory: 580k freed
[    5.192505] systemd-getty-g used greatest stack depth: 5120 bytes left
[    6.319201] mount used greatest stack depth: 4656 bytes left
[    6.757747] udevd[857]: starting version 182
[    7.423027] fsck used greatest stack depth: 4568 bytes left
[    7.827934] EXT4-fs (sda5): re-mounted. Opts: (null)
[    8.204586] usbcore: registered new interface driver usbfs
[    8.205466] usbcore: registered new interface driver hub
[    8.206299] usbcore: registered new device driver usb
[    8.227905] cfg80211: Calling CRDA to update world regulatory domain
[    8.262629] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    8.263480] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    8.263485] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    8.264267] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus =
number 1
[    8.265057] ehci_hcd 0000:00:1a.0: debug port 2
[    8.269690] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[    8.269706] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xe5450000
[    8.275853] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    8.276679] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    8.277461] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    8.278269] usb usb1: Product: EHCI Host Controller
[    8.279069] usb usb1: Manufacturer: Linux 3.4.0-rc5-wl+ ehci_hcd
[    8.279860] usb usb1: SerialNumber: 0000:00:1a.0
[    8.280801] hub 1-0:1.0: USB hub found
[    8.281884] hub 1-0:1.0: 2 ports detected
[    8.283048] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    8.283053] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    8.283982] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus =
number 2
[    8.284808] ehci_hcd 0000:00:1d.0: debug port 2
[    8.289476] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[    8.289494] ehci_hcd 0000:00:1d.0: irq 17, io mem 0xe5430000
[    8.295829] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    8.296723] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    8.297545] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    8.298378] usb usb2: Product: EHCI Host Controller
[    8.299232] usb usb2: Manufacturer: Linux 3.4.0-rc5-wl+ ehci_hcd
[    8.300089] usb usb2: SerialNumber: 0000:00:1d.0
[    8.301088] hub 2-0:1.0: USB hub found
[    8.301943] hub 2-0:1.0: 2 ports detected
[    8.436154] snd_hda_intel 0000:00:1b.0: irq 44 for MSI/MSI-X
[    8.477845] iwlwifi: Intel(R) Wireless WiFi Link AGN driver for Linux, i=
n-tree:d
[    8.478751] iwlwifi: Copyright(c) 2003-2012 Intel Corporation
[    8.479837] iwlwifi 0000:02:00.0: pci_resource_len =3D 0x00002000
[    8.480752] iwlwifi 0000:02:00.0: pci_resource_base =3D ffffc90000674000
[    8.481684] iwlwifi 0000:02:00.0: HW Revision ID =3D 0x34
[    8.483002] iwlwifi 0000:02:00.0: irq 45 for MSI/MSI-X
[    8.483107] iwlwifi 0000:02:00.0: U iwl_request_firmware attempting to l=
oad firmware 'iwlwifi-6000g2a-6.ucode'
[    8.512925] iwlwifi 0000:02:00.0: U iwl_request_firmware attempting to l=
oad firmware 'iwlwifi-6000g2a-5.ucode'
[    8.574099] iwlwifi 0000:02:00.0: U iwl_ucode_callback Loaded firmware f=
ile 'iwlwifi-6000g2a-5.ucode' (444128 bytes).
[    8.575070] iwlwifi 0000:02:00.0: loaded firmware version 17.168.5.3 bui=
ld 42301
[    8.575114] iwlwifi 0000:02:00.0: U validate_sec_sizes f/w package hdr r=
untime inst size =3D 149504
[    8.576979] iwlwifi 0000:02:00.0: U validate_sec_sizes f/w package hdr r=
untime data size =3D 81920
[    8.577899] iwlwifi 0000:02:00.0: U validate_sec_sizes f/w package hdr i=
nit inst size =3D 130552
[    8.578849] iwlwifi 0000:02:00.0: U validate_sec_sizes f/w package hdr i=
nit data size =3D 81920
[    8.579892] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_DEBUG enabled
[    8.580802] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_DEBUGFS disabled
[    8.581765] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_DEVICE_TRACING disabled
[    8.582698] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE enabled
[    8.583656] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_P2P enabled
[    8.584577] iwlwifi 0000:02:00.0: U iwl_op_mode_dvm_start *** LOAD DRIVE=
R ***
[    8.585443] usb 1-1: new high-speed USB device number 2 using ehci_hcd
[    8.586480] iwlwifi 0000:02:00.0: U iwl_op_mode_dvm_start BT channel inh=
ibition is On
[    8.587460] iwlwifi 0000:02:00.0: Detected Intel(R) Centrino(R) Advanced=
-N 6205 AGN, REV=3D0xB0
[    8.588422] iwlwifi 0000:02:00.0: U iwl_prepare_card_hw iwl_trans_prepar=
e_card_hw enter
[    8.589404] iwlwifi 0000:02:00.0: U iwl_set_hw_ready hardware ready
[    8.590398] iwlwifi 0000:02:00.0: U iwl_apm_init Init card's basic funct=
ions
[    8.591404] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[    8.609335] iwlwifi 0000:02:00.0: U iwl_apm_stop Stop card, put in low p=
ower state
[    8.610323] iwlwifi 0000:02:00.0: U iwl_apm_stop_master stop master
[    8.611382] iwlwifi 0000:02:00.0: device EEPROM VER=3D0x715, CALIB=3D0x6
[    8.612359] iwlwifi 0000:02:00.0: Device SKU: 0x1F0
[    8.613317] iwlwifi 0000:02:00.0: Valid Tx ant: 0x3, Valid Rx ant: 0x3
[    8.614275] iwlwifi 0000:02:00.0: U iwl_op_mode_dvm_start MAC address: a=
0:88:b4:6f:4e:2c
[    8.615260] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[    8.616253] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 1 Freq=3D2412[=
2.4GHz] valid flag=3D0x20
[    8.617246] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 2 Freq=3D2417[=
2.4GHz] valid flag=3D0x20
[    8.618220] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 3 Freq=3D2422[=
2.4GHz] valid flag=3D0x20
[    8.619209] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 4 Freq=3D2427[=
2.4GHz] valid flag=3D0x20
[    8.620166] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 5 Freq=3D2432[=
2.4GHz] valid flag=3D0x0
[    8.621143] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 6 Freq=3D2437[=
2.4GHz] valid flag=3D0x0
[    8.622085] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 7 Freq=3D2442[=
2.4GHz] valid flag=3D0x0
[    8.623037] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 8 Freq=3D2447[=
2.4GHz] valid flag=3D0x10
[    8.623964] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 9 Freq=3D2452[=
2.4GHz] valid flag=3D0x10
[    8.624910] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 10 Freq=3D2457=
[2.4GHz] valid flag=3D0x10
[    8.625823] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 11 Freq=3D2462=
[2.4GHz] valid flag=3D0x10
[    8.626752] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 12 Freq=3D2467=
[2.4GHz] valid flag=3D0x36
[    8.627648] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 13 Freq=3D2472=
[2.4GHz] valid flag=3D0x36
[    8.628587] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 36 Freq=3D5180=
[5.2GHz] valid flag=3D0x26
[    8.629480] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 40 Freq=3D5200=
[5.2GHz] valid flag=3D0x16
[    8.630382] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 44 Freq=3D5220=
[5.2GHz] valid flag=3D0x26
[    8.631247] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 48 Freq=3D5240=
[5.2GHz] valid flag=3D0x16
[    8.632103] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 52 Freq=3D5260=
[5.2GHz] valid flag=3D0x2E
[    8.633005] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 56 Freq=3D5280=
[5.2GHz] valid flag=3D0x1E
[    8.633859] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 60 Freq=3D5300=
[5.2GHz] valid flag=3D0x2E
[    8.634728] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 64 Freq=3D5320=
[5.2GHz] valid flag=3D0x1E
[    8.635565] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 100 Freq=3D550=
0[5.2GHz] valid flag=3D0x2E
[    8.636437] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 104 Freq=3D552=
0[5.2GHz] valid flag=3D0x1E
[    8.637251] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 108 Freq=3D554=
0[5.2GHz] valid flag=3D0x2E
[    8.638058] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 112 Freq=3D556=
0[5.2GHz] valid flag=3D0x1E
[    8.638889] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 116 Freq=3D558=
0[5.2GHz] valid flag=3D0x2E
[    8.639699] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 120 Freq=3D560=
0[5.2GHz] valid flag=3D0x1E
[    8.640573] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 124 Freq=3D562=
0[5.2GHz] valid flag=3D0x2E
[    8.641346] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 128 Freq=3D564=
0[5.2GHz] valid flag=3D0x1E
[    8.642123] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 132 Freq=3D566=
0[5.2GHz] valid flag=3D0x2E
[    8.642953] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 136 Freq=3D568=
0[5.2GHz] valid flag=3D0x1E
[    8.643733] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 140 Freq=3D570=
0[5.2GHz] valid flag=3D0x3E
[    8.644534] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 149 Freq=3D574=
5[5.2GHz] valid flag=3D0x26
[    8.645293] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 153 Freq=3D576=
5[5.2GHz] valid flag=3D0x16
[    8.646051] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 157 Freq=3D578=
5[5.2GHz] valid flag=3D0x26
[    8.646819] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 161 Freq=3D580=
5[5.2GHz] valid flag=3D0x16
[    8.647540] iwlwifi 0000:02:00.0: U iwl_init_geos Channel 165 Freq=3D582=
5[5.2GHz] valid flag=3D0x36
[    8.648265] iwlwifi 0000:02:00.0: Tunable channels: 13 802.11bg, 24 802.=
11a channels
[    8.649096] Registered led device: phy0-led
[    8.649230] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[    8.701702] usb 1-1: New USB device found, idVendor=3D8087, idProduct=3D=
0024
[    8.702461] usb 1-1: New USB device strings: Mfr=3D0, Product=3D0, Seria=
lNumber=3D0
[    8.703523] hub 1-1:1.0: USB hub found
[    8.704311] hub 1-1:1.0: 6 ports detected
[    8.807193] usb 2-1: new high-speed USB device number 2 using ehci_hcd
[    8.898563] cfg80211: World regulatory domain updated:
[    8.899287] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenn=
a_gain, max_eirp)
[    8.900011] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mB=
i, 2000 mBm)
[    8.900757] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mB=
i, 2000 mBm)
[    8.901468] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mB=
i, 2000 mBm)
[    8.902162] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mB=
i, 2000 mBm)
[    8.902856] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mB=
i, 2000 mBm)
[    8.921542] usb 2-1: New USB device found, idVendor=3D8087, idProduct=3D=
0024
[    8.922251] usb 2-1: New USB device strings: Mfr=3D0, Product=3D0, Seria=
lNumber=3D0
[    8.923406] hub 2-1:1.0: USB hub found
[    8.924275] hub 2-1:1.0: 6 ports detected
[    8.999136] usb 1-1.4: new high-speed USB device number 3 using ehci_hcd
[    9.169354] input: DualPoint Stick as /devices/platform/i8042/serio1/inp=
ut/input7
[    9.183580] input: AlpsPS/2 ALPS DualPoint TouchPad as /devices/platform=
/i8042/serio1/input/input8
[    9.191283] input: HDA Intel PCH HDMI/DP,pcm=3D8 as /devices/pci0000:00/=
0000:00:1b.0/sound/card0/input9
[    9.192213] input: HDA Intel PCH HDMI/DP,pcm=3D7 as /devices/pci0000:00/=
0000:00:1b.0/sound/card0/input10
[    9.193123] input: HDA Intel PCH HDMI/DP,pcm=3D3 as /devices/pci0000:00/=
0000:00:1b.0/sound/card0/input11
[    9.194028] input: HDA Intel PCH Dock Mic as /devices/pci0000:00/0000:00=
:1b.0/sound/card0/input12
[    9.194944] input: HDA Intel PCH Mic as /devices/pci0000:00/0000:00:1b.0=
/sound/card0/input13
[    9.195881] input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:0=
0:1b.0/sound/card0/input14
[    9.197010] input: HDA Intel PCH Dock Line Out as /devices/pci0000:00/00=
00:00:1b.0/sound/card0/input15
[    9.254369] usb 1-1.4: New USB device found, idVendor=3D1bcf, idProduct=
=3D280b
[    9.255246] usb 1-1.4: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[    9.256108] usb 1-1.4: Product: Laptop_Integrated_Webcam_FHD
[    9.256978] usb 1-1.4: Manufacturer: CN0CJ3P27248715OB5MJA00
[    9.547448] usb 2-1.4: new high-speed USB device number 3 using ehci_hcd
[    9.634491] usb 2-1.4: New USB device found, idVendor=3D05e3, idProduct=
=3D0608
[    9.635439] usb 2-1.4: New USB device strings: Mfr=3D0, Product=3D1, Ser=
ialNumber=3D0
[    9.636347] usb 2-1.4: Product: USB2.0 Hub
[    9.637711] hub 2-1.4:1.0: USB hub found
[    9.638984] hub 2-1.4:1.0: 4 ports detected
[    9.714326] usb 2-1.6: new full-speed USB device number 4 using ehci_hcd
[    9.804145] usb 2-1.6: New USB device found, idVendor=3D413c, idProduct=
=3D8187
[    9.805153] usb 2-1.6: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D3
[    9.806106] usb 2-1.6: Product: DW375 Bluetooth Module
[    9.807062] usb 2-1.6: Manufacturer: Dell Computer Corp
[    9.808022] usb 2-1.6: SerialNumber: C0F8DAE4FAE3
[    9.897996] Linux video capture interface: v2.00
[    9.905027] usb 2-1.4.2: new low-speed USB device number 5 using ehci_hcd
[   10.002964] uvcvideo: Found UVC 1.00 device Laptop_Integrated_Webcam_FHD=
 (1bcf:280b)
[   10.006025] usb 2-1.4.2: New USB device found, idVendor=3D046a, idProduc=
t=3D0023
[   10.007069] usb 2-1.4.2: New USB device strings: Mfr=3D0, Product=3D0, S=
erialNumber=3D0
[   10.037644] input: Laptop_Integrated_Webcam_FHD as /devices/pci0000:00/0=
000:00:1a.0/usb1/1-1/1-1.4/1-1.4:1.0/input/input16
[   10.038819] usbcore: registered new interface driver uvcvideo
[   10.039880] USB Video Class driver (1.1.1)
[   10.082845] usb 2-1.4.4: new high-speed USB device number 6 using ehci_h=
cd
[   10.159807] usb 2-1.4.4: New USB device found, idVendor=3D05e3, idProduc=
t=3D0608
[   10.160930] usb 2-1.4.4: New USB device strings: Mfr=3D0, Product=3D1, S=
erialNumber=3D0
[   10.162004] usb 2-1.4.4: Product: USB2.0 Hub
[   10.163515] hub 2-1.4.4:1.0: USB hub found
[   10.164925] hub 2-1.4.4:1.0: 4 ports detected
[   10.184544] usbcore: registered new interface driver usbhid
[   10.185642] usbhid: USB HID core driver
[   10.233165] input: HID 046a:0023 as /devices/pci0000:00/0000:00:1d.0/usb=
2/2-1/2-1.4/2-1.4.2/2-1.4.2:1.0/input/input17
[   10.234424] cherry 0003:046A:0023.0001: input,hidraw0: USB HID v1.11 Key=
board [HID 046a:0023] on usb-0000:00:1d.0-1.4.2/input0
[   10.244339] input: HID 046a:0023 as /devices/pci0000:00/0000:00:1d.0/usb=
2/2-1/2-1.4/2-1.4.2/2-1.4.2:1.1/input/input18
[   10.245614] cherry 0003:046A:0023.0002: input,hidraw1: USB HID v1.11 Dev=
ice [HID 046a:0023] on usb-0000:00:1d.0-1.4.2/input1
[   10.403105] Adding 8388604k swap on /dev/sda3.  Priority:0 extents:1 acr=
oss:8388604k=20
[   10.431435] usb 2-1.4.4.1: new high-speed USB device number 7 using ehci=
_hcd
[   10.511232] usb 2-1.4.4.1: New USB device found, idVendor=3D05e3, idProd=
uct=3D0723
[   10.512461] usb 2-1.4.4.1: New USB device strings: Mfr=3D3, Product=3D4,=
 SerialNumber=3D0
[   10.513644] usb 2-1.4.4.1: Product: USB Storage
[   10.514815] usb 2-1.4.4.1: Manufacturer: Generic=20
[   10.590148] usb 2-1.4.4.4: new low-speed USB device number 8 using ehci_=
hcd
[   10.614389] Initializing USB Mass Storage driver...
[   10.615674] usb-storage 2-1.4.4.1:1.0: Quirks match for vid 05e3 pid 072=
3: 8000
[   10.616887] scsi6 : usb-storage 2-1.4.4.1:1.0
[   10.618178] usbcore: registered new interface driver usb-storage
[   10.619388] USB Mass Storage support registered.
[   10.680880] usb 2-1.4.4.4: New USB device found, idVendor=3D093a, idProd=
uct=3D2510
[   10.682113] usb 2-1.4.4.4: New USB device strings: Mfr=3D1, Product=3D2,=
 SerialNumber=3D0
[   10.683289] usb 2-1.4.4.4: Product: USB OPTICAL MOUSE
[   10.684452] usb 2-1.4.4.4: Manufacturer: PIXART
[   10.689046] input: PIXART USB OPTICAL MOUSE as /devices/pci0000:00/0000:=
00:1d.0/usb2/2-1/2-1.4/2-1.4.4/2-1.4.4.4/2-1.4.4.4:1.0/input/input19
[   10.690407] generic-usb 0003:093A:2510.0003: input,hidraw2: USB HID v1.1=
0 Mouse [PIXART USB OPTICAL MOUSE] on usb-0000:00:1d.0-1.4.4.4/input0
[   11.620316] scsi 6:0:0:0: Direct-Access     Generic  STORAGE DEVICE   94=
51 PQ: 0 ANSI: 0
[   11.622642] sd 6:0:0:0: Attached scsi generic sg2 type 0
[   11.626288] sd 6:0:0:0: [sdb] Attached SCSI removable disk
[   11.775199] EXT4-fs (sda6): mounted filesystem with ordered data mode. O=
pts: (null)
[   16.675553] iwlwifi 0000:02:00.0: I iwl_prep_station Add STA to driver I=
D 15: ff:ff:ff:ff:ff:ff
[   16.675597] iwlwifi 0000:02:00.0: I iwl_prep_station Add STA to driver I=
D 14: ff:ff:ff:ff:ff:ff
[   16.675636] iwlwifi 0000:02:00.0: U iwl_prepare_card_hw iwl_trans_prepar=
e_card_hw enter
[   16.675701] iwlwifi 0000:02:00.0: U iwl_set_hw_ready hardware ready
[   16.675757] iwlwifi 0000:02:00.0: U iwl_apm_init Init card's basic funct=
ions
[   16.675840] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[   16.682657] iwlwifi 0000:02:00.0: Radio type=3D0x1-0x2-0x0
[   16.746028] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command COEX_PRIORITY_TABLE_CMD
[   16.746076] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command COEX_PRIORITY_TABLE_CMD
[   16.746217] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command COEX_PRIORITY_TABLE_CMD
[   16.746301] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_PHY_CALIBRATION_CMD
[   16.746367] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_PHY_CALIBRATION_CMD
[   16.746847] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_PHY_CALIBRATION_CMD
[   16.746930] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command CALIBRATION_CFG_CMD
[   16.746992] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command CALIBRATION_CFG_CMD
[   16.747155] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command CALIBRATION_CFG_CMD
[   16.967673] iwlwifi 0000:02:00.0: U iwl_apm_stop Stop card, put in low p=
ower state
[   16.967742] iwlwifi 0000:02:00.0: U iwl_apm_stop_master stop master
[   16.967836] iwlwifi 0000:02:00.0: U iwl_prepare_card_hw iwl_trans_prepar=
e_card_hw enter
[   16.967900] iwlwifi 0000:02:00.0: U iwl_set_hw_ready hardware ready
[   16.967956] iwlwifi 0000:02:00.0: U iwl_apm_init Init card's basic funct=
ions
[   16.968039] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[   16.974855] iwlwifi 0000:02:00.0: Radio type=3D0x1-0x2-0x0
[   17.041649] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command COEX_PRIORITY_TABLE_CMD
[   17.041697] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command COEX_PRIORITY_TABLE_CMD
[   17.041853] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command COEX_PRIORITY_TABLE_CMD
[   17.041931] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_PHY_CALIBRATION_CMD
[   17.041972] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_PHY_CALIBRATION_CMD
[   17.042509] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_PHY_CALIBRATION_CMD
[   17.042602] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_PHY_CALIBRATION_CMD
[   17.042659] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_PHY_CALIBRATION_CMD
[   17.042789] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_PHY_CALIBRATION_CMD
[   17.042837] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_PHY_CALIBRATION_CMD
[   17.042885] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_PHY_CALIBRATION_CMD
[   17.042963] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_PHY_CALIBRATION_CMD
[   17.043010] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_PHY_CALIBRATION_CMD
[   17.044082] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_PHY_CALIBRATION_CMD
[   17.045143] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_PHY_CALIBRATION_CMD
[   17.045150] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_PHY_CALIBRATION_CMD
[   17.045153] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_PHY_CALIBRATION_CMD
[   17.046216] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_PHY_CALIBRATION_CMD
[   17.046223] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_PHY_CALIBRATION_CMD
[   17.046225] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_PHY_CALIBRATION_CMD
[   17.049357] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_PHY_CALIBRATION_CMD
[   17.049364] iwlwifi 0000:02:00.0: U iwl_alive_start Runtime Alive receiv=
ed.
[   17.049367] iwlwifi 0000:02:00.0: U iwl_send_bt_config BT coex active
[   17.049370] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_BT_CONFIG
[   17.049372] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_BT_CONFIG
[   17.052563] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_BT_CONFIG
[   17.052570] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command CALIBRATION_CFG_CMD
[   17.052573] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command CALIBRATION_CFG_CMD
[   17.057929] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command CALIBRATION_CFG_CMD
[   17.057936] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command TX_ANT_CONFIGURATION_CMD
[   17.057939] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command TX_ANT_CONFIGURATION_CMD
[   17.079895] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command TX_ANT_CONFIGURATION_CMD
[   17.081030] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   17.082140] iwlwifi 0000:02:00.0: U iwl_full_rxon_required need full RXO=
N - !iwl_is_associated_ctx(ctx)
[   17.083278] iwlwifi 0000:02:00.0: U iwlagn_commit_rxon Going to commit R=
XON
[   17.083279]   * without RXON_FILTER_ASSOC_MSK
[   17.083280]   * channel =3D 1
[   17.083281]   * bssid =3D 00:00:00:00:00:00
[   17.087578] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_RXON
[   17.088677] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_RXON
[   17.089791] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_RXON
[   17.089806] iwlwifi 0000:02:00.0: U iwl_clear_ucode_stations Clearing uc=
ode stations in driver
[   17.089810] iwlwifi 0000:02:00.0: U iwl_clear_ucode_stations No active s=
tations found to be cleared
[   17.089814] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations ... start.
[   17.089817] iwlwifi 0000:02:00.0: I iwl_restore_stations Restoring sta f=
f:ff:ff:ff:ff:ff
[   17.089820] iwlwifi 0000:02:00.0: U iwl_send_add_sta Adding sta 15 (ff:f=
f:ff:ff:ff:ff) synchronously
[   17.089823] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_ADD_STA
[   17.089825] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_ADD_STA
[   17.106641] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Processing =
response for adding station 15
[   17.107750] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp REPLY_ADD_S=
TA PASSED
[   17.108834] iwlwifi 0000:02:00.0: I iwl_sta_ucode_activate Added STA id =
15 addr ff:ff:ff:ff:ff:ff to uCode
[   17.109926] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on id 15 addr ff:ff:ff:ff:ff:ff
[   17.111022] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on according to cmd buffer ff:ff:ff:ff:00:ff
[   17.112114] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_ADD_STA
[   17.113225] iwlwifi 0000:02:00.0: U is_lq_table_valid Channel 0 is not a=
n HT channel
[   17.114330] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_TX_LINK_QUALITY_CMD
[   17.115442] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_TX_LINK_QUALITY_CMD
[   17.115549] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_TX_LINK_QUALITY_CMD
[   17.115555] iwlwifi 0000:02:00.0: U iwl_send_lq_cmd init LQ command comp=
lete, clearing sta addition status for sta 15
[   17.115558] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations .... complete.
[   17.115561] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_CT_KILL_CONFIG_CMD
[   17.115564] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_CT_KILL_CONFIG_CMD
[   17.115625] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_CT_KILL_CONFIG_CMD
[   17.115630] iwlwifi 0000:02:00.0: U iwl_rf_kill_ct_config REPLY_CT_KILL_=
CONFIG_CMD succeeded, critical temperature enter is 114,exit is 95
[   17.115632] iwlwifi 0000:02:00.0: U iwl_alive_start ALIVE processing com=
plete.
[   17.115635] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command POWER_TABLE_CMD
[   17.115636] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command POWER_TABLE_CMD
[   17.115701] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command POWER_TABLE_CMD
[   17.115707] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   17.115709] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   17.115713] iwlwifi 0000:02:00.0: U iwlagn_mac_start Start UP work done.
[   17.115745] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   17.115749] iwlwifi 0000:02:00.0: U iwl_full_rxon_required need full RXO=
N - !iwl_is_associated_ctx(ctx)
[   17.115752] iwlwifi 0000:02:00.0: U iwlagn_commit_rxon Going to commit R=
XON
[   17.115753]   * without RXON_FILTER_ASSOC_MSK
[   17.115753]   * channel =3D 1
[   17.115754]   * bssid =3D 00:00:00:00:00:00
[   17.115756] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_RXON
[   17.115757] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_RXON
[   17.115953] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_RXON
[   17.115963] iwlwifi 0000:02:00.0: U iwl_clear_ucode_stations Clearing uc=
ode stations in driver
[   17.115965] iwlwifi 0000:02:00.0: I iwl_clear_ucode_stations Clearing uc=
ode active for station 15
[   17.115969] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations ... start.
[   17.115971] iwlwifi 0000:02:00.0: I iwl_restore_stations Restoring sta f=
f:ff:ff:ff:ff:ff
[   17.115973] iwlwifi 0000:02:00.0: U iwl_send_add_sta Adding sta 15 (ff:f=
f:ff:ff:ff:ff) synchronously
[   17.115975] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_ADD_STA
[   17.115977] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_ADD_STA
[   17.116103] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Processing =
response for adding station 15
[   17.116105] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp REPLY_ADD_S=
TA PASSED
[   17.116107] iwlwifi 0000:02:00.0: I iwl_sta_ucode_activate Added STA id =
15 addr ff:ff:ff:ff:ff:ff to uCode
[   17.116109] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on id 15 addr ff:ff:ff:ff:ff:ff
[   17.116110] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on according to cmd buffer ff:ff:ff:ff:ff:ff
[   17.116113] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_ADD_STA
[   17.116117] iwlwifi 0000:02:00.0: U is_lq_table_valid Channel 1 is not a=
n HT channel
[   17.116119] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_TX_LINK_QUALITY_CMD
[   17.116121] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_TX_LINK_QUALITY_CMD
[   17.116219] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_TX_LINK_QUALITY_CMD
[   17.116223] iwlwifi 0000:02:00.0: U iwl_send_lq_cmd init LQ command comp=
lete, clearing sta addition status for sta 15
[   17.116225] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations .... complete.
[   17.116231] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   17.116234] iwlwifi 0000:02:00.0: U iwl_full_rxon_required need full RXO=
N - !iwl_is_associated_ctx(ctx)
[   17.116236] iwlwifi 0000:02:00.0: U iwlagn_commit_rxon Going to commit R=
XON
[   17.116237]   * without RXON_FILTER_ASSOC_MSK
[   17.116238]   * channel =3D 1
[   17.116238]   * bssid =3D 00:00:00:00:00:00
[   17.116240] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_RXON
[   17.116242] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_RXON
[   17.116505] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_RXON
[   17.116520] iwlwifi 0000:02:00.0: U iwl_clear_ucode_stations Clearing uc=
ode stations in driver
[   17.116523] iwlwifi 0000:02:00.0: I iwl_clear_ucode_stations Clearing uc=
ode active for station 15
[   17.116526] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations ... start.
[   17.116529] iwlwifi 0000:02:00.0: I iwl_restore_stations Restoring sta f=
f:ff:ff:ff:ff:ff
[   17.116532] iwlwifi 0000:02:00.0: U iwl_send_add_sta Adding sta 15 (ff:f=
f:ff:ff:ff:ff) synchronously
[   17.116535] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_ADD_STA
[   17.116538] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_ADD_STA
[   17.116673] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Processing =
response for adding station 15
[   17.116675] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp REPLY_ADD_S=
TA PASSED
[   17.116677] iwlwifi 0000:02:00.0: I iwl_sta_ucode_activate Added STA id =
15 addr ff:ff:ff:ff:ff:ff to uCode
[   17.116680] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on id 15 addr ff:ff:ff:ff:ff:ff
[   17.116681] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on according to cmd buffer ff:ff:ff:ff:ff:ff
[   17.116684] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_ADD_STA
[   17.116694] iwlwifi 0000:02:00.0: U is_lq_table_valid Channel 1 is not a=
n HT channel
[   17.116696] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_TX_LINK_QUALITY_CMD
[   17.116698] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_TX_LINK_QUALITY_CMD
[   17.116827] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_TX_LINK_QUALITY_CMD
[   17.116839] iwlwifi 0000:02:00.0: U iwl_send_lq_cmd init LQ command comp=
lete, clearing sta addition status for sta 15
[   17.116841] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations .... complete.
[   17.116854] iwlwifi 0000:02:00.0: U iwlagn_update_qos send QoS cmd with =
Qos active=3D0 FLAGS=3D0x0
[   17.116857] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_QOS_PARAM
[   17.116860] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_QOS_PARAM
[   17.116983] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_QOS_PARAM
[   17.116995] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   17.116998] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   17.117002] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   17.117003] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   17.117008] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command POWER_TABLE_CMD
[   17.117010] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command POWER_TABLE_CMD
[   17.117090] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command POWER_TABLE_CMD
[   17.117102] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   17.117104] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   17.117412] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   17.204323] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_SCAN_CMD
[   17.204327] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_SCAN_CMD
[   17.205903] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_SCAN_CMD
[   17.635253] iwlwifi 0000:02:00.0: U iwl_full_rxon_required need full RXO=
N - !iwl_is_associated_ctx(ctx)
[   17.636681] iwlwifi 0000:02:00.0: U iwlagn_commit_rxon Going to commit R=
XON
[   17.636683]   * without RXON_FILTER_ASSOC_MSK
[   17.636684]   * channel =3D 1
[   17.636684]   * bssid =3D 00:00:00:00:00:00
[   17.642124] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_RXON
[   17.643144] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_RXON
[   17.645832] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_RXON
[   17.646909] iwlwifi 0000:02:00.0: U iwl_clear_ucode_stations Clearing uc=
ode stations in driver
[   17.647942] iwlwifi 0000:02:00.0: I iwl_clear_ucode_stations Clearing uc=
ode active for station 15
[   17.648971] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations ... start.
[   17.650002] iwlwifi 0000:02:00.0: I iwl_restore_stations Restoring sta f=
f:ff:ff:ff:ff:ff
[   17.651024] iwlwifi 0000:02:00.0: U iwl_send_add_sta Adding sta 15 (ff:f=
f:ff:ff:ff:ff) synchronously
[   17.652054] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_ADD_STA
[   17.653082] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_ADD_STA
[   17.655551] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Processing =
response for adding station 15
[   17.656633] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp REPLY_ADD_S=
TA PASSED
[   17.657666] iwlwifi 0000:02:00.0: I iwl_sta_ucode_activate Added STA id =
15 addr ff:ff:ff:ff:ff:ff to uCode
[   17.658711] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on id 15 addr ff:ff:ff:ff:ff:ff
[   17.659754] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on according to cmd buffer ff:ff:ff:ff:ff:ff
[   17.660804] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_ADD_STA
[   17.661859] iwlwifi 0000:02:00.0: U is_lq_table_valid Channel 1 is not a=
n HT channel
[   17.662936] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_TX_LINK_QUALITY_CMD
[   17.662939] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_TX_LINK_QUALITY_CMD
[   17.665091] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_TX_LINK_QUALITY_CMD
[   17.665098] iwlwifi 0000:02:00.0: U iwl_send_lq_cmd init LQ command comp=
lete, clearing sta addition status for sta 15
[   17.665101] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations .... complete.
[   17.665139] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_SCAN_CMD
[   17.665142] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_SCAN_CMD
[   17.670417] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_SCAN_CMD
[   17.849377] udevd used greatest stack depth: 4320 bytes left
[   22.114952] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_SCAN_CMD
[   22.116034] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_SCAN_CMD
[   22.118828] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_SCAN_CMD
[   22.547727] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_SCAN_CMD
[   22.548821] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_SCAN_CMD
[   22.552535] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_SCAN_CMD
[   25.576558] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   25.577702] iwlwifi 0000:02:00.0: U iwl_full_rxon_required need full RXO=
N - !iwl_is_associated_ctx(ctx)
[   25.578911] iwlwifi 0000:02:00.0: U iwlagn_commit_rxon Going to commit R=
XON
[   25.578913]   * without RXON_FILTER_ASSOC_MSK
[   25.578914]   * channel =3D 1
[   25.578915]   * bssid =3D 00:00:00:00:00:00
[   25.583412] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_RXON
[   25.583415] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_RXON
[   25.587434] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_RXON
[   25.588597] iwlwifi 0000:02:00.0: U iwl_clear_ucode_stations Clearing uc=
ode stations in driver
[   25.589741] iwlwifi 0000:02:00.0: I iwl_clear_ucode_stations Clearing uc=
ode active for station 15
[   25.590889] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations ... start.
[   25.592014] iwlwifi 0000:02:00.0: I iwl_restore_stations Restoring sta f=
f:ff:ff:ff:ff:ff
[   25.593162] iwlwifi 0000:02:00.0: U iwl_send_add_sta Adding sta 15 (ff:f=
f:ff:ff:ff:ff) synchronously
[   25.593166] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_ADD_STA
[   25.593169] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_ADD_STA
[   25.594579] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Processing =
response for adding station 15
[   25.594581] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp REPLY_ADD_S=
TA PASSED
[   25.594585] iwlwifi 0000:02:00.0: I iwl_sta_ucode_activate Added STA id =
15 addr ff:ff:ff:ff:ff:ff to uCode
[   25.594588] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on id 15 addr ff:ff:ff:ff:ff:ff
[   25.594591] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on according to cmd buffer ff:ff:ff:ff:ff:ff
[   25.594594] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_ADD_STA
[   25.594608] iwlwifi 0000:02:00.0: U is_lq_table_valid Channel 1 is not a=
n HT channel
[   25.594611] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_TX_LINK_QUALITY_CMD
[   25.594614] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_TX_LINK_QUALITY_CMD
[   25.595818] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_TX_LINK_QUALITY_CMD
[   25.595826] iwlwifi 0000:02:00.0: U iwl_send_lq_cmd init LQ command comp=
lete, clearing sta addition status for sta 15
[   25.595829] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations .... complete.
[   25.595851] iwlwifi 0000:02:00.0: U iwl_down iwlwifi is going down
[   25.595860] iwlwifi 0000:02:00.0: U iwl_clear_ucode_stations Clearing uc=
ode stations in driver
[   25.595862] iwlwifi 0000:02:00.0: I iwl_clear_ucode_stations Clearing uc=
ode active for station 15
[   25.596191] iwlwifi 0000:02:00.0: U iwl_apm_stop Stop card, put in low p=
ower state
[   25.596223] iwlwifi 0000:02:00.0: U iwl_apm_stop_master stop master
[   25.596329] iwlwifi 0000:02:00.0: U iwl_apm_stop Stop card, put in low p=
ower state
[   25.596362] iwlwifi 0000:02:00.0: U iwl_apm_stop_master stop master
[   25.620884] iwlwifi 0000:02:00.0: I iwl_prep_station Add STA to driver I=
D 15: ff:ff:ff:ff:ff:ff
[   25.622026] iwlwifi 0000:02:00.0: I iwl_prep_station Add STA to driver I=
D 14: ff:ff:ff:ff:ff:ff
[   25.623195] iwlwifi 0000:02:00.0: U iwl_prepare_card_hw iwl_trans_prepar=
e_card_hw enter
[   25.624345] iwlwifi 0000:02:00.0: U iwl_set_hw_ready hardware ready
[   25.624373] iwlwifi 0000:02:00.0: U iwl_apm_init Init card's basic funct=
ions
[   25.624417] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[   25.631205] iwlwifi 0000:02:00.0: Radio type=3D0x1-0x2-0x0
[   25.632282] ------------[ cut here ]------------
[   25.633353] WARNING: at drivers/iommu/intel-iommu.c:2922 intel_unmap_pag=
e+0x11e/0x130()
[   25.633355] Hardware name: Latitude E5420
[   25.633356] Driver unmaps unmatched page at PFN ffd5e000
[   25.633357] Modules linked in: usb_storage hid_cherry usbhid uvcvideo vi=
deobuf2_vmalloc videobuf2_memops videobuf2_core videodev snd_hda_codec_hdmi=
 snd_hda_codec_idt crc32c_intel aesni_intel aes_x86_64 cryptd iwlwifi snd_h=
da_intel snd_hda_codec mac80211 snd_hwdep snd_pcm snd_page_alloc ehci_hcd s=
nd_timer snd soundcore cfg80211 psmouse usbcore usb_common
[   25.633374] Pid: 1852, comm: ifconfig Tainted: G        W    3.4.0-rc5-w=
l+ #25
[   25.633376] Call Trace:
[   25.633381]  [<ffffffff8103279a>] warn_slowpath_common+0x7a/0xb0
[   25.633383]  [<ffffffff81032871>] warn_slowpath_fmt+0x41/0x50
[   25.633386]  [<ffffffff813735c0>] ? find_iova+0x50/0x90
[   25.633388]  [<ffffffff813775ae>] intel_unmap_page+0x11e/0x130
[   25.633395]  [<ffffffffa015b8c4>] iwl_trans_rxq_free_rx_bufs+0x54/0xf0 [=
iwlwifi]
[   25.633399]  [<ffffffffa015ce74>] ? iwl_trans_pcie_start_fw+0x154/0xee0 =
[iwlwifi]
[   25.633402]  [<ffffffff81058d03>] ? get_parent_ip+0x33/0x50
[   25.633405]  [<ffffffff81058e7d>] ? add_preempt_count+0x8d/0xc0
[   25.633407]  [<ffffffff81058d03>] ? get_parent_ip+0x33/0x50
[   25.633409]  [<ffffffff81058dbd>] ? sub_preempt_count+0x9d/0xd0
[   25.633413]  [<ffffffffa01461c8>] ? iwl_load_ucode_wait_alive+0xa8/0x3f0=
 [iwlwifi]
[   25.633415]  [<ffffffff81058d03>] ? get_parent_ip+0x33/0x50
[   25.633418]  [<ffffffffa0145bf0>] ? iwl_alloc_all+0x30/0x30 [iwlwifi]
[   25.633423]  [<ffffffff8148255a>] ? _raw_spin_unlock_bh+0x1a/0x20
[   25.633426]  [<ffffffffa0143cb2>] ? iwlagn_mac_start+0x132/0x210 [iwlwif=
i]
[   25.633432]  [<ffffffffa00fb023>] ? ieee80211_do_open+0x233/0x7f0 [mac80=
211]
[   25.633437]  [<ffffffffa00f8ea2>] ? ieee80211_check_concurrent_iface+0x2=
2/0x1a0 [mac80211]
[   25.633439]  [<ffffffff81395ef7>] ? __dev_open+0x97/0xe0
[   25.633441]  [<ffffffff8139617c>] ? __dev_change_flags+0x9c/0x180
[   25.633443]  [<ffffffff81396313>] ? dev_change_flags+0x23/0x70
[   25.633446]  [<ffffffff813f1a4d>] ? devinet_ioctl+0x5bd/0x740
[   25.633448]  [<ffffffff813f1f15>] ? inet_ioctl+0x75/0x90
[   25.633450]  [<ffffffff8137cefb>] ? sock_do_ioctl+0x2b/0x70
[   25.633453]  [<ffffffff8137cfa8>] ? sock_ioctl+0x68/0x2b0
[   25.633456]  [<ffffffff810fd62e>] ? do_vfs_ioctl+0x8e/0x500
[   25.633459]  [<ffffffff810914f2>] ? call_rcu+0x12/0x20
[   25.633462]  [<ffffffff8105408a>] ? __put_cred+0x3a/0x50
[   25.633464]  [<ffffffff810fdb31>] ? sys_ioctl+0x91/0xa0
[   25.633466]  [<ffffffff81483462>] ? system_call_fastpath+0x16/0x1b
[   25.633468] ---[ end trace e93713a9d40cd06e ]---
[   25.700446] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command COEX_PRIORITY_TABLE_CMD
[   25.701472] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command COEX_PRIORITY_TABLE_CMD
[   25.702633] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command COEX_PRIORITY_TABLE_CMD
[   25.703668] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_PHY_CALIBRATION_CMD
[   25.704740] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_PHY_CALIBRATION_CMD
[   25.705937] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_PHY_CALIBRATION_CMD
[   25.707008] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_PHY_CALIBRATION_CMD
[   25.708055] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_PHY_CALIBRATION_CMD
[   25.709209] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_PHY_CALIBRATION_CMD
[   25.710272] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_PHY_CALIBRATION_CMD
[   25.711404] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_PHY_CALIBRATION_CMD
[   25.711499] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_PHY_CALIBRATION_CMD
[   25.711507] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_PHY_CALIBRATION_CMD
[   25.711510] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_PHY_CALIBRATION_CMD
[   25.711604] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_PHY_CALIBRATION_CMD
[   25.711611] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_PHY_CALIBRATION_CMD
[   25.711614] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_PHY_CALIBRATION_CMD
[   25.711717] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_PHY_CALIBRATION_CMD
[   25.711723] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_PHY_CALIBRATION_CMD
[   25.711726] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_PHY_CALIBRATION_CMD
[   25.711818] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_PHY_CALIBRATION_CMD
[   25.711828] iwlwifi 0000:02:00.0: U iwl_alive_start Runtime Alive receiv=
ed.
[   25.711830] iwlwifi 0000:02:00.0: U iwl_send_bt_config BT coex active
[   25.711833] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_BT_CONFIG
[   25.711836] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_BT_CONFIG
[   25.711918] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_BT_CONFIG
[   25.711926] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command CALIBRATION_CFG_CMD
[   25.711929] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command CALIBRATION_CFG_CMD
[   25.712020] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command CALIBRATION_CFG_CMD
[   25.712033] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command TX_ANT_CONFIGURATION_CMD
[   25.712036] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command TX_ANT_CONFIGURATION_CMD
[   25.739256] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command TX_ANT_CONFIGURATION_CMD
[   25.740348] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   25.741429] iwlwifi 0000:02:00.0: U iwl_full_rxon_required need full RXO=
N - !iwl_is_associated_ctx(ctx)
[   25.742541] iwlwifi 0000:02:00.0: U iwlagn_commit_rxon Going to commit R=
XON
[   25.742542]   * without RXON_FILTER_ASSOC_MSK
[   25.742543]   * channel =3D 1
[   25.742543]   * bssid =3D 00:00:00:00:00:00
[   25.746787] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_RXON
[   25.747876] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_RXON
[   25.750188] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_RXON
[   25.751329] iwlwifi 0000:02:00.0: U iwl_clear_ucode_stations Clearing uc=
ode stations in driver
[   25.752443] iwlwifi 0000:02:00.0: U iwl_clear_ucode_stations No active s=
tations found to be cleared
[   25.753570] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations ... start.
[   25.753572] iwlwifi 0000:02:00.0: I iwl_restore_stations Restoring sta f=
f:ff:ff:ff:ff:ff
[   25.753575] iwlwifi 0000:02:00.0: U iwl_send_add_sta Adding sta 15 (ff:f=
f:ff:ff:ff:ff) synchronously
[   25.753577] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_ADD_STA
[   25.753579] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_ADD_STA
[   25.766903] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Processing =
response for adding station 15
[   25.768041] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp REPLY_ADD_S=
TA PASSED
[   25.769146] iwlwifi 0000:02:00.0: I iwl_sta_ucode_activate Added STA id =
15 addr ff:ff:ff:ff:ff:ff to uCode
[   25.770261] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on id 15 addr ff:ff:ff:ff:ff:ff
[   25.771380] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on according to cmd buffer ff:ff:ff:ff:00:ff
[   25.772497] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_ADD_STA
[   25.773628] iwlwifi 0000:02:00.0: U is_lq_table_valid Channel 1 is not a=
n HT channel
[   25.774759] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_TX_LINK_QUALITY_CMD
[   25.775999] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_TX_LINK_QUALITY_CMD
[   25.776109] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_TX_LINK_QUALITY_CMD
[   25.776114] iwlwifi 0000:02:00.0: U iwl_send_lq_cmd init LQ command comp=
lete, clearing sta addition status for sta 15
[   25.776117] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations .... complete.
[   25.776120] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_CT_KILL_CONFIG_CMD
[   25.776122] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_CT_KILL_CONFIG_CMD
[   25.776187] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_CT_KILL_CONFIG_CMD
[   25.776196] iwlwifi 0000:02:00.0: U iwl_rf_kill_ct_config REPLY_CT_KILL_=
CONFIG_CMD succeeded, critical temperature enter is 114,exit is 95
[   25.776198] iwlwifi 0000:02:00.0: U iwl_alive_start ALIVE processing com=
plete.
[   25.776202] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command POWER_TABLE_CMD
[   25.776203] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command POWER_TABLE_CMD
[   25.776292] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command POWER_TABLE_CMD
[   25.776304] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   25.776307] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   25.776311] iwlwifi 0000:02:00.0: U iwlagn_mac_start Start UP work done.
[   25.776317] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   25.776320] iwlwifi 0000:02:00.0: U iwl_full_rxon_required need full RXO=
N - !iwl_is_associated_ctx(ctx)
[   25.776322] iwlwifi 0000:02:00.0: U iwlagn_commit_rxon Going to commit R=
XON
[   25.776323]   * without RXON_FILTER_ASSOC_MSK
[   25.776324]   * channel =3D 1
[   25.776324]   * bssid =3D 00:00:00:00:00:00
[   25.776326] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_RXON
[   25.776328] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_RXON
[   25.777900] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_RXON
[   25.777917] iwlwifi 0000:02:00.0: U iwl_clear_ucode_stations Clearing uc=
ode stations in driver
[   25.777920] iwlwifi 0000:02:00.0: I iwl_clear_ucode_stations Clearing uc=
ode active for station 15
[   25.777925] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations ... start.
[   25.777927] iwlwifi 0000:02:00.0: I iwl_restore_stations Restoring sta f=
f:ff:ff:ff:ff:ff
[   25.777929] iwlwifi 0000:02:00.0: U iwl_send_add_sta Adding sta 15 (ff:f=
f:ff:ff:ff:ff) synchronously
[   25.777931] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_ADD_STA
[   25.777933] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_ADD_STA
[   25.778028] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Processing =
response for adding station 15
[   25.778031] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp REPLY_ADD_S=
TA PASSED
[   25.778033] iwlwifi 0000:02:00.0: I iwl_sta_ucode_activate Added STA id =
15 addr ff:ff:ff:ff:ff:ff to uCode
[   25.778035] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on id 15 addr ff:ff:ff:ff:ff:ff
[   25.778037] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on according to cmd buffer ff:ff:ff:ff:ff:ff
[   25.778040] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_ADD_STA
[   25.778050] iwlwifi 0000:02:00.0: U is_lq_table_valid Channel 1 is not a=
n HT channel
[   25.778052] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_TX_LINK_QUALITY_CMD
[   25.778054] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_TX_LINK_QUALITY_CMD
[   25.779258] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_TX_LINK_QUALITY_CMD
[   25.779270] iwlwifi 0000:02:00.0: U iwl_send_lq_cmd init LQ command comp=
lete, clearing sta addition status for sta 15
[   25.779272] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations .... complete.
[   25.779278] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   25.779281] iwlwifi 0000:02:00.0: U iwl_full_rxon_required need full RXO=
N - !iwl_is_associated_ctx(ctx)
[   25.779283] iwlwifi 0000:02:00.0: U iwlagn_commit_rxon Going to commit R=
XON
[   25.779284]   * without RXON_FILTER_ASSOC_MSK
[   25.779284]   * channel =3D 1
[   25.779285]   * bssid =3D 00:00:00:00:00:00
[   25.779286] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_RXON
[   25.779288] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_RXON
[   25.780847] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_RXON
[   25.780861] iwlwifi 0000:02:00.0: U iwl_clear_ucode_stations Clearing uc=
ode stations in driver
[   25.780863] iwlwifi 0000:02:00.0: I iwl_clear_ucode_stations Clearing uc=
ode active for station 15
[   25.780866] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations ... start.
[   25.780868] iwlwifi 0000:02:00.0: I iwl_restore_stations Restoring sta f=
f:ff:ff:ff:ff:ff
[   25.780870] iwlwifi 0000:02:00.0: U iwl_send_add_sta Adding sta 15 (ff:f=
f:ff:ff:ff:ff) synchronously
[   25.780872] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_ADD_STA
[   25.780874] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_ADD_STA
[   25.782156] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Processing =
response for adding station 15
[   25.782158] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp REPLY_ADD_S=
TA PASSED
[   25.782161] iwlwifi 0000:02:00.0: I iwl_sta_ucode_activate Added STA id =
15 addr ff:ff:ff:ff:ff:ff to uCode
[   25.782163] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on id 15 addr ff:ff:ff:ff:ff:ff
[   25.782165] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on according to cmd buffer ff:ff:ff:ff:ff:ff
[   25.782168] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_ADD_STA
[   25.782185] iwlwifi 0000:02:00.0: U is_lq_table_valid Channel 1 is not a=
n HT channel
[   25.782188] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_TX_LINK_QUALITY_CMD
[   25.782192] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_TX_LINK_QUALITY_CMD
[   25.783458] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_TX_LINK_QUALITY_CMD
[   25.783481] iwlwifi 0000:02:00.0: U iwl_send_lq_cmd init LQ command comp=
lete, clearing sta addition status for sta 15
[   25.783483] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations .... complete.
[   25.783489] iwlwifi 0000:02:00.0: U iwlagn_update_qos send QoS cmd with =
Qos active=3D0 FLAGS=3D0x0
[   25.783491] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_QOS_PARAM
[   25.783493] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_QOS_PARAM
[   25.784705] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_QOS_PARAM
[   25.784717] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   25.784722] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   25.784724] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   25.785029] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   25.861597] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   25.861601] iwlwifi 0000:02:00.0: U iwl_full_rxon_required need full RXO=
N - !iwl_is_associated_ctx(ctx)
[   25.861604] iwlwifi 0000:02:00.0: U iwlagn_commit_rxon Going to commit R=
XON
[   25.861605]   * without RXON_FILTER_ASSOC_MSK
[   25.861606]   * channel =3D 1
[   25.861606]   * bssid =3D 00:00:00:00:00:00
[   25.861608] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_RXON
[   25.861610] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_RXON
[   25.870280] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_RXON
[   25.870317] iwlwifi 0000:02:00.0: U iwl_clear_ucode_stations Clearing uc=
ode stations in driver
[   25.870320] iwlwifi 0000:02:00.0: I iwl_clear_ucode_stations Clearing uc=
ode active for station 15
[   25.870324] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations ... start.
[   25.870326] iwlwifi 0000:02:00.0: I iwl_restore_stations Restoring sta f=
f:ff:ff:ff:ff:ff
[   25.870328] iwlwifi 0000:02:00.0: U iwl_send_add_sta Adding sta 15 (ff:f=
f:ff:ff:ff:ff) synchronously
[   25.870330] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_ADD_STA
[   25.870332] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_ADD_STA
[   25.878652] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Processing =
response for adding station 15
[   25.878654] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp REPLY_ADD_S=
TA PASSED
[   25.878656] iwlwifi 0000:02:00.0: I iwl_sta_ucode_activate Added STA id =
15 addr ff:ff:ff:ff:ff:ff to uCode
[   25.878659] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on id 15 addr ff:ff:ff:ff:ff:ff
[   25.878661] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on according to cmd buffer ff:ff:ff:ff:ff:ff
[   25.878663] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_ADD_STA
[   25.878676] iwlwifi 0000:02:00.0: U is_lq_table_valid Channel 1 is not a=
n HT channel
[   25.878680] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_TX_LINK_QUALITY_CMD
[   25.878683] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_TX_LINK_QUALITY_CMD
[   25.884962] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_TX_LINK_QUALITY_CMD
[   25.884973] iwlwifi 0000:02:00.0: U iwl_send_lq_cmd init LQ command comp=
lete, clearing sta addition status for sta 15
[   25.884977] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations .... complete.
[   25.884995] iwlwifi 0000:02:00.0: U iwl_down iwlwifi is going down
[   25.884999] iwlwifi 0000:02:00.0: U iwl_clear_ucode_stations Clearing uc=
ode stations in driver
[   25.885001] iwlwifi 0000:02:00.0: I iwl_clear_ucode_stations Clearing uc=
ode active for station 15
[   25.885551] iwlwifi 0000:02:00.0: U iwl_apm_stop Stop card, put in low p=
ower state
[   25.885566] iwlwifi 0000:02:00.0: U iwl_apm_stop_master stop master
[   25.885632] iwlwifi 0000:02:00.0: U iwl_apm_stop Stop card, put in low p=
ower state
[   25.885647] iwlwifi 0000:02:00.0: U iwl_apm_stop_master stop master
[   25.893766] iwlwifi 0000:02:00.0: I iwl_prep_station Add STA to driver I=
D 15: ff:ff:ff:ff:ff:ff
[   25.893770] iwlwifi 0000:02:00.0: I iwl_prep_station Add STA to driver I=
D 14: ff:ff:ff:ff:ff:ff
[   25.893773] iwlwifi 0000:02:00.0: U iwl_prepare_card_hw iwl_trans_prepar=
e_card_hw enter
[   25.893806] iwlwifi 0000:02:00.0: U iwl_set_hw_ready hardware ready
[   25.893833] iwlwifi 0000:02:00.0: U iwl_apm_init Init card's basic funct=
ions
[   25.893878] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[   25.900650] iwlwifi 0000:02:00.0: Radio type=3D0x1-0x2-0x0
[   25.967097] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command COEX_PRIORITY_TABLE_CMD
[   25.968139] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command COEX_PRIORITY_TABLE_CMD
[   25.969382] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command COEX_PRIORITY_TABLE_CMD
[   25.970473] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_PHY_CALIBRATION_CMD
[   25.971602] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_PHY_CALIBRATION_CMD
[   25.972840] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_PHY_CALIBRATION_CMD
[   25.973911] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_PHY_CALIBRATION_CMD
[   25.974981] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_PHY_CALIBRATION_CMD
[   25.976219] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_PHY_CALIBRATION_CMD
[   25.977296] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_PHY_CALIBRATION_CMD
[   25.978380] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_PHY_CALIBRATION_CMD
[   25.979680] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_PHY_CALIBRATION_CMD
[   25.980800] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_PHY_CALIBRATION_CMD
[   25.981898] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_PHY_CALIBRATION_CMD
[   25.983194] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_PHY_CALIBRATION_CMD
[   25.984299] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_PHY_CALIBRATION_CMD
[   25.985413] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_PHY_CALIBRATION_CMD
[   25.986694] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_PHY_CALIBRATION_CMD
[   25.987841] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_PHY_CALIBRATION_CMD
[   25.988964] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_PHY_CALIBRATION_CMD
[   25.990278] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_PHY_CALIBRATION_CMD
[   25.991438] iwlwifi 0000:02:00.0: U iwl_alive_start Runtime Alive receiv=
ed.
[   25.992557] iwlwifi 0000:02:00.0: U iwl_send_bt_config BT coex active
[   25.993736] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_BT_CONFIG
[   25.994868] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_BT_CONFIG
[   25.994961] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_BT_CONFIG
[   25.994973] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command CALIBRATION_CFG_CMD
[   25.994975] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command CALIBRATION_CFG_CMD
[   25.995053] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command CALIBRATION_CFG_CMD
[   25.995070] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command TX_ANT_CONFIGURATION_CMD
[   25.995071] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command TX_ANT_CONFIGURATION_CMD
[   26.022265] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command TX_ANT_CONFIGURATION_CMD
[   26.023404] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   26.024520] iwlwifi 0000:02:00.0: U iwl_full_rxon_required need full RXO=
N - !iwl_is_associated_ctx(ctx)
[   26.025754] iwlwifi 0000:02:00.0: U iwlagn_commit_rxon Going to commit R=
XON
[   26.025755]   * without RXON_FILTER_ASSOC_MSK
[   26.025755]   * channel =3D 1
[   26.025756]   * bssid =3D 00:00:00:00:00:00
[   26.030111] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_RXON
[   26.031310] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_RXON
[   26.033647] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_RXON
[   26.034805] iwlwifi 0000:02:00.0: U iwl_clear_ucode_stations Clearing uc=
ode stations in driver
[   26.036356] iwlwifi 0000:02:00.0: U iwl_clear_ucode_stations No active s=
tations found to be cleared
[   26.037899] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations ... start.
[   26.037902] iwlwifi 0000:02:00.0: I iwl_restore_stations Restoring sta f=
f:ff:ff:ff:ff:ff
[   26.037906] iwlwifi 0000:02:00.0: U iwl_send_add_sta Adding sta 15 (ff:f=
f:ff:ff:ff:ff) synchronously
[   26.037909] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_ADD_STA
[   26.037912] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_ADD_STA
[   26.050390] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Processing =
response for adding station 15
[   26.051533] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp REPLY_ADD_S=
TA PASSED
[   26.052632] iwlwifi 0000:02:00.0: I iwl_sta_ucode_activate Added STA id =
15 addr ff:ff:ff:ff:ff:ff to uCode
[   26.053738] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on id 15 addr ff:ff:ff:ff:ff:ff
[   26.054850] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on according to cmd buffer ff:ff:ff:ff:00:ff
[   26.055960] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_ADD_STA
[   26.057077] iwlwifi 0000:02:00.0: U is_lq_table_valid Channel 1 is not a=
n HT channel
[   26.057080] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_TX_LINK_QUALITY_CMD
[   26.057083] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_TX_LINK_QUALITY_CMD
[   26.058225] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_TX_LINK_QUALITY_CMD
[   26.058232] iwlwifi 0000:02:00.0: U iwl_send_lq_cmd init LQ command comp=
lete, clearing sta addition status for sta 15
[   26.058235] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations .... complete.
[   26.058240] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_CT_KILL_CONFIG_CMD
[   26.058243] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_CT_KILL_CONFIG_CMD
[   26.061586] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_CT_KILL_CONFIG_CMD
[   26.061593] iwlwifi 0000:02:00.0: U iwl_rf_kill_ct_config REPLY_CT_KILL_=
CONFIG_CMD succeeded, critical temperature enter is 114,exit is 95
[   26.061597] iwlwifi 0000:02:00.0: U iwl_alive_start ALIVE processing com=
plete.
[   26.061601] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command POWER_TABLE_CMD
[   26.061603] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command POWER_TABLE_CMD
[   26.067268] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command POWER_TABLE_CMD
[   26.067277] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   26.067280] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   26.067285] iwlwifi 0000:02:00.0: U iwlagn_mac_start Start UP work done.
[   26.067292] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   26.067296] iwlwifi 0000:02:00.0: U iwl_full_rxon_required need full RXO=
N - !iwl_is_associated_ctx(ctx)
[   26.067299] iwlwifi 0000:02:00.0: U iwlagn_commit_rxon Going to commit R=
XON
[   26.067301]   * without RXON_FILTER_ASSOC_MSK
[   26.067302]   * channel =3D 1
[   26.067302]   * bssid =3D 00:00:00:00:00:00
[   26.067305] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_RXON
[   26.067308] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_RXON
[   26.072971] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_RXON
[   26.072978] iwlwifi 0000:02:00.0: U iwl_clear_ucode_stations Clearing uc=
ode stations in driver
[   26.072982] iwlwifi 0000:02:00.0: I iwl_clear_ucode_stations Clearing uc=
ode active for station 15
[   26.072986] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations ... start.
[   26.072988] iwlwifi 0000:02:00.0: I iwl_restore_stations Restoring sta f=
f:ff:ff:ff:ff:ff
[   26.072992] iwlwifi 0000:02:00.0: U iwl_send_add_sta Adding sta 15 (ff:f=
f:ff:ff:ff:ff) synchronously
[   26.072995] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_ADD_STA
[   26.072997] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_ADD_STA
[   26.087295] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Processing =
response for adding station 15
[   26.087297] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp REPLY_ADD_S=
TA PASSED
[   26.087299] iwlwifi 0000:02:00.0: I iwl_sta_ucode_activate Added STA id =
15 addr ff:ff:ff:ff:ff:ff to uCode
[   26.087301] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on id 15 addr ff:ff:ff:ff:ff:ff
[   26.087303] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on according to cmd buffer ff:ff:ff:ff:ff:ff
[   26.087306] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_ADD_STA
[   26.087314] iwlwifi 0000:02:00.0: U is_lq_table_valid Channel 1 is not a=
n HT channel
[   26.087317] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_TX_LINK_QUALITY_CMD
[   26.087319] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_TX_LINK_QUALITY_CMD
[   26.100304] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_TX_LINK_QUALITY_CMD
[   26.100311] iwlwifi 0000:02:00.0: U iwl_send_lq_cmd init LQ command comp=
lete, clearing sta addition status for sta 15
[   26.100314] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations .... complete.
[   26.100320] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   26.100323] iwlwifi 0000:02:00.0: U iwl_full_rxon_required need full RXO=
N - !iwl_is_associated_ctx(ctx)
[   26.100327] iwlwifi 0000:02:00.0: U iwlagn_commit_rxon Going to commit R=
XON
[   26.100328]   * without RXON_FILTER_ASSOC_MSK
[   26.100329]   * channel =3D 1
[   26.100330]   * bssid =3D 00:00:00:00:00:00
[   26.100332] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_RXON
[   26.100335] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_RXON
[   26.104736] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_RXON
[   26.104742] iwlwifi 0000:02:00.0: U iwl_clear_ucode_stations Clearing uc=
ode stations in driver
[   26.104745] iwlwifi 0000:02:00.0: I iwl_clear_ucode_stations Clearing uc=
ode active for station 15
[   26.104748] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations ... start.
[   26.104750] iwlwifi 0000:02:00.0: I iwl_restore_stations Restoring sta f=
f:ff:ff:ff:ff:ff
[   26.104753] iwlwifi 0000:02:00.0: U iwl_send_add_sta Adding sta 15 (ff:f=
f:ff:ff:ff:ff) synchronously
[   26.104756] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_ADD_STA
[   26.104763] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_ADD_STA
[   26.117791] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Processing =
response for adding station 15
[   26.117793] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp REPLY_ADD_S=
TA PASSED
[   26.117795] iwlwifi 0000:02:00.0: I iwl_sta_ucode_activate Added STA id =
15 addr ff:ff:ff:ff:ff:ff to uCode
[   26.117797] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on id 15 addr ff:ff:ff:ff:ff:ff
[   26.117798] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on according to cmd buffer ff:ff:ff:ff:ff:ff
[   26.117801] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_ADD_STA
[   26.117809] iwlwifi 0000:02:00.0: U is_lq_table_valid Channel 1 is not a=
n HT channel
[   26.117812] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_TX_LINK_QUALITY_CMD
[   26.117814] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_TX_LINK_QUALITY_CMD
[   26.130313] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_TX_LINK_QUALITY_CMD
[   26.130321] iwlwifi 0000:02:00.0: U iwl_send_lq_cmd init LQ command comp=
lete, clearing sta addition status for sta 15
[   26.130324] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations .... complete.
[   26.130329] iwlwifi 0000:02:00.0: U iwlagn_update_qos send QoS cmd with =
Qos active=3D0 FLAGS=3D0x0
[   26.130332] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_QOS_PARAM
[   26.130335] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_QOS_PARAM
[   26.134600] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_QOS_PARAM
[   26.134607] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   26.134612] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   26.134615] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   26.135160] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   28.205350] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_SCAN_CMD
[   28.206467] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_SCAN_CMD
[   28.209282] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_SCAN_CMD
[   28.731557] iwlwifi 0000:02:00.0: U iwl_full_rxon_required need full RXO=
N - !iwl_is_associated_ctx(ctx)
[   28.732697] iwlwifi 0000:02:00.0: U iwlagn_commit_rxon Going to commit R=
XON
[   28.732699]   * without RXON_FILTER_ASSOC_MSK
[   28.732700]   * channel =3D 1
[   28.732700]   * bssid =3D 00:00:00:00:00:00
[   28.737143] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_RXON
[   28.738262] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_RXON
[   28.741020] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_RXON
[   28.742152] iwlwifi 0000:02:00.0: U iwl_clear_ucode_stations Clearing uc=
ode stations in driver
[   28.743248] iwlwifi 0000:02:00.0: I iwl_clear_ucode_stations Clearing uc=
ode active for station 15
[   28.744380] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations ... start.
[   28.744384] iwlwifi 0000:02:00.0: I iwl_restore_stations Restoring sta f=
f:ff:ff:ff:ff:ff
[   28.744387] iwlwifi 0000:02:00.0: U iwl_send_add_sta Adding sta 15 (ff:f=
f:ff:ff:ff:ff) synchronously
[   28.744390] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_ADD_STA
[   28.744393] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_ADD_STA
[   28.745808] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Processing =
response for adding station 15
[   28.745810] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp REPLY_ADD_S=
TA PASSED
[   28.745813] iwlwifi 0000:02:00.0: I iwl_sta_ucode_activate Added STA id =
15 addr ff:ff:ff:ff:ff:ff to uCode
[   28.745817] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on id 15 addr ff:ff:ff:ff:ff:ff
[   28.745819] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on according to cmd buffer ff:ff:ff:ff:ff:ff
[   28.745824] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_ADD_STA
[   28.745834] iwlwifi 0000:02:00.0: U is_lq_table_valid Channel 1 is not a=
n HT channel
[   28.745836] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_TX_LINK_QUALITY_CMD
[   28.745839] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_TX_LINK_QUALITY_CMD
[   28.747905] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_TX_LINK_QUALITY_CMD
[   28.747913] iwlwifi 0000:02:00.0: U iwl_send_lq_cmd init LQ command comp=
lete, clearing sta addition status for sta 15
[   28.747916] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations .... complete.
[   28.747960] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_SCAN_CMD
[   28.747963] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_SCAN_CMD
[   28.750420] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_SCAN_CMD
[   31.477555] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_SCAN_CMD
[   31.479107] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_SCAN_CMD
[   31.483332] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_SCAN_CMD
[   31.484685] wlan0: authenticate with 00:1e:2a:f6:f1:4a
[   31.484693] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   31.485881] iwlwifi 0000:02:00.0: U iwl_full_rxon_required need full RXO=
N - !iwl_is_associated_ctx(ctx)
[   31.485885] iwlwifi 0000:02:00.0: U iwlagn_commit_rxon Going to commit R=
XON
[   31.485886]   * without RXON_FILTER_ASSOC_MSK
[   31.485887]   * channel =3D 1
[   31.485888]   * bssid =3D 00:00:00:00:00:00
[   31.485891] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_RXON
[   31.485893] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_RXON
[   31.487027] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_RXON
[   31.487035] iwlwifi 0000:02:00.0: U iwl_clear_ucode_stations Clearing uc=
ode stations in driver
[   31.487038] iwlwifi 0000:02:00.0: I iwl_clear_ucode_stations Clearing uc=
ode active for station 15
[   31.487042] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations ... start.
[   31.487045] iwlwifi 0000:02:00.0: I iwl_restore_stations Restoring sta f=
f:ff:ff:ff:ff:ff
[   31.487049] iwlwifi 0000:02:00.0: U iwl_send_add_sta Adding sta 15 (ff:f=
f:ff:ff:ff:ff) synchronously
[   31.487052] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_ADD_STA
[   31.487055] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_ADD_STA
[   31.494738] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Processing =
response for adding station 15
[   31.494740] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp REPLY_ADD_S=
TA PASSED
[   31.494742] iwlwifi 0000:02:00.0: I iwl_sta_ucode_activate Added STA id =
15 addr ff:ff:ff:ff:ff:ff to uCode
[   31.494744] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on id 15 addr ff:ff:ff:ff:ff:ff
[   31.494746] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on according to cmd buffer ff:ff:ff:ff:ff:ff
[   31.494748] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_ADD_STA
[   31.494757] iwlwifi 0000:02:00.0: U is_lq_table_valid Channel 1 is not a=
n HT channel
[   31.494759] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_TX_LINK_QUALITY_CMD
[   31.494762] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_TX_LINK_QUALITY_CMD
[   31.508662] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_TX_LINK_QUALITY_CMD
[   31.508670] iwlwifi 0000:02:00.0: U iwl_send_lq_cmd init LQ command comp=
lete, clearing sta addition status for sta 15
[   31.508673] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations .... complete.
[   31.508681] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   31.508685] iwlwifi 0000:02:00.0: U iwl_full_rxon_required need full RXO=
N - !iwl_is_associated_ctx(ctx)
[   31.508688] iwlwifi 0000:02:00.0: U iwlagn_commit_rxon Going to commit R=
XON
[   31.508689]   * without RXON_FILTER_ASSOC_MSK
[   31.508690]   * channel =3D 1
[   31.508691]   * bssid =3D 00:1e:2a:f6:f1:4a
[   31.508693] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_RXON
[   31.508696] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_RXON
[   31.513024] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_RXON
[   31.513031] iwlwifi 0000:02:00.0: U iwl_clear_ucode_stations Clearing uc=
ode stations in driver
[   31.513034] iwlwifi 0000:02:00.0: I iwl_clear_ucode_stations Clearing uc=
ode active for station 15
[   31.513037] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations ... start.
[   31.513040] iwlwifi 0000:02:00.0: I iwl_restore_stations Restoring sta f=
f:ff:ff:ff:ff:ff
[   31.513042] iwlwifi 0000:02:00.0: U iwl_send_add_sta Adding sta 15 (ff:f=
f:ff:ff:ff:ff) synchronously
[   31.513045] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_ADD_STA
[   31.513048] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_ADD_STA
[   31.526110] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Processing =
response for adding station 15
[   31.526112] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp REPLY_ADD_S=
TA PASSED
[   31.526113] iwlwifi 0000:02:00.0: I iwl_sta_ucode_activate Added STA id =
15 addr ff:ff:ff:ff:ff:ff to uCode
[   31.526115] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on id 15 addr ff:ff:ff:ff:ff:ff
[   31.526117] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on according to cmd buffer ff:ff:ff:ff:ff:ff
[   31.526120] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_ADD_STA
[   31.526128] iwlwifi 0000:02:00.0: U is_lq_table_valid Channel 1 is not a=
n HT channel
[   31.526130] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_TX_LINK_QUALITY_CMD
[   31.526133] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_TX_LINK_QUALITY_CMD
[   31.538790] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_TX_LINK_QUALITY_CMD
[   31.538797] iwlwifi 0000:02:00.0: U iwl_send_lq_cmd init LQ command comp=
lete, clearing sta addition status for sta 15
[   31.538800] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations .... complete.
[   31.538806] iwlwifi 0000:02:00.0: U iwlagn_mac_sta_add proceeding to add=
 station 00:1e:2a:f6:f1:4a
[   31.538809] iwlwifi 0000:02:00.0: I iwl_prep_station Add STA to driver I=
D 0: 00:1e:2a:f6:f1:4a
[   31.538812] iwlwifi 0000:02:00.0: U iwl_send_add_sta Adding sta 0 (00:1e=
:2a:f6:f1:4a) synchronously
[   31.538815] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_ADD_STA
[   31.538818] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_ADD_STA
[   31.543089] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Processing =
response for adding station 0
[   31.543091] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp REPLY_ADD_S=
TA PASSED
[   31.543093] iwlwifi 0000:02:00.0: I iwl_sta_ucode_activate Added STA id =
0 addr 00:1e:2a:f6:f1:4a to uCode
[   31.543095] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on id 0 addr 00:1e:2a:f6:f1:4a
[   31.543097] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on according to cmd buffer 00:1e:2a:f6:f1:4a
[   31.543100] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_ADD_STA
[   31.543114] wlan0: send auth to 00:1e:2a:f6:f1:4a (try 1/3)
[   31.557374] wlan0: authenticated
[   31.557712] wlan0: associate with 00:1e:2a:f6:f1:4a (try 1/3)
[   31.560404] wlan0: RX AssocResp from 00:1e:2a:f6:f1:4a (capab=3D0x431 st=
atus=3D0 aid=3D2)
[   31.560407] wlan0: associated
[   31.560412] iwlwifi 0000:02:00.0: U iwl_send_add_sta Adding sta 0 (00:00=
:00:00:00:00) synchronously
[   31.561557] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_ADD_STA
[   31.562660] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_ADD_STA
[   31.564187] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Processing =
response for adding station 0
[   31.565311] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp REPLY_ADD_S=
TA PASSED
[   31.566392] iwlwifi 0000:02:00.0: I iwl_sta_ucode_activate STA id 0 addr=
 00:1e:2a:f6:f1:4a already present in uCode (according to driver)
[   31.567507] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on id 0 addr 00:1e:2a:f6:f1:4a
[   31.568606] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on according to cmd buffer 00:00:00:00:00:00
[   31.569706] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_ADD_STA
[   31.570810] iwlwifi 0000:02:00.0: U iwlagn_mac_sta_state Initializing ra=
te scaling for station 00:1e:2a:f6:f1:4a
[   31.571955] iwlwifi 0000:02:00.0: U is_lq_table_valid Channel 1 is not a=
n HT channel
[   31.571958] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_TX_LINK_QUALITY_CMD
[   31.571961] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_TX_LINK_QUALITY_CMD
[   31.574203] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_TX_LINK_QUALITY_CMD
[   31.574210] iwlwifi 0000:02:00.0: U iwl_send_lq_cmd init LQ command comp=
lete, clearing sta addition status for sta 0
[   31.574216] iwlwifi 0000:02:00.0: U iwlagn_update_qos send QoS cmd with =
Qos active=3D1 FLAGS=3D0x1
[   31.574218] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_QOS_PARAM
[   31.574221] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_QOS_PARAM
[   31.576489] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_QOS_PARAM
[   31.576496] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   31.576499] iwlwifi 0000:02:00.0: U iwl_full_rxon_required need full RXO=
N - !iwl_is_associated_ctx(ctx)
[   31.576503] iwlwifi 0000:02:00.0: U iwlagn_commit_rxon Going to commit R=
XON
[   31.576504]   * with RXON_FILTER_ASSOC_MSK
[   31.576505]   * channel =3D 1
[   31.576505]   * bssid =3D 00:1e:2a:f6:f1:4a
[   31.576508] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_RXON
[   31.576510] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_RXON
[   31.582170] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_RXON
[   31.582177] iwlwifi 0000:02:00.0: U iwl_clear_ucode_stations Clearing uc=
ode stations in driver
[   31.582179] iwlwifi 0000:02:00.0: I iwl_clear_ucode_stations Clearing uc=
ode active for station 0
[   31.582183] iwlwifi 0000:02:00.0: I iwl_clear_ucode_stations Clearing uc=
ode active for station 15
[   31.582186] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations ... start.
[   31.582189] iwlwifi 0000:02:00.0: I iwl_restore_stations Restoring sta 0=
0:1e:2a:f6:f1:4a
[   31.582192] iwlwifi 0000:02:00.0: I iwl_restore_stations Restoring sta f=
f:ff:ff:ff:ff:ff
[   31.582195] iwlwifi 0000:02:00.0: U iwl_send_add_sta Adding sta 0 (00:1e=
:2a:f6:f1:4a) synchronously
[   31.582198] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_ADD_STA
[   31.582200] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_ADD_STA
[   31.593530] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Processing =
response for adding station 0
[   31.593531] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp REPLY_ADD_S=
TA PASSED
[   31.593533] iwlwifi 0000:02:00.0: I iwl_sta_ucode_activate Added STA id =
0 addr 00:1e:2a:f6:f1:4a to uCode
[   31.593535] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on id 0 addr 00:1e:2a:f6:f1:4a
[   31.593537] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on according to cmd buffer 00:1e:2a:f6:f1:4a
[   31.593540] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_ADD_STA
[   31.593548] iwlwifi 0000:02:00.0: U is_lq_table_valid Channel 1 is not a=
n HT channel
[   31.593550] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_TX_LINK_QUALITY_CMD
[   31.593553] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_TX_LINK_QUALITY_CMD
[   31.608768] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_TX_LINK_QUALITY_CMD
[   31.608775] iwlwifi 0000:02:00.0: U iwl_send_lq_cmd init LQ command comp=
lete, clearing sta addition status for sta 0
[   31.608779] iwlwifi 0000:02:00.0: U iwl_send_add_sta Adding sta 15 (ff:f=
f:ff:ff:ff:ff) synchronously
[   31.608782] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_ADD_STA
[   31.608785] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_ADD_STA
[   31.613156] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Processing =
response for adding station 15
[   31.613158] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp REPLY_ADD_S=
TA PASSED
[   31.613159] iwlwifi 0000:02:00.0: I iwl_sta_ucode_activate Added STA id =
15 addr ff:ff:ff:ff:ff:ff to uCode
[   31.613162] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on id 15 addr ff:ff:ff:ff:ff:ff
[   31.613163] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on according to cmd buffer ff:ff:ff:ff:ff:ff
[   31.613166] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_ADD_STA
[   31.613173] iwlwifi 0000:02:00.0: U is_lq_table_valid Channel 1 is not a=
n HT channel
[   31.613176] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_TX_LINK_QUALITY_CMD
[   31.613179] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_TX_LINK_QUALITY_CMD
[   31.623996] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_TX_LINK_QUALITY_CMD
[   31.624003] iwlwifi 0000:02:00.0: U iwl_send_lq_cmd init LQ command comp=
lete, clearing sta addition status for sta 15
[   31.624006] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations .... complete.
[   31.624010] iwlwifi 0000:02:00.0: U iwl_send_rxon_timing beacon interval=
 100 beacon timer 23161 beacon tim 0
[   31.624013] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_RXON_TIMING
[   31.624016] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_RXON_TIMING
[   31.628286] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_RXON_TIMING
[   31.628293] iwlwifi 0000:02:00.0: U iwlagn_update_qos send QoS cmd with =
Qos active=3D1 FLAGS=3D0x1
[   31.628295] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_QOS_PARAM
[   31.628298] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_QOS_PARAM
[   31.634733] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_QOS_PARAM
[   31.634740] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_RXON
[   31.634742] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_RXON
[   31.639041] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_RXON
[   31.639051] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_TX_POWER_DBM_CMD
[   31.639054] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_TX_POWER_DBM_CMD
[   31.642323] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_TX_POWER_DBM_CMD
[   31.642866] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   33.669744] iwlwifi 0000:02:00.0: U iwl_send_add_sta Adding sta 0 (00:1e=
:2a:f6:f1:4a) synchronously
[   33.670889] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_ADD_STA
[   33.672034] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_ADD_STA
[   33.673328] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Processing =
response for adding station 0
[   33.674474] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp REPLY_ADD_S=
TA PASSED
[   33.675607] iwlwifi 0000:02:00.0: I iwl_sta_ucode_activate STA id 0 addr=
 00:1e:2a:f6:f1:4a already present in uCode (according to driver)
[   33.676777] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on id 0 addr 00:1e:2a:f6:f1:4a
[   33.677951] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on according to cmd buffer 00:1e:2a:f6:f1:4a
[   33.679127] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_ADD_STA
[   33.680354] iwlwifi 0000:02:00.0: U iwl_send_add_sta Adding sta 0 (00:1e=
:2a:f6:f1:4a) synchronously
[   33.681547] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_ADD_STA
[   33.682766] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_ADD_STA
[   33.683995] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Processing =
response for adding station 0
[   33.683997] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp REPLY_ADD_S=
TA PASSED
[   33.683999] iwlwifi 0000:02:00.0: I iwl_sta_ucode_activate STA id 0 addr=
 00:1e:2a:f6:f1:4a already present in uCode (according to driver)
[   33.684001] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on id 0 addr 00:1e:2a:f6:f1:4a
[   33.684003] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on according to cmd buffer 00:1e:2a:f6:f1:4a
[   33.684005] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_ADD_STA
[   34.774147] iwlwifi 0000:02:00.0: I is_lq_table_valid Channel 1 is not a=
n HT channel
[   39.430439] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[   39.504532] iwlwifi 0000:02:00.0: I is_lq_table_valid Channel 1 is not a=
n HT channel
[   41.793681] wlan0: no IPv6 routers present
[   44.760987] iwlwifi 0000:02:00.0: I is_lq_table_valid Channel 1 is not a=
n HT channel
[   50.756538] iwlwifi 0000:02:00.0: I is_lq_table_valid Channel 1 is not a=
n HT channel
[   51.260128] iwlwifi 0000:02:00.0: I is_lq_table_valid Channel 1 is not a=
n HT channel
[   55.462355] iwlwifi 0000:02:00.0: I is_lq_table_valid Channel 1 is not a=
n HT channel
[   68.728965] iwlwifi 0000:02:00.0: I is_lq_table_valid Channel 1 is not a=
n HT channel
[   74.725596] iwlwifi 0000:02:00.0: I is_lq_table_valid Channel 1 is not a=
n HT channel
[   75.722499] iwlwifi 0000:02:00.0: I is_lq_table_valid Channel 1 is not a=
n HT channel
[   85.707093] iwlwifi 0000:02:00.0: I is_lq_table_valid Channel 1 is not a=
n HT channel
[   93.695814] iwlwifi 0000:02:00.0: I is_lq_table_valid Channel 1 is not a=
n HT channel
[  102.685134] iwlwifi 0000:02:00.0: I is_lq_table_valid Channel 1 is not a=
n HT channel
[  111.673516] iwlwifi 0000:02:00.0: I is_lq_table_valid Channel 1 is not a=
n HT channel
[  123.657977] iwlwifi 0000:02:00.0: I is_lq_table_valid Channel 1 is not a=
n HT channel
[  129.651489] iwlwifi 0000:02:00.0: I is_lq_table_valid Channel 1 is not a=
n HT channel
[  143.634475] iwlwifi 0000:02:00.0: I is_lq_table_valid Channel 1 is not a=
n HT channel
[  149.629175] iwlwifi 0000:02:00.0: I is_lq_table_valid Channel 1 is not a=
n HT channel
[  150.622973] iwlwifi 0000:02:00.0: I is_lq_table_valid Channel 1 is not a=
n HT channel
[  161.608724] iwlwifi 0000:02:00.0: I is_lq_table_valid Channel 1 is not a=
n HT channel
[  174.591975] iwlwifi 0000:02:00.0: I is_lq_table_valid Channel 1 is not a=
n HT channel
[  180.587679] iwlwifi 0000:02:00.0: I is_lq_table_valid Channel 1 is not a=
n HT channel
[  181.585452] iwlwifi 0000:02:00.0: I is_lq_table_valid Channel 1 is not a=
n HT channel
[  190.442730] iwlwifi 0000:02:00.0: I is_lq_table_valid Channel 1 is not a=
n HT channel
[  205.552012] iwlwifi 0000:02:00.0: I is_lq_table_valid Channel 1 is not a=
n HT channel
[  211.547011] iwlwifi 0000:02:00.0: I is_lq_table_valid Channel 1 is not a=
n HT channel
[  212.547434] iwlwifi 0000:02:00.0: I is_lq_table_valid Channel 1 is not a=
n HT channel
[  221.531319] iwlwifi 0000:02:00.0: I is_lq_table_valid Channel 1 is not a=
n HT channel
[  230.520028] iwlwifi 0000:02:00.0: I is_lq_table_valid Channel 1 is not a=
n HT channel
[  239.508064] iwlwifi 0000:02:00.0: I is_lq_table_valid Channel 1 is not a=
n HT channel
[  242.009367] iwlwifi 0000:02:00.0: U iwl_op_mode_dvm_stop *** UNLOAD DRIV=
ER ***
[  242.009720] wlan0: deauthenticating from 00:1e:2a:f6:f1:4a by local choi=
ce (reason=3D3)
[  242.013514] iwlwifi 0000:02:00.0: U iwl_send_add_sta Adding sta 0 (00:1e=
:2a:f6:f1:4a) synchronously
[  242.013773] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_ADD_STA
[  242.014039] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_ADD_STA
[  242.014435] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Processing =
response for adding station 0
[  242.014744] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp REPLY_ADD_S=
TA PASSED
[  242.015062] iwlwifi 0000:02:00.0: I iwl_sta_ucode_activate STA id 0 addr=
 00:1e:2a:f6:f1:4a already present in uCode (according to driver)
[  242.015432] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on id 0 addr 00:1e:2a:f6:f1:4a
[  242.015817] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on according to cmd buffer 00:1e:2a:f6:f1:4a
[  242.016226] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_ADD_STA
[  242.016673] iwlwifi 0000:02:00.0: U iwlagn_mac_sta_remove proceeding to =
remove station 00:1e:2a:f6:f1:4a
[  242.017168] iwlwifi 0000:02:00.0: U iwl_deactivate_station Deactivating =
STA: 00:1e:2a:f6:f1:4a (0)
[  242.018465] iwlwifi 0000:02:00.0: U iwlagn_update_qos send QoS cmd with =
Qos active=3D0 FLAGS=3D0x0
[  242.018971] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_QOS_PARAM
[  242.019504] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_QOS_PARAM
[  242.020138] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_QOS_PARAM
[  242.020744] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[  242.021331] iwlwifi 0000:02:00.0: U iwl_full_rxon_required need full RXO=
N - compare_ether_addr(staging->bssid_addr, active->bssid_addr)
[  242.021978] iwlwifi 0000:02:00.0: U iwlagn_commit_rxon Going to commit R=
XON
[  242.021979]   * without RXON_FILTER_ASSOC_MSK
[  242.021980]   * channel =3D 1
[  242.021981]   * bssid =3D 00:00:00:00:00:00
[  242.024703] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_RXON
[  242.025442] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_RXON
[  242.026250] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_RXON
[  242.026289] iwlwifi 0000:02:00.0: U iwl_clear_ucode_stations Clearing uc=
ode stations in driver
[  242.026293] iwlwifi 0000:02:00.0: I iwl_clear_ucode_stations Clearing uc=
ode active for station 0
[  242.026296] iwlwifi 0000:02:00.0: I iwl_clear_ucode_stations Clearing uc=
ode active for station 15
[  242.026300] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations ... start.
[  242.026303] iwlwifi 0000:02:00.0: I iwl_restore_stations Restoring sta f=
f:ff:ff:ff:ff:ff
[  242.026306] iwlwifi 0000:02:00.0: U iwl_send_add_sta Adding sta 15 (ff:f=
f:ff:ff:ff:ff) synchronously
[  242.026309] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_ADD_STA
[  242.026311] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_ADD_STA
[  242.033751] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Processing =
response for adding station 15
[  242.033753] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp REPLY_ADD_S=
TA PASSED
[  242.033755] iwlwifi 0000:02:00.0: I iwl_sta_ucode_activate Added STA id =
15 addr ff:ff:ff:ff:ff:ff to uCode
[  242.033757] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on id 15 addr ff:ff:ff:ff:ff:ff
[  242.033759] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on according to cmd buffer ff:ff:ff:ff:ff:ff
[  242.033762] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_ADD_STA
[  242.033794] iwlwifi 0000:02:00.0: U is_lq_table_valid Channel 1 is not a=
n HT channel
[  242.033797] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_TX_LINK_QUALITY_CMD
[  242.033799] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_TX_LINK_QUALITY_CMD
[  242.039622] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_TX_LINK_QUALITY_CMD
[  242.039633] iwlwifi 0000:02:00.0: U iwl_send_lq_cmd init LQ command comp=
lete, clearing sta addition status for sta 15
[  242.039636] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations .... complete.
[  242.474051] cfg80211: Calling CRDA to update world regulatory domain
[  242.475812] iwlwifi 0000:02:00.0: U iwlagn_set_rxon_chain rx_chain=3D0x2=
406 active=3D2 idle=3D1
[  242.476994] iwlwifi 0000:02:00.0: U iwl_full_rxon_required need full RXO=
N - !iwl_is_associated_ctx(ctx)
[  242.478119] iwlwifi 0000:02:00.0: U iwlagn_commit_rxon Going to commit R=
XON
[  242.478120]   * without RXON_FILTER_ASSOC_MSK
[  242.478121]   * channel =3D 1
[  242.478122]   * bssid =3D 00:00:00:00:00:00
[  242.482540] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_RXON
[  242.482542] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_RXON
[  242.484116] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_RXON
[  242.484130] iwlwifi 0000:02:00.0: U iwl_clear_ucode_stations Clearing uc=
ode stations in driver
[  242.484133] iwlwifi 0000:02:00.0: I iwl_clear_ucode_stations Clearing uc=
ode active for station 15
[  242.484137] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations ... start.
[  242.484140] iwlwifi 0000:02:00.0: I iwl_restore_stations Restoring sta f=
f:ff:ff:ff:ff:ff
[  242.484144] iwlwifi 0000:02:00.0: U iwl_send_add_sta Adding sta 15 (ff:f=
f:ff:ff:ff:ff) synchronously
[  242.484146] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_ADD_STA
[  242.484149] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_ADD_STA
[  242.485445] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Processing =
response for adding station 15
[  242.485447] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp REPLY_ADD_S=
TA PASSED
[  242.485450] iwlwifi 0000:02:00.0: I iwl_sta_ucode_activate Added STA id =
15 addr ff:ff:ff:ff:ff:ff to uCode
[  242.485452] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on id 15 addr ff:ff:ff:ff:ff:ff
[  242.485454] iwlwifi 0000:02:00.0: I iwl_process_add_sta_resp Added stati=
on according to cmd buffer ff:ff:ff:ff:ff:ff
[  242.485457] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_ADD_STA
[  242.485468] iwlwifi 0000:02:00.0: U is_lq_table_valid Channel 1 is not a=
n HT channel
[  242.485470] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Attempting to send=
 sync command REPLY_TX_LINK_QUALITY_CMD
[  242.485472] iwlwifi 0000:02:00.0: U iwl_send_cmd_sync Setting HCMD_ACTIV=
E for command REPLY_TX_LINK_QUALITY_CMD
[  242.487393] iwlwifi 0000:02:00.0: I iwl_tx_cmd_complete Clearing HCMD_AC=
TIVE for command REPLY_TX_LINK_QUALITY_CMD
[  242.487405] iwlwifi 0000:02:00.0: U iwl_send_lq_cmd init LQ command comp=
lete, clearing sta addition status for sta 15
[  242.487408] iwlwifi 0000:02:00.0: U iwl_restore_stations Restoring all k=
nown stations .... complete.
[  242.487418] iwlwifi 0000:02:00.0: U iwl_down iwlwifi is going down
[  242.487423] iwlwifi 0000:02:00.0: U iwl_clear_ucode_stations Clearing uc=
ode stations in driver
[  242.487426] iwlwifi 0000:02:00.0: I iwl_clear_ucode_stations Clearing uc=
ode active for station 15
[  242.488023] iwlwifi 0000:02:00.0: U iwl_apm_stop Stop card, put in low p=
ower state
[  242.488039] iwlwifi 0000:02:00.0: U iwl_apm_stop_master stop master
[  242.488105] iwlwifi 0000:02:00.0: U iwl_apm_stop Stop card, put in low p=
ower state
[  242.488120] iwlwifi 0000:02:00.0: U iwl_apm_stop_master stop master
[  242.521412] cfg80211: World regulatory domain updated:
[  242.522921] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenn=
a_gain, max_eirp)
[  242.524433] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mB=
i, 2000 mBm)
[  242.524437] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mB=
i, 2000 mBm)
[  242.524439] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mB=
i, 2000 mBm)
[  242.524442] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mB=
i, 2000 mBm)
[  242.524444] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mB=
i, 2000 mBm)
[  242.535825] iwlwifi 0000:02:00.0: U iwl_apm_stop Stop card, put in low p=
ower state
[  242.536967] iwlwifi 0000:02:00.0: U iwl_apm_stop_master stop master
[  242.538449] iwlwifi 0000:02:00.0: U iwl_apm_stop Stop card, put in low p=
ower state
[  242.538488] iwlwifi 0000:02:00.0: U iwl_apm_stop_master stop master
[  242.550960] modprobe used greatest stack depth: 4272 bytes left
[  245.909926] cfg80211: Calling CRDA to update world regulatory domain
[  245.913251] iwlwifi: Intel(R) Wireless WiFi Link AGN driver for Linux, i=
n-tree:d
[  245.914322] iwlwifi: Copyright(c) 2003-2012 Intel Corporation
[  245.915165] cfg80211: World regulatory domain updated:
[  245.915167] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenn=
a_gain, max_eirp)
[  245.915169] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mB=
i, 2000 mBm)
[  245.915171] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mB=
i, 2000 mBm)
[  245.915173] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mB=
i, 2000 mBm)
[  245.915174] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mB=
i, 2000 mBm)
[  245.915176] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mB=
i, 2000 mBm)
[  245.922504] iwlwifi 0000:02:00.0: pci_resource_len =3D 0x00002000
[  245.923495] iwlwifi 0000:02:00.0: pci_resource_base =3D ffffc9000543c000
[  245.924476] iwlwifi 0000:02:00.0: HW Revision ID =3D 0x34
[  245.925775] iwlwifi 0000:02:00.0: irq 45 for MSI/MSI-X
[  245.926916] iwlwifi 0000:02:00.0: loaded firmware version 17.168.5.3 bui=
ld 42301
[  245.927093] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_DEBUG enabled
[  245.929055] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_DEBUGFS disabled
[  245.930030] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_DEVICE_TRACING disabled
[  245.931004] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE enabled
[  245.931957] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_P2P enabled
[  245.932898] iwlwifi 0000:02:00.0: Detected Intel(R) Centrino(R) Advanced=
-N 6205 AGN, REV=3D0xB0
[  245.933939] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[  245.952046] iwlwifi 0000:02:00.0: device EEPROM VER=3D0x715, CALIB=3D0x6
[  245.952983] iwlwifi 0000:02:00.0: Device SKU: 0x1F0
[  245.953900] iwlwifi 0000:02:00.0: Valid Tx ant: 0x3, Valid Rx ant: 0x3
[  245.954847] iwlwifi 0000:02:00.0: Tunable channels: 13 802.11bg, 24 802.=
11a channels
[  245.955890] Registered led device: phy0-led
[  245.956170] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[  246.808762] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[  246.816483] iwlwifi 0000:02:00.0: Radio type=3D0x1-0x2-0x0
[  247.103081] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[  247.110769] iwlwifi 0000:02:00.0: Radio type=3D0x1-0x2-0x0
[  247.228448] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  247.243096] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[  247.250792] iwlwifi 0000:02:00.0: Radio type=3D0x1-0x2-0x0
[  247.377229] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  247.387143] wpa_supplicant used greatest stack depth: 3760 bytes left
[  249.402596] [drm] Changing LVDS panel from (+hsync, -vsync) to (-hsync, =
-vsync)
[  251.795682] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[  251.802476] iwlwifi 0000:02:00.0: Radio type=3D0x1-0x2-0x0
[  251.924185] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  255.256598] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[  255.263394] iwlwifi 0000:02:00.0: Radio type=3D0x1-0x2-0x0
[  255.390345] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  255.407042] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[  255.413847] iwlwifi 0000:02:00.0: Radio type=3D0x1-0x2-0x0
[  255.540159] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  257.324362] [drm] Changing LVDS panel from (-hsync, -vsync) to (+hsync, =
-vsync)
[  260.816246] wlan0: authenticate with 00:1e:2a:f6:f1:4a
[  260.822729] wlan0: send auth to 00:1e:2a:f6:f1:4a (try 1/3)
[  260.826777] wlan0: authenticated
[  260.827013] wlan0: associate with 00:1e:2a:f6:f1:4a (try 1/3)
[  260.829668] wlan0: RX AssocResp from 00:1e:2a:f6:f1:4a (capab=3D0x431 st=
atus=3D0 aid=3D2)
[  260.829671] wlan0: associated
[  260.843923] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[  261.089477] [drm] Changing LVDS panel from (+hsync, -vsync) to (-hsync, =
-vsync)
[  264.422170] [drm] Changing LVDS panel from (-hsync, -vsync) to (+hsync, =
-vsync)
[  266.720170] [drm] Changing LVDS panel from (+hsync, -vsync) to (-hsync, =
-vsync)
[  271.168692] wlan0: no IPv6 routers present
[  271.484298] [drm:pch_irq_handler] *ERROR* PCH poison interrupt
[  288.594895] [drm] Changing LVDS panel from (-hsync, -vsync) to (+hsync, =
-vsync)
[  294.970101] [drm:pch_irq_handler] *ERROR* PCH poison interrupt

--cNdxnHkX5QqsyA0e--

--St7VIuEGZ6dlpu13
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAEBAgAGBQJPo3j8AAoJEFMQTLzJFOZF9mgH/2Khj48JaGpE+EgzIEGYdG/C
5OubxjYx9lHMymxIcJ7O1RMCHBVRMGhMnE5KFlHb6Sq14Rwd8TezqRcNdekF7lEk
qEcRlRoU5ZX10RdGA+zIZ8mzAmpTZBjEOtLm4NpflSrN4oFNUNfZJxTiteNQtrql
M0TJzUMZA8D18UWz4FBmjYOv7VLZFDnnpz4552MwX0GS2qNo3+JqZOh8u24xuNN0
pPKaYUUIt2NWiYExxIRF74Hxm5GUKeH/I8ctBkpyrB385Ea3CJlRInrQ9JPsIrW/
NIsrpLlqUQulZJsRd+jpLFAcaIgb0ttzfyWrsRr4p3kkZ0nKveHo89j6jj2fw44=
=9Sui
-----END PGP SIGNATURE-----

--St7VIuEGZ6dlpu13--
