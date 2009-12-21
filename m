Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38108 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751302AbZLUXuy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2009 18:50:54 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Joseph Nahmias <joe@nahmias.net>
Cc: linux-wireless@vger.kernel.org, 562016@bugs.debian.org
In-Reply-To: <20091221232801.3371.80870.reportbug@wakko.nahmias.net>
References: <20091221232801.3371.80870.reportbug@wakko.nahmias.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-REBiTLVjQ2AEeCw/WIVU"
Date: Mon, 21 Dec 2009 23:50:41 +0000
Message-ID: <1261439441.25157.307.camel@localhost>
Mime-Version: 1.0
Subject: Re: Bug#562016: kernel WARNING in cfg80211 module
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-REBiTLVjQ2AEeCw/WIVU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-12-21 at 18:28 -0500, Joseph Nahmias wrote:
> Package: linux-2.6
> Version: 2.6.32-2
> Severity: normal
>=20
> Hello,
>=20
> I just rebooted into the new 2.6.32 kernel package and noticed that the
> kernel threw a WARNING during boot-up.  I presume this needs to be
> forwarded to linux-wireless, but leave it to the more knowledgeable
> maintainers to make that determination.

Yes, this looks like an issue with the mainline kernel, so let's see
what people on linux-wireless have to say.

Ben.

