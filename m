Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:64706 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab0IHDeP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Sep 2010 23:34:15 -0400
Received: by qwh6 with SMTP id 6so5262302qwh.19
        for <linux-wireless@vger.kernel.org>; Tue, 07 Sep 2010 20:34:13 -0700 (PDT)
Message-ID: <4C870408.7030004@andresmoreira.com>
Date: Wed, 08 Sep 2010 00:33:28 -0300
From: =?ISO-8859-1?Q?Andr=E9s_Moreira?= <andres@andresmoreira.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Problem with Atheros AR2985 - disconnect frequently
Content-Type: multipart/mixed;
 boundary="------------070408030009040303020605"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070408030009040303020605
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi guys,

 Today I've asked in the channel about this issue and PaulF suggest me
write to the list.

The problem is that the card disconnect frequently, after test a lot I
could check that this ocurrs when I'm about 7 to 8 meters from the AP,
when I'm closer to the AP, it just disconnect when I'm watching a
youtube video or transfering a big file.

The card is:
 lspci -nn:
 02:00.0 Network controller [0280]: Atheros Communications Inc. AR9285
Wireless Network Adapter (PCI-Express) [168c:002b] (rev 01)

 uname -a
Linux apollo 2.6.32-24-generic #42-Ubuntu SMP Fri Aug 20 14:21:58 UTC
2010 x86_64 GNU/Linux

I'm using the compat-wireless-2010-09-04, also I've tried the one
shipped with Ubuntu 10.04 and the linux-backport package from ubuntu,
and happened the same with each one.

I've attached a part of my /var/log/messages containing a sequence when
the card is disconnected.

Is there is some new or alternative thing I can do to get my card
working better?

Thanks in advance for the help.

Regards,

- ----
Andrés Moreira
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJMhwQIAAoJEJLd13UZkan6JRYP+wW5N8xhJBxgZHO+yhdjMEaf
5ou6jKjxp0uLXfmc3afdcswTi6y3JACgSPzAzFY8kpZRJRBjGZM5y4W/5I/IF38T
ECz1P4tRTD8Q3E2VLeNA5KOd5KhabV0rUG9bzFaSt7hiV5XysUoz3uia/c0+5WYX
2dJiNI19ShPxcFnoKMU9y6M29EQ3WwGlEH8PoudtV9tC77JEP1sz00CDOwZk2NmM
ixeYpAbQShgxsR5umDjT8/YSmxJHB2WTwe13mNXS9tUn0olUy7Qo9iEzaKh8gY7f
nJA9schv10j1k9tnh22vT/dv47mCaNMlj1J7z+w8AXyqSC6LLiXmjJXHpaM+VqqV
pnG9JkDVg31/hsNObDMgIRINZvs3hYni/k+iEzE+Nvs11KVB2y5vFMIQqFLlavGE
5ww6XfChsTQ1sC/aTslJgrTf8tKwbGWwPvM5glMZMnqCAKKDVePbpGZMVZv0g/ap
It9yGjobIrRPP+Ys5KuOTRgb0h1fmCzXkcB2Gmnppro0bwyWh5M2XB/svn0a/Fbw
Q7gpMCOO8NW6/JUlnWBizpiFKVQdiH6YCWQzJuJX4Jsqt2CS3r+phkXBweISAOVt
Ai7QAhyFTmC/dGrBB8PqNi85kYQ+YLFWiFD3o0uTayXtRYYz8qi05rVaqCShKwpN
JScBdkXBkVZtKPYLS55j
=wCIw
-----END PGP SIGNATURE-----

--------------070408030009040303020605
Content-Type: text/plain;
 name="messages.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="messages.log"

