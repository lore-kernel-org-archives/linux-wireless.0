Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:25151 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791AbZIIQDm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Sep 2009 12:03:42 -0400
Received: by fg-out-1718.google.com with SMTP id 22so2283669fge.1
        for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2009 09:03:44 -0700 (PDT)
Subject: wireless/sme.c:617 __cfg80211_disconnected I still get these daily
From: ASIC Felix <ic.felix@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Date: Wed, 09 Sep 2009 09:03:10 -0700
Message-Id: <1252512190.25355.15.camel@darkslate>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I still get these daily.

Thinkpad T43,
phy0: Atheros AR9280 MAC/BB Rev:2 AR5133 RF Rev:d0: mem=0xfa360000, irq=21

kernel: linville master-2009-09-08 2.6.31-rc9-wl-36500-g918dc92 

auth: WPA-EAP   PEAP

Best regards,
Felix

Sep  9 08:46:01 darkslate CROND[14154]: (root) CMD (   /usr/share/msec/promisc_check.sh)
Sep  9 08:46:22 darkslate klogd: ------------[ cut here ]------------
Sep  9 08:46:22 darkslate klogd: WARNING: at net/wireless/sme.c:617 __cfg80211_disconnected+0x1ff/0x210 [cfg80211]()
Sep  9 08:46:22 darkslate klogd: Hardware name: 1875DLU
Sep  9 08:46:22 darkslate klogd: deauth failed: -67
Sep  9 08:46:22 darkslate klogd: Modules linked in: xt_time xt_connlimit xt_realm iptable_raw xt_comment ipt_ULOG ipt_REJECT ipt_REDIRECT ipt_NETMAP ipt_MASQUERADE ipt_LOG ipt_ECN ipt_ecn ipt_ah ipt_addrtype nf_nat_tftp nf_nat_snmp_basic nf_nat_sip nf_nat_pptp nf_nat_proto_gre nf_nat_irc nf_nat_h323 nf_nat_ftp nf_nat_amanda ts_kmp nf_conntrack_amanda nf_conntrack_tftp nf_conntrack_sip nf_conntrack_pptp nf_conntrack_proto_gre nf_conntrack_netlink nf_conntrack_netbios_ns nf_conntrack_irc nf_conntrack_h323 nf_conntrack_ftp xt_tcpmss xt_recent xt_pkttype xt_physdev xt_owner xt_NFQUEUE xt_NFLOG nfnetlink_log xt_multiport xt_MARK xt_mark xt_mac xt_limit xt_length xt_iprange xt_helper xt_hashlimit xt_DSCP xt_dscp xt_dccp xt_conntrack xt_CONNMARK xt_connmark xt_CLASSIFY xt_tcpudp xt_state iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack iptable_mangle nfnetlink iptable_filter ip_tables x_tables i915 drm i2c_algo_bit aes_i586 aes_generic af_packet bridge stp llc bnep sco rfcomm l2cap bluetooth binfmt_misc 
Sep  9 08:46:22 darkslate klogd: oop fuse cpufreq_ondemand cpufreq_conservative cpufreq_powersave acpi_cpufreq freq_table arc4 ecb ath9k mac80211 ath cfg80211 thinkpad_acpi rfkill video tg3 joydev led_class evdev output nsc_ircc irda ehci_hcd crc_ccitt i2c_i801 i2c_core uhci_hcd intel_agp rtc_cmos sr_mod libphy sg iTCO_wdt iTCO_vendor_support pcspkr yenta_socket rsrc_nonstatic button agpgart thermal ac processor battery pcmcia_core nvram usbcore ata_generic ide_pci_generic ide_gd_mod ide_core pata_acpi ata_piix ahci libata sd_mod scsi_mod crc_t10dif ext3 jbd
Sep  9 08:46:22 darkslate klogd: Pid: 1142, comm: phy0 Tainted: G        W  2.6.31-rc9-wl-mnbStrip-36500-g918dc92 #77
Sep  9 08:46:22 darkslate klogd: Call Trace:
Sep  9 08:46:22 darkslate klogd:  [<f89134af>] ? __cfg80211_disconnected+0x1ff/0x210 [cfg80211]
Sep  9 08:46:22 darkslate klogd:  [<f89134af>] ? __cfg80211_disconnected+0x1ff/0x210 [cfg80211]
Sep  9 08:46:22 darkslate klogd:  [<c0138d9c>] warn_slowpath_common+0x6c/0xc0
Sep  9 08:46:22 darkslate klogd:  [<f89134af>] ? __cfg80211_disconnected+0x1ff/0x210 [cfg80211]
Sep  9 08:46:22 darkslate klogd:  [<c0138e36>] warn_slowpath_fmt+0x26/0x30
Sep  9 08:46:22 darkslate klogd:  [<f89134af>] __cfg80211_disconnected+0x1ff/0x210 [cfg80211]
Sep  9 08:46:22 darkslate klogd:  [<f8910262>] ? nl80211_send_deauth+0x22/0x30 [cfg80211]
Sep  9 08:46:22 darkslate klogd:  [<f8911463>] __cfg80211_send_deauth+0x213/0x260 [cfg80211]
Sep  9 08:46:22 darkslate klogd:  [<f89ea7a3>] ? __sta_info_free+0x33/0x40 [mac80211]
Sep  9 08:46:22 darkslate klogd:  [<f89ea9d3>] ? sta_info_destroy+0xf3/0x100 [mac80211]
Sep  9 08:46:22 darkslate klogd:  [<f89f1384>] ? ieee80211_set_disassoc+0x174/0x1d0 [mac80211]
Sep  9 08:46:22 darkslate klogd:  [<f891150e>] cfg80211_send_deauth+0x5e/0x70 [cfg80211]
Sep  9 08:46:22 darkslate klogd:  [<f89f2f31>] ieee80211_sta_work+0x901/0x1820 [mac80211]
Sep  9 08:46:22 darkslate klogd:  [<c0134ca1>] ? update_curr+0x1b1/0x1c0
Sep  9 08:46:22 darkslate klogd:  [<c013502d>] ? dequeue_task_fair+0x29d/0x2b0
Sep  9 08:46:22 darkslate klogd:  [<c010254d>] ? __switch_to+0xad/0x1a0
Sep  9 08:46:22 darkslate klogd:  [<c012a10f>] ? set_next_entity+0x11f/0x1b0
Sep  9 08:46:22 darkslate klogd:  [<c03a3c65>] ? schedule+0x495/0xa40
Sep  9 08:46:22 darkslate klogd:  [<c014fbea>] ? prepare_to_wait+0x3a/0x70
Sep  9 08:46:22 darkslate klogd:  [<c014b178>] worker_thread+0x148/0x210
Sep  9 08:46:22 darkslate klogd:  [<f89f2630>] ? ieee80211_sta_work+0x0/0x1820 [mac80211]
Sep  9 08:46:22 darkslate klogd:  [<c014f9a0>] ? autoremove_wake_function+0x0/0x50
Sep  9 08:46:22 darkslate klogd:  [<c014b030>] ? worker_thread+0x0/0x210
Sep  9 08:46:22 darkslate klogd:  [<c014f644>] kthread+0x84/0x90
Sep  9 08:46:22 darkslate klogd:  [<c014f5c0>] ? kthread+0x0/0x90
Sep  9 08:46:22 darkslate klogd:  [<c0104667>] kernel_thread_helper+0x7/0x10
Sep  9 08:46:22 darkslate klogd: ---[ end trace 46565fb73d858208 ]---
Sep  9 08:46:22 darkslate ifplugd(wlan0)[30335]: Link beat lost.
Sep  9 08:46:22 darkslate klogd: ------------[ cut here ]------------
Sep  9 08:46:22 darkslate klogd: WARNING: at net/wireless/sme.c:617 __cfg80211_disconnected+0x1ff/0x210 [cfg80211]()
Sep  9 08:46:22 darkslate klogd: Hardware name: 1875DLU
Sep  9 08:46:22 darkslate klogd: deauth failed: -67
Sep  9 08:46:22 darkslate klogd: Modules linked in: xt_time xt_connlimit xt_realm iptable_raw xt_comment ipt_ULOG ipt_REJECT ipt_REDIRECT ipt_NETMAP ipt_MASQUERADE ipt_LOG ipt_ECN ipt_ecn ipt_ah ipt_addrtype nf_nat_tftp nf_nat_snmp_basic nf_nat_sip nf_nat_pptp nf_nat_proto_gre nf_nat_irc nf_nat_h323 nf_nat_ftp nf_nat_amanda ts_kmp nf_conntrack_amanda nf_conntrack_tftp nf_conntrack_sip nf_conntrack_pptp nf_conntrack_proto_gre nf_conntrack_netlink nf_conntrack_netbios_ns nf_conntrack_irc nf_conntrack_h323 nf_conntrack_ftp xt_tcpmss xt_recent xt_pkttype xt_physdev xt_owner xt_NFQUEUE xt_NFLOG nfnetlink_log xt_multiport xt_MARK xt_mark xt_mac xt_limit xt_length xt_iprange xt_helper xt_hashlimit xt_DSCP xt_dscp xt_dccp xt_conntrack xt_CONNMARK xt_connmark xt_CLASSIFY xt_tcpudp xt_state iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack iptable_mangle nfnetlink iptable_filter ip_tables x_tables i915 drm i2c_algo_bit aes_i586 aes_generic af_packet bridge stp llc bnep sco rfcomm l2cap bluetooth binfmt_misc 
Sep  9 08:46:22 darkslate klogd: oop fuse cpufreq_ondemand cpufreq_conservative cpufreq_powersave acpi_cpufreq freq_table arc4 ecb ath9k mac80211 ath cfg80211 thinkpad_acpi rfkill video tg3 joydev led_class evdev output nsc_ircc irda ehci_hcd crc_ccitt i2c_i801 i2c_core uhci_hcd intel_agp rtc_cmos sr_mod libphy sg iTCO_wdt iTCO_vendor_support pcspkr yenta_socket rsrc_nonstatic button agpgart thermal ac processor battery pcmcia_core nvram usbcore ata_generic ide_pci_generic ide_gd_mod ide_core pata_acpi ata_piix ahci libata sd_mod scsi_mod crc_t10dif ext3 jbd
Sep  9 08:46:22 darkslate klogd: Pid: 1142, comm: phy0 Tainted: G        W  2.6.31-rc9-wl-mnbStrip-36500-g918dc92 #77
Sep  9 08:46:22 darkslate klogd: Call Trace:
Sep  9 08:46:22 darkslate klogd:  [<f89134af>] ? __cfg80211_disconnected+0x1ff/0x210 [cfg80211]
Sep  9 08:46:22 darkslate klogd:  [<f89134af>] ? __cfg80211_disconnected+0x1ff/0x210 [cfg80211]
Sep  9 08:46:22 darkslate klogd:  [<c0138d9c>] warn_slowpath_common+0x6c/0xc0
Sep  9 08:46:22 darkslate klogd:  [<f89134af>] ? __cfg80211_disconnected+0x1ff/0x210 [cfg80211]
Sep  9 08:46:22 darkslate klogd:  [<c0138e36>] warn_slowpath_fmt+0x26/0x30
Sep  9 08:46:22 darkslate klogd:  [<f89134af>] __cfg80211_disconnected+0x1ff/0x210 [cfg80211]
Sep  9 08:46:22 darkslate klogd:  [<f8910262>] ? nl80211_send_deauth+0x22/0x30 [cfg80211]
Sep  9 08:46:22 darkslate klogd:  [<f8911463>] __cfg80211_send_deauth+0x213/0x260 [cfg80211]
Sep  9 08:46:22 darkslate klogd:  [<f89ea7a3>] ? __sta_info_free+0x33/0x40 [mac80211]
Sep  9 08:46:22 darkslate klogd:  [<f89ea9d3>] ? sta_info_destroy+0xf3/0x100 [mac80211]
Sep  9 08:46:22 darkslate klogd:  [<f89f1384>] ? ieee80211_set_disassoc+0x174/0x1d0 [mac80211]
Sep  9 08:46:22 darkslate klogd:  [<f891150e>] cfg80211_send_deauth+0x5e/0x70 [cfg80211]
Sep  9 08:46:22 darkslate klogd:  [<f89f2f31>] ieee80211_sta_work+0x901/0x1820 [mac80211]
Sep  9 08:46:22 darkslate klogd:  [<c0134ca1>] ? update_curr+0x1b1/0x1c0
Sep  9 08:46:22 darkslate klogd:  [<c013502d>] ? dequeue_task_fair+0x29d/0x2b0
Sep  9 08:46:22 darkslate klogd:  [<c010254d>] ? __switch_to+0xad/0x1a0
Sep  9 08:46:22 darkslate klogd:  [<c012a10f>] ? set_next_entity+0x11f/0x1b0
Sep  9 08:46:22 darkslate klogd:  [<c03a3c65>] ? schedule+0x495/0xa40
Sep  9 08:46:22 darkslate klogd:  [<c014fbea>] ? prepare_to_wait+0x3a/0x70
Sep  9 08:46:22 darkslate klogd:  [<c014b178>] worker_thread+0x148/0x210
Sep  9 08:46:22 darkslate klogd:  [<f89f2630>] ? ieee80211_sta_work+0x0/0x1820 [mac80211]
Sep  9 08:46:22 darkslate klogd:  [<c014f9a0>] ? autoremove_wake_function+0x0/0x50
Sep  9 08:46:22 darkslate klogd:  [<c014b030>] ? worker_thread+0x0/0x210
Sep  9 08:46:22 darkslate klogd:  [<c014f644>] kthread+0x84/0x90
Sep  9 08:46:22 darkslate klogd:  [<c014f5c0>] ? kthread+0x0/0x90
Sep  9 08:46:22 darkslate klogd:  [<c0104667>] kernel_thread_helper+0x7/0x10
Sep  9 08:46:22 darkslate klogd: ---[ end trace 46565fb73d858208 ]---
Sep  9 08:46:22 darkslate ifplugd(wlan0)[30335]: Link beat lost.
Sep  9 08:46:23 darkslate ifplugd(wlan0)[30335]: Link beat detected.
Sep  9 08:46:23 darkslate ifplugd(wlan0)[30335]: Link beat detected.