> -- Package-specific info:
> ** Version:
> Linux version 2.6.32-trunk-686 (Debian 2.6.32-2) (ben@decadent.org.uk) (g=
cc version 4.3.4 (Debian 4.3.4-6) ) #1 SMP Thu Dec 17 00:26:04 UTC 2009
>=20
> ** Command line:
> root=3D/dev/mapper/diskvg-root ro vga=3D871 selinux=3D1 irqpoll=20
>=20
> ** Tainted: W (512)
>  * Taint on warning.
>=20
> ** Kernel log:
> [   19.961933] NTFS-fs warning (device sda1): load_system_files(): Unsupp=
orted volume flags 0x4000 encountered.
> [   19.975444] NTFS-fs error (device sda1): load_system_files(): Volume h=
as unsupported flags set.  Mounting read-only.  Run chkdsk and mount in Win=
dows.
> [   20.059006] SELinux: initialized (dev sda1, type ntfs), uses genfs_con=
texts
> [   20.308495] Adding 524280k swap on /dev/mapper/diskvg-swap.  Priority:=
-1 extents:1 across:524280k=20
> [   22.721825] type=3D1400 audit(1261437335.807:5): avc:  denied  { searc=
h } for  pid=3D1192 comm=3D"rpc.statd" name=3D"sbin" dev=3Ddm-0 ino=3D19660=
9 scontext=3Dsystem_u:system_r:rpcd_t:s0 tcontext=3Dsystem_u:object_r:sbin_=
t:s0 tclass=3Ddir
> [   22.750681] type=3D1400 audit(1261437335.837:6): avc:  denied  { execu=
te } for  pid=3D1192 comm=3D"rpc.statd" name=3D"sm-notify" dev=3Ddm-0 ino=
=3D198780 scontext=3Dsystem_u:system_r:rpcd_t:s0 tcontext=3Dsystem_u:object=
_r:sbin_t:s0 tclass=3Dfile
> [   22.781069] type=3D1400 audit(1261437335.867:7): avc:  denied  { read =
} for  pid=3D1192 comm=3D"rpc.statd" name=3D"sm-notify" dev=3Ddm-0 ino=3D19=
8780 scontext=3Dsystem_u:system_r:rpcd_t:s0 tcontext=3Dsystem_u:object_r:sb=
in_t:s0 tclass=3Dfile
> [   22.813318] type=3D1400 audit(1261437335.899:8): avc:  denied  { execu=
te_no_trans } for  pid=3D1192 comm=3D"rpc.statd" path=3D"/sbin/sm-notify" d=
ev=3Ddm-0 ino=3D198780 scontext=3Dsystem_u:system_r:rpcd_t:s0 tcontext=3Dsy=
stem_u:object_r:sbin_t:s0 tclass=3Dfile
> [   23.011784] type=3D1400 audit(1261437336.098:9): avc:  denied  { searc=
h } for  pid=3D1191 comm=3D"rpc.statd" scontext=3Dsystem_u:system_r:rpcd_t:=
s0 tcontext=3Dsystem_u:object_r:sysctl_fs_t:s0 tclass=3Ddir
> [   24.451013] fuse init (API version 7.13)
> [   24.459343] SELinux: initialized (dev fusectl, type fusectl), not conf=
igured for labeling
> [   24.459388] type=3D1400 audit(1261437337.544:10): avc:  denied  { moun=
t } for  pid=3D1307 comm=3D"mount" name=3D"/" dev=3Dfusectl ino=3D1 scontex=
t=3Dsystem_u:system_r:mount_t:s0 tcontext=3Dsystem_u:object_r:unlabeled_t:s=
0 tclass=3Dfilesystem
> [   27.155293] hdaps: inverting axis (3) readings.
> [   27.155547] hdaps: LENOVO ThinkPad T61 detected.
> [   27.157802] input: hdaps as /devices/platform/hdaps/input/input8
> [   27.158247] hdaps: driver successfully loaded.
> [   27.715624] input: ACPI Virtual Keyboard Device as /devices/virtual/in=
put/input9
> [   27.880138] SELinux: initialized (dev binfmt_misc, type binfmt_misc), =
uses genfs_contexts
> [   32.269939] apm: BIOS not found.
> [   32.959138] SELinux: initialized (dev autofs, type autofs), uses genfs=
_contexts
> [   32.959798] SELinux: initialized (dev autofs, type autofs), uses genfs=
_contexts
> [   32.963218] SELinux: initialized (dev autofs, type autofs), uses genfs=
_contexts
> [   43.356521] Bluetooth: L2CAP ver 2.14
> [   43.356725] Bluetooth: L2CAP socket layer initialized
> [   43.367135] Bluetooth: RFCOMM TTY layer initialized
> [   43.367376] Bluetooth: RFCOMM socket layer initialized
> [   43.367618] Bluetooth: RFCOMM ver 1.11
> [   43.599113] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
> [   43.599401] Bluetooth: BNEP filters: protocol multicast
> [   43.672862] Bridge firewalling registered
> [   43.820658] Bluetooth: SCO (Voice Link) ver 0.6
> [   43.820885] Bluetooth: SCO socket layer initialized
> [   49.144551] lp: driver loaded but no devices found
> [   49.247501] ppdev: user-space parallel port driver
> [   49.743983] ADDRCONF(NETDEV_UP): ath0: link is not ready
> [   54.152637] [drm] Initialized drm 1.1.0 20060810
> [   54.206930] pci 0000:00:02.0: power state changed by ACPI to D0
> [   54.206951] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ =
16
> [   54.206962] pci 0000:00:02.0: setting latency timer to 64
> [   54.224543] pci 0000:00:02.0: irq 31 for MSI/MSI-X
> [   54.230829] acpi device:01: registered as cooling_device2
> [   54.232043] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A=
08:00/LNXVIDEO:00/input/input10
> [   54.232208] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: =
no)
> [   54.232637] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on =
minor 0
> [   56.084489] e1000e 0000:00:19.0: irq 29 for MSI/MSI-X
> [   56.140549] e1000e 0000:00:19.0: irq 29 for MSI/MSI-X
> [   56.141427] ADDRCONF(NETDEV_UP): eth0: link is not ready
> [   62.304539] NTFS-fs error (device sda1): ntfs_remount(): Volume has un=
supported flags set (0x4000) and is read-only.  Cannot remount read-write.
> [   64.448580] e1000e 0000:00:19.0: irq 29 for MSI/MSI-X
> [   64.504282] e1000e 0000:00:19.0: irq 29 for MSI/MSI-X
> [   64.505259] ADDRCONF(NETDEV_UP): eth0: link is not ready
> [   64.764972] ADDRCONF(NETDEV_UP): ath0: link is not ready
> [   65.034652] ath0: direct probe to AP 00:11:95:77:e0:b0 (try 1)
> [   65.036737] ath0: direct probe responded
> [   65.036746] ath0: authenticate with AP 00:11:95:77:e0:b0 (try 1)
> [   65.038335] ath0: authenticated
> [   65.038367] ath0: associate with AP 00:11:95:77:e0:b0 (try 1)
> [   65.039861] ath0: deauthenticating from 00:11:95:77:e0:b0 by local cho=
ice (reason=3D3)
> [   65.039924] ath0: direct probe to AP 00:11:95:77:e0:b0 (try 1)
> [   65.040335] ath0: RX AssocResp from 00:11:95:77:e0:b0 (capab=3D0x421 s=
tatus=3D0 aid=3D2)
> [   65.040342] ath0: associated
> [   65.041219] ------------[ cut here ]------------
> [   65.041255] WARNING: at /tmp/buildd/linux-2.6-2.6.32/debian/build/sour=
ce_i386_none/net/wireless/mlme.c:97 cfg80211_send_rx_assoc+0x14d/0x152 [cfg=
80211]()
> [   65.041263] Hardware name: 7658CTO
> [   65.041267] Modules linked in: i915 drm_kms_helper drm i2c_algo_bit pp=
dev lp parport sco bridge stp bnep rfcomm l2cap crc16 autofs4 binfmt_misc u=
input joydev hdaps input_polldev dm_snapshot dm_mirror dm_region_hash dm_lo=
g fuse nls_utf8 ntfs firewire_sbp2 loop snd_hda_codec_analog snd_hda_intel =
snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm arc4 ecb snd_seq_=
midi snd_rawmidi ath5k snd_seq_midi_event mac80211 pcmcia ath snd_seq btusb=
 snd_timer thinkpad_acpi yenta_socket bluetooth cfg80211 rfkill snd_seq_dev=
