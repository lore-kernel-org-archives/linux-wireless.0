Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lugano1.hostireland.com ([72.32.223.205]:42395 "EHLO
	lugano.hostireland.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755372Ab0KKLQm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Nov 2010 06:16:42 -0500
Received: from localhost (localhost [127.0.0.1])
	by lugano.hostireland.com (Postfix) with ESMTP id 76F3DC0B16
	for <linux-wireless@vger.kernel.org>; Thu, 11 Nov 2010 11:16:41 +0000 (GMT)
Received: from raghuPC (unknown [115.108.4.204])
	by lugano.hostireland.com (Postfix) with ESMTP id A4A88C0B4F
	for <linux-wireless@vger.kernel.org>; Thu, 11 Nov 2010 11:16:36 +0000 (GMT)
From: "raghunath" <raghunath@airvod.com>
To: <linux-wireless@vger.kernel.org>
Subject: Ti's WL1271 on OMAP3EVM board with kernel version 2.6.36
Date: Thu, 11 Nov 2010 16:46:34 +0530
Message-ID: <004701cb8191$e82c75e0$b88561a0$@com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0048_01CB81C0.01E4B1E0"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.

------=_NextPart_000_0048_01CB81C0.01E4B1E0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,

I am working on OMAP3EVM board with Mistral wl1271 daughter board and using
linux kernel 2.6.36 I am using wl1271 drivers and getting this error pls
Let me know if any thing is wrong..


[    2.556549] wl1271: chip id after firmware boot: 0x4030111
[    2.576507] wl1271: cmd_box_addr 0x407b4 event_box_addr 0x4ce58
[    2.576660] wl1271: acx event mbox mask
[    2.576660] wl1271: cmd configure
[    2.576995] MBOX ptrs: 0x4ce58 0x4ceac
[    2.581146] MBOX ptrs: 0x4ce58 0x4ceac
[    2.585083] wl1271: cmd test
[    2.585479] wl1271: TEST_CMD_INI_FILE_RADIO_PARAM: 00000000: 00 00 00 00
19 00 00 00 00 00 ec f6 00 0c 18 f8
[    2.585510] wl1271: TEST_CMD_INI_FILE_RADIO_PARAM: 00000010: fc 00 08 10
f0 f8 00 0a 14 00 00 00 00 00 00 00
[    2.585540] wl1271: TEST_CMD_INI_FILE_RADIO_PARAM: 00000020: 00 00 00 00
00 00 00 ee f4 f8 fe 05 ea f3 fa 01
[    2.585571] wl1271: TEST_CMD_INI_FILE_RADIO_PARAM: 00000030: 06 e5 f1 fa
02 07 d9 01 80 00 1d 1f 22 26 27 29
[    2.585571] wl1271: TEST_CMD_INI_FILE_RADIO_PARAM: 00000040: 1d 1f 22 26
27 27 16 1d 1e 20 24 25 50 50 50 50
[    2.585601] wl1271: TEST_CMD_INI_FILE_RADIO_PARAM: 00000050: 50 50 50 50
50 50 50 50 50 50 50 50 50 50 50 50
[    2.585632] wl1271: TEST_CMD_INI_FILE_RADIO_PARAM: 00000060: 50 50 50 50
50 50 50 50 01 02 02 02 02 00 15 15
[    2.585662] wl1271: TEST_CMD_INI_FILE_RADIO_PARAM: 00000070: 15 19 19 15
0e 1e 2d 00 9a 01 ae 01 c2 01 cc 01
[    2.585662] wl1271: TEST_CMD_INI_FILE_RADIO_PARAM: 00000080: db 01 db 01
d1 01 80 80 80 80 80 80 80 00 00 00
[    2.585693] wl1271: TEST_CMD_INI_FILE_RADIO_PARAM: 00000090: 00 00 00 00
1c 1e 21 23 25 50 18 1e 21 23 25 50
[    2.585723] wl1271: TEST_CMD_INI_FILE_RADIO_PARAM: 000000a0: 16 1c 1e 20
20 50 50 50 50 50 50 50 50 50 50 50
[    2.585754] wl1271: TEST_CMD_INI_FILE_RADIO_PARAM: 000000b0: 50 50 50 50
50 50 50 50 50 50 50 50 50 50 50 50
[    2.585754] wl1271: TEST_CMD_INI_FILE_RADIO_PARAM: 000000c0: 50 50 50 50
50 50 50 50 50 01 02 02 02 02 00 1a
[    2.585784] wl1271: TEST_CMD_INI_FILE_RADIO_PARAM: 000000d0: 1a 1a 1a 1a
1a 10 10 10 10 10 10 10 1e 2d 00 00
[    2.585815] wl1271: cmd test
[    2.586303] wl1271: cmd template_set 2
[    2.586791] wl1271: cmd template_set 0
[    2.587219] wl1271: cmd template_set 6
[    2.587707] wl1271: cmd template_set 5
[    2.588226] wl1271: cmd template_set 4
[    2.588714] wl1271: cmd template_set 1
[    2.589202] wl1271: cmd template_set 7
[    2.589691] wl1271: cmd template_set 7
[    2.590179] wl1271: cmd template_set 7
[    2.590698] wl1271: cmd template_set 7
[    2.591186] wl1271: wl1271 mem cfg
[    2.591186] wl1271: cmd configure
[    2.591674] wl1271: acx mem map
[    2.591705] wl1271: cmd interrogate
[    2.592193] wl1271: available tx blocks: 83
[    2.592193] wl1271: acx rx msdu life time
[    2.592224] wl1271: cmd configure
[    2.592468] wl1271: acx rx config
[    2.592498] wl1271: cmd configure
[    2.592742] wl1271: acx data pd threshold
[    2.592742] wl1271: cmd configure
[    2.593017] wl1271: acx slot
[    2.593017] wl1271: cmd configure
[    2.593261] wl1271: acx group address tbl
[    2.593292] wl1271: cmd configure
[    2.593627] wl1271: acx service period timeout
[    2.593627] wl1271: cmd configure
[    2.593902] wl1271: acx rts threshold
[    2.593902] wl1271: cmd configure
[    2.594146] wl1271: acx connection monitor parameters: disabled
[    2.594177] wl1271: cmd configure
[    2.594421] wl1271: acx beacon filter opt
[    2.594451] wl1271: cmd configure
[    2.594757] wl1271: acx beacon filter table
[    2.594757] wl1271: cmd configure
[    2.595092] wl1271: acx tx config options
[    2.595123] wl1271: cmd configure
[    2.595367] wl1271: wl1271 rx interrupt config
[    2.595367] wl1271: cmd configure
[    2.595642] wl1271: acx sg cfg
[    2.595642] wl1271: cmd configure
[    2.598236] wl1271: acx sg enable
[    2.598236] wl1271: cmd configure
[    2.598510] wl1271: acx cca threshold
[    2.598510] wl1271: cmd configure
[    2.598754] wl1271: acx bcn dtim options
[    2.598785] wl1271: cmd configure
[    2.599029] wl1271: acx frag threshold
[    2.599060] wl1271: cmd configure
[    2.599304] wl1271: acx tid config
[    2.599334] wl1271: cmd configure
[    2.599578] wl1271: acx tid config
[    2.599578] wl1271: cmd configure
[    2.599822] wl1271: acx tid config
[    2.599853] wl1271: cmd configure
[    2.600097] wl1271: acx tid config
[    2.600128] wl1271: cmd configure
[    2.600372] wl1271: acx tid config
[    2.600372] wl1271: cmd configure
[    2.600616] wl1271: acx tid config
[    2.600646] wl1271: cmd configure
[    2.600891] wl1271: acx tid config
[    2.600921] wl1271: cmd configure
[    2.601165] wl1271: acx ac cfg 0 cw_ming 15 cw_max 63 aifs 3 txop 0
[    2.601196] wl1271: cmd configure
[    2.601440] wl1271: acx ac cfg 1 cw_ming 15 cw_max 63 aifs 7 txop 0
[    2.601470] wl1271: cmd configure
[    2.601715] wl1271: acx ac cfg 2 cw_ming 15 cw_max 63 aifs 1 txop 3008
[    2.601745] wl1271: cmd configure
[    2.601989] wl1271: acx ac cfg 3 cw_ming 15 cw_max 63 aifs 1 txop 1504
[    2.602020] wl1271: cmd configure
[    2.602264] wl1271: acx rate policies
[    2.602264] wl1271: cmd configure
[    2.602630] wl1271: cmd data path
[    2.602905] wl1271: rx start cmd channel 1
[    2.603149] wl1271: tx start cmd channel 1
[    2.603179] wl1271: acx sleep auth
[    2.603179] wl1271: cmd configure
[    2.603454] wl1271: acx feature cfg
[    2.603454] wl1271: cmd configure
[    2.603881] wl1271: cmd set_default_wep_key 0
[    2.604370] wl1271: acx pm config
[    2.604400] wl1271: cmd configure
[    2.604827] wl1271: acx keep alive config
[    2.604827] wl1271: cmd configure
[    2.605255] wl1271: acx keep alive config
[    2.605285] wl1271: cmd configure
[    2.605712] wl1271: acx keep alive config
[    2.605712] wl1271: cmd configure
[    2.606140] wl1271: acx keep alive config
[    2.606140] wl1271: cmd configure
[    2.606567] wl1271: acx keep alive mode: 0
[    2.606597] wl1271: cmd configure
[    2.607025] wl1271: acx rssi snr avg weights
[    2.607025] wl1271: cmd configure
[    2.607452] wl1271: firmware booted (Rev 6.1.0.0.343)
[    2.607482] wl1271: mac80211 bss info changed
[    2.607482] wl1271: acx slot
[    2.607513] wl1271: cmd configure
[    2.607940] wl1271: acx_set_preamble
[    2.607940] wl1271: cmd configure
[    2.608367] wl1271: acx_set_ctsprotect
[    2.608398] wl1271: cmd configure
[    2.608825] phy0: device now idle
[    2.608886] wl1271: mac80211 config ch 1 psm off power 20 idle
[    2.608917] wl1271: flushing tx buffer: 0
[    2.608917] wl1271: acx rate policies
[    2.608947] wl1271: cmd configure
[    2.609466] wl1271: acx rate policies
[    2.609466] wl1271: cmd configure
[    2.609954] wl1271: acx keep alive config
[    2.609985] wl1271: cmd configure
[    2.610473] wl1271: acx dot11_cur_tx_pwr
[    2.610473] wl1271: cmd configure
[    2.610931] wl1271: mac80211 conf tx 0
[    2.610931] wl1271: acx ac cfg 3 cw_ming 7 cw_max 15 aifs 2 txop 3264
[    2.610961] wl1271: cmd configure
[    2.611389] wl1271: acx tid config
[    2.611389] wl1271: cmd configure
[    2.611816] wl1271: mac80211 conf tx 1
[    2.611846] wl1271: acx ac cfg 2 cw_ming 15 cw_max 31 aifs 2 txop 6016
[    2.611877] wl1271: cmd configure
[    2.612274] wl1271: acx tid config
[    2.612304] wl1271: cmd configure
[    2.612731] wl1271: mac80211 conf tx 2
[    2.612762] wl1271: acx ac cfg 0 cw_ming 31 cw_max 1023 aifs 3 txop 0
[    2.612762] wl1271: cmd configure
[    2.613189] wl1271: acx tid config
[    2.613220] wl1271: cmd configure
[    2.613647] wl1271: mac80211 conf tx 3
[    2.613647] wl1271: acx ac cfg 1 cw_ming 31 cw_max 1023 aifs 7 txop 0
[    2.613677] wl1271: cmd configure
[    2.614105] wl1271: acx tid config
[    2.614105] wl1271: cmd configure
[    2.614532] wl1271: mac80211 bss info changed
[    2.614593] wl1271: mac80211 configure filter
[    2.614624] wl1271: acx group address tbl
[    2.614624] wl1271: cmd configure
[    2.615173] AIRVOD __dev_change_flags   net/core/dev.c ret = 0
[    2.621398] wl1271: elp work
[    2.621398] wl1271: chip to elp
[    2.621459] wl1271: mac80211 configure filter
[    2.621490] wl1271: waking up chip from elp
[    3.118377] wl1271: ERROR ELP wakeup timeout!
[    3.122955] wl1271: mac80211 configure filter
[    3.122985] wl1271: waking up chip from elp
[    3.618469] wl1271: ERROR ELP wakeup timeout!
[    3.626098] Sending DHCP requests .
[    5.627655] DHCP/BOOTP: Ignoring delayed packet
[    7.266723] .
[    8.767333] DHCP/BOOTP: Ignoring delayed packet
[   12.508941] ., OK
[   14.017211] IP-Config: Got DHCP answer from 0.0.0.0, my address is
192.168.1.14
[   14.024993] AIRVOD __dev_change_flags   net/core/dev.c ret = 0
[   14.031341] AIRVOD __dev_change_flags   net/core/dev.c ret = 0
[   14.037750] wl1271: mac80211 configure filter
[   14.037750] wl1271: waking up chip from elp
[   14.037872] wl1271: mac80211 configure filter
[   14.532409] wl1271: ERROR ELP wakeup timeout!
[   14.537017] wl1271: waking up chip from elp
[   15.032409] wl1271: ERROR ELP wakeup timeout!
[   15.037017] wl1271: mac80211 remove interface
[   15.037017] wl1271: down
[   15.037139] wl1271: mac80211 stop

------=_NextPart_000_0048_01CB81C0.01E4B1E0
Content-Type: text/plain;
	name="log_data.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="log_data.txt"

[    0.000000] Initializing cgroup subsys cpuset=0A=
[    0.000000] Initializing cgroup subsys cpu=0A=
[    0.000000] Linux version 2.6.36+ (raghu@raghu-laptop) (gcc version =
4.2.1 (CodeSourcery Sourcery G++ Lite 2007q3-51)) #98 SMP Wed Nov 10 =
18:34:51 IST 2010=0A=
[    0.000000] CPU: ARMv7 Processor [411fc083] revision 3 (ARMv7), =
cr=3D10c53c7f=0A=
[    0.000000] CPU: VIPT nonaliasing data cache, VIPT nonaliasing =
instruction cache=0A=
[    0.000000] Machine: OMAP3 EVM=0A=
[    0.000000] Memory policy: ECC disabled, Data cache writeback=0A=
[    0.000000] OMAP3430/3530 ES3.1 (l2cache iva sgx neon isp )=0A=
[    0.000000] SRAM: Mapped pa 0x40200000 to va 0xfe400000 size: 0x10000=0A=
[    0.000000] On node 0 totalpages: 22528=0A=
[    0.000000] free_area_init_node: node 0, pgdat c0715a80, node_mem_map =
c07a6000=0A=
[    0.000000]   Normal zone: 176 pages used for memmap=0A=
[    0.000000]   Normal zone: 0 pages reserved=0A=
[    0.000000]   Normal zone: 22352 pages, LIFO batch:3=0A=
[    0.000000] PERCPU: Embedded 7 pages/cpu @c0859000 s7616 r8192 d12864 =
u65536=0A=
[    0.000000] pcpu-alloc: s7616 r8192 d12864 u65536 alloc=3D16*4096=0A=
[    0.000000] pcpu-alloc: [0] 0 =0A=
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  =
Total pages: 22352=0A=
[    0.000000] Kernel command line: console=3DttyO0,115200n8 noinitrd rw =
ip=3Ddhcp root=3D/dev/nfs =
nfsroot=3D192.168.1.4:/home/raghu/workdir/lsp/filesys,nolock mem=3D88M =
omapfb.rotate=3D1 omapfb.rotate_type=3D1 =
omap_vout.vid1_static_vrfb_alloc=3Dy=0A=
[    0.000000] PID hash table entries: 512 (order: -1, 2048 bytes)=0A=
[    0.000000] Dentry cache hash table entries: 16384 (order: 4, 65536 =
bytes)=0A=
[    0.000000] Inode-cache hash table entries: 8192 (order: 3, 32768 =
bytes)=0A=
[    0.000000] allocated 450560 bytes of page_cgroup=0A=
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't =
want memory cgroups=0A=
[    0.000000] Memory: 88MB =3D 88MB total=0A=
[    0.000000] Memory: 80992k/80992k available, 9120k reserved, 0K =
highmem=0A=
[    0.000000] Virtual kernel memory layout:=0A=
[    0.000000]     vector  : 0xffff0000 - 0xffff1000   (   4 kB)=0A=
[    0.000000]     fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)=0A=
[    0.000000]     DMA     : 0xffc00000 - 0xffe00000   (   2 MB)=0A=
[    0.000000]     vmalloc : 0xc6000000 - 0xf8000000   ( 800 MB)=0A=
[    0.000000]     lowmem  : 0xc0000000 - 0xc5800000   (  88 MB)=0A=
[    0.000000]     pkmap   : 0xbfe00000 - 0xc0000000   (   2 MB)=0A=
[    0.000000]     modules : 0xbf000000 - 0xbfe00000   (  14 MB)=0A=
[    0.000000]       .init : 0xc0008000 - 0xc004a000   ( 264 kB)=0A=
[    0.000000]       .text : 0xc004a000 - 0xc064b000   (6148 kB)=0A=
[    0.000000]       .data : 0xc0678000 - 0xc071bcc0   ( 656 kB)=0A=
[    0.000000] SLUB: Genslabs=3D11, HWalign=3D32, Order=3D0-3, =
MinObjects=3D0, CPUs=3D1, Nodes=3D1=0A=
[    0.000000] Hierarchical RCU implementation.=0A=
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.=0A=
[    0.000000] 	Verbose stalled-CPUs detection is disabled.=0A=
[    0.000000] NR_IRQS:402=0A=
[    0.000000] Clocking rate (Crystal/Core/MPU): 26.0/332/500 MHz=0A=
[    0.000000] Reprogramming SDRC clock to 332000000 Hz=0A=
[    0.000000] GPMC revision 5.0=0A=
[    0.000000] IRQ: Found an INTC at 0xfa200000 (revision 4.0) with 96 =
interrupts=0A=
[    0.000000] Total of 96 interrupts on 1 active controller=0A=
[    0.000000] Could not get gpios_ick=0A=
[    0.000000] Could not get gpios_fck=0A=
[    0.000000] OMAP GPIO hardware version 2.5=0A=
[    0.000000] OMAP clockevent source: GPTIMER1 at 32768 Hz=0A=
[    0.000000] Console: colour dummy device 80x30=0A=
[    0.000000] Calibrating delay loop... 499.92 BogoMIPS (lpj=3D1949696)=0A=
[    0.000000] pid_max: default: 32768 minimum: 301=0A=
[    0.000000] Mount-cache hash table entries: 512=0A=
[    0.000000] Initializing cgroup subsys ns=0A=
[    0.000000] Initializing cgroup subsys cpuacct=0A=
[    0.000000] Initializing cgroup subsys memory=0A=
[    0.000000] Initializing cgroup subsys freezer=0A=
[    0.000000] Initializing cgroup subsys net_cls=0A=
[    0.000000] CPU: Testing write buffer coherency: ok=0A=
[    0.000000] Brought up 1 CPUs=0A=
[    0.000000] SMP: Total of 1 processors activated (499.92 BogoMIPS).=0A=
[    0.000000] device: 'platform': device_add=0A=
[    0.000000] PM: Adding info for No Bus:platform=0A=
[    0.000000] bus: 'platform': registered=0A=
[    0.000000] Registering sysdev class 'cpu'=0A=
[    0.000000] device: 'omap': device_add=0A=
[    0.000000] PM: Adding info for No Bus:omap=0A=
[    0.000000] regulator: core version 0.5=0A=
[    0.000000] device class 'regulator': registering=0A=
[    0.000000] NET: Registered protocol family 16=0A=
[    0.000000] device class 'bdi': registering=0A=
[    0.000000] device class 'gpio': registering=0A=
[    0.000000] device: 'gpiochip0': device_add=0A=
[    0.000000] PM: Adding info for No Bus:gpiochip0=0A=
[    0.000000] device: 'gpiochip32': device_add=0A=
[    0.000000] PM: Adding info for No Bus:gpiochip32=0A=
[    0.000000] device: 'gpiochip64': device_add=0A=
[    0.000000] PM: Adding info for No Bus:gpiochip64=0A=
[    0.000000] device: 'gpiochip96': device_add=0A=
[    0.000000] PM: Adding info for No Bus:gpiochip96=0A=
[    0.000000] device: 'gpiochip128': device_add=0A=
[    0.000000] PM: Adding info for No Bus:gpiochip128=0A=
[    0.000000] device: 'gpiochip160': device_add=0A=
[    0.000000] PM: Adding info for No Bus:gpiochip160=0A=
[    0.000000] device class 'backlight': registering=0A=
[    0.000000] device class 'tty': registering=0A=
[    0.000000] device class 'vtconsole': registering=0A=
[    0.000000] device: 'vtcon0': device_add=0A=
[    0.000000] PM: Adding info for No Bus:vtcon0=0A=
[    0.000000] bus: 'spi': registered=0A=
[    0.000000] device class 'spi_master': registering=0A=
[    0.000000] bus: 'i2c': registered=0A=
[    0.000000] bus: 'i2c': add driver dummy=0A=
[    0.000000] Registering platform device 'i2c_omap.1'. Parent at omap=0A=
[    0.000000] device: 'i2c_omap.1': device_add=0A=
[    0.000000] bus: 'platform': add device i2c_omap.1=0A=
[    0.000000] PM: Adding info for platform:i2c_omap.1=0A=
[    0.000000] mux: Setting signal i2c2_scl.i2c2_scl.i2c2_scl 0x0118 -> =
0x0100=0A=
[    0.000000] mux: Setting signal i2c2_sda.i2c2_sda.i2c2_sda 0x0118 -> =
0x0100=0A=
[    0.000000] Registering platform device 'i2c_omap.2'. Parent at omap=0A=
[    0.000000] device: 'i2c_omap.2': device_add=0A=
[    0.000000] bus: 'platform': add device i2c_omap.2=0A=
[    0.000000] PM: Adding info for platform:i2c_omap.2=0A=
[    0.000000] mux: Setting signal i2c3_scl.i2c3_scl.i2c3_scl 0x0118 -> =
0x0100=0A=
[    0.000000] mux: Setting signal i2c3_sda.i2c3_sda.i2c3_sda 0x0118 -> =
0x0100=0A=
[    0.000000] Registering platform device 'i2c_omap.3'. Parent at omap=0A=
[    0.000000] device: 'i2c_omap.3': device_add=0A=
[    0.000000] bus: 'platform': add device i2c_omap.3=0A=
[    0.000000] PM: Adding info for platform:i2c_omap.3=0A=
[    0.000000] Registering platform device 'omapdss'. Parent at platform=0A=
[    0.000000] device: 'omapdss': device_add=0A=
[    0.000000] bus: 'platform': add device omapdss=0A=
[    0.000000] PM: Adding info for platform:omapdss=0A=
[    0.000000] Registering platform device 'wl1271_data'. Parent at =
platform=0A=
[    0.000000] device: 'wl1271_data': device_add=0A=
[    0.000000] bus: 'platform': add device wl1271_data=0A=
[    0.000000] PM: Adding info for platform:wl1271_data=0A=
[    0.000000] Registering platform device 'reg-fixed-voltage.1'. Parent =
at platform=0A=
[    0.000000] device: 'reg-fixed-voltage.1': device_add=0A=
[    0.000000] bus: 'platform': add device reg-fixed-voltage.1=0A=
[    0.000000] PM: Adding info for platform:reg-fixed-voltage.1=0A=
[    0.000000] Registering platform device 'omap-hsuart.0'. Parent at =
omap=0A=
[    0.000000] device: 'omap-hsuart.0': device_add=0A=
[    0.000000] bus: 'platform': add device omap-hsuart.0=0A=
[    0.000000] PM: Adding info for platform:omap-hsuart.0=0A=
[    0.000000] Registering platform device 'omap-hsuart.1'. Parent at =
omap=0A=
[    0.000000] device: 'omap-hsuart.1': device_add=0A=
[    0.000000] bus: 'platform': add device omap-hsuart.1=0A=
[    0.000000] PM: Adding info for platform:omap-hsuart.1=0A=
[    0.000000] Registering platform device 'omap-hsuart.2'. Parent at =
omap=0A=
[    0.000000] device: 'omap-hsuart.2': device_add=0A=
[    0.000000] bus: 'platform': add device omap-hsuart.2=0A=
[    0.000000] PM: Adding info for platform:omap-hsuart.2=0A=
[    0.000000] mux: Setting signal etk_d8.gpio22 0x0100 -> 0x011c=0A=
[    0.000000] mux: Setting signal gpmc_nbe1.gpio61 0x0118 -> 0x011c=0A=
[    0.000000] mux: Setting signal etk_d7.gpio21 0x0100 -> 0x011c=0A=
[    0.000000] Registering platform device 'smsc911x'. Parent at platform=0A=
[    0.000000] device: 'smsc911x': device_add=0A=
[    0.000000] bus: 'platform': add device smsc911x=0A=
[    0.000000] PM: Adding info for platform:smsc911x=0A=
[    0.000000] Registering platform device 'arm-pmu.0'. Parent at =
platform=0A=
[    0.000000] device: 'arm-pmu.0': device_add=0A=
[    0.000000] bus: 'platform': add device arm-pmu.0=0A=
[    0.000000] PM: Adding info for platform:arm-pmu.0=0A=
[    0.000000] Registering platform device 'omap-mcbsp.1'. Parent at =
platform=0A=
[    0.000000] device: 'omap-mcbsp.1': device_add=0A=
[    0.000000] bus: 'platform': add device omap-mcbsp.1=0A=
[    0.000000] PM: Adding info for platform:omap-mcbsp.1=0A=
[    0.000000] Registering platform device 'omap-mcbsp.2'. Parent at =
platform=0A=
[    0.000000] device: 'omap-mcbsp.2': device_add=0A=
[    0.000000] bus: 'platform': add device omap-mcbsp.2=0A=
[    0.000000] PM: Adding info for platform:omap-mcbsp.2=0A=
[    0.000000] Registering platform device 'omap-mcbsp.3'. Parent at =
platform=0A=
[    0.000000] device: 'omap-mcbsp.3': device_add=0A=
[    0.000000] bus: 'platform': add device omap-mcbsp.3=0A=
[    0.000000] PM: Adding info for platform:omap-mcbsp.3=0A=
[    0.000000] Registering platform device 'omap-mcbsp.4'. Parent at =
platform=0A=
[    0.000000] device: 'omap-mcbsp.4': device_add=0A=
[    0.000000] bus: 'platform': add device omap-mcbsp.4=0A=
[    0.000000] PM: Adding info for platform:omap-mcbsp.4=0A=
[    0.000000] Registering platform device 'omap-mcbsp.5'. Parent at =
platform=0A=
[    0.000000] device: 'omap-mcbsp.5': device_add=0A=
[    0.000000] bus: 'platform': add device omap-mcbsp.5=0A=
[    0.000000] PM: Adding info for platform:omap-mcbsp.5=0A=
[    0.000000] bus: 'platform': add driver omap-mcbsp=0A=
[    0.000000] bus: 'platform': driver_probe_device: matched device =
omap-mcbsp.1 with driver omap-mcbsp=0A=
[    0.000000] bus: 'platform': really_probe: probing driver omap-mcbsp =
with device omap-mcbsp.1=0A=
[    0.000000] driver: 'omap-mcbsp.1': driver_bound: bound to device =
'omap-mcbsp'=0A=
[    0.000000] bus: 'platform': really_probe: bound device omap-mcbsp.1 =
to driver omap-mcbsp=0A=
[    0.000000] bus: 'platform': driver_probe_device: matched device =
omap-mcbsp.2 with driver omap-mcbsp=0A=
[    0.000000] bus: 'platform': really_probe: probing driver omap-mcbsp =
with device omap-mcbsp.2=0A=
[    0.000000] driver: 'omap-mcbsp.2': driver_bound: bound to device =
'omap-mcbsp'=0A=
[    0.000000] bus: 'platform': really_probe: bound device omap-mcbsp.2 =
to driver omap-mcbsp=0A=
[    0.000000] bus: 'platform': driver_probe_device: matched device =
omap-mcbsp.3 with driver omap-mcbsp=0A=
[    0.000000] bus: 'platform': really_probe: probing driver omap-mcbsp =
with device omap-mcbsp.3=0A=
[    0.000000] driver: 'omap-mcbsp.3': driver_bound: bound to device =
'omap-mcbsp'=0A=
[    0.000000] bus: 'platform': really_probe: bound device omap-mcbsp.3 =
to driver omap-mcbsp=0A=
[    0.000000] bus: 'platform': driver_probe_device: matched device =
omap-mcbsp.4 with driver omap-mcbsp=0A=
[    0.000000] bus: 'platform': really_probe: probing driver omap-mcbsp =
with device omap-mcbsp.4=0A=
[    0.000000] driver: 'omap-mcbsp.4': driver_bound: bound to device =
'omap-mcbsp'=0A=
[    0.000000] bus: 'platform': really_probe: bound device omap-mcbsp.4 =
to driver omap-mcbsp=0A=
[    0.000000] bus: 'platform': driver_probe_device: matched device =
omap-mcbsp.5 with driver omap-mcbsp=0A=
[    0.000000] bus: 'platform': really_probe: probing driver omap-mcbsp =
with device omap-mcbsp.5=0A=
[    0.000000] driver: 'omap-mcbsp.5': driver_bound: bound to device =
'omap-mcbsp'=0A=
[    0.000000] bus: 'platform': really_probe: bound device omap-mcbsp.5 =
to driver omap-mcbsp=0A=
[    0.000000] Registering platform device 'omap_rng'. Parent at platform=0A=
[    0.000000] device: 'omap_rng': device_add=0A=
[    0.000000] bus: 'platform': add device omap_rng=0A=
[    0.000000] PM: Adding info for platform:omap_rng=0A=
[    0.000000] OMAP DMA hardware revision 4.0=0A=
[    0.000000] Registering sysdev class 'gpio'=0A=
[    0.000000] Registering sys device of class 'gpio'=0A=
[    0.000000] Registering sys device 'gpio0'=0A=
[    0.000030] Registering sys device of class 'cpu'=0A=
[    0.000061] Registering sys device 'cpu0'=0A=
[    0.004852] device: 'default': device_add=0A=
[    0.004943] PM: Adding info for No Bus:default=0A=
[    0.005523] bio: create slab <bio-0> at 0=0A=
[    0.005615] device class 'block': registering=0A=
[    0.005920] bus: 'platform': add driver twl4030_gpio=0A=
[    0.006072] device class 'graphics': registering=0A=
[    0.006134] bus: 'platform': add driver reg-fixed-voltage=0A=
[    0.006195] bus: 'platform': driver_probe_device: matched device =
reg-fixed-voltage.1 with driver reg-fixed-voltage=0A=
[    0.006225] bus: 'platform': really_probe: probing driver =
reg-fixed-voltage with device reg-fixed-voltage.1=0A=
[    0.006286] device: 'regulator.0': device_add=0A=
[    0.006378] PM: Adding info for No Bus:regulator.0=0A=
[    0.006439] machine_constraints_voltage: override 'vwlan' min_uV, 1 =
-> 1800000=0A=
[    0.006469] machine_constraints_voltage: override 'vwlan' max_uV, =
2147483647 -> 1800000=0A=
[    0.006500] regulator: vwlan: 1800 mV =0A=
[    0.006530] reg-fixed-voltage reg-fixed-voltage.1: vwlan supplying =
1800000uV=0A=
[    0.006561] driver: 'reg-fixed-voltage.1': driver_bound: bound to =
device 'reg-fixed-voltage'=0A=
[    0.006591] bus: 'platform': really_probe: bound device =
reg-fixed-voltage.1 to driver reg-fixed-voltage=0A=
[    0.006652] bus: 'platform': add driver twl_reg=0A=
[    0.006774] device class 'misc': registering=0A=
[    0.006866] bus: 'i2c': add driver twl=0A=
[    0.007263] device class 'scsi_host': registering=0A=
[    0.007415] bus: 'scsi': registered=0A=
[    0.007446] device class 'scsi_device': registering=0A=
[    0.007537] SCSI subsystem initialized=0A=
[    0.007568] device class 'mdio_bus': registering=0A=
[    0.007690] bus: 'mdio_bus': registered=0A=
[    0.007690] bus: 'mdio_bus': add driver Generic PHY=0A=
[    0.007843] bus: 'serio': registered=0A=
[    0.008056] device class 'input': registering=0A=
[    0.008178] bus: 'platform': add driver i2c_omap=0A=
[    0.008209] bus: 'platform': driver_probe_device: matched device =
i2c_omap.1 with driver i2c_omap=0A=
[    0.008239] bus: 'platform': really_probe: probing driver i2c_omap =
with device i2c_omap.1=0A=
[    0.008300] i2c_omap i2c_omap.1: __pm_runtime_resume()!=0A=
[    0.008331] omap_device: i2c_omap.1: new worst case activate latency =
0: 30517=0A=
[    0.008361] i2c_omap i2c_omap.1: __pm_runtime_resume() returns 0!=0A=
[    0.020233] i2c_omap i2c_omap.1: bus 1 rev3.12 at 2600 kHz=0A=
[    0.020294] device: 'i2c-1': device_add=0A=
[    0.020324] bus: 'i2c': add device i2c-1=0A=
[    0.020385] PM: Adding info for i2c:i2c-1=0A=
[    0.020477] device: '1-0048': device_add=0A=
[    0.020538] bus: 'i2c': add device 1-0048=0A=
[    0.020568] PM: Adding info for i2c:1-0048=0A=
[    0.020629] bus: 'i2c': driver_probe_device: matched device 1-0048 =
with driver twl=0A=
[    0.020660] bus: 'i2c': really_probe: probing driver twl with device =
1-0048=0A=
[    0.020721] device: '1-0049': device_add=0A=
[    0.020751] bus: 'i2c': add device 1-0049=0A=
[    0.020812] PM: Adding info for i2c:1-0049=0A=
[    0.020874] bus: 'i2c': driver_probe_device: matched device 1-0049 =
with driver dummy=0A=
[    0.020874] bus: 'i2c': really_probe: probing driver dummy with =
device 1-0049=0A=
[    0.020904] driver: '1-0049': driver_bound: bound to device 'dummy'=0A=
[    0.020935] bus: 'i2c': really_probe: bound device 1-0049 to driver =
dummy=0A=
[    0.020965] device: '1-004a': device_add=0A=
[    0.021026] bus: 'i2c': add device 1-004a=0A=
[    0.021057] PM: Adding info for i2c:1-004a=0A=
[    0.021118] bus: 'i2c': driver_probe_device: matched device 1-004a =
with driver dummy=0A=
[    0.021148] bus: 'i2c': really_probe: probing driver dummy with =
device 1-004a=0A=
[    0.021179] driver: '1-004a': driver_bound: bound to device 'dummy'=0A=
[    0.021179] bus: 'i2c': really_probe: bound device 1-004a to driver =
dummy=0A=
[    0.021240] device: '1-004b': device_add=0A=
[    0.021270] bus: 'i2c': add device 1-004b=0A=
[    0.021331] PM: Adding info for i2c:1-004b=0A=
[    0.021362] bus: 'i2c': driver_probe_device: matched device 1-004b =
with driver dummy=0A=
[    0.021392] bus: 'i2c': really_probe: probing driver dummy with =
device 1-004b=0A=
[    0.021423] driver: '1-004b': driver_bound: bound to device 'dummy'=0A=
[    0.021453] bus: 'i2c': really_probe: bound device 1-004b to driver =
dummy=0A=
[    0.021514] i2c_omap i2c_omap.1: __pm_runtime_resume()!=0A=
[    0.021545] i2c_omap i2c_omap.1: __pm_runtime_resume() returns 1!=0A=
[    0.021636] i2c_omap i2c_omap.1: __pm_runtime_resume()!=0A=
[    0.021667] i2c_omap i2c_omap.1: __pm_runtime_resume() returns 1!=0A=
[    0.021759] i2c_omap i2c_omap.1: __pm_runtime_resume()!=0A=
[    0.021759] i2c_omap i2c_omap.1: __pm_runtime_resume() returns 1!=0A=
[    0.021850] i2c_omap i2c_omap.1: __pm_runtime_resume()!=0A=
[    0.021881] i2c_omap i2c_omap.1: __pm_runtime_resume() returns 1!=0A=
[    0.021972] i2c_omap i2c_omap.1: __pm_runtime_resume()!=0A=
[    0.022003] i2c_omap i2c_omap.1: __pm_runtime_resume() returns 1!=0A=
[    0.022094] i2c_omap i2c_omap.1: __pm_runtime_resume()!=0A=
[    0.022125] i2c_omap i2c_omap.1: __pm_runtime_resume() returns 1!=0A=
[    0.022216] i2c_omap i2c_omap.1: __pm_runtime_resume()!=0A=
[    0.022216] i2c_omap i2c_omap.1: __pm_runtime_resume() returns 1!=0A=
[    0.022308] i2c_omap i2c_omap.1: __pm_runtime_resume()!=0A=
[    0.022338] i2c_omap i2c_omap.1: __pm_runtime_resume() returns 1!=0A=
[    0.022430] i2c_omap i2c_omap.1: __pm_runtime_resume()!=0A=
[    0.022430] i2c_omap i2c_omap.1: __pm_runtime_resume() returns 1!=0A=
[    0.022521] i2c_omap i2c_omap.1: __pm_runtime_resume()!=0A=
[    0.022552] i2c_omap i2c_omap.1: __pm_runtime_resume() returns 1!=0A=
[    0.022644] i2c_omap i2c_omap.1: __pm_runtime_resume()!=0A=
[    0.022644] i2c_omap i2c_omap.1: __pm_runtime_resume() returns 1!=0A=
[    0.022735] i2c_omap i2c_omap.1: __pm_runtime_resume()!=0A=
[    0.022766] i2c_omap i2c_omap.1: __pm_runtime_resume() returns 1!=0A=
[    0.022857] i2c_omap i2c_omap.1: __pm_runtime_resume()!=0A=
[    0.022888] i2c_omap i2c_omap.1: __pm_runtime_resume() returns 1!=0A=
[    0.023010] i2c_omap i2c_omap.1: __pm_runtime_resume()!=0A=
[    0.023010] i2c_omap i2c_omap.1: __pm_runtime_resume() returns 1!=0A=
[    0.023132] i2c_omap i2c_omap.1: __pm_runtime_resume()!=0A=
[    0.023162] i2c_omap i2c_omap.1: __pm_runtime_resume() returns 1!=0A=
[    0.023284] i2c_omap i2c_omap.1: __pm_runtime_resume()!=0A=
[    0.023284] i2c_omap i2c_omap.1: __pm_runtime_resume() returns 1!=0A=
[    0.023406] i2c_omap i2c_omap.1: __pm_runtime_resume()!=0A=
[    0.023437] i2c_omap i2c_omap.1: __pm_runtime_resume() returns 1!=0A=
[    0.023529] i2c_omap i2c_omap.1: __pm_runtime_resume()!=0A=
[    0.023559] i2c_omap i2c_omap.1: __pm_runtime_resume() returns 1!=0A=
[    0.023651] i2c_omap i2c_omap.1: __pm_runtime_resume()!=0A=
[    0.023681] i2c_omap i2c_omap.1: __pm_runtime_resume() returns 1!=0A=
[    0.023803] i2c_omap i2c_omap.1: __pm_runtime_resume()!=0A=
[    0.023803] i2c_omap i2c_omap.1: __pm_runtime_resume() returns 1!=0A=
[    0.023895] i2c_omap i2c_omap.1: __pm_runtime_resume()!=0A=
[    0.023925] i2c_omap i2c_omap.1: __pm_runtime_resume() returns 1!=0A=
[    0.024047] i2c_omap i2c_omap.1: __pm_runtime_resume()!=0A=
[    0.024047] i2c_omap i2c_omap.1: __pm_runtime_resume() returns 1!=0A=
[    0.024139] i2c_omap i2c_omap.1: __pm_runtime_resume()!=0A=
[    0.024169] i2c_omap i2c_omap.1: __pm_runtime_resume() returns 1!=0A=
[    0.024291] i2c_omap i2c_omap.1: __pm_runtime_resume()!=0A=
[    0.024291] i2c_omap i2c_omap.1: __pm_runtime_resume() returns 1!=0A=
[    0.024383] i2c_omap i2c_omap.1: __pm_runtime_resume()!=0A=
[    0.024414] i2c_omap i2c_omap.1: __pm_runtime_resume() returns 1!=0A=
[    0.024505] i2c_omap i2c_omap.1: __pm_runtime_resume()!=0A=
[    0.024536] i2c_omap i2c_omap.1: __pm_runtime_resume() returns 1!=0A=
[    0.024841] twl4030: PIH (irq 7) chaining IRQs 368..375=0A=
[    0.024902] twl4030: power (irq 373) chaining IRQs 376..383=0A=
[    0.025085] i2c_omap i2c_omap.1: __pm_runtime_resume()!=0A=
[    0.025115] i2c_omap i2c_omap.1: __pm_runtime_resume() returns 1!=0A=
[    0.025238] i2c_omap i2c_omap.1: __pm_runtime_resume()!=0A=
[    0.025238] i2c_omap i2c_omap.1: __pm_runtime_resume() returns 1!=0A=
[    0.025360] Registering platform device 'twl4030_gpio'. Parent at =
1-0049=0A=
[    0.025390] device: 'twl4030_gpio': device_add=0A=
[    0.025421] bus: 'platform': add device twl4030_gpio=0A=
[    0.025482] PM: Adding info for platform:twl4030_gpio=0A=
[    0.025573] bus: 'platform': driver_probe_device: matched device =
twl4030_gpio with driver twl4030_gpio=0A=
[    0.025573] bus: 'platform': really_probe: probing driver =
twl4030_gpio with device twl4030_gpio=0A=
[    0.025665] twl4030: gpio (irq 368) chaining IRQs 384..401=0A=
[    0.025695] i2c_omap i2c_omap.1: __pm_runtime_resume()!=0A=
[    0.025695] i2c_omap i2c_omap.1: __pm_runtime_resume() returns 1!=0A=
[    0.025817] i2c_omap i2c_omap.1: __pm_runtime_resume()!=0A=
[    0.025848] i2c_omap i2c_omap.1: __pm_runtime_resume() returns 1!=0A=
[    0.025970] device: 'gpiochip192': device_add=0A=
[    0.026062] PM: Adding info for No Bus:gpiochip192=0A=
[    0.026214] mux: Setting signal gpmc_wait1.gpio63 0x0118 -> 0x0104=0A=
[    0.026245] mux: Setting signal gpmc_wait1.gpio63 0x0104 -> 0x011c=0A=
[    0.026397] mux: Setting signal sdmmc1_clk.sdmmc1_clk 0x0018 -> 0x0118=0A=
[    0.026519] mux: Setting signal sdmmc1_cmd.sdmmc1_cmd 0x0118 -> 0x0118=0A=
[    0.026611] mux: Setting signal sdmmc1_dat0.sdmmc1_dat0 0x0118 -> =
0x0118=0A=
[    0.026702] mux: Setting signal sdmmc1_dat1.sdmmc1_dat1 0x0118 -> =
0x0118=0A=
[    0.026824] mux: Setting signal sdmmc1_dat2.sdmmc1_dat2 0x0118 -> =
0x0118=0A=
[    0.026916] mux: Setting signal sdmmc1_dat3.sdmmc1_dat3 0x0118 -> =
0x0118=0A=
[    0.026977] Registering platform device 'mmci-omap-hs.0'. Parent at =
platform=0A=
[    0.027008] device: 'mmci-omap-hs.0': device_add=0A=
[    0.027038] bus: 'platform': add device mmci-omap-hs.0=0A=
[    0.027130] PM: Adding info for platform:mmci-omap-hs.0=0A=
[    0.027252] mux: Setting signal sdmmc2_clk.sdmmc2_clk 0x0100 -> 0x0118=0A=
[    0.027374] mux: Setting signal sdmmc2_cmd.sdmmc2_cmd 0x0118 -> 0x0118=0A=
[    0.027465] mux: Setting signal sdmmc2_dat0.sdmmc2_dat0 0x0118 -> =
0x0118=0A=
[    0.027557] mux: Setting signal sdmmc2_dat1.sdmmc2_dat1 0x0118 -> =
0x0118=0A=
[    0.027679] mux: Setting signal sdmmc2_dat2.sdmmc2_dat2 0x0118 -> =
0x0118=0A=
[    0.027770] mux: Setting signal sdmmc2_dat3.sdmmc2_dat3 0x0118 -> =
0x0118=0A=
[    0.027801] Registering platform device 'mmci-omap-hs.1'. Parent at =
platform=0A=
[    0.027832] device: 'mmci-omap-hs.1': device_add=0A=
[    0.027862] bus: 'platform': add device mmci-omap-hs.1=0A=
[    0.027984] PM: Adding info for platform:mmci-omap-hs.1=0A=
[    0.028076] i2c_omap i2c_omap.1: __pm_runtime_resume()!=0A=
[    0.028106] i2c_omap i2c_omap.1: __pm_runtime_resume() returns 1!=0A=
[    0.028228] i2c_omap i2c_omap.1: __pm_runtime_resume()!=0A=
[    0.028228] i2c_omap i2c_omap.1: __pm_runtime_resume() returns 1!=0A=
[    0.028320] i2c_omap i2c_omap.1: __pm_runtime_resume()!=0A=
[    0.028350] i2c_omap i2c_omap.1: __pm_runtime_resume() returns 1!=0A=
[    0.028472] i2c_omap i2c_omap.1: __pm_runtime_resume()!=0A=
[    0.028503] i2c_omap i2c_omap.1: __pm_runtime_resume() returns 1!=0A=
[    0.028594] i2c_omap i2c_omap.1: __pm_runtime_resume()!=0A=
[    0.028594] i2c_omap i2c_omap.1: __pm_runtime_resume() returns 1!=0A=
[    0.028717] i2c_omap i2c_omap.1: __pm_runtime_resume()!=0A=
[    0.028717] i2c_omap i2c_omap.1: __pm_runtime_resume() returns 1!=0A=
[    0.028808] i2c_omap i2c_omap.1: __pm_runtime_resume()!=0A=
[    0.028839] i2c_omap i2c_omap.1: __pm_runtime_resume() returns 1!=0A=
[    0.028930] i2c_omap i2c_omap.1: __pm_runtime_resume()!=0A=
[    0.028961] i2c_omap i2c_omap.1: __pm_runtime_resume() returns 1!=0A=
[    0.029083] i2c_omap i2c_omap.1: __pm_runtime_resume()!=0A=
[    0.029083] i2c_omap i2c_omap.1: __pm_runtime_resume() returns 1!=0A=
[    0.029205] Registering platform device 'leds-gpio.211'. Parent at =
platform=0A=
[    0.029205] device: 'leds-gpio.211': device_add=0A=
[    0.029266] bus: 'platform': add device leds-gpio.211=0A=
[    0.029327] PM: Adding info for platform:leds-gpio.211=0A=
[    0.029388] driver: 'twl4030_gpio': driver_bound: bound to device =
'twl4030_gpio'=0A=
[    0.029418] bus: 'platform': really_probe: bound device twl4030_gpio =
to driver twl4030_gpio=0A=
[    0.029449] Registering platform device 'twl4030_pwrbutton'. Parent =
at 1-0049=0A=
[    0.029479] device: 'twl4030_pwrbutton': device_add=0A=
[    0.029510] bus: 'platform': add device twl4030_pwrbutton=0A=
[    0.029571] PM: Adding info for platform:twl4030_pwrbutton=0A=
[    0.029632] Registering platform device 'twl_reg.6'. Parent at 1-004b=0A=
[    0.029663] device: 'twl_reg.6': device_add=0A=
[    0.029693] bus: 'platform': add device twl_reg.6=0A=
[    0.029754] PM: Adding info for platform:twl_reg.6=0A=
[    0.029815] bus: 'platform': driver_probe_device: matched device =
twl_reg.6 with driver twl_reg=0A=
[    0.029815] bus: 'platform': really_probe: probing driver twl_reg =
with device twl_reg.6=0A=
[    0.029876] device: 'regulator.1': device_add=0A=
[    0.029968] PM: Adding info for No Bus:regulator.1=0A=
[    0.030029] i2c_omap i2c_omap.1: __pm_runtime_resume()!=0A=
[    0.030059] i2c_omap i2c_omap.1: __pm_runtime_resume() returns 1!=0A=
[    0.030181] regulator: VMMC1: 1850 <--> 3150 mV at 3000 mV normal =
standby=0A=
[    0.030242] i2c_omap i2c_omap.1: __pm_runtime_resume()!=0A=
[    0.030273] i2c_omap i2c_omap.1: __pm_runtime_resume() returns 1!=0A=
[    0.030364] driver: 'twl_reg.6': driver_bound: bound to device =
'twl_reg'=0A=
[    0.030395] bus: 'platform': really_probe: bound device twl_reg.6 to =
driver twl_reg=0A=
[    0.030426] Registering platform device 'twl_reg.3'. Parent at 1-004b=0A=
[    0.030456] device: 'twl_reg.3': device_add=0A=
[    0.030487] bus: 'platform': add device twl_reg.3=0A=
[    0.030548] PM: Adding info for platform:twl_reg.3=0A=
[    0.030609] bus: 'platform': driver_probe_device: matched device =
twl_reg.3 with driver twl_reg=0A=
[    0.030639] bus: 'platform': really_probe: probing driver twl_reg =
with device twl_reg.3=0A=
[    0.030700] device: 'regulator.2': device_add=0A=
[    0.030792] PM: Adding info for No Bus:regulator.2=0A=
[    0.030883] i2c_omap i2c_omap.1: __pm_runtime_resume()!=0A=
[    0.030883] i2c_omap i2c_omap.1: __pm_runtime_resume() returns 1!=0A=
[    0.031005] regulator: VDAC: 1800 mV normal standby=0A=
[    0.031036] i2c_omap i2c_omap.1: __pm_runtime_resume()!=0A=
[    0.031066] i2c_omap i2c_omap.1: __pm_runtime_resume() returns 1!=0A=
[    0.031158] driver: 'twl_reg.3': driver_bound: bound to device =
'twl_reg'=0A=
[    0.031188] bus: 'platform': really_probe: bound device twl_reg.3 to =
driver twl_reg=0A=
[    0.031219] Registering platform device 'twl_reg.5'. Parent at 1-004b=0A=
[    0.031250] device: 'twl_reg.5': device_add=0A=
[    0.031280] bus: 'platform': add device twl_reg.5=0A=
[    0.031341] PM: Adding info for platform:twl_reg.5=0A=
[    0.031402] bus: 'platform': driver_probe_device: matched device =
twl_reg.5 with driver twl_reg=0A=
[    0.031433] bus: 'platform': really_probe: probing driver twl_reg =
with device twl_reg.5=0A=
[    0.031463] device: 'regulator.3': device_add=0A=
[    0.031555] PM: Adding info for No Bus:regulator.3=0A=
[    0.031616] i2c_omap i2c_omap.1: __pm_runtime_resume()!=0A=
[    0.031646] i2c_omap i2c_omap.1: __pm_runtime_resume() returns 1!=0A=
[    0.031738] regulator: VPLL2: 1800 mV normal standby=0A=
[    0.031799] i2c_omap i2c_omap.1: __pm_runtime_resume()!=0A=
[    0.031829] i2c_omap i2c_omap.1: __pm_runtime_resume() returns 1!=0A=
[    0.031921] driver: 'twl_reg.5': driver_bound: bound to device =
'twl_reg'=0A=
[    0.031921] bus: 'platform': really_probe: bound device twl_reg.5 to =
driver twl_reg=0A=
[    0.031982] Registering platform device 'twl_reg.8'. Parent at 1-004b=0A=
[    0.031982] device: 'twl_reg.8': device_add=0A=
[    0.032012] bus: 'platform': add device twl_reg.8=0A=
[    0.032073] PM: Adding info for platform:twl_reg.8=0A=
[    0.032165] bus: 'platform': driver_probe_device: matched device =
twl_reg.8 with driver twl_reg=0A=
[    0.032165] bus: 'platform': really_probe: probing driver twl_reg =
with device twl_reg.8=0A=
[    0.032226] device: 'regulator.4': device_add=0A=
[    0.032318] PM: Adding info for No Bus:regulator.4=0A=
[    0.032379] i2c_omap i2c_omap.1: __pm_runtime_resume()!=0A=
[    0.032409] i2c_omap i2c_omap.1: __pm_runtime_resume() returns 1!=0A=
[    0.032531] regulator: VSIM: 1800 <--> 3000 mV at 1800 mV normal =
standby=0A=
[    0.032592] i2c_omap i2c_omap.1: __pm_runtime_resume()!=0A=
[    0.032623] i2c_omap i2c_omap.1: __pm_runtime_resume() returns 1!=0A=
[    0.032714] driver: 'twl_reg.8': driver_bound: bound to device =
'twl_reg'=0A=
[    0.032714] bus: 'platform': really_probe: bound device twl_reg.8 to =
driver twl_reg=0A=
[    0.032745] driver: '1-0048': driver_bound: bound to device 'twl'=0A=
[    0.032775] bus: 'i2c': really_probe: bound device 1-0048 to driver =
twl=0A=
[    0.032806] driver: 'i2c_omap.1': driver_bound: bound to device =
'i2c_omap'=0A=
[    0.032836] bus: 'platform': really_probe: bound device i2c_omap.1 to =
driver i2c_omap=0A=
[    0.032867] i2c_omap i2c_omap.1: __pm_runtime_suspend()!=0A=
[    0.032897] omap_device: i2c_omap.1: new worst case deactivate =
latency 0: 30517=0A=
[    0.032928] i2c_omap i2c_omap.1: __pm_runtime_suspend() returns 0!=0A=
[    0.032958] bus: 'platform': driver_probe_device: matched device =
i2c_omap.2 with driver i2c_omap=0A=
[    0.032958] bus: 'platform': really_probe: probing driver i2c_omap =
with device i2c_omap.2=0A=
[    0.033020] i2c_omap i2c_omap.2: __pm_runtime_resume()!=0A=
[    0.033050] i2c_omap i2c_omap.2: __pm_runtime_resume() returns 0!=0A=
[    0.033142] i2c_omap i2c_omap.2: bus 2 rev3.12 at 400 kHz=0A=
[    0.033172] device: 'i2c-2': device_add=0A=
[    0.033233] bus: 'i2c': add device i2c-2=0A=
[    0.033294] PM: Adding info for i2c:i2c-2=0A=
[    0.033355] driver: 'i2c_omap.2': driver_bound: bound to device =
'i2c_omap'=0A=
[    0.033386] bus: 'platform': really_probe: bound device i2c_omap.2 to =
driver i2c_omap=0A=
[    0.033416] i2c_omap i2c_omap.2: __pm_runtime_suspend()!=0A=
[    0.033447] i2c_omap i2c_omap.2: __pm_runtime_suspend() returns 0!=0A=
[    0.033447] bus: 'platform': driver_probe_device: matched device =
i2c_omap.3 with driver i2c_omap=0A=
[    0.033477] bus: 'platform': really_probe: probing driver i2c_omap =
with device i2c_omap.3=0A=
[    0.033538] i2c_omap i2c_omap.3: __pm_runtime_resume()!=0A=
[    0.033569] i2c_omap i2c_omap.3: __pm_runtime_resume() returns 0!=0A=
[    0.043640] i2c_omap i2c_omap.3: bus 3 rev3.12 at 400 kHz=0A=
[    0.043670] device: 'i2c-3': device_add=0A=
[    0.043701] bus: 'i2c': add device i2c-3=0A=
[    0.043762] PM: Adding info for i2c:i2c-3=0A=
[    0.043853] driver: 'i2c_omap.3': driver_bound: bound to device =
'i2c_omap'=0A=
[    0.043853] bus: 'platform': really_probe: bound device i2c_omap.3 to =
driver i2c_omap=0A=
[    0.043884] i2c_omap i2c_omap.3: __pm_runtime_suspend()!=0A=
[    0.043914] i2c_omap i2c_omap.3: __pm_runtime_suspend() returns 0!=0A=
[    0.044036] AIRVOD  mmc_init        drivers/mmc/core/core.c=0A=
[    0.044342] bus: 'mmc': registered=0A=
[    0.044372] device class 'mmc_host': registering=0A=
[    0.044525] bus: 'sdio': registered=0A=
[    0.044555] device class 'leds': registering=0A=
[    0.044647] device class 'net': registering=0A=
[    0.044799] device: 'lo': device_add=0A=
[    0.045104] PM: Adding info for No Bus:lo=0A=
[    0.045379] NET: Registered protocol family 8=0A=
[    0.045410] NET: Registered protocol family 20=0A=
[    0.045440] device class 'atm': registering=0A=
[    0.045532] device class 'ieee80211': registering=0A=
[    0.045745] Registering platform device 'regulatory.0'. Parent at =
platform=0A=
[    0.045776] device: 'regulatory.0': device_add=0A=
[    0.045806] bus: 'platform': add device regulatory.0=0A=
[    0.045898] PM: Adding info for platform:regulatory.0=0A=
[    0.045989] cfg80211: Calling CRDA to update world regulatory domain=0A=
[    0.047271] device class 'rfkill': registering=0A=
[    0.047363] device: 'rfkill': device_add=0A=
[    0.047454] PM: Adding info for No Bus:rfkill=0A=
[    0.047515] device class 'ieee802154': registering=0A=
[    0.047668] Switching to clocksource 32k_counter=0A=
[    0.063201] device class 'mem': registering=0A=
[    0.063323] device: 'mem': device_add=0A=
[    0.063446] PM: Adding info for No Bus:mem=0A=
[    0.063629] device: 'null': device_add=0A=
[    0.063751] PM: Adding info for No Bus:null=0A=
[    0.063812] device: 'zero': device_add=0A=
[    0.063903] PM: Adding info for No Bus:zero=0A=
[    0.063964] device: 'full': device_add=0A=
[    0.064056] PM: Adding info for No Bus:full=0A=
[    0.064147] device: 'random': device_add=0A=
[    0.064208] PM: Adding info for No Bus:random=0A=
[    0.064300] device: 'urandom': device_add=0A=
[    0.064361] PM: Adding info for No Bus:urandom=0A=
[    0.064453] device: 'kmsg': device_add=0A=
[    0.064514] PM: Adding info for No Bus:kmsg=0A=
[    0.064605] device: 'tty': device_add=0A=
[    0.064697] PM: Adding info for No Bus:tty=0A=
[    0.064788] device: 'console': device_add=0A=
[    0.064880] PM: Adding info for No Bus:console=0A=
[    0.064941] device: 'tty0': device_add=0A=
[    0.065032] PM: Adding info for No Bus:tty0=0A=
[    0.065093] device class 'vc': registering=0A=
[    0.065155] device: 'vcs': device_add=0A=
[    0.065277] PM: Adding info for No Bus:vcs=0A=
[    0.065338] device: 'vcsa': device_add=0A=
[    0.065399] PM: Adding info for No Bus:vcsa=0A=
[    0.065490] device: 'vcs1': device_add=0A=
[    0.065582] PM: Adding info for No Bus:vcs1=0A=
[    0.065643] device: 'vcsa1': device_add=0A=
[    0.065734] PM: Adding info for No Bus:vcsa1=0A=
[    0.065795] device: 'tty1': device_add=0A=
[    0.065917] PM: Adding info for No Bus:tty1=0A=
[    0.065979] device: 'tty2': device_add=0A=
[    0.066070] PM: Adding info for No Bus:tty2=0A=
[    0.066131] device: 'tty3': device_add=0A=
[    0.066223] PM: Adding info for No Bus:tty3=0A=
[    0.066284] device: 'tty4': device_add=0A=
[    0.066375] PM: Adding info for No Bus:tty4=0A=
[    0.066436] device: 'tty5': device_add=0A=
[    0.066528] PM: Adding info for No Bus:tty5=0A=
[    0.066589] device: 'tty6': device_add=0A=
[    0.066680] PM: Adding info for No Bus:tty6=0A=
[    0.066772] device: 'tty7': device_add=0A=
[    0.066864] PM: Adding info for No Bus:tty7=0A=
[    0.066925] device: 'tty8': device_add=0A=
[    0.067016] PM: Adding info for No Bus:tty8=0A=
[    0.067077] device: 'tty9': device_add=0A=
[    0.067199] PM: Adding info for No Bus:tty9=0A=
[    0.067260] device: 'tty10': device_add=0A=
[    0.067352] PM: Adding info for No Bus:tty10=0A=
[    0.067413] device: 'tty11': device_add=0A=
[    0.067504] PM: Adding info for No Bus:tty11=0A=
[    0.067596] device: 'tty12': device_add=0A=
[    0.067687] PM: Adding info for No Bus:tty12=0A=
[    0.067749] device: 'tty13': device_add=0A=
[    0.067840] PM: Adding info for No Bus:tty13=0A=
[    0.067901] device: 'tty14': device_add=0A=
[    0.068023] PM: Adding info for No Bus:tty14=0A=
[    0.068084] device: 'tty15': device_add=0A=
[    0.068206] PM: Adding info for No Bus:tty15=0A=
[    0.068267] device: 'tty16': device_add=0A=
[    0.068359] PM: Adding info for No Bus:tty16=0A=
[    0.068420] device: 'tty17': device_add=0A=
[    0.068542] PM: Adding info for No Bus:tty17=0A=
[    0.068603] device: 'tty18': device_add=0A=
[    0.068695] PM: Adding info for No Bus:tty18=0A=
[    0.068756] device: 'tty19': device_add=0A=
[    0.068878] PM: Adding info for No Bus:tty19=0A=
[    0.068939] device: 'tty20': device_add=0A=
[    0.069030] PM: Adding info for No Bus:tty20=0A=
[    0.069122] device: 'tty21': device_add=0A=
[    0.069213] PM: Adding info for No Bus:tty21=0A=
[    0.069274] device: 'tty22': device_add=0A=
[    0.069396] PM: Adding info for No Bus:tty22=0A=
[    0.069458] device: 'tty23': device_add=0A=
[    0.069549] PM: Adding info for No Bus:tty23=0A=
[    0.069641] device: 'tty24': device_add=0A=
[    0.069732] PM: Adding info for No Bus:tty24=0A=
[    0.069793] device: 'tty25': device_add=0A=
[    0.069915] PM: Adding info for No Bus:tty25=0A=
[    0.069976] device: 'tty26': device_add=0A=
[    0.070068] PM: Adding info for No Bus:tty26=0A=
[    0.070159] device: 'tty27': device_add=0A=
[    0.070281] PM: Adding info for No Bus:tty27=0A=
[    0.070343] device: 'tty28': device_add=0A=
[    0.070465] PM: Adding info for No Bus:tty28=0A=
[    0.070526] device: 'tty29': device_add=0A=
[    0.070617] PM: Adding info for No Bus:tty29=0A=
[    0.070709] device: 'tty30': device_add=0A=
[    0.070800] PM: Adding info for No Bus:tty30=0A=
[    0.070892] device: 'tty31': device_add=0A=
[    0.071014] PM: Adding info for No Bus:tty31=0A=
[    0.071075] device: 'tty32': device_add=0A=
[    0.071197] PM: Adding info for No Bus:tty32=0A=
[    0.071258] device: 'tty33': device_add=0A=
[    0.071472] PM: Adding info for No Bus:tty33=0A=
[    0.071533] device: 'tty34': device_add=0A=
[    0.071655] PM: Adding info for No Bus:tty34=0A=
[    0.071716] device: 'tty35': device_add=0A=
[    0.071838] PM: Adding info for No Bus:tty35=0A=
[    0.071929] device: 'tty36': device_add=0A=
[    0.072052] PM: Adding info for No Bus:tty36=0A=
[    0.072113] device: 'tty37': device_add=0A=
[    0.072235] PM: Adding info for No Bus:tty37=0A=
[    0.072296] device: 'tty38': device_add=0A=
[    0.072418] PM: Adding info for No Bus:tty38=0A=
[    0.072479] device: 'tty39': device_add=0A=
[    0.072601] PM: Adding info for No Bus:tty39=0A=
[    0.072662] device: 'tty40': device_add=0A=
[    0.072814] PM: Adding info for No Bus:tty40=0A=
[    0.072875] device: 'tty41': device_add=0A=
[    0.072998] PM: Adding info for No Bus:tty41=0A=
[    0.073059] device: 'tty42': device_add=0A=
[    0.073181] PM: Adding info for No Bus:tty42=0A=
[    0.073242] device: 'tty43': device_add=0A=
[    0.073394] PM: Adding info for No Bus:tty43=0A=
[    0.073455] device: 'tty44': device_add=0A=
[    0.073577] PM: Adding info for No Bus:tty44=0A=
[    0.073638] device: 'tty45': device_add=0A=
[    0.073760] PM: Adding info for No Bus:tty45=0A=
[    0.073822] device: 'tty46': device_add=0A=
[    0.073974] PM: Adding info for No Bus:tty46=0A=
[    0.074035] device: 'tty47': device_add=0A=
[    0.074188] PM: Adding info for No Bus:tty47=0A=
[    0.074249] device: 'tty48': device_add=0A=
[    0.074371] PM: Adding info for No Bus:tty48=0A=
[    0.074432] device: 'tty49': device_add=0A=
[    0.074554] PM: Adding info for No Bus:tty49=0A=
[    0.074615] device: 'tty50': device_add=0A=
[    0.074768] PM: Adding info for No Bus:tty50=0A=
[    0.074829] device: 'tty51': device_add=0A=
[    0.074951] PM: Adding info for No Bus:tty51=0A=
[    0.075012] device: 'tty52': device_add=0A=
[    0.075195] PM: Adding info for No Bus:tty52=0A=
[    0.075256] device: 'tty53': device_add=0A=
[    0.075408] PM: Adding info for No Bus:tty53=0A=
[    0.075469] device: 'tty54': device_add=0A=
[    0.075592] PM: Adding info for No Bus:tty54=0A=
[    0.075653] device: 'tty55': device_add=0A=
[    0.075836] PM: Adding info for No Bus:tty55=0A=
[    0.075897] device: 'tty56': device_add=0A=
[    0.076019] PM: Adding info for No Bus:tty56=0A=
[    0.076080] device: 'tty57': device_add=0A=
[    0.076202] PM: Adding info for No Bus:tty57=0A=
[    0.076263] device: 'tty58': device_add=0A=
[    0.076385] PM: Adding info for No Bus:tty58=0A=
[    0.076477] device: 'tty59': device_add=0A=
[    0.076568] PM: Adding info for No Bus:tty59=0A=
[    0.076660] device: 'tty60': device_add=0A=
[    0.076782] PM: Adding info for No Bus:tty60=0A=
[    0.076843] device: 'tty61': device_add=0A=
[    0.076965] PM: Adding info for No Bus:tty61=0A=
[    0.077056] device: 'tty62': device_add=0A=
[    0.077178] PM: Adding info for No Bus:tty62=0A=
[    0.077239] device: 'tty63': device_add=0A=
[    0.077362] PM: Adding info for No Bus:tty63=0A=
[    0.077728] device class 'firmware': registering=0A=
[    0.078002] NET: Registered protocol family 2=0A=
[    0.078399] IP route cache hash table entries: 1024 (order: 0, 4096 =
bytes)=0A=
[    0.079833] TCP established hash table entries: 4096 (order: 3, 32768 =
bytes)=0A=
[    0.079956] TCP bind hash table entries: 4096 (order: 3, 32768 bytes)=0A=
[    0.080078] TCP: Hash tables configured (established 4096 bind 4096)=0A=
[    0.080108] TCP reno registered=0A=
[    0.080139] UDP hash table entries: 128 (order: 0, 4096 bytes)=0A=
[    0.080169] UDP-Lite hash table entries: 128 (order: 0, 4096 bytes)=0A=
[    0.080566] NET: Registered protocol family 1=0A=
[    0.081329] RPC: Registered udp transport module.=0A=
[    0.081359] RPC: Registered tcp transport module.=0A=
[    0.081359] RPC: Registered tcp NFSv4.1 backchannel transport module.=0A=
[    0.081726] Registering sysdev class 'timer'=0A=
[    0.081817] Registering sys device of class 'timer'=0A=
[    0.081848] Registering sys device 'timer0'=0A=
[    0.081939] Registering platform device 'mpu.0'. Parent at omap=0A=
[    0.081939] device: 'mpu.0': device_add=0A=
[    0.082000] bus: 'platform': add device mpu.0=0A=
[    0.082061] PM: Adding info for platform:mpu.0=0A=
[    0.082183] Registering platform device 'iva.0'. Parent at omap=0A=
[    0.082183] device: 'iva.0': device_add=0A=
[    0.082214] bus: 'platform': add device iva.0=0A=
[    0.082305] PM: Adding info for platform:iva.0=0A=
[    0.082397] Registering platform device 'l3_main.0'. Parent at omap=0A=
[    0.082397] device: 'l3_main.0': device_add=0A=
[    0.082427] bus: 'platform': add device l3_main.0=0A=
[    0.082519] PM: Adding info for platform:l3_main.0=0A=
[    0.082672] Registering sysdev class 'timekeeping'=0A=
[    0.082733] Registering sys device of class 'timekeeping'=0A=
[    0.082763] Registering sys device 'timekeeping0'=0A=
[    0.082824] Registering sysdev class 'clocksource'=0A=
[    0.082855] Registering sys device of class 'clocksource'=0A=
[    0.082885] Registering sys device 'clocksource0'=0A=
[    0.083160] audit: initializing netlink socket (disabled)=0A=
[    0.083221] type=3D2000 audit(0.265:1): initialized=0A=
[    0.279815] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).=0A=
[    0.281860] msgmni has been set to 158=0A=
[    0.284606] io scheduler noop registered=0A=
[    0.284637] io scheduler deadline registered=0A=
[    0.284790] io scheduler cfq registered (default)=0A=
[    0.285064] device: 'ptmx': device_add=0A=
[    0.285308] PM: Adding info for No Bus:ptmx=0A=
[    0.285430] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled=0A=
[    0.285552] Registering platform device 'serial8250'. Parent at =
platform=0A=
[    0.285583] device: 'serial8250': device_add=0A=
[    0.285614] bus: 'platform': add device serial8250=0A=
[    0.285705] PM: Adding info for platform:serial8250=0A=
[    0.285827] device: 'ttyS0': device_add=0A=
[    0.285980] PM: Adding info for No Bus:ttyS0=0A=
[    0.286071] device: 'ttyS1': device_add=0A=
[    0.286193] PM: Adding info for No Bus:ttyS1=0A=
[    0.286285] device: 'ttyS2': device_add=0A=
[    0.286407] PM: Adding info for No Bus:ttyS2=0A=
[    0.286468] device: 'ttyS3': device_add=0A=
[    0.286590] PM: Adding info for No Bus:ttyS3=0A=
[    0.286651] bus: 'platform': add driver serial8250=0A=
[    0.286743] bus: 'platform': driver_probe_device: matched device =
serial8250 with driver serial8250=0A=
[    0.286773] bus: 'platform': really_probe: probing driver serial8250 =
with device serial8250=0A=
[    0.286804] driver: 'serial8250': driver_bound: bound to device =
'serial8250'=0A=
[    0.286834] bus: 'platform': really_probe: bound device serial8250 to =
driver serial8250=0A=
[    0.286956] bus: 'platform': add driver omap-hsuart=0A=
[    0.286987] bus: 'platform': driver_probe_device: matched device =
omap-hsuart.0 with driver omap-hsuart=0A=
[    0.287017] bus: 'platform': really_probe: probing driver omap-hsuart =
with device omap-hsuart.0=0A=
[    0.287078] omap-hsuart.0: ttyO0 at MMIO 0x4806a000 (irq =3D 72) is a =
OMAP UART0=0A=
[    0.877380] console [ttyO0] enabled=0A=
[    0.881195] device: 'ttyO0': device_add=0A=
[    0.881378] PM: Adding info for No Bus:ttyO0=0A=
[    0.881469] driver: 'omap-hsuart.0': driver_bound: bound to device =
'omap-hsuart'=0A=
[    0.881500] bus: 'platform': really_probe: bound device omap-hsuart.0 =
to driver omap-hsuart=0A=
[    0.881500] bus: 'platform': driver_probe_device: matched device =
omap-hsuart.1 with driver omap-hsuart=0A=
[    0.881530] bus: 'platform': really_probe: probing driver omap-hsuart =
with device omap-hsuart.1=0A=
[    0.881591] omap-hsuart.1: ttyO1 at MMIO 0x4806c000 (irq =3D 73) is a =
OMAP UART1=0A=
[    0.889343] device: 'ttyO1': device_add=0A=
[    0.889526] PM: Adding info for No Bus:ttyO1=0A=
[    0.889587] driver: 'omap-hsuart.1': driver_bound: bound to device =
'omap-hsuart'=0A=
[    0.889617] bus: 'platform': really_probe: bound device omap-hsuart.1 =
to driver omap-hsuart=0A=
[    0.889648] bus: 'platform': driver_probe_device: matched device =
omap-hsuart.2 with driver omap-hsuart=0A=
[    0.889678] bus: 'platform': really_probe: probing driver omap-hsuart =
with device omap-hsuart.2=0A=
[    0.889739] omap-hsuart.2: ttyO2 at MMIO 0x49020000 (irq =3D 74) is a =
OMAP UART2=0A=
[    0.897399] device: 'ttyO2': device_add=0A=
[    0.897552] PM: Adding info for No Bus:ttyO2=0A=
[    0.897613] driver: 'omap-hsuart.2': driver_bound: bound to device =
'omap-hsuart'=0A=
[    0.897644] bus: 'platform': really_probe: bound device omap-hsuart.2 =
to driver omap-hsuart=0A=
[    0.897796] bus: 'i2c': add driver menelaus=0A=
[    0.897918] device class 'scsi_disk': registering=0A=
[    0.898010] bus: 'scsi': add driver sd=0A=
[    0.898193] bus: 'scsi': add driver sr=0A=
[    0.898284] device class 'scsi_generic': registering=0A=
[    0.898437] bus: 'mdio_bus': add driver Marvell 88E1101=0A=
[    0.898529] bus: 'mdio_bus': add driver Marvell 88E1112=0A=
[    0.898590] bus: 'mdio_bus': add driver Marvell 88E1111=0A=
[    0.898712] bus: 'mdio_bus': add driver Marvell 88E1118=0A=
[    0.898803] bus: 'mdio_bus': add driver Marvell 88E1121R=0A=
[    0.898864] bus: 'mdio_bus': add driver Marvell 88EC048=0A=
[    0.898956] bus: 'mdio_bus': add driver Marvell 88E1145=0A=
[    0.899017] bus: 'mdio_bus': add driver Marvell 88E1240=0A=
[    0.899108] bus: 'mdio_bus': add driver Davicom DM9161E=0A=
[    0.899200] bus: 'mdio_bus': add driver Davicom DM9161A=0A=
[    0.899291] bus: 'mdio_bus': add driver Davicom DM9131=0A=
[    0.899353] bus: 'mdio_bus': add driver Cicada Cis8204=0A=
[    0.899505] bus: 'mdio_bus': add driver Cicada Cis8201=0A=
[    0.899597] bus: 'mdio_bus': add driver LXT970=0A=
[    0.899688] bus: 'mdio_bus': add driver LXT971=0A=
[    0.899749] bus: 'mdio_bus': add driver LXT973=0A=
[    0.899841] bus: 'mdio_bus': add driver QS6612=0A=
[    0.899902] bus: 'mdio_bus': add driver SMSC LAN83C185=0A=
[    0.899993] bus: 'mdio_bus': add driver SMSC LAN8187=0A=
[    0.900054] bus: 'mdio_bus': add driver SMSC LAN8700=0A=
[    0.900146] bus: 'mdio_bus': add driver SMSC LAN911x Internal PHY=0A=
[    0.900238] bus: 'mdio_bus': add driver SMSC LAN8710/LAN8720=0A=
[    0.900299] bus: 'mdio_bus': add driver Vitesse VSC8244=0A=
[    0.900390] bus: 'mdio_bus': add driver Vitesse VSC8221=0A=
[    0.900482] bus: 'mdio_bus': add driver Broadcom BCM5411=0A=
[    0.900543] bus: 'mdio_bus': add driver Broadcom BCM5421=0A=
[    0.900634] bus: 'mdio_bus': add driver Broadcom BCM5461=0A=
[    0.900726] bus: 'mdio_bus': add driver Broadcom BCM5464=0A=
[    0.900787] bus: 'mdio_bus': add driver Broadcom BCM5481=0A=
[    0.900878] bus: 'mdio_bus': add driver Broadcom BCM5482=0A=
[    0.900970] bus: 'mdio_bus': add driver Broadcom BCM50610=0A=
[    0.901062] bus: 'mdio_bus': add driver Broadcom BCM50610M=0A=
[    0.901153] bus: 'mdio_bus': add driver Broadcom BCM57780=0A=
[    0.901245] bus: 'mdio_bus': add driver Broadcom BCMAC131=0A=
[    0.901336] bus: 'mdio_bus': add driver Broadcom BCM5241=0A=
[    0.901397] bus: 'mdio_bus': add driver ICPlus IP175C=0A=
[    0.901489] bus: 'mdio_bus': add driver RTL821x Gigabit Ethernet=0A=
[    0.901580] bus: 'mdio_bus': add driver ET1011C=0A=
[    0.901672] Registering platform device 'Fixed MDIO bus.0'. Parent at =
platform=0A=
[    0.901702] device: 'Fixed MDIO bus.0': device_add=0A=
[    0.901733] bus: 'platform': add device Fixed MDIO bus.0=0A=
[    0.901824] PM: Adding info for platform:Fixed MDIO bus.0=0A=
[    0.901916] device: '0': device_add=0A=
[    0.902008] PM: Adding info for No Bus:0=0A=
[    0.902099] Fixed MDIO Bus: probed=0A=
[    0.905670] bus: 'platform': add driver mdio-gpio=0A=
[    0.905822] bus: 'mdio_bus': add driver NatSemi DP83865=0A=
[    0.905883] bus: 'mdio_bus': add driver STe100p=0A=
[    0.905975] bus: 'mdio_bus': add driver STe101p=0A=
[    0.906066] bus: 'mdio_bus': add driver Micrel KS8001 or KS8721=0A=
[    0.906158] bus: 'mdio_bus': add driver Micrel KSZ9021 Gigabit PHY=0A=
[    0.906250] bus: 'mdio_bus': add driver Micrel KS8737=0A=
[    0.906372] bus: 'mdio_bus': add driver Micrel KS8041=0A=
[    0.906463] bus: 'mdio_bus': add driver Micrel KS8051=0A=
[    0.906677] device: 'dummy0': device_add=0A=
[    0.906982] PM: Adding info for No Bus:dummy0=0A=
[    0.908294] device: 'ifb0': device_add=0A=
[    0.908630] PM: Adding info for No Bus:ifb0=0A=
[    0.909851] device: 'ifb1': device_add=0A=
[    0.910217] PM: Adding info for No Bus:ifb1=0A=
[    0.911437] bus: 'platform': add driver smc91x=0A=
[    0.911590] bus: 'platform': add driver smc911x=0A=
[    0.911712] bus: 'platform': add driver smsc911x=0A=
[    0.911743] bus: 'platform': driver_probe_device: matched device =
smsc911x with driver smsc911x=0A=
[    0.911773] bus: 'platform': really_probe: probing driver smsc911x =
with device smsc911x=0A=
[    0.911804] smsc911x: Driver version 2008-10-21.=0A=
[    0.917053] device: 'eth0': device_add=0A=
[    0.917419] PM: Adding info for No Bus:eth0=0A=
[    0.918762] device: 'ffffffff': device_add=0A=
[    0.918853] PM: Adding info for No Bus:ffffffff=0A=
[    0.919738] device: 'ffffffff:01': device_add=0A=
[    0.919769] bus: 'mdio_bus': add device ffffffff:01=0A=
[    0.919860] PM: Adding info for mdio_bus:ffffffff:01=0A=
[    0.919952] bus: 'mdio_bus': driver_probe_device: matched device =
ffffffff:01 with driver SMSC LAN8700=0A=
[    0.919982] bus: 'mdio_bus': really_probe: probing driver SMSC =
LAN8700 with device ffffffff:01=0A=
[    0.920013] driver: 'ffffffff:01': driver_bound: bound to device =
'SMSC LAN8700'=0A=
[    0.920043] bus: 'mdio_bus': really_probe: bound device ffffffff:01 =
to driver SMSC LAN8700=0A=
[    0.920074] smsc911x-mdio: probed=0A=
[    0.923858] eth0: attached PHY driver [SMSC LAN8700] =
(mii_bus:phy_addr=3Dffffffff:01, irq=3D-1)=0A=
[    0.932952] net eth0: MAC Address: 00:50:c2:7e:91:0b=0A=
[    0.938171] driver: 'smsc911x': driver_bound: bound to device =
'smsc911x'=0A=
[    0.938201] bus: 'platform': really_probe: bound device smsc911x to =
driver smsc911x=0A=
[    0.938323] bus: 'sdio': add driver wl1271_sdio=0A=
[    0.938629] device: 'mice': device_add=0A=
[    0.938812] PM: Adding info for No Bus:mice=0A=
[    0.938903] device: 'psaux': device_add=0A=
[    0.939025] PM: Adding info for No Bus:psaux=0A=
[    0.939086] mice: PS/2 mouse device common for all mice=0A=
[    0.944580] bus: 'serio': add driver atkbd=0A=
[    0.945190] cpuidle: using governor ladder=0A=
[    0.949645] cpuidle: using governor menu=0A=
[    0.953765] bus: 'mmc': add driver mmcblk=0A=
[    0.953887] AIRVOD platform_driver_probe        =
drivers/base/platform.c=0A=
[    0.960906] bus: 'platform': add driver mmci-omap=0A=
[    0.961059] bus: 'platform': remove driver mmci-omap=0A=
[    0.961120] driver: 'mmci-omap': driver_release=0A=
[    0.961120] AIRVOD platform_driver_probe        =
drivers/base/platform.c=0A=
[    0.968139] bus: 'platform': add driver mmci-omap-hs=0A=
[    0.968200] bus: 'platform': driver_probe_device: matched device =
mmci-omap-hs.0 with driver mmci-omap-hs=0A=
[    0.968231] bus: 'platform': really_probe: probing driver =
mmci-omap-hs with device mmci-omap-hs.0=0A=
[    0.968292] i2c_omap i2c_omap.1: __pm_runtime_resume()!=0A=
[    0.968353] i2c_omap i2c_omap.1: __pm_runtime_resume() returns 0!=0A=
[    0.968505] i2c_omap i2c_omap.1: __pm_runtime_suspend()!=0A=
[    0.968536] i2c_omap i2c_omap.1: __pm_runtime_suspend() returns 0!=0A=
[    0.968566] i2c_omap i2c_omap.1: __pm_runtime_resume()!=0A=
[    0.968597] i2c_omap i2c_omap.1: __pm_runtime_resume() returns 0!=0A=
[    0.968719] i2c_omap i2c_omap.1: __pm_runtime_suspend()!=0A=
[    0.968750] i2c_omap i2c_omap.1: __pm_runtime_suspend() returns 0!=0A=
[    0.969085] i2c_omap i2c_omap.1: __pm_runtime_resume()!=0A=
[    0.969116] i2c_omap i2c_omap.1: __pm_runtime_resume() returns 0!=0A=
[    0.969268] i2c_omap i2c_omap.1: __pm_runtime_suspend()!=0A=
[    0.969299] i2c_omap i2c_omap.1: __pm_runtime_suspend() returns 0!=0A=
[    0.969329] i2c_omap i2c_omap.1: __pm_runtime_resume()!=0A=
[    0.969360] i2c_omap i2c_omap.1: __pm_runtime_resume() returns 0!=0A=
[    0.969482] i2c_omap i2c_omap.1: __pm_runtime_suspend()!=0A=
[    0.969512] i2c_omap i2c_omap.1: __pm_runtime_suspend() returns 0!=0A=
[    0.969573] i2c_omap i2c_omap.1: __pm_runtime_resume()!=0A=
[    0.969635] i2c_omap i2c_omap.1: __pm_runtime_resume() returns 0!=0A=
[    0.970001] i2c_omap i2c_omap.1: __pm_runtime_suspend()!=0A=
[    0.970031] i2c_omap i2c_omap.1: __pm_runtime_suspend() returns 0!=0A=
[    0.970062] i2c_omap i2c_omap.1: __pm_runtime_resume()!=0A=
[    0.970092] i2c_omap i2c_omap.1: __pm_runtime_resume() returns 0!=0A=
[    0.970245] i2c_omap i2c_omap.1: __pm_runtime_suspend()!=0A=
[    0.970275] i2c_omap i2c_omap.1: __pm_runtime_suspend() returns 0!=0A=
[    0.970306] i2c_omap i2c_omap.1: __pm_runtime_resume()!=0A=
[    0.970336] i2c_omap i2c_omap.1: __pm_runtime_resume() returns 0!=0A=
[    0.970428] device: 'mmc0': device_add=0A=
[    0.970458] i2c_omap i2c_omap.1: __pm_runtime_suspend()!=0A=
[    0.970489] i2c_omap i2c_omap.1: __pm_runtime_suspend() returns 0!=0A=
[    0.970642] PM: Adding info for No Bus:mmc0=0A=
[    0.970764] AIRVOD mmc_start_host        drivers/mmc/core/core.c=0A=
[    0.977142] AIRVOD   mmc_rescan        drivers/mmc/core/core.c=0A=
[    0.983398] driver: 'mmci-omap-hs.0': driver_bound: bound to device =
'mmci-omap-hs'=0A=
[    0.983428] bus: 'platform': really_probe: bound device =
mmci-omap-hs.0 to driver mmci-omap-hs=0A=
[    0.983459] bus: 'platform': driver_probe_device: matched device =
mmci-omap-hs.1 with driver mmci-omap-hs=0A=
[    0.983489] bus: 'platform': really_probe: probing driver =
mmci-omap-hs with device mmci-omap-hs.1=0A=
[    0.983764] device: 'mmc1': device_add=0A=
[    0.983856] PM: Adding info for No Bus:mmc1=0A=
[    0.983947] AIRVOD mmc_start_host        drivers/mmc/core/core.c=0A=
[    0.990356] i2c_omap i2c_omap.1: __pm_runtime_resume()!=0A=
[    0.990417] i2c_omap i2c_omap.1: __pm_runtime_resume() returns 0!=0A=
[    0.990570] i2c_omap i2c_omap.1: __pm_runtime_suspend()!=0A=
[    0.990600] i2c_omap i2c_omap.1: __pm_runtime_suspend() returns 0!=0A=
[    0.990631] AIRVOD   mmc_rescan        drivers/mmc/core/core.c=0A=
[    0.996887] driver: 'mmci-omap-hs.1': driver_bound: bound to device =
'mmci-omap-hs'=0A=
[    0.996917] bus: 'platform': really_probe: bound device =
mmci-omap-hs.1 to driver mmci-omap-hs=0A=
[    0.997436] pktgen: Packet Generator for packet performance testing. =
Version: 2.74=0A=
[    1.058044] IPv4 over IPv4 tunneling driver=0A=
[    1.062530] device: 'tunl0': device_add=0A=
[    1.062927] PM: Adding info for No Bus:tunl0=0A=
[    1.079010] TCP probe registered (port=3D0) bufsize=3D4096=0A=
[    1.084533] TCP cubic registered=0A=
[    1.087982] Initializing XFRM netlink socket=0A=
[    1.092559] NET: Registered protocol family 17=0A=
[    1.097351] NET: Registered protocol family 15=0A=
[    1.102386] Bridge firewalling registered=0A=
[    1.106964] bus: 'platform': add driver dsa=0A=
[    1.107238] 802.1Q VLAN Support v1.8 Ben Greear =
<greearb@candelatech.com>=0A=
[    1.114440] All bugs added by David S. Miller <davem@redhat.com>=0A=
[    1.122558] CCID: Activated CCID 2 (TCP-like)=0A=
[    1.127380] CCID: Activated CCID 3 (TCP-Friendly Rate Control)=0A=
[    1.137725] SCTP: Hash tables configured (established 2048 bind 2048)=0A=
[    1.145263] ARIVOD mmc_attach_sdio   drivers/mmc/core/sdio.c=0A=
[    1.151275] mmc1: card claims to support voltages below the defined =
range. These will be ignored.=0A=
[    1.160675] AIRVOD mmc_sdio_init_card        drivers/mmc/core/sdio.c=0A=
[    1.168609] NET: Registered protocol family 21=0A=
[    1.173370] lib80211: common routines for IEEE802.11 drivers=0A=
[    1.179351] lib80211_crypt: registered algorithm 'NULL'=0A=
[    1.179504] NET: Registered protocol family 36=0A=
[    1.184234] Registering the dns_resolver key type=0A=
[    1.189239] AIRVOD 1 mmc_sdio_init_card        drivers/mmc/core/sdio.c=0A=
[    1.196105] AIRVOD omap_hsmmc_init_card        =
drivers/mmc/host/omap_hsmmc.c=0A=
[    1.205871] Power Management for TI OMAP3.=0A=
[    1.220184] VFP support v0.3: implementor 41 architecture 3 part 30 =
variant c rev 1=0A=
[    1.228332] Registering sysdev class 'vfp'=0A=
[    1.228454] Registering sys device of class 'vfp'=0A=
[    1.228485] Registering sys device 'vfp0'=0A=
[    1.228637] device: 'cpu_dma_latency': device_add=0A=
[    1.228790] PM: Adding info for No Bus:cpu_dma_latency=0A=
[    1.228881] device: 'network_latency': device_add=0A=
[    1.229003] PM: Adding info for No Bus:network_latency=0A=
[    1.229064] device: 'network_throughput': device_add=0A=
[    1.229187] PM: Adding info for No Bus:network_throughput=0A=
[    1.229309] registered taskstats version 1=0A=
[    1.233673] i2c_omap i2c_omap.1: __pm_runtime_resume()!=0A=
[    1.233734] i2c_omap i2c_omap.1: __pm_runtime_resume() returns 0!=0A=
[    1.233978] i2c_omap i2c_omap.1: __pm_runtime_suspend()!=0A=
[    1.234008] i2c_omap i2c_omap.1: __pm_runtime_suspend() returns 0!=0A=
[    1.234039] i2c_omap i2c_omap.1: __pm_runtime_resume()!=0A=
[    1.234100] i2c_omap i2c_omap.1: __pm_runtime_resume() returns 0!=0A=
[    1.234344] i2c_omap i2c_omap.1: __pm_runtime_suspend()!=0A=
[    1.234375] i2c_omap i2c_omap.1: __pm_runtime_suspend() returns 0!=0A=
[    1.234405] i2c_omap i2c_omap.1: __pm_runtime_resume()!=0A=
[    1.234436] i2c_omap i2c_omap.1: __pm_runtime_resume() returns 0!=0A=
[    1.234710] i2c_omap i2c_omap.1: __pm_runtime_suspend()!=0A=
[    1.234741] i2c_omap i2c_omap.1: __pm_runtime_suspend() returns 0!=0A=
[    1.234771] i2c_omap i2c_omap.1: __pm_runtime_resume()!=0A=
[    1.234802] i2c_omap i2c_omap.1: __pm_runtime_resume() returns 0!=0A=
[    1.235076] i2c_omap i2c_omap.1: __pm_runtime_suspend()!=0A=
[    1.235107] i2c_omap i2c_omap.1: __pm_runtime_suspend() returns 0!=0A=
[    1.235198] bus: 'platform': add driver davinci_emac=0A=
[    1.235443] Initalizing network drop monitor service=0A=
[    1.243316] ARIVOD sdio_init_func   drivers/mmc/core/sdio.c=0A=
[    1.249206] ARIVOD 2 sdio_init_func   drivers/mmc/core/sdio.c=0A=
[    1.255279] ARIVOD sdio_init_func   drivers/mmc/core/sdio.c=0A=
[    1.261230] ARIVOD 2 sdio_init_func   drivers/mmc/core/sdio.c=0A=
[    1.267333] mmc1: new SDIO card at address 0001=0A=
[    1.272094] device: 'mmc1:0001': device_add=0A=
[    1.272155] bus: 'mmc': add device mmc1:0001=0A=
[    1.272216] PM: Adding info for mmc:mmc1:0001=0A=
[    1.272308] bus: 'mmc': driver_probe_device: matched device mmc1:0001 =
with driver mmcblk=0A=
[    1.272338] bus: 'mmc': really_probe: probing driver mmcblk with =
device mmc1:0001=0A=
[    1.272430] device: 'mmc1:0001:1': device_add=0A=
[    1.272460] bus: 'sdio': add device mmc1:0001:1=0A=
[    1.272552] PM: Adding info for sdio:mmc1:0001:1=0A=
[    1.272644] bus: 'sdio': driver_probe_device: matched device =
mmc1:0001:1 with driver wl1271_sdio=0A=
[    1.272674] bus: 'sdio': really_probe: probing driver wl1271_sdio =
with device mmc1:0001:1=0A=
[    1.272705] AIRVOD   sdio_bus_probe        drivers/mmc/core/sdio_bus.c=0A=
[    1.279754] device: 'mmc1:0001:2': device_add=0A=
[    1.279785] bus: 'sdio': add device mmc1:0001:2=0A=
[    1.279907] PM: Adding info for sdio:mmc1:0001:2=0A=
[    1.279968] bus: 'sdio': driver_probe_device: matched device =
mmc1:0001:2 with driver wl1271_sdio=0A=
[    1.279998] bus: 'sdio': really_probe: probing driver wl1271_sdio =
with device mmc1:0001:2=0A=
[    1.280029] AIRVOD   sdio_bus_probe        drivers/mmc/core/sdio_bus.c=0A=
[    1.287994] Registering platform device 'wl1271'. Parent at platform=0A=
[    1.287994] device: 'wl1271': device_add=0A=
[    1.288055] bus: 'platform': add device wl1271=0A=
[    1.288177] PM: Adding info for platform:wl1271=0A=
[    1.288330] device: 'phy0': device_add=0A=
[    1.288452] PM: Adding info for No Bus:phy0=0A=
[    1.288635] device: 'rfkill0': device_add=0A=
[    1.288757] PM: Adding info for No Bus:rfkill0=0A=
[    1.291503] device: 'wlan0': device_add=0A=
[    1.291931] PM: Adding info for No Bus:wlan0=0A=
[    1.294006] wl1271: loaded=0A=
[    1.296844] wl1271: initialized=0A=
[    1.300262] driver: 'mmc1:0001:2': driver_bound: bound to device =
'wl1271_sdio'=0A=
[    1.300262] bus: 'sdio': really_probe: bound device mmc1:0001:2 to =
driver wl1271_sdio=0A=
[    1.743377] AIRVOD __dev_change_flags   net/core/dev.c ret =3D 0=0A=
[    1.749908] ARIVOD eth_validate_addr   net/ethernet/eth.c=0A=
[    1.755676] AIRVOD __dev_change_flags   net/core/dev.c ret =3D 0=0A=
[    1.761993] ARIVOD eth_validate_addr   net/ethernet/eth.c=0A=
[    1.767700] AIRVOD __dev_change_flags   net/core/dev.c ret =3D 0=0A=
[    1.773956] ARIVOD eth_validate_addr   net/ethernet/eth.c=0A=
[    1.790283] net eth0: SMSC911x/921x identified at 0xc600c000, IRQ: 336=0A=
[    1.797210] AIRVOD __dev_change_flags   net/core/dev.c ret =3D 0=0A=
[    1.803558] wl1271: mac80211 start=0A=
[    1.803588] wl1271: mac80211 add interface type 2 mac =
12:34:56:78:ab:cd=0A=
[    2.040649] chip id 0x4030111 (1271 PG20)=0A=
[    2.282836] chip id 0x4030111 (1271 PG20)=0A=
[    2.287872] wl1271: pause1 0xf03=0A=
[    2.288818] wl1271: DRPW_SCRATCH_START 0031002c=0A=
[    2.288879] wl1271: clk2 0x0=0A=
[    2.289398] wl1271: soft reset bootdata 0x0=0A=
[    2.289520] wl1271: nvs burst write 0x30546c: 0x5678abcd=0A=
[    2.289581] wl1271: nvs burst write 0x305470: 0x1234=0A=
[    2.290283] wl1271: ACX_EEPROMLESS_IND_REG=0A=
[    2.290435] wl1271: chip id 0x4030111=0A=
[    2.290802] wl1271: firmware chunks to be uploaded: 6=0A=
[    2.290832] wl1271: chunk 5 addr 0x0 len 195924=0A=
[    2.290832] wl1271: starting firmware upload=0A=
[    2.290863] wl1271: fw_data_len 195924 chunk_size 512=0A=
[    2.291198] wl1271: uploading fw chunk 0xc600f00c to 0x0=0A=
[    2.291625] wl1271: uploading fw chunk 0xc600f20c to 0x200=0A=
[    2.292022] wl1271: uploading fw chunk 0xc600f40c to 0x400=0A=
[    2.292419] wl1271: uploading fw chunk 0xc600f60c to 0x600=0A=
[    2.292816] wl1271: uploading fw chunk 0xc600f80c to 0x800=0A=
[    2.293243] wl1271: uploading fw chunk 0xc600fa0c to 0xa00=0A=
[    2.293640] wl1271: uploading fw chunk 0xc600fc0c to 0xc00=0A=
[    2.294036] wl1271: uploading fw chunk 0xc600fe0c to 0xe00=0A=
[    2.294464] wl1271: uploading fw chunk 0xc601000c to 0x1000=0A=
[    2.294860] wl1271: uploading fw chunk 0xc601020c to 0x1200=0A=
[    2.295257] wl1271: uploading fw chunk 0xc601040c to 0x1400=0A=
[    2.295654] wl1271: uploading fw chunk 0xc601060c to 0x1600=0A=
[    2.296081] wl1271: uploading fw chunk 0xc601080c to 0x1800=0A=
[    2.296478] wl1271: uploading fw chunk 0xc6010a0c to 0x1a00=0A=
[    2.296875] wl1271: uploading fw chunk 0xc6010c0c to 0x1c00=0A=
[    2.297271] wl1271: uploading fw chunk 0xc6010e0c to 0x1e00=0A=
[    2.297698] wl1271: uploading fw chunk 0xc601100c to 0x2000=0A=
[    2.298065] wl1271: uploading fw chunk 0xc601120c to 0x2200=0A=
[    2.298461] wl1271: uploading fw chunk 0xc601140c to 0x2400=0A=
[    2.298858] wl1271: uploading fw chunk 0xc601160c to 0x2600=0A=
[    2.299285] wl1271: uploading fw chunk 0xc601180c to 0x2800=0A=
[    2.299682] wl1271: uploading fw chunk 0xc6011a0c to 0x2a00=0A=
[    2.300079] wl1271: uploading fw chunk 0xc6011c0c to 0x2c00=0A=
[    2.300476] wl1271: uploading fw chunk 0xc6011e0c to 0x2e00=0A=
[    2.300903] wl1271: uploading fw chunk 0xc601200c to 0x3000=0A=
[    2.301300] wl1271: uploading fw chunk 0xc601220c to 0x3200=0A=
[    2.301696] wl1271: uploading fw chunk 0xc601240c to 0x3400=0A=
[    2.302093] wl1271: uploading fw chunk 0xc601260c to 0x3600=0A=
[    2.302520] wl1271: uploading fw chunk 0xc601280c to 0x3800=0A=
[    2.302917] wl1271: uploading fw chunk 0xc6012a0c to 0x3a00=0A=
[    2.303314] wl1271: uploading fw chunk 0xc6012c0c to 0x3c00=0A=
[    2.303741] wl1271: uploading fw chunk 0xc6012e0c to 0x3e00=0A=
[    2.304138] wl1271: uploading fw chunk 0xc601300c to 0x4000=0A=
[    2.304534] wl1271: uploading fw chunk 0xc601320c to 0x4200=0A=
[    2.304931] wl1271: uploading fw chunk 0xc601340c to 0x4400=0A=
[    2.305358] wl1271: uploading fw chunk 0xc601360c to 0x4600=0A=
[    2.305755] wl1271: uploading fw chunk 0xc601380c to 0x4800=0A=
[    2.306152] wl1271: uploading fw chunk 0xc6013a0c to 0x4a00=0A=
[    2.306579] wl1271: uploading fw chunk 0xc6013c0c to 0x4c00=0A=
[    2.306976] wl1271: uploading fw chunk 0xc6013e0c to 0x4e00=0A=
[    2.307373] wl1271: uploading fw chunk 0xc601400c to 0x5000=0A=
[    2.307800] wl1271: uploading fw chunk 0xc601420c to 0x5200=0A=
[    2.308197] wl1271: uploading fw chunk 0xc601440c to 0x5400=0A=
[    2.308593] wl1271: uploading fw chunk 0xc601460c to 0x5600=0A=
[    2.308990] wl1271: uploading fw chunk 0xc601480c to 0x5800=0A=
[    2.309417] wl1271: uploading fw chunk 0xc6014a0c to 0x5a00=0A=
[    2.309814] wl1271: uploading fw chunk 0xc6014c0c to 0x5c00=0A=
[    2.310211] wl1271: uploading fw chunk 0xc6014e0c to 0x5e00=0A=
[    2.310607] wl1271: uploading fw chunk 0xc601500c to 0x6000=0A=
[    2.311035] wl1271: uploading fw chunk 0xc601520c to 0x6200=0A=
[    2.311431] wl1271: uploading fw chunk 0xc601540c to 0x6400=0A=
[    2.311828] wl1271: uploading fw chunk 0xc601560c to 0x6600=0A=
[    2.312255] wl1271: uploading fw chunk 0xc601580c to 0x6800=0A=
[    2.312652] wl1271: uploading fw chunk 0xc6015a0c to 0x6a00=0A=
[    2.313049] wl1271: uploading fw chunk 0xc6015c0c to 0x6c00=0A=
[    2.313476] wl1271: uploading fw chunk 0xc6015e0c to 0x6e00=0A=
[    2.313873] wl1271: uploading fw chunk 0xc601600c to 0x7000=0A=
[    2.314270] wl1271: uploading fw chunk 0xc601620c to 0x7200=0A=
[    2.314666] wl1271: uploading fw chunk 0xc601640c to 0x7400=0A=
[    2.315093] wl1271: uploading fw chunk 0xc601660c to 0x7600=0A=
[    2.315490] wl1271: uploading fw chunk 0xc601680c to 0x7800=0A=
[    2.315887] wl1271: uploading fw chunk 0xc6016a0c to 0x7a00=0A=
[    2.316284] wl1271: uploading fw chunk 0xc6016c0c to 0x7c00=0A=
[    2.316711] wl1271: uploading fw chunk 0xc6016e0c to 0x7e00=0A=
[    2.317108] wl1271: uploading fw chunk 0xc601700c to 0x8000=0A=
[    2.317504] wl1271: uploading fw chunk 0xc601720c to 0x8200=0A=
[    2.317932] wl1271: uploading fw chunk 0xc601740c to 0x8400=0A=
[    2.318328] wl1271: uploading fw chunk 0xc601760c to 0x8600=0A=
[    2.318725] wl1271: uploading fw chunk 0xc601780c to 0x8800=0A=
[    2.319122] wl1271: uploading fw chunk 0xc6017a0c to 0x8a00=0A=
[    2.319549] wl1271: uploading fw chunk 0xc6017c0c to 0x8c00=0A=
[    2.319946] wl1271: uploading fw chunk 0xc6017e0c to 0x8e00=0A=
[    2.320343] wl1271: uploading fw chunk 0xc601800c to 0x9000=0A=
[    2.320739] wl1271: uploading fw chunk 0xc601820c to 0x9200=0A=
[    2.321166] wl1271: uploading fw chunk 0xc601840c to 0x9400=0A=
[    2.321533] wl1271: uploading fw chunk 0xc601860c to 0x9600=0A=
[    2.321929] wl1271: uploading fw chunk 0xc601880c to 0x9800=0A=
[    2.322326] wl1271: uploading fw chunk 0xc6018a0c to 0x9a00=0A=
[    2.322723] wl1271: uploading fw chunk 0xc6018c0c to 0x9c00=0A=
[    2.323150] wl1271: uploading fw chunk 0xc6018e0c to 0x9e00=0A=
[    2.323547] wl1271: uploading fw chunk 0xc601900c to 0xa000=0A=
[    2.323944] wl1271: uploading fw chunk 0xc601920c to 0xa200=0A=
[    2.324371] wl1271: uploading fw chunk 0xc601940c to 0xa400=0A=
[    2.324768] wl1271: uploading fw chunk 0xc601960c to 0xa600=0A=
[    2.325164] wl1271: uploading fw chunk 0xc601980c to 0xa800=0A=
[    2.325561] wl1271: uploading fw chunk 0xc6019a0c to 0xaa00=0A=
[    2.325988] wl1271: uploading fw chunk 0xc6019c0c to 0xac00=0A=
[    2.326385] wl1271: uploading fw chunk 0xc6019e0c to 0xae00=0A=
[    2.326782] wl1271: uploading fw chunk 0xc601a00c to 0xb000=0A=
[    2.327209] wl1271: uploading fw chunk 0xc601a20c to 0xb200=0A=
[    2.327606] wl1271: uploading fw chunk 0xc601a40c to 0xb400=0A=
[    2.328002] wl1271: uploading fw chunk 0xc601a60c to 0xb600=0A=
[    2.328399] wl1271: uploading fw chunk 0xc601a80c to 0xb800=0A=
[    2.328826] wl1271: uploading fw chunk 0xc601aa0c to 0xba00=0A=
[    2.329223] wl1271: uploading fw chunk 0xc601ac0c to 0xbc00=0A=
[    2.329620] wl1271: uploading fw chunk 0xc601ae0c to 0xbe00=0A=
[    2.330047] wl1271: uploading fw chunk 0xc601b00c to 0xc000=0A=
[    2.330444] wl1271: uploading fw chunk 0xc601b20c to 0xc200=0A=
[    2.330841] wl1271: uploading fw chunk 0xc601b40c to 0xc400=0A=
[    2.331237] wl1271: uploading fw chunk 0xc601b60c to 0xc600=0A=
[    2.331665] wl1271: uploading fw chunk 0xc601b80c to 0xc800=0A=
[    2.332061] wl1271: uploading fw chunk 0xc601ba0c to 0xca00=0A=
[    2.332458] wl1271: uploading fw chunk 0xc601bc0c to 0xcc00=0A=
[    2.332855] wl1271: uploading fw chunk 0xc601be0c to 0xce00=0A=
[    2.333282] wl1271: uploading fw chunk 0xc601c00c to 0xd000=0A=
[    2.333679] wl1271: uploading fw chunk 0xc601c20c to 0xd200=0A=
[    2.334075] wl1271: uploading fw chunk 0xc601c40c to 0xd400=0A=
[    2.334503] wl1271: uploading fw chunk 0xc601c60c to 0xd600=0A=
[    2.334899] wl1271: uploading fw chunk 0xc601c80c to 0xd800=0A=
[    2.335296] wl1271: uploading fw chunk 0xc601ca0c to 0xda00=0A=
[    2.335693] wl1271: uploading fw chunk 0xc601cc0c to 0xdc00=0A=
[    2.336120] wl1271: uploading fw chunk 0xc601ce0c to 0xde00=0A=
[    2.336517] wl1271: uploading fw chunk 0xc601d00c to 0xe000=0A=
[    2.336944] wl1271: uploading fw chunk 0xc601d20c to 0xe200=0A=
[    2.337341] wl1271: uploading fw chunk 0xc601d40c to 0xe400=0A=
[    2.337738] wl1271: uploading fw chunk 0xc601d60c to 0xe600=0A=
[    2.338134] wl1271: uploading fw chunk 0xc601d80c to 0xe800=0A=
[    2.338562] wl1271: uploading fw chunk 0xc601da0c to 0xea00=0A=
[    2.338958] wl1271: uploading fw chunk 0xc601dc0c to 0xec00=0A=
[    2.339355] wl1271: uploading fw chunk 0xc601de0c to 0xee00=0A=
[    2.339782] wl1271: uploading fw chunk 0xc601e00c to 0xf000=0A=
[    2.340179] wl1271: uploading fw chunk 0xc601e20c to 0xf200=0A=
[    2.340576] wl1271: uploading fw chunk 0xc601e40c to 0xf400=0A=
[    2.340972] wl1271: uploading fw chunk 0xc601e60c to 0xf600=0A=
[    2.341400] wl1271: uploading fw chunk 0xc601e80c to 0xf800=0A=
[    2.341796] wl1271: uploading fw chunk 0xc601ea0c to 0xfa00=0A=
[    2.342193] wl1271: uploading fw chunk 0xc601ec0c to 0xfc00=0A=
[    2.342590] wl1271: uploading fw chunk 0xc601ee0c to 0xfe00=0A=
[    2.343017] wl1271: uploading fw chunk 0xc601f00c to 0x10000=0A=
[    2.343414] wl1271: uploading fw chunk 0xc601f20c to 0x10200=0A=
[    2.343811] wl1271: uploading fw chunk 0xc601f40c to 0x10400=0A=
[    2.344207] wl1271: uploading fw chunk 0xc601f60c to 0x10600=0A=
[    2.344635] wl1271: uploading fw chunk 0xc601f80c to 0x10800=0A=
[    2.345031] wl1271: uploading fw chunk 0xc601fa0c to 0x10a00=0A=
[    2.345458] wl1271: uploading fw chunk 0xc601fc0c to 0x10c00=0A=
[    2.345855] wl1271: uploading fw chunk 0xc601fe0c to 0x10e00=0A=
[    2.346252] wl1271: uploading fw chunk 0xc602000c to 0x11000=0A=
[    2.346649] wl1271: uploading fw chunk 0xc602020c to 0x11200=0A=
[    2.347076] wl1271: uploading fw chunk 0xc602040c to 0x11400=0A=
[    2.347473] wl1271: uploading fw chunk 0xc602060c to 0x11600=0A=
[    2.347869] wl1271: uploading fw chunk 0xc602080c to 0x11800=0A=
[    2.348266] wl1271: uploading fw chunk 0xc6020a0c to 0x11a00=0A=
[    2.348693] wl1271: uploading fw chunk 0xc6020c0c to 0x11c00=0A=
[    2.349090] wl1271: uploading fw chunk 0xc6020e0c to 0x11e00=0A=
[    2.349487] wl1271: uploading fw chunk 0xc602100c to 0x12000=0A=
[    2.349914] wl1271: uploading fw chunk 0xc602120c to 0x12200=0A=
[    2.350311] wl1271: uploading fw chunk 0xc602140c to 0x12400=0A=
[    2.350708] wl1271: uploading fw chunk 0xc602160c to 0x12600=0A=
[    2.351104] wl1271: uploading fw chunk 0xc602180c to 0x12800=0A=
[    2.351531] wl1271: uploading fw chunk 0xc6021a0c to 0x12a00=0A=
[    2.351928] wl1271: uploading fw chunk 0xc6021c0c to 0x12c00=0A=
[    2.352325] wl1271: uploading fw chunk 0xc6021e0c to 0x12e00=0A=
[    2.352752] wl1271: uploading fw chunk 0xc602200c to 0x13000=0A=
[    2.353149] wl1271: uploading fw chunk 0xc602220c to 0x13200=0A=
[    2.353546] wl1271: uploading fw chunk 0xc602240c to 0x13400=0A=
[    2.353973] wl1271: uploading fw chunk 0xc602260c to 0x13600=0A=
[    2.354370] wl1271: uploading fw chunk 0xc602280c to 0x13800=0A=
[    2.354766] wl1271: uploading fw chunk 0xc6022a0c to 0x13a00=0A=
[    2.355163] wl1271: uploading fw chunk 0xc6022c0c to 0x13c00=0A=
[    2.355590] wl1271: uploading fw chunk 0xc6022e0c to 0x13e00=0A=
[    2.355987] wl1271: uploading fw chunk 0xc602300c to 0x14000=0A=
[    2.356384] wl1271: uploading fw chunk 0xc602320c to 0x14200=0A=
[    2.356781] wl1271: uploading fw chunk 0xc602340c to 0x14400=0A=
[    2.357208] wl1271: uploading fw chunk 0xc602360c to 0x14600=0A=
[    2.357604] wl1271: uploading fw chunk 0xc602380c to 0x14800=0A=
[    2.358001] wl1271: uploading fw chunk 0xc6023a0c to 0x14a00=0A=
[    2.358428] wl1271: uploading fw chunk 0xc6023c0c to 0x14c00=0A=
[    2.358825] wl1271: uploading fw chunk 0xc6023e0c to 0x14e00=0A=
[    2.359222] wl1271: uploading fw chunk 0xc602400c to 0x15000=0A=
[    2.359619] wl1271: uploading fw chunk 0xc602420c to 0x15200=0A=
[    2.360046] wl1271: uploading fw chunk 0xc602440c to 0x15400=0A=
[    2.360443] wl1271: uploading fw chunk 0xc602460c to 0x15600=0A=
[    2.360839] wl1271: uploading fw chunk 0xc602480c to 0x15800=0A=
[    2.361267] wl1271: uploading fw chunk 0xc6024a0c to 0x15a00=0A=
[    2.361663] wl1271: uploading fw chunk 0xc6024c0c to 0x15c00=0A=
[    2.362060] wl1271: uploading fw chunk 0xc6024e0c to 0x15e00=0A=
[    2.362487] wl1271: uploading fw chunk 0xc602500c to 0x16000=0A=
[    2.362884] wl1271: uploading fw chunk 0xc602520c to 0x16200=0A=
[    2.363281] wl1271: uploading fw chunk 0xc602540c to 0x16400=0A=
[    2.363677] wl1271: uploading fw chunk 0xc602560c to 0x16600=0A=
[    2.364105] wl1271: uploading fw chunk 0xc602580c to 0x16800=0A=
[    2.364501] wl1271: uploading fw chunk 0xc6025a0c to 0x16a00=0A=
[    2.364898] wl1271: uploading fw chunk 0xc6025c0c to 0x16c00=0A=
[    2.365325] wl1271: uploading fw chunk 0xc6025e0c to 0x16e00=0A=
[    2.365722] wl1271: uploading fw chunk 0xc602600c to 0x17000=0A=
[    2.366119] wl1271: uploading fw chunk 0xc602620c to 0x17200=0A=
[    2.366851] wl1271: uploading fw chunk 0xc602640c to 0x17400=0A=
[    2.367248] wl1271: uploading fw chunk 0xc602660c to 0x17600=0A=
[    2.367675] wl1271: uploading fw chunk 0xc602680c to 0x17800=0A=
[    2.368072] wl1271: uploading fw chunk 0xc6026a0c to 0x17a00=0A=
[    2.368499] wl1271: uploading fw chunk 0xc6026c0c to 0x17c00=0A=
[    2.368896] wl1271: uploading fw chunk 0xc6026e0c to 0x17e00=0A=
[    2.369293] wl1271: uploading fw chunk 0xc602700c to 0x18000=0A=
[    2.369689] wl1271: uploading fw chunk 0xc602720c to 0x18200=0A=
[    2.370117] wl1271: uploading fw chunk 0xc602740c to 0x18400=0A=
[    2.370513] wl1271: uploading fw chunk 0xc602760c to 0x18600=0A=
[    2.370910] wl1271: uploading fw chunk 0xc602780c to 0x18800=0A=
[    2.371307] wl1271: uploading fw chunk 0xc6027a0c to 0x18a00=0A=
[    2.371734] wl1271: uploading fw chunk 0xc6027c0c to 0x18c00=0A=
[    2.372131] wl1271: uploading fw chunk 0xc6027e0c to 0x18e00=0A=
[    2.372528] wl1271: uploading fw chunk 0xc602800c to 0x19000=0A=
[    2.372955] wl1271: uploading fw chunk 0xc602820c to 0x19200=0A=
[    2.373352] wl1271: uploading fw chunk 0xc602840c to 0x19400=0A=
[    2.373748] wl1271: uploading fw chunk 0xc602860c to 0x19600=0A=
[    2.374145] wl1271: uploading fw chunk 0xc602880c to 0x19800=0A=
[    2.374572] wl1271: uploading fw chunk 0xc6028a0c to 0x19a00=0A=
[    2.374969] wl1271: uploading fw chunk 0xc6028c0c to 0x19c00=0A=
[    2.375366] wl1271: uploading fw chunk 0xc6028e0c to 0x19e00=0A=
[    2.375762] wl1271: uploading fw chunk 0xc602900c to 0x1a000=0A=
[    2.376129] wl1271: uploading fw chunk 0xc602920c to 0x1a200=0A=
[    2.376495] wl1271: uploading fw chunk 0xc602940c to 0x1a400=0A=
[    2.376892] wl1271: uploading fw chunk 0xc602960c to 0x1a600=0A=
[    2.377288] wl1271: uploading fw chunk 0xc602980c to 0x1a800=0A=
[    2.377685] wl1271: uploading fw chunk 0xc6029a0c to 0x1aa00=0A=
[    2.378051] wl1271: uploading fw chunk 0xc6029c0c to 0x1ac00=0A=
[    2.378448] wl1271: uploading fw chunk 0xc6029e0c to 0x1ae00=0A=
[    2.378845] wl1271: uploading fw chunk 0xc602a00c to 0x1b000=0A=
[    2.379211] wl1271: uploading fw chunk 0xc602a20c to 0x1b200=0A=
[    2.379608] wl1271: uploading fw chunk 0xc602a40c to 0x1b400=0A=
[    2.380004] wl1271: uploading fw chunk 0xc602a60c to 0x1b600=0A=
[    2.380401] wl1271: uploading fw chunk 0xc602a80c to 0x1b800=0A=
[    2.380767] wl1271: uploading fw chunk 0xc602aa0c to 0x1ba00=0A=
[    2.381164] wl1271: uploading fw chunk 0xc602ac0c to 0x1bc00=0A=
[    2.381561] wl1271: uploading fw chunk 0xc602ae0c to 0x1be00=0A=
[    2.381927] wl1271: uploading fw chunk 0xc602b00c to 0x1c000=0A=
[    2.382324] wl1271: uploading fw chunk 0xc602b20c to 0x1c200=0A=
[    2.382720] wl1271: uploading fw chunk 0xc602b40c to 0x1c400=0A=
[    2.383087] wl1271: uploading fw chunk 0xc602b60c to 0x1c600=0A=
[    2.383483] wl1271: uploading fw chunk 0xc602b80c to 0x1c800=0A=
[    2.383941] wl1271: uploading fw chunk 0xc602ba0c to 0x1ca00=0A=
[    2.384368] wl1271: uploading fw chunk 0xc602bc0c to 0x1cc00=0A=
[    2.384765] wl1271: uploading fw chunk 0xc602be0c to 0x1ce00=0A=
[    2.385162] wl1271: uploading fw chunk 0xc602c00c to 0x1d000=0A=
[    2.385589] wl1271: uploading fw chunk 0xc602c20c to 0x1d200=0A=
[    2.385986] wl1271: uploading fw chunk 0xc602c40c to 0x1d400=0A=
[    2.386383] wl1271: uploading fw chunk 0xc602c60c to 0x1d600=0A=
[    2.386779] wl1271: uploading fw chunk 0xc602c80c to 0x1d800=0A=
[    2.387207] wl1271: uploading fw chunk 0xc602ca0c to 0x1da00=0A=
[    2.387603] wl1271: uploading fw chunk 0xc602cc0c to 0x1dc00=0A=
[    2.388000] wl1271: uploading fw chunk 0xc602ce0c to 0x1de00=0A=
[    2.388427] wl1271: uploading fw chunk 0xc602d00c to 0x1e000=0A=
[    2.388824] wl1271: uploading fw chunk 0xc602d20c to 0x1e200=0A=
[    2.389221] wl1271: uploading fw chunk 0xc602d40c to 0x1e400=0A=
[    2.389617] wl1271: uploading fw chunk 0xc602d60c to 0x1e600=0A=
[    2.390045] wl1271: uploading fw chunk 0xc602d80c to 0x1e800=0A=
[    2.390441] wl1271: uploading fw chunk 0xc602da0c to 0x1ea00=0A=
[    2.390838] wl1271: uploading fw chunk 0xc602dc0c to 0x1ec00=0A=
[    2.391235] wl1271: uploading fw chunk 0xc602de0c to 0x1ee00=0A=
[    2.391662] wl1271: uploading fw chunk 0xc602e00c to 0x1f000=0A=
[    2.392059] wl1271: uploading fw chunk 0xc602e20c to 0x1f200=0A=
[    2.392486] wl1271: uploading fw chunk 0xc602e40c to 0x1f400=0A=
[    2.392883] wl1271: uploading fw chunk 0xc602e60c to 0x1f600=0A=
[    2.393280] wl1271: uploading fw chunk 0xc602e80c to 0x1f800=0A=
[    2.393676] wl1271: uploading fw chunk 0xc602ea0c to 0x1fa00=0A=
[    2.394104] wl1271: uploading fw chunk 0xc602ec0c to 0x1fc00=0A=
[    2.394500] wl1271: uploading fw chunk 0xc602ee0c to 0x1fe00=0A=
[    2.394897] wl1271: uploading fw chunk 0xc602f00c to 0x20000=0A=
[    2.395324] wl1271: uploading fw chunk 0xc602f20c to 0x20200=0A=
[    2.395721] wl1271: uploading fw chunk 0xc602f40c to 0x20400=0A=
[    2.396118] wl1271: uploading fw chunk 0xc602f60c to 0x20600=0A=
[    2.396514] wl1271: uploading fw chunk 0xc602f80c to 0x20800=0A=
[    2.396942] wl1271: uploading fw chunk 0xc602fa0c to 0x20a00=0A=
[    2.397338] wl1271: uploading fw chunk 0xc602fc0c to 0x20c00=0A=
[    2.397735] wl1271: uploading fw chunk 0xc602fe0c to 0x20e00=0A=
[    2.398132] wl1271: uploading fw chunk 0xc603000c to 0x21000=0A=
[    2.398559] wl1271: uploading fw chunk 0xc603020c to 0x21200=0A=
[    2.398956] wl1271: uploading fw chunk 0xc603040c to 0x21400=0A=
[    2.399353] wl1271: uploading fw chunk 0xc603060c to 0x21600=0A=
[    2.399780] wl1271: uploading fw chunk 0xc603080c to 0x21800=0A=
[    2.400177] wl1271: uploading fw chunk 0xc6030a0c to 0x21a00=0A=
[    2.400573] wl1271: uploading fw chunk 0xc6030c0c to 0x21c00=0A=
[    2.401000] wl1271: uploading fw chunk 0xc6030e0c to 0x21e00=0A=
[    2.401397] wl1271: uploading fw chunk 0xc603100c to 0x22000=0A=
[    2.401794] wl1271: uploading fw chunk 0xc603120c to 0x22200=0A=
[    2.402221] wl1271: uploading fw chunk 0xc603140c to 0x22400=0A=
[    2.402618] wl1271: uploading fw chunk 0xc603160c to 0x22600=0A=
[    2.403015] wl1271: uploading fw chunk 0xc603180c to 0x22800=0A=
[    2.403411] wl1271: uploading fw chunk 0xc6031a0c to 0x22a00=0A=
[    2.403839] wl1271: uploading fw chunk 0xc6031c0c to 0x22c00=0A=
[    2.404235] wl1271: uploading fw chunk 0xc6031e0c to 0x22e00=0A=
[    2.404632] wl1271: uploading fw chunk 0xc603200c to 0x23000=0A=
[    2.405059] wl1271: uploading fw chunk 0xc603220c to 0x23200=0A=
[    2.405456] wl1271: uploading fw chunk 0xc603240c to 0x23400=0A=
[    2.405853] wl1271: uploading fw chunk 0xc603260c to 0x23600=0A=
[    2.406280] wl1271: uploading fw chunk 0xc603280c to 0x23800=0A=
[    2.406677] wl1271: uploading fw chunk 0xc6032a0c to 0x23a00=0A=
[    2.407073] wl1271: uploading fw chunk 0xc6032c0c to 0x23c00=0A=
[    2.407440] wl1271: uploading fw chunk 0xc6032e0c to 0x23e00=0A=
[    2.407836] wl1271: uploading fw chunk 0xc603300c to 0x24000=0A=
[    2.408233] wl1271: uploading fw chunk 0xc603320c to 0x24200=0A=
[    2.408660] wl1271: uploading fw chunk 0xc603340c to 0x24400=0A=
[    2.409057] wl1271: uploading fw chunk 0xc603360c to 0x24600=0A=
[    2.409454] wl1271: uploading fw chunk 0xc603380c to 0x24800=0A=
[    2.409851] wl1271: uploading fw chunk 0xc6033a0c to 0x24a00=0A=
[    2.410278] wl1271: uploading fw chunk 0xc6033c0c to 0x24c00=0A=
[    2.410675] wl1271: uploading fw chunk 0xc6033e0c to 0x24e00=0A=
[    2.411071] wl1271: uploading fw chunk 0xc603400c to 0x25000=0A=
[    2.411499] wl1271: uploading fw chunk 0xc603420c to 0x25200=0A=
[    2.411895] wl1271: uploading fw chunk 0xc603440c to 0x25400=0A=
[    2.412292] wl1271: uploading fw chunk 0xc603460c to 0x25600=0A=
[    2.412689] wl1271: uploading fw chunk 0xc603480c to 0x25800=0A=
[    2.413116] wl1271: uploading fw chunk 0xc6034a0c to 0x25a00=0A=
[    2.413513] wl1271: uploading fw chunk 0xc6034c0c to 0x25c00=0A=
[    2.413909] wl1271: uploading fw chunk 0xc6034e0c to 0x25e00=0A=
[    2.414306] wl1271: uploading fw chunk 0xc603500c to 0x26000=0A=
[    2.414733] wl1271: uploading fw chunk 0xc603520c to 0x26200=0A=
[    2.415130] wl1271: uploading fw chunk 0xc603540c to 0x26400=0A=
[    2.415557] wl1271: uploading fw chunk 0xc603560c to 0x26600=0A=
[    2.415954] wl1271: uploading fw chunk 0xc603580c to 0x26800=0A=
[    2.416351] wl1271: uploading fw chunk 0xc6035a0c to 0x26a00=0A=
[    2.416748] wl1271: uploading fw chunk 0xc6035c0c to 0x26c00=0A=
[    2.417175] wl1271: uploading fw chunk 0xc6035e0c to 0x26e00=0A=
[    2.417572] wl1271: uploading fw chunk 0xc603600c to 0x27000=0A=
[    2.417968] wl1271: uploading fw chunk 0xc603620c to 0x27200=0A=
[    2.418365] wl1271: uploading fw chunk 0xc603640c to 0x27400=0A=
[    2.418792] wl1271: uploading fw chunk 0xc603660c to 0x27600=0A=
[    2.419189] wl1271: uploading fw chunk 0xc603680c to 0x27800=0A=
[    2.419586] wl1271: uploading fw chunk 0xc6036a0c to 0x27a00=0A=
[    2.419982] wl1271: uploading fw chunk 0xc6036c0c to 0x27c00=0A=
[    2.420410] wl1271: uploading fw chunk 0xc6036e0c to 0x27e00=0A=
[    2.420806] wl1271: uploading fw chunk 0xc603700c to 0x28000=0A=
[    2.421203] wl1271: uploading fw chunk 0xc603720c to 0x28200=0A=
[    2.421630] wl1271: uploading fw chunk 0xc603740c to 0x28400=0A=
[    2.422027] wl1271: uploading fw chunk 0xc603760c to 0x28600=0A=
[    2.422424] wl1271: uploading fw chunk 0xc603780c to 0x28800=0A=
[    2.422851] wl1271: uploading fw chunk 0xc6037a0c to 0x28a00=0A=
[    2.423248] wl1271: uploading fw chunk 0xc6037c0c to 0x28c00=0A=
[    2.423645] wl1271: uploading fw chunk 0xc6037e0c to 0x28e00=0A=
[    2.424072] wl1271: uploading fw chunk 0xc603800c to 0x29000=0A=
[    2.424468] wl1271: uploading fw chunk 0xc603820c to 0x29200=0A=
[    2.424865] wl1271: uploading fw chunk 0xc603840c to 0x29400=0A=
[    2.425262] wl1271: uploading fw chunk 0xc603860c to 0x29600=0A=
[    2.425689] wl1271: uploading fw chunk 0xc603880c to 0x29800=0A=
[    2.426086] wl1271: uploading fw chunk 0xc6038a0c to 0x29a00=0A=
[    2.426483] wl1271: uploading fw chunk 0xc6038c0c to 0x29c00=0A=
[    2.426879] wl1271: uploading fw chunk 0xc6038e0c to 0x29e00=0A=
[    2.427307] wl1271: uploading fw chunk 0xc603900c to 0x2a000=0A=
[    2.427703] wl1271: uploading fw chunk 0xc603920c to 0x2a200=0A=
[    2.428100] wl1271: uploading fw chunk 0xc603940c to 0x2a400=0A=
[    2.428527] wl1271: uploading fw chunk 0xc603960c to 0x2a600=0A=
[    2.428924] wl1271: uploading fw chunk 0xc603980c to 0x2a800=0A=
[    2.429321] wl1271: uploading fw chunk 0xc6039a0c to 0x2aa00=0A=
[    2.429748] wl1271: uploading fw chunk 0xc6039c0c to 0x2ac00=0A=
[    2.430145] wl1271: uploading fw chunk 0xc6039e0c to 0x2ae00=0A=
[    2.430603] wl1271: uploading fw chunk 0xc603a00c to 0x2b000=0A=
[    2.430999] wl1271: uploading fw chunk 0xc603a20c to 0x2b200=0A=
[    2.431396] wl1271: uploading fw chunk 0xc603a40c to 0x2b400=0A=
[    2.431823] wl1271: uploading fw chunk 0xc603a60c to 0x2b600=0A=
[    2.432220] wl1271: uploading fw chunk 0xc603a80c to 0x2b800=0A=
[    2.432617] wl1271: uploading fw chunk 0xc603aa0c to 0x2ba00=0A=
[    2.433044] wl1271: uploading fw chunk 0xc603ac0c to 0x2bc00=0A=
[    2.433441] wl1271: uploading fw chunk 0xc603ae0c to 0x2be00=0A=
[    2.433837] wl1271: uploading fw chunk 0xc603b00c to 0x2c000=0A=
[    2.434234] wl1271: uploading fw chunk 0xc603b20c to 0x2c200=0A=
[    2.434661] wl1271: uploading fw chunk 0xc603b40c to 0x2c400=0A=
[    2.435058] wl1271: uploading fw chunk 0xc603b60c to 0x2c600=0A=
[    2.435455] wl1271: uploading fw chunk 0xc603b80c to 0x2c800=0A=
[    2.435882] wl1271: uploading fw chunk 0xc603ba0c to 0x2ca00=0A=
[    2.436279] wl1271: uploading fw chunk 0xc603bc0c to 0x2cc00=0A=
[    2.436676] wl1271: uploading fw chunk 0xc603be0c to 0x2ce00=0A=
[    2.437072] wl1271: uploading fw chunk 0xc603c00c to 0x2d000=0A=
[    2.437500] wl1271: uploading fw chunk 0xc603c20c to 0x2d200=0A=
[    2.437896] wl1271: uploading fw chunk 0xc603c40c to 0x2d400=0A=
[    2.438293] wl1271: uploading fw chunk 0xc603c60c to 0x2d600=0A=
[    2.438659] wl1271: uploading fw chunk 0xc603c80c to 0x2d800=0A=
[    2.439056] wl1271: uploading fw chunk 0xc603ca0c to 0x2da00=0A=
[    2.439453] wl1271: uploading fw chunk 0xc603cc0c to 0x2dc00=0A=
[    2.439880] wl1271: uploading fw chunk 0xc603ce0c to 0x2de00=0A=
[    2.440277] wl1271: uploading fw chunk 0xc603d00c to 0x2e000=0A=
[    2.440673] wl1271: uploading fw chunk 0xc603d20c to 0x2e200=0A=
[    2.441070] wl1271: uploading fw chunk 0xc603d40c to 0x2e400=0A=
[    2.441497] wl1271: uploading fw chunk 0xc603d60c to 0x2e600=0A=
[    2.442230] wl1271: uploading fw chunk 0xc603d80c to 0x2e800=0A=
[    2.442626] wl1271: uploading fw chunk 0xc603da0c to 0x2ea00=0A=
[    2.443023] wl1271: uploading fw chunk 0xc603dc0c to 0x2ec00=0A=
[    2.443450] wl1271: uploading fw chunk 0xc603de0c to 0x2ee00=0A=
[    2.443847] wl1271: uploading fw chunk 0xc603e00c to 0x2f000=0A=
[    2.444244] wl1271: uploading fw chunk 0xc603e20c to 0x2f200=0A=
[    2.444641] wl1271: uploading fw chunk 0xc603e40c to 0x2f400=0A=
[    2.445068] wl1271: uploading fw chunk 0xc603e60c to 0x2f600=0A=
[    2.445465] wl1271: uploading fw chunk 0xc603e80c to 0x2f800=0A=
[    2.445861] wl1271: uploading fw chunk 0xc603ea0c to 0x2fa00=0A=
[    2.446289] wl1271: uploading fw last chunk (340 B) 0xc603ec0c to =
0x2fc00=0A=
[    2.446624] wl1271: chunk 4 addr 0x20000000 len 47604=0A=
[    2.446624] wl1271: starting firmware upload=0A=
[    2.446655] wl1271: fw_data_len 47604 chunk_size 512=0A=
[    2.447326] wl1271: uploading fw chunk 0xc603ed68 to 0x20000000=0A=
[    2.448059] wl1271: uploading fw chunk 0xc603ef68 to 0x20000200=0A=
[    2.448791] wl1271: uploading fw chunk 0xc603f168 to 0x20000400=0A=
[    2.449523] wl1271: uploading fw chunk 0xc603f368 to 0x20000600=0A=
[    2.450256] wl1271: uploading fw chunk 0xc603f568 to 0x20000800=0A=
[    2.450988] wl1271: uploading fw chunk 0xc603f768 to 0x20000a00=0A=
[    2.451721] wl1271: uploading fw chunk 0xc603f968 to 0x20000c00=0A=
[    2.452453] wl1271: uploading fw chunk 0xc603fb68 to 0x20000e00=0A=
[    2.453186] wl1271: uploading fw chunk 0xc603fd68 to 0x20001000=0A=
[    2.453918] wl1271: uploading fw chunk 0xc603ff68 to 0x20001200=0A=
[    2.454620] wl1271: uploading fw chunk 0xc6040168 to 0x20001400=0A=
[    2.455352] wl1271: uploading fw chunk 0xc6040368 to 0x20001600=0A=
[    2.456085] wl1271: uploading fw chunk 0xc6040568 to 0x20001800=0A=
[    2.456817] wl1271: uploading fw chunk 0xc6040768 to 0x20001a00=0A=
[    2.457550] wl1271: uploading fw chunk 0xc6040968 to 0x20001c00=0A=
[    2.458282] wl1271: uploading fw chunk 0xc6040b68 to 0x20001e00=0A=
[    2.459014] wl1271: uploading fw chunk 0xc6040d68 to 0x20002000=0A=
[    2.459747] wl1271: uploading fw chunk 0xc6040f68 to 0x20002200=0A=
[    2.460479] wl1271: uploading fw chunk 0xc6041168 to 0x20002400=0A=
[    2.461212] wl1271: uploading fw chunk 0xc6041368 to 0x20002600=0A=
[    2.462005] wl1271: uploading fw chunk 0xc6041568 to 0x20002800=0A=
[    2.462738] wl1271: uploading fw chunk 0xc6041768 to 0x20002a00=0A=
[    2.463470] wl1271: uploading fw chunk 0xc6041968 to 0x20002c00=0A=
[    2.464202] wl1271: uploading fw chunk 0xc6041b68 to 0x20002e00=0A=
[    2.464935] wl1271: uploading fw chunk 0xc6041d68 to 0x20003000=0A=
[    2.465667] wl1271: uploading fw chunk 0xc6041f68 to 0x20003200=0A=
[    2.466400] wl1271: uploading fw chunk 0xc6042168 to 0x20003400=0A=
[    2.467132] wl1271: uploading fw chunk 0xc6042368 to 0x20003600=0A=
[    2.467864] wl1271: uploading fw chunk 0xc6042568 to 0x20003800=0A=
[    2.468597] wl1271: uploading fw chunk 0xc6042768 to 0x20003a00=0A=
[    2.469329] wl1271: uploading fw chunk 0xc6042968 to 0x20003c00=0A=
[    2.470062] wl1271: uploading fw chunk 0xc6042b68 to 0x20003e00=0A=
[    2.470764] wl1271: uploading fw chunk 0xc6042d68 to 0x20004000=0A=
[    2.471496] wl1271: uploading fw chunk 0xc6042f68 to 0x20004200=0A=
[    2.472198] wl1271: uploading fw chunk 0xc6043168 to 0x20004400=0A=
[    2.472900] wl1271: uploading fw chunk 0xc6043368 to 0x20004600=0A=
[    2.473602] wl1271: uploading fw chunk 0xc6043568 to 0x20004800=0A=
[    2.474334] wl1271: uploading fw chunk 0xc6043768 to 0x20004a00=0A=
[    2.475036] wl1271: uploading fw chunk 0xc6043968 to 0x20004c00=0A=
[    2.475769] wl1271: uploading fw chunk 0xc6043b68 to 0x20004e00=0A=
[    2.476470] wl1271: uploading fw chunk 0xc6043d68 to 0x20005000=0A=
[    2.477172] wl1271: uploading fw chunk 0xc6043f68 to 0x20005200=0A=
[    2.477966] wl1271: uploading fw chunk 0xc6044168 to 0x20005400=0A=
[    2.478698] wl1271: uploading fw chunk 0xc6044368 to 0x20005600=0A=
[    2.479431] wl1271: uploading fw chunk 0xc6044568 to 0x20005800=0A=
[    2.480163] wl1271: uploading fw chunk 0xc6044768 to 0x20005a00=0A=
[    2.480895] wl1271: uploading fw chunk 0xc6044968 to 0x20005c00=0A=
[    2.481628] wl1271: uploading fw chunk 0xc6044b68 to 0x20005e00=0A=
[    2.482360] wl1271: uploading fw chunk 0xc6044d68 to 0x20006000=0A=
[    2.483093] wl1271: uploading fw chunk 0xc6044f68 to 0x20006200=0A=
[    2.483825] wl1271: uploading fw chunk 0xc6045168 to 0x20006400=0A=
[    2.484558] wl1271: uploading fw chunk 0xc6045368 to 0x20006600=0A=
[    2.485290] wl1271: uploading fw chunk 0xc6045568 to 0x20006800=0A=
[    2.486083] wl1271: uploading fw chunk 0xc6045768 to 0x20006a00=0A=
[    2.486816] wl1271: uploading fw chunk 0xc6045968 to 0x20006c00=0A=
[    2.487548] wl1271: uploading fw chunk 0xc6045b68 to 0x20006e00=0A=
[    2.488281] wl1271: uploading fw chunk 0xc6045d68 to 0x20007000=0A=
[    2.489013] wl1271: uploading fw chunk 0xc6045f68 to 0x20007200=0A=
[    2.489746] wl1271: uploading fw chunk 0xc6046168 to 0x20007400=0A=
[    2.490478] wl1271: uploading fw chunk 0xc6046368 to 0x20007600=0A=
[    2.491210] wl1271: uploading fw chunk 0xc6046568 to 0x20007800=0A=
[    2.491943] wl1271: uploading fw chunk 0xc6046768 to 0x20007a00=0A=
[    2.492675] wl1271: uploading fw chunk 0xc6046968 to 0x20007c00=0A=
[    2.493408] wl1271: uploading fw chunk 0xc6046b68 to 0x20007e00=0A=
[    2.494140] wl1271: uploading fw chunk 0xc6046d68 to 0x20008000=0A=
[    2.494873] wl1271: uploading fw chunk 0xc6046f68 to 0x20008200=0A=
[    2.495605] wl1271: uploading fw chunk 0xc6047168 to 0x20008400=0A=
[    2.496337] wl1271: uploading fw chunk 0xc6047368 to 0x20008600=0A=
[    2.497070] wl1271: uploading fw chunk 0xc6047568 to 0x20008800=0A=
[    2.497802] wl1271: uploading fw chunk 0xc6047768 to 0x20008a00=0A=
[    2.498535] wl1271: uploading fw chunk 0xc6047968 to 0x20008c00=0A=
[    2.499267] wl1271: uploading fw chunk 0xc6047b68 to 0x20008e00=0A=
[    2.500000] wl1271: uploading fw chunk 0xc6047d68 to 0x20009000=0A=
[    2.500732] wl1271: uploading fw chunk 0xc6047f68 to 0x20009200=0A=
[    2.501464] wl1271: uploading fw chunk 0xc6048168 to 0x20009400=0A=
[    2.502197] wl1271: uploading fw chunk 0xc6048368 to 0x20009600=0A=
[    2.502929] wl1271: uploading fw chunk 0xc6048568 to 0x20009800=0A=
[    2.503662] wl1271: uploading fw chunk 0xc6048768 to 0x20009a00=0A=
[    2.504394] wl1271: uploading fw chunk 0xc6048968 to 0x20009c00=0A=
[    2.505126] wl1271: uploading fw chunk 0xc6048b68 to 0x20009e00=0A=
[    2.505859] wl1271: uploading fw chunk 0xc6048d68 to 0x2000a000=0A=
[    2.506591] wl1271: uploading fw chunk 0xc6048f68 to 0x2000a200=0A=
[    2.507293] wl1271: uploading fw chunk 0xc6049168 to 0x2000a400=0A=
[    2.508026] wl1271: uploading fw chunk 0xc6049368 to 0x2000a600=0A=
[    2.508819] wl1271: uploading fw chunk 0xc6049568 to 0x2000a800=0A=
[    2.509552] wl1271: uploading fw chunk 0xc6049768 to 0x2000aa00=0A=
[    2.510284] wl1271: uploading fw chunk 0xc6049968 to 0x2000ac00=0A=
[    2.511016] wl1271: uploading fw chunk 0xc6049b68 to 0x2000ae00=0A=
[    2.511749] wl1271: uploading fw chunk 0xc6049d68 to 0x2000b000=0A=
[    2.512481] wl1271: uploading fw chunk 0xc6049f68 to 0x2000b200=0A=
[    2.513214] wl1271: uploading fw chunk 0xc604a168 to 0x2000b400=0A=
[    2.513946] wl1271: uploading fw chunk 0xc604a368 to 0x2000b600=0A=
[    2.514343] wl1271: uploading fw last chunk (500 B) 0xc604a568 to =
0x2000b800=0A=
[    2.514770] wl1271: chunk 3 addr 0x40000 len 448=0A=
[    2.514770] wl1271: starting firmware upload=0A=
[    2.514801] wl1271: fw_data_len 448 chunk_size 512=0A=
[    2.515136] wl1271: uploading fw last chunk (448 B) 0xc604a764 to =
0x40000=0A=
[    2.515533] wl1271: chunk 2 addr 0x40be0 len 15988=0A=
[    2.515533] wl1271: starting firmware upload=0A=
[    2.515563] wl1271: fw_data_len 15988 chunk_size 512=0A=
[    2.516235] wl1271: uploading fw chunk 0xc604a92c to 0x40be0=0A=
[    2.516967] wl1271: uploading fw chunk 0xc604ab2c to 0x40de0=0A=
[    2.517700] wl1271: uploading fw chunk 0xc604ad2c to 0x40fe0=0A=
[    2.518432] wl1271: uploading fw chunk 0xc604af2c to 0x411e0=0A=
[    2.519165] wl1271: uploading fw chunk 0xc604b12c to 0x413e0=0A=
[    2.519897] wl1271: uploading fw chunk 0xc604b32c to 0x415e0=0A=
[    2.520629] wl1271: uploading fw chunk 0xc604b52c to 0x417e0=0A=
[    2.521362] wl1271: uploading fw chunk 0xc604b72c to 0x419e0=0A=
[    2.522094] wl1271: uploading fw chunk 0xc604b92c to 0x41be0=0A=
[    2.522827] wl1271: uploading fw chunk 0xc604bb2c to 0x41de0=0A=
[    2.523559] wl1271: uploading fw chunk 0xc604bd2c to 0x41fe0=0A=
[    2.524291] wl1271: uploading fw chunk 0xc604bf2c to 0x421e0=0A=
[    2.525024] wl1271: uploading fw chunk 0xc604c12c to 0x423e0=0A=
[    2.525756] wl1271: uploading fw chunk 0xc604c32c to 0x425e0=0A=
[    2.526489] wl1271: uploading fw chunk 0xc604c52c to 0x427e0=0A=
[    2.527221] wl1271: uploading fw chunk 0xc604c72c to 0x429e0=0A=
[    2.527954] wl1271: uploading fw chunk 0xc604c92c to 0x42be0=0A=
[    2.528656] wl1271: uploading fw chunk 0xc604cb2c to 0x42de0=0A=
[    2.529388] wl1271: uploading fw chunk 0xc604cd2c to 0x42fe0=0A=
[    2.530120] wl1271: uploading fw chunk 0xc604cf2c to 0x431e0=0A=
[    2.530853] wl1271: uploading fw chunk 0xc604d12c to 0x433e0=0A=
[    2.531585] wl1271: uploading fw chunk 0xc604d32c to 0x435e0=0A=
[    2.532379] wl1271: uploading fw chunk 0xc604d52c to 0x437e0=0A=
[    2.533111] wl1271: uploading fw chunk 0xc604d72c to 0x439e0=0A=
[    2.533843] wl1271: uploading fw chunk 0xc604d92c to 0x43be0=0A=
[    2.534576] wl1271: uploading fw chunk 0xc604db2c to 0x43de0=0A=
[    2.535308] wl1271: uploading fw chunk 0xc604dd2c to 0x43fe0=0A=
[    2.536041] wl1271: uploading fw chunk 0xc604df2c to 0x441e0=0A=
[    2.536773] wl1271: uploading fw chunk 0xc604e12c to 0x443e0=0A=
[    2.537506] wl1271: uploading fw chunk 0xc604e32c to 0x445e0=0A=
[    2.538238] wl1271: uploading fw chunk 0xc604e52c to 0x447e0=0A=
[    2.538635] wl1271: uploading fw last chunk (116 B) 0xc604e72c to =
0x449e0=0A=
[    2.538940] wl1271: chunk 1 addr 0x312000 len 7936=0A=
[    2.538970] wl1271: starting firmware upload=0A=
[    2.538970] wl1271: fw_data_len 7936 chunk_size 512=0A=
[    2.539642] wl1271: uploading fw chunk 0xc604e7a8 to 0x312000=0A=
[    2.540405] wl1271: uploading fw chunk 0xc604e9a8 to 0x312200=0A=
[    2.541107] wl1271: uploading fw chunk 0xc604eba8 to 0x312400=0A=
[    2.541839] wl1271: uploading fw chunk 0xc604eda8 to 0x312600=0A=
[    2.542572] wl1271: uploading fw chunk 0xc604efa8 to 0x312800=0A=
[    2.543304] wl1271: uploading fw chunk 0xc604f1a8 to 0x312a00=0A=
[    2.544036] wl1271: uploading fw chunk 0xc604f3a8 to 0x312c00=0A=
[    2.544769] wl1271: uploading fw chunk 0xc604f5a8 to 0x312e00=0A=
[    2.545501] wl1271: uploading fw chunk 0xc604f7a8 to 0x313000=0A=
[    2.546234] wl1271: uploading fw chunk 0xc604f9a8 to 0x313200=0A=
[    2.546966] wl1271: uploading fw chunk 0xc604fba8 to 0x313400=0A=
[    2.547698] wl1271: uploading fw chunk 0xc604fda8 to 0x313600=0A=
[    2.548370] wl1271: uploading fw chunk 0xc604ffa8 to 0x313800=0A=
[    2.549102] wl1271: uploading fw chunk 0xc60501a8 to 0x313a00=0A=
[    2.549835] wl1271: uploading fw chunk 0xc60503a8 to 0x313c00=0A=
[    2.550262] wl1271: uploading fw last chunk (256 B) 0xc60505a8 to =
0x313e00=0A=
[    2.550567] wl1271: chunk 0 addr 0x316000 len 3760=0A=
[    2.550567] wl1271: starting firmware upload=0A=
[    2.550567] wl1271: fw_data_len 3760 chunk_size 512=0A=
[    2.551239] wl1271: uploading fw chunk 0xc60506b0 to 0x316000=0A=
[    2.551971] wl1271: uploading fw chunk 0xc60508b0 to 0x316200=0A=
[    2.552703] wl1271: uploading fw chunk 0xc6050ab0 to 0x316400=0A=
[    2.553436] wl1271: uploading fw chunk 0xc6050cb0 to 0x316600=0A=
[    2.554168] wl1271: uploading fw chunk 0xc6050eb0 to 0x316800=0A=
[    2.554901] wl1271: uploading fw chunk 0xc60510b0 to 0x316a00=0A=
[    2.555694] wl1271: uploading fw chunk 0xc60512b0 to 0x316c00=0A=
[    2.556091] wl1271: uploading fw last chunk (176 B) 0xc60514b0 to =
0x316e00=0A=
[    2.556549] wl1271: chip id after firmware boot: 0x4030111=0A=
[    2.576507] wl1271: cmd_box_addr 0x407b4 event_box_addr 0x4ce58=0A=
[    2.576660] wl1271: acx event mbox mask=0A=
[    2.576660] wl1271: cmd configure=0A=
[    2.576995] MBOX ptrs: 0x4ce58 0x4ceac=0A=
[    2.581146] MBOX ptrs: 0x4ce58 0x4ceac=0A=
[    2.585083] wl1271: cmd test=0A=
[    2.585479] wl1271: TEST_CMD_INI_FILE_RADIO_PARAM: 00000000: 00 00 00 =
00 19 00 00 00 00 00 ec f6 00 0c 18 f8=0A=
[    2.585510] wl1271: TEST_CMD_INI_FILE_RADIO_PARAM: 00000010: fc 00 08 =
10 f0 f8 00 0a 14 00 00 00 00 00 00 00=0A=
[    2.585540] wl1271: TEST_CMD_INI_FILE_RADIO_PARAM: 00000020: 00 00 00 =
00 00 00 00 ee f4 f8 fe 05 ea f3 fa 01=0A=
[    2.585571] wl1271: TEST_CMD_INI_FILE_RADIO_PARAM: 00000030: 06 e5 f1 =
fa 02 07 d9 01 80 00 1d 1f 22 26 27 29=0A=
[    2.585571] wl1271: TEST_CMD_INI_FILE_RADIO_PARAM: 00000040: 1d 1f 22 =
26 27 27 16 1d 1e 20 24 25 50 50 50 50=0A=
[    2.585601] wl1271: TEST_CMD_INI_FILE_RADIO_PARAM: 00000050: 50 50 50 =
50 50 50 50 50 50 50 50 50 50 50 50 50=0A=
[    2.585632] wl1271: TEST_CMD_INI_FILE_RADIO_PARAM: 00000060: 50 50 50 =
50 50 50 50 50 01 02 02 02 02 00 15 15=0A=
[    2.585662] wl1271: TEST_CMD_INI_FILE_RADIO_PARAM: 00000070: 15 19 19 =
15 0e 1e 2d 00 9a 01 ae 01 c2 01 cc 01=0A=
[    2.585662] wl1271: TEST_CMD_INI_FILE_RADIO_PARAM: 00000080: db 01 db =
01 d1 01 80 80 80 80 80 80 80 00 00 00=0A=
[    2.585693] wl1271: TEST_CMD_INI_FILE_RADIO_PARAM: 00000090: 00 00 00 =
00 1c 1e 21 23 25 50 18 1e 21 23 25 50=0A=
[    2.585723] wl1271: TEST_CMD_INI_FILE_RADIO_PARAM: 000000a0: 16 1c 1e =
20 20 50 50 50 50 50 50 50 50 50 50 50=0A=
[    2.585754] wl1271: TEST_CMD_INI_FILE_RADIO_PARAM: 000000b0: 50 50 50 =
50 50 50 50 50 50 50 50 50 50 50 50 50=0A=
[    2.585754] wl1271: TEST_CMD_INI_FILE_RADIO_PARAM: 000000c0: 50 50 50 =
50 50 50 50 50 50 01 02 02 02 02 00 1a=0A=
[    2.585784] wl1271: TEST_CMD_INI_FILE_RADIO_PARAM: 000000d0: 1a 1a 1a =
1a 1a 10 10 10 10 10 10 10 1e 2d 00 00=0A=
[    2.585815] wl1271: cmd test=0A=
[    2.586303] wl1271: cmd template_set 2=0A=
[    2.586791] wl1271: cmd template_set 0=0A=
[    2.587219] wl1271: cmd template_set 6=0A=
[    2.587707] wl1271: cmd template_set 5=0A=
[    2.588226] wl1271: cmd template_set 4=0A=
[    2.588714] wl1271: cmd template_set 1=0A=
[    2.589202] wl1271: cmd template_set 7=0A=
[    2.589691] wl1271: cmd template_set 7=0A=
[    2.590179] wl1271: cmd template_set 7=0A=
[    2.590698] wl1271: cmd template_set 7=0A=
[    2.591186] wl1271: wl1271 mem cfg=0A=
[    2.591186] wl1271: cmd configure=0A=
[    2.591674] wl1271: acx mem map=0A=
[    2.591705] wl1271: cmd interrogate=0A=
[    2.592193] wl1271: available tx blocks: 83=0A=
[    2.592193] wl1271: acx rx msdu life time=0A=
[    2.592224] wl1271: cmd configure=0A=
[    2.592468] wl1271: acx rx config=0A=
[    2.592498] wl1271: cmd configure=0A=
[    2.592742] wl1271: acx data pd threshold=0A=
[    2.592742] wl1271: cmd configure=0A=
[    2.593017] wl1271: acx slot=0A=
[    2.593017] wl1271: cmd configure=0A=
[    2.593261] wl1271: acx group address tbl=0A=
[    2.593292] wl1271: cmd configure=0A=
[    2.593627] wl1271: acx service period timeout=0A=
[    2.593627] wl1271: cmd configure=0A=
[    2.593902] wl1271: acx rts threshold=0A=
[    2.593902] wl1271: cmd configure=0A=
[    2.594146] wl1271: acx connection monitor parameters: disabled=0A=
[    2.594177] wl1271: cmd configure=0A=
[    2.594421] wl1271: acx beacon filter opt=0A=
[    2.594451] wl1271: cmd configure=0A=
[    2.594757] wl1271: acx beacon filter table=0A=
[    2.594757] wl1271: cmd configure=0A=
[    2.595092] wl1271: acx tx config options=0A=
[    2.595123] wl1271: cmd configure=0A=
[    2.595367] wl1271: wl1271 rx interrupt config=0A=
[    2.595367] wl1271: cmd configure=0A=
[    2.595642] wl1271: acx sg cfg=0A=
[    2.595642] wl1271: cmd configure=0A=
[    2.598236] wl1271: acx sg enable=0A=
[    2.598236] wl1271: cmd configure=0A=
[    2.598510] wl1271: acx cca threshold=0A=
[    2.598510] wl1271: cmd configure=0A=
[    2.598754] wl1271: acx bcn dtim options=0A=
[    2.598785] wl1271: cmd configure=0A=
[    2.599029] wl1271: acx frag threshold=0A=
[    2.599060] wl1271: cmd configure=0A=
[    2.599304] wl1271: acx tid config=0A=
[    2.599334] wl1271: cmd configure=0A=
[    2.599578] wl1271: acx tid config=0A=
[    2.599578] wl1271: cmd configure=0A=
[    2.599822] wl1271: acx tid config=0A=
[    2.599853] wl1271: cmd configure=0A=
[    2.600097] wl1271: acx tid config=0A=
[    2.600128] wl1271: cmd configure=0A=
[    2.600372] wl1271: acx tid config=0A=
[    2.600372] wl1271: cmd configure=0A=
[    2.600616] wl1271: acx tid config=0A=
[    2.600646] wl1271: cmd configure=0A=
[    2.600891] wl1271: acx tid config=0A=
[    2.600921] wl1271: cmd configure=0A=
[    2.601165] wl1271: acx ac cfg 0 cw_ming 15 cw_max 63 aifs 3 txop 0=0A=
[    2.601196] wl1271: cmd configure=0A=
[    2.601440] wl1271: acx ac cfg 1 cw_ming 15 cw_max 63 aifs 7 txop 0=0A=
[    2.601470] wl1271: cmd configure=0A=
[    2.601715] wl1271: acx ac cfg 2 cw_ming 15 cw_max 63 aifs 1 txop 3008=0A=
[    2.601745] wl1271: cmd configure=0A=
[    2.601989] wl1271: acx ac cfg 3 cw_ming 15 cw_max 63 aifs 1 txop 1504=0A=
[    2.602020] wl1271: cmd configure=0A=
[    2.602264] wl1271: acx rate policies=0A=
[    2.602264] wl1271: cmd configure=0A=
[    2.602630] wl1271: cmd data path=0A=
[    2.602905] wl1271: rx start cmd channel 1=0A=
[    2.603149] wl1271: tx start cmd channel 1=0A=
[    2.603179] wl1271: acx sleep auth=0A=
[    2.603179] wl1271: cmd configure=0A=
[    2.603454] wl1271: acx feature cfg=0A=
[    2.603454] wl1271: cmd configure=0A=
[    2.603881] wl1271: cmd set_default_wep_key 0=0A=
[    2.604370] wl1271: acx pm config=0A=
[    2.604400] wl1271: cmd configure=0A=
[    2.604827] wl1271: acx keep alive config=0A=
[    2.604827] wl1271: cmd configure=0A=
[    2.605255] wl1271: acx keep alive config=0A=
[    2.605285] wl1271: cmd configure=0A=
[    2.605712] wl1271: acx keep alive config=0A=
[    2.605712] wl1271: cmd configure=0A=
[    2.606140] wl1271: acx keep alive config=0A=
[    2.606140] wl1271: cmd configure=0A=
[    2.606567] wl1271: acx keep alive mode: 0=0A=
[    2.606597] wl1271: cmd configure=0A=
[    2.607025] wl1271: acx rssi snr avg weights=0A=
[    2.607025] wl1271: cmd configure=0A=
[    2.607452] wl1271: firmware booted (Rev 6.1.0.0.343)=0A=
[    2.607482] wl1271: mac80211 bss info changed=0A=
[    2.607482] wl1271: acx slot=0A=
[    2.607513] wl1271: cmd configure=0A=
[    2.607940] wl1271: acx_set_preamble=0A=
[    2.607940] wl1271: cmd configure=0A=
[    2.608367] wl1271: acx_set_ctsprotect=0A=
[    2.608398] wl1271: cmd configure=0A=
[    2.608825] phy0: device now idle=0A=
[    2.608886] wl1271: mac80211 config ch 1 psm off power 20 idle=0A=
[    2.608917] wl1271: flushing tx buffer: 0=0A=
[    2.608917] wl1271: acx rate policies=0A=
[    2.608947] wl1271: cmd configure=0A=
[    2.609466] wl1271: acx rate policies=0A=
[    2.609466] wl1271: cmd configure=0A=
[    2.609954] wl1271: acx keep alive config=0A=
[    2.609985] wl1271: cmd configure=0A=
[    2.610473] wl1271: acx dot11_cur_tx_pwr=0A=
[    2.610473] wl1271: cmd configure=0A=
[    2.610931] wl1271: mac80211 conf tx 0=0A=
[    2.610931] wl1271: acx ac cfg 3 cw_ming 7 cw_max 15 aifs 2 txop 3264=0A=
[    2.610961] wl1271: cmd configure=0A=
[    2.611389] wl1271: acx tid config=0A=
[    2.611389] wl1271: cmd configure=0A=
[    2.611816] wl1271: mac80211 conf tx 1=0A=
[    2.611846] wl1271: acx ac cfg 2 cw_ming 15 cw_max 31 aifs 2 txop 6016=0A=
[    2.611877] wl1271: cmd configure=0A=
[    2.612274] wl1271: acx tid config=0A=
[    2.612304] wl1271: cmd configure=0A=
[    2.612731] wl1271: mac80211 conf tx 2=0A=
[    2.612762] wl1271: acx ac cfg 0 cw_ming 31 cw_max 1023 aifs 3 txop 0=0A=
[    2.612762] wl1271: cmd configure=0A=
[    2.613189] wl1271: acx tid config=0A=
[    2.613220] wl1271: cmd configure=0A=
[    2.613647] wl1271: mac80211 conf tx 3=0A=
[    2.613647] wl1271: acx ac cfg 1 cw_ming 31 cw_max 1023 aifs 7 txop 0=0A=
[    2.613677] wl1271: cmd configure=0A=
[    2.614105] wl1271: acx tid config=0A=
[    2.614105] wl1271: cmd configure=0A=
[    2.614532] wl1271: mac80211 bss info changed=0A=
[    2.614593] wl1271: mac80211 configure filter=0A=
[    2.614624] wl1271: acx group address tbl=0A=
[    2.614624] wl1271: cmd configure=0A=
[    2.615173] AIRVOD __dev_change_flags   net/core/dev.c ret =3D 0=0A=
[    2.621398] wl1271: elp work=0A=
[    2.621398] wl1271: chip to elp=0A=
[    2.621459] wl1271: mac80211 configure filter=0A=
[    2.621490] wl1271: waking up chip from elp=0A=
[    3.118377] wl1271: ERROR ELP wakeup timeout!=0A=
[    3.122955] wl1271: mac80211 configure filter=0A=
[    3.122985] wl1271: waking up chip from elp=0A=
[    3.618469] wl1271: ERROR ELP wakeup timeout!=0A=
[    3.626098] Sending DHCP requests .=0A=
[    5.627655] DHCP/BOOTP: Ignoring delayed packet=0A=
[    7.266723] .=0A=
[    8.767333] DHCP/BOOTP: Ignoring delayed packet=0A=
[   12.508941] ., OK=0A=
[   14.017211] IP-Config: Got DHCP answer from 0.0.0.0, my address is =
192.168.1.14=0A=
[   14.024993] AIRVOD __dev_change_flags   net/core/dev.c ret =3D 0=0A=
[   14.031341] AIRVOD __dev_change_flags   net/core/dev.c ret =3D 0=0A=
[   14.037750] wl1271: mac80211 configure filter=0A=
[   14.037750] wl1271: waking up chip from elp=0A=
[   14.037872] wl1271: mac80211 configure filter=0A=
[   14.532409] wl1271: ERROR ELP wakeup timeout!=0A=
[   14.537017] wl1271: waking up chip from elp=0A=
[   15.032409] wl1271: ERROR ELP wakeup timeout!=0A=
[   15.037017] wl1271: mac80211 remove interface=0A=
[   15.037017] wl1271: down=0A=
[   15.037139] wl1271: mac80211 stop=0A=
[   15.037170] AIRVOD __dev_change_flags   net/core/dev.c ret =3D 0=0A=
[   15.043975] IP-Config: Complete:=0A=
[   15.047180]      device=3Deth0, addr=3D192.168.1.14, =
mask=3D255.255.255.0, gw=3D192.168.1.1,=0A=
[   15.055328]      host=3D192.168.1.14, domain=3D, nis-domain=3D(none),=0A=
[   15.061614]      bootserver=3D0.0.0.0, rootserver=3D192.168.1.4, =
rootpath=3D, mtu=3D576=0A=
[   15.070037] Looking up port of RPC 100003/2 on 192.168.1.4=0A=
[   15.153350] Looking up port of RPC 100005/1 on 192.168.1.4=0A=
[   15.431274] device: '0:12': device_add=0A=
[   15.431427] PM: Adding info for No Bus:0:12=0A=
[   15.433990] VFS: Mounted root (nfs filesystem) on device 0:12.=0A=
[   15.440368] Freeing init memory: 264K=0A=
[   18.859985] udevd (110): /proc/110/oom_adj is deprecated, please use =
/proc/110/oom_score_adj instead.=0A=
[   19.874969] device: 'wlan0': device_rename: renaming to 'wlan1'=0A=

------=_NextPart_000_0048_01CB81C0.01E4B1E0--

