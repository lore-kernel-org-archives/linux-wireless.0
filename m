Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59120 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab1AGLzX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jan 2011 06:55:23 -0500
Received: by qwa26 with SMTP id 26so17707601qwa.19
        for <linux-wireless@vger.kernel.org>; Fri, 07 Jan 2011 03:55:21 -0800 (PST)
Received: by qwa26 with SMTP id 26so17707569qwa.19
        for <linux-wireless@vger.kernel.org>; Fri, 07 Jan 2011 03:55:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTikqJfYgsv=z62bwESeccnYydsbJ842sk3+XBgcB@mail.gmail.com>
References: <AANLkTimekYjYh7uZ3enOQ+zX2_dpA25Zy0aATCDzw521@mail.gmail.com>
 <AANLkTimYBb-hqWWtPpQVnVQ2ifemQbAvOBnKSUxM_jsJ@mail.gmail.com>
 <AANLkTik8nfAFF=OhG1EqzJYkYMh+ds1igRgngLArVswC@mail.gmail.com> <AANLkTikqJfYgsv=z62bwESeccnYydsbJ842sk3+XBgcB@mail.gmail.com>
From: Damian Minkov <damencho@sip-communicator.org>
Date: Fri, 7 Jan 2011 13:54:59 +0200
Message-ID: <AANLkTimmd_=yzdSWv8GFcHSis5E9wiCOM60wwuO4Fuqm@mail.gmail.com>
Subject: Re: Question about ep-n8508
To: sedat.dilek@gmail.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi again,

On Fri, Jan 7, 2011 at 1:04 PM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
> On Fri, Jan 7, 2011 at 11:32 AM, Damian Minkov
> <damencho@sip-communicator.org> wrote:
>> Hi,
>>
>> On Fri, Jan 7, 2011 at 11:11 AM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
>>> On Fri, Jan 7, 2011 at 9:06 AM, Damian Minkov
>>> <damencho@sip-communicator.org> wrote:
>>>> Hi,
>>>>
>>>> I recently bought the device EDUP ep-n8508 but I have problems running
>>>> it under Ubuntu 10.10, kernel: 2.6.35-24-generic x86_64.
>>>> I tried with the drivers provided on the CD coming with the device
>>>> (rtl8192CU_linux_v2.0.939.20100726) have no problem compiling and
>>>> installing. But after loading the module no network device appears and
>>>> a lot of "usb write TimeOut!" in the messages.
>>>> Then I tried with latest driver edition from realtek website -
>>>> rtl8192CU_linux_v2.0.1212.20101208. Again with same result.
>>>> Here is all the output: http://pastebin.com/7xhkzYNC.
>>>> I saw there is a similar thread, with similar problems "Question about
>>>> Edimax 7811Un", but as I'm new to the list didn't manage to continue
>>>> that thread.
>>>>
>>>> Seems a problem with amd64 systems. Is there any workaround? Anything
>>>> I can further test to help figuring this out?
>>>>
>>>> Thanks in advance
>>>> damencho
>>>
>>> First of all, please do not refer to pastebin-URLs as they have a
>>> limited life-cycle.
>>> A full dmesg and an output of lspci is much more appreciated, so
>>> interested people can look at it.
>>>
>>> - Sedat -
>>>
>>
>> sorry for the pastebin, here are lspci and dmesg prints:
>>
>> # lspci
>> 00:00.0 Host bridge: Intel Corporation Mobile PM965/GM965/GL960 Memory
>> Controller Hub (rev 03)
>> 00:02.0 VGA compatible controller: Intel Corporation Mobile
>> GM965/GL960 Integrated Graphics Controller (rev 03)
>> 00:02.1 Display controller: Intel Corporation Mobile GM965/GL960
>> Integrated Graphics Controller (rev 03)
>> 00:1a.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB
>> UHCI Controller #4 (rev 03)
>> 00:1a.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB
>> UHCI Controller #5 (rev 03)
>> 00:1a.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2
>> EHCI Controller #2 (rev 03)
>> 00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio
>> Controller (rev 03)
>> 00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express
>> Port 1 (rev 03)
>> 00:1c.4 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express
>> Port 5 (rev 03)
>> 00:1c.5 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express
>> Port 6 (rev 03)
>> 00:1d.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB
>> UHCI Controller #1 (rev 03)
>> 00:1d.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB
>> UHCI Controller #2 (rev 03)
>> 00:1d.2 USB Controller: Intel Corporation 82801H (ICH8 Family) USB
>> UHCI Controller #3 (rev 03)
>> 00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2
>> EHCI Controller #1 (rev 03)
>> 00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev f3)
>> 00:1f.0 ISA bridge: Intel Corporation 82801HEM (ICH8M) LPC Interface
>> Controller (rev 03)
>> 00:1f.1 IDE interface: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E)
>> IDE Controller (rev 03)
>> 00:1f.2 IDE interface: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E)
>> SATA IDE Controller (rev 03)
>> 00:1f.3 SMBus: Intel Corporation 82801H (ICH8 Family) SMBus Controller (rev 03)
>> 02:00.0 Network controller: Broadcom Corporation BCM4321 802.11a/b/g/n (rev 03)
>> 03:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8058
>> PCI-E Gigabit Ethernet Controller (rev 13)
>> 04:03.0 FireWire (IEEE 1394): Agere Systems FW322/323 (rev 61)
>>
>
> lspci shows BCM4321 device but no rtl8192CU.
> Is that USB?

Yes its usb, when I plug it I see it for a moment and then it
disappears from the output of lsusb, its:
Bus 001 Device 006: ID 0bda:8176 Realtek Semiconductor Corp.

