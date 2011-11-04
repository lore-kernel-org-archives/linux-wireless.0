Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47986 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932296Ab1KDTZ3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 15:25:29 -0400
Subject: Re: v3.1 - WARNING: at net/mac80211/util.c:540
 ieee80211_can_queue_work
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1320431074.29441.25.camel@localhost.localdomain>
References: <1320431074.29441.25.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Nov 2011 20:25:27 +0100
Message-ID: <1320434727.3969.124.camel@jlt3.sipsolutions.net> (sfid-20111104_202533_593942_C845ABB3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A little more ... anything really ... would be helpful.

johannes

[full quote for wireless list]


On Fri, 2011-11-04 at 19:24 +0100, Thomas Meyer wrote:
> [281558.898551] WARNING: at net/mac80211/util.c:540 ieee80211_can_queue_work+0x35/0x40 [mac80211]()
> [281558.898554] Hardware name: Aspire 1810T
> [281558.898556] queueing ieee80211 work while going to suspend
> [281558.898558] Modules linked in: ipt_MASQUERADE iptable_nat nf_nat
> vfat fat fuse bluetooth nf_conntrack_ipv6 nf_defrag_ipv6 ip6t_REJECT
> ip6table_filter ip6_tables sha256_generic aes_x86_64 aes_generic
> snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec
> snd_hwdep snd_seq snd_seq_device arc4 snd_pcm snd_timer iwlagn
> virtio_net virtio virtio_ring uvcvideo mac80211 videodev usb_storage
> v4l2_compat_ioctl32 snd kvm_intel cfg80211 soundcore acer_wmi kvm
> snd_page_alloc sparse_keymap wmi acerhdf rfkill pcspkr joydev uinput
> ipv6
> [281558.898592] Pid: 0, comm: swapper Tainted: G        W   3.1.0 #3
> [281558.898595] Call Trace:
> [281558.898597]  <IRQ>  [<ffffffff8103024a>] warn_slowpath_common+0x7a/0xb0
> [281558.898610]  [<ffffffff8105731d>] ? clockevents_program_event+0x5d/0xa0
> [281558.898614]  [<ffffffff81030321>] warn_slowpath_fmt+0x41/0x50
> [281558.898619]  [<ffffffff81058259>] ? tick_program_event+0x19/0x20
> [281558.898624]  [<ffffffff8104d46e>] ? hrtimer_interrupt+0xfe/0x1f0
> [281558.898633]  [<ffffffffa017fe45>] ieee80211_can_queue_work+0x35/0x40 [mac80211]
> [281558.898642]  [<ffffffffa017ff9b>] ieee80211_queue_work+0x1b/0x40 [mac80211]
> [281558.898651]  [<ffffffffa016bfdf>] ieee80211_sta_timer+0x2f/0x40 [mac80211]
> [281558.898657]  [<ffffffff8103bb8f>] run_timer_softirq+0xef/0x210
> [281558.898666]  [<ffffffffa016bfb0>] ? ieee80211_sta_bcn_mon_timer+0x40/0x40 [mac80211]
> [281558.898671]  [<ffffffff81035787>] __do_softirq+0x87/0x110
> [281558.898677]  [<ffffffff81485c3a>] call_softirq+0x1a/0x30
> [281558.898682]  [<ffffffff810038dd>] do_softirq+0x4d/0x80
> [281558.898685]  [<ffffffff810359ee>] irq_exit+0x7e/0xa0
> [281558.898689]  [<ffffffff8100377b>] do_IRQ+0x5b/0xd0
> [281558.898693]  [<ffffffff8147f569>] common_interrupt+0x69/0x69
> [281558.898695]  <EOI>  [<ffffffff8123d352>] ? acpi_idle_enter_c1+0x2d/0x98
> [281558.898704]  [<ffffffff8123d352>] ? acpi_idle_enter_c1+0x2d/0x98
> [281558.898708]  [<ffffffff8123d5db>] acpi_idle_enter_simple+0x31/0xe8
> [281558.898714]  [<ffffffff81395149>] cpuidle_idle_call+0x99/0xf0
> [281558.898717]  [<ffffffff810011e8>] cpu_idle+0x98/0xe0
> [281558.898722]  [<ffffffff8146e45e>] rest_init+0x62/0x64
> [281558.898726]  [<ffffffff81690b5b>] start_kernel+0x34e/0x359
> [281558.898730]  [<ffffffff81690322>] x86_64_start_reservations+0x132/0x136
> [281558.898734]  [<ffffffff81690416>] x86_64_start_kernel+0xf0/0xf7
> [281558.898739]  [<ffffffff81017370>] ? acpi_suspend_lowlevel+0x1b0/0x1b0
> [281558.898742] ---[ end trace 4dca017856e3a2e9 ]---
> 


