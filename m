Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:54323 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752904AbZEYWyF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 May 2009 18:54:05 -0400
Message-ID: <4A1B2186.3070107@gmx.net>
Date: Tue, 26 May 2009 00:53:58 +0200
From: Barkle <barkle@gmx.net>
MIME-Version: 1.0
To: Hin-Tak Leung <hintak.leung@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: RTL 8185
References: <4A199FED.7000609@gmx.net>	 <3ace41890905242315i53dbb93dsf98e7a3a574a3c29@mail.gmail.com>	 <4A1B00E7.5070801@gmx.net> <3ace41890905251414v75544ed4o7bafdb3cdc170d1d@mail.gmail.com>
In-Reply-To: <3ace41890905251414v75544ed4o7bafdb3cdc170d1d@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------080704060008090702050308"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080704060008090702050308
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hin-Tak Leung schrieb:
> On Mon, May 25, 2009 at 9:34 PM, Barkle <barkle@gmx.net> wrote:
>
>   
>> Have a look in the appended file "dmesg_2009-05-25.txt" and it's not wlan0,
>> it's phy0.
>> I hope, I haven't cut off too much .
>>     
>
> You have removed almost everything that might be useful... 
>   
Sorry, here is one komplett cycle begining with the restart, all from 
00:28:35 to 00:28:35
The next line beginning with 00:32:58 is the next reboot after a freeze.

>> wpa_supplicant -Dwext -iwlan0 -c/etc/wpa_supplicant/wpa_supplicant.conf -W
>> -dd
>>     
>
> If you are not using any encryption (WEP/WPA, etc),

I need encryption, but it doesn't matter if I use the right values. The 
result is the same.

> Also, what's in /var/log/wpa_supplicant.log ?
>   

Empty.
**********************
feta:/var/log# ls -l w*
-rw-r--r-- 1 root root      0 25. Mai 06:25 wpa_supplicant.wlan0.log
-rw-r--r-- 1 root root     20 24. Mai 06:25 wpa_supplicant.wlan0.log.1.gz
-rw-r--r-- 1 root root     20 23. Mai 06:25 wpa_supplicant.wlan0.log.2.gz
-rw-r--r-- 1 root root     20 22. Mai 06:25 wpa_supplicant.wlan0.log.3.gz
-rw-r--r-- 1 root root     20 21. Mai 06:25 wpa_supplicant.wlan0.log.4.gz
-rw-r--r-- 1 root root     20 20. Mai 06:25 wpa_supplicant.wlan0.log.5.gz
**********************


> In fact you should shutdown network manager and wpa_suplicant and
> probably dbus as well.
>   
There is no networkmanager working.
The wpa_supplicant is needed for encryption
How can I switch off the dbus?


> Please gIve compat-wireless a go.
>   

Please be a little pacient with me. I work on it.
Do you need any further information?


Thanks so long.


--------------080704060008090702050308
Content-Type: text/plain;
 name="syslog_2009-05-26_001.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="syslog_2009-05-26_001.txt"

