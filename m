Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gmmr1.centrum.cz ([46.255.225.252]:39269 "EHLO gmmr1.centrum.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764AbbHRUpD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2015 16:45:03 -0400
Received: from mail1004.cent (mail-g1.snat.cent [10.32.3.100])
	by gmmr1.centrum.cz (Postfix) with ESMTP id 1C39E80090AC
	for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2015 22:37:42 +0200 (CEST)
To: <linux-wireless@vger.kernel.org>
Subject: =?utf-8?q?brcmsmac_AP_not_working_with_=5B14e4=3A4353=5D?=
Date: Tue, 18 Aug 2015 22:37:41 +0200
From: =?utf-8?q?Milan_Svoboda?= <milan.svoboda@centrum.cz>
MIME-Version: 1.0
Message-Id: <20150818223741.F3636A1B@centrum.cz> (sfid-20150818_224521_818094_E756B596)
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello group!

Wifi AP's SSID not visible by clients, no hidden network either. When using b43 it works (slowly but that is different issue).

Any idea how to fix it?

Thanks!

Linux fenix 4.1.6-1-ARCH #1 SMP PREEMPT Mon Aug 17 08:52:28 CEST 2015 x86_64 GNU/Linux

03:00.0 Network controller [0280]: Broadcom Corporation BCM43224 802.11a/b/g/n [14e4:4353] (rev 01)

Module                  Size  Used by
xt_tcpudp              16384  0
ctr                    16384  2
ccm                    20480  2
ipt_MASQUERADE         16384  1
nf_nat_masquerade_ipv4    16384  1 ipt_MASQUERADE
iptable_nat            16384  1
nf_nat_ipv4            16384  1 iptable_nat
nf_nat                 24576  2 nf_nat_ipv4,nf_nat_masquerade_ipv4
nf_log_ipv4            16384  1
nf_log_common          16384  1 nf_log_ipv4
xt_LOG                 16384  1
xt_limit               16384  1
ipt_REJECT             16384  1
nf_reject_ipv4         16384  1 ipt_REJECT
nf_conntrack_ipv4      20480  3
nf_defrag_ipv4         16384  1 nf_conntrack_ipv4
xt_conntrack           16384  2
nf_conntrack           90112  5 nf_nat,nf_nat_ipv4,xt_conntrack,nf_nat_masquerade_ipv4,nf_conntrack_ipv4
iptable_filter         16384  1
arc4                   16384  2
nls_iso8859_1          16384  0
intel_rapl             20480  0
iosf_mbi               16384  1 intel_rapl
brcmsmac              536576  0
nls_cp437              20480  0
vfat                   24576  0
fat                    65536  1 vfat
cordic                 16384  1 brcmsmac
x86_pkg_temp_thermal    16384  0
intel_powerclamp       16384  0
brcmutil               16384  1 brcmsmac
coretemp               16384  0
snd_hda_codec_hdmi     53248  1
kvm_intel             155648  0
snd_hda_codec_realtek    77824  1
led_class              16384  1 brcmsmac
snd_hda_codec_generic    69632  1 snd_hda_codec_realtek
mac80211              667648  1 brcmsmac
cfg80211              483328  2 brcmsmac,mac80211
snd_hda_intel          28672  0
snd_hda_controller     28672  1 snd_hda_intel
snd_hda_codec          98304  5 snd_hda_codec_realtek,snd_hda_codec_hdmi,snd_hda_codec_generic,snd_hda_intel,snd_hda_controller
i915                 1044480  1
kvm                   442368  1 kvm_intel
snd_hda_core           28672  5 snd_hda_codec_realtek,snd_hda_codec_hdmi,snd_hda_codec_generic,snd_hda_codec,snd_hda_controller
snd_hwdep              16384  1 snd_hda_codec
snd_pcm                90112  4 snd_hda_codec_hdmi,snd_hda_codec,snd_hda_intel,snd_hda_controller
rfkill                 24576  2 cfg80211
crct10dif_pclmul       16384  0
bcma                   49152  1 brcmsmac
snd_timer              28672  1 snd_pcm
snd                    69632  8 snd_hda_codec_realtek,snd_hwdep,snd_timer,snd_hda_codec_hdmi,snd_pcm,snd_hda_codec_generic,snd_hda_codec,snd_hda_intel
e1000e                221184  0
crc32_pclmul           16384  0
crc32c_intel           24576  0
drm_kms_helper        106496  1 i915
evdev                  24576  3
mac_hid                16384  0
ghash_clmulni_intel    16384  0
pcspkr                 16384  0
ptp                    20480  1 e1000e
iTCO_wdt               16384  0
iTCO_vendor_support    16384  1 iTCO_wdt
cryptd                 20480  1 ghash_clmulni_intel
drm                   286720  3 i915,drm_kms_helper
pps_core               20480  1 ptp
soundcore              16384  1 snd
intel_gtt              20480  1 i915
thermal                20480  0
battery                20480  0
i2c_algo_bit           16384  1 i915
video                  24576  1 i915
i2c_i801               20480  0
mei_me                 24576  0
i2c_core               49152  5 drm,i915,i2c_i801,drm_kms_helper,i2c_algo_bit
button                 16384  1 i915
mei                    77824  1 mei_me
shpchp                 36864  0
lpc_ich                24576  0
processor              28672  0
fan                    16384  0
sch_fq_codel           20480  7
ip_tables              28672  2 iptable_filter,iptable_nat
x_tables               28672  8 ip_tables,xt_tcpudp,ipt_MASQUERADE,xt_limit,xt_conntrack,xt_LOG,iptable_filter,ipt_REJECT
ext4                  516096  1
crc16                  16384  1 ext4
mbcache                20480  1 ext4
jbd2                   90112  1 ext4
sd_mod                 36864  2
ahci                   36864  1
libahci                28672  1 ahci
libata                204800  2 ahci,libahci
scsi_mod              151552  2 libata,sd_mod
ehci_pci               16384  0
xhci_pci               16384  0
ehci_hcd               73728  1 ehci_pci
xhci_hcd              155648  1 xhci_pci
usbcore               200704  4 ehci_hcd,ehci_pci,xhci_hcd,xhci_pci
usb_common             16384  1 usbcore


hostapd v2.4
User space daemon for IEEE 802.11 AP management,
IEEE 802.1X/WPA/WPA2/EAP/RADIUS Authenticator
Copyright (c) 2002-2015, Jouni Malinen <j@w1.fi> and contributors

$ cat /etc/hostapd/hostapd.conf 

interface=wlp3s0b1
driver=nl80211
hw_mode=g
ieee80211n=1   # N doesn't work with b43
wmm_enabled=1   # QoS
channel=7
country_code=CZ
ieee80211d=1    # limit the frequencies to those enabled by country_code
ssid=test11
auth_algs=1
wpa=2
wpa_passphrase=...
wpa_key_mgmt=WPA-PSK
rsn_pairwise=CCMP
macaddr_acl=0
ht_capab=[HT40][GF][SHORT-GI-40][SHORT-GI-20]
require_ht=1
ignore_broadcast_ssid=0

milan@fenix ~> iw wlp3s0b1 info

Interface wlp3s0b1
ifindex 4
wdev 0x1
addr 00:8e:f2:a3:56:18
ssid test11
type AP
wiphy 0
channel 7 (2442 MHz), width: 20 MHz, center1: 2442 MHz

$iw phy0 info

Wiphy phy0
	max # scan SSIDs: 4
	max scan IEs length: 2257 bytes
	max # sched scan SSIDs: 0
	max # match sets: 0
	Retry short limit: 7
	Retry long limit: 4
	Coverage class: 0 (up to 0m)
	Device supports RSN-IBSS.
	Supported Ciphers:
		* WEP40 (00-0f-ac:1)
		* WEP104 (00-0f-ac:5)
		* TKIP (00-0f-ac:2)
		* CCMP (00-0f-ac:4)
		* 00-0f-ac:10
		* GCMP (00-0f-ac:8)
		* 00-0f-ac:9
	Available Antennas: TX 0 RX 0
	Supported interface modes:
		 * IBSS
		 * managed
		 * AP
		 * AP/VLAN
		 * monitor
	Band 1:
		Capabilities: 0x70
			HT20
			Static SM Power Save
			RX Greenfield
			RX HT20 SGI
			RX HT40 SGI
			No RX STBC
			Max AMSDU length: 3839 bytes
			No DSSS/CCK HT40
		Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
		Minimum RX AMPDU time spacing: 8 usec (0x06)
		HT Max RX data rate: 500 Mbps
		HT TX/RX MCS rate indexes supported: 0-15
		Bitrates (non-HT):
			* 1.0 Mbps
			* 2.0 Mbps (short preamble supported)
			* 5.5 Mbps (short preamble supported)
			* 11.0 Mbps (short preamble supported)
			* 6.0 Mbps
			* 9.0 Mbps
			* 12.0 Mbps
			* 18.0 Mbps
			* 24.0 Mbps
			* 36.0 Mbps
			* 48.0 Mbps
			* 54.0 Mbps
		Frequencies:
			* 2412 MHz [1] (19.0 dBm)
			* 2417 MHz [2] (19.0 dBm)
			* 2422 MHz [3] (19.0 dBm)
			* 2427 MHz [4] (19.0 dBm)
			* 2432 MHz [5] (19.0 dBm)
			* 2437 MHz [6] (19.0 dBm)
			* 2442 MHz [7] (19.0 dBm)
			* 2447 MHz [8] (19.0 dBm)
			* 2452 MHz [9] (19.0 dBm)
			* 2457 MHz [10] (19.0 dBm)
			* 2462 MHz [11] (19.0 dBm)
			* 2467 MHz [12] (19.0 dBm) (no IR)
			* 2472 MHz [13] (19.0 dBm) (no IR)
			* 2484 MHz [14] (disabled)
	Band 2:
		Capabilities: 0x70
			HT20
			Static SM Power Save
			RX Greenfield
			RX HT20 SGI
			RX HT40 SGI
			No RX STBC
			Max AMSDU length: 3839 bytes
			No DSSS/CCK HT40
		Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
		Minimum RX AMPDU time spacing: 8 usec (0x06)
		HT Max RX data rate: 500 Mbps
		HT TX/RX MCS rate indexes supported: 0-15
		Bitrates (non-HT):
			* 6.0 Mbps
			* 9.0 Mbps
			* 12.0 Mbps
			* 18.0 Mbps
			* 24.0 Mbps
			* 36.0 Mbps
			* 48.0 Mbps
			* 54.0 Mbps
		Frequencies:
			* 5180 MHz [36] (21.0 dBm) (no IR)
			* 5200 MHz [40] (21.0 dBm) (no IR)
			* 5220 MHz [44] (21.0 dBm) (no IR)
			* 5240 MHz [48] (21.0 dBm) (no IR)
			* 5260 MHz [52] (20.0 dBm) (no IR, radar detection)
			  DFS state: usable (for 1773 sec)
			  DFS CAC time: 60000 ms
			* 5280 MHz [56] (20.0 dBm) (no IR, radar detection)
			  DFS state: usable (for 1773 sec)
			  DFS CAC time: 60000 ms
			* 5300 MHz [60] (20.0 dBm) (no IR, radar detection)
			  DFS state: usable (for 1773 sec)
			  DFS CAC time: 60000 ms
			* 5320 MHz [64] (20.0 dBm) (no IR, radar detection)
			  DFS state: usable (for 1773 sec)
			  DFS CAC time: 60000 ms
			* 5500 MHz [100] (21.0 dBm) (no IR, radar detection)
			  DFS state: usable (for 1773 sec)
			  DFS CAC time: 60000 ms
			* 5520 MHz [104] (21.0 dBm) (no IR, radar detection)
			  DFS state: usable (for 1773 sec)
			  DFS CAC time: 60000 ms
			* 5540 MHz [108] (21.0 dBm) (no IR, radar detection)
			  DFS state: usable (for 1773 sec)
			  DFS CAC time: 60000 ms
			* 5560 MHz [112] (21.0 dBm) (no IR, radar detection)
			  DFS state: usable (for 1773 sec)
			  DFS CAC time: 60000 ms
			* 5580 MHz [116] (21.0 dBm) (no IR, radar detection)
			  DFS state: usable (for 1773 sec)
			  DFS CAC time: 60000 ms
			* 5600 MHz [120] (21.0 dBm) (no IR, radar detection)
			  DFS state: usable (for 1773 sec)
			  DFS CAC time: 60000 ms
			* 5620 MHz [124] (21.0 dBm) (no IR, radar detection)
			  DFS state: usable (for 1773 sec)
			  DFS CAC time: 60000 ms
			* 5640 MHz [128] (21.0 dBm) (no IR, radar detection)
			  DFS state: usable (for 1773 sec)
			  DFS CAC time: 60000 ms
			* 5660 MHz [132] (21.0 dBm) (no IR, radar detection)
			  DFS state: usable (for 1773 sec)
			  DFS CAC time: 60000 ms
			* 5680 MHz [136] (21.0 dBm) (no IR, radar detection)
			  DFS state: usable (for 1773 sec)
			  DFS CAC time: 60000 ms
			* 5700 MHz [140] (21.0 dBm) (no IR, radar detection)
			  DFS state: usable (for 1773 sec)
			  DFS CAC time: 60000 ms
			* 5745 MHz [149] (disabled)
			* 5765 MHz [153] (disabled)
			* 5785 MHz [157] (disabled)
			* 5805 MHz [161] (disabled)
			* 5825 MHz [165] (disabled)
	Supported commands:
		 * new_interface
		 * set_interface
		 * new_key
		 * start_ap
		 * new_station
		 * new_mpath
		 * set_mesh_config
		 * set_bss
		 * authenticate
		 * associate
		 * deauthenticate
		 * disassociate
		 * join_ibss
		 * join_mesh
		 * set_tx_bitrate_mask
		 * frame
		 * frame_wait_cancel
		 * set_wiphy_netns
		 * set_channel
		 * set_wds_peer
		 * probe_client
		 * set_noack_map
		 * register_beacons
		 * start_p2p_device
		 * set_mcast_rate
		 * set_qos_map
		 * connect
		 * disconnect
	Supported TX frame types:
		 * IBSS: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
		 * managed: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
		 * AP: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
		 * AP/VLAN: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
		 * mesh point: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
		 * P2P-client: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
		 * P2P-GO: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
		 * P2P-device: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
	Supported RX frame types:
		 * IBSS: 0x40 0xb0 0xc0 0xd0
		 * managed: 0x40 0xd0
		 * AP: 0x00 0x20 0x40 0xa0 0xb0 0xc0 0xd0
		 * AP/VLAN: 0x00 0x20 0x40 0xa0 0xb0 0xc0 0xd0
		 * mesh point: 0xb0 0xc0 0xd0
		 * P2P-client: 0x40 0xd0
		 * P2P-GO: 0x00 0x20 0x40 0xa0 0xb0 0xc0 0xd0
		 * P2P-device: 0x40 0xd0
	software interface modes (can always be added):
		 * AP/VLAN
		 * monitor
	interface combinations are not supported
	HT Capability overrides:
		 * MCS: ff ff ff ff ff ff ff ff ff ff
		 * maximum A-MSDU length
		 * supported channel width
		 * short GI for 40 MHz
		 * max A-MPDU length exponent
		 * min MPDU start spacing
	Device supports TX status socket option.
	Device supports HT-IBSS.
	Device supports SAE with AUTHENTICATE command
	Device supports low priority scan.
	Device supports scan flush.
	Device supports AP scan.
	Device supports per-vif TX power setting
	Driver supports a userspace MPM
	Device supports configuring vdev MAC-addr on create.

Aug 18 23:44:56 fenix network[1270]: Started network profile 'hostap'
Aug 18 23:44:56 fenix systemd[1]: Started Internal HostAP, static wifi connection.
Aug 18 23:44:56 fenix systemd[1]: Started Hostapd IEEE 802.11 AP, IEEE 802.1X/WPA/WPA2/EAP/RADIUS Authenticator.
Aug 18 23:44:56 fenix sudo[1249]: pam_unix(sudo:session): session closed for user root
Aug 18 23:44:56 fenix polkitd[962]: Unregistered Authentication Agent for unix-process:1250:147272 (system bus name :1.11, object path /org/freedesktop/PolicyKit1/AuthenticationAgent, locale C) (disc
Aug 18 23:44:56 fenix hostapd[1281]: Configuration file: /etc/hostapd/hostapd.conf
Aug 18 23:44:57 fenix hostapd[1281]: wlp3s0b1: interface state UNINITIALIZED->COUNTRY_UPDATE
Aug 18 23:44:57 fenix hostapd[1281]: Using interface wlp3s0b1 with hwaddr 00:8e:f2:a3:56:18 and ssid "test11"
Aug 18 23:44:57 fenix kernel: brcmsmac bcma0:1: brcms_ops_bss_info_changed: qos enabled: true (implement)
Aug 18 23:44:57 fenix kernel: brcmsmac bcma0:1: brcms_ops_config: change power-save mode: false (implement)
Aug 18 23:44:57 fenix kernel: IPv6: ADDRCONF(NETDEV_UP): wlp3s0b1: link is not ready
Aug 18 23:44:57 fenix kernel: brcmsmac bcma0:1: brcms_ops_bss_info_changed: Beacon enabled: true
Aug 18 23:44:57 fenix kernel: IPv6: ADDRCONF(NETDEV_CHANGE): wlp3s0b1: link becomes ready
Aug 18 23:44:57 fenix hostapd[1281]: wlp3s0b1: interface state COUNTRY_UPDATE->ENABLED
Aug 18 23:44:57 fenix hostapd[1281]: wlp3s0b1: AP-ENABLED
Aug 18 23:44:57 fenix kernel: brcmsmac bcma0:1: brcms_ops_bss_info_changed: qos enabled: true (implement)
Aug 18 23:44:57 fenix kernel: brcmsmac bcma0:1: brcms_ops_bss_info_changed: qos enabled: true (implement)
Aug 18 23:44:57 fenix kernel: brcmsmac bcma0:1: brcms_ops_bss_info_changed: qos enabled: true (implement)
Aug 18 23:44:57 fenix kernel: brcmsmac bcma0:1: brcms_ops_bss_info_changed: qos enabled: true (implement)
