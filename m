Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:44503 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752576AbcKIKmV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Nov 2016 05:42:21 -0500
From: =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Tim Shepard <shep@alum.mit.edu>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>
Subject: Re: [v5] ath9k: Switch to using mac80211 intermediate software queues.
References: <E1c4IsV-0003Rk-00@www.xplot.org>
Date: Wed, 09 Nov 2016 11:42:16 +0100
In-Reply-To: <E1c4IsV-0003Rk-00@www.xplot.org> (Tim Shepard's message of "Tue,
        08 Nov 2016 21:44:42 -0500")
Message-ID: <87k2cd0waf.fsf@toke.dk> (sfid-20161109_114225_804809_8B5A7931)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tim Shepard <shep@alum.mit.edu> writes:

>> While at it, could you also add to the commit log some info how awesome this
>> patch is from user's point of view and how it helps. For example, before and
>> and after numbers and other results.
>
> That varies wildly, depending on many details of the scenario
> (including the wireless capabilities of the clients connected to the
> AP using this patch, and how far away those clients are). There's
> really not enough room in a commit message to explain enough to make
> any such claimed numbers reproducible.

I disagree; it's quite straightforward to demonstrate a gain from this
on an ath9k access point. And while of course the mac80211 queues is the
reason for this, the commit that uses it (i.e. this one) can explain
that and include some numbers. I'll add that and resend :)

-Toke