Sep  7 22:27:52 apollo kernel: imklog 4.2.0, log source = /proc/kmsg started.
Sep  7 22:27:52 apollo rsyslogd: [origin software="rsyslogd" swVersion="4.2.0" x-pid="970" x-info="http://www.rsyslog.com"] (re)start
Sep  7 22:27:52 apollo rsyslogd: rsyslogd's groupid changed to 103
Sep  7 22:27:52 apollo rsyslogd: rsyslogd's userid changed to 101
Sep  7 22:27:52 apollo kernel: [    0.000000] Initializing cgroup subsys cpuset
Sep  7 22:27:52 apollo kernel: [    0.000000] Initializing cgroup subsys cpu
Sep  7 22:27:52 apollo kernel: [    0.000000] Linux version 2.6.32-24-generic (buildd@crested) (gcc version 4.4.3 (Ubuntu 4.4.3-4ubuntu5) ) #42-Ubuntu SMP Fri Aug 20 14:21:58 UTC 2010 (Ubuntu 2.6.32-24.42-generic 2.6.32.15+drm33.5)
Sep  7 22:27:52 apollo kernel: [    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-2.6.32-24-generic root=UUID=968a30f9-a6f4-4ec1-aed0-c0e3305eecf0 ro quiet splash
Sep  7 22:27:52 apollo kernel: [    0.000000] KERNEL supported cpus:
Sep  7 22:27:52 apollo kernel: [    0.000000]   Intel GenuineIntel
Sep  7 22:27:52 apollo kernel: [    0.000000]   AMD AuthenticAMD
Sep  7 22:27:52 apollo kernel: [    0.000000]   Centaur CentaurHauls
Sep  7 22:27:52 apollo kernel: [    0.000000] BIOS-provided physical RAM map:
Sep  7 22:27:52 apollo kernel: [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009d000 (usable)
Sep  7 22:27:52 apollo kernel: [    0.000000]  BIOS-e820: 000000000009d000 - 00000000000a0000 (reserved)
Sep  7 22:27:52 apollo kernel: [    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
Sep  7 22:27:52 apollo kernel: [    0.000000]  BIOS-e820: 0000000000100000 - 00000000bb63f000 (usable)
Sep  7 22:27:52 apollo kernel: [    0.000000]  BIOS-e820: 00000000bb63f000 - 00000000bb6bf000 (reserved)
Sep  7 22:27:52 apollo kernel: [    0.000000]  BIOS-e820: 00000000bb6bf000 - 00000000bb7bf000 (ACPI NVS)
Sep  7 22:27:52 apollo kernel: [    0.000000]  BIOS-e820: 00000000bb7bf000 - 00000000bb7ff000 (ACPI data)
Sep  7 22:27:52 apollo kernel: [    0.000000]  BIOS-e820: 00000000bb7ff000 - 00000000bb800000 (usable)
Sep  7 22:27:52 apollo kernel: [    0.000000]  BIOS-e820: 00000000bb800000 - 00000000c0000000 (reserved)
Sep  7 22:27:52 apollo kernel: [    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
Sep  7 22:27:52 apollo kernel: [    0.000000]  BIOS-e820: 00000000feb00000 - 00000000feb04000 (reserved)
Sep  7 22:27:52 apollo kernel: [    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
Sep  7 22:27:52 apollo kernel: [    0.000000]  BIOS-e820: 00000000fed10000 - 00000000fed14000 (reserved)
Sep  7 22:27:52 apollo kernel: [    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1a000 (reserved)
Sep  7 22:27:52 apollo kernel: [    0.000000]  BIOS-e820: 00000000fed1b000 - 00000000fed20000 (reserved)
Sep  7 22:27:52 apollo kernel: [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
Sep  7 22:27:52 apollo kernel: [    0.000000]  BIOS-e820: 00000000ffe80000 - 0000000100000000 (reserved)
Sep  7 22:27:52 apollo kernel: [    0.000000]  BIOS-e820: 0000000100000000 - 0000000138000000 (usable)
Sep  7 22:27:52 apollo kernel: [    0.000000] DMI 2.6 present.
Sep  7 22:27:52 apollo kernel: [    0.000000] last_pfn = 0x138000 max_arch_pfn = 0x400000000
Sep  7 22:27:52 apollo kernel: [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
Sep  7 22:27:52 apollo kernel: [    0.000000] last_pfn = 0xbb800 max_arch_pfn = 0x400000000
Sep  7 22:27:52 apollo kernel: [    0.000000] Scanning 1 areas for low memory corruption
Sep  7 22:27:52 apollo kernel: [    0.000000] modified physical RAM map:
Sep  7 22:27:52 apollo kernel: [    0.000000]  modified: 0000000000000000 - 0000000000001000 (usable)
Sep  7 22:27:52 apollo kernel: [    0.000000]  modified: 0000000000001000 - 0000000000006000 (reserved)
Sep  7 22:27:52 apollo kernel: [    0.000000]  modified: 0000000000006000 - 000000000009d000 (usable)
Sep  7 22:27:52 apollo kernel: [    0.000000]  modified: 000000000009d000 - 00000000000a0000 (reserved)
Sep  7 22:27:52 apollo kernel: [    0.000000]  modified: 00000000000e0000 - 0000000000100000 (reserved)
Sep  7 22:27:52 apollo kernel: [    0.000000]  modified: 0000000000100000 - 00000000bb63f000 (usable)
Sep  7 22:27:52 apollo kernel: [    0.000000]  modified: 00000000bb63f000 - 00000000bb6bf000 (reserved)
Sep  7 22:27:52 apollo kernel: [    0.000000]  modified: 00000000bb6bf000 - 00000000bb7bf000 (ACPI NVS)
Sep  7 22:27:52 apollo kernel: [    0.000000]  modified: 00000000bb7bf000 - 00000000bb7ff000 (ACPI data)
Sep  7 22:27:52 apollo kernel: [    0.000000]  modified: 00000000bb7ff000 - 00000000bb800000 (usable)
Sep  7 22:27:52 apollo kernel: [    0.000000]  modified: 00000000bb800000 - 00000000c0000000 (reserved)
Sep  7 22:27:52 apollo kernel: [    0.000000]  modified: 00000000e0000000 - 00000000f0000000 (reserved)
Sep  7 22:27:52 apollo kernel: [    0.000000]  modified: 00000000feb00000 - 00000000feb04000 (reserved)
Sep  7 22:27:52 apollo kernel: [    0.000000]  modified: 00000000fec00000 - 00000000fec01000 (reserved)
Sep  7 22:27:52 apollo kernel: [    0.000000]  modified: 00000000fed10000 - 00000000fed14000 (reserved)
Sep  7 22:27:52 apollo kernel: [    0.000000]  modified: 00000000fed18000 - 00000000fed1a000 (reserved)
Sep  7 22:27:52 apollo kernel: [    0.000000]  modified: 00000000fed1b000 - 00000000fed20000 (reserved)
Sep  7 22:27:52 apollo kernel: [    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
Sep  7 22:27:52 apollo kernel: [    0.000000]  modified: 00000000ffe80000 - 0000000100000000 (reserved)
Sep  7 22:27:52 apollo kernel: [    0.000000]  modified: 0000000100000000 - 0000000138000000 (usable)
Sep  7 22:27:52 apollo kernel: [    0.000000] init_memory_mapping: 0000000000000000-00000000bb800000
Sep  7 22:27:52 apollo kernel: [    0.000000] NX (Execute Disable) protection: active
Sep  7 22:27:52 apollo kernel: [    0.000000] init_memory_mapping: 0000000100000000-0000000138000000
Sep  7 22:27:52 apollo kernel: [    0.000000] NX (Execute Disable) protection: active
Sep  7 22:27:52 apollo kernel: [    0.000000] RAMDISK: 37285000 - 37fefc1a
Sep  7 22:27:52 apollo kernel: [    0.000000] ACPI: RSDP 00000000000fe020 00024 (v02 HPQOEM)
Sep  7 22:27:52 apollo kernel: [    0.000000] ACPI: XSDT 00000000bb7fe120 00074 (v01 HPQOEM SLIC-MPC 00000001      01000013)
Sep  7 22:27:52 apollo kernel: [    0.000000] ACPI: FACP 00000000bb7fc000 000F4 (v04 HPQOEM SLIC-MPC 00000001 MSFT 01000013)
Sep  7 22:27:52 apollo kernel: [    0.000000] ACPI: DSDT 00000000bb7e7000 11C83 (v02 HPQOEM SLIC-MPC 00000001 MSFT 01000013)
Sep  7 22:27:52 apollo kernel: [    0.000000] ACPI: FACS 00000000bb76f000 00040
Sep  7 22:27:52 apollo kernel: [    0.000000] ACPI: ASF! 00000000bb7fd000 000A5 (v32 HPQOEM SLIC-MPC 00000001 MSFT 01000013)
Sep  7 22:27:52 apollo kernel: [    0.000000] ACPI: HPET 00000000bb7fb000 00038 (v01 HPQOEM SLIC-MPC 00000001 MSFT 01000013)
Sep  7 22:27:52 apollo kernel: [    0.000000] ACPI: APIC 00000000bb7fa000 0008C (v02 HPQOEM SLIC-MPC 00000001 MSFT 01000013)
Sep  7 22:27:52 apollo kernel: [    0.000000] ACPI: MCFG 00000000bb7f9000 0003C (v01 HPQOEM SLIC-MPC 00000001 MSFT 01000013)
Sep  7 22:27:52 apollo kernel: [    0.000000] ACPI: SLIC 00000000bb7e6000 00176 (v01 HPQOEM SLIC-MPC 00000001 SLIC 000F4240)
Sep  7 22:27:52 apollo kernel: [    0.000000] ACPI: BOOT 00000000bb7e3000 00028 (v01 HPQOEM SLIC-MPC 00000001 MSFT 01000013)
Sep  7 22:27:52 apollo kernel: [    0.000000] ACPI: ASPT 00000000bb7e0000 00034 (v04 HPQOEM SLIC-MPC 00000001 MSFT 01000013)
Sep  7 22:27:52 apollo kernel: [    0.000000] ACPI: WDAT 00000000bb7df000 00224 (v01 HPQOEM SLIC-MPC 00000001 MSFT 01000013)
Sep  7 22:27:52 apollo kernel: [    0.000000] ACPI: SSDT 00000000bb7de000 009F1 (v01  PmRef    CpuPm 00003000 INTL 20051117)
Sep  7 22:27:52 apollo kernel: [    0.000000] No NUMA configuration found
Sep  7 22:27:52 apollo kernel: [    0.000000] Faking a node at 0000000000000000-0000000138000000
Sep  7 22:27:52 apollo kernel: [    0.000000] Bootmem setup node 0 0000000000000000-0000000138000000
Sep  7 22:27:52 apollo kernel: [    0.000000]   NODE_DATA [000000000000b000 - 000000000000ffff]
Sep  7 22:27:52 apollo kernel: [    0.000000]   bootmap [0000000000010000 -  0000000000036fff] pages 27
Sep  7 22:27:52 apollo kernel: [    0.000000] (8 early reservations) ==> bootmem [0000000000 - 0138000000]
Sep  7 22:27:52 apollo kernel: [    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
Sep  7 22:27:52 apollo kernel: [    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
Sep  7 22:27:52 apollo kernel: [    0.000000]   #2 [0001000000 - 0001a2fe64]    TEXT DATA BSS ==> [0001000000 - 0001a2fe64]
Sep  7 22:27:52 apollo kernel: [    0.000000]   #3 [0037285000 - 0037fefc1a]          RAMDISK ==> [0037285000 - 0037fefc1a]
Sep  7 22:27:52 apollo kernel: [    0.000000]   #4 [000009d000 - 0000100000]    BIOS reserved ==> [000009d000 - 0000100000]
Sep  7 22:27:52 apollo kernel: [    0.000000]   #5 [0001a30000 - 0001a302be]              BRK ==> [0001a30000 - 0001a302be]
Sep  7 22:27:52 apollo kernel: [    0.000000]   #6 [0000008000 - 000000a000]          PGTABLE ==> [0000008000 - 000000a000]
Sep  7 22:27:52 apollo kernel: [    0.000000]   #7 [000000a000 - 000000b000]          PGTABLE ==> [000000a000 - 000000b000]
Sep  7 22:27:52 apollo kernel: [    0.000000] Zone PFN ranges:
Sep  7 22:27:52 apollo kernel: [    0.000000]   DMA      0x00000000 -> 0x00001000
Sep  7 22:27:52 apollo kernel: [    0.000000]   DMA32    0x00001000 -> 0x00100000
Sep  7 22:27:52 apollo kernel: [    0.000000]   Normal   0x00100000 -> 0x00138000
Sep  7 22:27:52 apollo kernel: [    0.000000] Movable zone start PFN for each node
Sep  7 22:27:52 apollo kernel: [    0.000000] early_node_map[5] active PFN ranges
Sep  7 22:27:52 apollo kernel: [    0.000000]     0: 0x00000000 -> 0x00000001
Sep  7 22:27:52 apollo kernel: [    0.000000]     0: 0x00000006 -> 0x0000009d
Sep  7 22:27:52 apollo kernel: [    0.000000]     0: 0x00000100 -> 0x000bb63f
Sep  7 22:27:52 apollo kernel: [    0.000000]     0: 0x000bb7ff -> 0x000bb800
Sep  7 22:27:52 apollo kernel: [    0.000000]     0: 0x00100000 -> 0x00138000
Sep  7 22:27:52 apollo kernel: [    0.000000] ACPI: PM-Timer IO Port: 0x408
Sep  7 22:27:52 apollo kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Sep  7 22:27:52 apollo kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Sep  7 22:27:52 apollo kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
Sep  7 22:27:52 apollo kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x05] enabled)
Sep  7 22:27:52 apollo kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x00] disabled)
Sep  7 22:27:52 apollo kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x00] disabled)
Sep  7 22:27:52 apollo kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x00] disabled)
Sep  7 22:27:52 apollo kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x00] disabled)
Sep  7 22:27:52 apollo kernel: [    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
Sep  7 22:27:52 apollo kernel: [    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
Sep  7 22:27:52 apollo kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
Sep  7 22:27:52 apollo kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Sep  7 22:27:52 apollo kernel: [    0.000000] Using ACPI (MADT) for SMP configuration information
Sep  7 22:27:52 apollo kernel: [    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
Sep  7 22:27:52 apollo kernel: [    0.000000] SMP: Allowing 8 CPUs, 4 hotplug CPUs
Sep  7 22:27:52 apollo kernel: [    0.000000] PM: Registered nosave memory: 0000000000001000 - 0000000000006000
Sep  7 22:27:52 apollo kernel: [    0.000000] PM: Registered nosave memory: 000000000009d000 - 00000000000a0000
Sep  7 22:27:52 apollo kernel: [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
Sep  7 22:27:52 apollo kernel: [    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
Sep  7 22:27:52 apollo kernel: [    0.000000] PM: Registered nosave memory: 00000000bb63f000 - 00000000bb6bf000
Sep  7 22:27:52 apollo kernel: [    0.000000] PM: Registered nosave memory: 00000000bb6bf000 - 00000000bb7bf000
Sep  7 22:27:52 apollo kernel: [    0.000000] PM: Registered nosave memory: 00000000bb7bf000 - 00000000bb7ff000
Sep  7 22:27:52 apollo kernel: [    0.000000] PM: Registered nosave memory: 00000000bb800000 - 00000000c0000000
Sep  7 22:27:52 apollo kernel: [    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000e0000000
Sep  7 22:27:52 apollo kernel: [    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
Sep  7 22:27:52 apollo kernel: [    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000feb00000
Sep  7 22:27:52 apollo kernel: [    0.000000] PM: Registered nosave memory: 00000000feb00000 - 00000000feb04000
Sep  7 22:27:52 apollo kernel: [    0.000000] PM: Registered nosave memory: 00000000feb04000 - 00000000fec00000
Sep  7 22:27:52 apollo kernel: [    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec01000
Sep  7 22:27:52 apollo kernel: [    0.000000] PM: Registered nosave memory: 00000000fec01000 - 00000000fed10000
Sep  7 22:27:52 apollo kernel: [    0.000000] PM: Registered nosave memory: 00000000fed10000 - 00000000fed14000
Sep  7 22:27:52 apollo kernel: [    0.000000] PM: Registered nosave memory: 00000000fed14000 - 00000000fed18000
Sep  7 22:27:52 apollo kernel: [    0.000000] PM: Registered nosave memory: 00000000fed18000 - 00000000fed1a000
Sep  7 22:27:52 apollo kernel: [    0.000000] PM: Registered nosave memory: 00000000fed1a000 - 00000000fed1b000
Sep  7 22:27:52 apollo kernel: [    0.000000] PM: Registered nosave memory: 00000000fed1b000 - 00000000fed20000
Sep  7 22:27:52 apollo kernel: [    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000fee00000
Sep  7 22:27:52 apollo kernel: [    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
Sep  7 22:27:52 apollo kernel: [    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ffe80000
Sep  7 22:27:52 apollo kernel: [    0.000000] PM: Registered nosave memory: 00000000ffe80000 - 0000000100000000
Sep  7 22:27:52 apollo kernel: [    0.000000] Allocating PCI resources starting at c0000000 (gap: c0000000:20000000)
Sep  7 22:27:52 apollo kernel: [    0.000000] Booting paravirtualized kernel on bare hardware
Sep  7 22:27:52 apollo kernel: [    0.000000] NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:8 nr_node_ids:1
Sep  7 22:27:52 apollo kernel: [    0.000000] PERCPU: Embedded 30 pages/cpu @ffff880028200000 s91544 r8192 d23144 u262144
Sep  7 22:27:52 apollo kernel: [    0.000000] pcpu-alloc: s91544 r8192 d23144 u262144 alloc=1*2097152
Sep  7 22:27:52 apollo kernel: [    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
Sep  7 22:27:52 apollo kernel: [    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 979247
Sep  7 22:27:52 apollo kernel: [    0.000000] Policy zone: Normal
Sep  7 22:27:52 apollo kernel: [    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.32-24-generic root=UUID=968a30f9-a6f4-4ec1-aed0-c0e3305eecf0 ro quiet splash
Sep  7 22:27:52 apollo kernel: [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
Sep  7 22:27:52 apollo kernel: [    0.000000] Initializing CPU#0
Sep  7 22:27:52 apollo kernel: [    0.000000] Checking aperture...
Sep  7 22:27:52 apollo kernel: [    0.000000] No AGP bridge found
Sep  7 22:27:52 apollo kernel: [    0.000000] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Sep  7 22:27:52 apollo kernel: [    0.000000] Placing 64MB software IO TLB between ffff880020000000 - ffff880024000000
Sep  7 22:27:52 apollo kernel: [    0.000000] software IO TLB at phys 0x20000000 - 0x24000000
Sep  7 22:27:52 apollo kernel: [    0.000000] Memory: 3838608k/5111808k available (5422k kernel code, 1124512k absent, 148688k reserved, 2979k data, 880k init)
Sep  7 22:27:52 apollo kernel: [    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
Sep  7 22:27:52 apollo kernel: [    0.000000] Hierarchical RCU implementation.
Sep  7 22:27:52 apollo kernel: [    0.000000] NR_IRQS:4352 nr_irqs:472
Sep  7 22:27:52 apollo kernel: [    0.000000] Extended CMOS year: 2000
Sep  7 22:27:52 apollo kernel: [    0.000000] Console: colour VGA+ 80x25
Sep  7 22:27:52 apollo kernel: [    0.000000] console [tty0] enabled
Sep  7 22:27:52 apollo kernel: [    0.000000] allocated 40632320 bytes of page_cgroup
Sep  7 22:27:52 apollo kernel: [    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
Sep  7 22:27:52 apollo kernel: [    0.000000] HPET: 8 timers in total, 5 timers will be used for per-cpu timer
Sep  7 22:27:52 apollo kernel: [    0.000000] Fast TSC calibration using PIT
Sep  7 22:27:52 apollo kernel: [    0.010000] Detected 2128.387 MHz processor.
Sep  7 22:27:52 apollo kernel: [    0.000006] Calibrating delay loop (skipped), value calculated using timer frequency.. 4256.77 BogoMIPS (lpj=21283870)
Sep  7 22:27:52 apollo kernel: [    0.000024] Security Framework initialized
Sep  7 22:27:52 apollo kernel: [    0.000041] AppArmor: AppArmor initialized
Sep  7 22:27:52 apollo kernel: [    0.000366] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Sep  7 22:27:52 apollo kernel: [    0.001393] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Sep  7 22:27:52 apollo kernel: [    0.001803] Mount-cache hash table entries: 256
Sep  7 22:27:52 apollo kernel: [    0.001915] Initializing cgroup subsys ns
Sep  7 22:27:52 apollo kernel: [    0.001919] Initializing cgroup subsys cpuacct
Sep  7 22:27:52 apollo kernel: [    0.001922] Initializing cgroup subsys memory
Sep  7 22:27:52 apollo kernel: [    0.001929] Initializing cgroup subsys devices
Sep  7 22:27:52 apollo kernel: [    0.001931] Initializing cgroup subsys freezer
Sep  7 22:27:52 apollo kernel: [    0.001933] Initializing cgroup subsys net_cls
Sep  7 22:27:52 apollo kernel: [    0.001951] CPU: Physical Processor ID: 0
Sep  7 22:27:52 apollo kernel: [    0.001952] CPU: Processor Core ID: 0
Sep  7 22:27:52 apollo kernel: [    0.001956] CPU: L1 I cache: 32K, L1 D cache: 32K
Sep  7 22:27:52 apollo kernel: [    0.001958] CPU: L2 cache: 256K
Sep  7 22:27:52 apollo kernel: [    0.001959] CPU: L3 cache: 3072K
Sep  7 22:27:52 apollo kernel: [    0.001963] CPU 0/0x0 -> Node 0
Sep  7 22:27:52 apollo kernel: [    0.001966] mce: CPU supports 9 MCE banks
Sep  7 22:27:52 apollo kernel: [    0.001977] CPU0: Thermal monitoring enabled (TM1)
Sep  7 22:27:52 apollo kernel: [    0.001981] CPU 0 MCA banks CMCI:2 CMCI:3 CMCI:5 CMCI:6
Sep  7 22:27:52 apollo kernel: [    0.001990] using mwait in idle threads.
Sep  7 22:27:52 apollo kernel: [    0.001992] Performance Events: Westmere events, Intel PMU driver.
Sep  7 22:27:52 apollo kernel: [    0.001997] ... version:                3
Sep  7 22:27:52 apollo kernel: [    0.001999] ... bit width:              48
Sep  7 22:27:52 apollo kernel: [    0.002000] ... generic registers:      4
Sep  7 22:27:52 apollo kernel: [    0.002002] ... value mask:             0000ffffffffffff
Sep  7 22:27:52 apollo kernel: [    0.002003] ... max period:             000000007fffffff
Sep  7 22:27:52 apollo kernel: [    0.002005] ... fixed-purpose events:   3
Sep  7 22:27:52 apollo kernel: [    0.002006] ... event mask:             000000070000000f
Sep  7 22:27:52 apollo kernel: [    0.004261] ACPI: Core revision 20090903
Sep  7 22:27:52 apollo kernel: [    0.060692] ftrace: converting mcount calls to 0f 1f 44 00 00
Sep  7 22:27:52 apollo kernel: [    0.060696] ftrace: allocating 22527 entries in 89 pages
Sep  7 22:27:52 apollo kernel: [    0.068619] Setting APIC routing to flat
Sep  7 22:27:52 apollo kernel: [    0.069023] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
Sep  7 22:27:52 apollo kernel: [    0.169008] CPU0: Intel(R) Core(TM) i3 CPU       M 330  @ 2.13GHz stepping 02
Sep  7 22:27:52 apollo kernel: [    0.283231] Booting processor 1 APIC 0x1 ip 0x6000
Sep  7 22:27:52 apollo kernel: [    0.293434] Initializing CPU#1
Sep  7 22:27:52 apollo kernel: [    0.443076] CPU: Physical Processor ID: 0
Sep  7 22:27:52 apollo kernel: [    0.443078] CPU: Processor Core ID: 0
Sep  7 22:27:52 apollo kernel: [    0.443081] CPU: L1 I cache: 32K, L1 D cache: 32K
Sep  7 22:27:52 apollo kernel: [    0.443083] CPU: L2 cache: 256K
Sep  7 22:27:52 apollo kernel: [    0.443085] CPU: L3 cache: 3072K
Sep  7 22:27:52 apollo kernel: [    0.443088] CPU 1/0x1 -> Node 0
Sep  7 22:27:52 apollo kernel: [    0.443102] CPU1: Thermal monitoring enabled (TM1)
Sep  7 22:27:52 apollo kernel: [    0.443106] CPU 1 MCA banks SHD:2 SHD:3 SHD:5 SHD:6
Sep  7 22:27:52 apollo kernel: [    0.443213] CPU1: Intel(R) Core(TM) i3 CPU       M 330  @ 2.13GHz stepping 02
Sep  7 22:27:52 apollo kernel: [    0.443223] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Sep  7 22:27:52 apollo kernel: [    0.463333] Booting processor 2 APIC 0x4 ip 0x6000
Sep  7 22:27:52 apollo kernel: [    0.473570] Initializing CPU#2
Sep  7 22:27:52 apollo kernel: [    0.623029] CPU: Physical Processor ID: 0
Sep  7 22:27:52 apollo kernel: [    0.623031] CPU: Processor Core ID: 2
Sep  7 22:27:52 apollo kernel: [    0.623033] CPU: L1 I cache: 32K, L1 D cache: 32K
Sep  7 22:27:52 apollo kernel: [    0.623035] CPU: L2 cache: 256K
Sep  7 22:27:52 apollo kernel: [    0.623036] CPU: L3 cache: 3072K
Sep  7 22:27:52 apollo kernel: [    0.623039] CPU 2/0x4 -> Node 0
Sep  7 22:27:52 apollo kernel: [    0.623052] CPU2: Thermal monitoring enabled (TM1)
Sep  7 22:27:52 apollo kernel: [    0.623055] CPU 2 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6
Sep  7 22:27:52 apollo kernel: [    0.623106] CPU2: Intel(R) Core(TM) i3 CPU       M 330  @ 2.13GHz stepping 02
Sep  7 22:27:52 apollo kernel: [    0.623114] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
Sep  7 22:27:52 apollo kernel: [    0.643219] Booting processor 3 APIC 0x5 ip 0x6000
Sep  7 22:27:52 apollo kernel: [    0.653455] Initializing CPU#3
Sep  7 22:27:52 apollo kernel: [    0.802984] CPU: Physical Processor ID: 0
Sep  7 22:27:52 apollo kernel: [    0.802985] CPU: Processor Core ID: 2
Sep  7 22:27:52 apollo kernel: [    0.802988] CPU: L1 I cache: 32K, L1 D cache: 32K
Sep  7 22:27:52 apollo kernel: [    0.802989] CPU: L2 cache: 256K
Sep  7 22:27:52 apollo kernel: [    0.802990] CPU: L3 cache: 3072K
Sep  7 22:27:52 apollo kernel: [    0.802993] CPU 3/0x5 -> Node 0
Sep  7 22:27:52 apollo kernel: [    0.803006] CPU3: Thermal monitoring enabled (TM1)
Sep  7 22:27:52 apollo kernel: [    0.803009] CPU 3 MCA banks SHD:2 SHD:3 SHD:5 SHD:6
Sep  7 22:27:52 apollo kernel: [    0.803093] CPU3: Intel(R) Core(TM) i3 CPU       M 330  @ 2.13GHz stepping 02
Sep  7 22:27:52 apollo kernel: [    0.803101] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
Sep  7 22:27:52 apollo kernel: [    0.823120] Brought up 4 CPUs
Sep  7 22:27:52 apollo kernel: [    0.823122] Total of 4 processors activated (17027.03 BogoMIPS).
Sep  7 22:27:52 apollo kernel: [    0.824984] devtmpfs: initialized
Sep  7 22:27:52 apollo kernel: [    0.825322] regulator: core version 0.5
Sep  7 22:27:52 apollo kernel: [    0.825349] Time:  1:27:41  Date: 09/08/10
Sep  7 22:27:52 apollo kernel: [    0.825392] NET: Registered protocol family 16
Sep  7 22:27:52 apollo kernel: [    0.825485] Trying to unpack rootfs image as initramfs...
Sep  7 22:27:52 apollo kernel: [    0.825508] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
Sep  7 22:27:52 apollo kernel: [    0.825511] ACPI: bus type pci registered
Sep  7 22:27:52 apollo kernel: [    0.825589] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
Sep  7 22:27:52 apollo kernel: [    0.825592] PCI: MCFG area at e0000000 reserved in E820
Sep  7 22:27:52 apollo kernel: [    0.833205] PCI: Using MMCONFIG at e0000000 - efffffff
Sep  7 22:27:52 apollo kernel: [    0.833207] PCI: Using configuration type 1 for base access
Sep  7 22:27:52 apollo kernel: [    0.833919] bio: create slab <bio-0> at 0
Sep  7 22:27:52 apollo kernel: [    0.840642] ACPI: BIOS _OSI(Linux) query ignored
Sep  7 22:27:52 apollo kernel: [    0.863789] ACPI: Interpreter enabled
Sep  7 22:27:52 apollo kernel: [    0.863798] ACPI: (supports S0 S3 S4 S5)
Sep  7 22:27:52 apollo kernel: [    0.863842] ACPI: Using IOAPIC for interrupt routing
Sep  7 22:27:52 apollo kernel: [    0.876595] ACPI: EC: GPE = 0x16, I/O: command/status = 0x66, data = 0x62
Sep  7 22:27:52 apollo kernel: [    0.877047] ACPI: No dock devices found.
Sep  7 22:27:52 apollo kernel: [    0.878077] ACPI: PCI Root Bridge [PCI0] (0000:00)
Sep  7 22:27:52 apollo kernel: [    0.878328] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
Sep  7 22:27:52 apollo kernel: [    0.878334] pci 0000:00:16.0: PME# disabled
Sep  7 22:27:52 apollo kernel: [    0.878473] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
Sep  7 22:27:52 apollo kernel: [    0.878478] pci 0000:00:1a.0: PME# disabled
Sep  7 22:27:52 apollo kernel: [    0.878590] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
Sep  7 22:27:52 apollo kernel: [    0.878595] pci 0000:00:1b.0: PME# disabled
Sep  7 22:27:52 apollo kernel: [    0.878685] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
Sep  7 22:27:52 apollo kernel: [    0.878691] pci 0000:00:1c.0: PME# disabled
Sep  7 22:27:52 apollo kernel: [    0.878782] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
Sep  7 22:27:52 apollo kernel: [    0.878787] pci 0000:00:1c.1: PME# disabled
Sep  7 22:27:52 apollo kernel: [    0.878925] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
Sep  7 22:27:52 apollo kernel: [    0.878930] pci 0000:00:1d.0: PME# disabled
Sep  7 22:27:52 apollo kernel: [    0.879241] pci 0000:00:1f.2: PME# supported from D3hot
Sep  7 22:27:52 apollo kernel: [    0.879246] pci 0000:00:1f.2: PME# disabled
Sep  7 22:27:52 apollo kernel: [    0.879488] pci 0000:02:00.0: PME# supported from D0 D1 D3hot
Sep  7 22:27:52 apollo kernel: [    0.879495] pci 0000:02:00.0: PME# disabled
Sep  7 22:27:52 apollo kernel: [    0.879974] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
Sep  7 22:27:52 apollo kernel: [    0.879989] pci 0000:03:00.0: PME# disabled
Sep  7 22:27:52 apollo kernel: [    0.880206] pci 0000:00:1e.0: transparent bridge
Sep  7 22:27:52 apollo kernel: [    0.880538] ACPI Warning for \_SB_.PCI0.P0P1._PRT: Return Package has no elements (empty) (20090903/nspredef-433)
Sep  7 22:27:52 apollo kernel: [    0.896413] ACPI: PCI Root Bridge [CPBG] (0000:ff)
Sep  7 22:27:52 apollo kernel: [    0.896897] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *0
Sep  7 22:27:52 apollo kernel: [    0.897063] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12 14 15)
Sep  7 22:27:52 apollo kernel: [    0.897225] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
Sep  7 22:27:52 apollo kernel: [    0.897388] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
Sep  7 22:27:52 apollo kernel: [    0.897548] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
Sep  7 22:27:52 apollo kernel: [    0.897710] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 *5 6 7 11 12 14 15)
Sep  7 22:27:52 apollo kernel: [    0.897869] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
Sep  7 22:27:52 apollo kernel: [    0.898031] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
Sep  7 22:27:52 apollo kernel: [    0.898172] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
Sep  7 22:27:52 apollo kernel: [    0.898182] vgaarb: loaded
Sep  7 22:27:52 apollo kernel: [    0.898283] SCSI subsystem initialized
Sep  7 22:27:52 apollo kernel: [    0.898466] usbcore: registered new interface driver usbfs
Sep  7 22:27:52 apollo kernel: [    0.898475] usbcore: registered new interface driver hub
Sep  7 22:27:52 apollo kernel: [    0.898499] usbcore: registered new device driver usb
Sep  7 22:27:52 apollo kernel: [    0.898645] ACPI: WMI: Mapper loaded
Sep  7 22:27:52 apollo kernel: [    0.898647] PCI: Using ACPI for IRQ routing
Sep  7 22:27:52 apollo kernel: [    0.898816] NetLabel: Initializing
Sep  7 22:27:52 apollo kernel: [    0.898818] NetLabel:  domain hash size = 128
Sep  7 22:27:52 apollo kernel: [    0.898819] NetLabel:  protocols = UNLABELED CIPSOv4
Sep  7 22:27:52 apollo kernel: [    0.898832] NetLabel:  unlabeled traffic allowed by default
Sep  7 22:27:52 apollo kernel: [    0.898872] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 24, 25, 26, 27, 28, 0
Sep  7 22:27:52 apollo kernel: [    0.898878] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
Sep  7 22:27:52 apollo kernel: [    0.923285] Switching to clocksource tsc
Sep  7 22:27:52 apollo kernel: [    0.925113] AppArmor: AppArmor Filesystem Enabled
Sep  7 22:27:52 apollo kernel: [    0.925128] pnp: PnP ACPI init
Sep  7 22:27:52 apollo kernel: [    0.925146] ACPI: bus type pnp registered
Sep  7 22:27:52 apollo kernel: [    0.928726] pnp: PnP ACPI: found 11 devices
Sep  7 22:27:52 apollo kernel: [    0.928728] ACPI: ACPI bus type pnp unregistered
Sep  7 22:27:52 apollo kernel: [    0.928740] system 00:05: ioport range 0x680-0x69f has been reserved
Sep  7 22:27:52 apollo kernel: [    0.928743] system 00:05: ioport range 0x800-0x80f has been reserved
Sep  7 22:27:52 apollo kernel: [    0.928745] system 00:05: ioport range 0xffff-0xffff has been reserved
Sep  7 22:27:52 apollo kernel: [    0.928748] system 00:05: ioport range 0xffff-0xffff has been reserved
Sep  7 22:27:52 apollo kernel: [    0.928750] system 00:05: ioport range 0x400-0x47f has been reserved
Sep  7 22:27:52 apollo kernel: [    0.928752] system 00:05: ioport range 0x500-0x57f has been reserved
Sep  7 22:27:52 apollo kernel: [    0.928755] system 00:05: ioport range 0x164e-0x164f has been reserved
Sep  7 22:27:52 apollo kernel: [    0.928757] system 00:05: ioport range 0x380-0x38e has been reserved
Sep  7 22:27:52 apollo kernel: [    0.928763] system 00:09: iomem range 0xfed1c000-0xfed1ffff has been reserved
Sep  7 22:27:52 apollo kernel: [    0.928766] system 00:09: iomem range 0xfed10000-0xfed13fff has been reserved
Sep  7 22:27:52 apollo kernel: [    0.928768] system 00:09: iomem range 0xfed18000-0xfed18fff has been reserved
Sep  7 22:27:52 apollo kernel: [    0.928771] system 00:09: iomem range 0xfed19000-0xfed19fff has been reserved
Sep  7 22:27:52 apollo kernel: [    0.928773] system 00:09: iomem range 0xe0000000-0xefffffff has been reserved
Sep  7 22:27:52 apollo kernel: [    0.928776] system 00:09: iomem range 0xfed20000-0xfed3ffff has been reserved
Sep  7 22:27:52 apollo kernel: [    0.928778] system 00:09: iomem range 0xfed45000-0xfed8ffff has been reserved
Sep  7 22:27:52 apollo kernel: [    0.928781] system 00:09: iomem range 0xff000000-0xffffffff could not be reserved
Sep  7 22:27:52 apollo kernel: [    0.928783] system 00:09: iomem range 0xfee00000-0xfeefffff could not be reserved
Sep  7 22:27:52 apollo kernel: [    0.928786] system 00:09: iomem range 0xd4500000-0xd4500fff has been reserved
Sep  7 22:27:52 apollo kernel: [    0.933504] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
Sep  7 22:27:52 apollo kernel: [    0.933508] pci 0000:00:1c.0:   IO window: 0x3000-0x3fff
Sep  7 22:27:52 apollo kernel: [    0.933514] pci 0000:00:1c.0:   MEM window: 0xd3400000-0xd43fffff
Sep  7 22:27:52 apollo kernel: [    0.933519] pci 0000:00:1c.0:   PREFETCH window: 0x000000d0400000-0x000000d13fffff
Sep  7 22:27:52 apollo kernel: [    0.933530] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03
Sep  7 22:27:52 apollo kernel: [    0.933533] pci 0000:00:1c.1:   IO window: 0x2000-0x2fff
Sep  7 22:27:52 apollo kernel: [    0.933539] pci 0000:00:1c.1:   MEM window: 0xd2400000-0xd33fffff
Sep  7 22:27:52 apollo kernel: [    0.933544] pci 0000:00:1c.1:   PREFETCH window: 0x000000d1400000-0x000000d23fffff
Sep  7 22:27:52 apollo kernel: [    0.933551] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:04
Sep  7 22:27:52 apollo kernel: [    0.933553] pci 0000:00:1e.0:   IO window: disabled
Sep  7 22:27:52 apollo kernel: [    0.933559] pci 0000:00:1e.0:   MEM window: disabled
Sep  7 22:27:52 apollo kernel: [    0.933563] pci 0000:00:1e.0:   PREFETCH window: disabled
Sep  7 22:27:52 apollo kernel: [    0.933591] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
Sep  7 22:27:52 apollo kernel: [    0.933612] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
Sep  7 22:27:52 apollo kernel: [    0.933690] NET: Registered protocol family 2
Sep  7 22:27:52 apollo kernel: [    0.933849] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
Sep  7 22:27:52 apollo kernel: [    0.934794] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
Sep  7 22:27:52 apollo kernel: [    0.937711] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
Sep  7 22:27:52 apollo kernel: [    0.938063] TCP: Hash tables configured (established 524288 bind 65536)
Sep  7 22:27:52 apollo kernel: [    0.938066] TCP reno registered
Sep  7 22:27:52 apollo kernel: [    0.938172] NET: Registered protocol family 1
Sep  7 22:27:52 apollo kernel: [    0.973211] Simple Boot Flag at 0x44 set to 0x1
Sep  7 22:27:52 apollo kernel: [    0.973476] Scanning for low memory corruption every 60 seconds
Sep  7 22:27:52 apollo kernel: [    0.973601] audit: initializing netlink socket (disabled)
Sep  7 22:27:52 apollo kernel: [    0.973614] type=2000 audit(1283909260.819:1): initialized
Sep  7 22:27:52 apollo kernel: [    0.983694] HugeTLB registered 2 MB page size, pre-allocated 0 pages
Sep  7 22:27:52 apollo kernel: [    0.984985] VFS: Disk quotas dquot_6.5.2
Sep  7 22:27:52 apollo kernel: [    0.985035] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
Sep  7 22:27:52 apollo kernel: [    0.985598] fuse init (API version 7.13)
Sep  7 22:27:52 apollo kernel: [    0.985672] msgmni has been set to 7497
Sep  7 22:27:52 apollo kernel: [    0.985897] alg: No test for stdrng (krng)
Sep  7 22:27:52 apollo kernel: [    0.985949] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
Sep  7 22:27:52 apollo kernel: [    0.985952] io scheduler noop registered
Sep  7 22:27:52 apollo kernel: [    0.985953] io scheduler anticipatory registered
Sep  7 22:27:52 apollo kernel: [    0.985955] io scheduler deadline registered
Sep  7 22:27:52 apollo kernel: [    0.985989] io scheduler cfq registered (default)
Sep  7 22:27:52 apollo kernel: [    0.986406] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
Sep  7 22:27:52 apollo kernel: [    0.987061] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
Sep  7 22:27:52 apollo kernel: [    0.987461] ACPI: AC Adapter [ACAD] (off-line)
Sep  7 22:27:52 apollo kernel: [    0.987530] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
Sep  7 22:27:52 apollo kernel: [    0.987533] ACPI: Power Button [PWRB]
Sep  7 22:27:52 apollo kernel: [    0.987567] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input1
Sep  7 22:27:52 apollo kernel: [    0.988002] ACPI: Lid Switch [LID0]
Sep  7 22:27:52 apollo kernel: [    0.988053] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
Sep  7 22:27:52 apollo kernel: [    0.988055] ACPI: Power Button [PWRF]
Sep  7 22:27:52 apollo kernel: [    0.989542] ACPI: SSDT 00000000bb691c18 003A0 (v01  PmRef  Cpu0Ist 00003000 INTL 20051117)
Sep  7 22:27:52 apollo kernel: [    0.990226] ACPI: SSDT 00000000bb68f618 005CD (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
Sep  7 22:27:52 apollo kernel: [    0.990948] processor LNXCPU:00: registered as cooling_device0
Sep  7 22:27:52 apollo kernel: [    0.991606] ACPI: SSDT 00000000bb690a98 00303 (v01  PmRef    ApIst 00003000 INTL 20051117)
Sep  7 22:27:52 apollo kernel: [    0.992217] ACPI: SSDT 00000000bb68ed98 00119 (v01  PmRef    ApCst 00003000 INTL 20051117)
Sep  7 22:27:52 apollo kernel: [    0.993025] processor LNXCPU:01: registered as cooling_device1
Sep  7 22:27:52 apollo kernel: [    0.994193] processor LNXCPU:02: registered as cooling_device2
Sep  7 22:27:52 apollo kernel: [    1.003275] processor LNXCPU:03: registered as cooling_device3
Sep  7 22:27:52 apollo kernel: [    1.009372] ACPI Exception: AE_OK, No or invalid critical threshold (20090903/thermal-386)
Sep  7 22:27:52 apollo kernel: [    1.010807] Linux agpgart interface v0.103
Sep  7 22:27:52 apollo kernel: [    1.010836] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
Sep  7 22:27:52 apollo kernel: [    1.012112] brd: module loaded
Sep  7 22:27:52 apollo kernel: [    1.012535] loop: module loaded
Sep  7 22:27:52 apollo kernel: [    1.012600] input: Macintosh mouse button emulation as /devices/virtual/input/input3
Sep  7 22:27:52 apollo kernel: [    1.012916] Fixed MDIO Bus: probed
Sep  7 22:27:52 apollo kernel: [    1.012957] PPP generic driver version 2.4.2
Sep  7 22:27:52 apollo kernel: [    1.012984] tun: Universal TUN/TAP device driver, 1.6
Sep  7 22:27:52 apollo kernel: [    1.012986] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
Sep  7 22:27:52 apollo kernel: [    1.013045] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Sep  7 22:27:52 apollo kernel: [    1.013069] ehci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Sep  7 22:27:52 apollo kernel: [    1.013092] ehci_hcd 0000:00:1a.0: EHCI Host Controller
Sep  7 22:27:52 apollo kernel: [    1.013126] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
Sep  7 22:27:52 apollo kernel: [    1.013168] ehci_hcd 0000:00:1a.0: debug port 2
Sep  7 22:27:52 apollo kernel: [    1.017093] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xd4405c00
Sep  7 22:27:52 apollo kernel: [    1.032943] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
Sep  7 22:27:52 apollo kernel: [    1.033056] usb usb1: configuration #1 chosen from 1 choice
Sep  7 22:27:52 apollo kernel: [    1.033082] hub 1-0:1.0: USB hub found
Sep  7 22:27:52 apollo kernel: [    1.033090] hub 1-0:1.0: 3 ports detected
Sep  7 22:27:52 apollo kernel: [    1.033160] ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
Sep  7 22:27:52 apollo kernel: [    1.033191] ehci_hcd 0000:00:1d.0: EHCI Host Controller
Sep  7 22:27:52 apollo kernel: [    1.033225] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
Sep  7 22:27:52 apollo kernel: [    1.033257] ehci_hcd 0000:00:1d.0: debug port 2
Sep  7 22:27:52 apollo kernel: [    1.037162] ehci_hcd 0000:00:1d.0: irq 21, io mem 0xd4405800
Sep  7 22:27:52 apollo kernel: [    1.052933] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
Sep  7 22:27:52 apollo kernel: [    1.053037] usb usb2: configuration #1 chosen from 1 choice
Sep  7 22:27:52 apollo kernel: [    1.053062] hub 2-0:1.0: USB hub found
Sep  7 22:27:52 apollo kernel: [    1.053071] hub 2-0:1.0: 3 ports detected
Sep  7 22:27:52 apollo kernel: [    1.053131] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
Sep  7 22:27:52 apollo kernel: [    1.053145] uhci_hcd: USB Universal Host Controller Interface driver
Sep  7 22:27:52 apollo kernel: [    1.053220] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
Sep  7 22:27:52 apollo kernel: [    1.067740] serio: i8042 KBD port at 0x60,0x64 irq 1
Sep  7 22:27:52 apollo kernel: [    1.067753] serio: i8042 AUX port at 0x60,0x64 irq 12
Sep  7 22:27:52 apollo kernel: [    1.067862] mice: PS/2 mouse device common for all mice
Sep  7 22:27:52 apollo kernel: [    1.067982] rtc_cmos 00:06: RTC can wake from S4
Sep  7 22:27:52 apollo kernel: [    1.068026] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
Sep  7 22:27:52 apollo kernel: [    1.068062] rtc0: alarms up to one year, y3k, 242 bytes nvram, hpet irqs
Sep  7 22:27:52 apollo kernel: [    1.068223] device-mapper: uevent: version 1.0.3
Sep  7 22:27:52 apollo kernel: [    1.068348] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
Sep  7 22:27:52 apollo kernel: [    1.068450] device-mapper: multipath: version 1.1.0 loaded
Sep  7 22:27:52 apollo kernel: [    1.068454] device-mapper: multipath round-robin: version 1.0.0 loaded
Sep  7 22:27:52 apollo kernel: [    1.068814] cpuidle: using governor ladder
Sep  7 22:27:52 apollo kernel: [    1.069394] cpuidle: using governor menu
Sep  7 22:27:52 apollo kernel: [    1.069722] TCP cubic registered
Sep  7 22:27:52 apollo kernel: [    1.069828] NET: Registered protocol family 10
Sep  7 22:27:52 apollo kernel: [    1.070242] lo: Disabled Privacy Extensions
Sep  7 22:27:52 apollo kernel: [    1.070491] NET: Registered protocol family 17
Sep  7 22:27:52 apollo kernel: [    1.072489] registered taskstats version 1
Sep  7 22:27:52 apollo kernel: [    1.073024]   Magic number: 10:646:457
Sep  7 22:27:52 apollo kernel: [    1.073127] rtc_cmos 00:06: setting system clock to 2010-09-08 01:27:41 UTC (1283909261)
Sep  7 22:27:52 apollo kernel: [    1.073131] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
Sep  7 22:27:52 apollo kernel: [    1.073134] EDD information not available.
Sep  7 22:27:52 apollo kernel: [    1.078270] ACPI: Battery Slot [BAT0] (battery present)
Sep  7 22:27:52 apollo kernel: [    1.092886] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
Sep  7 22:27:52 apollo kernel: [    1.129861] Freeing initrd memory: 13739k freed
Sep  7 22:27:52 apollo kernel: [    1.133075] Freeing unused kernel memory: 880k freed
Sep  7 22:27:52 apollo kernel: [    1.133280] Write protecting the kernel read-only data: 7696k
Sep  7 22:27:52 apollo kernel: [    1.149335] udev: starting version 151
Sep  7 22:27:52 apollo kernel: [    1.196161] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
Sep  7 22:27:52 apollo kernel: [    1.196324] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 4 ports 3 Gbps 0x3 impl SATA mode
Sep  7 22:27:52 apollo kernel: [    1.196330] ahci 0000:00:1f.2: flags: 64bit ncq sntf ilck pm led clo pio slum part ems apst 
Sep  7 22:27:52 apollo kernel: [    1.196638] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
Sep  7 22:27:52 apollo kernel: [    1.196679] r8169 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
Sep  7 22:27:52 apollo kernel: [    1.197761] eth0: RTL8102e at 0xffffc90000678000, c8:0a:a9:59:be:c8, XID 04e00000 IRQ 32
Sep  7 22:27:52 apollo kernel: [    1.215453] scsi0 : ahci
Sep  7 22:27:52 apollo kernel: [    1.215607] scsi1 : ahci
Sep  7 22:27:52 apollo kernel: [    1.215690] scsi2 : ahci
Sep  7 22:27:52 apollo kernel: [    1.215762] scsi3 : ahci
Sep  7 22:27:52 apollo kernel: [    1.215817] ata1: SATA max UDMA/133 abar m2048@0xd4405000 port 0xd4405100 irq 31
Sep  7 22:27:52 apollo kernel: [    1.215822] ata2: SATA max UDMA/133 abar m2048@0xd4405000 port 0xd4405180 irq 31
Sep  7 22:27:52 apollo kernel: [    1.215824] ata3: DUMMY
Sep  7 22:27:52 apollo kernel: [    1.215826] ata4: DUMMY
Sep  7 22:27:52 apollo kernel: [    1.215902] agpgart-intel 0000:00:00.0: Intel IGDNG/M Chipset
Sep  7 22:27:52 apollo kernel: [    1.216660] agpgart-intel 0000:00:00.0: detected 32764K stolen memory
Sep  7 22:27:52 apollo kernel: [    1.227490] [drm] Initialized drm 1.1.0 20060810
Sep  7 22:27:52 apollo kernel: [    1.294835] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xc0000000
Sep  7 22:27:52 apollo kernel: [    1.353468] usb 1-1: new high speed USB device using ehci_hcd and address 2
Sep  7 22:27:52 apollo kernel: [    1.523917] usb 1-1: configuration #1 chosen from 1 choice
Sep  7 22:27:52 apollo kernel: [    1.524113] hub 1-1:1.0: USB hub found
Sep  7 22:27:52 apollo kernel: [    1.524179] hub 1-1:1.0: 6 ports detected
Sep  7 22:27:52 apollo kernel: [    1.565322] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Sep  7 22:27:52 apollo kernel: [    1.565412] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Sep  7 22:27:52 apollo kernel: [    1.566265] ata1.00: ATA-8: Hitachi HTS725032A9A364, PC3OC72E, max UDMA/100
Sep  7 22:27:52 apollo kernel: [    1.566270] ata1.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
Sep  7 22:27:52 apollo kernel: [    1.567428] ata1.00: configured for UDMA/100
Sep  7 22:27:52 apollo kernel: [    1.584576] ata2.00: ATAPI: hp       CDDVDW TS-L633N, 0300, max UDMA/100, ATAPI AN
Sep  7 22:27:52 apollo kernel: [    1.585389] scsi 0:0:0:0: Direct-Access     ATA      Hitachi HTS72503 PC3O PQ: 0 ANSI: 5
Sep  7 22:27:52 apollo kernel: [    1.585526] sd 0:0:0:0: Attached scsi generic sg0 type 0
Sep  7 22:27:52 apollo kernel: [    1.585608] sd 0:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB/298 GiB)
Sep  7 22:27:52 apollo kernel: [    1.585643] sd 0:0:0:0: [sda] Write Protect is off
Sep  7 22:27:52 apollo kernel: [    1.585663] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Sep  7 22:27:52 apollo kernel: [    1.585771]  sda:
Sep  7 22:27:52 apollo kernel: [    1.607247] ata2.00: configured for UDMA/100
Sep  7 22:27:52 apollo kernel: [    1.611244]  sda1 sda2 sda3 < sda5 sda6 >
Sep  7 22:27:52 apollo kernel: [    1.628311] scsi 1:0:0:0: CD-ROM            hp       CDDVDW TS-L633N  0300 PQ: 0 ANSI: 5
Sep  7 22:27:52 apollo kernel: [    1.636917] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
Sep  7 22:27:52 apollo kernel: [    1.636924] Uniform CD-ROM driver Revision: 3.20
Sep  7 22:27:52 apollo kernel: [    1.637119] sr 1:0:0:0: Attached scsi generic sg1 type 5
Sep  7 22:27:52 apollo kernel: [    1.644692] usb 2-1: new high speed USB device using ehci_hcd and address 2
Sep  7 22:27:52 apollo kernel: [    1.644827] sd 0:0:0:0: [sda] Attached SCSI disk
Sep  7 22:27:52 apollo kernel: [    1.663638] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Sep  7 22:27:52 apollo kernel: [    1.677410] [drm] set up 31M of stolen space
Sep  7 22:27:52 apollo kernel: [    1.803681] usb 2-1: configuration #1 chosen from 1 choice
Sep  7 22:27:52 apollo kernel: [    1.803893] hub 2-1:1.0: USB hub found
Sep  7 22:27:52 apollo kernel: [    1.803975] hub 2-1:1.0: 8 ports detected
Sep  7 22:27:52 apollo kernel: [    1.894122] usb 1-1.5: new high speed USB device using ehci_hcd and address 3
Sep  7 22:27:52 apollo kernel: [    2.025167] usb 1-1.5: configuration #1 chosen from 1 choice
Sep  7 22:27:52 apollo kernel: [    2.035041] Initializing USB Mass Storage driver...
Sep  7 22:27:52 apollo kernel: [    2.035134] scsi4 : SCSI emulation for USB Mass Storage devices
Sep  7 22:27:52 apollo kernel: [    2.035226] usbcore: registered new interface driver usb-storage
Sep  7 22:27:52 apollo kernel: [    2.035230] USB Mass Storage support registered.
Sep  7 22:27:52 apollo kernel: [    2.113444] usb 2-1.5: new high speed USB device using ehci_hcd and address 3
Sep  7 22:27:52 apollo kernel: [    2.238436] usb 2-1.5: configuration #1 chosen from 1 choice
Sep  7 22:27:52 apollo kernel: [    2.260844] fb0: inteldrmfb frame buffer device
Sep  7 22:27:52 apollo kernel: [    2.260847] registered panic notifier
Sep  7 22:27:52 apollo kernel: [    2.262924] ACPI Error: Needed [Buffer/String/Package], found [Integer] ffff8801329a13a8 (20090903/exresop-590)
Sep  7 22:27:52 apollo kernel: [    2.262930] ACPI Exception: AE_AML_OPERAND_TYPE, While resolving operands for [OpcodeName unavailable] (20090903/dswexec-445)
Sep  7 22:27:52 apollo kernel: [    2.262937] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.GFX0.DD02.GBQC] (Node ffff880133844ca0), AE_AML_OPERAND_TYPE
Sep  7 22:27:52 apollo kernel: [    2.262989] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.GFX0.DD02._BQC] (Node ffff880133844c80), AE_AML_OPERAND_TYPE
Sep  7 22:27:52 apollo kernel: [    2.263049] ACPI Warning: Evaluating _BQC failed (20090903/video-641)
Sep  7 22:27:52 apollo kernel: [    2.265569] acpi device:01: registered as cooling_device4
Sep  7 22:27:52 apollo kernel: [    2.266213] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input5
Sep  7 22:27:52 apollo kernel: [    2.266244] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
Sep  7 22:27:52 apollo kernel: [    2.266310] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
Sep  7 22:27:52 apollo kernel: [    2.267845] vga16fb: mapped to 0xffff8800000a0000
Sep  7 22:27:52 apollo kernel: [    2.267848] vga16fb: not registering due to another framebuffer present
Sep  7 22:27:52 apollo kernel: [    2.552278] Console: switching to colour frame buffer device 170x48
Sep  7 22:27:52 apollo kernel: [    3.008389] EXT4-fs (sda1): mounted filesystem with ordered data mode
Sep  7 22:27:52 apollo kernel: [    7.035077] scsi 4:0:0:0: Direct-Access     Generic- Multi-Card       1.00 PQ: 0 ANSI: 0 CCS
Sep  7 22:27:52 apollo kernel: [    7.035578] sd 4:0:0:0: Attached scsi generic sg2 type 0
Sep  7 22:27:52 apollo kernel: [    7.039697] sd 4:0:0:0: [sdb] Attached SCSI removable disk
Sep  7 22:27:52 apollo kernel: [   11.231747] udev: starting version 151
Sep  7 22:27:52 apollo kernel: [   11.243101] lp: driver loaded but no devices found
Sep  7 22:27:52 apollo kernel: [   11.285350] Adding 3999736k swap on /dev/sda2.  Priority:-1 extents:1 across:3999736k 
Sep  7 22:27:52 apollo kernel: [   11.382993] cfg80211: Calling CRDA to update world regulatory domain
Sep  7 22:27:52 apollo kernel: [   11.394727] cfg80211: World regulatory domain updated:
Sep  7 22:27:52 apollo kernel: [   11.394731]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Sep  7 22:27:52 apollo kernel: [   11.394736]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  7 22:27:52 apollo kernel: [   11.394739]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  7 22:27:52 apollo kernel: [   11.394742]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  7 22:27:52 apollo kernel: [   11.394745]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  7 22:27:52 apollo kernel: [   11.394748]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  7 22:27:52 apollo kernel: [   11.404180] Linux video capture interface: v2.00
Sep  7 22:27:52 apollo kernel: [   11.417567] uvcvideo: Found UVC 1.00 device HP Webcam-101 (04f2:b1aa)
Sep  7 22:27:52 apollo kernel: [   11.419522] input: HP Webcam-101 as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.5/2-1.5:1.0/input/input6
Sep  7 22:27:52 apollo kernel: [   11.419596] usbcore: registered new interface driver uvcvideo
Sep  7 22:27:52 apollo kernel: [   11.419600] USB Video Class driver (v0.1.0)
Sep  7 22:27:52 apollo kernel: [   11.448078] ath9k 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Sep  7 22:27:52 apollo kernel: [   11.448634] type=1505 audit(1283909271.872:2):  operation="profile_load" pid=761 name="/sbin/dhclient3"
Sep  7 22:27:52 apollo kernel: [   11.449121] type=1505 audit(1283909271.872:3):  operation="profile_load" pid=761 name="/usr/lib/NetworkManager/nm-dhcp-client.action"
Sep  7 22:27:52 apollo kernel: [   11.449388] type=1505 audit(1283909271.872:4):  operation="profile_load" pid=761 name="/usr/lib/connman/scripts/dhclient-script"
Sep  7 22:27:52 apollo kernel: [   11.508702] Registered led device: ath9k-phy0::radio
Sep  7 22:27:52 apollo kernel: [   11.508716] Registered led device: ath9k-phy0::assoc
Sep  7 22:27:52 apollo kernel: [   11.508729] Registered led device: ath9k-phy0::tx
Sep  7 22:27:52 apollo kernel: [   11.508741] Registered led device: ath9k-phy0::rx
Sep  7 22:27:52 apollo kernel: [   11.508747] phy0: Atheros AR9285 Rev:2 mem=0xffffc900113e0000, irq=16
Sep  7 22:27:52 apollo kernel: [   11.526639] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
Sep  7 22:27:52 apollo kernel: [   11.632552] hda_codec: ALC259: BIOS auto-probing.
Sep  7 22:27:52 apollo kernel: [   11.633885] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input7
Sep  7 22:27:52 apollo kernel: [   12.256575] Synaptics Touchpad, model: 1, fw: 7.4, id: 0x1e0b1, caps: 0xd04771/0xe40000
Sep  7 22:27:52 apollo kernel: [   12.256581] Synaptics: Clickpad mode enabled
Sep  7 22:27:52 apollo kernel: [   12.331641] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input8
Sep  7 22:27:52 apollo kernel: [   12.339505] EXT4-fs (sda6): mounted filesystem with ordered data mode
Sep  7 22:27:52 apollo kernel: [   12.466249] EXT4-fs (sda5): mounted filesystem with ordered data mode
Sep  7 22:27:52 apollo kernel: [   12.519551] type=1505 audit(1283909272.941:5):  operation="profile_load" pid=994 name="/usr/share/gdm/guest-session/Xsession"
Sep  7 22:27:52 apollo kernel: [   12.520804] type=1505 audit(1283909272.941:6):  operation="profile_replace" pid=995 name="/sbin/dhclient3"
Sep  7 22:27:52 apollo kernel: [   12.521297] type=1505 audit(1283909272.941:7):  operation="profile_replace" pid=995 name="/usr/lib/NetworkManager/nm-dhcp-client.action"
Sep  7 22:27:52 apollo kernel: [   12.521568] type=1505 audit(1283909272.950:8):  operation="profile_replace" pid=995 name="/usr/lib/connman/scripts/dhclient-script"
Sep  7 22:27:52 apollo kernel: [   12.523744] type=1505 audit(1283909272.950:9):  operation="profile_load" pid=996 name="/usr/bin/evince"
Sep  7 22:27:52 apollo kernel: [   12.530420] type=1505 audit(1283909272.950:10):  operation="profile_load" pid=996 name="/usr/bin/evince-previewer"
Sep  7 22:27:52 apollo kernel: [   12.535087] type=1505 audit(1283909272.960:11):  operation="profile_load" pid=996 name="/usr/bin/evince-thumbnailer"
Sep  7 22:27:53 apollo kernel: [   12.691668] ADDRCONF(NETDEV_UP): wlan0: link is not ready
Sep  7 22:27:53 apollo kernel: [   12.723289] r8169: eth0: link down
Sep  7 22:27:53 apollo kernel: [   12.723667] ADDRCONF(NETDEV_UP): eth0: link is not ready
Sep  7 22:27:53 apollo kernel: [   12.763981] ppdev: user-space parallel port driver
Sep  7 22:28:01 apollo kernel: [   20.638371] Intel AES-NI instructions are not detected.
Sep  7 22:28:01 apollo kernel: [   20.692649] padlock: VIA PadLock not detected.
Sep  7 22:28:20 apollo kernel: [   40.214176] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
Sep  7 22:29:45 apollo kernel: [  124.738386] cfg80211: Calling CRDA to update world regulatory domain
Sep  7 22:29:45 apollo kernel: [  124.741569] cfg80211: World regulatory domain updated:
Sep  7 22:29:45 apollo kernel: [  124.741575]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Sep  7 22:29:45 apollo kernel: [  124.741581]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  7 22:29:45 apollo kernel: [  124.741587]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  7 22:29:45 apollo kernel: [  124.741592]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  7 22:29:45 apollo kernel: [  124.741597]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  7 22:29:45 apollo kernel: [  124.741602]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  7 22:29:54 apollo kernel: [  133.762828] cfg80211: Calling CRDA to update world regulatory domain
Sep  7 22:29:54 apollo kernel: [  133.765627] cfg80211: World regulatory domain updated:
Sep  7 22:29:54 apollo kernel: [  133.765632]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Sep  7 22:29:54 apollo kernel: [  133.765639]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  7 22:29:54 apollo kernel: [  133.765645]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  7 22:29:54 apollo kernel: [  133.765650]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  7 22:29:54 apollo kernel: [  133.765655]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  7 22:29:54 apollo kernel: [  133.765660]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  7 22:30:04 apollo kernel: [  143.950453] cfg80211: Calling CRDA to update world regulatory domain
Sep  7 22:30:04 apollo kernel: [  143.952969] cfg80211: World regulatory domain updated:
Sep  7 22:30:04 apollo kernel: [  143.952974]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Sep  7 22:30:04 apollo kernel: [  143.952981]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  7 22:30:04 apollo kernel: [  143.952987]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  7 22:30:04 apollo kernel: [  143.952992]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  7 22:30:04 apollo kernel: [  143.952997]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  7 22:30:04 apollo kernel: [  143.953002]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  7 22:30:17 apollo kernel: [  157.201393] cfg80211: Calling CRDA to update world regulatory domain
Sep  7 22:30:17 apollo kernel: [  157.204354] cfg80211: World regulatory domain updated:
Sep  7 22:30:17 apollo kernel: [  157.204360]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Sep  7 22:30:17 apollo kernel: [  157.204366]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  7 22:30:17 apollo kernel: [  157.204372]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  7 22:30:17 apollo kernel: [  157.204377]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  7 22:30:17 apollo kernel: [  157.204382]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  7 22:30:17 apollo kernel: [  157.204387]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  7 22:33:17 apollo kernel: [  336.667699] lo: Disabled Privacy Extensions
Sep  7 22:33:50 apollo sudo: pam_sm_authenticate: Called
Sep  7 22:33:50 apollo sudo: pam_sm_authenticate: username = [andres]
Sep  7 22:33:50 apollo sudo: pam_sm_authenticate: /home/andres is already mounted
Sep  7 22:46:55 apollo gnome-screensaver-dialog: pam_sm_authenticate: Called
Sep  7 22:46:55 apollo gnome-screensaver-dialog: pam_sm_authenticate: username = [andres]
Sep  7 22:46:55 apollo gnome-screensaver-dialog: pam_sm_authenticate: /home/andres is already mounted
Sep  7 23:02:46 apollo sudo: pam_sm_authenticate: Called
Sep  7 23:02:46 apollo sudo: pam_sm_authenticate: username = [andres]
Sep  7 23:02:46 apollo sudo: pam_sm_authenticate: /home/andres is already mounted
Sep  7 23:04:10 apollo kernel: [ 2188.935926] cfg80211: Calling CRDA to update world regulatory domain
Sep  7 23:04:10 apollo kernel: [ 2188.939258] cfg80211: World regulatory domain updated:
Sep  7 23:04:10 apollo kernel: [ 2188.939262]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Sep  7 23:04:10 apollo kernel: [ 2188.939265]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  7 23:04:10 apollo kernel: [ 2188.939268]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  7 23:04:10 apollo kernel: [ 2188.939270]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  7 23:04:10 apollo kernel: [ 2188.939273]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  7 23:04:10 apollo kernel: [ 2188.939276]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  7 23:18:18 apollo sudo: pam_sm_authenticate: Called
Sep  7 23:18:18 apollo sudo: pam_sm_authenticate: username = [andres]
Sep  7 23:18:18 apollo sudo: pam_sm_authenticate: /home/andres is already mounted
Sep  7 23:20:15 apollo kernel: [ 3153.467617] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
Sep  7 23:20:15 apollo kernel: [ 3153.469038] SGI XFS Quota Management subsystem
Sep  7 23:20:15 apollo kernel: [ 3153.475575] JFS: nTxBlock = 8192, nTxLock = 65536
Sep  7 23:20:15 apollo kernel: [ 3153.495823] NTFS driver 2.1.29 [Flags: R/O MODULE].
Sep  7 23:20:15 apollo kernel: [ 3153.515487] QNX4 filesystem 0.2.3 registered.
Sep  7 23:20:15 apollo kernel: [ 3153.554391] Btrfs loaded
Sep  7 23:20:15 apollo os-prober: debug: running /usr/lib/os-probes/50mounted-tests on /dev/sda2
Sep  7 23:20:15 apollo 50mounted-tests: debug: /dev/sda2 is a swap partition; skipping
Sep  7 23:20:15 apollo os-prober: debug: os detected by /usr/lib/os-probes/50mounted-tests
Sep  7 23:20:15 apollo os-prober: debug: running /usr/lib/os-probes/50mounted-tests on /dev/sda3
Sep  7 23:20:15 apollo 50mounted-tests: debug: /dev/sda3 type not recognised; skipping
Sep  7 23:20:15 apollo os-prober: debug: os detected by /usr/lib/os-probes/50mounted-tests
Sep  7 23:20:15 apollo os-prober: debug: running /usr/lib/os-probes/mounted/10freedos on mounted /dev/sda5
Sep  7 23:20:15 apollo 10freedos: debug: /dev/sda5 is not a FAT partition: exiting
Sep  7 23:20:15 apollo os-prober: debug: running /usr/lib/os-probes/mounted/10qnx on mounted /dev/sda5
Sep  7 23:20:15 apollo 10qnx: debug: /dev/sda5 is not a QNX4 partition: exiting
Sep  7 23:20:15 apollo os-prober: debug: running /usr/lib/os-probes/mounted/20macosx on mounted /dev/sda5
Sep  7 23:20:15 apollo macosx-prober: debug: /dev/sda5 is not an HFS+ partition: exiting
Sep  7 23:20:15 apollo os-prober: debug: running /usr/lib/os-probes/mounted/20microsoft on mounted /dev/sda5
Sep  7 23:20:15 apollo 20microsoft: debug: /dev/sda5 is not a MS partition: exiting
Sep  7 23:20:15 apollo os-prober: debug: running /usr/lib/os-probes/mounted/30utility on mounted /dev/sda5
Sep  7 23:20:15 apollo 30utility: debug: /dev/sda5 is not a FAT partition: exiting
Sep  7 23:20:15 apollo os-prober: debug: running /usr/lib/os-probes/mounted/40lsb on mounted /dev/sda5
Sep  7 23:20:15 apollo os-prober: debug: running /usr/lib/os-probes/mounted/70hurd on mounted /dev/sda5
Sep  7 23:20:15 apollo os-prober: debug: running /usr/lib/os-probes/mounted/80minix on mounted /dev/sda5
Sep  7 23:20:15 apollo os-prober: debug: running /usr/lib/os-probes/mounted/90linux-distro on mounted /dev/sda5
Sep  7 23:20:15 apollo os-prober: debug: running /usr/lib/os-probes/mounted/90solaris on mounted /dev/sda5
Sep  7 23:20:15 apollo os-prober: debug: running /usr/lib/os-probes/mounted/10freedos on mounted /dev/sda6
Sep  7 23:20:15 apollo 10freedos: debug: /dev/sda6 is not a FAT partition: exiting
Sep  7 23:20:15 apollo os-prober: debug: running /usr/lib/os-probes/mounted/10qnx on mounted /dev/sda6
Sep  7 23:20:15 apollo 10qnx: debug: /dev/sda6 is not a QNX4 partition: exiting
Sep  7 23:20:15 apollo os-prober: debug: running /usr/lib/os-probes/mounted/20macosx on mounted /dev/sda6
Sep  7 23:20:15 apollo macosx-prober: debug: /dev/sda6 is not an HFS+ partition: exiting
Sep  7 23:20:15 apollo os-prober: debug: running /usr/lib/os-probes/mounted/20microsoft on mounted /dev/sda6
Sep  7 23:20:15 apollo 20microsoft: debug: /dev/sda6 is not a MS partition: exiting
Sep  7 23:20:15 apollo os-prober: debug: running /usr/lib/os-probes/mounted/30utility on mounted /dev/sda6
Sep  7 23:20:15 apollo 30utility: debug: /dev/sda6 is not a FAT partition: exiting
Sep  7 23:20:15 apollo os-prober: debug: running /usr/lib/os-probes/mounted/40lsb on mounted /dev/sda6
Sep  7 23:20:15 apollo os-prober: debug: running /usr/lib/os-probes/mounted/70hurd on mounted /dev/sda6
Sep  7 23:20:15 apollo os-prober: debug: running /usr/lib/os-probes/mounted/80minix on mounted /dev/sda6
Sep  7 23:20:15 apollo os-prober: debug: running /usr/lib/os-probes/mounted/90linux-distro on mounted /dev/sda6
Sep  7 23:20:15 apollo os-prober: debug: running /usr/lib/os-probes/mounted/90solaris on mounted /dev/sda6
Sep  7 23:20:24 apollo kernel: [ 3162.566299] ath9k 0000:02:00.0: PCI INT A disabled
Sep  7 23:20:24 apollo kernel: [ 3162.566344] ath9k: Driver unloaded
Sep  7 23:20:36 apollo kernel: [ 3174.602638] __ratelimit: 12 callbacks suppressed
Sep  7 23:20:36 apollo kernel: [ 3174.602643] nautilus[1556] general protection ip:7f7f38b8713d sp:7fff7bb33d40 error:0 in libgobject-2.0.so.0.2400.1[7f7f38b5b000+45000]
Sep  7 23:20:36 apollo kernel: Kernel logging (proc) stopped.
Sep  7 23:20:36 apollo rsyslogd: [origin software="rsyslogd" swVersion="4.2.0" x-pid="970" x-info="http://www.rsyslog.com"] exiting on signal 15.
Sep  7 23:21:04 apollo kernel: imklog 4.2.0, log source = /proc/kmsg started.
Sep  7 23:21:04 apollo rsyslogd: [origin software="rsyslogd" swVersion="4.2.0" x-pid="988" x-info="http://www.rsyslog.com"] (re)start
Sep  7 23:21:04 apollo rsyslogd: rsyslogd's groupid changed to 103
Sep  7 23:21:04 apollo rsyslogd: rsyslogd's userid changed to 101
Sep  7 23:21:04 apollo kernel: [    0.000000] Initializing cgroup subsys cpuset
Sep  7 23:21:04 apollo kernel: [    0.000000] Initializing cgroup subsys cpu
Sep  7 23:21:04 apollo kernel: [    0.000000] Linux version 2.6.32-24-generic (buildd@crested) (gcc version 4.4.3 (Ubuntu 4.4.3-4ubuntu5) ) #42-Ubuntu SMP Fri Aug 20 14:21:58 UTC 2010 (Ubuntu 2.6.32-24.42-generic 2.6.32.15+drm33.5)
Sep  7 23:21:04 apollo kernel: [    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-2.6.32-24-generic root=UUID=968a30f9-a6f4-4ec1-aed0-c0e3305eecf0 ro quiet splash
Sep  7 23:21:04 apollo kernel: [    0.000000] KERNEL supported cpus:
Sep  7 23:21:04 apollo kernel: [    0.000000]   Intel GenuineIntel
Sep  7 23:21:04 apollo kernel: [    0.000000]   AMD AuthenticAMD
Sep  7 23:21:04 apollo kernel: [    0.000000]   Centaur CentaurHauls
Sep  7 23:21:04 apollo kernel: [    0.000000] BIOS-provided physical RAM map:
Sep  7 23:21:04 apollo kernel: [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009d000 (usable)
Sep  7 23:21:04 apollo kernel: [    0.000000]  BIOS-e820: 000000000009d000 - 00000000000a0000 (reserved)
Sep  7 23:21:04 apollo kernel: [    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
Sep  7 23:21:04 apollo kernel: [    0.000000]  BIOS-e820: 0000000000100000 - 00000000bb63f000 (usable)
Sep  7 23:21:04 apollo kernel: [    0.000000]  BIOS-e820: 00000000bb63f000 - 00000000bb6bf000 (reserved)
Sep  7 23:21:04 apollo kernel: [    0.000000]  BIOS-e820: 00000000bb6bf000 - 00000000bb7bf000 (ACPI NVS)
Sep  7 23:21:04 apollo kernel: [    0.000000]  BIOS-e820: 00000000bb7bf000 - 00000000bb7ff000 (ACPI data)
Sep  7 23:21:04 apollo kernel: [    0.000000]  BIOS-e820: 00000000bb7ff000 - 00000000bb800000 (usable)
Sep  7 23:21:04 apollo kernel: [    0.000000]  BIOS-e820: 00000000bb800000 - 00000000c0000000 (reserved)
Sep  7 23:21:04 apollo kernel: [    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
Sep  7 23:21:04 apollo kernel: [    0.000000]  BIOS-e820: 00000000feb00000 - 00000000feb04000 (reserved)
Sep  7 23:21:04 apollo kernel: [    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
Sep  7 23:21:04 apollo kernel: [    0.000000]  BIOS-e820: 00000000fed10000 - 00000000fed14000 (reserved)
Sep  7 23:21:04 apollo kernel: [    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1a000 (reserved)
Sep  7 23:21:04 apollo kernel: [    0.000000]  BIOS-e820: 00000000fed1b000 - 00000000fed20000 (reserved)
Sep  7 23:21:04 apollo kernel: [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
Sep  7 23:21:04 apollo kernel: [    0.000000]  BIOS-e820: 00000000ffe80000 - 0000000100000000 (reserved)
Sep  7 23:21:04 apollo kernel: [    0.000000]  BIOS-e820: 0000000100000000 - 0000000138000000 (usable)
Sep  7 23:21:04 apollo kernel: [    0.000000] DMI 2.6 present.
Sep  7 23:21:04 apollo kernel: [    0.000000] last_pfn = 0x138000 max_arch_pfn = 0x400000000
Sep  7 23:21:04 apollo kernel: [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
Sep  7 23:21:04 apollo kernel: [    0.000000] last_pfn = 0xbb800 max_arch_pfn = 0x400000000
Sep  7 23:21:04 apollo kernel: [    0.000000] Scanning 1 areas for low memory corruption
Sep  7 23:21:04 apollo kernel: [    0.000000] modified physical RAM map:
Sep  7 23:21:04 apollo kernel: [    0.000000]  modified: 0000000000000000 - 0000000000001000 (usable)
Sep  7 23:21:04 apollo kernel: [    0.000000]  modified: 0000000000001000 - 0000000000006000 (reserved)
Sep  7 23:21:04 apollo kernel: [    0.000000]  modified: 0000000000006000 - 000000000009d000 (usable)
Sep  7 23:21:04 apollo kernel: [    0.000000]  modified: 000000000009d000 - 00000000000a0000 (reserved)
Sep  7 23:21:04 apollo kernel: [    0.000000]  modified: 00000000000e0000 - 0000000000100000 (reserved)
Sep  7 23:21:04 apollo kernel: [    0.000000]  modified: 0000000000100000 - 00000000bb63f000 (usable)
Sep  7 23:21:04 apollo kernel: [    0.000000]  modified: 00000000bb63f000 - 00000000bb6bf000 (reserved)
Sep  7 23:21:04 apollo kernel: [    0.000000]  modified: 00000000bb6bf000 - 00000000bb7bf000 (ACPI NVS)
Sep  7 23:21:04 apollo kernel: [    0.000000]  modified: 00000000bb7bf000 - 00000000bb7ff000 (ACPI data)
Sep  7 23:21:04 apollo kernel: [    0.000000]  modified: 00000000bb7ff000 - 00000000bb800000 (usable)
Sep  7 23:21:04 apollo kernel: [    0.000000]  modified: 00000000bb800000 - 00000000c0000000 (reserved)
Sep  7 23:21:04 apollo kernel: [    0.000000]  modified: 00000000e0000000 - 00000000f0000000 (reserved)
Sep  7 23:21:04 apollo kernel: [    0.000000]  modified: 00000000feb00000 - 00000000feb04000 (reserved)
Sep  7 23:21:04 apollo kernel: [    0.000000]  modified: 00000000fec00000 - 00000000fec01000 (reserved)
Sep  7 23:21:04 apollo kernel: [    0.000000]  modified: 00000000fed10000 - 00000000fed14000 (reserved)
Sep  7 23:21:04 apollo kernel: [    0.000000]  modified: 00000000fed18000 - 00000000fed1a000 (reserved)
Sep  7 23:21:04 apollo kernel: [    0.000000]  modified: 00000000fed1b000 - 00000000fed20000 (reserved)
Sep  7 23:21:04 apollo kernel: [    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
Sep  7 23:21:04 apollo kernel: [    0.000000]  modified: 00000000ffe80000 - 0000000100000000 (reserved)
Sep  7 23:21:04 apollo kernel: [    0.000000]  modified: 0000000100000000 - 0000000138000000 (usable)
Sep  7 23:21:04 apollo kernel: [    0.000000] init_memory_mapping: 0000000000000000-00000000bb800000
Sep  7 23:21:04 apollo kernel: [    0.000000] NX (Execute Disable) protection: active
Sep  7 23:21:04 apollo kernel: [    0.000000] init_memory_mapping: 0000000100000000-0000000138000000
Sep  7 23:21:04 apollo kernel: [    0.000000] NX (Execute Disable) protection: active
Sep  7 23:21:04 apollo kernel: [    0.000000] RAMDISK: 37286000 - 37fefad7
Sep  7 23:21:04 apollo kernel: [    0.000000] ACPI: RSDP 00000000000fe020 00024 (v02 HPQOEM)
Sep  7 23:21:04 apollo kernel: [    0.000000] ACPI: XSDT 00000000bb7fe120 00074 (v01 HPQOEM SLIC-MPC 00000001      01000013)
Sep  7 23:21:04 apollo kernel: [    0.000000] ACPI: FACP 00000000bb7fc000 000F4 (v04 HPQOEM SLIC-MPC 00000001 MSFT 01000013)
Sep  7 23:21:04 apollo kernel: [    0.000000] ACPI: DSDT 00000000bb7e7000 11C83 (v02 HPQOEM SLIC-MPC 00000001 MSFT 01000013)
Sep  7 23:21:04 apollo kernel: [    0.000000] ACPI: FACS 00000000bb76f000 00040
Sep  7 23:21:04 apollo kernel: [    0.000000] ACPI: ASF! 00000000bb7fd000 000A5 (v32 HPQOEM SLIC-MPC 00000001 MSFT 01000013)
Sep  7 23:21:04 apollo kernel: [    0.000000] ACPI: HPET 00000000bb7fb000 00038 (v01 HPQOEM SLIC-MPC 00000001 MSFT 01000013)
Sep  7 23:21:04 apollo kernel: [    0.000000] ACPI: APIC 00000000bb7fa000 0008C (v02 HPQOEM SLIC-MPC 00000001 MSFT 01000013)
Sep  7 23:21:04 apollo kernel: [    0.000000] ACPI: MCFG 00000000bb7f9000 0003C (v01 HPQOEM SLIC-MPC 00000001 MSFT 01000013)
Sep  7 23:21:04 apollo kernel: [    0.000000] ACPI: SLIC 00000000bb7e6000 00176 (v01 HPQOEM SLIC-MPC 00000001 SLIC 000F4240)
Sep  7 23:21:04 apollo kernel: [    0.000000] ACPI: BOOT 00000000bb7e3000 00028 (v01 HPQOEM SLIC-MPC 00000001 MSFT 01000013)
Sep  7 23:21:04 apollo kernel: [    0.000000] ACPI: ASPT 00000000bb7e0000 00034 (v04 HPQOEM SLIC-MPC 00000001 MSFT 01000013)
Sep  7 23:21:04 apollo kernel: [    0.000000] ACPI: WDAT 00000000bb7df000 00224 (v01 HPQOEM SLIC-MPC 00000001 MSFT 01000013)
Sep  7 23:21:04 apollo kernel: [    0.000000] ACPI: SSDT 00000000bb7de000 009F1 (v01  PmRef    CpuPm 00003000 INTL 20051117)
Sep  7 23:21:04 apollo kernel: [    0.000000] No NUMA configuration found
Sep  7 23:21:04 apollo kernel: [    0.000000] Faking a node at 0000000000000000-0000000138000000
Sep  7 23:21:04 apollo kernel: [    0.000000] Bootmem setup node 0 0000000000000000-0000000138000000
Sep  7 23:21:04 apollo kernel: [    0.000000]   NODE_DATA [000000000000b000 - 000000000000ffff]
Sep  7 23:21:04 apollo kernel: [    0.000000]   bootmap [0000000000010000 -  0000000000036fff] pages 27
Sep  7 23:21:04 apollo kernel: [    0.000000] (8 early reservations) ==> bootmem [0000000000 - 0138000000]
Sep  7 23:21:04 apollo kernel: [    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
Sep  7 23:21:04 apollo kernel: [    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
Sep  7 23:21:04 apollo kernel: [    0.000000]   #2 [0001000000 - 0001a2fe64]    TEXT DATA BSS ==> [0001000000 - 0001a2fe64]
Sep  7 23:21:04 apollo kernel: [    0.000000]   #3 [0037286000 - 0037fefad7]          RAMDISK ==> [0037286000 - 0037fefad7]
Sep  7 23:21:04 apollo kernel: [    0.000000]   #4 [000009d000 - 0000100000]    BIOS reserved ==> [000009d000 - 0000100000]
Sep  7 23:21:04 apollo kernel: [    0.000000]   #5 [0001a30000 - 0001a302be]              BRK ==> [0001a30000 - 0001a302be]
Sep  7 23:21:04 apollo kernel: [    0.000000]   #6 [0000008000 - 000000a000]          PGTABLE ==> [0000008000 - 000000a000]
Sep  7 23:21:04 apollo kernel: [    0.000000]   #7 [000000a000 - 000000b000]          PGTABLE ==> [000000a000 - 000000b000]
Sep  7 23:21:04 apollo kernel: [    0.000000] Zone PFN ranges:
Sep  7 23:21:04 apollo kernel: [    0.000000]   DMA      0x00000000 -> 0x00001000
Sep  7 23:21:04 apollo kernel: [    0.000000]   DMA32    0x00001000 -> 0x00100000
Sep  7 23:21:04 apollo kernel: [    0.000000]   Normal   0x00100000 -> 0x00138000
Sep  7 23:21:04 apollo kernel: [    0.000000] Movable zone start PFN for each node
Sep  7 23:21:04 apollo kernel: [    0.000000] early_node_map[5] active PFN ranges
Sep  7 23:21:04 apollo kernel: [    0.000000]     0: 0x00000000 -> 0x00000001
Sep  7 23:21:04 apollo kernel: [    0.000000]     0: 0x00000006 -> 0x0000009d
Sep  7 23:21:04 apollo kernel: [    0.000000]     0: 0x00000100 -> 0x000bb63f
Sep  7 23:21:04 apollo kernel: [    0.000000]     0: 0x000bb7ff -> 0x000bb800
Sep  7 23:21:04 apollo kernel: [    0.000000]     0: 0x00100000 -> 0x00138000
Sep  7 23:21:04 apollo kernel: [    0.000000] ACPI: PM-Timer IO Port: 0x408
Sep  7 23:21:04 apollo kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Sep  7 23:21:04 apollo kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Sep  7 23:21:04 apollo kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
Sep  7 23:21:04 apollo kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x05] enabled)
Sep  7 23:21:04 apollo kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x00] disabled)
Sep  7 23:21:04 apollo kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x00] disabled)
Sep  7 23:21:04 apollo kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x00] disabled)
Sep  7 23:21:04 apollo kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x00] disabled)
Sep  7 23:21:04 apollo kernel: [    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
Sep  7 23:21:04 apollo kernel: [    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
Sep  7 23:21:04 apollo kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
Sep  7 23:21:04 apollo kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Sep  7 23:21:04 apollo kernel: [    0.000000] Using ACPI (MADT) for SMP configuration information
Sep  7 23:21:04 apollo kernel: [    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
Sep  7 23:21:04 apollo kernel: [    0.000000] SMP: Allowing 8 CPUs, 4 hotplug CPUs
Sep  7 23:21:04 apollo kernel: [    0.000000] PM: Registered nosave memory: 0000000000001000 - 0000000000006000
Sep  7 23:21:04 apollo kernel: [    0.000000] PM: Registered nosave memory: 000000000009d000 - 00000000000a0000
Sep  7 23:21:04 apollo kernel: [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
Sep  7 23:21:04 apollo kernel: [    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
Sep  7 23:21:04 apollo kernel: [    0.000000] PM: Registered nosave memory: 00000000bb63f000 - 00000000bb6bf000
Sep  7 23:21:04 apollo kernel: [    0.000000] PM: Registered nosave memory: 00000000bb6bf000 - 00000000bb7bf000
Sep  7 23:21:04 apollo kernel: [    0.000000] PM: Registered nosave memory: 00000000bb7bf000 - 00000000bb7ff000
Sep  7 23:21:04 apollo kernel: [    0.000000] PM: Registered nosave memory: 00000000bb800000 - 00000000c0000000
Sep  7 23:21:04 apollo kernel: [    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000e0000000
Sep  7 23:21:04 apollo kernel: [    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
Sep  7 23:21:04 apollo kernel: [    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000feb00000
Sep  7 23:21:04 apollo kernel: [    0.000000] PM: Registered nosave memory: 00000000feb00000 - 00000000feb04000
Sep  7 23:21:04 apollo kernel: [    0.000000] PM: Registered nosave memory: 00000000feb04000 - 00000000fec00000
Sep  7 23:21:04 apollo kernel: [    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec01000
Sep  7 23:21:04 apollo kernel: [    0.000000] PM: Registered nosave memory: 00000000fec01000 - 00000000fed10000
Sep  7 23:21:04 apollo kernel: [    0.000000] PM: Registered nosave memory: 00000000fed10000 - 00000000fed14000
Sep  7 23:21:04 apollo kernel: [    0.000000] PM: Registered nosave memory: 00000000fed14000 - 00000000fed18000
Sep  7 23:21:04 apollo kernel: [    0.000000] PM: Registered nosave memory: 00000000fed18000 - 00000000fed1a000
Sep  7 23:21:04 apollo kernel: [    0.000000] PM: Registered nosave memory: 00000000fed1a000 - 00000000fed1b000
Sep  7 23:21:04 apollo kernel: [    0.000000] PM: Registered nosave memory: 00000000fed1b000 - 00000000fed20000
Sep  7 23:21:04 apollo kernel: [    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000fee00000
Sep  7 23:21:04 apollo kernel: [    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
Sep  7 23:21:04 apollo kernel: [    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ffe80000
Sep  7 23:21:04 apollo kernel: [    0.000000] PM: Registered nosave memory: 00000000ffe80000 - 0000000100000000
Sep  7 23:21:04 apollo kernel: [    0.000000] Allocating PCI resources starting at c0000000 (gap: c0000000:20000000)
Sep  7 23:21:04 apollo kernel: [    0.000000] Booting paravirtualized kernel on bare hardware
Sep  7 23:21:04 apollo kernel: [    0.000000] NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:8 nr_node_ids:1
Sep  7 23:21:04 apollo kernel: [    0.000000] PERCPU: Embedded 30 pages/cpu @ffff880028200000 s91544 r8192 d23144 u262144
Sep  7 23:21:04 apollo kernel: [    0.000000] pcpu-alloc: s91544 r8192 d23144 u262144 alloc=1*2097152
Sep  7 23:21:04 apollo kernel: [    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
Sep  7 23:21:04 apollo kernel: [    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 979247
Sep  7 23:21:04 apollo kernel: [    0.000000] Policy zone: Normal
Sep  7 23:21:04 apollo kernel: [    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.32-24-generic root=UUID=968a30f9-a6f4-4ec1-aed0-c0e3305eecf0 ro quiet splash
Sep  7 23:21:04 apollo kernel: [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
Sep  7 23:21:04 apollo kernel: [    0.000000] Initializing CPU#0
Sep  7 23:21:04 apollo kernel: [    0.000000] Checking aperture...
Sep  7 23:21:04 apollo kernel: [    0.000000] No AGP bridge found
Sep  7 23:21:04 apollo kernel: [    0.000000] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Sep  7 23:21:04 apollo kernel: [    0.000000] Placing 64MB software IO TLB between ffff880020000000 - ffff880024000000
Sep  7 23:21:04 apollo kernel: [    0.000000] software IO TLB at phys 0x20000000 - 0x24000000
Sep  7 23:21:04 apollo kernel: [    0.000000] Memory: 3838612k/5111808k available (5422k kernel code, 1124512k absent, 148684k reserved, 2979k data, 880k init)
Sep  7 23:21:04 apollo kernel: [    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
Sep  7 23:21:04 apollo kernel: [    0.000000] Hierarchical RCU implementation.
Sep  7 23:21:04 apollo kernel: [    0.000000] NR_IRQS:4352 nr_irqs:472
Sep  7 23:21:04 apollo kernel: [    0.000000] Extended CMOS year: 2000
Sep  7 23:21:04 apollo kernel: [    0.000000] Console: colour VGA+ 80x25
Sep  7 23:21:04 apollo kernel: [    0.000000] console [tty0] enabled
Sep  7 23:21:04 apollo kernel: [    0.000000] allocated 40632320 bytes of page_cgroup
Sep  7 23:21:04 apollo kernel: [    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
Sep  7 23:21:04 apollo kernel: [    0.000000] HPET: 8 timers in total, 5 timers will be used for per-cpu timer
Sep  7 23:21:04 apollo kernel: [    0.000000] Fast TSC calibration using PIT
Sep  7 23:21:04 apollo kernel: [    0.010000] Detected 2128.732 MHz processor.
Sep  7 23:21:04 apollo kernel: [    0.000006] Calibrating delay loop (skipped), value calculated using timer frequency.. 4257.46 BogoMIPS (lpj=21287320)
Sep  7 23:21:04 apollo kernel: [    0.000023] Security Framework initialized
Sep  7 23:21:04 apollo kernel: [    0.000041] AppArmor: AppArmor initialized
Sep  7 23:21:04 apollo kernel: [    0.000366] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Sep  7 23:21:04 apollo kernel: [    0.001388] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Sep  7 23:21:04 apollo kernel: [    0.001799] Mount-cache hash table entries: 256
Sep  7 23:21:04 apollo kernel: [    0.001913] Initializing cgroup subsys ns
Sep  7 23:21:04 apollo kernel: [    0.001916] Initializing cgroup subsys cpuacct
Sep  7 23:21:04 apollo kernel: [    0.001920] Initializing cgroup subsys memory
Sep  7 23:21:04 apollo kernel: [    0.001926] Initializing cgroup subsys devices
Sep  7 23:21:04 apollo kernel: [    0.001929] Initializing cgroup subsys freezer
Sep  7 23:21:04 apollo kernel: [    0.001931] Initializing cgroup subsys net_cls
Sep  7 23:21:04 apollo kernel: [    0.001948] CPU: Physical Processor ID: 0
Sep  7 23:21:04 apollo kernel: [    0.001950] CPU: Processor Core ID: 0
Sep  7 23:21:04 apollo kernel: [    0.001954] CPU: L1 I cache: 32K, L1 D cache: 32K
Sep  7 23:21:04 apollo kernel: [    0.001955] CPU: L2 cache: 256K
Sep  7 23:21:04 apollo kernel: [    0.001957] CPU: L3 cache: 3072K
Sep  7 23:21:04 apollo kernel: [    0.001960] CPU 0/0x0 -> Node 0
Sep  7 23:21:04 apollo kernel: [    0.001963] mce: CPU supports 9 MCE banks
Sep  7 23:21:04 apollo kernel: [    0.001975] CPU0: Thermal monitoring enabled (TM1)
Sep  7 23:21:04 apollo kernel: [    0.001979] CPU 0 MCA banks CMCI:2 CMCI:3 CMCI:5 CMCI:6
Sep  7 23:21:04 apollo kernel: [    0.001988] using mwait in idle threads.
Sep  7 23:21:04 apollo kernel: [    0.001990] Performance Events: Westmere events, Intel PMU driver.
Sep  7 23:21:04 apollo kernel: [    0.001995] ... version:                3
Sep  7 23:21:04 apollo kernel: [    0.001997] ... bit width:              48
Sep  7 23:21:04 apollo kernel: [    0.001998] ... generic registers:      4
Sep  7 23:21:04 apollo kernel: [    0.002000] ... value mask:             0000ffffffffffff
Sep  7 23:21:04 apollo kernel: [    0.002001] ... max period:             000000007fffffff
Sep  7 23:21:04 apollo kernel: [    0.002003] ... fixed-purpose events:   3
Sep  7 23:21:04 apollo kernel: [    0.002004] ... event mask:             000000070000000f
Sep  7 23:21:04 apollo kernel: [    0.004257] ACPI: Core revision 20090903
Sep  7 23:21:04 apollo kernel: [    0.060885] ftrace: converting mcount calls to 0f 1f 44 00 00
Sep  7 23:21:04 apollo kernel: [    0.060890] ftrace: allocating 22527 entries in 89 pages
Sep  7 23:21:04 apollo kernel: [    0.068809] Setting APIC routing to flat
Sep  7 23:21:04 apollo kernel: [    0.069218] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
Sep  7 23:21:04 apollo kernel: [    0.169220] CPU0: Intel(R) Core(TM) i3 CPU       M 330  @ 2.13GHz stepping 02
Sep  7 23:21:04 apollo kernel: [    0.283232] Booting processor 1 APIC 0x1 ip 0x6000
Sep  7 23:21:04 apollo kernel: [    0.293536] Initializing CPU#1
Sep  7 23:21:04 apollo kernel: [    0.443076] CPU: Physical Processor ID: 0
Sep  7 23:21:04 apollo kernel: [    0.443077] CPU: Processor Core ID: 0
Sep  7 23:21:04 apollo kernel: [    0.443081] CPU: L1 I cache: 32K, L1 D cache: 32K
Sep  7 23:21:04 apollo kernel: [    0.443083] CPU: L2 cache: 256K
Sep  7 23:21:04 apollo kernel: [    0.443084] CPU: L3 cache: 3072K
Sep  7 23:21:04 apollo kernel: [    0.443087] CPU 1/0x1 -> Node 0
Sep  7 23:21:04 apollo kernel: [    0.443102] CPU1: Thermal monitoring enabled (TM1)
Sep  7 23:21:04 apollo kernel: [    0.443105] CPU 1 MCA banks SHD:2 SHD:3 SHD:5 SHD:6
Sep  7 23:21:04 apollo kernel: [    0.443213] CPU1: Intel(R) Core(TM) i3 CPU       M 330  @ 2.13GHz stepping 02
Sep  7 23:21:04 apollo kernel: [    0.443222] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Sep  7 23:21:04 apollo kernel: [    0.463337] Booting processor 2 APIC 0x4 ip 0x6000
Sep  7 23:21:04 apollo kernel: [    0.473576] Initializing CPU#2
Sep  7 23:21:04 apollo kernel: [    0.623029] CPU: Physical Processor ID: 0
Sep  7 23:21:04 apollo kernel: [    0.623031] CPU: Processor Core ID: 2
Sep  7 23:21:04 apollo kernel: [    0.623033] CPU: L1 I cache: 32K, L1 D cache: 32K
Sep  7 23:21:04 apollo kernel: [    0.623035] CPU: L2 cache: 256K
Sep  7 23:21:04 apollo kernel: [    0.623036] CPU: L3 cache: 3072K
Sep  7 23:21:04 apollo kernel: [    0.623038] CPU 2/0x4 -> Node 0
Sep  7 23:21:04 apollo kernel: [    0.623052] CPU2: Thermal monitoring enabled (TM1)
Sep  7 23:21:04 apollo kernel: [    0.623056] CPU 2 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6
Sep  7 23:21:04 apollo kernel: [    0.623113] CPU2: Intel(R) Core(TM) i3 CPU       M 330  @ 2.13GHz stepping 02
Sep  7 23:21:04 apollo kernel: [    0.623121] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
Sep  7 23:21:04 apollo kernel: [    0.643229] Booting processor 3 APIC 0x5 ip 0x6000
Sep  7 23:21:04 apollo kernel: [    0.653466] Initializing CPU#3
Sep  7 23:21:04 apollo kernel: [    0.802984] CPU: Physical Processor ID: 0
Sep  7 23:21:04 apollo kernel: [    0.802985] CPU: Processor Core ID: 2
Sep  7 23:21:04 apollo kernel: [    0.802988] CPU: L1 I cache: 32K, L1 D cache: 32K
Sep  7 23:21:04 apollo kernel: [    0.802989] CPU: L2 cache: 256K
Sep  7 23:21:04 apollo kernel: [    0.802990] CPU: L3 cache: 3072K
Sep  7 23:21:04 apollo kernel: [    0.802993] CPU 3/0x5 -> Node 0
Sep  7 23:21:04 apollo kernel: [    0.803006] CPU3: Thermal monitoring enabled (TM1)
Sep  7 23:21:04 apollo kernel: [    0.803010] CPU 3 MCA banks SHD:2 SHD:3 SHD:5 SHD:6
Sep  7 23:21:04 apollo kernel: [    0.803105] CPU3: Intel(R) Core(TM) i3 CPU       M 330  @ 2.13GHz stepping 02
Sep  7 23:21:04 apollo kernel: [    0.803113] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
Sep  7 23:21:04 apollo kernel: [    0.823135] Brought up 4 CPUs
Sep  7 23:21:04 apollo kernel: [    0.823137] Total of 4 processors activated (17027.71 BogoMIPS).
Sep  7 23:21:04 apollo kernel: [    0.824992] devtmpfs: initialized
Sep  7 23:21:04 apollo kernel: [    0.825332] regulator: core version 0.5
Sep  7 23:21:04 apollo kernel: [    0.825360] Time:  2:20:53  Date: 09/08/10
Sep  7 23:21:04 apollo kernel: [    0.825402] NET: Registered protocol family 16
Sep  7 23:21:04 apollo kernel: [    0.825495] Trying to unpack rootfs image as initramfs...
Sep  7 23:21:04 apollo kernel: [    0.825518] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
Sep  7 23:21:04 apollo kernel: [    0.825521] ACPI: bus type pci registered
Sep  7 23:21:04 apollo kernel: [    0.825600] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
Sep  7 23:21:04 apollo kernel: [    0.825602] PCI: MCFG area at e0000000 reserved in E820
Sep  7 23:21:04 apollo kernel: [    0.833213] PCI: Using MMCONFIG at e0000000 - efffffff
Sep  7 23:21:04 apollo kernel: [    0.833215] PCI: Using configuration type 1 for base access
Sep  7 23:21:04 apollo kernel: [    0.833929] bio: create slab <bio-0> at 0
Sep  7 23:21:04 apollo kernel: [    0.840655] ACPI: BIOS _OSI(Linux) query ignored
Sep  7 23:21:04 apollo kernel: [    0.844912] ACPI: Interpreter enabled
Sep  7 23:21:04 apollo kernel: [    0.844920] ACPI: (supports S0 S3 S4 S5)
Sep  7 23:21:04 apollo kernel: [    0.844961] ACPI: Using IOAPIC for interrupt routing
Sep  7 23:21:04 apollo kernel: [    0.857718] ACPI: EC: GPE = 0x16, I/O: command/status = 0x66, data = 0x62
Sep  7 23:21:04 apollo kernel: [    0.858172] ACPI: No dock devices found.
Sep  7 23:21:04 apollo kernel: [    0.859193] ACPI: PCI Root Bridge [PCI0] (0000:00)
Sep  7 23:21:04 apollo kernel: [    0.859449] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
Sep  7 23:21:04 apollo kernel: [    0.859454] pci 0000:00:16.0: PME# disabled
Sep  7 23:21:04 apollo kernel: [    0.859592] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
Sep  7 23:21:04 apollo kernel: [    0.859597] pci 0000:00:1a.0: PME# disabled
Sep  7 23:21:04 apollo kernel: [    0.859711] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
Sep  7 23:21:04 apollo kernel: [    0.859716] pci 0000:00:1b.0: PME# disabled
Sep  7 23:21:04 apollo kernel: [    0.859805] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
Sep  7 23:21:04 apollo kernel: [    0.859810] pci 0000:00:1c.0: PME# disabled
Sep  7 23:21:04 apollo kernel: [    0.859902] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
Sep  7 23:21:04 apollo kernel: [    0.859907] pci 0000:00:1c.1: PME# disabled
Sep  7 23:21:04 apollo kernel: [    0.860046] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
Sep  7 23:21:04 apollo kernel: [    0.860051] pci 0000:00:1d.0: PME# disabled
Sep  7 23:21:04 apollo kernel: [    0.860361] pci 0000:00:1f.2: PME# supported from D3hot
Sep  7 23:21:04 apollo kernel: [    0.860365] pci 0000:00:1f.2: PME# disabled
Sep  7 23:21:04 apollo kernel: [    0.860606] pci 0000:02:00.0: PME# supported from D0 D1 D3hot
Sep  7 23:21:04 apollo kernel: [    0.860613] pci 0000:02:00.0: PME# disabled
Sep  7 23:21:04 apollo kernel: [    0.861104] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
Sep  7 23:21:04 apollo kernel: [    0.861119] pci 0000:03:00.0: PME# disabled
Sep  7 23:21:04 apollo kernel: [    0.861328] pci 0000:00:1e.0: transparent bridge
Sep  7 23:21:04 apollo kernel: [    0.861664] ACPI Warning for \_SB_.PCI0.P0P1._PRT: Return Package has no elements (empty) (20090903/nspredef-433)
Sep  7 23:21:04 apollo kernel: [    0.877540] ACPI: PCI Root Bridge [CPBG] (0000:ff)
Sep  7 23:21:04 apollo kernel: [    0.878023] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *0
Sep  7 23:21:04 apollo kernel: [    0.878188] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12 14 15)
Sep  7 23:21:04 apollo kernel: [    0.878351] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
Sep  7 23:21:04 apollo kernel: [    0.878513] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
Sep  7 23:21:04 apollo kernel: [    0.878675] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
Sep  7 23:21:04 apollo kernel: [    0.878837] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 *5 6 7 11 12 14 15)
Sep  7 23:21:04 apollo kernel: [    0.878998] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
Sep  7 23:21:04 apollo kernel: [    0.879160] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
Sep  7 23:21:04 apollo kernel: [    0.879293] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
Sep  7 23:21:04 apollo kernel: [    0.879303] vgaarb: loaded
Sep  7 23:21:04 apollo kernel: [    0.879404] SCSI subsystem initialized
Sep  7 23:21:04 apollo kernel: [    0.879580] usbcore: registered new interface driver usbfs
Sep  7 23:21:04 apollo kernel: [    0.879590] usbcore: registered new interface driver hub
Sep  7 23:21:04 apollo kernel: [    0.879611] usbcore: registered new device driver usb
Sep  7 23:21:04 apollo kernel: [    0.879746] ACPI: WMI: Mapper loaded
Sep  7 23:21:04 apollo kernel: [    0.879748] PCI: Using ACPI for IRQ routing
Sep  7 23:21:04 apollo kernel: [    0.879916] NetLabel: Initializing
Sep  7 23:21:04 apollo kernel: [    0.879918] NetLabel:  domain hash size = 128
Sep  7 23:21:04 apollo kernel: [    0.879919] NetLabel:  protocols = UNLABELED CIPSOv4
Sep  7 23:21:04 apollo kernel: [    0.879934] NetLabel:  unlabeled traffic allowed by default
Sep  7 23:21:04 apollo kernel: [    0.879974] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 24, 25, 26, 27, 28, 0
Sep  7 23:21:04 apollo kernel: [    0.879980] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
Sep  7 23:21:04 apollo kernel: [    0.903204] Switching to clocksource tsc
Sep  7 23:21:04 apollo kernel: [    0.905243] AppArmor: AppArmor Filesystem Enabled
Sep  7 23:21:04 apollo kernel: [    0.905258] pnp: PnP ACPI init
Sep  7 23:21:04 apollo kernel: [    0.905279] ACPI: bus type pnp registered
Sep  7 23:21:04 apollo kernel: [    0.908905] pnp: PnP ACPI: found 11 devices
Sep  7 23:21:04 apollo kernel: [    0.908907] ACPI: ACPI bus type pnp unregistered
Sep  7 23:21:04 apollo kernel: [    0.908919] system 00:05: ioport range 0x680-0x69f has been reserved
Sep  7 23:21:04 apollo kernel: [    0.908921] system 00:05: ioport range 0x800-0x80f has been reserved
Sep  7 23:21:04 apollo kernel: [    0.908924] system 00:05: ioport range 0xffff-0xffff has been reserved
Sep  7 23:21:04 apollo kernel: [    0.908926] system 00:05: ioport range 0xffff-0xffff has been reserved
Sep  7 23:21:04 apollo kernel: [    0.908929] system 00:05: ioport range 0x400-0x47f has been reserved
Sep  7 23:21:04 apollo kernel: [    0.908931] system 00:05: ioport range 0x500-0x57f has been reserved
Sep  7 23:21:04 apollo kernel: [    0.908933] system 00:05: ioport range 0x164e-0x164f has been reserved
Sep  7 23:21:04 apollo kernel: [    0.908936] system 00:05: ioport range 0x380-0x38e has been reserved
Sep  7 23:21:04 apollo kernel: [    0.908942] system 00:09: iomem range 0xfed1c000-0xfed1ffff has been reserved
Sep  7 23:21:04 apollo kernel: [    0.908944] system 00:09: iomem range 0xfed10000-0xfed13fff has been reserved
Sep  7 23:21:04 apollo kernel: [    0.908947] system 00:09: iomem range 0xfed18000-0xfed18fff has been reserved
Sep  7 23:21:04 apollo kernel: [    0.908949] system 00:09: iomem range 0xfed19000-0xfed19fff has been reserved
Sep  7 23:21:04 apollo kernel: [    0.908952] system 00:09: iomem range 0xe0000000-0xefffffff has been reserved
Sep  7 23:21:04 apollo kernel: [    0.908954] system 00:09: iomem range 0xfed20000-0xfed3ffff has been reserved
Sep  7 23:21:04 apollo kernel: [    0.908957] system 00:09: iomem range 0xfed45000-0xfed8ffff has been reserved
Sep  7 23:21:04 apollo kernel: [    0.908959] system 00:09: iomem range 0xff000000-0xffffffff could not be reserved
Sep  7 23:21:04 apollo kernel: [    0.908962] system 00:09: iomem range 0xfee00000-0xfeefffff could not be reserved
Sep  7 23:21:04 apollo kernel: [    0.908964] system 00:09: iomem range 0xd4500000-0xd4500fff has been reserved
Sep  7 23:21:04 apollo kernel: [    0.913681] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
Sep  7 23:21:04 apollo kernel: [    0.913685] pci 0000:00:1c.0:   IO window: 0x3000-0x3fff
Sep  7 23:21:04 apollo kernel: [    0.913691] pci 0000:00:1c.0:   MEM window: 0xd3400000-0xd43fffff
Sep  7 23:21:04 apollo kernel: [    0.913696] pci 0000:00:1c.0:   PREFETCH window: 0x000000d0400000-0x000000d13fffff
Sep  7 23:21:04 apollo kernel: [    0.913707] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03
Sep  7 23:21:04 apollo kernel: [    0.913710] pci 0000:00:1c.1:   IO window: 0x2000-0x2fff
Sep  7 23:21:04 apollo kernel: [    0.913717] pci 0000:00:1c.1:   MEM window: 0xd2400000-0xd33fffff
Sep  7 23:21:04 apollo kernel: [    0.913722] pci 0000:00:1c.1:   PREFETCH window: 0x000000d1400000-0x000000d23fffff
Sep  7 23:21:04 apollo kernel: [    0.913730] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:04
Sep  7 23:21:04 apollo kernel: [    0.913732] pci 0000:00:1e.0:   IO window: disabled
Sep  7 23:21:04 apollo kernel: [    0.913738] pci 0000:00:1e.0:   MEM window: disabled
Sep  7 23:21:04 apollo kernel: [    0.913742] pci 0000:00:1e.0:   PREFETCH window: disabled
Sep  7 23:21:04 apollo kernel: [    0.913770] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
Sep  7 23:21:04 apollo kernel: [    0.913791] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
Sep  7 23:21:04 apollo kernel: [    0.913868] NET: Registered protocol family 2
Sep  7 23:21:04 apollo kernel: [    0.914031] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
Sep  7 23:21:04 apollo kernel: [    0.914975] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
Sep  7 23:21:04 apollo kernel: [    0.917891] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
Sep  7 23:21:04 apollo kernel: [    0.918242] TCP: Hash tables configured (established 524288 bind 65536)
Sep  7 23:21:04 apollo kernel: [    0.918245] TCP reno registered
Sep  7 23:21:04 apollo kernel: [    0.918351] NET: Registered protocol family 1
Sep  7 23:21:04 apollo kernel: [    0.953219] Simple Boot Flag at 0x44 set to 0x1
Sep  7 23:21:04 apollo kernel: [    0.953480] Scanning for low memory corruption every 60 seconds
Sep  7 23:21:04 apollo kernel: [    0.953606] audit: initializing netlink socket (disabled)
Sep  7 23:21:04 apollo kernel: [    0.953618] type=2000 audit(1283912452.799:1): initialized
Sep  7 23:21:04 apollo kernel: [    0.963696] HugeTLB registered 2 MB page size, pre-allocated 0 pages
Sep  7 23:21:04 apollo kernel: [    0.964994] VFS: Disk quotas dquot_6.5.2
Sep  7 23:21:04 apollo kernel: [    0.965044] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
Sep  7 23:21:04 apollo kernel: [    0.965606] fuse init (API version 7.13)
Sep  7 23:21:04 apollo kernel: [    0.965682] msgmni has been set to 7497
Sep  7 23:21:04 apollo kernel: [    0.965906] alg: No test for stdrng (krng)
Sep  7 23:21:04 apollo kernel: [    0.965959] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
Sep  7 23:21:04 apollo kernel: [    0.965962] io scheduler noop registered
Sep  7 23:21:04 apollo kernel: [    0.965964] io scheduler anticipatory registered
Sep  7 23:21:04 apollo kernel: [    0.965966] io scheduler deadline registered
Sep  7 23:21:04 apollo kernel: [    0.965999] io scheduler cfq registered (default)
Sep  7 23:21:04 apollo kernel: [    0.966413] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
Sep  7 23:21:04 apollo kernel: [    0.967071] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
Sep  7 23:21:04 apollo kernel: [    0.967439] ACPI: AC Adapter [ACAD] (off-line)
Sep  7 23:21:04 apollo kernel: [    0.967509] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
Sep  7 23:21:04 apollo kernel: [    0.967512] ACPI: Power Button [PWRB]
Sep  7 23:21:04 apollo kernel: [    0.967547] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input1
Sep  7 23:21:04 apollo kernel: [    0.967944] ACPI: Lid Switch [LID0]
Sep  7 23:21:04 apollo kernel: [    0.967993] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
Sep  7 23:21:04 apollo kernel: [    0.967995] ACPI: Power Button [PWRF]
Sep  7 23:21:04 apollo kernel: [    0.969478] ACPI: SSDT 00000000bb691c18 003A0 (v01  PmRef  Cpu0Ist 00003000 INTL 20051117)
Sep  7 23:21:04 apollo kernel: [    0.970169] ACPI: SSDT 00000000bb68f618 005CD (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
Sep  7 23:21:04 apollo kernel: [    0.970911] processor LNXCPU:00: registered as cooling_device0
Sep  7 23:21:04 apollo kernel: [    0.971578] ACPI: SSDT 00000000bb690a98 00303 (v01  PmRef    ApIst 00003000 INTL 20051117)
Sep  7 23:21:04 apollo kernel: [    0.972191] ACPI: SSDT 00000000bb68ed98 00119 (v01  PmRef    ApCst 00003000 INTL 20051117)
Sep  7 23:21:04 apollo kernel: [    0.972996] processor LNXCPU:01: registered as cooling_device1
Sep  7 23:21:04 apollo kernel: [    0.974168] processor LNXCPU:02: registered as cooling_device2
Sep  7 23:21:04 apollo kernel: [    0.983240] processor LNXCPU:03: registered as cooling_device3
Sep  7 23:21:04 apollo kernel: [    0.989149] ACPI Exception: AE_OK, No or invalid critical threshold (20090903/thermal-386)
Sep  7 23:21:04 apollo kernel: [    0.990441] Linux agpgart interface v0.103
Sep  7 23:21:04 apollo kernel: [    0.990469] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
Sep  7 23:21:04 apollo kernel: [    0.991522] brd: module loaded
Sep  7 23:21:04 apollo kernel: [    0.991897] loop: module loaded
Sep  7 23:21:04 apollo kernel: [    0.991967] input: Macintosh mouse button emulation as /devices/virtual/input/input3
Sep  7 23:21:04 apollo kernel: [    0.992282] Fixed MDIO Bus: probed
Sep  7 23:21:04 apollo kernel: [    0.992309] PPP generic driver version 2.4.2
Sep  7 23:21:04 apollo kernel: [    0.992337] tun: Universal TUN/TAP device driver, 1.6
Sep  7 23:21:04 apollo kernel: [    0.992339] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
Sep  7 23:21:04 apollo kernel: [    0.992402] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Sep  7 23:21:04 apollo kernel: [    0.992427] ehci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Sep  7 23:21:04 apollo kernel: [    0.992449] ehci_hcd 0000:00:1a.0: EHCI Host Controller
Sep  7 23:21:04 apollo kernel: [    0.992476] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
Sep  7 23:21:04 apollo kernel: [    0.992509] ehci_hcd 0000:00:1a.0: debug port 2
Sep  7 23:21:04 apollo kernel: [    0.996418] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xd4405c00
Sep  7 23:21:04 apollo kernel: [    1.013118] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
Sep  7 23:21:04 apollo kernel: [    1.013286] usb usb1: configuration #1 chosen from 1 choice
Sep  7 23:21:04 apollo kernel: [    1.013315] hub 1-0:1.0: USB hub found
Sep  7 23:21:04 apollo kernel: [    1.013323] hub 1-0:1.0: 3 ports detected
Sep  7 23:21:04 apollo kernel: [    1.013400] ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
Sep  7 23:21:04 apollo kernel: [    1.013431] ehci_hcd 0000:00:1d.0: EHCI Host Controller
Sep  7 23:21:04 apollo kernel: [    1.013470] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
Sep  7 23:21:04 apollo kernel: [    1.013510] ehci_hcd 0000:00:1d.0: debug port 2
Sep  7 23:21:04 apollo kernel: [    1.017473] ehci_hcd 0000:00:1d.0: irq 21, io mem 0xd4405800
Sep  7 23:21:04 apollo kernel: [    1.033111] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
Sep  7 23:21:04 apollo kernel: [    1.033227] usb usb2: configuration #1 chosen from 1 choice
Sep  7 23:21:04 apollo kernel: [    1.033252] hub 2-0:1.0: USB hub found
Sep  7 23:21:04 apollo kernel: [    1.033260] hub 2-0:1.0: 3 ports detected
Sep  7 23:21:04 apollo kernel: [    1.033316] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
Sep  7 23:21:04 apollo kernel: [    1.033331] uhci_hcd: USB Universal Host Controller Interface driver
Sep  7 23:21:04 apollo kernel: [    1.033407] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
Sep  7 23:21:04 apollo kernel: [    1.048143] serio: i8042 KBD port at 0x60,0x64 irq 1
Sep  7 23:21:04 apollo kernel: [    1.048156] serio: i8042 AUX port at 0x60,0x64 irq 12
Sep  7 23:21:04 apollo kernel: [    1.048256] mice: PS/2 mouse device common for all mice
Sep  7 23:21:04 apollo kernel: [    1.048372] rtc_cmos 00:06: RTC can wake from S4
Sep  7 23:21:04 apollo kernel: [    1.048407] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
Sep  7 23:21:04 apollo kernel: [    1.048443] rtc0: alarms up to one year, y3k, 242 bytes nvram, hpet irqs
Sep  7 23:21:04 apollo kernel: [    1.048569] device-mapper: uevent: version 1.0.3
Sep  7 23:21:04 apollo kernel: [    1.048669] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
Sep  7 23:21:04 apollo kernel: [    1.048758] device-mapper: multipath: version 1.1.0 loaded
Sep  7 23:21:04 apollo kernel: [    1.048761] device-mapper: multipath round-robin: version 1.0.0 loaded
Sep  7 23:21:04 apollo kernel: [    1.049045] cpuidle: using governor ladder
Sep  7 23:21:04 apollo kernel: [    1.049358] cpuidle: using governor menu
Sep  7 23:21:04 apollo kernel: [    1.049687] TCP cubic registered
Sep  7 23:21:04 apollo kernel: [    1.049794] NET: Registered protocol family 10
Sep  7 23:21:04 apollo kernel: [    1.050212] lo: Disabled Privacy Extensions
Sep  7 23:21:04 apollo kernel: [    1.050466] NET: Registered protocol family 17
Sep  7 23:21:04 apollo kernel: [    1.052471] registered taskstats version 1
Sep  7 23:21:04 apollo kernel: [    1.053008]   Magic number: 10:99:308
Sep  7 23:21:04 apollo kernel: [    1.053036] tty tty37: hash matches
Sep  7 23:21:04 apollo kernel: [    1.053130] rtc_cmos 00:06: setting system clock to 2010-09-08 02:20:53 UTC (1283912453)
Sep  7 23:21:04 apollo kernel: [    1.053134] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
Sep  7 23:21:04 apollo kernel: [    1.053136] EDD information not available.
Sep  7 23:21:04 apollo kernel: [    1.067102] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
Sep  7 23:21:04 apollo kernel: [    1.078052] ACPI: Battery Slot [BAT0] (battery present)
Sep  7 23:21:04 apollo kernel: [    1.134268] Freeing initrd memory: 13734k freed
Sep  7 23:21:04 apollo kernel: [    1.137464] Freeing unused kernel memory: 880k freed
Sep  7 23:21:04 apollo kernel: [    1.137669] Write protecting the kernel read-only data: 7696k
Sep  7 23:21:04 apollo kernel: [    1.153726] udev: starting version 151
Sep  7 23:21:04 apollo kernel: [    1.176663] agpgart-intel 0000:00:00.0: Intel IGDNG/M Chipset
Sep  7 23:21:04 apollo kernel: [    1.177539] agpgart-intel 0000:00:00.0: detected 32764K stolen memory
Sep  7 23:21:04 apollo kernel: [    1.246326] [drm] Initialized drm 1.1.0 20060810
Sep  7 23:21:04 apollo kernel: [    1.249869] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
Sep  7 23:21:04 apollo kernel: [    1.249917] r8169 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
Sep  7 23:21:04 apollo kernel: [    1.251070] eth0: RTL8102e at 0xffffc900110fa000, c8:0a:a9:59:be:c8, XID 04e00000 IRQ 31
Sep  7 23:21:04 apollo kernel: [    1.253866] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xc0000000
Sep  7 23:21:04 apollo kernel: [    1.257210] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
Sep  7 23:21:04 apollo kernel: [    1.257334] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 4 ports 3 Gbps 0x3 impl SATA mode
Sep  7 23:21:04 apollo kernel: [    1.257338] ahci 0000:00:1f.2: flags: 64bit ncq sntf ilck pm led clo pio slum part ems apst 
Sep  7 23:21:04 apollo kernel: [    1.274545] scsi0 : ahci
Sep  7 23:21:04 apollo kernel: [    1.274677] scsi1 : ahci
Sep  7 23:21:04 apollo kernel: [    1.274751] scsi2 : ahci
Sep  7 23:21:04 apollo kernel: [    1.274812] scsi3 : ahci
Sep  7 23:21:04 apollo kernel: [    1.274848] ata1: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 32
Sep  7 23:21:04 apollo kernel: [    1.274852] ata2: SATA max UDMA/133 irq_stat 0x00400040, connection status changed
Sep  7 23:21:04 apollo kernel: [    1.274854] ata3: DUMMY
Sep  7 23:21:04 apollo kernel: [    1.274855] ata4: DUMMY
Sep  7 23:21:04 apollo kernel: [    1.274911] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Sep  7 23:21:04 apollo kernel: [    1.288655] [drm] set up 31M of stolen space
Sep  7 23:21:04 apollo kernel: [    1.334152] usb 1-1: new high speed USB device using ehci_hcd and address 2
Sep  7 23:21:04 apollo kernel: [    1.485283] usb 1-1: configuration #1 chosen from 1 choice
Sep  7 23:21:04 apollo kernel: [    1.485379] hub 1-1:1.0: USB hub found
Sep  7 23:21:04 apollo kernel: [    1.485466] hub 1-1:1.0: 6 ports detected
Sep  7 23:21:04 apollo kernel: [    1.604748] usb 2-1: new high speed USB device using ehci_hcd and address 2
Sep  7 23:21:04 apollo kernel: [    1.755882] usb 2-1: configuration #1 chosen from 1 choice
Sep  7 23:21:04 apollo kernel: [    1.756057] hub 2-1:1.0: USB hub found
Sep  7 23:21:04 apollo kernel: [    1.756145] hub 2-1:1.0: 8 ports detected
Sep  7 23:21:04 apollo kernel: [    1.833675] usb 1-1.5: new high speed USB device using ehci_hcd and address 3
Sep  7 23:21:04 apollo kernel: [    1.874460] fb0: inteldrmfb frame buffer device
Sep  7 23:21:04 apollo kernel: [    1.874462] registered panic notifier
Sep  7 23:21:04 apollo kernel: [    1.876713] ACPI Error: Needed [Buffer/String/Package], found [Integer] ffff88013093ce58 (20090903/exresop-590)
Sep  7 23:21:04 apollo kernel: [    1.876720] ACPI Exception: AE_AML_OPERAND_TYPE, While resolving operands for [OpcodeName unavailable] (20090903/dswexec-445)
Sep  7 23:21:04 apollo kernel: [    1.876727] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.GFX0.DD02.GBQC] (Node ffff880133844ca0), AE_AML_OPERAND_TYPE
Sep  7 23:21:04 apollo kernel: [    1.876779] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.GFX0.DD02._BQC] (Node ffff880133844c80), AE_AML_OPERAND_TYPE
Sep  7 23:21:04 apollo kernel: [    1.876839] ACPI Warning: Evaluating _BQC failed (20090903/video-641)
Sep  7 23:21:04 apollo kernel: [    1.879381] acpi device:01: registered as cooling_device4
Sep  7 23:21:04 apollo kernel: [    1.880307] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input5
Sep  7 23:21:04 apollo kernel: [    1.880369] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
Sep  7 23:21:04 apollo kernel: [    1.880467] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
Sep  7 23:21:04 apollo kernel: [    1.965417] usb 1-1.5: configuration #1 chosen from 1 choice
Sep  7 23:21:04 apollo kernel: [    1.975614] Initializing USB Mass Storage driver...
Sep  7 23:21:04 apollo kernel: [    1.975710] scsi4 : SCSI emulation for USB Mass Storage devices
Sep  7 23:21:04 apollo kernel: [    1.975792] usbcore: registered new interface driver usb-storage
Sep  7 23:21:04 apollo kernel: [    1.975795] USB Mass Storage support registered.
Sep  7 23:21:04 apollo kernel: [    2.025418] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Sep  7 23:21:04 apollo kernel: [    2.025454] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Sep  7 23:21:04 apollo kernel: [    2.026401] ata1.00: ATA-8: Hitachi HTS725032A9A364, PC3OC72E, max UDMA/100
Sep  7 23:21:04 apollo kernel: [    2.026406] ata1.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
Sep  7 23:21:04 apollo kernel: [    2.027559] ata1.00: configured for UDMA/100
Sep  7 23:21:04 apollo kernel: [    2.045557] scsi 0:0:0:0: Direct-Access     ATA      Hitachi HTS72503 PC3O PQ: 0 ANSI: 5
Sep  7 23:21:04 apollo kernel: [    2.045688] sd 0:0:0:0: Attached scsi generic sg0 type 0
Sep  7 23:21:04 apollo kernel: [    2.045780] sd 0:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB/298 GiB)
Sep  7 23:21:04 apollo kernel: [    2.045839] sd 0:0:0:0: [sda] Write Protect is off
Sep  7 23:21:04 apollo kernel: [    2.045861] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Sep  7 23:21:04 apollo kernel: [    2.045972]  sda:
Sep  7 23:21:04 apollo kernel: [    2.046470] ata2.00: ATAPI: hp       CDDVDW TS-L633N, 0300, max UDMA/100, ATAPI AN
Sep  7 23:21:04 apollo kernel: [    2.064343] usb 2-1.5: new high speed USB device using ehci_hcd and address 3
Sep  7 23:21:04 apollo kernel: [    2.065548]  sda1 sda2 sda3 <
Sep  7 23:21:04 apollo kernel: [    2.069625] ata2.00: configured for UDMA/100
Sep  7 23:21:04 apollo kernel: [    2.077088]  sda5 sda6 >
Sep  7 23:21:04 apollo kernel: [    2.087241] scsi 1:0:0:0: CD-ROM            hp       CDDVDW TS-L633N  0300 PQ: 0 ANSI: 5
Sep  7 23:21:04 apollo kernel: [    2.099122] sd 0:0:0:0: [sda] Attached SCSI disk
Sep  7 23:21:04 apollo kernel: [    2.101976] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
Sep  7 23:21:04 apollo kernel: [    2.101983] Uniform CD-ROM driver Revision: 3.20
Sep  7 23:21:04 apollo kernel: [    2.102173] sr 1:0:0:0: Attached scsi generic sg1 type 5
Sep  7 23:21:04 apollo kernel: [    2.104222] vga16fb: mapped to 0xffff8800000a0000
Sep  7 23:21:04 apollo kernel: [    2.104226] vga16fb: not registering due to another framebuffer present
Sep  7 23:21:04 apollo kernel: [    2.179338] Console: switching to colour frame buffer device 170x48
Sep  7 23:21:04 apollo kernel: [    2.199886] usb 2-1.5: configuration #1 chosen from 1 choice
Sep  7 23:21:04 apollo kernel: [    2.853750] EXT4-fs (sda1): mounted filesystem with ordered data mode
Sep  7 23:21:04 apollo kernel: [    6.975704] scsi 4:0:0:0: Direct-Access     Generic- Multi-Card       1.00 PQ: 0 ANSI: 0 CCS
Sep  7 23:21:04 apollo kernel: [    6.976047] sd 4:0:0:0: Attached scsi generic sg2 type 0
Sep  7 23:21:04 apollo kernel: [    6.980262] sd 4:0:0:0: [sdb] Attached SCSI removable disk
Sep  7 23:21:04 apollo kernel: [   10.750523] Adding 3999736k swap on /dev/sda2.  Priority:-1 extents:1 across:3999736k 
Sep  7 23:21:04 apollo kernel: [   10.805282] udev: starting version 151
Sep  7 23:21:04 apollo kernel: [   10.817674] lp: driver loaded but no devices found
Sep  7 23:21:04 apollo kernel: [   10.980737] type=1505 audit(1283912463.421:2):  operation="profile_load" pid=790 name="/sbin/dhclient3"
Sep  7 23:21:04 apollo kernel: [   10.981341] type=1505 audit(1283912463.421:3):  operation="profile_load" pid=790 name="/usr/lib/NetworkManager/nm-dhcp-client.action"
Sep  7 23:21:04 apollo kernel: [   10.981677] type=1505 audit(1283912463.421:4):  operation="profile_load" pid=790 name="/usr/lib/connman/scripts/dhclient-script"
Sep  7 23:21:04 apollo kernel: [   10.984635] cfg80211: Calling CRDA to update world regulatory domain
Sep  7 23:21:04 apollo kernel: [   10.989660] cfg80211: World regulatory domain updated:
Sep  7 23:21:04 apollo kernel: [   10.989663]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Sep  7 23:21:04 apollo kernel: [   10.989667]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  7 23:21:04 apollo kernel: [   10.989670]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  7 23:21:04 apollo kernel: [   10.989673]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  7 23:21:04 apollo kernel: [   10.989676]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  7 23:21:04 apollo kernel: [   10.989679]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  7 23:21:04 apollo kernel: [   10.994992] Linux video capture interface: v2.00
Sep  7 23:21:04 apollo kernel: [   11.003649] uvcvideo: Found UVC 1.00 device HP Webcam-101 (04f2:b1aa)
Sep  7 23:21:04 apollo kernel: [   11.005739] input: HP Webcam-101 as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.5/2-1.5:1.0/input/input6
Sep  7 23:21:04 apollo kernel: [   11.005807] usbcore: registered new interface driver uvcvideo
Sep  7 23:21:04 apollo kernel: [   11.005811] USB Video Class driver (v0.1.0)
Sep  7 23:21:04 apollo kernel: [   11.130823] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
Sep  7 23:21:04 apollo kernel: [   11.269132] hda_codec: ALC259: BIOS auto-probing.
Sep  7 23:21:04 apollo kernel: [   11.270499] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input7
Sep  7 23:21:04 apollo kernel: [   11.377079] ath9k 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Sep  7 23:21:04 apollo kernel: [   11.433031] Registered led device: ath9k-phy0::radio
Sep  7 23:21:04 apollo kernel: [   11.433053] Registered led device: ath9k-phy0::assoc
Sep  7 23:21:04 apollo kernel: [   11.433077] Registered led device: ath9k-phy0::tx
Sep  7 23:21:04 apollo kernel: [   11.433092] Registered led device: ath9k-phy0::rx
Sep  7 23:21:04 apollo kernel: [   11.433098] phy0: Atheros AR9285 Rev:2 mem=0xffffc90011360000, irq=16
Sep  7 23:21:04 apollo kernel: [   11.810842] Synaptics Touchpad, model: 1, fw: 7.4, id: 0x1e0b1, caps: 0xd04771/0xe40000
Sep  7 23:21:04 apollo kernel: [   11.810849] Synaptics: Clickpad mode enabled
Sep  7 23:21:04 apollo kernel: [   11.823726] EXT4-fs (sda6): mounted filesystem with ordered data mode
Sep  7 23:21:04 apollo kernel: [   11.887361] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input8
Sep  7 23:21:04 apollo kernel: [   12.037381] EXT4-fs (sda5): mounted filesystem with ordered data mode
Sep  7 23:21:04 apollo kernel: [   12.157280] type=1505 audit(1283912464.602:5):  operation="profile_load" pid=1011 name="/usr/share/gdm/guest-session/Xsession"
Sep  7 23:21:04 apollo kernel: [   12.158513] type=1505 audit(1283912464.602:6):  operation="profile_replace" pid=1012 name="/sbin/dhclient3"
Sep  7 23:21:04 apollo kernel: [   12.158995] type=1505 audit(1283912464.602:7):  operation="profile_replace" pid=1012 name="/usr/lib/NetworkManager/nm-dhcp-client.action"
Sep  7 23:21:04 apollo kernel: [   12.159259] type=1505 audit(1283912464.602:8):  operation="profile_replace" pid=1012 name="/usr/lib/connman/scripts/dhclient-script"
Sep  7 23:21:04 apollo kernel: [   12.161366] type=1505 audit(1283912464.602:9):  operation="profile_load" pid=1013 name="/usr/bin/evince"
Sep  7 23:21:04 apollo kernel: [   12.168049] type=1505 audit(1283912464.612:10):  operation="profile_load" pid=1013 name="/usr/bin/evince-previewer"
Sep  7 23:21:04 apollo kernel: [   12.172694] type=1505 audit(1283912464.612:11):  operation="profile_load" pid=1013 name="/usr/bin/evince-thumbnailer"
Sep  7 23:21:04 apollo kernel: [   12.218848] ADDRCONF(NETDEV_UP): wlan0: link is not ready
Sep  7 23:21:04 apollo kernel: [   12.221463] r8169: eth0: link down
Sep  7 23:21:04 apollo kernel: [   12.222046] ADDRCONF(NETDEV_UP): eth0: link is not ready
Sep  7 23:21:04 apollo kernel: [   12.443283] ppdev: user-space parallel port driver
Sep  7 23:21:15 apollo kernel: [   22.583444] Intel AES-NI instructions are not detected.
Sep  7 23:21:15 apollo kernel: [   22.623912] padlock: VIA PadLock not detected.
Sep  7 23:21:31 apollo kernel: [   39.371083] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
Sep  7 23:22:03 apollo kernel: [   71.206314] lo: Disabled Privacy Extensions
Sep  7 23:23:38 apollo kernel: [  166.150231] cfg80211: Calling CRDA to update world regulatory domain
Sep  7 23:23:38 apollo kernel: [  166.153557] cfg80211: World regulatory domain updated:
Sep  7 23:23:38 apollo kernel: [  166.153563]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Sep  7 23:23:38 apollo kernel: [  166.153569]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  7 23:23:38 apollo kernel: [  166.153575]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  7 23:23:38 apollo kernel: [  166.153580]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  7 23:23:38 apollo kernel: [  166.153585]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  7 23:23:38 apollo kernel: [  166.153590]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  7 23:24:09 apollo kernel: [  197.052577] cfg80211: Calling CRDA to update world regulatory domain
Sep  7 23:24:09 apollo kernel: [  197.056341] cfg80211: World regulatory domain updated:
Sep  7 23:24:09 apollo kernel: [  197.056349]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Sep  7 23:24:09 apollo kernel: [  197.056357]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  7 23:24:09 apollo kernel: [  197.056365]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  7 23:24:09 apollo kernel: [  197.056372]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  7 23:24:09 apollo kernel: [  197.056380]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  7 23:24:09 apollo kernel: [  197.056386]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  7 23:24:47 apollo kernel: [  234.861576] cfg80211: Calling CRDA to update world regulatory domain
Sep  7 23:24:47 apollo kernel: [  234.865187] cfg80211: World regulatory domain updated:
Sep  7 23:24:47 apollo kernel: [  234.865193]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Sep  7 23:24:47 apollo kernel: [  234.865200]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  7 23:24:47 apollo kernel: [  234.865205]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  7 23:24:47 apollo kernel: [  234.865210]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  7 23:24:47 apollo kernel: [  234.865215]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  7 23:24:47 apollo kernel: [  234.865220]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  7 23:29:38 apollo kernel: [  525.991647] cfg80211: Calling CRDA to update world regulatory domain
Sep  7 23:29:38 apollo kernel: [  525.994853] cfg80211: World regulatory domain updated:
Sep  7 23:29:38 apollo kernel: [  525.994859]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Sep  7 23:29:38 apollo kernel: [  525.994865]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  7 23:29:38 apollo kernel: [  525.994871]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  7 23:29:38 apollo kernel: [  525.994876]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  7 23:29:38 apollo kernel: [  525.994881]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  7 23:29:38 apollo kernel: [  525.994886]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  7 23:30:46 apollo kernel: [  593.973188] cfg80211: Calling CRDA to update world regulatory domain
Sep  7 23:30:46 apollo kernel: [  593.976515] cfg80211: World regulatory domain updated:
Sep  7 23:30:46 apollo kernel: [  593.976521]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Sep  7 23:30:46 apollo kernel: [  593.976528]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  7 23:30:46 apollo kernel: [  593.976533]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  7 23:30:46 apollo kernel: [  593.976538]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  7 23:30:46 apollo kernel: [  593.976543]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  7 23:30:46 apollo kernel: [  593.976548]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  7 23:31:58 apollo kernel: [  665.332174] cfg80211: Calling CRDA to update world regulatory domain
Sep  7 23:31:58 apollo kernel: [  665.340141] cfg80211: World regulatory domain updated:
Sep  7 23:31:58 apollo kernel: [  665.340148]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Sep  7 23:31:58 apollo kernel: [  665.340157]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  7 23:31:58 apollo kernel: [  665.340165]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  7 23:31:58 apollo kernel: [  665.340172]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  7 23:31:58 apollo kernel: [  665.340180]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  7 23:31:58 apollo kernel: [  665.340186]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  7 23:33:18 apollo sudo: pam_sm_authenticate: Called
Sep  7 23:33:18 apollo sudo: pam_sm_authenticate: username = [andres]
Sep  7 23:33:18 apollo sudo: pam_sm_authenticate: /home/andres is already mounted
Sep  7 23:48:49 apollo sudo: pam_sm_authenticate: Called
Sep  7 23:48:49 apollo sudo: pam_sm_authenticate: username = [andres]
Sep  7 23:48:49 apollo sudo: pam_sm_authenticate: /home/andres is already mounted
Sep  7 23:51:54 apollo sudo: pam_sm_authenticate: Called
Sep  7 23:51:54 apollo sudo: pam_sm_authenticate: username = [andres]
Sep  7 23:51:54 apollo sudo: pam_sm_authenticate: /home/andres is already mounted
Sep  7 23:56:52 apollo kernel: [ 2159.077767] cfg80211: Calling CRDA to update world regulatory domain
Sep  7 23:56:52 apollo kernel: [ 2159.107865] cfg80211: World regulatory domain updated:
Sep  7 23:56:52 apollo kernel: [ 2159.107869]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Sep  7 23:56:52 apollo kernel: [ 2159.107873]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  7 23:56:52 apollo kernel: [ 2159.107877]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  7 23:56:52 apollo kernel: [ 2159.107880]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep  7 23:56:52 apollo kernel: [ 2159.107883]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  7 23:56:52 apollo kernel: [ 2159.107887]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep  7 23:56:52 apollo kernel: [ 2159.108703] ath9k 0000:02:00.0: PCI INT A disabled
Sep  7 23:56:52 apollo kernel: [ 2159.108750] ath9k: Driver unloaded
Sep  7 23:57:42 apollo sudo: pam_sm_authenticate: Called
Sep  7 23:57:42 apollo sudo: pam_sm_authenticate: username = [andres]
Sep  7 23:57:42 apollo sudo: pam_sm_authenticate: /home/andres is already mounted

--------------070408030009040303020605--