May 26 00:27:55 feta shutdown[1559]: shutting down for system reboot
May 26 00:27:55 feta init: Switching to runlevel: 6
May 26 00:27:58 feta rpc.statd[916]: Caught signal 15, un-registering and exiting.
May 26 00:28:35 feta kernel: imklog 3.18.6, log source = /proc/kmsg started.
May 26 00:28:35 feta kernel: Linux version 2.6.30-rc5-1 (root@feta) (gcc version 4.3.2 (Debian 4.3.2-1.1) ) #1 PREEMPT Mon May 11 00:13:36 CEST 2009
May 26 00:28:35 feta kernel: KERNEL supported cpus:
May 26 00:28:35 feta kernel:  Intel GenuineIntel
May 26 00:28:35 feta kernel:  AMD AuthenticAMD
May 26 00:28:35 feta kernel:  NSC Geode by NSC
May 26 00:28:35 feta kernel:  Cyrix CyrixInstead
May 26 00:28:35 feta kernel:  Centaur CentaurHauls
May 26 00:28:35 feta kernel:  Transmeta GenuineTMx86
May 26 00:28:35 feta kernel:  Transmeta TransmetaCPU
May 26 00:28:35 feta kernel:  UMC UMC UMC UMC
May 26 00:28:35 feta kernel: BIOS-provided physical RAM map:
May 26 00:28:35 feta kernel: BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
May 26 00:28:35 feta kernel: BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
May 26 00:28:35 feta kernel: BIOS-e820: 00000000000e4c00 - 0000000000100000 (reserved)
May 26 00:28:35 feta kernel: BIOS-e820: 0000000000100000 - 000000000fef0000 (usable)
May 26 00:28:35 feta kernel: BIOS-e820: 000000000fef0000 - 000000000feffc00 (ACPI data)
May 26 00:28:35 feta kernel: BIOS-e820: 000000000feffc00 - 000000000ff00000 (ACPI NVS)
May 26 00:28:35 feta kernel: BIOS-e820: 000000000ff00000 - 0000000010000000 (reserved)
May 26 00:28:35 feta kernel: BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
May 26 00:28:35 feta kernel: DMI present.
May 26 00:28:35 feta kernel: Phoenix BIOS detected: BIOS may corrupt low RAM, working around it.
May 26 00:28:35 feta kernel: e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
May 26 00:28:35 feta kernel: last_pfn = 0xfef0 max_arch_pfn = 0x100000
May 26 00:28:35 feta kernel: MTRR default type: uncachable
May 26 00:28:35 feta kernel: MTRR fixed ranges enabled:
May 26 00:28:35 feta kernel:  00000-9FFFF write-back
May 26 00:28:35 feta kernel:  A0000-BFFFF uncachable
May 26 00:28:35 feta kernel:  C0000-C7FFF write-protect
May 26 00:28:35 feta kernel:  C8000-DFFFF uncachable
May 26 00:28:35 feta kernel:  E0000-FFFFF write-protect
May 26 00:28:35 feta kernel: MTRR variable ranges enabled:
May 26 00:28:35 feta kernel:  0 base 000000000 mask FF8000000 write-back
May 26 00:28:35 feta kernel:  1 base 008000000 mask FFC000000 write-back
May 26 00:28:35 feta kernel:  2 base 00C000000 mask FFE000000 write-back
May 26 00:28:35 feta kernel:  3 base 00E000000 mask FFF000000 write-back
May 26 00:28:35 feta kernel:  4 base 00F000000 mask FFF800000 write-back
May 26 00:28:35 feta kernel:  5 base 00F800000 mask FFFC00000 write-back
May 26 00:28:35 feta kernel:  6 base 00FC00000 mask FFFE00000 write-back
May 26 00:28:35 feta kernel:  7 base 00FE00000 mask FFFF00000 write-back
May 26 00:28:35 feta kernel: PAT not supported by CPU.
May 26 00:28:35 feta kernel: init_memory_mapping: 0000000000000000-000000000fef0000
May 26 00:28:35 feta kernel: 0000000000 - 0000400000 page 4k
May 26 00:28:35 feta kernel: 0000400000 - 000fc00000 page 2M
May 26 00:28:35 feta kernel: 000fc00000 - 000fef0000 page 4k
May 26 00:28:35 feta kernel: kernel direct mapping tables up to fef0000 @ 10000-15000
May 26 00:28:35 feta kernel: ACPI: RSDP 000f6b70 00014 (v00 PTLTD )
May 26 00:28:35 feta kernel: ACPI: RSDT 0fefd4af 0002C (v01 PTLTD  	 RSDT   06040000  LTP 00000000)
May 26 00:28:35 feta kernel: ACPI: FACP 0fefd4db 00074 (v01 FSC    D1183/84 06040000      000F4240)
May 26 00:28:35 feta kernel: ACPI: DSDT 0fefd54f 02689 (v01 FSC    D1183/84 06040000 MSFT 0100000C)
May 26 00:28:35 feta kernel: ACPI: FACS 0fefffc0 00040
May 26 00:28:35 feta kernel: ACPI: BOOT 0feffbd8 00028 (v01 PTLTD  $SBFTBL$ 06040000  LTP 00000001)
May 26 00:28:35 feta kernel: 254MB LOWMEM available.
May 26 00:28:35 feta kernel:  mapped low ram: 0 - 0fef0000
May 26 00:28:35 feta kernel:  low ram: 0 - 0fef0000
May 26 00:28:35 feta kernel:  node 0 low ram: 00000000 - 0fef0000
May 26 00:28:35 feta kernel:  node 0 bootmap 00011000 - 00012fe0
May 26 00:28:35 feta kernel: (6 early reservations) ==> bootmem [0000000000 - 000fef0000]
May 26 00:28:35 feta kernel:  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
May 26 00:28:35 feta kernel:  #1 [0000100000 - 000042b29c]    TEXT DATA BSS ==> [0000100000 - 000042b29c]
May 26 00:28:35 feta kernel:  #2 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
May 26 00:28:35 feta kernel:  #3 [000042c000 - 000042e130]              BRK ==> [000042c000 - 000042e130]
May 26 00:28:35 feta kernel:  #4 [0000010000 - 0000011000]          PGTABLE ==> [0000010000 - 0000011000]
May 26 00:28:35 feta kernel:  #5 [0000011000 - 0000013000]          BOOTMAP ==> [0000011000 - 0000013000]
May 26 00:28:35 feta kernel: Zone PFN ranges:
May 26 00:28:35 feta kernel:  DMA      0x00000010 -> 0x00001000
May 26 00:28:35 feta kernel:  Normal   0x00001000 -> 0x0000fef0
May 26 00:28:35 feta kernel: Movable zone start PFN for each node
May 26 00:28:35 feta kernel: early_node_map[2] active PFN ranges
May 26 00:28:35 feta kernel:    0: 0x00000010 -> 0x0000009f
May 26 00:28:35 feta kernel:    0: 0x00000100 -> 0x0000fef0
May 26 00:28:35 feta kernel: On node 0 totalpages: 65151
May 26 00:28:35 feta kernel: free_area_init_node: node 0, pgdat c03c15e0, node_mem_map c1000200
May 26 00:28:35 feta kernel:  DMA zone: 32 pages used for memmap
May 26 00:28:35 feta kernel:  DMA zone: 0 pages reserved
May 26 00:28:35 feta kernel:  DMA zone: 3951 pages, LIFO batch:0
May 26 00:28:35 feta kernel:  Normal zone: 478 pages used for memmap
May 26 00:28:35 feta kernel:  Normal zone: 60690 pages, LIFO batch:15
May 26 00:28:35 feta kernel: Using APIC driver default
May 26 00:28:35 feta kernel: ACPI: PM-Timer IO Port: 0xf008
May 26 00:28:35 feta kernel: Local APIC disabled by BIOS -- you can enable it with "lapic"
May 26 00:28:35 feta kernel: nr_irqs_gsi: 16
May 26 00:28:35 feta kernel: Allocating PCI resources starting at 20000000 (gap: 10000000:eff00000)
May 26 00:28:35 feta kernel: Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64641
May 26 00:28:35 feta kernel: Kernel command line: root=/dev/hda1 ro vga=3845
May 26 00:28:35 feta kernel: Enabling fast FPU save and restore... done.
May 26 00:28:35 feta kernel: Enabling unmasked SIMD FPU exception support... done.
May 26 00:28:35 feta kernel: Initializing CPU#0
May 26 00:28:35 feta kernel: NR_IRQS:288
May 26 00:28:35 feta kernel: PID hash table entries: 1024 (order: 10, 4096 bytes)
May 26 00:28:35 feta kernel: Fast TSC calibration using PIT
May 26 00:28:35 feta kernel: Detected 861.697 MHz processor.
May 26 00:28:35 feta kernel: Console: colour VGA+ 80x30
May 26 00:28:35 feta kernel: console [tty0] enabled
May 26 00:28:35 feta kernel: Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
May 26 00:28:35 feta kernel: Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
May 26 00:28:35 feta kernel: Memory: 254956k/261056k available (2065k kernel code, 5540k reserved, 780k data, 248k init, 0k highmem)
May 26 00:28:35 feta kernel: virtual kernel memory layout:
May 26 00:28:35 feta kernel:    fixmap  : 0xfffaa000 - 0xfffff000   ( 340 kB)
May 26 00:28:35 feta kernel:    vmalloc : 0xd06f0000 - 0xfffa8000   ( 760 MB)
May 26 00:28:35 feta kernel:    lowmem  : 0xc0000000 - 0xcfef0000   ( 254 MB)
May 26 00:28:35 feta kernel:      .init : 0xc03ca000 - 0xc0408000   ( 248 kB)
May 26 00:28:35 feta kernel:      .data : 0xc0304607 - 0xc03c7768   ( 780 kB)
May 26 00:28:35 feta kernel:      .text : 0xc0100000 - 0xc0304607   (2065 kB)
May 26 00:28:35 feta kernel: Checking if this processor honours the WP bit even in supervisor mode...Ok.
May 26 00:28:35 feta kernel: Calibrating delay loop (skipped), value calculated using timer frequency.. 1723.39 BogoMIPS (lpj=3446788)
May 26 00:28:35 feta kernel: Mount-cache hash table entries: 512
May 26 00:28:35 feta kernel: CPU: L1 I cache: 16K, L1 D cache: 16K
May 26 00:28:35 feta kernel: CPU: L2 cache: 256K
May 26 00:28:35 feta kernel: Intel machine check architecture supported.
May 26 00:28:35 feta kernel: Intel machine check reporting enabled on CPU#0.
May 26 00:28:35 feta kernel: CPU: Intel Pentium III (Coppermine) stepping 06
May 26 00:28:35 feta kernel: Checking 'hlt' instruction... OK.
May 26 00:28:35 feta kernel: ACPI: Core revision 20090320
May 26 00:28:35 feta kernel: ACPI: setting ELCR to 0200 (from 0e80)
May 26 00:28:35 feta kernel: net_namespace: 520 bytes
May 26 00:28:35 feta kernel: NET: Registered protocol family 16
May 26 00:28:35 feta kernel: ACPI: bus type pci registered
May 26 00:28:35 feta kernel: PCI: PCI BIOS revision 2.10 entry at 0xfd96e, last bus=1
May 26 00:28:35 feta kernel: PCI: Using configuration type 1 for base access
May 26 00:28:35 feta kernel: bio: create slab <bio-0> at 0
May 26 00:28:35 feta kernel: ACPI: EC: Look up EC in DSDT
May 26 00:28:35 feta kernel: ACPI: Interpreter enabled
May 26 00:28:35 feta kernel: ACPI: (supports S0 S1 S3 S5)
May 26 00:28:35 feta kernel: ACPI: Using PIC for interrupt routing
May 26 00:28:35 feta kernel: ACPI: PCI Root Bridge [PCI0] (0000:00)
May 26 00:28:35 feta kernel: pci 0000:00:02.0: reg 10 32bit mmio: [0xf8000000-0xfbffffff]
May 26 00:28:35 feta kernel: pci 0000:00:02.0: reg 14 32bit mmio: [0xf4000000-0xf407ffff]
May 26 00:28:35 feta kernel: pci 0000:00:1f.0: quirk: region f000-f07f claimed by ICH4 ACPI/GPIO/TCO
May 26 00:28:35 feta kernel: pci 0000:00:1f.0: quirk: region f180-f1bf claimed by ICH4 GPIO
May 26 00:28:35 feta kernel: pci 0000:00:1f.1: reg 20 io port: [0x1000-0x100f]
May 26 00:28:35 feta kernel: pci 0000:00:1f.2: reg 20 io port: [0x1400-0x141f]
May 26 00:28:35 feta kernel: pci 0000:00:1f.3: reg 20 io port: [0x1800-0x180f]
May 26 00:28:35 feta kernel: pci 0000:01:07.0: reg 10 io port: [0x2000-0x20ff]
May 26 00:28:35 feta kernel: pci 0000:01:07.0: reg 14 32bit mmio: [0xf4100000-0xf41001ff]
May 26 00:28:35 feta kernel: pci 0000:01:07.0: supports D1 D2
May 26 00:28:35 feta kernel: pci 0000:01:07.0: PME# supported from D1 D2 D3hot D3cold
May 26 00:28:35 feta kernel: pci 0000:01:07.0: PME# disabled
May 26 00:28:35 feta kernel: pci 0000:01:09.0: reg 10 io port: [0x2400-0x247f]
May 26 00:28:35 feta kernel: pci 0000:01:09.0: reg 14 32bit mmio: [0xf4100400-0xf410047f]
May 26 00:28:35 feta kernel: pci 0000:01:09.0: reg 30 32bit mmio: [0x000000-0x01ffff]
May 26 00:28:35 feta kernel: pci 0000:01:09.0: supports D1 D2
May 26 00:28:35 feta kernel: pci 0000:01:09.0: PME# supported from D0 D1 D2 D3hot D3cold
May 26 00:28:35 feta kernel: pci 0000:01:09.0: PME# disabled
May 26 00:28:35 feta kernel: pci 0000:01:0b.0: reg 10 32bit mmio: [0xf5000000-0xf5ffffff]
May 26 00:28:35 feta kernel: pci 0000:01:0b.2: reg 10 32bit mmio: [0xf6000000-0xf6ffffff]
May 26 00:28:35 feta kernel: pci 0000:00:1e.0: transparent bridge
May 26 00:28:35 feta kernel: pci 0000:00:1e.0: bridge io port: [0x2000-0x2fff]
May 26 00:28:35 feta kernel: pci 0000:00:1e.0: bridge 32bit mmio: [0xf4100000-0xf6ffffff]
May 26 00:28:35 feta kernel: pci_bus 0000:00: on NUMA node 0
May 26 00:28:35 feta kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
May 26 00:28:35 feta kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIH._PRT]
May 26 00:28:35 feta kernel: ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
May 26 00:28:35 feta kernel: ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
May 26 00:28:35 feta kernel: ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *7 9 10 11 12 14 15)
May 26 00:28:35 feta kernel: ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
May 26 00:28:35 feta kernel: PCI: Using ACPI for IRQ routing
May 26 00:28:35 feta kernel: pnp: PnP ACPI init
May 26 00:28:35 feta kernel: ACPI: bus type pnp registered
May 26 00:28:35 feta kernel: pnp: PnP ACPI: found 9 devices
May 26 00:28:35 feta kernel: ACPI: ACPI bus type pnp unregistered
May 26 00:28:35 feta kernel: system 00:02: ioport range 0x4d0-0x4d1 has been reserved
May 26 00:28:35 feta kernel: system 00:02: ioport range 0xf000-0xf07f has been reserved
May 26 00:28:35 feta kernel: system 00:02: ioport range 0xf100-0xf10f has been reserved
May 26 00:28:35 feta kernel: system 00:02: ioport range 0xf180-0xf1bf has been reserved
May 26 00:28:35 feta kernel: system 00:02: ioport range 0x800-0x87f has been reserved
May 26 00:28:35 feta kernel: system 00:02: ioport range 0xf820-0xf82f has been reserved
May 26 00:28:35 feta kernel: system 00:02: ioport range 0xfe00-0xfe00 has been reserved
May 26 00:28:35 feta kernel: pci 0000:00:1e.0: PCI bridge, secondary bus 0000:01
May 26 00:28:35 feta kernel: pci 0000:00:1e.0:   IO window: 0x2000-0x2fff
May 26 00:28:35 feta kernel: pci 0000:00:1e.0:   MEM window: 0xf4100000-0xf6ffffff
May 26 00:28:35 feta kernel: pci 0000:00:1e.0:   PREFETCH window: 0x00000020000000-0x000000200fffff
May 26 00:28:35 feta kernel: pci 0000:00:1e.0: setting latency timer to 64
May 26 00:28:35 feta kernel: pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
May 26 00:28:35 feta kernel: pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
May 26 00:28:35 feta kernel: pci_bus 0000:01: resource 0 io:  [0x2000-0x2fff]
May 26 00:28:35 feta kernel: pci_bus 0000:01: resource 1 mem: [0xf4100000-0xf6ffffff]
May 26 00:28:35 feta kernel: pci_bus 0000:01: resource 2 pref mem [0x20000000-0x200fffff]
May 26 00:28:35 feta kernel: pci_bus 0000:01: resource 3 io:  [0x00-0xffff]
May 26 00:28:35 feta kernel: pci_bus 0000:01: resource 4 mem: [0x000000-0xffffffff]
May 26 00:28:35 feta kernel: NET: Registered protocol family 2
May 26 00:28:35 feta kernel: IP route cache hash table entries: 2048 (order: 1, 8192 bytes)
May 26 00:28:35 feta kernel: TCP established hash table entries: 8192 (order: 4, 65536 bytes)
May 26 00:28:35 feta kernel: TCP bind hash table entries: 8192 (order: 3, 32768 bytes)
May 26 00:28:35 feta kernel: TCP: Hash tables configured (established 8192 bind 8192)
May 26 00:28:35 feta kernel: TCP reno registered
May 26 00:28:35 feta kernel: Simple Boot Flag at 0x69 set to 0x1
May 26 00:28:35 feta kernel: audit: initializing netlink socket (disabled)
May 26 00:28:35 feta kernel: type=2000 audit(1243290500.116:1): initialized
May 26 00:28:35 feta kernel: msgmni has been set to 498
May 26 00:28:35 feta kernel: alg: No test for stdrng (krng)
May 26 00:28:35 feta kernel: io scheduler noop registered (default)
May 26 00:28:35 feta kernel: pci 0000:00:02.0: Boot video device
May 26 00:28:35 feta kernel: input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
May 26 00:28:35 feta kernel: ACPI: Power Button [PWRF]
May 26 00:28:35 feta kernel: input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
May 26 00:28:35 feta kernel: ACPI: Power Button [PWRB]
May 26 00:28:35 feta kernel: Marking TSC unstable due to TSC halts in idle
May 26 00:28:35 feta kernel: processor ACPI_CPU:00: registered as cooling_device0
May 26 00:28:35 feta kernel: floppy0: no floppy controllers found
May 26 00:28:35 feta kernel: Uniform Multi-Platform E-IDE driver
May 26 00:28:35 feta kernel: piix 0000:00:1f.1: IDE controller (0x8086:0x2411 rev 0x02)
May 26 00:28:35 feta kernel: piix 0000:00:1f.1: not 100% native mode: will probe irqs later
May 26 00:28:35 feta kernel:    ide0: BM-DMA at 0x1000-0x1007
May 26 00:28:35 feta kernel:    ide1: BM-DMA at 0x1008-0x100f
May 26 00:28:35 feta kernel: Probing IDE interface ide0...
May 26 00:28:35 feta kernel: hda: IC35L020AVER07-0, ATA DISK drive
May 26 00:28:35 feta kernel: hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
May 26 00:28:35 feta kernel: hda: host side 80-wire cable detection failed, limiting max speed to UDMA33
May 26 00:28:35 feta kernel: hda: UDMA/33 mode selected
May 26 00:28:35 feta kernel: Probing IDE interface ide1...
May 26 00:28:35 feta kernel: hdc: LITE-ON LTR-40125S, ATAPI CD/DVD-ROM drive
May 26 00:28:35 feta kernel: hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO4
May 26 00:28:35 feta kernel: hdc: UDMA/33 mode selected
May 26 00:28:35 feta kernel: ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
May 26 00:28:35 feta kernel: ide1 at 0x170-0x177,0x376 on irq 15
May 26 00:28:35 feta kernel: ide-gd driver 1.18
May 26 00:28:35 feta kernel: hda: max request size: 128KiB
May 26 00:28:35 feta kernel: hda: 40188960 sectors (20576 MB) w/1916KiB Cache, CHS=39870/16/63
May 26 00:28:35 feta kernel: hda: cache flushes not supported
May 26 00:28:35 feta kernel: hda: hda1 hda2
May 26 00:28:35 feta kernel: PNP: PS/2 Controller [PNP0303:KEYB,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
May 26 00:28:35 feta kernel: serio: i8042 KBD port at 0x60,0x64 irq 1
May 26 00:28:35 feta kernel: serio: i8042 AUX port at 0x60,0x64 irq 12
May 26 00:28:35 feta kernel: mice: PS/2 mouse device common for all mice
May 26 00:28:35 feta kernel: cpuidle: using governor ladder
May 26 00:28:35 feta kernel: TCP cubic registered
May 26 00:28:35 feta kernel: lib80211: common routines for IEEE802.11 drivers
May 26 00:28:35 feta kernel: lib80211_crypt: registered algorithm 'NULL'
May 26 00:28:35 feta kernel: Using IPI Shortcut mode
May 26 00:28:35 feta kernel: input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
May 26 00:28:35 feta kernel: kjournald starting.  Commit interval 5 seconds
May 26 00:28:35 feta kernel: EXT3-fs: mounted filesystem with writeback data mode.
May 26 00:28:35 feta kernel: VFS: Mounted root (ext3 filesystem) readonly on device 3:1.
May 26 00:28:35 feta kernel: Freeing unused kernel memory: 248k freed
May 26 00:28:35 feta kernel: NET: Registered protocol family 1
May 26 00:28:35 feta kernel: cfg80211: Using static regulatory domain info
May 26 00:28:35 feta kernel: cfg80211: Regulatory domain: US
May 26 00:28:35 feta kernel: 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
May 26 00:28:35 feta kernel: 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
May 26 00:28:35 feta kernel: 	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
May 26 00:28:35 feta kernel: 	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
May 26 00:28:35 feta kernel: 	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
May 26 00:28:35 feta kernel: 	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
May 26 00:28:35 feta kernel: 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
May 26 00:28:35 feta kernel: cfg80211: Calling CRDA for country: US
May 26 00:28:35 feta kernel: ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 7
May 26 00:28:35 feta kernel: PCI: setting IRQ 7 as level-triggered
May 26 00:28:35 feta kernel: 3c59x 0000:01:09.0: PCI INT A -> Link[LNKC] -> GSI 7 (level, low) -> IRQ 7
May 26 00:28:35 feta kernel: 3c59x: Donald Becker and others.
May 26 00:28:35 feta kernel: 0000:01:09.0: 3Com PCI 3c905C Tornado at d0776400.
May 26 00:28:35 feta kernel: ide-cd driver 5.00
May 26 00:28:35 feta kernel: ide-cd: hdc: ATAPI 48X CD-ROM CD-R/RW drive, 2048kB Cache
May 26 00:28:35 feta kernel: Uniform CD-ROM driver Revision: 3.20
May 26 00:28:35 feta kernel: ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
May 26 00:28:35 feta kernel: PCI: setting IRQ 11 as level-triggered
May 26 00:28:35 feta kernel: rtl8180 0000:01:07.0: PCI INT A -> Link[LNKB] -> GSI 11 (level, low) -> IRQ 11
May 26 00:28:35 feta kernel: phy0: Selected rate control algorithm 'minstrel'
May 26 00:28:35 feta kernel: phy0: hwaddr 00:0e:2e:e9:b5:fd, RTL8185vD + rtl8225z2
May 26 00:28:35 feta kernel: Adding 819304k swap on /dev/hda2.  Priority:-1 extents:1 across:819304k 
May 26 00:28:35 feta kernel: EXT3 FS on hda1, internal journal
May 26 00:28:35 feta kernel: loop: module loaded
May 26 00:28:35 feta kernel: eth0:  setting full-duplex.
May 26 00:28:35 feta rsyslogd: [origin software="rsyslogd" swVersion="3.18.6" x-pid="1091" x-info="http://www.rsyslog.com"] restart
May 26 00:28:38 feta /usr/sbin/cron[1461]: (CRON) INFO (pidfile fd = 3)
May 26 00:28:38 feta /usr/sbin/cron[1462]: (CRON) STARTUP (fork ok)
May 26 00:28:38 feta /usr/sbin/cron[1462]: (CRON) INFO (Running @reboot jobs)
May 26 00:32:58 feta kernel: imklog 3.18.6, log source = /proc/kmsg started.
May 26 00:32:58 feta kernel: Linux version 2.6.30-rc5-1 (root@feta) (gcc version 4.3.2 (Debian 4.3.2-1.1) ) #1 PREEMPT Mon May 11 00:13:36 CEST 2009
May 26 00:32:58 feta kernel: KERNEL supported cpus:
May 26 00:32:58 feta kernel:  Intel GenuineIntel
May 26 00:32:58 feta kernel:  AMD AuthenticAMD
May 26 00:32:58 feta kernel:  NSC Geode by NSC
May 26 00:32:58 feta kernel:  Cyrix CyrixInstead
May 26 00:32:58 feta kernel:  Centaur CentaurHauls
May 26 00:32:58 feta kernel:  Transmeta GenuineTMx86
May 26 00:32:58 feta kernel:  Transmeta TransmetaCPU
May 26 00:32:58 feta kernel:  UMC UMC UMC UMC

--------------080704060008090702050308--