dmesg -c
wlan0: deauthenticated from 00:0b:85:6f:12:ac (Reason: 1)
wlan0: direct probe to AP 00:0b:85:6f:20:8c (try 1)
wlan0 direct probe responded
wlan0: authenticate with AP 00:0b:85:6f:20:8c (try 1)
wlan0: authenticated
wlan0: associate with AP 00:0b:85:6f:20:8c (try 1)
wlan0: RX AssocResp from 00:0b:85:6f:20:8c (capab=0x421 status=17 aid=0)
wlan0: AP denied association (code=17)
wlan0: deauthenticating by local choice (reason=3)
wlan0: direct probe to AP 00:0b:85:6f:20:8c (try 1)
wlan0 direct probe responded
wlan0: authenticate with AP 00:0b:85:6f:20:8c (try 1)
wlan0: authenticated
wlan0: associate with AP 00:0b:85:6f:20:8c (try 1)
wlan0: RX AssocResp from 00:0b:85:6f:20:8c (capab=0x431 status=1 aid=16)
wlan0: AP denied association (code=1)
wlan0: direct probe to AP 00:0b:85:6f:12:ac (try 1)
wlan0 direct probe responded
wlan0: authenticate with AP 00:0b:85:6f:12:ac (try 1)
wlan0: authenticated
wlan0: associate with AP 00:0b:85:6f:12:ac (try 1)
wlan0: RX AssocResp from 00:0b:85:6f:12:ac (capab=0x431 status=0 aid=26)
wlan0: associated
wlan0: deauthenticated from 00:0b:85:6f:12:ac (Reason: 1)
wlan0: deauthenticating by local choice (reason=3)
------------[ cut here ]------------
WARNING: at net/wireless/sme.c:617 __cfg80211_disconnected+0x1ff/0x210 [cfg80211]()
Hardware name: 1875DLU
deauth failed: -67
Modules linked in: xt_time xt_connlimit xt_realm iptable_raw xt_comment ipt_ULOG ipt_REJECT ipt_REDIRECT ipt_NETMAP ipt_MASQUERADE ipt_LOG ipt_ECN ipt_ecn ipt_ah ipt_addrtype nf_nat_tftp nf_nat_snmp_basic nf_nat_sip nf_nat_pptp nf_nat_proto_gre nf_nat_irc nf_nat_h323 nf_nat_ftp nf_nat_amanda ts_kmp nf_conntrack_amanda nf_conntrack_tftp nf_conntrack_sip nf_conntrack_pptp nf_conntrack_proto_gre nf_conntrack_netlink nf_conntrack_netbios_ns nf_conntrack_irc nf_conntrack_h323 nf_conntrack_ftp xt_tcpmss xt_recent xt_pkttype xt_physdev xt_owner xt_NFQUEUE xt_NFLOG nfnetlink_log xt_multiport xt_MARK xt_mark xt_mac xt_limit xt_length xt_iprange xt_helper xt_hashlimit xt_DSCP xt_dscp xt_dccp xt_conntrack xt_CONNMARK xt_connmark xt_CLASSIFY xt_tcpudp xt_state iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack iptable_mangle nfnetlink iptable_filter ip_tables x_tables i915 drm i2c_algo_bit aes_i586 aes_generic af_packet bridge stp llc bnep sco rfcomm l2cap bluetooth binfmt_misc loop fuse cpufreq_ondemand cpufreq_conservative cpufreq_powersave acpi_cpufreq freq_table arc4 ecb ath9k mac80211 ath cfg80211 thinkpad_acpi rfkill video tg3 joydev led_class evdev output nsc_ircc irda ehci_hcd crc_ccitt i2c_i801 i2c_core uhci_hcd intel_agp rtc_cmos sr_mod libphy sg iTCO_wdt iTCO_vendor_support pcspkr yenta_socket rsrc_nonstatic button agpgart thermal ac processor battery pcmcia_core nvram usbcore ata_generic ide_pci_generic ide_gd_mod ide_core pata_acpi ata_piix ahci libata sd_mod scsi_mod crc_t10dif ext3 jbd
Pid: 1142, comm: phy0 Tainted: G        W  2.6.31-rc9-wl-mnbStrip-36500-g918dc92 #77
Call Trace:
 [<f89134af>] ? __cfg80211_disconnected+0x1ff/0x210 [cfg80211]
 [<f89134af>] ? __cfg80211_disconnected+0x1ff/0x210 [cfg80211]
 [<c0138d9c>] warn_slowpath_common+0x6c/0xc0
 [<f89134af>] ? __cfg80211_disconnected+0x1ff/0x210 [cfg80211]
 [<c0138e36>] warn_slowpath_fmt+0x26/0x30
 [<f89134af>] __cfg80211_disconnected+0x1ff/0x210 [cfg80211]
 [<f8910262>] ? nl80211_send_deauth+0x22/0x30 [cfg80211]
 [<f8911463>] __cfg80211_send_deauth+0x213/0x260 [cfg80211]
 [<f89ea7a3>] ? __sta_info_free+0x33/0x40 [mac80211]
 [<f89ea9d3>] ? sta_info_destroy+0xf3/0x100 [mac80211]
 [<f89f1384>] ? ieee80211_set_disassoc+0x174/0x1d0 [mac80211]
 [<f891150e>] cfg80211_send_deauth+0x5e/0x70 [cfg80211]
 [<f89f2f31>] ieee80211_sta_work+0x901/0x1820 [mac80211]
 [<c0134ca1>] ? update_curr+0x1b1/0x1c0
 [<c013502d>] ? dequeue_task_fair+0x29d/0x2b0
 [<c010254d>] ? __switch_to+0xad/0x1a0
 [<c012a10f>] ? set_next_entity+0x11f/0x1b0
 [<c03a3c65>] ? schedule+0x495/0xa40
 [<c014fbea>] ? prepare_to_wait+0x3a/0x70
 [<c014b178>] worker_thread+0x148/0x210
 [<f89f2630>] ? ieee80211_sta_work+0x0/0x1820 [mac80211]
 [<c014f9a0>] ? autoremove_wake_function+0x0/0x50
 [<c014b030>] ? worker_thread+0x0/0x210
 [<c014f644>] kthread+0x84/0x90
 [<c014f5c0>] ? kthread+0x0/0x90
 [<c0104667>] kernel_thread_helper+0x7/0x10
---[ end trace 46565fb73d858208 ]---
wlan0: direct probe to AP 00:0b:85:6f:12:ac (try 1)
wlan0 direct probe responded
wlan0: authenticate with AP 00:0b:85:6f:12:ac (try 1)
wlan0: authenticated
wlan0: associate with AP 00:0b:85:6f:12:ac (try 1)
wlan0: RX ReassocResp from 00:0b:85:6f:12:ac (capab=0x431 status=0 aid=25)
wlan0: associated

 sometimes no re-connect, until manual /etc/init.d/network restart