> Then try with lsusb command and check by yourself (by reading the
> output) if there is EDUP ep-n8508 (rtl8192CU) listed or not.
> People on this list are interested in the vendor-id and product-id/modell-id.
> In my case it is: 168c (vendor-id) and 1014 (product-id).
>
> $ lspci -nnvv | grep "Ethernet controller" | grep Atheros
> 02:02.0 Ethernet controller [0200]: Atheros Communications Inc. AR5212
> 802.11abg NIC [168c:1014] (rev 01)
>
> "Full dmesg" means give us the output from the very first lines where
> your kernel boots up, not truncated or extracted.
>
> You should see sth. like this (first 10 lines, your output might differ):
>
> $ dmesg | head -10
> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 2.6.37-next20110107.dileks.1-686-iniza
> (Debian 2.6.37-2~next20110107.dileks.1) (sedat.dilek@gmail.com) (gcc
> version 4.5.2 (Debian 4.5.2-1) ) #1 SMP Fri Jan 7 07:52:57 CET 2011
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
> [    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
> [    0.000000]  BIOS-e820: 00000000000d2000 - 00000000000d4000 (reserved)
> [    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
> [    0.000000]  BIOS-e820: 0000000000100000 - 000000003ff60000 (usable)
> [    0.000000]  BIOS-e820: 000000003ff60000 - 000000003ff77000 (ACPI data)
>
> Best is you reboot and do 'dmesg > /tmp/dmesg.txt'.
>
> - Sedat -
>

I've rebooted to reduce the size of dmesg and here it is

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.35-24-generic (buildd@yellow) (gcc
version 4.4.5 (Ubuntu/Linaro 4.4.4-14ubuntu5) ) #42-Ubuntu SMP Thu Dec
2 02:41:37 UTC 2010 (Ubuntu 2.6.35-24.42-generic 2.6.35.8)
[    0.000000] Command line:
BOOT_IMAGE=/boot/vmlinuz-2.6.35-24-generic
root=UUID=4a4d7f5b-f901-4bf3-9ba0-f801fbc9c0ee ro splash quiet quiet
splash
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bdd31000 (usable)
[    0.000000]  BIOS-e820: 00000000bdd31000 - 00000000bdf32000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bdf32000 - 00000000bdfe5000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bdfe5000 - 00000000bdfe7000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bdfe7000 - 00000000beec3000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000beec3000 - 00000000beec5000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000beec5000 - 00000000beec8000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000beec8000 - 00000000beecb000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000beecb000 - 00000000beecc000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000beecc000 - 00000000beedf000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000beedf000 - 00000000beef9000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000beef9000 - 00000000beeff000 (reserved)
[    0.000000]  BIOS-e820: 00000000beeff000 - 00000000bef00000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bef00000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000140000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] e820 update range: 0000000000000000 - 0000000000001000
(usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x140000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-DFFFF uncachable
[    0.000000]   E0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0FFE00000 mask FFFE00000 write-protect
[    0.000000]   1 base 000000000 mask F80000000 write-back
[    0.000000]   2 base 080000000 mask FC0000000 write-back
[    0.000000]   3 base 100000000 mask FC0000000 write-back
[    0.000000]   4 base 0BF000000 mask FFF000000 uncachable
[    0.000000]   5 base 0BEF00000 mask FFFF00000 uncachable
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] last_pfn = 0xbdd31 max_arch_pfn = 0x400000000
[    0.000000] e820 update range: 0000000000001000 - 0000000000010000
(usable) ==> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009fc00 (usable)
[    0.000000]  modified: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000bdd31000 (usable)
[    0.000000]  modified: 00000000bdd31000 - 00000000bdf32000 (ACPI NVS)
[    0.000000]  modified: 00000000bdf32000 - 00000000bdfe5000 (ACPI data)
[    0.000000]  modified: 00000000bdfe5000 - 00000000bdfe7000 (ACPI NVS)
[    0.000000]  modified: 00000000bdfe7000 - 00000000beec3000 (ACPI data)
[    0.000000]  modified: 00000000beec3000 - 00000000beec5000 (ACPI NVS)
[    0.000000]  modified: 00000000beec5000 - 00000000beec8000 (ACPI data)
[    0.000000]  modified: 00000000beec8000 - 00000000beecb000 (ACPI NVS)
[    0.000000]  modified: 00000000beecb000 - 00000000beecc000 (ACPI data)
[    0.000000]  modified: 00000000beecc000 - 00000000beedf000 (ACPI NVS)
[    0.000000]  modified: 00000000beedf000 - 00000000beef9000 (ACPI data)
[    0.000000]  modified: 00000000beef9000 - 00000000beeff000 (reserved)
[    0.000000]  modified: 00000000beeff000 - 00000000bef00000 (ACPI data)
[    0.000000]  modified: 00000000bef00000 - 00000000c0000000 (reserved)
[    0.000000]  modified: 00000000f0000000 - 00000000f4000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  modified: 00000000fed14000 - 00000000fed1a000 (reserved)
[    0.000000]  modified: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100000000 - 0000000140000000 (usable)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000bdd31000
[    0.000000]  0000000000 - 00bdc00000 page 2M
[    0.000000]  00bdc00000 - 00bdd31000 page 4k
[    0.000000] kernel direct mapping tables up to bdd31000 @ 16000-1b000
[    0.000000] init_memory_mapping: 0000000100000000-0000000140000000
[    0.000000]  0100000000 - 0140000000 page 2M
[    0.000000] kernel direct mapping tables up to 140000000 @ 19000-1f000
[    0.000000] RAMDISK: 370ab000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000fe020 00024 (v02 APPLE )
[    0.000000] ACPI: XSDT 00000000beeee1c0 00084 (v01 APPLE   Apple00
000000C1      01000013)
[    0.000000] ACPI: FACP 00000000beeec000 000F4 (v03 APPLE   Apple00
000000C1 Loki 0000005F)
[    0.000000] ACPI: DSDT 00000000beee1000 045C6 (v01 APPLE   MacBook
00040001 INTL 20061109)
[    0.000000] ACPI: FACS 00000000beecc000 00040
[    0.000000] ACPI: HPET 00000000beeeb000 00038 (v01 APPLE   Apple00
00000001 Loki 0000005F)
[    0.000000] ACPI: APIC 00000000beeea000 00068 (v01 APPLE   Apple00
00000001 Loki 0000005F)
[    0.000000] ACPI: MCFG 00000000beee9000 0003C (v01 APPLE   Apple00
00000001 Loki 0000005F)
[    0.000000] ACPI: ASF! 00000000beee8000 000A5 (v32 APPLE   Apple00
00000001 Loki 0000005F)
[    0.000000] ACPI: SBST 00000000beee7000 00030 (v01 APPLE   Apple00
00000001 Loki 0000005F)
[    0.000000] ACPI: ECDT 00000000beee6000 00053 (v01 APPLE   Apple00
00000001 Loki 0000005F)
[    0.000000] ACPI: SSDT 00000000beec7000 004DC (v01  APPLE    CpuPm
00003000 INTL 20061109)
[    0.000000] ACPI: SSDT 00000000beec6000 0025F (v01  APPLE  Cpu0Tst
00003000 INTL 20061109)
[    0.000000] ACPI: SSDT 00000000beec5000 000A6 (v01  APPLE  Cpu1Tst
00003000 INTL 20061109)
[    0.000000] ACPI: SSDT 00000000beee0000 00544 (v01 SataRe  SataPri
00001000 INTL 20061109)
[    0.000000] ACPI: SSDT 00000000beedf000 00477 (v01 SataRe  SataSec
00001000 INTL 20061109)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000140000000
[    0.000000] Initmem setup node 0 0000000000000000-0000000140000000
[    0.000000]   NODE_DATA [0000000100000000 - 0000000100004fff]
[    0.000000]  [ffffea0000000000-ffffea00045fffff] PMD ->
[ffff880100200000-ffff8801039fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00140000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000bdd31
[    0.000000]     0: 0x00100000 -> 0x00140000
[    0.000000] On node 0 totalpages: 1039552
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3927 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 759145 pages, LIFO batch:31
[    0.000000]   Normal zone: 3584 pages used for memmap
[    0.000000]   Normal zone: 258560 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] early_res array is doubled to 64 at [1a000 - 1a7ff]
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bdd31000 - 00000000bdf32000
[    0.000000] PM: Registered nosave memory: 00000000bdf32000 - 00000000bdfe5000
[    0.000000] PM: Registered nosave memory: 00000000bdfe5000 - 00000000bdfe7000
[    0.000000] PM: Registered nosave memory: 00000000bdfe7000 - 00000000beec3000
[    0.000000] PM: Registered nosave memory: 00000000beec3000 - 00000000beec5000
[    0.000000] PM: Registered nosave memory: 00000000beec5000 - 00000000beec8000
[    0.000000] PM: Registered nosave memory: 00000000beec8000 - 00000000beecb000
[    0.000000] PM: Registered nosave memory: 00000000beecb000 - 00000000beecc000
[    0.000000] PM: Registered nosave memory: 00000000beecc000 - 00000000beedf000
[    0.000000] PM: Registered nosave memory: 00000000beedf000 - 00000000beef9000
[    0.000000] PM: Registered nosave memory: 00000000beef9000 - 00000000beeff000
[    0.000000] PM: Registered nosave memory: 00000000beeff000 - 00000000bef00000
[    0.000000] PM: Registered nosave memory: 00000000bef00000 - 00000000c0000000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000f4000000
[    0.000000] PM: Registered nosave memory: 00000000f4000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec01000
[    0.000000] PM: Registered nosave memory: 00000000fec01000 - 00000000fed14000
[    0.000000] PM: Registered nosave memory: 00000000fed14000 - 00000000fed1a000
[    0.000000] PM: Registered nosave memory: 00000000fed1a000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ffe00000
[    0.000000] PM: Registered nosave memory: 00000000ffe00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at c0000000 (gap:
c0000000:30000000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64
nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 30 pages/cpu @ffff880001e00000 s91520
r8192 d23168 u1048576
[    0.000000] early_res array is doubled to 128 at [1a800 - 1b7ff]
[    0.000000] pcpu-alloc: s91520 r8192 d23168 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.
Total pages: 1021632
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line:
BOOT_IMAGE=/boot/vmlinuz-2.6.35-24-generic
root=UUID=4a4d7f5b-f901-4bf3-9ba0-f801fbc9c0ee ro splash quiet quiet
splash
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Subtract (64 early reservations)
[    0.000000]   #1 [0001000000 - 0001d17114]   TEXT DATA BSS
[    0.000000]   #2 [00370ab000 - 0037ff0000]         RAMDISK
[    0.000000]   #3 [000009fc00 - 0000100000]   BIOS reserved
[    0.000000]   #4 [0001d18000 - 0001d1822d]             BRK
[    0.000000]   #5 [0000010000 - 0000012000]      TRAMPOLINE
[    0.000000]   #6 [0000012000 - 0000016000]     ACPI WAKEUP
[    0.000000]   #7 [0000016000 - 0000019000]         PGTABLE
[    0.000000]   #8 [0000019000 - 000001a000]         PGTABLE
[    0.000000]   #9 [0100000000 - 0100005000]       NODE_DATA
[    0.000000]   #10 [0001d18240 - 0001d19240]         BOOTMEM
[    0.000000]   #11 [0001d17140 - 0001d17440]         BOOTMEM
[    0.000000]   #12 [0100005000 - 0100006000]         BOOTMEM
[    0.000000]   #13 [0100006000 - 0100007000]         BOOTMEM
[    0.000000]   #14 [0100200000 - 0103a00000]        MEMMAP 0
[    0.000000]   #15 [0001d17440 - 0001d175c0]         BOOTMEM
[    0.000000]   #16 [0001d19240 - 0001d31240]         BOOTMEM
[    0.000000]   #17 [0001d31240 - 0001d37240]         BOOTMEM
[    0.000000]   #18 [0001d38000 - 0001d39000]         BOOTMEM
[    0.000000]   #19 [0001d175c0 - 0001d17601]         BOOTMEM
[    0.000000]   #20 [0001d17640 - 0001d17683]         BOOTMEM
[    0.000000]   #21 [0001d176c0 - 0001d17c38]         BOOTMEM
[    0.000000]   #22 [0001d17c40 - 0001d17ca8]         BOOTMEM
[    0.000000]   #23 [0001d17cc0 - 0001d17d28]         BOOTMEM
[    0.000000]   #24 [0001d17d40 - 0001d17da8]         BOOTMEM
[    0.000000]   #25 [0001d17dc0 - 0001d17e28]         BOOTMEM
[    0.000000]   #26 [0001d17e40 - 0001d17ea8]         BOOTMEM
[    0.000000]   #27 [0001d17ec0 - 0001d17f28]         BOOTMEM
[    0.000000]   #28 [0001d17f40 - 0001d17fa8]         BOOTMEM
[    0.000000]   #29 [0001d37240 - 0001d372a8]         BOOTMEM
[    0.000000]   #30 [0001d372c0 - 0001d37328]         BOOTMEM
[    0.000000]   #31 [0001d37340 - 0001d373a8]         BOOTMEM
[    0.000000]   #32 [0001d373c0 - 0001d37428]         BOOTMEM
[    0.000000]   #33 [0001d37440 - 0001d374a8]         BOOTMEM
[    0.000000]   #34 [0001d374c0 - 0001d37528]         BOOTMEM
[    0.000000]   #35 [0001d37540 - 0001d375a8]         BOOTMEM
[    0.000000]   #36 [0001d375c0 - 0001d37628]         BOOTMEM
[    0.000000]   #37 [0001d37640 - 0001d376a8]         BOOTMEM
[    0.000000]   #38 [0001d376c0 - 0001d37728]         BOOTMEM
[    0.000000]   #39 [0001d37740 - 0001d377a8]         BOOTMEM
[    0.000000]   #40 [0001d377c0 - 0001d37828]         BOOTMEM
[    0.000000]   #41 [0001d37840 - 0001d378a8]         BOOTMEM
[    0.000000]   #42 [0001d378c0 - 0001d37928]         BOOTMEM
[    0.000000]   #43 [0001d37940 - 0001d379a8]         BOOTMEM
[    0.000000]   #44 [0001d379c0 - 0001d37a28]         BOOTMEM
[    0.000000]   #45 [0001d37a40 - 0001d37aa8]         BOOTMEM
[    0.000000]   #46 [0001d17fc0 - 0001d17fe0]         BOOTMEM
[    0.000000]   #47 [0001d37ac0 - 0001d37ae0]         BOOTMEM
[    0.000000]   #48 [0001d37b00 - 0001d37b77]         BOOTMEM
[    0.000000]   #49 [0001d37b80 - 0001d37bf7]         BOOTMEM
[    0.000000]   #50 [0001e00000 - 0001e1e000]         BOOTMEM
[    0.000000]   #51 [0001f00000 - 0001f1e000]         BOOTMEM
[    0.000000]   #52 [0001d37c00 - 0001d37c08]         BOOTMEM
[    0.000000]   #53 [0001d37c40 - 0001d37c48]         BOOTMEM
[    0.000000]   #54 [0001d37c80 - 0001d37c88]         BOOTMEM
[    0.000000]   #55 [0001d37cc0 - 0001d37cd0]         BOOTMEM
[    0.000000]   #56 [0001d37d00 - 0001d37e40]         BOOTMEM
[    0.000000]   #57 [0001d37e40 - 0001d37ea0]         BOOTMEM
[    0.000000]   #58 [0001d37ec0 - 0001d37f20]         BOOTMEM
[    0.000000]   #59 [0001d39000 - 0001d41000]         BOOTMEM
[    0.000000]   #60 [0001f1e000 - 0005f1e000]         BOOTMEM
[    0.000000]   #61 [0001d41000 - 0001d61000]         BOOTMEM
[    0.000000]   #62 [0001d61000 - 0001da1000]         BOOTMEM
[    0.000000]   #63 [000001b800 - 0000023800]         BOOTMEM
[    0.000000] Memory: 4005392k/5242880k available (5711k kernel code,
1084672k absent, 152816k reserved, 5379k data, 908k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0,
CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:4352 nr_irqs:512
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 41943040 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't
want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2393.745 MHz processor.
[    0.010011] Calibrating delay loop (skipped), value calculated
using timer frequency.. 4787.49 BogoMIPS (lpj=23937450)
[    0.010015] pid_max: default: 32768 minimum: 301
[    0.010039] Security Framework initialized
[    0.010059] AppArmor: AppArmor initialized
[    0.010061] Yama: becoming mindful.
[    0.010470] Dentry cache hash table entries: 524288 (order: 10,
4194304 bytes)
[    0.013041] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.014135] Mount-cache hash table entries: 256
[    0.014283] Initializing cgroup subsys ns
[    0.014289] Initializing cgroup subsys cpuacct
[    0.014292] Initializing cgroup subsys memory
[    0.014301] Initializing cgroup subsys devices
[    0.014303] Initializing cgroup subsys freezer
[    0.014305] Initializing cgroup subsys net_cls
[    0.014335] CPU: Physical Processor ID: 0
[    0.014337] CPU: Processor Core ID: 0
[    0.014339] mce: CPU supports 6 MCE banks
[    0.014348] CPU0: Thermal monitoring enabled (TM2)
[    0.014353] using mwait in idle threads.
[    0.014355] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
[    0.014363] ... version:                2
[    0.014364] ... bit width:              40
[    0.014365] ... generic registers:      2
[    0.014367] ... value mask:             000000ffffffffff
[    0.014369] ... max period:             000000007fffffff
[    0.014370] ... fixed-purpose events:   3
[    0.014371] ... event mask:             0000000700000003
[    0.021932] ACPI: Core revision 20100428
[    0.028169] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.028175] ftrace: allocating 22678 entries in 89 pages
[    0.030055] Setting APIC routing to flat
[    0.030405] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.137676] CPU0: Intel(R) Core(TM)2 Duo CPU     T8300  @ 2.40GHz stepping 06
[    0.140000] Booting Node   0, Processors  #1 Ok.
[    0.300016] Brought up 2 CPUs
[    0.300020] Total of 2 processors activated (9575.47 BogoMIPS).
[    0.300631] devtmpfs: initialized
[    0.300642] regulator: core version 0.5
[    0.300673] Time: 13:32:13  Date: 01/07/11
[    0.300707] NET: Registered protocol family 16
[    0.300727] Trying to unpack rootfs image as initramfs...
[    0.300827] ACPI: bus type pci registered
[    0.300894] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem
0xf0000000-0xffffffff] (base 0xf0000000)
[    0.300897] PCI: MMCONFIG at [mem 0xf0000000-0xffffffff] reserved in E820
[    0.300900] PCI: MMCONFIG for 0000 [bus00-3f] at [mem
0xf0000000-0xf3ffffff] (base 0xf0000000) (size reduced!)
[    0.318809] PCI: Using configuration type 1 for base access
[    0.330087] bio: create slab <bio-0> at 0
[    0.331175] ACPI: EC: EC description table is found, configuring boot EC
[    0.331780] ACPI: BIOS _OSI(Linux) query ignored
[    0.332473] ACPI: SSDT 00000000beecaa98 00340 (v01  APPLE  Cpu0Ist
00003000 INTL 20061109)
[    0.332733] ACPI: Dynamic OEM Table Load:
[    0.332736] ACPI: SSDT (null) 00340 (v01  APPLE  Cpu0Ist 00003000
INTL 20061109)
[    0.332914] ACPI: SSDT 00000000beec8c18 002AD (v01  APPLE  Cpu0Cst
00003001 INTL 20061109)
[    0.333160] ACPI: Dynamic OEM Table Load:
[    0.333163] ACPI: SSDT (null) 002AD (v01  APPLE  Cpu0Cst 00003001
INTL 20061109)
[    0.333497] ACPI: SSDT 00000000beec9f18 000C8 (v01  APPLE  Cpu1Ist
00003000 INTL 20061109)
[    0.333750] ACPI: Dynamic OEM Table Load:
[    0.333753] ACPI: SSDT (null) 000C8 (v01  APPLE  Cpu1Ist 00003000
INTL 20061109)
[    0.333873] ACPI: SSDT 00000000beec8f18 00085 (v01  APPLE  Cpu1Cst
00003000 INTL 20061109)
[    0.334118] ACPI: Dynamic OEM Table Load:
[    0.334120] ACPI: SSDT (null) 00085 (v01  APPLE  Cpu1Cst 00003000
INTL 20061109)
[    0.334330] ACPI: Interpreter enabled
[    0.334333] ACPI: (supports S0 S3 S4 S5)
[    0.334350] ACPI: Using IOAPIC for interrupt routing
[    0.344846] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
[    0.344846] ACPI: No dock devices found.
[    0.344846] PCI: Using host bridge windows from ACPI; if necessary,
use "pci=nocrs" and report a bug
[    0.344846] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.344846] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.344846] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.344846] pci_root PNP0A08:00: host bridge window [mem
0x000a0000-0x000bffff]
[    0.344846] pci_root PNP0A08:00: host bridge window [mem
0xc0000000-0xfebfffff]
[    0.344846] pci 0000:00:02.0: reg 10: [mem 0xd0100000-0xd01fffff 64bit]
[    0.344846] pci 0000:00:02.0: reg 18: [mem 0xc0000000-0xcfffffff 64bit pref]
[    0.344846] pci 0000:00:02.0: reg 20: [io  0x6110-0x6117]
[    0.344846] pci 0000:00:02.1: reg 10: [mem 0xd0200000-0xd02fffff 64bit]
[    0.344846] pci 0000:00:1a.0: reg 20: [io  0x60c0-0x60df]
[    0.344846] pci 0000:00:1a.1: reg 20: [io  0x60a0-0x60bf]
[    0.344846] pci 0000:00:1a.7: reg 10: [mem 0xd0704c00-0xd0704fff]
[    0.344846] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.344846] pci 0000:00:1a.7: PME# disabled
[    0.344846] pci 0000:00:1b.0: reg 10: [mem 0xd0700000-0xd0703fff 64bit]
[    0.344846] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.344846] pci 0000:00:1b.0: PME# disabled
[    0.344846] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.344846] pci 0000:00:1c.0: PME# disabled
[    0.344846] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.344846] pci 0000:00:1c.4: PME# disabled
[    0.344846] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.344846] pci 0000:00:1c.5: PME# disabled
[    0.344846] pci 0000:00:1d.0: reg 20: [io  0x6080-0x609f]
[    0.344846] pci 0000:00:1d.1: reg 20: [io  0x6060-0x607f]
[    0.344846] pci 0000:00:1d.2: reg 20: [io  0x6040-0x605f]
[    0.344846] pci 0000:00:1d.7: reg 10: [mem 0xd0704800-0xd0704bff]
[    0.344846] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.344846] pci 0000:00:1d.7: PME# disabled
[    0.344846] pci 0000:00:1f.0: quirk: [io  0x0400-0x047f] claimed by
ICH6 ACPI/GPIO/TCO
[    0.344846] pci 0000:00:1f.0: quirk: [io  0x0500-0x053f] claimed by ICH6 GPIO
[    0.344846] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at
0680 (mask 000f)
[    0.344846] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at
1640 (mask 000f)
[    0.344846] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at
0300 (mask 001f)
[    0.344846] pci 0000:00:1f.1: reg 10: [io  0x6108-0x610f]
[    0.344846] pci 0000:00:1f.1: reg 14: [io  0x6124-0x6127]
[    0.344846] pci 0000:00:1f.1: reg 18: [io  0x6100-0x6107]
[    0.344846] pci 0000:00:1f.1: reg 1c: [io  0x6120-0x6123]
[    0.344846] pci 0000:00:1f.1: reg 20: [io  0x60e0-0x60ef]
[    0.344846] pci 0000:00:1f.2: reg 10: [io  0x60f8-0x60ff]
[    0.344846] pci 0000:00:1f.2: reg 14: [io  0x611c-0x611f]
[    0.344846] pci 0000:00:1f.2: reg 18: [io  0x60f0-0x60f7]
[    0.344846] pci 0000:00:1f.2: reg 1c: [io  0x6118-0x611b]
[    0.344846] pci 0000:00:1f.2: reg 20: [io  0x6020-0x602f]
[    0.344846] pci 0000:00:1f.2: reg 24: [io  0x4000-0x400f]
[    0.344846] pci 0000:00:1f.2: PME# supported from D3hot
[    0.344846] pci 0000:00:1f.2: PME# disabled
[    0.344846] pci 0000:00:1f.3: reg 10: [mem 0xd0705000-0xd07050ff]
[    0.344846] pci 0000:00:1f.3: reg 20: [io  0xefa0-0xefbf]
[    0.344846] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
[    0.344846] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.344846] pci 0000:00:1c.0:   bridge window [mem 0xd0600000-0xd06fffff]
[    0.344846] pci 0000:00:1c.0:   bridge window [mem
0xfff00000-0x000fffff pref] (disabled)
[    0.344846] pci 0000:02:00.0: reg 10: [mem 0xd0500000-0xd0503fff 64bit]
[    0.344846] pci 0000:02:00.0: reg 18: [mem 0xd0000000-0xd00fffff 64bit pref]
[    0.344846] pci 0000:02:00.0: supports D1 D2
[    0.344846] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.344846] pci 0000:02:00.0: PME# disabled
[    0.360026] pci 0000:00:1c.4: PCI bridge to [bus 02-02]
[    0.360032] pci 0000:00:1c.4:   bridge window [io  0xf000-0x0000] (disabled)
[    0.360038] pci 0000:00:1c.4:   bridge window [mem 0xd0500000-0xd05fffff]
[    0.360046] pci 0000:00:1c.4:   bridge window [mem
0xd0000000-0xd00fffff 64bit pref]
[    0.360422] pci 0000:03:00.0: reg 10: [mem 0xd0400000-0xd0403fff 64bit]
[    0.360475] pci 0000:03:00.0: reg 18: [io  0x5000-0x50ff]
[    0.360668] pci 0000:03:00.0: reg 30: [mem 0xfffe0000-0xffffffff pref]
[    0.360996] pci 0000:03:00.0: supports D1 D2
[    0.360998] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.361023] pci 0000:03:00.0: PME# disabled
[    0.361237] pci 0000:00:1c.5: PCI bridge to [bus 03-03]
[    0.361242] pci 0000:00:1c.5:   bridge window [io  0x5000-0x5fff]
[    0.361247] pci 0000:00:1c.5:   bridge window [mem 0xd0400000-0xd04fffff]
[    0.361255] pci 0000:00:1c.5:   bridge window [mem
0xfff00000-0x000fffff pref] (disabled)
[    0.361323] pci 0000:04:03.0: reg 10: [mem 0xd0300000-0xd0300fff]
[    0.361384] pci 0000:04:03.0: supports D1 D2
[    0.361386] pci 0000:04:03.0: PME# supported from D0 D1 D2 D3hot
[    0.361390] pci 0000:04:03.0: PME# disabled
[    0.361452] pci 0000:00:1e.0: PCI bridge to [bus 04-04] (subtractive decode)
[    0.361458] pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.361463] pci 0000:00:1e.0:   bridge window [mem 0xd0300000-0xd03fffff]
[    0.361471] pci 0000:00:1e.0:   bridge window [mem
0xfff00000-0x000fffff pref] (disabled)
[    0.361474] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7]
(subtractive decode)
[    0.361476] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff]
(subtractive decode)
[    0.361478] pci 0000:00:1e.0:   bridge window [mem
0x000a0000-0x000bffff] (subtractive decode)
[    0.361481] pci 0000:00:1e.0:   bridge window [mem
0xc0000000-0xfebfffff] (subtractive decode)
[    0.361519] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.361723] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP05._PRT]
[    0.361787] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP06._PRT]
[    0.361881] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    0.369838] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12
14 15) *11
[    0.369925] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 *7 11 12 14 15)
[    0.370031] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 *5 6 7 10 12 14 15)
[    0.370115] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12
14 15) *0, disabled.
[    0.370199] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 *10 12 14 15)
[    0.370281] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *9
[    0.370365] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12
14 15) *0, disabled.
[    0.370448] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 11 12
14 15) *0, disabled.
[    0.370488] HEST: Table is not found!
[    0.370562] vgaarb: device added:
PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.370574] vgaarb: loaded
[    0.370712] SCSI subsystem initialized
[    0.370805] libata version 3.00 loaded.
[    0.370859] usbcore: registered new interface driver usbfs
[    0.370870] usbcore: registered new interface driver hub
[    0.370892] usbcore: registered new device driver usb
[    0.371011] ACPI: WMI: Mapper loaded
[    0.371013] PCI: Using ACPI for IRQ routing
[    0.371016] PCI: pci_cache_line_size set to 64 bytes
[    0.371162] reserve RAM buffer: 000000000009fc00 - 000000000009ffff
[    0.371165] reserve RAM buffer: 00000000bdd31000 - 00000000bfffffff
[    0.371255] NetLabel: Initializing
[    0.371256] NetLabel:  domain hash size = 128
[    0.371258] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.371271] NetLabel:  unlabeled traffic allowed by default
[    0.371300] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.371306] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.371310] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.390040] Switching to clocksource tsc
[    0.399475] AppArmor: AppArmor Filesystem Enabled
[    0.399494] pnp: PnP ACPI init
[    0.399525] ACPI: bus type pnp registered
[    0.404262] pnp: PnP ACPI: found 9 devices
[    0.404264] ACPI: ACPI bus type pnp unregistered
[    0.404278] system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.404281] system 00:01: [mem 0xfed14000-0xfed17fff] has been reserved
[    0.404284] system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.404286] system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.404289] system 00:01: [mem 0xf0000000-0xf3ffffff] has been reserved
[    0.404291] system 00:01: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.404294] system 00:01: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.404300] system 00:05: [mem 0xfed00000-0xfed003ff] has been reserved
[    0.404305] system 00:07: [io  0x0680-0x069f] has been reserved
[    0.404308] system 00:07: [io  0x0800-0x080f] has been reserved
[    0.404310] system 00:07: [io  0x0810-0x0817] has been reserved
[    0.404313] system 00:07: [io  0x0400-0x047f] has been reserved
[    0.404315] system 00:07: [io  0x0500-0x053f] has been reserved
[    0.404317] system 00:07: [io  0x1640-0x164f] has been reserved
[    0.410292] pci 0000:03:00.0: no compatible bridge window for [mem
0xfffe0000-0xffffffff pref]
[    0.410349] pci 0000:00:1c.0: BAR 15: assigned [mem
0xd0800000-0xd09fffff 64bit pref]
[    0.410352] pci 0000:00:1c.5: BAR 15: assigned [mem
0xd0a00000-0xd0bfffff pref]
[    0.410355] pci 0000:00:1c.0: BAR 13: assigned [io  0x2000-0x2fff]
[    0.410358] pci 0000:00:1c.4: BAR 13: assigned [io  0x3000-0x3fff]
[    0.410360] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
[    0.410363] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.410370] pci 0000:00:1c.0:   bridge window [mem 0xd0600000-0xd06fffff]
[    0.410375] pci 0000:00:1c.0:   bridge window [mem
0xd0800000-0xd09fffff 64bit pref]
[    0.410383] pci 0000:00:1c.4: PCI bridge to [bus 02-02]
[    0.410386] pci 0000:00:1c.4:   bridge window [io  0x3000-0x3fff]
[    0.410392] pci 0000:00:1c.4:   bridge window [mem 0xd0500000-0xd05fffff]
[    0.410397] pci 0000:00:1c.4:   bridge window [mem
0xd0000000-0xd00fffff 64bit pref]
[    0.410406] pci 0000:03:00.0: BAR 6: assigned [mem
0xd0a00000-0xd0a1ffff pref]
[    0.410408] pci 0000:00:1c.5: PCI bridge to [bus 03-03]
[    0.410411] pci 0000:00:1c.5:   bridge window [io  0x5000-0x5fff]
[    0.410417] pci 0000:00:1c.5:   bridge window [mem 0xd0400000-0xd04fffff]
[    0.410422] pci 0000:00:1c.5:   bridge window [mem
0xd0a00000-0xd0bfffff pref]
[    0.410430] pci 0000:00:1e.0: PCI bridge to [bus 04-04]
[    0.410432] pci 0000:00:1e.0:   bridge window [io  disabled]
[    0.410438] pci 0000:00:1e.0:   bridge window [mem 0xd0300000-0xd03fffff]
[    0.410442] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.410458] pci 0000:00:1c.0: enabling device (0000 -> 0003)
[    0.410465]   alloc irq_desc for 16 on node -1
[    0.410467]   alloc kstat_irqs on node -1
[    0.410474] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.410481] pci 0000:00:1c.0: setting latency timer to 64
[    0.410492] pci 0000:00:1c.4: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.410497] pci 0000:00:1c.4: setting latency timer to 64
[    0.410507]   alloc irq_desc for 17 on node -1
[    0.410508]   alloc kstat_irqs on node -1
[    0.410511] pci 0000:00:1c.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.410516] pci 0000:00:1c.5: setting latency timer to 64
[    0.410581] pci 0000:00:1e.0: power state changed by ACPI to D0
[    0.410625] pci 0000:00:1e.0: power state changed by ACPI to D0
[    0.410632] pci 0000:00:1e.0: setting latency timer to 64
[    0.410636] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.410639] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.410641] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.410643] pci_bus 0000:00: resource 7 [mem 0xc0000000-0xfebfffff]
[    0.410645] pci_bus 0000:01: resource 0 [io  0x2000-0x2fff]
[    0.410647] pci_bus 0000:01: resource 1 [mem 0xd0600000-0xd06fffff]
[    0.410650] pci_bus 0000:01: resource 2 [mem 0xd0800000-0xd09fffff
64bit pref]
[    0.410652] pci_bus 0000:02: resource 0 [io  0x3000-0x3fff]
[    0.410654] pci_bus 0000:02: resource 1 [mem 0xd0500000-0xd05fffff]
[    0.410656] pci_bus 0000:02: resource 2 [mem 0xd0000000-0xd00fffff
64bit pref]
[    0.410658] pci_bus 0000:03: resource 0 [io  0x5000-0x5fff]
[    0.410660] pci_bus 0000:03: resource 1 [mem 0xd0400000-0xd04fffff]
[    0.410662] pci_bus 0000:03: resource 2 [mem 0xd0a00000-0xd0bfffff pref]
[    0.410664] pci_bus 0000:04: resource 1 [mem 0xd0300000-0xd03fffff]
[    0.410666] pci_bus 0000:04: resource 4 [io  0x0000-0x0cf7]
[    0.410668] pci_bus 0000:04: resource 5 [io  0x0d00-0xffff]
[    0.410670] pci_bus 0000:04: resource 6 [mem 0x000a0000-0x000bffff]
[    0.410672] pci_bus 0000:04: resource 7 [mem 0xc0000000-0xfebfffff]
[    0.410714] NET: Registered protocol family 2
[    0.410859] IP route cache hash table entries: 131072 (order: 8,
1048576 bytes)
[    0.412122] TCP established hash table entries: 524288 (order: 11,
8388608 bytes)
[    0.416830] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.417461] TCP: Hash tables configured (established 524288 bind 65536)
[    0.417464] TCP reno registered
[    0.417480] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.417523] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.417670] NET: Registered protocol family 1
[    0.417699] pci 0000:00:02.0: Boot video device
[    0.417902] PCI: CLS mismatch (256 != 64), using 64 bytes
[    0.417905] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.417909] Placing 64MB software IO TLB between ffff880001f1e000 -
ffff880005f1e000
[    0.417911] software IO TLB at phys 0x1f1e000 - 0x5f1e000
[    0.418120] Scanning for low memory corruption every 60 seconds
[    0.418304] audit: initializing netlink socket (disabled)
[    0.418316] type=2000 audit(1294407132.400:1): initialized
[    0.440380] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.441648] VFS: Disk quotas dquot_6.5.2
[    0.441697] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.442236] fuse init (API version 7.14)
[    0.442307] msgmni has been set to 7823
[    0.442569] Block layer SCSI generic (bsg) driver version 0.4
loaded (major 253)
[    0.442572] io scheduler noop registered
[    0.442574] io scheduler deadline registered
[    0.442604] io scheduler cfq registered (default)
[    0.442714] pcieport 0000:00:1c.0: setting latency timer to 64
[    0.442763]   alloc irq_desc for 40 on node -1
[    0.442765]   alloc kstat_irqs on node -1
[    0.442778] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
[    0.442873] pcieport 0000:00:1c.4: setting latency timer to 64
[    0.442918]   alloc irq_desc for 41 on node -1
[    0.442920]   alloc kstat_irqs on node -1
[    0.442929] pcieport 0000:00:1c.4: irq 41 for MSI/MSI-X
[    0.443026] pcieport 0000:00:1c.5: setting latency timer to 64
[    0.443072]   alloc irq_desc for 42 on node -1
[    0.443074]   alloc kstat_irqs on node -1
[    0.443082] pcieport 0000:00:1c.5: irq 42 for MSI/MSI-X
[    0.443191] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.443600] pciehp 0000:00:1c.0:pcie04: HPC vendor_id 8086
device_id 283f ss_vid 0 ss_did 0
[    0.443636] pciehp 0000:00:1c.0:pcie04: service driver pciehp loaded
[    0.443652] pciehp 0000:00:1c.4:pcie04: HPC vendor_id 8086
device_id 2847 ss_vid 0 ss_did 0
[    0.443685] pciehp 0000:00:1c.4:pcie04: service driver pciehp loaded
[    0.443701] pciehp 0000:00:1c.5:pcie04: HPC vendor_id 8086
device_id 2849 ss_vid 0 ss_did 0
[    0.443728] pciehp 0000:00:1c.5:pcie04: service driver pciehp loaded
[    0.443735] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.443806] efifb: dmi detected MacBook4,1 - framebuffer at
0000000080000000 (1280x800, stride 8192)
[    0.443810] intel_idle: MWAIT substates: 0x3122220
[    0.443811] intel_idle: does not run on family 6 model 23
[    0.443888] ACPI: AC Adapter [ADP1] (on-line)
[    0.443970] input: Lid Switch as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
[    0.444003] ACPI: Lid Switch [LID0]
[    0.444041] input: Power Button as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
[    0.444046] ACPI: Power Button [PWRB]
[    0.444079] input: Sleep Button as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input2
[    0.444082] ACPI: Sleep Button [SLPB]
[    0.444129] input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    0.444132] ACPI: Power Button [PWRF]
[    0.444306] ACPI: acpi_idle registered with cpuidle
[    0.459817] Monitor-Mwait will be used to enter C-1 state
[    0.460029] Monitor-Mwait will be used to enter C-2 state
[    0.470005] Monitor-Mwait will be used to enter C-3 state
[    0.470017] Marking TSC unstable due to TSC halts in idle
[    0.472074] Switching to clocksource hpet
[    0.475061] ERST: Table is not found!
[    0.475568] Linux agpgart interface v0.103
[    0.475595] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.476806] brd: module loaded
[    0.477254] loop: module loaded
[    0.477430] ata_piix 0000:00:1f.1: version 2.13
[    0.477485] ata_piix 0000:00:1f.1: power state changed by ACPI to D0
[    0.477516] ata_piix 0000:00:1f.1: power state changed by ACPI to D0
[    0.477525]   alloc irq_desc for 21 on node -1
[    0.477527]   alloc kstat_irqs on node -1
[    0.477538] ata_piix 0000:00:1f.1: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    0.477579] ata_piix 0000:00:1f.1: setting latency timer to 64
[    0.482422] scsi0 : ata_piix
[    0.482513] scsi1 : ata_piix
[    0.482988] ata1: PATA max UDMA/100 cmd 0x6108 ctl 0x6124 bmdma 0x60e0 irq 21
[    0.482991] ata2: PATA max UDMA/100 cmd 0x6100 ctl 0x6120 bmdma 0x60e8 irq 21
[    0.483015]   alloc irq_desc for 18 on node -1
[    0.483017]   alloc kstat_irqs on node -1
[    0.483023] ata_piix 0000:00:1f.2: PCI INT B -> GSI 18 (level, low) -> IRQ 18
[    0.483028] ata_piix 0000:00:1f.2: MAP [ P0 -- -- -- ]
[    0.483076] ata_piix 0000:00:1f.2: setting latency timer to 64
[    0.490125] scsi2 : ata_piix
[    0.490196] scsi3 : ata_piix
[    0.490925] ata3: SATA max UDMA/133 cmd 0x60f8 ctl 0x611c bmdma 0x6020 irq 18
[    0.490927] ata4: SATA max UDMA/133 cmd 0x60f0 ctl 0x6118 bmdma 0x6028 irq 18
[    0.491197] Fixed MDIO Bus: probed
[    0.491227] PPP generic driver version 2.4.2
[    0.491283] tun: Universal TUN/TAP device driver, 1.6
[    0.491284] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    0.491382] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.491404] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 21 (level, low) -> IRQ 21
[    0.491436] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    0.491440] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    0.491472] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned
bus number 1
[    0.491507] ehci_hcd 0000:00:1a.7: debug port 1
[    0.495383] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    0.495391] ehci_hcd 0000:00:1a.7: irq 21, io mem 0xd0704c00
[    0.512545] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    0.512780] hub 1-0:1.0: USB hub found
[    0.512785] hub 1-0:1.0: 4 ports detected
[    0.512938]   alloc irq_desc for 20 on node -1
[    0.512940]   alloc kstat_irqs on node -1
[    0.512947] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 20 (level, low) -> IRQ 20
[    0.512978] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    0.512982] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    0.513017] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned
bus number 2
[    0.513087] ehci_hcd 0000:00:1d.7: debug port 1
[    0.516956] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    0.516984] ehci_hcd 0000:00:1d.7: irq 20, io mem 0xd0704800
[    0.532543] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    0.532741] hub 2-0:1.0: USB hub found
[    0.532747] hub 2-0:1.0: 6 ports detected
[    0.532829] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.532844] uhci_hcd: USB Universal Host Controller Interface driver
[    0.532947] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.532963] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    0.532968] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    0.533008] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned
bus number 3
[    0.533039] uhci_hcd 0000:00:1a.0: irq 20, io base 0x000060c0
[    0.533147] hub 3-0:1.0: USB hub found
[    0.533151] hub 3-0:1.0: 2 ports detected
[    0.533204] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.533210] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    0.533214] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    0.533247] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned
bus number 4
[    0.533320] uhci_hcd 0000:00:1a.1: irq 16, io base 0x000060a0
[    0.533447] hub 4-0:1.0: USB hub found
[    0.533450] hub 4-0:1.0: 2 ports detected
[    0.533507] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.533513] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    0.533516] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    0.533549] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned
bus number 5
[    0.533576] uhci_hcd 0000:00:1d.0: irq 16, io base 0x00006080
[    0.533677] hub 5-0:1.0: USB hub found
[    0.533680] hub 5-0:1.0: 2 ports detected
[    0.533733] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 18 (level, low) -> IRQ 18
[    0.533739] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    0.533742] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    0.533774] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned
bus number 6
[    0.533802] uhci_hcd 0000:00:1d.1: irq 18, io base 0x00006060
[    0.533910] hub 6-0:1.0: USB hub found
[    0.533913] hub 6-0:1.0: 2 ports detected
[    0.533968] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 21 (level, low) -> IRQ 21
[    0.533974] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    0.533978] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    0.534004] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned
bus number 7
[    0.534033] uhci_hcd 0000:00:1d.2: irq 21, io base 0x00006040
[    0.534136] hub 7-0:1.0: USB hub found
[    0.534140] hub 7-0:1.0: 2 ports detected
[    0.534240] PNP: No PS/2 controller found. Probing ports directly.
[    0.535097] i8042.c: No controller found.
[    0.535152] mice: PS/2 mouse device common for all mice
[    0.535298] rtc_cmos 00:08: RTC can wake from S4
[    0.535336] rtc_cmos 00:08: rtc core: registered rtc_cmos as rtc0
[    0.535370] rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    0.535455] device-mapper: uevent: version 1.0.3
[    0.535534] device-mapper: ioctl: 4.17.0-ioctl (2010-03-05)
initialised: dm-devel@redhat.com
[    0.535593] device-mapper: multipath: version 1.1.1 loaded
[    0.535595] device-mapper: multipath round-robin: version 1.0.0 loaded
[    0.535790] cpuidle: using governor ladder
[    0.535868] cpuidle: using governor menu
[    0.536102] TCP cubic registered
[    0.536206] NET: Registered protocol family 10
[    0.536505] lo: Disabled Privacy Extensions
[    0.536668] NET: Registered protocol family 17
[    0.537275] PM: Resume from disk failed.
[    0.537287] registered taskstats version 1
[    0.537712]   Magic number: 11:349:533
[    0.537731] bdi 1:11: hash matches
[    0.537831] rtc_cmos 00:08: setting system clock to 2011-01-07
13:32:13 UTC (1294407133)
[    0.537833] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    0.537835] EDD information not available.
[    0.623866] ACPI: Battery Slot [BAT0] (battery present)
[    0.626736] Freeing initrd memory: 15636k freed
[    0.675439] ata1.00: ATAPI: HL-DT-ST DVDRW  GSA-S10N, BP10, max UDMA/33
[    0.675594] ata3.00: ATA-8: FUJITSU MHY2250BH, 0081000D, max UDMA/100
[    0.675596] ata3.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    0.710379] ata1.00: configured for UDMA/33
[    0.710421] ata3.00: configured for UDMA/100
[    0.714603] scsi 0:0:0:0: CD-ROM            HL-DT-ST DVDRW
GSA-S10N  BP10 PQ: 0 ANSI: 5
[    0.724909] sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda caddy
[    0.724914] Uniform CD-ROM driver Revision: 3.20
[    0.725043] sr 0:0:0:0: Attached scsi CD-ROM sr0
[    0.725109] sr 0:0:0:0: Attached scsi generic sg0 type 5
[    0.725252] scsi 2:0:0:0: Direct-Access     ATA      FUJITSU
MHY2250B 0081 PQ: 0 ANSI: 5
[    0.725353] sd 2:0:0:0: Attached scsi generic sg1 type 0
[    0.725361] sd 2:0:0:0: [sda] 488397168 512-byte logical blocks:
(250 GB/232 GiB)
[    0.725447] sd 2:0:0:0: [sda] Write Protect is off
[    0.725450] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    0.725506] sd 2:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    0.725796]  sda: sda1 sda2 sda3 sda4
[    0.769245] sd 2:0:0:0: [sda] Attached SCSI disk
[    0.769282] Freeing unused kernel memory: 908k freed
[    0.769728] Write protecting the kernel read-only data: 10240k
[    0.769898] Freeing unused kernel memory: 412k freed
[    0.770296] Freeing unused kernel memory: 1644k freed
[    0.785660] udev[93]: starting version 163
[    0.854854] input: Video Bus as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input4
[    0.854901] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    0.859711] agpgart-intel 0000:00:00.0: Intel 965GM Chipset
[    0.860785] agpgart-intel 0000:00:00.0: detected 15868K stolen memory
[    0.882670] sky2: driver version 1.28
[    0.882770] sky2 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.882819] sky2 0000:03:00.0: setting latency timer to 64
[    0.882918] sky2 0000:03:00.0: Yukon-2 EC Ultra chip revision 3
[    0.883876]   alloc irq_desc for 43 on node -1
[    0.883879]   alloc kstat_irqs on node -1
[    0.883950] sky2 0000:03:00.0: irq 43 for MSI/MSI-X
[    0.884881] sky2 0000:03:00.0: eth0: addr 00:1f:5b:f5:d2:ef
[    0.896963]   alloc irq_desc for 19 on node -1
[    0.896966]   alloc kstat_irqs on node -1
[    0.896974] firewire_ohci 0000:04:03.0: PCI INT A -> GSI 19 (level,
low) -> IRQ 19
[    0.914676] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xc0000000
[    0.931054] [drm] Initialized drm 1.1.0 20060810
[    0.949354] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.949360] i915 0000:00:02.0: setting latency timer to 64
[    0.952591] usb 1-2: new high speed USB device using ehci_hcd and address 3
[    1.033655]   alloc irq_desc for 44 on node -1
[    1.033659]   alloc kstat_irqs on node -1
[    1.033668] i915 0000:00:02.0: irq 44 for MSI/MSI-X
[    1.033681] [drm] set up 15M of stolen space
[    1.150038] firewire_ohci: Added fw-ohci device 0000:04:03.0, OHCI
v1.0, 8 IR + 8 IT contexts, quirks 0x0
[    1.280040] usb 2-4: new high speed USB device using ehci_hcd and address 3
[    1.473037] vgaarb: device changed decodes:
PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    1.473351] [drm] initialized overlay support
[    1.476560] render error detected, EIR: 0x00000010
[    1.476562] page table error
[    1.476563]   PGTBL_ER: 0x00000100
[    1.476567] [drm:i915_report_and_clear_eir] *ERROR* EIR stuck:
0x00000010, masking
[    1.684821] firewire_core: created device fw0: GUID 001ff3fffe24cba8, S400
[    1.770068] Skipping EDID probe due to cached edid
[    1.890071] usb 3-1: new full speed USB device using uhci_hcd and address 2
[    2.092073] usbcore: registered new interface driver hiddev
[    2.097842] Console: switching to colour frame buffer device 160x50
[    2.100177] fb0: inteldrmfb frame buffer device
[    2.100179] drm: registered panic notifier
[    2.100182] Slow work thread pool: Starting up
[    2.100336] Slow work thread pool: Ready
[    2.100345] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    2.109383] input: HID 05ac:1000 as
/devices/pci0000:00/0000:00:1a.0/usb3/3-1/3-1:1.0/input/input5
[    2.109464] generic-usb 0003:05AC:1000.0001: input,hidraw0: USB HID
v1.11 Keyboard [HID 05ac:1000] on usb-0000:00:1a.0-1/input0
[    2.141355] input: HID 05ac:1000 as
/devices/pci0000:00/0000:00:1a.0/usb3/3-1/3-1:1.1/input/input6
[    2.141425] generic-usb 0003:05AC:1000.0002: input,hidraw1: USB HID
v1.11 Mouse [HID 05ac:1000] on usb-0000:00:1a.0-1/input1
[    2.141438] usbcore: registered new interface driver usbhid
[    2.141439] usbhid: USB HID core driver
[    2.360101] usb 5-1: new low speed USB device using uhci_hcd and address 2
[    2.422607] Skipping EDID probe due to cached edid
[    2.571924] input: Logitech USB Receiver as
/devices/pci0000:00/0000:00:1d.0/usb5/5-1/5-1:1.0/input/input7
[    2.572016] generic-usb 0003:046D:C51B.0003: input,hidraw2: USB HID
v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:1d.0-1/input0
[    2.585772] generic-usb 0003:046D:C51B.0004: hiddev96,hidraw3: USB
HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:1d.0-1/input1
[    2.870056] usb 7-1: new low speed USB device using uhci_hcd and address 2
[    2.968764] EXT4-fs (sda3): mounted filesystem with ordered data
mode. Opts: (null)
[    3.340062] usb 7-2: new full speed USB device using uhci_hcd and address 3
[   20.614624] udev[397]: starting version 163
[   20.645360] lp: driver loaded but no devices found
[   20.817784] lib80211: common routines for IEEE802.11 drivers
[   20.817788] lib80211_crypt: registered algorithm 'NULL'
[   20.822655] mbp_nvidia_bl: MacBook 4,1 detected
[   20.863981] applesmc: Apple MacBook 4 detected:
[   20.863985] applesmc:  - Model with accelerometer
[   20.863986] applesmc:  - Model without light sensors and backlight
[   20.863989] applesmc:  - Model with 10 temperature sensors
[   20.907715] EXT4-fs (sda3): re-mounted. Opts: errors=remount-ro
[   20.930801] applesmc: device successfully initialized (0xe0, 0x00).
[   20.930804] applesmc: device successfully initialized.
[   20.931489] applesmc: 1 fans found.
[   20.933552] input: applesmc as /devices/platform/applesmc.768/input/input8
[   20.933625] applesmc: driver successfully loaded.
[   20.953846] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 20 (level,
low) -> IRQ 20
[   20.953928]   alloc irq_desc for 45 on node -1
[   20.953930]   alloc kstat_irqs on node -1
[   20.953944] HDA Intel 0000:00:1b.0: irq 45 for MSI/MSI-X
[   20.953975] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   20.990770] wl: module license 'unspecified' taints kernel.
[   20.990774] Disabling lock debugging due to kernel taint
[   21.000621] wl 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   21.000629] wl 0000:02:00.0: setting latency timer to 64
[   21.017617] type=1400 audit(1294399953.966:2): apparmor="STATUS"
operation="profile_load" name="/sbin/dhclient3" pid=694
comm="apparmor_parser"
[   21.018214] type=1400 audit(1294399953.966:3): apparmor="STATUS"
operation="profile_load"
name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=694
comm="apparmor_parser"
[   21.018539] type=1400 audit(1294399953.966:4): apparmor="STATUS"
operation="profile_load"
name="/usr/lib/connman/scripts/dhclient-script" pid=694
comm="apparmor_parser"
[   21.021088] lib80211_crypt: registered algorithm 'TKIP'
[   21.040880] eth1: Broadcom BCM4328 802.11 Hybrid Wireless
Controller 5.100.82.38
[   21.044766] hda_codec: ALC889A: SKU not ready 0x400000f0
[   21.071759] udev[406]: renamed network interface eth1 to eth2
[   21.130070] usb 3-1: usbfs: USBDEVFS_CONTROL failed cmd hid2hci rqt
64 rq 0 len 0 ret -84
[   21.147564] rtw driver version=v2.0.1212.20101205
[   21.147603] register rtl8192_netdev_ops to netdev_ops
[   21.147609]
[   21.147609] 8712_usb_endpoint_descriptor(0):
[   21.147611] bLength=7
[   21.147612] bDescriptorType=5
[   21.147613] bEndpointAddress=81
[   21.147615] wMaxPacketSize=200
[   21.147616] bInterval=0
[   21.147617]
[   21.147617] 8712_usb_endpoint_descriptor(1):
[   21.147619] bLength=7
[   21.147620] bDescriptorType=5
[   21.147621] bEndpointAddress=2
[   21.147622] wMaxPacketSize=200
[   21.147623] bInterval=0
[   21.147624]
[   21.147625] 8712_usb_endpoint_descriptor(2):
[   21.147626] bLength=7
[   21.147627] bDescriptorType=5
[   21.147628] bEndpointAddress=3
[   21.147630] wMaxPacketSize=200
[   21.147631] bInterval=0
[   21.147632]
[   21.147632] 8712_usb_endpoint_descriptor(3):
[   21.147633] bLength=7
[   21.147635] bDescriptorType=5
[   21.147636] bEndpointAddress=84
[   21.147637] wMaxPacketSize=40
[   21.147638] bInterval=1
[   21.147640] nr_endpoint=4, in_num=2, out_num=2
[   21.147640]
[   21.147642] 8192cu: USB_SPEED_HIGH
[   21.148257] Chip Version ID: VERSION_NORMAL_TSMC_CHIP_88C.
[   21.148793] EEPROM type is E-FUSE
[   21.148795] ====> ReadAdapterInfo8192C
[   21.148916] Boot from EFUSE, Autoload Success !
[   21.153801] rtw_efuse_get_max_phy_size...eeprompriv.efuse_phy_max_size(504)
[   21.176068] appletouch: Geyser mode initialized.
[   21.176172] input: appletouch as
/devices/pci0000:00/0000:00:1d.2/usb7/7-2/7-2:1.1/input/input9
[   21.176297] usbcore: registered new interface driver appletouch
[   21.312183] apple 0003:05AC:8242.0005: hiddev97,hidraw4: USB HID
v1.11 Device [Apple Computer, Inc. IR Receiver] on
usb-0000:00:1d.2-1/input0
[   21.316363] input: Apple Computer Apple Internal Keyboard /
Trackpad as /devices/pci0000:00/0000:00:1d.2/usb7/7-2/7-2:1.0/input/input10
[   21.316472] apple 0003:05AC:022A.0006: input,hidraw5: USB HID v1.11
Keyboard [Apple Computer Apple Internal Keyboard / Trackpad] on
usb-0000:00:1d.2-2/input0
[   21.319263] input: Apple Computer Apple Internal Keyboard /
Trackpad as /devices/pci0000:00/0000:00:1d.2/usb7/7-2/7-2:1.2/input/input11
[   21.319361] apple 0003:05AC:022A.0007: input,hidraw6: USB HID v1.11
Device [Apple Computer Apple Internal Keyboard / Trackpad] on
usb-0000:00:1d.2-2/input2
[   21.450139] usb 2-4: USB disconnect, address 3
[   21.520717] Failed to initialise isight firmware loader
[   21.520758] usbcore: registered new interface driver isight_firmware
[   21.615434] EEPROMVID = 0x0bda
[   21.615437] EEPROMPID = 0x8176
[   21.615439] EEPROMCustomerID : 0x00
[   21.615440] EEPROMSubCustomerID: 0x00
[   21.615441] RT_CustomerID: 0x00
[   21.615444] RT_ChannelPlan: 0x02
[   21.615446] _ReadBoardType(0)
[   21.615447] ### AntDivCfg(0)
[   21.615449] BT Coexistance = disable
[   21.615451] _ReadHWPDSelection...bHWPwrPindetect(0) bSupportRemoteWakeup(0)
[   21.615453] <==== ReadAdapterInfo8192C
[   21.615456] MAC Address from efuse= 00:e0:4c:00:29:ba
[   21.616452] usbcore: registered new interface driver rtw_usb_drv
[   21.672601] usb 3-1: USB disconnect, address 2
[   21.760483] udev[403]: renamed network interface wlan0 to wlan1
[   22.110088] usb 3-1: new full speed USB device using uhci_hcd and address 3
[   22.549536] Bluetooth: Core ver 2.15
[   22.549580] NET: Registered protocol family 31
[   22.549582] Bluetooth: HCI device and connection manager initialized
[   22.549584] Bluetooth: HCI socket layer initialized
[   22.552158] Bluetooth: Generic Bluetooth USB driver ver 0.6
[   22.558711] usbcore: registered new interface driver btusb
[   22.572358] type=1400 audit(1294399955.526:5): apparmor="STATUS"
operation="profile_replace" name="/sbin/dhclient3" pid=1126
comm="apparmor_parser"
[   22.573541] type=1400 audit(1294399955.526:6): apparmor="STATUS"
operation="profile_replace"
name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=1126
comm="apparmor_parser"
[   22.573865] type=1400 audit(1294399955.526:7): apparmor="STATUS"
operation="profile_replace"
name="/usr/lib/connman/scripts/dhclient-script" pid=1126
comm="apparmor_parser"
[   22.578752] type=1400 audit(1294399955.526:8): apparmor="STATUS"
operation="profile_load" name="/usr/share/gdm/guest-session/Xsession"
pid=1125 comm="apparmor_parser"
[   22.583421] type=1400 audit(1294399955.536:9): apparmor="STATUS"
operation="profile_load" name="/usr/bin/evince" pid=1128
comm="apparmor_parser"
[   22.598812] Adding 2097148k swap on /swap_file.  Priority:-1
extents:7 across:39526396k
[   22.599516] type=1400 audit(1294399955.546:10): apparmor="STATUS"
operation="profile_load" name="/usr/lib/cups/backend/cups-pdf"
pid=1132 comm="apparmor_parser"
[   22.600249] type=1400 audit(1294399955.556:11): apparmor="STATUS"
operation="profile_load" name="/usr/sbin/cupsd" pid=1132
comm="apparmor_parser"
[   22.749757] Bluetooth: L2CAP ver 2.14
[   22.749760] Bluetooth: L2CAP socket layer initialized
[   22.754027] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   22.754029] Bluetooth: BNEP filters: protocol multicast
[   22.757406] Bluetooth: SCO (Voice Link) ver 0.6
[   22.757408] Bluetooth: SCO socket layer initialized
[   22.838964] ppdev: user-space parallel port driver
[   22.978339] +8192cu_drv - drv_open, bup=0
[   23.022616] Bluetooth: RFCOMM TTY layer initialized
[   23.022622] Bluetooth: RFCOMM socket layer initialized
[   23.022623] Bluetooth: RFCOMM ver 1.11
[   23.060143] usb 2-4: new high speed USB device using ehci_hcd and address 6
[   23.061680]  ===> FirmwareDownload91C() fw:Rtl819XFwImageArray_TSMC
[   23.061692] fw_ver=v60, fw_subver=0, sig=0x88c0
[   23.097562] fw download ok!
[   23.097567] Set RF Chip ID to RF_6052 and RF type to 1T1R.
[   23.097571] rf_chip=0x4, rf_type=0x3
[   23.109816] reg 0x4c8, usb write TimeOut! status:-71 value=0x0
[   23.109821] usb_write8...error(-71)
[   23.113941] reg 0xf0, usb read TimeOut! status:-71 value=0x0
[   23.118065] reg 0xff, usb write TimeOut! status:-71 value=0x0
[   23.118069] usb_write8...error(-71)
[   23.122187] reg 0xf0, usb read TimeOut! status:-71 value=0x0
[   23.126440] reg 0x4c9, usb write TimeOut! status:-71 value=0x0
[   23.126444] usb_write8...error(-71)
[   23.130562] reg 0xf0, usb read TimeOut! status:-71 value=0x0
[   23.134681] reg 0x8, usb write TimeOut! status:-71 value=0x0
[   23.134683] usb_write8...error(-71)
[   23.138808] reg 0xf0, usb read TimeOut! status:-71 value=0x0
[   23.142941] reg 0x4cc, usb write TimeOut! status:-71 value=0x0
[   23.142945] usb_write8...error(-71)
[   23.147065] reg 0xf0, usb read TimeOut! status:-71 value=0x0
[   23.151189] reg 0xff, usb write TimeOut! status:-71 value=0x0
[   23.151191] usb_write8...error(-71)
[   23.155312] reg 0xf0, usb read TimeOut! status:-71 value=0x0
[   23.159442] reg 0x4cd, usb write TimeOut! status:-71 value=0x0
[   23.159446] usb_write8...error(-71)
[   23.163565] reg 0xf0, usb read TimeOut! status:-71 value=0x0
[   23.167690] reg 0xff, usb write TimeOut! status:-71 value=0x0
[   23.167694] usb_write8...error(-71)
[   23.171814] reg 0xf0, usb read TimeOut! status:-71 value=0x0
[   23.175939] reg 0x4ce, usb write TimeOut! status:-71 value=0x0
[   23.175943] usb_write8...error(-71)
[   23.180063] reg 0xf0, usb read TimeOut! status:-71 value=0x0
[   23.184189] reg 0x1, usb write TimeOut! status:-71 value=0x0
[   23.184193] usb_write8...error(-71)
[   23.188315] reg 0xf0, usb read TimeOut! status:-71 value=0x0
[   23.192437] reg 0x500, usb write TimeOut! status:-71 value=0x0
[   23.192439] usb_write8...error(-71)
[   23.196561] reg 0xf0, usb read TimeOut! status:-71 value=0x0
[   23.200689] reg 0x26, usb write TimeOut! status:-71 value=0x0
[   23.200693] usb_write8...error(-71)
[   23.204811] reg 0xf0, usb read TimeOut! status:-71 value=0x0
[   23.208937] reg 0x501, usb write TimeOut! status:-71 value=0x0
[   23.208939] usb_write8...error(-71)
[   23.211226] usb 1-2: USB disconnect, address 3
[   23.211351] +rtw_dev_remove
[   23.211356] reg 0xf0, usb read TimeOut! status:-108 value=0x0
[   23.211359] reg 0xa2, usb write TimeOut! status:-19 value=0x0
[   23.211361] usb_write8...error(-19)
[   23.211363] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.211365] reg 0x502, usb write TimeOut! status:-19 value=0x0
[   23.211367] usb_write8...error(-19)
[   23.211369] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.211371] reg 0x2f, usb write TimeOut! status:-19 value=0x0
[   23.211373] usb_write8...error(-19)
[   23.211374] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.211377] reg 0x503, usb write TimeOut! status:-19 value=0x0
[   23.211378] usb_write8...error(-19)
[   23.211380] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.211382] reg 0x0, usb write TimeOut! status:-19 value=0x0
[   23.211384] usb_write8...error(-19)
[   23.211386] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.211388] reg 0x504, usb write TimeOut! status:-19 value=0x0
[   23.211389] usb_write8...error(-19)
[   23.211391] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.211393] reg 0x28, usb write TimeOut! status:-19 value=0x0
[   23.211395] usb_write8...error(-19)
[   23.211397] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.211399] reg 0x608, usb read TimeOut! status:-19 value=0x0
[   23.211401] usb_read32...error(-19)
[   23.211403] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.211405] reg 0x608, usb write TimeOut! status:-19 value=0x0
[   23.211408] reg 0x2, usb read TimeOut! status:-19 value=0x0
[   23.211409] usb_read16...error(-19)
[   23.211411] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.211414] reg 0x2, usb write TimeOut! status:-19 value=0x2003
[   23.211416] reg 0x28, usb write TimeOut! status:-19 value=0x83
[   23.211417] usb_write8...error(-19)
[   23.211419] reg 0xf0, usb read TimeOut! status:-19 value=0x83
[   23.211421] reg 0x29, usb write TimeOut! status:-19 value=0xdb
[   23.211423] usb_write8...error(-19)
[   23.211425] reg 0xf0, usb read TimeOut! status:-19 value=0xdb
[   23.211427] reg 0x1f, usb write TimeOut! status:-19 value=0x7
[   23.211429] usb_write8...error(-19)
[   23.211430] reg 0xf0, usb read TimeOut! status:-19 value=0x7
[   23.211433] reg 0x2, usb write TimeOut! status:-19 value=0x17
[   23.211434] usb_write8...error(-19)
[   23.211436] reg 0xf0, usb read TimeOut! status:-19 value=0x17
[   23.211438] reg 0x22, usb write TimeOut! status:-19 value=0xf
[   23.211440] usb_write8...error(-19)
[   23.211442] reg 0xf0, usb read TimeOut! status:-19 value=0xf
[   23.211444] reg 0x15, usb write TimeOut! status:-19 value=0xe9
[   23.211445] usb_write8...error(-19)
[   23.211447] reg 0xf0, usb read TimeOut! status:-19 value=0xe9
[   23.211449] reg 0x25, usb write TimeOut! status:-19 value=0x80
[   23.211451] usb_write8...error(-19)
[   23.211453] reg 0xf0, usb read TimeOut! status:-19 value=0x80
[   23.211456] reg 0x24, usb write TimeOut! status:-19 value=0x0
[   23.211459] reg 0x800d, usb write TimeOut! status:-19 value=0x0
[   23.211462] reg 0x28, usb write TimeOut! status:-19 value=0x0
[   23.211466] reg 0xdb83, usb write TimeOut! status:-19 value=0x0
[   23.211469] reg 0x800, usb write TimeOut! status:-19 value=0x0
[   23.211472] reg 0x0, usb write TimeOut! status:-19 value=0x0
[   23.211475] reg 0x804, usb write TimeOut! status:-19 value=0x0
[   23.211479] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.211482] reg 0x808, usb write TimeOut! status:-19 value=0x0
[   23.211485] reg 0xfc00, usb write TimeOut! status:-19 value=0x0
[   23.211489] reg 0x80c, usb write TimeOut! status:-19 value=0x0
[   23.211492] reg 0xa, usb write TimeOut! status:-19 value=0x0
[   23.211495] reg 0x810, usb write TimeOut! status:-19 value=0x0
[   23.211499] reg 0x5388, usb write TimeOut! status:-19 value=0x0
[   23.211502] reg 0x814, usb write TimeOut! status:-19 value=0x0
[   23.211505] reg 0x3d10, usb write TimeOut! status:-19 value=0x0
[   23.211509] reg 0x818, usb write TimeOut! status:-19 value=0x0
[   23.211512] reg 0x385, usb write TimeOut! status:-19 value=0x0
[   23.211515] reg 0x81c, usb write TimeOut! status:-19 value=0x0
[   23.211518] reg 0x0, usb write TimeOut! status:-19 value=0x0
[   23.211522] reg 0x820, usb write TimeOut! status:-19 value=0x0
[   23.211525] reg 0x100, usb write TimeOut! status:-19 value=0x0
[   23.211528] reg 0x824, usb write TimeOut! status:-19 value=0x0
[   23.211532] reg 0x4, usb write TimeOut! status:-19 value=0x0
[   23.211535] reg 0x828, usb write TimeOut! status:-19 value=0x0
[   23.211538] reg 0x0, usb write TimeOut! status:-19 value=0x0
[   23.211542] reg 0x82c, usb write TimeOut! status:-19 value=0x0
[   23.211545] reg 0x0, usb write TimeOut! status:-19 value=0x0
[   23.211548] reg 0x830, usb write TimeOut! status:-19 value=0x0
[   23.211552] reg 0x0, usb write TimeOut! status:-19 value=0x0
[   23.211555] reg 0x834, usb write TimeOut! status:-19 value=0x0
[   23.211558] reg 0x0, usb write TimeOut! status:-19 value=0x0
[   23.211562] reg 0x838, usb write TimeOut! status:-19 value=0x0
[   23.211565] reg 0x0, usb write TimeOut! status:-19 value=0x0
[   23.211568] reg 0x83c, usb write TimeOut! status:-19 value=0x0
[   23.211572] reg 0x0, usb write TimeOut! status:-19 value=0x0
[   23.211575] reg 0x840, usb write TimeOut! status:-19 value=0x0
[   23.211578] reg 0x0, usb write TimeOut! status:-19 value=0x0
[   23.211581] reg 0x844, usb write TimeOut! status:-19 value=0x0
[   23.211585] reg 0x0, usb write TimeOut! status:-19 value=0x0
[   23.211588] reg 0x848, usb write TimeOut! status:-19 value=0x0
[   23.211591] reg 0x0, usb write TimeOut! status:-19 value=0x0
[   23.211595] reg 0x84c, usb write TimeOut! status:-19 value=0x0
[   23.211598] reg 0x0, usb write TimeOut! status:-19 value=0x0
[   23.211601] reg 0x850, usb write TimeOut! status:-19 value=0x0
[   23.211605] reg 0x0, usb write TimeOut! status:-19 value=0x0
[   23.211608] reg 0x854, usb write TimeOut! status:-19 value=0x0
[   23.211611] reg 0x0, usb write TimeOut! status:-19 value=0x0
[   23.211615] reg 0x858, usb write TimeOut! status:-19 value=0x0
[   23.211618] reg 0x569a, usb write TimeOut! status:-19 value=0x0
[   23.211621] reg 0x85c, usb write TimeOut! status:-19 value=0x0
[   23.211625] reg 0x25a4, usb write TimeOut! status:-19 value=0x0
[   23.211628] reg 0x860, usb write TimeOut! status:-19 value=0x0
[   23.211631] reg 0x230, usb write TimeOut! status:-19 value=0x0
[   23.211634] reg 0x864, usb write TimeOut! status:-19 value=0x0
[   23.211638] reg 0x130, usb write TimeOut! status:-19 value=0x0
[   23.211641] reg 0x868, usb write TimeOut! status:-19 value=0x0
[   23.211644] reg 0x0, usb write TimeOut! status:-19 value=0x0
[   23.211648] reg 0x86c, usb write TimeOut! status:-19 value=0x0
[   23.211651] reg 0x3200, usb write TimeOut! status:-19 value=0x0
[   23.211654] reg 0x870, usb write TimeOut! status:-19 value=0x0
[   23.211658] reg 0x700, usb write TimeOut! status:-19 value=0x0
[   23.211661] reg 0x874, usb write TimeOut! status:-19 value=0x0
[   23.211664] reg 0x4000, usb write TimeOut! status:-19 value=0x0
[   23.211668] reg 0x878, usb write TimeOut! status:-19 value=0x0
[   23.211671] reg 0x808, usb write TimeOut! status:-19 value=0x0
[   23.211674] reg 0x87c, usb write TimeOut! status:-19 value=0x0
[   23.211678] reg 0x0, usb write TimeOut! status:-19 value=0x0
[   23.211681] reg 0x880, usb write TimeOut! status:-19 value=0x0
[   23.211684] reg 0x3070, usb write TimeOut! status:-19 value=0x0
[   23.211688] reg 0x884, usb write TimeOut! status:-19 value=0x0
[   23.211691] reg 0x4d5, usb write TimeOut! status:-19 value=0x0
[   23.211694] reg 0x888, usb write TimeOut! status:-19 value=0x0
[   23.211697] reg 0x0, usb write TimeOut! status:-19 value=0x0
[   23.211701] reg 0x88c, usb write TimeOut! status:-19 value=0x0
[   23.211704] reg 0xc0, usb write TimeOut! status:-19 value=0x0
[   23.211707] reg 0x890, usb write TimeOut! status:-19 value=0x0
[   23.211711] reg 0x800, usb write TimeOut! status:-19 value=0x0
[   23.211714] reg 0x894, usb write TimeOut! status:-19 value=0x0
[   23.211717] reg 0xfffe, usb write TimeOut! status:-19 value=0x0
[   23.211721] reg 0x898, usb write TimeOut! status:-19 value=0x0
[   23.211724] reg 0x2010, usb write TimeOut! status:-19 value=0x0
[   23.211727] reg 0x89c, usb write TimeOut! status:-19 value=0x0
[   23.211731] reg 0x6050, usb write TimeOut! status:-19 value=0x0
[   23.211734] reg 0x900, usb write TimeOut! status:-19 value=0x0
[   23.211737] reg 0x0, usb write TimeOut! status:-19 value=0x0
[   23.211741] reg 0x904, usb write TimeOut! status:-19 value=0x0
[   23.211744] reg 0x23, usb write TimeOut! status:-19 value=0x0
[   23.211747] reg 0x908, usb write TimeOut! status:-19 value=0x0
[   23.211751] reg 0x0, usb write TimeOut! status:-19 value=0x0
[   23.211754] reg 0x90c, usb write TimeOut! status:-19 value=0x0
[   23.211757] reg 0x1111, usb write TimeOut! status:-19 value=0x0
[   23.211761] reg 0xa00, usb write TimeOut! status:-19 value=0x0
[   23.211764] reg 0x47c8, usb write TimeOut! status:-19 value=0x0
[   23.211767] reg 0xa04, usb write TimeOut! status:-19 value=0x0
[   23.211770] reg 0xc, usb write TimeOut! status:-19 value=0x0
[   23.211774] reg 0xa08, usb write TimeOut! status:-19 value=0x0
[   23.211777] reg 0x8300, usb write TimeOut! status:-19 value=0x0
[   23.211780] reg 0xa0c, usb write TimeOut! status:-19 value=0x0
[   23.211784] reg 0x120f, usb write TimeOut! status:-19 value=0x0
[   23.211787] reg 0xa10, usb write TimeOut! status:-19 value=0x0
[   23.211790] reg 0xbb78, usb write TimeOut! status:-19 value=0x0
[   23.211794] reg 0xa14, usb write TimeOut! status:-19 value=0x0
[   23.211797] reg 0x4028, usb write TimeOut! status:-19 value=0x0
[   23.211800] reg 0xa18, usb write TimeOut! status:-19 value=0x0
[   23.211804] reg 0x1117, usb write TimeOut! status:-19 value=0x0
[   23.211807] reg 0xa1c, usb write TimeOut! status:-19 value=0x0
[   23.211810] reg 0xf00, usb write TimeOut! status:-19 value=0x0
[   23.211814] reg 0xa20, usb write TimeOut! status:-19 value=0x0
[   23.211817] reg 0x0, usb write TimeOut! status:-19 value=0x0
[   23.211820] reg 0xa24, usb write TimeOut! status:-19 value=0x0
[   23.211824] reg 0x1317, usb write TimeOut! status:-19 value=0x0
[   23.211827] reg 0xa28, usb write TimeOut! status:-19 value=0x0
[   23.211830] reg 0x204, usb write TimeOut! status:-19 value=0x0
[   23.211834] reg 0xa2c, usb write TimeOut! status:-19 value=0x0
[   23.211837] reg 0x0, usb write TimeOut! status:-19 value=0x0
[   23.211840] reg 0xa70, usb write TimeOut! status:-19 value=0x0
[   23.211844] reg 0xbf00, usb write TimeOut! status:-19 value=0x0
[   23.211847] reg 0xa74, usb write TimeOut! status:-19 value=0x0
[   23.211850] reg 0x7, usb write TimeOut! status:-19 value=0x0
[   23.211854] reg 0xc00, usb write TimeOut! status:-19 value=0x0
[   23.211857] reg 0x1d40, usb write TimeOut! status:-19 value=0x0
[   23.211860] reg 0xc04, usb write TimeOut! status:-19 value=0x0
[   23.211864] reg 0x5611, usb write TimeOut! status:-19 value=0x0
[   23.211867] reg 0xc08, usb write TimeOut! status:-19 value=0x0
[   23.211870] reg 0xe4, usb write TimeOut! status:-19 value=0x0
[   23.211873] reg 0xc0c, usb write TimeOut! status:-19 value=0x0
[   23.211877] reg 0x6c6c, usb write TimeOut! status:-19 value=0x0
[   23.211880] reg 0xc10, usb write TimeOut! status:-19 value=0x0
[   23.211883] reg 0x0, usb write TimeOut! status:-19 value=0x0
[   23.211887] reg 0xc14, usb write TimeOut! status:-19 value=0x0
[   23.211890] reg 0x100, usb write TimeOut! status:-19 value=0x0
[   23.211893] reg 0xc18, usb write TimeOut! status:-19 value=0x0
[   23.211897] reg 0x0, usb write TimeOut! status:-19 value=0x0
[   23.211900] reg 0xc1c, usb write TimeOut! status:-19 value=0x0
[   23.211903] reg 0x100, usb write TimeOut! status:-19 value=0x0
[   23.211907] reg 0xc20, usb write TimeOut! status:-19 value=0x0
[   23.211910] reg 0x0, usb write TimeOut! status:-19 value=0x0
[   23.211913] reg 0xc24, usb write TimeOut! status:-19 value=0x0
[   23.211917] reg 0x0, usb write TimeOut! status:-19 value=0x0
[   23.211920] reg 0xc28, usb write TimeOut! status:-19 value=0x0
[   23.211923] reg 0x0, usb write TimeOut! status:-19 value=0x0
[   23.211926] reg 0xc2c, usb write TimeOut! status:-19 value=0x0
[   23.211930] reg 0x0, usb write TimeOut! status:-19 value=0x0
[   23.211933] reg 0xc30, usb write TimeOut! status:-19 value=0x0
[   23.211936] reg 0xac44, usb write TimeOut! status:-19 value=0x0
[   23.211939] reg 0xc34, usb write TimeOut! status:-19 value=0x0
[   23.211943] reg 0x52cf, usb write TimeOut! status:-19 value=0x0
[   23.211946] reg 0xc38, usb write TimeOut! status:-19 value=0x0
[   23.211949] reg 0x5994, usb write TimeOut! status:-19 value=0x0
[   23.211952] reg 0xc3c, usb write TimeOut! status:-19 value=0x0
[   23.211956] reg 0x971c, usb write TimeOut! status:-19 value=0x0
[   23.211959] reg 0xc40, usb write TimeOut! status:-19 value=0x0
[   23.211962] reg 0x403f, usb write TimeOut! status:-19 value=0x0
[   23.211965] reg 0xc44, usb write TimeOut! status:-19 value=0x0
[   23.211969] reg 0xb7, usb write TimeOut! status:-19 value=0x0
[   23.211972] reg 0xc48, usb write TimeOut! status:-19 value=0x0
[   23.211975] reg 0x107, usb write TimeOut! status:-19 value=0x0
[   23.211978] reg 0xc4c, usb write TimeOut! status:-19 value=0x0
[   23.211981] reg 0x37f, usb write TimeOut! status:-19 value=0x0
[   23.211985] reg 0xc50, usb write TimeOut! status:-19 value=0x0
[   23.211988] reg 0x341e, usb write TimeOut! status:-19 value=0x0
[   23.211991] reg 0xc54, usb write TimeOut! status:-19 value=0x0
[   23.211994] reg 0x94, usb write TimeOut! status:-19 value=0x0
[   23.211998] reg 0xc58, usb write TimeOut! status:-19 value=0x0
[   23.212001] reg 0x341e, usb write TimeOut! status:-19 value=0x0
[   23.212004] reg 0xc5c, usb write TimeOut! status:-19 value=0x0
[   23.212007] reg 0x94, usb write TimeOut! status:-19 value=0x0
[   23.212010] reg 0xc60, usb write TimeOut! status:-19 value=0x0
[   23.212014] reg 0x0, usb write TimeOut! status:-19 value=0x0
[   23.212017] reg 0xc64, usb write TimeOut! status:-19 value=0x0
[   23.212020] reg 0x848b, usb write TimeOut! status:-19 value=0x0
[   23.212023] reg 0xc68, usb write TimeOut! status:-19 value=0x0
[   23.212027] reg 0xbff, usb write TimeOut! status:-19 value=0x0
[   23.212030] reg 0xc6c, usb write TimeOut! status:-19 value=0x0
[   23.212033] reg 0x36, usb write TimeOut! status:-19 value=0x0
[   23.212036] reg 0xc70, usb write TimeOut! status:-19 value=0x0
[   23.212039] reg 0xd, usb write TimeOut! status:-19 value=0x0
[   23.212043] reg 0xc74, usb write TimeOut! status:-19 value=0x0
[   23.212046] reg 0x10db, usb write TimeOut! status:-19 value=0x0
[   23.212049] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212052] reg 0x1f, usb write TimeOut! status:-19 value=0x0
[   23.212056] reg 0xc7c, usb write TimeOut! status:-19 value=0x0
[   23.212059] reg 0x1612, usb write TimeOut! status:-19 value=0x0
[   23.212062] reg 0xc80, usb write TimeOut! status:-19 value=0x0
[   23.212065] reg 0x100, usb write TimeOut! status:-19 value=0x0
[   23.212069] reg 0xc84, usb write TimeOut! status:-19 value=0x0
[   23.212076] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212079] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212082] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212086] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212089] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212092] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212095] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212098] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212102] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212105] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212108] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212111] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212115] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212118] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212121] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212124] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212127] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212131] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212134] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212137] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212140] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212144] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212147] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212150] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212153] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212157] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212160] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212163] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212166] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212170] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212173] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212176] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212179] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212182] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212186] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212189] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212192] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212195] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212199] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212202] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212205] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212208] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212212] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212215] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212218] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212221] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212224] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212228] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212231] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212234] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212237] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212241] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212244] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212247] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212250] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212253] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212257] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212260] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212263] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212267] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212270] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212273] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212276] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212280] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212283] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212286] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212290] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212293] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212296] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212299] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212303] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212306] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212309] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212312] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212315] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212319] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212322] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212325] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212328] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212332] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212335] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212338] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212342] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212345] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212348] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212352] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212355] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212358] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212362] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212365] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212368] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212372] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212375] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212378] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212382] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212385] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212388] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212391] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212395] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212398] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212401] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212405] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212408] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212411] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212415] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212418] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212421] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212425] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212428] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212431] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212435] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212438] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212441] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212445] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212448] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212451] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212454] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212458] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212461] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212464] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212468] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212471] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212474] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212478] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212481] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212484] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212488] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212491] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212494] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212498] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212517] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212520] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212524] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212527] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212531] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212534] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212538] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212541] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212545] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212548] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212552] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212555] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212559] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212562] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212566] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212569] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212573] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212576] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212580] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212583] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212587] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212590] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212594] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212597] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212601] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212604] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212608] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212611] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212615] reg 0xc78, usb write TimeOut! status:-19 value=0x0
[   23.212618] reg 0x1, usb write TimeOut! status:-19 value=0x0
[   23.212622] reg 0x824, usb read TimeOut! status:-19 value=0x0
[   23.212623] usb_read32...error(-19)
[   23.212626] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.212628] reg 0x870, usb read TimeOut! status:-19 value=0x0
[   23.212630] usb_read32...error(-19)
[   23.212632] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.212635] reg 0x860, usb read TimeOut! status:-19 value=0x0
[   23.212636] usb_read32...error(-19)
[   23.212639] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.212641] reg 0x860, usb write TimeOut! status:-19 value=0x100000
[   23.212645] reg 0x860, usb read TimeOut! status:-19 value=0x0
[   23.212646] usb_read32...error(-19)
[   23.212649] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.212651] reg 0x860, usb write TimeOut! status:-19 value=0x10
[   23.212655] reg 0x824, usb read TimeOut! status:-19 value=0x0
[   23.212656] usb_read32...error(-19)
[   23.212658] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.212661] reg 0x824, usb write TimeOut! status:-19 value=0x0
[   23.212664] reg 0x824, usb read TimeOut! status:-19 value=0x0
[   23.212666] usb_read32...error(-19)
[   23.212668] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.212671] reg 0x824, usb write TimeOut! status:-19 value=0x0
[   23.212675] reg 0x840, usb write TimeOut! status:-19 value=0x0
[   23.212679] reg 0x840, usb write TimeOut! status:-19 value=0x1900000
[   23.212682] reg 0x840, usb write TimeOut! status:-19 value=0x100000
[   23.212686] reg 0x840, usb write TimeOut! status:-19 value=0x400000
[   23.212690] reg 0x840, usb write TimeOut! status:-19 value=0x200000
[   23.212693] reg 0x840, usb write TimeOut! status:-19 value=0x0
[   23.212697] reg 0x840, usb write TimeOut! status:-19 value=0x300000
[   23.212700] reg 0x840, usb write TimeOut! status:-19 value=0x2300000
[   23.212704] reg 0x840, usb write TimeOut! status:-19 value=0x400000
[   23.212708] reg 0x840, usb write TimeOut! status:-19 value=0x2700000
[   23.212711] reg 0x840, usb write TimeOut! status:-19 value=0x900000
[   23.212715] reg 0x840, usb write TimeOut! status:-19 value=0xf00000
[   23.212718] reg 0x840, usb write TimeOut! status:-19 value=0xa00000
[   23.212722] reg 0x840, usb write TimeOut! status:-19 value=0x3100000
[   23.212726] reg 0x840, usb write TimeOut! status:-19 value=0xb00000
[   23.212729] reg 0x840, usb write TimeOut! status:-19 value=0x2700000
[   23.212733] reg 0x840, usb write TimeOut! status:-19 value=0xc00000
[   23.212736] reg 0x840, usb write TimeOut! status:-19 value=0x2e00000
[   23.212740] reg 0x840, usb write TimeOut! status:-19 value=0xd00000
[   23.212744] reg 0x840, usb write TimeOut! status:-19 value=0x2c00000
[   23.212747] reg 0x840, usb write TimeOut! status:-19 value=0xe00000
[   23.212751] reg 0x840, usb write TimeOut! status:-19 value=0x2700000
[   23.212754] reg 0x840, usb write TimeOut! status:-19 value=0xf00000
[   23.212758] reg 0x840, usb write TimeOut! status:-19 value=0x1100000
[   23.212762] reg 0x840, usb write TimeOut! status:-19 value=0x1900000
[   23.212765] reg 0x840, usb write TimeOut! status:-19 value=0x0
[   23.212769] reg 0x840, usb write TimeOut! status:-19 value=0x1a00000
[   23.212772] reg 0x840, usb write TimeOut! status:-19 value=0x1500000
[   23.212776] reg 0x840, usb write TimeOut! status:-19 value=0x1b00000
[   23.212779] reg 0x840, usb write TimeOut! status:-19 value=0x0
[   23.212783] reg 0x840, usb write TimeOut! status:-19 value=0x1c00000
[   23.212786] reg 0x840, usb write TimeOut! status:-19 value=0x3800000
[   23.212790] reg 0x840, usb write TimeOut! status:-19 value=0x1d00000
[   23.212794] reg 0x840, usb write TimeOut! status:-19 value=0x1000000
[   23.212797] reg 0x840, usb write TimeOut! status:-19 value=0x1e00000
[   23.212801] reg 0x840, usb write TimeOut! status:-19 value=0x1f00000
[   23.212804] reg 0x840, usb write TimeOut! status:-19 value=0x1f00000
[   23.212808] reg 0x840, usb write TimeOut! status:-19 value=0x100000
[   23.212811] reg 0x840, usb write TimeOut! status:-19 value=0x2000000
[   23.212815] reg 0x840, usb write TimeOut! status:-19 value=0x1400000
[   23.212819] reg 0x840, usb write TimeOut! status:-19 value=0x2100000
[   23.212822] reg 0x840, usb write TimeOut! status:-19 value=0x0
[   23.212826] reg 0x840, usb write TimeOut! status:-19 value=0x2200000
[   23.212829] reg 0x840, usb write TimeOut! status:-19 value=0x0
[   23.212833] reg 0x840, usb write TimeOut! status:-19 value=0x2300000
[   23.212836] reg 0x840, usb write TimeOut! status:-19 value=0x1800000
[   23.212840] reg 0x840, usb write TimeOut! status:-19 value=0x2400000
[   23.212844] reg 0x840, usb write TimeOut! status:-19 value=0x2000000
[   23.212847] reg 0x840, usb write TimeOut! status:-19 value=0x2500000
[   23.212851] reg 0x840, usb write TimeOut! status:-19 value=0x300000
[   23.212854] reg 0x840, usb write TimeOut! status:-19 value=0x2600000
[   23.212858] reg 0x840, usb write TimeOut! status:-19 value=0x0
[   23.212861] reg 0x840, usb write TimeOut! status:-19 value=0x2700000
[   23.212864] reg 0x840, usb write TimeOut! status:-19 value=0x1900000
[   23.212868] reg 0x840, usb write TimeOut! status:-19 value=0x2800000
[   23.212871] reg 0x840, usb write TimeOut! status:-19 value=0x0
[   23.212874] reg 0x840, usb write TimeOut! status:-19 value=0x2900000
[   23.212878] reg 0x840, usb write TimeOut! status:-19 value=0x300000
[   23.212881] reg 0x840, usb write TimeOut! status:-19 value=0x2a00000
[   23.212884] reg 0x840, usb write TimeOut! status:-19 value=0x100000
[   23.212888] reg 0x840, usb write TimeOut! status:-19 value=0x2b00000
[   23.212891] reg 0x840, usb write TimeOut! status:-19 value=0x3400000
[   23.212894] reg 0x840, usb write TimeOut! status:-19 value=0x2a00000
[   23.212897] reg 0x840, usb write TimeOut! status:-19 value=0x0
[   23.212901] reg 0x840, usb write TimeOut! status:-19 value=0x2b00000
[   23.212904] reg 0x840, usb write TimeOut! status:-19 value=0x1400000
[   23.212907] reg 0x840, usb write TimeOut! status:-19 value=0x2a00000
[   23.212911] reg 0x840, usb write TimeOut! status:-19 value=0x100000
[   23.212914] reg 0x840, usb write TimeOut! status:-19 value=0x2b00000
[   23.212917] reg 0x840, usb write TimeOut! status:-19 value=0x800000
[   23.212921] reg 0x840, usb write TimeOut! status:-19 value=0x2b00000
[   23.212924] reg 0x840, usb write TimeOut! status:-19 value=0x3300000
[   23.212928] reg 0x840, usb write TimeOut! status:-19 value=0x2c00000
[   23.212931] reg 0x840, usb write TimeOut! status:-19 value=0xc00000
[   23.212934] reg 0x840, usb write TimeOut! status:-19 value=0x2a00000
[   23.212938] reg 0x840, usb write TimeOut! status:-19 value=0x200000
[   23.212941] reg 0x840, usb write TimeOut! status:-19 value=0x2b00000
[   23.212944] reg 0x840, usb write TimeOut! status:-19 value=0x800000
[   23.212948] reg 0x840, usb write TimeOut! status:-19 value=0x2b00000
[   23.212951] reg 0x840, usb write TimeOut! status:-19 value=0x3300000
[   23.212954] reg 0x840, usb write TimeOut! status:-19 value=0x2c00000
[   23.212958] reg 0x840, usb write TimeOut! status:-19 value=0xd00000
[   23.212961] reg 0x840, usb write TimeOut! status:-19 value=0x2a00000
[   23.212964] reg 0x840, usb write TimeOut! status:-19 value=0x300000
[   23.212967] reg 0x840, usb write TimeOut! status:-19 value=0x2b00000
[   23.212971] reg 0x840, usb write TimeOut! status:-19 value=0x800000
[   23.212974] reg 0x840, usb write TimeOut! status:-19 value=0x2b00000
[   23.212978] reg 0x840, usb write TimeOut! status:-19 value=0x3300000
[   23.212981] reg 0x840, usb write TimeOut! status:-19 value=0x2c00000
[   23.212984] reg 0x840, usb write TimeOut! status:-19 value=0xd00000
[   23.212988] reg 0x840, usb write TimeOut! status:-19 value=0x2a00000
[   23.212991] reg 0x840, usb write TimeOut! status:-19 value=0x400000
[   23.212994] reg 0x840, usb write TimeOut! status:-19 value=0x2b00000
[   23.212997] reg 0x840, usb write TimeOut! status:-19 value=0x800000
[   23.213001] reg 0x840, usb write TimeOut! status:-19 value=0x2b00000
[   23.213004] reg 0x840, usb write TimeOut! status:-19 value=0x3300000
[   23.213007] reg 0x840, usb write TimeOut! status:-19 value=0x2c00000
[   23.213011] reg 0x840, usb write TimeOut! status:-19 value=0xd00000
[   23.213014] reg 0x840, usb write TimeOut! status:-19 value=0x2a00000
[   23.213017] reg 0x840, usb write TimeOut! status:-19 value=0x500000
[   23.213021] reg 0x840, usb write TimeOut! status:-19 value=0x2b00000
[   23.213024] reg 0x840, usb write TimeOut! status:-19 value=0x800000
[   23.213027] reg 0x840, usb write TimeOut! status:-19 value=0x2b00000
[   23.213031] reg 0x840, usb write TimeOut! status:-19 value=0x3300000
[   23.213034] reg 0x840, usb write TimeOut! status:-19 value=0x2c00000
[   23.213037] reg 0x840, usb write TimeOut! status:-19 value=0xd00000
[   23.213041] reg 0x840, usb write TimeOut! status:-19 value=0x2a00000
[   23.213044] reg 0x840, usb write TimeOut! status:-19 value=0x600000
[   23.213047] reg 0x840, usb write TimeOut! status:-19 value=0x2b00000
[   23.213051] reg 0x840, usb write TimeOut! status:-19 value=0x900000
[   23.213054] reg 0x840, usb write TimeOut! status:-19 value=0x2b00000
[   23.213057] reg 0x840, usb write TimeOut! status:-19 value=0x3300000
[   23.213061] reg 0x840, usb write TimeOut! status:-19 value=0x2c00000
[   23.213064] reg 0x840, usb write TimeOut! status:-19 value=0xd00000
[   23.213067] reg 0x840, usb write TimeOut! status:-19 value=0x2a00000
[   23.213071] reg 0x840, usb write TimeOut! status:-19 value=0x700000
[   23.213074] reg 0x840, usb write TimeOut! status:-19 value=0x2b00000
[   23.213077] reg 0x840, usb write TimeOut! status:-19 value=0x900000
[   23.213081] reg 0x840, usb write TimeOut! status:-19 value=0x2b00000
[   23.213084] reg 0x840, usb write TimeOut! status:-19 value=0x3300000
[   23.213087] reg 0x840, usb write TimeOut! status:-19 value=0x2c00000
[   23.213091] reg 0x840, usb write TimeOut! status:-19 value=0xd00000
[   23.213094] reg 0x840, usb write TimeOut! status:-19 value=0x2a00000
[   23.213097] reg 0x840, usb write TimeOut! status:-19 value=0x800000
[   23.213101] reg 0x840, usb write TimeOut! status:-19 value=0x2b00000
[   23.213104] reg 0x840, usb write TimeOut! status:-19 value=0xa00000
[   23.213107] reg 0x840, usb write TimeOut! status:-19 value=0x2b00000
[   23.213111] reg 0x840, usb write TimeOut! status:-19 value=0x3300000
[   23.213114] reg 0x840, usb write TimeOut! status:-19 value=0x2c00000
[   23.213117] reg 0x840, usb write TimeOut! status:-19 value=0xd00000
[   23.213121] reg 0x840, usb write TimeOut! status:-19 value=0x2a00000
[   23.213124] reg 0x840, usb write TimeOut! status:-19 value=0x900000
[   23.213127] reg 0x840, usb write TimeOut! status:-19 value=0x2b00000
[   23.213131] reg 0x840, usb write TimeOut! status:-19 value=0xa00000
[   23.213134] reg 0x840, usb write TimeOut! status:-19 value=0x2b00000
[   23.213137] reg 0x840, usb write TimeOut! status:-19 value=0x3300000
[   23.213141] reg 0x840, usb write TimeOut! status:-19 value=0x2c00000
[   23.213144] reg 0x840, usb write TimeOut! status:-19 value=0xd00000
[   23.213148] reg 0x840, usb write TimeOut! status:-19 value=0x2a00000
[   23.213151] reg 0x840, usb write TimeOut! status:-19 value=0xa00000
[   23.213155] reg 0x840, usb write TimeOut! status:-19 value=0x2b00000
[   23.213158] reg 0x870, usb read TimeOut! status:-19 value=0x0
[   23.213160] usb_read32...error(-19)
[   23.213162] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.213165] reg 0x870, usb write TimeOut! status:-19 value=0x0
[   23.213167] reg 0x824, usb read TimeOut! status:-19 value=0x0
[   23.213169] usb_read32...error(-19)
[   23.213171] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.213174] reg 0x824, usb write TimeOut! status:-19 value=0x0
[   23.214175] reg 0x824, usb write TimeOut! status:-19 value=0x8c000000
[   23.215175] reg 0x824, usb write TimeOut! status:-19 value=0x80000000
[   23.216176] reg 0x820, usb read TimeOut! status:-19 value=0x0
[   23.216178] usb_read32...error(-19)
[   23.216179] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.216182] reg 0x8a0, usb read TimeOut! status:-19 value=0x0
[   23.216183] usb_read32...error(-19)
[   23.216185] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.216187] reg 0x824, usb read TimeOut! status:-19 value=0x0
[   23.216189] usb_read32...error(-19)
[   23.216190] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.216193] reg 0x82c, usb read TimeOut! status:-19 value=0x0
[   23.216194] usb_read32...error(-19)
[   23.216196] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.216198] reg 0x824, usb write TimeOut! status:-19 value=0x0
[   23.218011] reg 0x82c, usb write TimeOut! status:-19 value=0x8c000000
[   23.219013] reg 0x824, usb write TimeOut! status:-19 value=0x80000000
[   23.220014] reg 0x828, usb read TimeOut! status:-19 value=0x0
[   23.220016] usb_read32...error(-19)
[   23.220018] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.220020] reg 0x8a4, usb read TimeOut! status:-19 value=0x0
[   23.220021] usb_read32...error(-19)
[   23.220023] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.220026] reg 0x800, usb read TimeOut! status:-19 value=0x0
[   23.220027] usb_read32...error(-19)
[   23.220029] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.220031] reg 0x800, usb write TimeOut! status:-19 value=0x1000000
[   23.220034] reg 0x800, usb read TimeOut! status:-19 value=0x0
[   23.220035] usb_read32...error(-19)
[   23.220037] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.220039] reg 0x800, usb write TimeOut! status:-19 value=0x2000000
[   23.220042] reg 0x674, usb write TimeOut! status:-19 value=0x8010
[   23.220044] reg 0x670, usb write TimeOut! status:-19 value=0x80010000
[   23.220046] reg 0x674, usb write TimeOut! status:-19 value=0x8011
[   23.220049] reg 0x670, usb write TimeOut! status:-19 value=0x80010008
[   23.220051] reg 0x674, usb write TimeOut! status:-19 value=0x8012
[   23.220053] reg 0x670, usb write TimeOut! status:-19 value=0x80010010
[   23.220055] reg 0x674, usb write TimeOut! status:-19 value=0x8013
[   23.220058] reg 0x670, usb write TimeOut! status:-19 value=0x80010018
[   23.220060] reg 0x674, usb write TimeOut! status:-19 value=0x8010
[   23.220062] reg 0x670, usb write TimeOut! status:-19 value=0x80010020
[   23.220064] reg 0x674, usb write TimeOut! status:-19 value=0x8011
[   23.220067] reg 0x670, usb write TimeOut! status:-19 value=0x80010028
[   23.220069] reg 0x674, usb write TimeOut! status:-19 value=0x8012
[   23.220071] reg 0x670, usb write TimeOut! status:-19 value=0x80010030
[   23.220073] reg 0x674, usb write TimeOut! status:-19 value=0x8013
[   23.220075] reg 0x670, usb write TimeOut! status:-19 value=0x80010038
[   23.220078] reg 0x674, usb write TimeOut! status:-19 value=0x8010
[   23.220080] reg 0x670, usb write TimeOut! status:-19 value=0x80010040
[   23.220082] reg 0x674, usb write TimeOut! status:-19 value=0x8011
[   23.220084] reg 0x670, usb write TimeOut! status:-19 value=0x80010048
[   23.220086] reg 0x674, usb write TimeOut! status:-19 value=0x8012
[   23.220089] reg 0x670, usb write TimeOut! status:-19 value=0x80010050
[   23.220091] reg 0x674, usb write TimeOut! status:-19 value=0x8013
[   23.220093] reg 0x670, usb write TimeOut! status:-19 value=0x80010058
[   23.220095] reg 0x674, usb write TimeOut! status:-19 value=0x8010
[   23.220097] reg 0x670, usb write TimeOut! status:-19 value=0x80010060
[   23.220100] reg 0x674, usb write TimeOut! status:-19 value=0x8011
[   23.220102] reg 0x670, usb write TimeOut! status:-19 value=0x80010068
[   23.220104] reg 0x674, usb write TimeOut! status:-19 value=0x8012
[   23.220106] reg 0x670, usb write TimeOut! status:-19 value=0x80010070
[   23.220109] reg 0x674, usb write TimeOut! status:-19 value=0x8013
[   23.220111] reg 0x670, usb write TimeOut! status:-19 value=0x80010078
[   23.220113] reg 0x674, usb write TimeOut! status:-19 value=0x8010
[   23.220115] reg 0x670, usb write TimeOut! status:-19 value=0x80010080
[   23.220118] reg 0x674, usb write TimeOut! status:-19 value=0x8011
[   23.220120] reg 0x670, usb write TimeOut! status:-19 value=0x80010088
[   23.220122] reg 0x674, usb write TimeOut! status:-19 value=0x8012
[   23.220124] reg 0x670, usb write TimeOut! status:-19 value=0x80010090
[   23.220126] reg 0x674, usb write TimeOut! status:-19 value=0x8013
[   23.220128] reg 0x670, usb write TimeOut! status:-19 value=0x80010098
[   23.220131] reg 0x674, usb write TimeOut! status:-19 value=0x8010
[   23.220133] reg 0x670, usb write TimeOut! status:-19 value=0x800100a0
[   23.220135] reg 0x674, usb write TimeOut! status:-19 value=0x8011
[   23.220137] reg 0x670, usb write TimeOut! status:-19 value=0x800100a8
[   23.220140] reg 0x674, usb write TimeOut! status:-19 value=0x8012
[   23.220142] reg 0x670, usb write TimeOut! status:-19 value=0x800100b0
[   23.220144] reg 0x674, usb write TimeOut! status:-19 value=0x8013
[   23.220146] reg 0x670, usb write TimeOut! status:-19 value=0x800100b8
[   23.220148] reg 0x674, usb write TimeOut! status:-19 value=0x8010
[   23.220151] reg 0x670, usb write TimeOut! status:-19 value=0x800100c0
[   23.220153] reg 0x674, usb write TimeOut! status:-19 value=0x8011
[   23.220155] reg 0x670, usb write TimeOut! status:-19 value=0x800100c8
[   23.220157] reg 0x674, usb write TimeOut! status:-19 value=0x8012
[   23.220160] reg 0x670, usb write TimeOut! status:-19 value=0x800100d0
[   23.220162] reg 0x674, usb write TimeOut! status:-19 value=0x8013
[   23.220164] reg 0x670, usb write TimeOut! status:-19 value=0x800100d8
[   23.220166] reg 0x674, usb write TimeOut! status:-19 value=0x8010
[   23.220168] reg 0x670, usb write TimeOut! status:-19 value=0x800100e0
[   23.220171] reg 0x674, usb write TimeOut! status:-19 value=0x8011
[   23.220173] reg 0x670, usb write TimeOut! status:-19 value=0x800100e8
[   23.220175] reg 0x674, usb write TimeOut! status:-19 value=0x8012
[   23.220177] reg 0x670, usb write TimeOut! status:-19 value=0x800100f0
[   23.220179] reg 0x674, usb write TimeOut! status:-19 value=0x8013
[   23.220182] reg 0x670, usb write TimeOut! status:-19 value=0x800100f8
[   23.220184] reg 0x674, usb write TimeOut! status:-19 value=0x8010
[   23.220186] reg 0x670, usb write TimeOut! status:-19 value=0x80010000
[   23.220188] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220191] reg 0x670, usb write TimeOut! status:-19 value=0x80010001
[   23.220193] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220195] reg 0x670, usb write TimeOut! status:-19 value=0x80010002
[   23.220198] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220200] reg 0x670, usb write TimeOut! status:-19 value=0x80010003
[   23.220202] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220204] reg 0x670, usb write TimeOut! status:-19 value=0x80010004
[   23.220207] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220209] reg 0x670, usb write TimeOut! status:-19 value=0x80010005
[   23.220211] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220214] reg 0x670, usb write TimeOut! status:-19 value=0x80010006
[   23.220216] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220218] reg 0x670, usb write TimeOut! status:-19 value=0x80010007
[   23.220220] reg 0x674, usb write TimeOut! status:-19 value=0x8011
[   23.220223] reg 0x670, usb write TimeOut! status:-19 value=0x80010008
[   23.220225] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220227] reg 0x670, usb write TimeOut! status:-19 value=0x80010009
[   23.220230] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220232] reg 0x670, usb write TimeOut! status:-19 value=0x8001000a
[   23.220234] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220236] reg 0x670, usb write TimeOut! status:-19 value=0x8001000b
[   23.220239] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220241] reg 0x670, usb write TimeOut! status:-19 value=0x8001000c
[   23.220243] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220245] reg 0x670, usb write TimeOut! status:-19 value=0x8001000d
[   23.220248] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220250] reg 0x670, usb write TimeOut! status:-19 value=0x8001000e
[   23.220252] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220255] reg 0x670, usb write TimeOut! status:-19 value=0x8001000f
[   23.220257] reg 0x674, usb write TimeOut! status:-19 value=0x8012
[   23.220259] reg 0x670, usb write TimeOut! status:-19 value=0x80010010
[   23.220262] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220264] reg 0x670, usb write TimeOut! status:-19 value=0x80010011
[   23.220266] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220268] reg 0x670, usb write TimeOut! status:-19 value=0x80010012
[   23.220271] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220273] reg 0x670, usb write TimeOut! status:-19 value=0x80010013
[   23.220275] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220278] reg 0x670, usb write TimeOut! status:-19 value=0x80010014
[   23.220280] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220282] reg 0x670, usb write TimeOut! status:-19 value=0x80010015
[   23.220284] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220287] reg 0x670, usb write TimeOut! status:-19 value=0x80010016
[   23.220289] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220291] reg 0x670, usb write TimeOut! status:-19 value=0x80010017
[   23.220293] reg 0x674, usb write TimeOut! status:-19 value=0x8013
[   23.220296] reg 0x670, usb write TimeOut! status:-19 value=0x80010018
[   23.220298] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220300] reg 0x670, usb write TimeOut! status:-19 value=0x80010019
[   23.220303] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220305] reg 0x670, usb write TimeOut! status:-19 value=0x8001001a
[   23.220307] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220309] reg 0x670, usb write TimeOut! status:-19 value=0x8001001b
[   23.220311] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220314] reg 0x670, usb write TimeOut! status:-19 value=0x8001001c
[   23.220316] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220318] reg 0x670, usb write TimeOut! status:-19 value=0x8001001d
[   23.220320] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220322] reg 0x670, usb write TimeOut! status:-19 value=0x8001001e
[   23.220325] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220327] reg 0x670, usb write TimeOut! status:-19 value=0x8001001f
[   23.220329] reg 0x674, usb write TimeOut! status:-19 value=0x8010
[   23.220331] reg 0x670, usb write TimeOut! status:-19 value=0x80010020
[   23.220333] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220335] reg 0x670, usb write TimeOut! status:-19 value=0x80010021
[   23.220338] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220340] reg 0x670, usb write TimeOut! status:-19 value=0x80010022
[   23.220342] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220344] reg 0x670, usb write TimeOut! status:-19 value=0x80010023
[   23.220346] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220348] reg 0x670, usb write TimeOut! status:-19 value=0x80010024
[   23.220351] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220353] reg 0x670, usb write TimeOut! status:-19 value=0x80010025
[   23.220355] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220357] reg 0x670, usb write TimeOut! status:-19 value=0x80010026
[   23.220359] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220361] reg 0x670, usb write TimeOut! status:-19 value=0x80010027
[   23.220364] reg 0x674, usb write TimeOut! status:-19 value=0x8011
[   23.220366] reg 0x670, usb write TimeOut! status:-19 value=0x80010028
[   23.220368] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220370] reg 0x670, usb write TimeOut! status:-19 value=0x80010029
[   23.220372] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220375] reg 0x670, usb write TimeOut! status:-19 value=0x8001002a
[   23.220377] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220379] reg 0x670, usb write TimeOut! status:-19 value=0x8001002b
[   23.220381] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220383] reg 0x670, usb write TimeOut! status:-19 value=0x8001002c
[   23.220385] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220388] reg 0x670, usb write TimeOut! status:-19 value=0x8001002d
[   23.220390] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220392] reg 0x670, usb write TimeOut! status:-19 value=0x8001002e
[   23.220394] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220396] reg 0x670, usb write TimeOut! status:-19 value=0x8001002f
[   23.220399] reg 0x674, usb write TimeOut! status:-19 value=0x8012
[   23.220401] reg 0x670, usb write TimeOut! status:-19 value=0x80010030
[   23.220403] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220405] reg 0x670, usb write TimeOut! status:-19 value=0x80010031
[   23.220408] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220410] reg 0x670, usb write TimeOut! status:-19 value=0x80010032
[   23.220412] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220414] reg 0x670, usb write TimeOut! status:-19 value=0x80010033
[   23.220416] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220418] reg 0x670, usb write TimeOut! status:-19 value=0x80010034
[   23.220421] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220423] reg 0x670, usb write TimeOut! status:-19 value=0x80010035
[   23.220425] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220427] reg 0x670, usb write TimeOut! status:-19 value=0x80010036
[   23.220429] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220431] reg 0x670, usb write TimeOut! status:-19 value=0x80010037
[   23.220434] reg 0x674, usb write TimeOut! status:-19 value=0x8013
[   23.220436] reg 0x670, usb write TimeOut! status:-19 value=0x80010038
[   23.220438] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220440] reg 0x670, usb write TimeOut! status:-19 value=0x80010039
[   23.220443] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220445] reg 0x670, usb write TimeOut! status:-19 value=0x8001003a
[   23.220447] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220449] reg 0x670, usb write TimeOut! status:-19 value=0x8001003b
[   23.220451] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220453] reg 0x670, usb write TimeOut! status:-19 value=0x8001003c
[   23.220456] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220458] reg 0x670, usb write TimeOut! status:-19 value=0x8001003d
[   23.220460] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220462] reg 0x670, usb write TimeOut! status:-19 value=0x8001003e
[   23.220464] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220467] reg 0x670, usb write TimeOut! status:-19 value=0x8001003f
[   23.220469] reg 0x674, usb write TimeOut! status:-19 value=0x8010
[   23.220471] reg 0x670, usb write TimeOut! status:-19 value=0x80010040
[   23.220473] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220475] reg 0x670, usb write TimeOut! status:-19 value=0x80010041
[   23.220478] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220480] reg 0x670, usb write TimeOut! status:-19 value=0x80010042
[   23.220482] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220484] reg 0x670, usb write TimeOut! status:-19 value=0x80010043
[   23.220486] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220488] reg 0x670, usb write TimeOut! status:-19 value=0x80010044
[   23.220491] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220493] reg 0x670, usb write TimeOut! status:-19 value=0x80010045
[   23.220495] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220497] reg 0x670, usb write TimeOut! status:-19 value=0x80010046
[   23.220499] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220501] reg 0x670, usb write TimeOut! status:-19 value=0x80010047
[   23.220504] reg 0x674, usb write TimeOut! status:-19 value=0x8011
[   23.220506] reg 0x670, usb write TimeOut! status:-19 value=0x80010048
[   23.220508] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220510] reg 0x670, usb write TimeOut! status:-19 value=0x80010049
[   23.220513] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220515] reg 0x670, usb write TimeOut! status:-19 value=0x8001004a
[   23.220517] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220519] reg 0x670, usb write TimeOut! status:-19 value=0x8001004b
[   23.220521] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220523] reg 0x670, usb write TimeOut! status:-19 value=0x8001004c
[   23.220526] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220528] reg 0x670, usb write TimeOut! status:-19 value=0x8001004d
[   23.220530] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220532] reg 0x670, usb write TimeOut! status:-19 value=0x8001004e
[   23.220534] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220537] reg 0x670, usb write TimeOut! status:-19 value=0x8001004f
[   23.220539] reg 0x674, usb write TimeOut! status:-19 value=0x8012
[   23.220541] reg 0x670, usb write TimeOut! status:-19 value=0x80010050
[   23.220543] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220545] reg 0x670, usb write TimeOut! status:-19 value=0x80010051
[   23.220547] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220550] reg 0x670, usb write TimeOut! status:-19 value=0x80010052
[   23.220552] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220554] reg 0x670, usb write TimeOut! status:-19 value=0x80010053
[   23.220556] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220558] reg 0x670, usb write TimeOut! status:-19 value=0x80010054
[   23.220561] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220563] reg 0x670, usb write TimeOut! status:-19 value=0x80010055
[   23.220565] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220567] reg 0x670, usb write TimeOut! status:-19 value=0x80010056
[   23.220569] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220572] reg 0x670, usb write TimeOut! status:-19 value=0x80010057
[   23.220574] reg 0x674, usb write TimeOut! status:-19 value=0x8013
[   23.220576] reg 0x670, usb write TimeOut! status:-19 value=0x80010058
[   23.220578] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220581] reg 0x670, usb write TimeOut! status:-19 value=0x80010059
[   23.220583] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220585] reg 0x670, usb write TimeOut! status:-19 value=0x8001005a
[   23.220587] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220589] reg 0x670, usb write TimeOut! status:-19 value=0x8001005b
[   23.220591] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220594] reg 0x670, usb write TimeOut! status:-19 value=0x8001005c
[   23.220596] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220598] reg 0x670, usb write TimeOut! status:-19 value=0x8001005d
[   23.220600] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220602] reg 0x670, usb write TimeOut! status:-19 value=0x8001005e
[   23.220605] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220607] reg 0x670, usb write TimeOut! status:-19 value=0x8001005f
[   23.220609] reg 0x674, usb write TimeOut! status:-19 value=0x8010
[   23.220611] reg 0x670, usb write TimeOut! status:-19 value=0x80010060
[   23.220613] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220616] reg 0x670, usb write TimeOut! status:-19 value=0x80010061
[   23.220618] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220620] reg 0x670, usb write TimeOut! status:-19 value=0x80010062
[   23.220622] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220625] reg 0x670, usb write TimeOut! status:-19 value=0x80010063
[   23.220627] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220629] reg 0x670, usb write TimeOut! status:-19 value=0x80010064
[   23.220631] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220633] reg 0x670, usb write TimeOut! status:-19 value=0x80010065
[   23.220635] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220638] reg 0x670, usb write TimeOut! status:-19 value=0x80010066
[   23.220640] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220642] reg 0x670, usb write TimeOut! status:-19 value=0x80010067
[   23.220644] reg 0x674, usb write TimeOut! status:-19 value=0x8011
[   23.220647] reg 0x670, usb write TimeOut! status:-19 value=0x80010068
[   23.220649] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220651] reg 0x670, usb write TimeOut! status:-19 value=0x80010069
[   23.220653] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220656] reg 0x670, usb write TimeOut! status:-19 value=0x8001006a
[   23.220658] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220660] reg 0x670, usb write TimeOut! status:-19 value=0x8001006b
[   23.220662] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220664] reg 0x670, usb write TimeOut! status:-19 value=0x8001006c
[   23.220666] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220669] reg 0x670, usb write TimeOut! status:-19 value=0x8001006d
[   23.220671] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220673] reg 0x670, usb write TimeOut! status:-19 value=0x8001006e
[   23.220675] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220677] reg 0x670, usb write TimeOut! status:-19 value=0x8001006f
[   23.220679] reg 0x674, usb write TimeOut! status:-19 value=0x8012
[   23.220682] reg 0x670, usb write TimeOut! status:-19 value=0x80010070
[   23.220684] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220686] reg 0x670, usb write TimeOut! status:-19 value=0x80010071
[   23.220688] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220691] reg 0x670, usb write TimeOut! status:-19 value=0x80010072
[   23.220693] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220695] reg 0x670, usb write TimeOut! status:-19 value=0x80010073
[   23.220697] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220699] reg 0x670, usb write TimeOut! status:-19 value=0x80010074
[   23.220702] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220704] reg 0x670, usb write TimeOut! status:-19 value=0x80010075
[   23.220706] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220708] reg 0x670, usb write TimeOut! status:-19 value=0x80010076
[   23.220710] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220712] reg 0x670, usb write TimeOut! status:-19 value=0x80010077
[   23.220715] reg 0x674, usb write TimeOut! status:-19 value=0x8013
[   23.220717] reg 0x670, usb write TimeOut! status:-19 value=0x80010078
[   23.220719] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220721] reg 0x670, usb write TimeOut! status:-19 value=0x80010079
[   23.220723] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220726] reg 0x670, usb write TimeOut! status:-19 value=0x8001007a
[   23.220728] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220730] reg 0x670, usb write TimeOut! status:-19 value=0x8001007b
[   23.220732] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220735] reg 0x670, usb write TimeOut! status:-19 value=0x8001007c
[   23.220737] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220739] reg 0x670, usb write TimeOut! status:-19 value=0x8001007d
[   23.220741] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220743] reg 0x670, usb write TimeOut! status:-19 value=0x8001007e
[   23.220745] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220748] reg 0x670, usb write TimeOut! status:-19 value=0x8001007f
[   23.220750] reg 0x674, usb write TimeOut! status:-19 value=0x8010
[   23.220752] reg 0x670, usb write TimeOut! status:-19 value=0x80010080
[   23.220754] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220756] reg 0x670, usb write TimeOut! status:-19 value=0x80010081
[   23.220759] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220761] reg 0x670, usb write TimeOut! status:-19 value=0x80010082
[   23.220763] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220765] reg 0x670, usb write TimeOut! status:-19 value=0x80010083
[   23.220768] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220770] reg 0x670, usb write TimeOut! status:-19 value=0x80010084
[   23.220772] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220774] reg 0x670, usb write TimeOut! status:-19 value=0x80010085
[   23.220776] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220779] reg 0x670, usb write TimeOut! status:-19 value=0x80010086
[   23.220781] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220783] reg 0x670, usb write TimeOut! status:-19 value=0x80010087
[   23.220785] reg 0x674, usb write TimeOut! status:-19 value=0x8011
[   23.220787] reg 0x670, usb write TimeOut! status:-19 value=0x80010088
[   23.220789] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220792] reg 0x670, usb write TimeOut! status:-19 value=0x80010089
[   23.220794] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220796] reg 0x670, usb write TimeOut! status:-19 value=0x8001008a
[   23.220798] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220800] reg 0x670, usb write TimeOut! status:-19 value=0x8001008b
[   23.220803] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220805] reg 0x670, usb write TimeOut! status:-19 value=0x8001008c
[   23.220807] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220809] reg 0x670, usb write TimeOut! status:-19 value=0x8001008d
[   23.220811] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220814] reg 0x670, usb write TimeOut! status:-19 value=0x8001008e
[   23.220816] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220818] reg 0x670, usb write TimeOut! status:-19 value=0x8001008f
[   23.220820] reg 0x674, usb write TimeOut! status:-19 value=0x8012
[   23.220822] reg 0x670, usb write TimeOut! status:-19 value=0x80010090
[   23.220825] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220827] reg 0x670, usb write TimeOut! status:-19 value=0x80010091
[   23.220829] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220831] reg 0x670, usb write TimeOut! status:-19 value=0x80010092
[   23.220833] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220836] reg 0x670, usb write TimeOut! status:-19 value=0x80010093
[   23.220838] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220840] reg 0x670, usb write TimeOut! status:-19 value=0x80010094
[   23.220842] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220844] reg 0x670, usb write TimeOut! status:-19 value=0x80010095
[   23.220847] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220849] reg 0x670, usb write TimeOut! status:-19 value=0x80010096
[   23.220851] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220853] reg 0x670, usb write TimeOut! status:-19 value=0x80010097
[   23.220855] reg 0x674, usb write TimeOut! status:-19 value=0x8013
[   23.220857] reg 0x670, usb write TimeOut! status:-19 value=0x80010098
[   23.220860] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220862] reg 0x670, usb write TimeOut! status:-19 value=0x80010099
[   23.220864] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220866] reg 0x670, usb write TimeOut! status:-19 value=0x8001009a
[   23.220868] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220871] reg 0x670, usb write TimeOut! status:-19 value=0x8001009b
[   23.220873] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220875] reg 0x670, usb write TimeOut! status:-19 value=0x8001009c
[   23.220877] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220879] reg 0x670, usb write TimeOut! status:-19 value=0x8001009d
[   23.220881] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220884] reg 0x670, usb write TimeOut! status:-19 value=0x8001009e
[   23.220886] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220888] reg 0x670, usb write TimeOut! status:-19 value=0x8001009f
[   23.220890] reg 0x674, usb write TimeOut! status:-19 value=0x8010
[   23.220893] reg 0x670, usb write TimeOut! status:-19 value=0x800100a0
[   23.220895] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220897] reg 0x670, usb write TimeOut! status:-19 value=0x800100a1
[   23.220899] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220901] reg 0x670, usb write TimeOut! status:-19 value=0x800100a2
[   23.220903] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220906] reg 0x670, usb write TimeOut! status:-19 value=0x800100a3
[   23.220908] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220910] reg 0x670, usb write TimeOut! status:-19 value=0x800100a4
[   23.220912] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220914] reg 0x670, usb write TimeOut! status:-19 value=0x800100a5
[   23.220916] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220919] reg 0x670, usb write TimeOut! status:-19 value=0x800100a6
[   23.220921] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220935] reg 0x670, usb write TimeOut! status:-19 value=0x800100a7
[   23.220935] reg 0x674, usb write TimeOut! status:-19 value=0x8011
[   23.220935] reg 0x670, usb write TimeOut! status:-19 value=0x800100a8
[   23.220935] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220935] reg 0x670, usb write TimeOut! status:-19 value=0x800100a9
[   23.220935] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220937] reg 0x670, usb write TimeOut! status:-19 value=0x800100aa
[   23.220939] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220941] reg 0x670, usb write TimeOut! status:-19 value=0x800100ab
[   23.220943] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220946] reg 0x670, usb write TimeOut! status:-19 value=0x800100ac
[   23.220948] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220950] reg 0x670, usb write TimeOut! status:-19 value=0x800100ad
[   23.220952] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220955] reg 0x670, usb write TimeOut! status:-19 value=0x800100ae
[   23.220957] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220959] reg 0x670, usb write TimeOut! status:-19 value=0x800100af
[   23.220961] reg 0x674, usb write TimeOut! status:-19 value=0x8012
[   23.220963] reg 0x670, usb write TimeOut! status:-19 value=0x800100b0
[   23.220966] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220968] reg 0x670, usb write TimeOut! status:-19 value=0x800100b1
[   23.220970] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220972] reg 0x670, usb write TimeOut! status:-19 value=0x800100b2
[   23.220974] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220977] reg 0x670, usb write TimeOut! status:-19 value=0x800100b3
[   23.220979] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220981] reg 0x670, usb write TimeOut! status:-19 value=0x800100b4
[   23.220983] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220985] reg 0x670, usb write TimeOut! status:-19 value=0x800100b5
[   23.220987] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220990] reg 0x670, usb write TimeOut! status:-19 value=0x800100b6
[   23.220992] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.220994] reg 0x670, usb write TimeOut! status:-19 value=0x800100b7
[   23.220996] reg 0x674, usb write TimeOut! status:-19 value=0x8013
[   23.220998] reg 0x670, usb write TimeOut! status:-19 value=0x800100b8
[   23.221001] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.221003] reg 0x670, usb write TimeOut! status:-19 value=0x800100b9
[   23.221005] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.221007] reg 0x670, usb write TimeOut! status:-19 value=0x800100ba
[   23.221009] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.221012] reg 0x670, usb write TimeOut! status:-19 value=0x800100bb
[   23.221014] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.221016] reg 0x670, usb write TimeOut! status:-19 value=0x800100bc
[   23.221018] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.221020] reg 0x670, usb write TimeOut! status:-19 value=0x800100bd
[   23.221023] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.221025] reg 0x670, usb write TimeOut! status:-19 value=0x800100be
[   23.221027] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.221029] reg 0x670, usb write TimeOut! status:-19 value=0x800100bf
[   23.221031] reg 0x674, usb write TimeOut! status:-19 value=0x8010
[   23.221034] reg 0x670, usb write TimeOut! status:-19 value=0x800100c0
[   23.221036] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.221038] reg 0x670, usb write TimeOut! status:-19 value=0x800100c1
[   23.221040] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.221042] reg 0x670, usb write TimeOut! status:-19 value=0x800100c2
[   23.221045] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.221047] reg 0x670, usb write TimeOut! status:-19 value=0x800100c3
[   23.221049] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.221051] reg 0x670, usb write TimeOut! status:-19 value=0x800100c4
[   23.221053] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.221056] reg 0x670, usb write TimeOut! status:-19 value=0x800100c5
[   23.221058] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.221060] reg 0x670, usb write TimeOut! status:-19 value=0x800100c6
[   23.221062] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.221065] reg 0x670, usb write TimeOut! status:-19 value=0x800100c7
[   23.221067] reg 0x674, usb write TimeOut! status:-19 value=0x8011
[   23.221069] reg 0x670, usb write TimeOut! status:-19 value=0x800100c8
[   23.221072] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.221074] reg 0x670, usb write TimeOut! status:-19 value=0x800100c9
[   23.221076] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.221079] reg 0x670, usb write TimeOut! status:-19 value=0x800100ca
[   23.221081] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.221083] reg 0x670, usb write TimeOut! status:-19 value=0x800100cb
[   23.221085] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.221087] reg 0x670, usb write TimeOut! status:-19 value=0x800100cc
[   23.221090] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.221092] reg 0x670, usb write TimeOut! status:-19 value=0x800100cd
[   23.221094] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.221096] reg 0x670, usb write TimeOut! status:-19 value=0x800100ce
[   23.221098] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.221100] reg 0x670, usb write TimeOut! status:-19 value=0x800100cf
[   23.221103] reg 0x674, usb write TimeOut! status:-19 value=0x8012
[   23.221105] reg 0x670, usb write TimeOut! status:-19 value=0x800100d0
[   23.221107] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.221109] reg 0x670, usb write TimeOut! status:-19 value=0x800100d1
[   23.221111] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.221114] reg 0x670, usb write TimeOut! status:-19 value=0x800100d2
[   23.221116] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.221118] reg 0x670, usb write TimeOut! status:-19 value=0x800100d3
[   23.221120] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.221122] reg 0x670, usb write TimeOut! status:-19 value=0x800100d4
[   23.221124] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.221127] reg 0x670, usb write TimeOut! status:-19 value=0x800100d5
[   23.221129] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.221131] reg 0x670, usb write TimeOut! status:-19 value=0x800100d6
[   23.221133] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.221135] reg 0x670, usb write TimeOut! status:-19 value=0x800100d7
[   23.221138] reg 0x674, usb write TimeOut! status:-19 value=0x8013
[   23.221140] reg 0x670, usb write TimeOut! status:-19 value=0x800100d8
[   23.221142] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.221144] reg 0x670, usb write TimeOut! status:-19 value=0x800100d9
[   23.221147] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.221149] reg 0x670, usb write TimeOut! status:-19 value=0x800100da
[   23.221151] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.221153] reg 0x670, usb write TimeOut! status:-19 value=0x800100db
[   23.221156] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.221158] reg 0x670, usb write TimeOut! status:-19 value=0x800100dc
[   23.221160] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.221162] reg 0x670, usb write TimeOut! status:-19 value=0x800100dd
[   23.221164] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.221166] reg 0x670, usb write TimeOut! status:-19 value=0x800100de
[   23.221169] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.221171] reg 0x670, usb write TimeOut! status:-19 value=0x800100df
[   23.221173] reg 0x674, usb write TimeOut! status:-19 value=0x8010
[   23.221175] reg 0x670, usb write TimeOut! status:-19 value=0x800100e0
[   23.221177] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.221180] reg 0x670, usb write TimeOut! status:-19 value=0x800100e1
[   23.221182] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.221184] reg 0x670, usb write TimeOut! status:-19 value=0x800100e2
[   23.221186] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.221188] reg 0x670, usb write TimeOut! status:-19 value=0x800100e3
[   23.221191] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.221193] reg 0x670, usb write TimeOut! status:-19 value=0x800100e4
[   23.221195] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.221197] reg 0x670, usb write TimeOut! status:-19 value=0x800100e5
[   23.221199] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.221202] reg 0x670, usb write TimeOut! status:-19 value=0x800100e6
[   23.221204] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.221206] reg 0x670, usb write TimeOut! status:-19 value=0x800100e7
[   23.221208] reg 0x674, usb write TimeOut! status:-19 value=0x8011
[   23.221210] reg 0x670, usb write TimeOut! status:-19 value=0x800100e8
[   23.221213] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.221215] reg 0x670, usb write TimeOut! status:-19 value=0x800100e9
[   23.221217] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.221219] reg 0x670, usb write TimeOut! status:-19 value=0x800100ea
[   23.221222] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.221224] reg 0x670, usb write TimeOut! status:-19 value=0x800100eb
[   23.221226] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.221228] reg 0x670, usb write TimeOut! status:-19 value=0x800100ec
[   23.221230] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.221233] reg 0x670, usb write TimeOut! status:-19 value=0x800100ed
[   23.221235] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.221237] reg 0x670, usb write TimeOut! status:-19 value=0x800100ee
[   23.221239] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.221241] reg 0x670, usb write TimeOut! status:-19 value=0x800100ef
[   23.221244] reg 0x674, usb write TimeOut! status:-19 value=0x8012
[   23.221246] reg 0x670, usb write TimeOut! status:-19 value=0x800100f0
[   23.221248] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.221250] reg 0x670, usb write TimeOut! status:-19 value=0x800100f1
[   23.221253] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.221255] reg 0x670, usb write TimeOut! status:-19 value=0x800100f2
[   23.221257] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.221259] reg 0x670, usb write TimeOut! status:-19 value=0x800100f3
[   23.221261] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.221264] reg 0x670, usb write TimeOut! status:-19 value=0x800100f4
[   23.221266] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.221268] reg 0x670, usb write TimeOut! status:-19 value=0x800100f5
[   23.221270] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.221272] reg 0x670, usb write TimeOut! status:-19 value=0x800100f6
[   23.221275] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.221277] reg 0x670, usb write TimeOut! status:-19 value=0x800100f7
[   23.221279] reg 0x674, usb write TimeOut! status:-19 value=0x8013
[   23.221281] reg 0x670, usb write TimeOut! status:-19 value=0x800100f8
[   23.221284] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.221286] reg 0x670, usb write TimeOut! status:-19 value=0x800100f9
[   23.221288] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.221290] reg 0x670, usb write TimeOut! status:-19 value=0x800100fa
[   23.221292] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.221294] reg 0x670, usb write TimeOut! status:-19 value=0x800100fb
[   23.221297] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.221299] reg 0x670, usb write TimeOut! status:-19 value=0x800100fc
[   23.221301] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.221303] reg 0x670, usb write TimeOut! status:-19 value=0x800100fd
[   23.221305] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.221308] reg 0x670, usb write TimeOut! status:-19 value=0x800100fe
[   23.221310] reg 0x674, usb write TimeOut! status:-19 value=0x0
[   23.221312] reg 0x670, usb write TimeOut! status:-19 value=0x800100ff
[   23.221315] reg 0x670, usb write TimeOut! status:-19 value=0xc0000000
[   23.221317] reg 0x423, usb write TimeOut! status:-19 value=0xff
[   23.221319] usb_write8...error(-19)
[   23.221320] reg 0xf0, usb read TimeOut! status:-19 value=0xff
[   23.221322] IQK:Start!!!
[   23.221325] reg 0x800, usb read TimeOut! status:-19 value=0x0
[   23.221326] usb_read32...error(-19)
[   23.221328] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.221330] reg 0x85c, usb read TimeOut! status:-19 value=0x0
[   23.221332] usb_read32...error(-19)
[   23.221334] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.221336] reg 0xe6c, usb read TimeOut! status:-19 value=0x0
[   23.221338] usb_read32...error(-19)
[   23.221339] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.221342] reg 0xe70, usb read TimeOut! status:-19 value=0x0
[   23.221343] usb_read32...error(-19)
[   23.221345] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.221347] reg 0xe74, usb read TimeOut! status:-19 value=0x0
[   23.221349] usb_read32...error(-19)
[   23.221350] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.221353] reg 0xe78, usb read TimeOut! status:-19 value=0x0
[   23.221354] usb_read32...error(-19)
[   23.221356] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.221358] reg 0xe7c, usb read TimeOut! status:-19 value=0x0
[   23.221360] usb_read32...error(-19)
[   23.221362] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.221364] reg 0xe80, usb read TimeOut! status:-19 value=0x0
[   23.221365] usb_read32...error(-19)
[   23.221367] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.221369] reg 0xe84, usb read TimeOut! status:-19 value=0x0
[   23.221371] usb_read32...error(-19)
[   23.221373] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.221375] reg 0xe88, usb read TimeOut! status:-19 value=0x0
[   23.221376] usb_read32...error(-19)
[   23.221378] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.221380] reg 0xe8c, usb read TimeOut! status:-19 value=0x0
[   23.221382] usb_read32...error(-19)
[   23.221384] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.221386] reg 0xed0, usb read TimeOut! status:-19 value=0x0
[   23.221387] usb_read32...error(-19)
[   23.221389] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.221391] reg 0xed4, usb read TimeOut! status:-19 value=0x0
[   23.221393] usb_read32...error(-19)
[   23.221395] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.221397] reg 0xed8, usb read TimeOut! status:-19 value=0x0
[   23.221399] usb_read32...error(-19)
[   23.221400] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.221403] reg 0xedc, usb read TimeOut! status:-19 value=0x0
[   23.221404] usb_read32...error(-19)
[   23.221406] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.221408] reg 0xee0, usb read TimeOut! status:-19 value=0x0
[   23.221410] usb_read32...error(-19)
[   23.221412] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.221414] reg 0xeec, usb read TimeOut! status:-19 value=0x0
[   23.221416] usb_read32...error(-19)
[   23.221417] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.221420] reg 0x522, usb read TimeOut! status:-19 value=0x0
[   23.221422] reg 0x550, usb read TimeOut! status:-19 value=0x0
[   23.221424] reg 0x551, usb read TimeOut! status:-19 value=0x0
[   23.221426] reg 0x40, usb read TimeOut! status:-19 value=0x0
[   23.221428] usb_read32...error(-19)
[   23.221430] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.221432] reg 0xc04, usb read TimeOut! status:-19 value=0x0
[   23.221433] usb_read32...error(-19)
[   23.221435] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.221437] reg 0xc08, usb read TimeOut! status:-19 value=0x0
[   23.221439] usb_read32...error(-19)
[   23.221441] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.221443] reg 0x874, usb read TimeOut! status:-19 value=0x0
[   23.221444] usb_read32...error(-19)
[   23.221446] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.221448] reg 0xb68, usb read TimeOut! status:-19 value=0x0
[   23.221450] usb_read32...error(-19)
[   23.221452] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.221454] reg 0xb6c, usb read TimeOut! status:-19 value=0x0
[   23.221455] usb_read32...error(-19)
[   23.221457] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.221459] reg 0x870, usb read TimeOut! status:-19 value=0x0
[   23.221461] usb_read32...error(-19)
[   23.221463] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.221465] reg 0x860, usb read TimeOut! status:-19 value=0x0
[   23.221467] usb_read32...error(-19)
[   23.221468] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.221471] reg 0x864, usb read TimeOut! status:-19 value=0x0
[   23.221472] usb_read32...error(-19)
[   23.221474] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.221476] reg 0x800, usb read TimeOut! status:-19 value=0x0
[   23.221478] usb_read32...error(-19)
[   23.221479] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.221482] reg 0x85c, usb write TimeOut! status:-19 value=0xb1b25a0
[   23.221484] reg 0xe6c, usb write TimeOut! status:-19 value=0xbdb25a0
[   23.221487] reg 0xe70, usb write TimeOut! status:-19 value=0xbdb25a0
[   23.221489] reg 0xe74, usb write TimeOut! status:-19 value=0xbdb25a0
[   23.221491] reg 0xe78, usb write TimeOut! status:-19 value=0xbdb25a0
[   23.221493] reg 0xe7c, usb write TimeOut! status:-19 value=0xbdb25a0
[   23.221495] reg 0xe80, usb write TimeOut! status:-19 value=0xbdb25a0
[   23.221498] reg 0xe84, usb write TimeOut! status:-19 value=0xbdb25a0
[   23.221500] reg 0xe88, usb write TimeOut! status:-19 value=0xbdb25a0
[   23.221502] reg 0xe8c, usb write TimeOut! status:-19 value=0xbdb25a0
[   23.221504] reg 0xed0, usb write TimeOut! status:-19 value=0xbdb25a0
[   23.221507] reg 0xed4, usb write TimeOut! status:-19 value=0xbdb25a0
[   23.221509] reg 0xed8, usb write TimeOut! status:-19 value=0xbdb25a0
[   23.221511] reg 0xedc, usb write TimeOut! status:-19 value=0xbdb25a0
[   23.221513] reg 0xee0, usb write TimeOut! status:-19 value=0xbdb25a0
[   23.221515] reg 0xeec, usb write TimeOut! status:-19 value=0xbdb25a0
[   23.221518] reg 0x820, usb read TimeOut! status:-19 value=0x0
[   23.221519] usb_read32...error(-19)
[   23.221521] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.221524] reg 0x820, usb write TimeOut! status:-19 value=0x1000100
[   23.221526] reg 0x828, usb write TimeOut! status:-19 value=0x1000100
[   23.221528] reg 0x800, usb read TimeOut! status:-19 value=0x0
[   23.221530] usb_read32...error(-19)
[   23.221532] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.221534] reg 0x800, usb write TimeOut! status:-19 value=0x0
[   23.221536] reg 0xc04, usb write TimeOut! status:-19 value=0x3a05600
[   23.221538] reg 0xc08, usb write TimeOut! status:-19 value=0x800e4
[   23.221541] reg 0x874, usb write TimeOut! status:-19 value=0x22204000
[   23.221543] reg 0x870, usb read TimeOut! status:-19 value=0x0
[   23.221544] usb_read32...error(-19)
[   23.221546] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.221548] reg 0x870, usb write TimeOut! status:-19 value=0x400
[   23.221550] reg 0x870, usb read TimeOut! status:-19 value=0x0
[   23.221552] usb_read32...error(-19)
[   23.221554] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.221556] reg 0x870, usb write TimeOut! status:-19 value=0x4000000
[   23.221558] reg 0x860, usb read TimeOut! status:-19 value=0x0
[   23.221560] usb_read32...error(-19)
[   23.221562] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.221564] reg 0x860, usb write TimeOut! status:-19 value=0x0
[   23.221566] reg 0x864, usb read TimeOut! status:-19 value=0x0
[   23.221568] usb_read32...error(-19)
[   23.221569] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.221572] reg 0x864, usb write TimeOut! status:-19 value=0x0
[   23.221574] reg 0x522, usb write TimeOut! status:-19 value=0x3f
[   23.221575] usb_write8...error(-19)
[   23.221577] reg 0xf0, usb read TimeOut! status:-19 value=0x3f
[   23.221579] reg 0x550, usb write TimeOut! status:-19 value=0x0
[   23.221581] usb_write8...error(-19)
[   23.221583] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.221585] reg 0x551, usb write TimeOut! status:-19 value=0x0
[   23.221587] usb_write8...error(-19)
[   23.221588] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.221591] reg 0x40, usb write TimeOut! status:-19 value=0x0
[   23.221592] usb_write8...error(-19)
[   23.221594] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.221596] reg 0xb68, usb write TimeOut! status:-19 value=0x80000
[   23.221599] reg 0xe28, usb write TimeOut! status:-19 value=0x80800000
[   23.221601] reg 0xe40, usb write TimeOut! status:-19 value=0x1007c00
[   23.221603] reg 0xe44, usb write TimeOut! status:-19 value=0x1004800
[   23.221605] reg 0xe30, usb write TimeOut! status:-19 value=0x10008c1f
[   23.221608] reg 0xe34, usb write TimeOut! status:-19 value=0x10008c1f
[   23.221610] reg 0xe38, usb write TimeOut! status:-19 value=0x82140102
[   23.221612] reg 0xe3c, usb write TimeOut! status:-19 value=0x28160502
[   23.221614] reg 0xe4c, usb write TimeOut! status:-19 value=0x1028d1
[   23.221617] reg 0xe48, usb write TimeOut! status:-19 value=0xf9000000
[   23.221619] reg 0xe48, usb write TimeOut! status:-19 value=0xf8000000
[   23.222764] reg 0xeac, usb read TimeOut! status:-19 value=0x0
[   23.222766] usb_read32...error(-19)
[   23.222768] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.222771] reg 0xe94, usb read TimeOut! status:-19 value=0x0
[   23.222772] usb_read32...error(-19)
[   23.222774] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.222776] reg 0xe9c, usb read TimeOut! status:-19 value=0x0
[   23.222778] usb_read32...error(-19)
[   23.222780] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.222782] reg 0xea4, usb read TimeOut! status:-19 value=0x0
[   23.222783] usb_read32...error(-19)
[   23.222785] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.222787] Path A IQK Success!!
[   23.222789] reg 0xe94, usb read TimeOut! status:-19 value=0x0
[   23.222790] usb_read32...error(-19)
[   23.222792] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.222794] reg 0xe9c, usb read TimeOut! status:-19 value=0x0
[   23.222796] usb_read32...error(-19)
[   23.222798] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.222800] reg 0xea4, usb read TimeOut! status:-19 value=0x0
[   23.222802] usb_read32...error(-19)
[   23.222803] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.222806] reg 0xeac, usb read TimeOut! status:-19 value=0x0
[   23.222807] usb_read32...error(-19)
[   23.222809] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.222811] reg 0xe28, usb write TimeOut! status:-19 value=0x0
[   23.222814] reg 0x85c, usb write TimeOut! status:-19 value=0xb1b25a0
[   23.222816] reg 0xe6c, usb write TimeOut! status:-19 value=0xbdb25a0
[   23.222819] reg 0xe70, usb write TimeOut! status:-19 value=0xbdb25a0
[   23.222821] reg 0xe74, usb write TimeOut! status:-19 value=0xbdb25a0
[   23.222823] reg 0xe78, usb write TimeOut! status:-19 value=0xbdb25a0
[   23.222825] reg 0xe7c, usb write TimeOut! status:-19 value=0xbdb25a0
[   23.222828] reg 0xe80, usb write TimeOut! status:-19 value=0xbdb25a0
[   23.222830] reg 0xe84, usb write TimeOut! status:-19 value=0xbdb25a0
[   23.222832] reg 0xe88, usb write TimeOut! status:-19 value=0xbdb25a0
[   23.222835] reg 0xe8c, usb write TimeOut! status:-19 value=0xbdb25a0
[   23.222837] reg 0xed0, usb write TimeOut! status:-19 value=0xbdb25a0
[   23.222839] reg 0xed4, usb write TimeOut! status:-19 value=0xbdb25a0
[   23.222842] reg 0xed8, usb write TimeOut! status:-19 value=0xbdb25a0
[   23.222844] reg 0xedc, usb write TimeOut! status:-19 value=0xbdb25a0
[   23.222846] reg 0xee0, usb write TimeOut! status:-19 value=0xbdb25a0
[   23.222849] reg 0xeec, usb write TimeOut! status:-19 value=0xbdb25a0
[   23.222851] reg 0x820, usb write TimeOut! status:-19 value=0x1000100
[   23.222853] reg 0x828, usb write TimeOut! status:-19 value=0x1000100
[   23.222855] reg 0x800, usb read TimeOut! status:-19 value=0x0
[   23.222857] usb_read32...error(-19)
[   23.222859] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.222861] reg 0x800, usb write TimeOut! status:-19 value=0x0
[   23.222863] reg 0xc04, usb write TimeOut! status:-19 value=0x3a05600
[   23.222866] reg 0xc08, usb write TimeOut! status:-19 value=0x800e4
[   23.222868] reg 0x874, usb write TimeOut! status:-19 value=0x22204000
[   23.222870] reg 0x870, usb read TimeOut! status:-19 value=0x0
[   23.222871] usb_read32...error(-19)
[   23.222873] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.222876] reg 0x870, usb write TimeOut! status:-19 value=0x400
[   23.222878] reg 0x870, usb read TimeOut! status:-19 value=0x0
[   23.222879] usb_read32...error(-19)
[   23.222881] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.222883] reg 0x870, usb write TimeOut! status:-19 value=0x4000000
[   23.222886] reg 0x860, usb read TimeOut! status:-19 value=0x0
[   23.222887] usb_read32...error(-19)
[   23.222889] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.222891] reg 0x860, usb write TimeOut! status:-19 value=0x0
[   23.222893] reg 0x864, usb read TimeOut! status:-19 value=0x0
[   23.222895] usb_read32...error(-19)
[   23.222897] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.222899] reg 0x864, usb write TimeOut! status:-19 value=0x0
[   23.222901] reg 0x522, usb write TimeOut! status:-19 value=0x3f
[   23.222903] usb_write8...error(-19)
[   23.222905] reg 0xf0, usb read TimeOut! status:-19 value=0x3f
[   23.222907] reg 0x550, usb write TimeOut! status:-19 value=0x0
[   23.222909] usb_write8...error(-19)
[   23.222911] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.222913] reg 0x551, usb write TimeOut! status:-19 value=0x0
[   23.222914] usb_write8...error(-19)
[   23.222916] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.222918] reg 0x40, usb write TimeOut! status:-19 value=0x0
[   23.222920] usb_write8...error(-19)
[   23.222922] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.222924] reg 0xb68, usb write TimeOut! status:-19 value=0x80000
[   23.222927] reg 0xe28, usb write TimeOut! status:-19 value=0x80800000
[   23.222929] reg 0xe40, usb write TimeOut! status:-19 value=0x1007c00
[   23.222931] reg 0xe44, usb write TimeOut! status:-19 value=0x1004800
[   23.222934] reg 0xe30, usb write TimeOut! status:-19 value=0x10008c1f
[   23.222936] reg 0xe34, usb write TimeOut! status:-19 value=0x10008c1f
[   23.222938] reg 0xe38, usb write TimeOut! status:-19 value=0x82140102
[   23.222941] reg 0xe3c, usb write TimeOut! status:-19 value=0x28160502
[   23.222943] reg 0xe4c, usb write TimeOut! status:-19 value=0x1028d1
[   23.222945] reg 0xe48, usb write TimeOut! status:-19 value=0xf9000000
[   23.222947] reg 0xe48, usb write TimeOut! status:-19 value=0xf8000000
[   23.223948] reg 0xeac, usb read TimeOut! status:-19 value=0x0
[   23.223950] usb_read32...error(-19)
[   23.223951] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.223954] reg 0xe94, usb read TimeOut! status:-19 value=0x0
[   23.223955] usb_read32...error(-19)
[   23.223957] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.223959] reg 0xe9c, usb read TimeOut! status:-19 value=0x0
[   23.223961] usb_read32...error(-19)
[   23.223963] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.223965] reg 0xea4, usb read TimeOut! status:-19 value=0x0
[   23.223967] usb_read32...error(-19)
[   23.223969] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.223970] Path A IQK Success!!
[   23.223972] reg 0xe94, usb read TimeOut! status:-19 value=0x0
[   23.223974] usb_read32...error(-19)
[   23.223976] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.223978] reg 0xe9c, usb read TimeOut! status:-19 value=0x0
[   23.223980] usb_read32...error(-19)
[   23.223982] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.223984] reg 0xea4, usb read TimeOut! status:-19 value=0x0
[   23.223985] usb_read32...error(-19)
[   23.223987] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.223990] reg 0xeac, usb read TimeOut! status:-19 value=0x0
[   23.223991] usb_read32...error(-19)
[   23.223993] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.223995] reg 0xe28, usb write TimeOut! status:-19 value=0x0
[   23.223997] reg 0x820, usb write TimeOut! status:-19 value=0x1000000
[   23.224000] reg 0x828, usb write TimeOut! status:-19 value=0x1000000
[   23.224002] reg 0x85c, usb write TimeOut! status:-19 value=0x0
[   23.224004] reg 0xe6c, usb write TimeOut! status:-19 value=0x0
[   23.224006] reg 0xe70, usb write TimeOut! status:-19 value=0x0
[   23.224009] reg 0xe74, usb write TimeOut! status:-19 value=0x0
[   23.224011] reg 0xe78, usb write TimeOut! status:-19 value=0x0
[   23.224013] reg 0xe7c, usb write TimeOut! status:-19 value=0x0
[   23.224015] reg 0xe80, usb write TimeOut! status:-19 value=0x0
[   23.224017] reg 0xe84, usb write TimeOut! status:-19 value=0x0
[   23.224019] reg 0xe88, usb write TimeOut! status:-19 value=0x0
[   23.224021] reg 0xe8c, usb write TimeOut! status:-19 value=0x0
[   23.224023] reg 0xed0, usb write TimeOut! status:-19 value=0x0
[   23.224026] reg 0xed4, usb write TimeOut! status:-19 value=0x0
[   23.224028] reg 0xed8, usb write TimeOut! status:-19 value=0x0
[   23.224030] reg 0xedc, usb write TimeOut! status:-19 value=0x0
[   23.224032] reg 0xee0, usb write TimeOut! status:-19 value=0x0
[   23.224034] reg 0xeec, usb write TimeOut! status:-19 value=0x0
[   23.224036] reg 0x522, usb write TimeOut! status:-19 value=0x0
[   23.224038] usb_write8...error(-19)
[   23.224040] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.224042] reg 0x550, usb write TimeOut! status:-19 value=0x0
[   23.224044] usb_write8...error(-19)
[   23.224046] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.224048] reg 0x551, usb write TimeOut! status:-19 value=0x0
[   23.224050] usb_write8...error(-19)
[   23.224052] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.224054] reg 0x40, usb write TimeOut! status:-19 value=0x0
[   23.224056] reg 0xc04, usb write TimeOut! status:-19 value=0x0
[   23.224058] reg 0xc08, usb write TimeOut! status:-19 value=0x0
[   23.224060] reg 0x874, usb write TimeOut! status:-19 value=0x0
[   23.224062] reg 0xb68, usb write TimeOut! status:-19 value=0x0
[   23.224065] reg 0xb6c, usb write TimeOut! status:-19 value=0x0
[   23.224067] reg 0x870, usb write TimeOut! status:-19 value=0x0
[   23.224069] reg 0x860, usb write TimeOut! status:-19 value=0x0
[   23.224071] reg 0x864, usb write TimeOut! status:-19 value=0x0
[   23.224073] reg 0x800, usb write TimeOut! status:-19 value=0x0
[   23.224076] reg 0x840, usb write TimeOut! status:-19 value=0x32ed3
[   23.224078] reg 0xe30, usb write TimeOut! status:-19 value=0x1008c00
[   23.224080] reg 0xe34, usb write TimeOut! status:-19 value=0x1008c00
[   23.224082] IQK: final_candidate is 0
[   23.224084] IQK: RegE94=0 RegE9C=0 RegEA4=0 RegEAC=0 RegEB4=0
RegEBC=0 RegEC4=0 RegECC=0
[   23.224085]  reg 0xc14, usb read TimeOut! status:-19 value=0x0
[   23.224088] usb_read32...error(-19)
[   23.224090] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.224093] reg 0xc1c, usb read TimeOut! status:-19 value=0x0
[   23.224094] usb_read32...error(-19)
[   23.224096] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.224098] reg 0xc4c, usb read TimeOut! status:-19 value=0x0
[   23.224100] usb_read32...error(-19)
[   23.224102] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.224104] reg 0xc78, usb read TimeOut! status:-19 value=0x0
[   23.224105] usb_read32...error(-19)
[   23.224107] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.224109] reg 0xc80, usb read TimeOut! status:-19 value=0x0
[   23.224111] usb_read32...error(-19)
[   23.224113] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.224115] reg 0xc88, usb read TimeOut! status:-19 value=0x0
[   23.224117] usb_read32...error(-19)
[   23.224118] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.224121] reg 0xc90, usb read TimeOut! status:-19 value=0x0
[   23.224122] usb_read32...error(-19)
[   23.224124] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.224126] reg 0xc94, usb read TimeOut! status:-19 value=0x0
[   23.224128] usb_read32...error(-19)
[   23.224130] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.224132] reg 0xc9c, usb read TimeOut! status:-19 value=0x0
[   23.224134] usb_read32...error(-19)
[   23.224135] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.224138] reg 0xca0, usb read TimeOut! status:-19 value=0x0
[   23.224139] usb_read32...error(-19)
[   23.224141] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.224144] reg 0xd03, usb read TimeOut! status:-19 value=0x0
[   23.224146] usb_read32...error(-19)
[   23.224148] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.224150] reg 0x522, usb write TimeOut! status:-19 value=0xff
[   23.224151] usb_write8...error(-19)
[   23.224153] reg 0xf0, usb read TimeOut! status:-19 value=0xff
[   23.224155] reg 0x824, usb read TimeOut! status:-19 value=0x0
[   23.224157] usb_read32...error(-19)
[   23.224159] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.224161] reg 0x824, usb write TimeOut! status:-19 value=0x0
[   23.225162] reg 0x824, usb write TimeOut! status:-19 value=0x8c000000
[   23.226162] reg 0x824, usb write TimeOut! status:-19 value=0x80000000
[   23.227163] reg 0x820, usb read TimeOut! status:-19 value=0x0
[   23.227164] usb_read32...error(-19)
[   23.227166] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.227168] reg 0x8a0, usb read TimeOut! status:-19 value=0x0
[   23.227170] usb_read32...error(-19)
[   23.227172] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.227174] reg 0x824, usb read TimeOut! status:-19 value=0x0
[   23.227176] usb_read32...error(-19)
[   23.227178] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.227180] reg 0x824, usb write TimeOut! status:-19 value=0x0
[   23.228181] reg 0x824, usb write TimeOut! status:-19 value=0x8c000000
[   23.229181] reg 0x824, usb write TimeOut! status:-19 value=0x80000000
[   23.230182] reg 0x820, usb read TimeOut! status:-19 value=0x0
[   23.230183] usb_read32...error(-19)
[   23.230185] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.230187] reg 0x8a0, usb read TimeOut! status:-19 value=0x0
[   23.230189] usb_read32...error(-19)
[   23.230191] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.230193] reg 0x840, usb write TimeOut! status:-19 value=0x1808000
[   23.330275] reg 0x522, usb write TimeOut! status:-19 value=0x0
[   23.330278] usb_write8...error(-19)
[   23.330280] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.330283] reg 0x550, usb read TimeOut! status:-19 value=0x0
[   23.330285] reg 0x522, usb read TimeOut! status:-19 value=0x0
[   23.330287] reg 0x422, usb read TimeOut! status:-19 value=0x0
[   23.330289] reg 0x542, usb read TimeOut! status:-19 value=0x0
[   23.330291] reg 0xfe40, usb write TimeOut! status:-19 value=0xe0
[   23.330293] usb_write8...error(-19)
[   23.330295] reg 0xf0, usb read TimeOut! status:-19 value=0xe0
[   23.330297] reg 0xfe41, usb write TimeOut! status:-19 value=0x8d
[   23.330299] usb_write8...error(-19)
[   23.330301] reg 0xf0, usb read TimeOut! status:-19 value=0x8d
[   23.330303] reg 0xfe42, usb write TimeOut! status:-19 value=0x80
[   23.330305] usb_write8...error(-19)
[   23.330307] reg 0xf0, usb read TimeOut! status:-19 value=0x80
[   23.330309] reg 0x20c, usb write TimeOut! status:-19 value=0xfd0320
[   23.330311] reg 0x610, usb read TimeOut! status:-19 value=0x0
[   23.330313] reg 0x611, usb read TimeOut! status:-19 value=0x0
[   23.330316] reg 0x612, usb read TimeOut! status:-19 value=0x0
[   23.330318] reg 0x613, usb read TimeOut! status:-19 value=0x0
[   23.330320] reg 0x614, usb read TimeOut! status:-19 value=0x0
[   23.330322] reg 0x615, usb read TimeOut! status:-19 value=0x0
[   23.330324] MAC Address from REG = 0-0-0-0-0-0
[   23.330326] reg 0x31, usb write TimeOut! status:-19 value=0xfa
[   23.330328] usb_write8...error(-19)
[   23.330330] reg 0xf0, usb read TimeOut! status:-19 value=0xfa
[   23.330332] reg 0x32, usb read TimeOut! status:-19 value=0x0
[   23.330334] reg 0x32, usb write TimeOut! status:-19 value=0x1
[   23.330336] usb_write8...error(-19)
[   23.330337] reg 0xf0, usb read TimeOut! status:-19 value=0x1
[   23.330340] reg 0x30, usb read TimeOut! status:-19 value=0x0
[   23.330341] usb_read32...error(-19)
[   23.330343] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.330345] reg 0x30, usb write TimeOut! status:-19 value=0x0
[   23.330347] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330349] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330351] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330354] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330356] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330358] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330360] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330362] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330364] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330366] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330368] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330370] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330372] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330374] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330376] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330378] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330381] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330383] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330385] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330387] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330389] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330391] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330393] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330395] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330397] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330399] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330401] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330403] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330405] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330407] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330410] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330412] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330414] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330416] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330418] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330420] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330422] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330424] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330426] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330428] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330430] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330432] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330434] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330436] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330439] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330441] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330443] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330445] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330447] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330449] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330451] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330453] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330455] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330457] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330459] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330461] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330463] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330465] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330467] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330469] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330471] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330473] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330476] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330478] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330480] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330482] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330484] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330486] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330488] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330490] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330492] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330494] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330496] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330498] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330500] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330502] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330505] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330507] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330509] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330511] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330513] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330515] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330517] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330519] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330521] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330523] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330525] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330527] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330530] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330532] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330534] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330536] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330538] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330540] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330542] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330544] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330546] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330548] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330550] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330552] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330554] reg 0x33, usb read TimeOut! status:-19 value=0x0
[   23.330558] pdmpriv->TxPowerTrackControl = 1
[   23.330560] reg 0x40, usb read TimeOut! status:-19 value=0x0
[   23.330562] reg 0x40, usb write TimeOut! status:-19 value=0x0
[   23.330564] usb_write8...error(-19)
[   23.330565] reg 0xf0, usb read TimeOut! status:-19 value=0x0
[   23.330568] reg 0x15, usb write TimeOut! status:-19 value=0xe9
[   23.330569] usb_write8...error(-19)
[   23.330571] reg 0xf0, usb read TimeOut! status:-19 value=0xe9
[   23.330574] MAC Address = 0-e0-4c-0-29-ba
[   23.330606] -871x_drv - drv_open, bup=1
[   23.331654] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[   23.342545] (2)8192cu_drv - drv_close, bup=1, hw_init_completed=1
[   23.342553] -871x_drv - drv_close, bup=1
[   23.343334] ###> rtw_cmd_thread break.................
[   23.400143] +rtw_dev_unload
[   23.400154] reg 0x522, usb write TimeOut! status:-19 value=0xff
[   23.400156] usb_write8...error(-19)
[   23.400158] reg 0xf0, usb read TimeOut! status:-19 value=0xff
[   23.400161] usb_read_port_cancel
[   23.400164] usb_read_port_cancel
[   23.400166] -rtw_dev_unload
[   23.400167] +r871xu_dev_remove, hw_init_completed=1
[   23.400227] free_recv_skb_queue not empty, 8
[   23.400244] -r871xu_dev_remove, done
[   23.413027] sky2 0000:03:00.0: eth0: enabling interface
[   23.413493] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   23.439390] Linux video capture interface: v2.00
[   23.442405] uvcvideo: Found UVC 1.00 device Built-in iSight (05ac:8501)
[   23.444762] uvcvideo: UVC non compliance - GET_DEF(PROBE) not
supported. Enabling workaround.
[   23.445281] usbcore: registered new interface driver uvcvideo
[   23.445283] USB Video Class driver (v0.1.0)
[   23.560168] Skipping EDID probe due to cached edid
[   24.032674] Skipping EDID probe due to cached edid
[   25.542673] Skipping EDID probe due to cached edid
[   26.010090] Skipping EDID probe due to cached edid
[   26.490077] Skipping EDID probe due to cached edid
[   26.970056] Skipping EDID probe due to cached edid
[   30.158059] EXT4-fs (sda3): re-mounted. Opts: errors=remount-ro,commit=0
[   33.920039] eth2: no IPv6 routers present
[   39.680084] Skipping EDID probe due to cached edid
[   40.170061] Skipping EDID probe due to cached edid
[   40.650057] Skipping EDID probe due to cached edid
[   45.153935] vboxdrv: Found 2 processor cores.
[   45.154431] VBoxDrv: dbg - g_abExecMemory=ffffffffa0593e00
[   45.154450] vboxdrv: fAsync=0 offMin=0x1b0 offMax=0x144c
[   45.155005] vboxdrv: TSC mode is 'synchronous', kernel timer mode
is 'normal'.
[   45.155008] vboxdrv: Successfully loaded version 3.2.12 (interface
0x00140001).
[   48.220083] Skipping EDID probe due to cached edid
[   68.863164] lo: Disabled Privacy Extensions


Thanks once again
damencho