ice i2c_i801 rsrc_nonstatic i2c_core snd led_class pcmcia_core psmouse soun=
dcore serio_raw wmi nvram snd_page_alloc pcspkr processor ac battery evdev =
ext3 jbd mbcache dm_mod sd_mod crc_t10dif ata_generic uhci_hcd ide_pci_gene=
ric ahci piix libata video output firewire_ohci ehci_hcd firewire_core crc_=
itu_t ide_core intel_agp agpgart e1000e usbcore scsi_mod nls_base button th=
ermal fan thermal_sys [last unloaded: scsi_wait_scan]
> [   65.041486] Pid: 761, comm: phy0 Not tainted 2.6.32-trunk-686 #1
> [   65.041491] Call Trace:
> [   65.041506]  [<c1030a5d>] ? warn_slowpath_common+0x5e/0x8a
> [   65.041515]  [<c1030a93>] ? warn_slowpath_null+0xa/0xc
> [   65.041540]  [<f86cafc7>] ? cfg80211_send_rx_assoc+0x14d/0x152 [cfg802=
11]
> [   65.041563]  [<f8848107>] ? ieee80211_sta_work+0x89f/0x11ec [mac80211]
> [   65.041575]  [<c1025914>] ? update_curr+0x106/0x1b3
> [   65.041585]  [<c102bb26>] ? finish_task_switch+0x34/0x8e
> [   65.041596]  [<c1258230>] ? schedule+0x731/0x77e
> [   65.041613]  [<f889d5e8>] ? ath5k_hw_set_rx_filter+0x97/0xb8 [ath5k]
> [   65.041628]  [<f889cd83>] ? ath5k_hw_set_mcast_filter+0x22/0x40 [ath5k=
]
> [   65.041640]  [<c1041503>] ? worker_thread+0x141/0x1bd
> [   65.041661]  [<f8847868>] ? ieee80211_sta_work+0x0/0x11ec [mac80211]
> [   65.041671]  [<c104423e>] ? autoremove_wake_function+0x0/0x2d
> [   65.041679]  [<c10413c2>] ? worker_thread+0x0/0x1bd
> [   65.041687]  [<c104400c>] ? kthread+0x61/0x66
> [   65.041695]  [<c1043fab>] ? kthread+0x0/0x66
> [   65.041705]  [<c1003d47>] ? kernel_thread_helper+0x7/0x10
> [   65.041711] ---[ end trace 803644cf1ebb7c60 ]---
> [   65.042191] ADDRCONF(NETDEV_CHANGE): ath0: link becomes ready
> [   65.057483] ath0: deauthenticating from 00:11:95:77:e0:b0 by local cho=
ice (reason=3D3)
> [   75.816298] ath0: no IPv6 routers present
> [   91.680596] e1000e 0000:00:19.0: irq 29 for MSI/MSI-X
> [   91.737568] e1000e 0000:00:19.0: irq 29 for MSI/MSI-X
> [   91.738236] ADDRCONF(NETDEV_UP): eth0: link is not ready
> [   91.906035] ADDRCONF(NETDEV_UP): ath0: link is not ready
> [   91.909344] ath0: direct probe to AP 00:11:95:77:e0:b0 (try 1)
> [   91.911254] ath0: direct probe responded
> [   91.911262] ath0: authenticate with AP 00:11:95:77:e0:b0 (try 1)
> [   91.912923] ath0: authenticated
> [   91.912958] ath0: associate with AP 00:11:95:77:e0:b0 (try 1)
> [   91.915043] ath0: RX ReassocResp from 00:11:95:77:e0:b0 (capab=3D0x421=
 status=3D0 aid=3D2)
