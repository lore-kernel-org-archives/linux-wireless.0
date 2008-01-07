Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:23339 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756112AbYAGQxn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jan 2008 11:53:43 -0500
Received: by fg-out-1718.google.com with SMTP id e21so4306449fga.17
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jan 2008 08:53:40 -0800 (PST)
Date: Mon, 7 Jan 2008 17:52:48 +0100
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?=
	<ariveira@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-wireless@vger.kernel.org
Subject: Re: Linux 2.6.24-rc7
Message-ID: <20080107175248.7b0e143f@Varda> (sfid-20080107_165347_649064_38CD6A80)
In-Reply-To: <200801071724.03936.mb@bu3sch.de>
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org>
	<20080107171415.19826ea4@Varda>
	<200801071724.03936.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

El Mon, 7 Jan 2008 17:24:03 +0100
Michael Buesch <mb@bu3sch.de> escribi=C3=B3:

                                                                       =
             =20
>=20
> Can you post the lines above this?
> This might be a WARN_ON_ONCE() triggering, for which fixes are on the=
ir way into
> the wireless-2.6 tree.

 This?


[   37.043990] WARNING: at /home/alex/kernel/linux-2.6/net/mac80211/rx.=
c:1486 __ieee80211_rx()=20
[   37.043996] Pid: 0, comm: swapper Not tainted 2.6.24-rc7 #3         =
                                                     =20
[   37.043998]                                                         =
                                                     =20
[   37.043999] Call Trace:                                             =
                                                     =20
[   37.044001]  <IRQ>  [<ffffffff80227fe3>] enqueue_task+0x13/0x30     =
                                                     =20
[   37.044040]  [<ffffffff88178cbe>] :mac80211:__ieee80211_rx+0xc7e/0xd=
30                                                   =20
[   37.044044]  [<ffffffff80228062>] activate_task+0x32/0x50           =
                                                     =20
[   37.044073]  [<ffffffff8816a28b>] :mac80211:ieee80211_tasklet_handle=
r+0xbb/0x120                                         =20
[   37.044086]  [<ffffffff80238d08>] tasklet_action+0x48/0xb0          =
                                                     =20
[   37.044091]  [<ffffffff80238c09>] __do_softirq+0x69/0xe0            =
                                                     =20
[   37.044097]  [<ffffffff8020ce2c>] call_softirq+0x1c/0x30            =
                                                     =20
[   37.044101]  [<ffffffff8020efe5>] do_softirq+0x35/0x90              =
                                                     =20
[   37.044105]  [<ffffffff80238aa5>] irq_exit+0x95/0xa0                =
                                                     =20
[   37.044108]  [<ffffffff8020f0c0>] do_IRQ+0x80/0x100                 =
                                                     =20
[   37.044111]  [<ffffffff8020a840>] default_idle+0x0/0x40             =
                                                     =20
[   37.044115]  [<ffffffff8020c181>] ret_from_intr+0x0/0xa             =
                                                     =20
[   37.044117]  <EOI>  [<ffffffff8020a869>] default_idle+0x29/0x40     =
                                                     =20
[   37.044130]  [<ffffffff8020a8f5>] cpu_idle+0x75/0xc0                =
                                                     =20
[   37.044146]                                                         =
                                                     =20


>=20
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
