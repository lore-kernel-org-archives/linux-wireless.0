Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lan.nucleusys.com ([92.247.61.126]:56316 "EHLO zztop"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751391AbaJXPQS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2014 11:16:18 -0400
Date: Fri, 24 Oct 2014 17:34:40 +0300
From: Petko Manolov <petkan@nucleusys.com>
To: Johannes Berg <johannes.berg@intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: iwlmwm dump
Message-ID: <20141024143440.GB4006@localhost> (sfid-20141024_171622_441545_58729AF8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

	Hi guys,

Since this is happening regularly on my machine i thought you might be interested.


cheers,
Petko


[    3.788633] iwlwifi 0000:01:00.0: Direct firmware load for iwlwifi-7260-10.ucode failed with error -2
[    3.790849] iwlwifi 0000:01:00.0: loaded firmware version 23.214.9.0 op_mode iwlmvm

[ 1057.767587] ------------[ cut here ]------------
[ 1057.767609] WARNING: CPU: 0 PID: 3524 at drivers/net/wireless/iwlwifi/mvm/tx.c:190 iwl_mvm_set_tx_params+0x57a/0x5d0 [iwlmvm]()
[ 1057.767611] Got an HT rate for a non data frame 0x8
[ 1057.767613] Modules linked in: kvm_intel kvm microcode iwlmvm iwlwifi
[ 1057.767626] CPU: 0 PID: 3524 Comm: wpa_supplicant Not tainted 3.17.1 #38
[ 1057.767628] Hardware name: LENOVO 20266/Yoga2, BIOS 76CN27WW 09/17/2013
[ 1057.767630]  0000000000000009 ffffffff8155934f ffff880097a0b958 ffffffff8106768d
[ 1057.767636]  0000000000001808 ffff880097a0b9a8 ffff88025483e5e0 ffff880097735d00
[ 1057.767640]  0000000000000000 ffffffff810676f7 ffffffffa0034638 ffff880200000020
[ 1057.767645] Call Trace:
[ 1057.767660]  [<ffffffff8155934f>] ? dump_stack+0x41/0x51
[ 1057.767666]  [<ffffffff8106768d>] ? warn_slowpath_common+0x6d/0x90
[ 1057.767670]  [<ffffffff810676f7>] ? warn_slowpath_fmt+0x47/0x50
[ 1057.767679]  [<ffffffff811d9e6a>] ? crypto_ccm_init_tfm+0x4a/0xa0
[ 1057.767688]  [<ffffffffa00245ba>] ? iwl_mvm_set_tx_params+0x57a/0x5d0 [iwlmvm]
[ 1057.767696]  [<ffffffffa0024838>] ? iwl_mvm_tx_skb+0x48/0x3c0 [iwlmvm]
[ 1057.767703]  [<ffffffffa001db4b>] ? iwl_mvm_mac_tx+0x7b/0x180 [iwlmvm]
[ 1057.767709]  [<ffffffff8153bfc9>] ? __ieee80211_tx+0x2b9/0x3c0
[ 1057.767714]  [<ffffffff8153e3d3>] ? ieee80211_tx+0xb3/0x100
[ 1057.767719]  [<ffffffff8153ebd1>] ? ieee80211_subif_start_xmit+0x391/0x9e0
[ 1057.767728]  [<ffffffff814f0000>] ? packet_create+0x10/0x210
[ 1057.767737]  [<ffffffff81471e2d>] ? dev_hard_start_xmit+0x2bd/0x4d0
[ 1057.767743]  [<ffffffff8148ad26>] ? sch_direct_xmit+0x96/0x1f0
[ 1057.767749]  [<ffffffff814721ea>] ? __dev_queue_xmit+0x1aa/0x490
[ 1057.767754]  [<ffffffff8148a1a0>] ? ether_setup+0x70/0x70
[ 1057.767762]  [<ffffffff814f33a9>] ? packet_sendmsg+0xf49/0x10c0
[ 1057.767770]  [<ffffffff814583ae>] ? sock_sendmsg+0x6e/0x90
[ 1057.767777]  [<ffffffff81461ee0>] ? skb_queue_purge+0x20/0x30
[ 1057.767784]  [<ffffffff81094980>] ? autoremove_wake_function+0x30/0x30
[ 1057.767793]  [<ffffffff8114ade2>] ? fsnotify_clear_marks_by_inode+0x22/0x110
[ 1057.767798]  [<ffffffff814589fd>] ? sockfd_lookup_light+0xd/0x60
[ 1057.767804]  [<ffffffff81459962>] ? SYSC_sendto+0x102/0x130
[ 1057.767811]  [<ffffffff8145aa59>] ? __sys_recvmsg+0x39/0x70
[ 1057.767818]  [<ffffffff81560596>] ? system_call_fastpath+0x1a/0x1f
[ 1057.767821] ---[ end trace e16527461e072e77 ]---