> [   91.915051] ath0: associated
> [   91.916338] ADDRCONF(NETDEV_CHANGE): ath0: link becomes ready
> [  102.021186] ath0: no IPv6 routers present
>=20
> ** Model information
> not available
>=20
> ** Loaded modules:
> Module                  Size  Used by
> i915                  216703  1=20
> drm_kms_helper         17175  1 i915
> drm                   107304  3 i915,drm_kms_helper
> i2c_algo_bit            3497  1 i915
> ppdev                   4058  0=20
> lp                      5570  0=20
> parport                22554  2 ppdev,lp
> sco                     5837  2=20
> bridge                 32847  0=20
> stp                      996  1 bridge
> bnep                    7376  2=20
> rfcomm                 25063  5=20
> l2cap                  21677  16 bnep,rfcomm
> crc16                   1027  1 l2cap
> autofs4                16567  3=20
> binfmt_misc             4875  1=20
> uinput                  4796  1=20
> joydev                  6767  0=20
> hdaps                   3780  0=20
> input_polldev           1479  1 hdaps
> dm_snapshot            17949  0=20
> dm_mirror               9639  0=20
> dm_region_hash          5612  1 dm_mirror
> dm_log                  6369  2 dm_mirror,dm_region_hash
> fuse                   43554  1=20
> nls_utf8                 908  1=20
> ntfs                  163169  1=20
> firewire_sbp2           9575  0=20
> loop                    9721  0=20
> snd_hda_codec_analog    45498  1=20
> snd_hda_intel          15063  0=20
> snd_hda_codec          44938  2 snd_hda_codec_analog,snd_hda_intel
> snd_hwdep               4054  1 snd_hda_codec
> snd_pcm_oss            28479  0=20
> snd_mixer_oss          10461  1 snd_pcm_oss
> snd_pcm                47362  3 snd_hda_intel,snd_hda_codec,snd_pcm_oss
> arc4                     974  2=20
> ecb                     1405  2=20
> snd_seq_midi            3480  0=20
> snd_rawmidi            12313  1 snd_seq_midi
> ath5k                 103286  0=20
> snd_seq_midi_event      3684  1 snd_seq_midi
> mac80211              121089  1 ath5k
> pcmcia                 17442  0=20
> ath                     5982  1 ath5k
> snd_seq                35303  3 snd_seq_midi,snd_seq_midi_event
> btusb                   7981  2=20
> snd_timer              12258  2 snd_pcm,snd_seq
> thinkpad_acpi          41929  0=20
> yenta_socket           16403  1=20
> bluetooth              36259  9 sco,bnep,rfcomm,l2cap,btusb
> cfg80211               86926  3 ath5k,mac80211,ath
> rfkill                 10196  4 thinkpad_acpi,bluetooth,cfg80211
> snd_seq_device          3673  3 snd_seq_midi,snd_rawmidi,snd_seq
> i2c_i801                6334  0=20
> rsrc_nonstatic          7057  1 yenta_socket
> i2c_core               12612  4 i915,drm,i2c_algo_bit,i2c_i801
> snd                    33551  12 snd_hda_codec_analog,snd_hda_intel,snd_h=
da_codec,snd_hwdep,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_rawmidi,snd_seq,sn=
d_timer,snd_seq_device
> led_class               1757  2 ath5k,thinkpad_acpi
> pcmcia_core            20406  3 pcmcia,yenta_socket,rsrc_nonstatic
> psmouse                32473  0=20
> soundcore               3450  1 snd
> serio_raw               2916  0=20
> wmi                     3575  0=20
> nvram                   3957  1 thinkpad_acpi
> snd_page_alloc          4973  2 snd_hda_intel,snd_pcm
> pcspkr                  1207  0=20
> processor              25803  2=20
> ac                      1640  0=20
> battery                 3782  0=20
> evdev                   5609  14=20
> ext3                   93757  7=20
> jbd                    31965  1 ext3
> mbcache                 3762  1 ext3
> dm_mod                 45778  25 dm_snapshot,dm_mirror,dm_log
> sd_mod                 25717  4=20
> crc_t10dif              1012  1 sd_mod
> ata_generic             2015  0=20
> uhci_hcd               15945  0=20
> ide_pci_generic         1924  0=20
> ahci                   26446  3=20
> piix                    3564  0=20
> libata                113728  2 ata_generic,ahci
> video                  14605  1 i915
> output                  1204  1 video
> firewire_ohci          16469  0=20
> ehci_hcd               27222  0=20
> firewire_core          30911  2 firewire_sbp2,firewire_ohci
> crc_itu_t               1035  1 firewire_core
> ide_core               63842  2 ide_pci_generic,piix
> intel_agp              20145  1=20
> agpgart                19516  3 drm,intel_agp
> e1000e                 97405  0=20
> usbcore                97778  4 btusb,uhci_hcd,ehci_hcd
> scsi_mod              101061  3 firewire_sbp2,sd_mod,libata
> nls_base                4541  3 nls_utf8,ntfs,usbcore
> button                  3586  1 i915
> thermal                 9206  0=20
> fan                     2586  0=20
> thermal_sys             9378  4 processor,video,thermal,fan
>=20
> ** Network interface configuration:
>=20
> auto lo
> iface lo inet loopback
>=20
>=20
>=20
>=20
>=20
> ** Network status:
> *** IP interfaces and addresses:
> 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 16436 qdisc noqueue state UNKNOWN=20
>     link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
>     inet 127.0.0.1/8 scope host lo
>     inet6 ::1/128 scope host=20
>        valid_lft forever preferred_lft forever
> 2: eth0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc pfifo_fast st=
ate DOWN qlen 1000
>     link/ether 00:15:58:84:a3:15 brd ff:ff:ff:ff:ff:ff
> 3: ath0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast stat=
e UP qlen 1000
>     link/ether 00:19:7e:a4:95:b6 brd ff:ff:ff:ff:ff:ff
>     inet 192.168.0.101/24 brd 192.168.0.255 scope global ath0
>     inet6 fe80::219:7eff:fea4:95b6/64 scope link=20
>        valid_lft forever preferred_lft forever
> 4: pan0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN=20
>     link/ether 1a:40:82:db:e4:99 brd ff:ff:ff:ff:ff:ff
>=20
> *** Device statistics:
> Inter-|   Receive                                                |  Trans=
mit
>  face |bytes    packets errs drop fifo frame compressed multicast|bytes  =
  packets errs drop fifo colls carrier compressed
