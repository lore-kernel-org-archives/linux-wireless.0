Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:42432 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754296Ab3LGM0m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Dec 2013 07:26:42 -0500
Received: by mail-lb0-f179.google.com with SMTP id l4so677225lbv.24
        for <linux-wireless@vger.kernel.org>; Sat, 07 Dec 2013 04:26:41 -0800 (PST)
Received: from [94.255.216.2] (c-94-255-216-2.cust.bredband2.com. [94.255.216.2])
        by mx.google.com with ESMTPSA id tc8sm1883406lbb.9.2013.12.07.04.26.40
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sat, 07 Dec 2013 04:26:40 -0800 (PST)
Message-ID: <52A313FF.2000301@gmail.com> (sfid-20131207_132656_597844_C809A39B)
Date: Sat, 07 Dec 2013 13:26:39 +0100
From: =?ISO-8859-1?Q?Torquil_Macdonald_S=F8rensen?= <torquil@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: iwlwifi error when activating network-manager hotspot function
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

When activating the Hotspot function of Network Manager, I get this
message in the dmesg output:

[  103.801354] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[  103.808386] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[  103.908937] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  103.973502] ------------[ cut here ]------------
[  103.973530] WARNING: CPU: 0 PID: 4144 at
/build/linux-DpqWmm/linux-3.11.10/drivers/net/wireless/iwlwifi/dvm/tx.c:456
iwlagn_tx_skb+0xb6c/0xb80 [iwldvm]()
[  103.973532] Modules linked in: bnep rfcomm cpufreq_userspace
cpufreq_powersave cpufreq_stats cpufreq_conservative act_police
cls_basic cls_flow cls_fw cls_u32 sch_fq_codel sch_tbf sch_prio sch_htb
sch_hfsc sch_ingress sch_sfq xt_CHECKSUM ipt_rpfilter xt_statistic xt_CT
xt_LOG xt_connlimit xt_realm xt_addrtype xt_comment xt_recent xt_nat
ipt_ULOG ipt_REJECT ipt_MASQUERADE ipt_ECN ipt_CLUSTERIP ipt_ah xt_set
ip_set nf_nat_tftp nf_nat_snmp_basic nf_conntrack_snmp nf_nat_sip
nf_nat_pptp nf_nat_proto_gre nf_nat_irc nf_nat_h323 nf_nat_ftp
nf_nat_amanda ts_kmp nf_conntrack_amanda nf_conntrack_sane
nf_conntrack_tftp nf_conntrack_sip nf_conntrack_proto_udplite
nf_conntrack_proto_sctp nf_conntrack_pptp nf_conntrack_proto_gre
nf_conntrack_netlink nf_conntrack_netbios_ns nf_conntrack_broadcast
nf_conntrack_irc nf_conntrack_h323 nf_conntrack_ftp xt_TPROXY
nf_defrag_ipv6 nf_tproxy_core xt_time xt_TCPMSS xt_tcpmss xt_sctp
xt_policy xt_pkttype xt_physdev xt_owner xt_NFQUEUE xt_NFLOG
nfnetlink_log xt_multiport xt_mark xt_mac xt_limit xt_length xt_iprange
xt_helper xt_hashlimit xt_DSCP xt_dscp xt_dccp xt_conntrack xt_connmark
xt_CLASSIFY xt_AUDIT xt_tcpudp xt_state iptable_raw iptable_nat
nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack
iptable_mangle nfnetlink iptable_filter ip_tables x_tables fuse loop
snd_hda_codec_realtek iTCO_wdt iTCO_vendor_support uvcvideo
videobuf2_vmalloc videobuf2_memops videobuf2_core videodev media
x86_pkg_temp_thermal coretemp kvm crc32c_intel ghash_clmulni_intel
cdc_mbim btusb bluetooth arc4 cdc_ncm usbnet mii iwldvm cdc_wdm mac80211
cdc_acm aesni_intel aes_x86_64 snd_hda_intel ablk_helper snd_hda_codec
cryptd lrw gf128mul snd_hwdep glue_helper thinkpad_acpi snd_pcm
snd_page_alloc iwlwifi nvram microcode snd_seq snd_seq_device snd_timer
psmouse cfg80211 pcspkr evdev serio_raw i2c_i801 snd lpc_ich mei_me
mfd_core soundcore mei rfkill i915 wmi ac tpm_tis tpm battery
drm_kms_helper tpm_bios drm mperf i2c_algo_bit i2c_core video processor
button ext4 crc16 mbcache jbd2 sg sd_mod crc_t10dif sr_mod cdrom
hid_generic usbhid hid ahci libahci firewire_ohci libata sdhci_pci sdhci
scsi_mod mmc_core firewire_core thermal crc_itu_t thermal_sys e1000e ptp
pps_core xhci_hcd ehci_pci ehci_hcd usbcore usb_common
[  103.973632] CPU: 0 PID: 4144 Comm: wpa_supplicant Not tainted
3.11-2-amd64 #1 Debian 3.11.10-1
[  103.973634] Hardware name: LENOVO 24297XG/24297XG, BIOS G4ET94WW
(2.54 ) 05/23/2013
[  103.973635]  0000000000000009 ffffffff814740f8 0000000000000000
ffffffff810583d2
[  103.973638]  ffff8802146dbe00 ffff8801fea520c0 0000000000000000
0000000000000008
[  103.973641]  0000000000000000 ffffffffa06a78cc ffff8802147a99e8
ffff00c0fea520c0
[  103.973644] Call Trace:
[  103.973650]  [<ffffffff814740f8>] ? dump_stack+0x41/0x51
[  103.973654]  [<ffffffff810583d2>] ? warn_slowpath_common+0x72/0x90
[  103.973664]  [<ffffffffa06a78cc>] ? iwlagn_tx_skb+0xb6c/0xb80 [iwldvm]
[  103.973672]  [<ffffffffa06a53e8>] ? iwlagn_mac_tx+0x18/0x30 [iwldvm]
[  103.973685]  [<ffffffffa063202e>] ? __ieee80211_tx+0x11e/0x330 [mac80211]
[  103.973697]  [<ffffffffa063419b>] ? ieee80211_tx+0xab/0xe0 [mac80211]
[  103.973707]  [<ffffffffa063467a>] ?
ieee80211_monitor_start_xmit+0x27a/0x310 [mac80211]
[  103.973711]  [<ffffffff813944ba>] ? dev_hard_start_xmit+0x2da/0x500
[  103.973717]  [<ffffffff813b0281>] ? sch_direct_xmit+0xc1/0x190
[  103.973720]  [<ffffffff813948d3>] ? dev_queue_xmit+0x1f3/0x470
[  103.973723]  [<ffffffff8145ea9c>] ? packet_sendmsg+0xcbc/0xee0
[  103.973726]  [<ffffffff813b9d16>] ? netlink_recvmsg+0x1f6/0x380
[  103.973730]  [<ffffffff8137ccd4>] ? sock_sendmsg+0x94/0xd0
[  103.973733]  [<ffffffff8137d333>] ? sock_recvmsg+0xa3/0xe0
[  103.973736]  [<ffffffff8137d0f9>] ? ___sys_sendmsg+0x3a9/0x3c0
[  103.973740]  [<ffffffff8118e6ed>] ? __inode_wait_for_writeback+0x6d/0xc0
[  103.973744]  [<ffffffff81078b90>] ? wake_atomic_t_function+0x30/0x30
[  103.973748]  [<ffffffff811a67a5>] ?
fsnotify_clear_marks_by_inode+0x25/0x110
[  103.973752]  [<ffffffff8117ecf2>] ? dput.part.15+0x1b2/0x2b0
[  103.973755]  [<ffffffff8116b5fd>] ? __fput+0x14d/0x220
[  103.973759]  [<ffffffff8137db49>] ? __sys_sendmsg+0x39/0x70
[  103.973763]  [<ffffffff81481469>] ? system_call_fastpath+0x16/0x1b
[  103.973765] ---[ end trace 668a89610fd96a1c ]---
[  103.984693] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready

However, the hotspot function does seem to work, because I can connect
my Android telephone to the resulting network. The internet is connected
through eth0 on the laptop. I do seem to have some network problems
(stopping of downloads) from my Android phone for large downloads, so
perhaps that is related to this dmesg output. But I have not used the
Android + Hotspot + Laptop enough to say for sure yet. But I guess the
above error message should be fixed anyway.

I'm on a Lenovo T530 laptop running an updated Debian Sid, but using
networkmanager (0.9.8.8-1) from the experimental distribution, and the
most recent Debian subversion repository version of wpasupplicant
(v.1.1-1). I had to update network-manager and wpasupplicant due to some
other problems. The kernel comes from the Debian
packagelinux-image-3.11-2-amd64:

$ uname -a
Linux lenovo 3.11-2-amd64 #1 SMP Debian 3.11.10-1 (2013-12-04) x86_64
GNU/Linux

and this is the lspci output for the wireless card:

$ lspci -s 03:00.0 -vv
03:00.0 Network controller: Intel Corporation Centrino Advanced-N 6205
[Taylor Peak] (rev 34)
    Subsystem: Intel Corporation Centrino Advanced-N 6205 AGN
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 43
    Region 0: Memory at f1c00000 (64-bit, non-prefetchable) [size=8K]
    Capabilities: <access denied>
    Kernel driver in use: iwlwifi

Some iwlwifi-related dmesg-output from earlier in the startup sequence:

[    2.279353] iwlwifi 0000:03:00.0: can't disable ASPM; OS doesn't have
ASPM control
[    2.279554] iwlwifi 0000:03:00.0: irq 43 for MSI/MSI-X
[    2.283063] iwlwifi 0000:03:00.0: firmware: agent loaded
iwlwifi-6000g2a-6.ucode into memory
[    2.283272] iwlwifi 0000:03:00.0: loaded firmware version 18.168.6.1
op_mode iwldvm
[    2.296356] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUG disabled
[    2.296359] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUGFS disabled
[    2.296361] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TRACING disabled
[    2.296363] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_P2P enabled
[    2.296365] iwlwifi 0000:03:00.0: Detected Intel(R) Centrino(R)
Advanced-N 6205 AGN, REV=0xB0
[    2.296533] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[    4.996326] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[    5.003364] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[    5.270981] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[    5.278030] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0

Please ask for any more info that is relevant.

Best regards
Torquil Sørensen
