Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.190]:3166 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611AbYLATD0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 14:03:26 -0500
Received: by rn-out-0910.google.com with SMTP id k40so2054170rnd.17
        for <linux-wireless@vger.kernel.org>; Mon, 01 Dec 2008 11:03:25 -0800 (PST)
Message-ID: <43e72e890812011103q6e7940cbu22c0281c9559aa63@mail.gmail.com> (sfid-20081201_200329_820261_CBA07BBA)
Date: Mon, 1 Dec 2008 11:03:25 -0800
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: 11d segfault
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1228129742.3478.2.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1228129742.3478.2.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 1, 2008 at 3:09 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> Dec  1 12:07:00 johannes kernel: [  193.370168] Unable to handle kernel paging request for data at address 0x00000000
> Dec  1 12:07:00 johannes kernel: [  193.370180] Faulting instruction address: 0xf2794560
> Dec  1 12:07:00 johannes kernel: [  193.370194] Oops: Kernel access of bad area, sig: 11 [#1]
> Dec  1 12:07:00 johannes kernel: [  193.370196] PREEMPT PowerMac
> Dec  1 12:07:00 johannes kernel: [  193.370200] Modules linked in: ...
> Dec  1 12:07:00 johannes kernel: [  193.370266] NIP: f2794560 LR: f27944fc CTR: 00000000
> Dec  1 12:07:00 johannes kernel: [  193.370270] REGS: eed15ce0 TRAP: 0300   Not tainted  (2.6.28-rc6-wl-dirty)
> Dec  1 12:07:00 johannes kernel: [  193.370273] MSR: 00009032 <EE,ME,IR,DR>  CR: 22000048  XER: 20000000
> Dec  1 12:07:00 johannes kernel: [  193.370283] DAR: 00000000, DSISR: 40000000
> Dec  1 12:07:00 johannes kernel: [  193.370286] TASK = ef145640[1049] 'phy0' THREAD: eed14000
> Dec  1 12:07:00 johannes kernel: [  193.370289] GPR00: 00000000 eed15d90 ef145640 eed15d38 22222222 00000000 eed15d48 37d38608
> Dec  1 12:07:00 johannes kernel: [  193.370299] GPR08: 37d38600 00000000 c03f97e0 f279bda0 82000044 00000000 00000000 00000000
> Dec  1 12:07:00 johannes kernel: [  193.370309] GPR16: 00000000 41400000 01400000 017f4bb4 017f42c0 00000000 c03f9400 c04264e8
> Dec  1 12:07:00 johannes kernel: [  193.370319] GPR24: c03f9438 00000000 f279c410 eecaa080 f279bd8c f27a0000 ec44a0d6 00000006
> Dec  1 12:07:00 johannes kernel: [  193.370346] NIP [f2794560] regulatory_hint_11d+0x98/0x14c [cfg80211]
> Dec  1 12:07:00 johannes kernel: [  193.370352] LR [f27944fc] regulatory_hint_11d+0x34/0x14c [cfg80211]
> Dec  1 12:07:00 johannes kernel: [  193.370355] Call Trace:
> Dec  1 12:07:00 johannes kernel: [  193.370361] [eed15d90] [f27944fc] regulatory_hint_11d+0x34/0x14c [cfg80211] (unreliable)

What is regulatory_hint_11d+0x34 ?

  Luis