>     lo:  792616     309    0    0    0     0          0         0   79261=
6     309    0    0    0     0       0          0
>   eth0:       0       0    0    0    0     0          0         0        =
0       0    0    0    0     0       0          0
>   ath0:  952558    1146    0    0    0     0          0         0    9528=
2     902    0    0    0     0       0          0
>   pan0:       0       0    0    0    0     0          0         0        =
0       0    0    0    0     0       0          0
>=20
> *** Protocol statistics:
> Ip:
>     1474 total packets received
>     0 forwarded
>     0 incoming packets discarded
>     1145 incoming packets delivered
>     1192 requests sent out
> Icmp:
>     2 ICMP messages received
>     0 input ICMP message failed.
>     ICMP input histogram:
>         echo replies: 2
>     2 ICMP messages sent
>     0 ICMP messages failed
>     ICMP output histogram:
>         echo request: 2
> IcmpMsg:
>         InType0: 2
>         OutType8: 2
> Tcp:
>     12 active connections openings
>     5 passive connection openings
>     0 failed connection attempts
>     0 connection resets received
>     0 connections established
>     1096 segments received
>     1145 segments send out
>     0 segments retransmited
>     0 bad segments received.
>     0 resets sent
> Udp:
>     41 packets received
>     0 packets to unknown port received.
>     2 packet receive errors
>     41 packets sent
>     RcvbufErrors: 2
> UdpLite:
> TcpExt:
>     9 TCP sockets finished time wait in fast timer
>     72 delayed acks sent
>     Quick ack mode was activated 2 times
>     2 packets directly queued to recvmsg prequeue.
>     2 bytes directly received in process context from prequeue
>     651 packet headers predicted
>     104 acknowledgments not containing data payload received
>     140 predicted acknowledgments
>     2 DSACKs sent for old packets
> IpExt:
>     InMcastPkts: 21
>     OutMcastPkts: 25
>     InBcastPkts: 6
>     InOctets: 1734368
>     OutOctets: 857361
>     InMcastOctets: 5302
>     OutMcastOctets: 5462
>     InBcastOctets: 1166
>=20
> *** Device features:
> ath0: 0x2000
> eth0: 0x1109a9
> lo: 0x13865
> pan0: 0xff3865
>=20
> ** PCI devices:
> 00:00.0 Host bridge [0600]: Intel Corporation Mobile PM965/GM965/GL960 Me=
mory Controller Hub [8086:2a00] (rev 0c)
> 	Subsystem: Lenovo T61 [17aa:20b3]
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR+ FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort+ >SERR- <PERR- INTx-
> 	Latency: 0
> 	Capabilities: <access denied>
> 	Kernel driver in use: agpgart-intel
>=20
> 00:02.0 VGA compatible controller [0300]: Intel Corporation Mobile GM965/=
GL960 Integrated Graphics Controller [8086:2a02] (rev 0c) (prog-if 00 [VGA =
controller])
> 	Subsystem: Lenovo T61 [17aa:20b5]
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx+
> 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin A routed to IRQ 31
> 	Region 0: Memory at f8100000 (64-bit, non-prefetchable) [size=3D1M]
> 	Region 2: Memory at e0000000 (64-bit, prefetchable) [size=3D256M]
> 	Region 4: I/O ports at 1800 [size=3D8]
> 	Expansion ROM at <unassigned> [disabled]
> 	Capabilities: <access denied>
>=20
> 00:02.1 Display controller [0380]: Intel Corporation Mobile GM965/GL960 I=
ntegrated Graphics Controller [8086:2a03] (rev 0c)
> 	Subsystem: Lenovo T61 [17aa:20b5]
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Region 0: Memory at f8200000 (64-bit, non-prefetchable) [size=3D1M]
> 	Capabilities: <access denied>
>=20
> 00:19.0 Ethernet controller [0200]: Intel Corporation 82566MM Gigabit Net=
work Connection [8086:1049] (rev 03)
> 	Subsystem: Lenovo ThinkPad T61 [17aa:20b9]
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR+ FastB2B- DisINTx+
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin A routed to IRQ 29
> 	Region 0: Memory at fe000000 (32-bit, non-prefetchable) [size=3D128K]
> 	Region 1: Memory at fe025000 (32-bit, non-prefetchable) [size=3D4K]
> 	Region 2: I/O ports at 1840 [size=3D32]
> 	Capabilities: <access denied>
> 	Kernel driver in use: e1000e
>=20
> 00:1a.0 USB Controller [0c03]: Intel Corporation 82801H (ICH8 Family) USB=
 UHCI Controller #4 [8086:2834] (rev 03) (prog-if 00 [UHCI])
> 	Subsystem: Lenovo ThinkPad T61 [17aa:20aa]
> 	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
> 	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin A routed to IRQ 20
> 	Region 4: I/O ports at 1860 [size=3D32]
> 	Kernel driver in use: uhci_hcd
>=20
> 00:1a.1 USB Controller [0c03]: Intel Corporation 82801H (ICH8 Family) USB=
 UHCI Controller #5 [8086:2835] (rev 03) (prog-if 00 [UHCI])
> 	Subsystem: Lenovo ThinkPad T60 [17aa:20aa]
> 	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
> 	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin B routed to IRQ 21
> 	Region 4: I/O ports at 1880 [size=3D32]
> 	Kernel driver in use: uhci_hcd
>=20
> 00:1a.7 USB Controller [0c03]: Intel Corporation 82801H (ICH8 Family) USB=
2 EHCI Controller #2 [8086:283a] (rev 03) (prog-if 20 [EHCI])
> 	Subsystem: Lenovo ThinkPad T61 [17aa:20ab]
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR+ FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin C routed to IRQ 22
> 	Region 0: Memory at fe226c00 (32-bit, non-prefetchable) [size=3D1K]
> 	Capabilities: <access denied>
> 	Kernel driver in use: ehci_hcd
>=20
> 00:1b.0 Audio device [0403]: Intel Corporation 82801H (ICH8 Family) HD Au=
dio Controller [8086:284b] (rev 03)
> 	Subsystem: Lenovo ThinkPad T61 [17aa:20ac]
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR+ FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0, Cache Line Size: 64 bytes
> 	Interrupt: pin B routed to IRQ 17
> 	Region 0: Memory at fe020000 (64-bit, non-prefetchable) [size=3D16K]
> 	Capabilities: <access denied>
> 	Kernel driver in use: HDA Intel
>=20
> 00:1c.0 PCI bridge [0604]: Intel Corporation 82801H (ICH8 Family) PCI Exp=
ress Port 1 [8086:283f] (rev 03) (prog-if 00 [Normal decode])
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR+ FastB2B- DisINTx+
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0, Cache Line Size: 64 bytes
> 	Bus: primary=3D00, secondary=3D02, subordinate=3D02, sec-latency=3D0
> 	I/O behind bridge: 00002000-00002fff
> 	Memory behind bridge: fc000000-fdffffff
> 	Prefetchable memory behind bridge: 00000000f8000000-00000000f80fffff
> 	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- <SERR- <PERR-
> 	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
> 		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> 	Capabilities: <access denied>
> 	Kernel driver in use: pcieport
>=20
> 00:1c.1 PCI bridge [0604]: Intel Corporation 82801H (ICH8 Family) PCI Exp=
ress Port 2 [8086:2841] (rev 03) (prog-if 00 [Normal decode])
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR+ FastB2B- DisINTx+
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0, Cache Line Size: 64 bytes
> 	Bus: primary=3D00, secondary=3D03, subordinate=3D03, sec-latency=3D0
> 	I/O behind bridge: 00003000-00003fff
> 	Memory behind bridge: dc000000-df3fffff
> 	Prefetchable memory behind bridge: 00000000dfe00000-00000000dfefffff
> 	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- <SERR- <PERR-
> 	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
> 		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> 	Capabilities: <access denied>
> 	Kernel driver in use: pcieport
>=20
> 00:1c.2 PCI bridge [0604]: Intel Corporation 82801H (ICH8 Family) PCI Exp=
ress Port 3 [8086:2843] (rev 03) (prog-if 00 [Normal decode])
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR+ FastB2B- DisINTx+
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0, Cache Line Size: 64 bytes
> 	Bus: primary=3D00, secondary=3D04, subordinate=3D04, sec-latency=3D0
> 	I/O behind bridge: 00004000-00004fff
> 	Memory behind bridge: d8000000-d9ffffff
> 	Prefetchable memory behind bridge: 00000000dfb00000-00000000dfbfffff
> 	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- <SERR- <PERR-
> 	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
> 		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> 	Capabilities: <access denied>
> 	Kernel driver in use: pcieport
>=20
> 00:1c.3 PCI bridge [0604]: Intel Corporation 82801H (ICH8 Family) PCI Exp=
ress Port 4 [8086:2845] (rev 03) (prog-if 00 [Normal decode])
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR+ FastB2B- DisINTx+
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0, Cache Line Size: 64 bytes
> 	Bus: primary=3D00, secondary=3D05, subordinate=3D0c, sec-latency=3D0
> 	I/O behind bridge: 00005000-00005fff
> 	Memory behind bridge: d4000000-d5ffffff
> 	Prefetchable memory behind bridge: 00000000df800000-00000000df8fffff
> 	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- <SERR- <PERR-
> 	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
> 		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> 	Capabilities: <access denied>
> 	Kernel driver in use: pcieport
>=20
> 00:1c.4 PCI bridge [0604]: Intel Corporation 82801H (ICH8 Family) PCI Exp=
ress Port 5 [8086:2847] (rev 03) (prog-if 00 [Normal decode])
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR+ FastB2B- DisINTx+
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0, Cache Line Size: 64 bytes
> 	Bus: primary=3D00, secondary=3D0d, subordinate=3D14, sec-latency=3D0
> 	I/O behind bridge: 00006000-00006fff
> 	Memory behind bridge: d0000000-d1ffffff
> 	Prefetchable memory behind bridge: 00000000df500000-00000000df5fffff
> 	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- <SERR- <PERR-
> 	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
> 		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> 	Capabilities: <access denied>
> 	Kernel driver in use: pcieport
>=20
> 00:1d.0 USB Controller [0c03]: Intel Corporation 82801H (ICH8 Family) USB=
 UHCI Controller #1 [8086:2830] (rev 03) (prog-if 00 [UHCI])
> 	Subsystem: Lenovo ThinkPad T61 [17aa:20aa]
> 	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
> 	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin A routed to IRQ 16
> 	Region 4: I/O ports at 18a0 [size=3D32]
> 	Kernel driver in use: uhci_hcd
>=20
> 00:1d.1 USB Controller [0c03]: Intel Corporation 82801H (ICH8 Family) USB=
 UHCI Controller #2 [8086:2831] (rev 03) (prog-if 00 [UHCI])
> 	Subsystem: Lenovo ThinkPad T61 [17aa:20aa]
> 	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
> 	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin B routed to IRQ 17
> 	Region 4: I/O ports at 18c0 [size=3D32]
> 	Kernel driver in use: uhci_hcd
>=20
> 00:1d.2 USB Controller [0c03]: Intel Corporation 82801H (ICH8 Family) USB=
 UHCI Controller #3 [8086:2832] (rev 03) (prog-if 00 [UHCI])
> 	Subsystem: Lenovo ThinkPad T61 [17aa:20aa]
> 	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
> 	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin C routed to IRQ 18
> 	Region 4: I/O ports at 18e0 [size=3D32]
> 	Kernel driver in use: uhci_hcd
>=20
> 00:1d.7 USB Controller [0c03]: Intel Corporation 82801H (ICH8 Family) USB=
2 EHCI Controller #1 [8086:2836] (rev 03) (prog-if 20 [EHCI])
> 	Subsystem: Lenovo ThinkPad T61 [17aa:20ab]
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR+ FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin D routed to IRQ 19
> 	Region 0: Memory at fe227000 (32-bit, non-prefetchable) [size=3D1K]
> 	Capabilities: <access denied>
> 	Kernel driver in use: ehci_hcd
>=20
> 00:1e.0 PCI bridge [0604]: Intel Corporation 82801 Mobile PCI Bridge [808=
6:2448] (rev f3) (prog-if 01 [Subtractive decode])
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Bus: primary=3D00, secondary=3D15, subordinate=3D18, sec-latency=3D32
> 	I/O behind bridge: 00007000-0000afff
> 	Memory behind bridge: f8300000-fbffffff
> 	Prefetchable memory behind bridge: 00000000f4000000-00000000f7ffffff
> 	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort+ <SERR- <PERR-
> 	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
> 		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> 	Capabilities: <access denied>
>=20
> 00:1f.0 ISA bridge [0601]: Intel Corporation 82801HBM (ICH8M-E) LPC Inter=
face Controller [8086:2811] (rev 03)
> 	Subsystem: Lenovo T61 [17aa:20b6]
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Capabilities: <access denied>
>=20
> 00:1f.1 IDE interface [0101]: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M=
-E) IDE Controller [8086:2850] (rev 03) (prog-if 8a [Master SecP PriP])
> 	Subsystem: Lenovo ThinkPad T61 [17aa:20a6]
> 	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
> 	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx+
> 	Latency: 0
> 	Interrupt: pin C routed to IRQ 16
> 	Region 0: I/O ports at 01f0 [size=3D8]
> 	Region 1: I/O ports at 03f4 [size=3D1]
> 	Region 2: I/O ports at 0170 [size=3D8]
> 	Region 3: I/O ports at 0374 [size=3D1]
> 	Region 4: I/O ports at 1c00 [size=3D16]
> 	Kernel driver in use: PIIX_IDE
>=20
> 00:1f.2 SATA controller [0106]: Intel Corporation 82801HBM/HEM (ICH8M/ICH=
8M-E) SATA AHCI Controller [8086:2829] (rev 03) (prog-if 01 [AHCI 1.0])
> 	Subsystem: Lenovo ThinkPad T61 [17aa:20a7]
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx+
> 	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin B routed to IRQ 30
> 	Region 0: I/O ports at 1c50 [size=3D8]
> 	Region 1: I/O ports at 1c44 [size=3D4]
> 	Region 2: I/O ports at 1c48 [size=3D8]
> 	Region 3: I/O ports at 1c40 [size=3D4]
> 	Region 4: I/O ports at 1c20 [size=3D32]
> 	Region 5: Memory at fe226000 (32-bit, non-prefetchable) [size=3D2K]
> 	Capabilities: <access denied>
> 	Kernel driver in use: ahci
>=20
> 00:1f.3 SMBus [0c05]: Intel Corporation 82801H (ICH8 Family) SMBus Contro=
ller [8086:283e] (rev 03)
> 	Subsystem: Lenovo ThinkPad T61 [17aa:20a9]
> 	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR+ FastB2B- DisINTx-
> 	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
> 	Interrupt: pin A routed to IRQ 23
> 	Region 0: Memory at fe227400 (32-bit, non-prefetchable) [size=3D256]
> 	Region 4: I/O ports at 1c60 [size=3D32]
> 	Kernel driver in use: i801_smbus
>=20
> 03:00.0 Ethernet controller [0200]: Atheros Communications Inc. AR5212 80=
2.11abg NIC [168c:1014] (rev 01)
> 	Subsystem: IBM ThinkPad 11a/b/g Wireless LAN Mini Express Adapter (AR5BX=
B6) [1014:058a]
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR+ FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0, Cache Line Size: 64 bytes
> 	Interrupt: pin A routed to IRQ 17
> 	Region 0: Memory at df3f0000 (64-bit, non-prefetchable) [size=3D64K]
> 	Capabilities: <access denied>
> 	Kernel driver in use: ath5k
>=20
> 15:00.0 CardBus bridge [0607]: Ricoh Co Ltd RL5c476 II [1180:0476] (rev b=
a)
> 	Subsystem: Lenovo Device [17aa:20c6]
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 168
> 	Interrupt: pin A routed to IRQ 16
> 	Region 0: Memory at f8300000 (32-bit, non-prefetchable) [size=3D4K]
> 	Bus: primary=3D15, secondary=3D16, subordinate=3D17, sec-latency=3D176
> 	Memory window 0: f4000000-f7fff000 (prefetchable)
> 	Memory window 1: 80000000-83fff000
> 	I/O window 0: 00007000-000070ff
> 	I/O window 1: 00007400-000074ff
> 	BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset- 16bInt+ PostWrite+
> 	16-bit legacy interface ports at 0001
> 	Kernel driver in use: yenta_cardbus
>=20
> 15:00.1 FireWire (IEEE 1394) [0c00]: Ricoh Co Ltd R5C832 IEEE 1394 Contro=
ller [1180:0832] (rev 04) (prog-if 10 [OHCI])
> 	Subsystem: Lenovo Device [17aa:20c7]
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 64 (500ns min, 1000ns max)
> 	Interrupt: pin B routed to IRQ 17
> 	Region 0: Memory at f8301000 (32-bit, non-prefetchable) [size=3D2K]
> 	Capabilities: <access denied>
> 	Kernel driver in use: firewire_ohci
>=20
>=20
> ** USB devices:
> Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 003 Device 002: ID 0a5c:2110 Broadcom Corp. Bluetooth Controller
> Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 006 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 007 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
>=20
>=20
> -- System Information:
> Debian Release: squeeze/sid
>   APT prefers unstable
>   APT policy: (990, 'unstable'), (500, 'stable'), (1, 'experimental')
> Architecture: i386 (i686)
>=20
> Kernel: Linux 2.6.32-trunk-686 (SMP w/2 CPU cores)
> Locale: LANG=3Den_US.UTF-8, LC_CTYPE=3Den_US.UTF-8 (charmap=3DUTF-8)
> Shell: /bin/sh linked to /bin/dash
>=20
> Versions of packages linux-image-2.6.32-trunk-686 depends on:
> ii  debconf [debconf-2.0]         1.5.28     Debian configuration managem=
ent sy
> ii  initramfs-tools [linux-initra 0.93.4     tools for generating an init=
ramfs
> ii  module-init-tools             3.11-1     tools for managing Linux ker=
nel mo
>=20
> Versions of packages linux-image-2.6.32-trunk-686 recommends:
> pn  firmware-linux-free           <none>     (no description available)
> ii  libc6-i686                    2.10.2-2   GNU C Library: Shared librar=
ies [i
>=20
> Versions of packages linux-image-2.6.32-trunk-686 suggests:
> ii  grub-legacy [grub]            0.97-59    GRand Unified Bootloader (Le=
gacy v
> pn  linux-doc-2.6.32              <none>     (no description available)
>=20
> Versions of packages linux-image-2.6.32-trunk-686 is related to:
> pn  firmware-bnx2                 <none>     (no description available)
> pn  firmware-bnx2x                <none>     (no description available)
> pn  firmware-ipw2x00              <none>     (no description available)
> pn  firmware-ivtv                 <none>     (no description available)
> pn  firmware-iwlwifi              <none>     (no description available)
> pn  firmware-linux                <none>     (no description available)
> pn  firmware-linux-nonfree        <none>     (no description available)
> pn  firmware-qlogic               <none>     (no description available)
> pn  firmware-ralink               <none>     (no description available)
>=20
> -- debconf information:
>   linux-image-2.6.32-trunk-686/postinst/bootloader-test-error-2.6.32-trun=
k-686:
>   linux-image-2.6.32-trunk-686/postinst/missing-firmware-2.6.32-trunk-686=
:
>   linux-image-2.6.32-trunk-686/prerm/would-invalidate-boot-loader-2.6.32-=
trunk-686: true
>   shared/kernel-image/really-run-bootloader: true
>   linux-image-2.6.32-trunk-686/postinst/depmod-error-initrd-2.6.32-trunk-=
686: false
>   linux-image-2.6.32-trunk-686/prerm/removing-running-kernel-2.6.32-trunk=
-686: true
>   linux-image-2.6.32-trunk-686/postinst/bootloader-error-2.6.32-trunk-686=
:
>=20
>=20
>=20

--=20
Ben Hutchings
Experience is what causes a person to make new mistakes instead of old ones=
.

--=-REBiTLVjQ2AEeCw/WIVU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUASzAJy+e/yOyVhhEJAQL0QRAAj5pmnsu+fOs7FE4/kjKEeTsYkTinDOKh
HfjmQslVNxzhA+YQvxyzzMC9g5NBS2txv3b+ZhY6z3B7vfUCdyNON64SnkF25dUe
+smzeP0UWNAAKP2ys8rNeaZ8QZyTpFyxIqcb+w71Asnh4wWW32IrYlHRtVH3Xd5G
QsXMV7vYQywA8j9xmUN7C3hLR5GjQUa3sMXDQozlBPmjfJdGQ5uz8bePf/f3DQBx
FvGdZcu1vskEgbwCyDhgeyle1Ao34NRVKsJHQEVoRMirJQrttXKJViHTbcxwXDAK
USET3BFAKBeVEtp0PMz3qTb4nORN29375Dkwe4PxjAGSh0Q481Ba3m02SwQst4p1
lL6NHNBcDYC+01GfUPoJk6wfv+9TxbNirmBRGMuvD61qJsB/PeDxwG3hUNsusZUB
7a+fEDfAZMAz/6jhkvHPR75yKJZ/6wi1lYgW5v/pgRjeZUZuEUwvwK66s7deK6WH
z8wlx4QgXC3dtY1ayKh+DQGT5a2tHAOLLcAGhiqbT9ZEu35oXG2FTsGhtElMa3tw
ZPTosDorbncwm3nbdtTgR7MWAYyW+F6dU7f/h+IyUY4D9SCy2eQgwU1xWxwHmbyZ
bAEc60AoubOvq2MRktdA0BupXJE8PRjhFevdWiJpUVRu7mvSZ/0KKLUyG0kxPYCo
/goqnOc2wsE=
=qMxn
-----END PGP SIGNATURE-----

--=-REBiTLVjQ2AEeCw/WIVU--
