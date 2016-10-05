Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41956 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752481AbcJEPu6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Oct 2016 11:50:58 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc: linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net, ath9k-devel@lists.ath9k.org,
        Tim Shepard <shep@alum.mit.edu>, Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH v4] ath9k: Switch to using mac80211 intermediate software queues.
References: <20160706193417.13080-1-toke@toke.dk>
        <20160805160346.10545-1-toke@toke.dk>
        <87mvk44xmt.fsf@purkki.adurom.net> <87bn0k4w4d.fsf@toke.dk>
        <87fupwvisn.fsf@kamboji.qca.qualcomm.com> <871t1g4thz.fsf@toke.dk>
        <877fb8ug0x.fsf@kamboji.qca.qualcomm.com> <87k2dm6git.fsf@toke.dk>
Date: Wed, 05 Oct 2016 18:50:52 +0300
In-Reply-To: <87k2dm6git.fsf@toke.dk> ("Toke =?utf-8?Q?H=C3=B8iland-J?=
 =?utf-8?Q?=C3=B8rgensen=22's?= message of
        "Wed, 05 Oct 2016 16:02:02 +0200")
Message-ID: <878tu2okv7.fsf@kamboji.qca.qualcomm.com> (sfid-20161005_175102_217540_D5D00E85)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk> writes:

> Kalle Valo <kvalo@codeaurora.org> writes:
>
>> Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk> writes:
>>
>> I understand your point, but I don't want to rush this to 4.9 and then
>> start getting lots of bug reports and eventually forced to revert it. If
>> we just found a new serious regression the chances are that there are
>> more lurking somewhere and this patch is just not ready yet.
>
> So, the changes to mac80211 that fixes the known regressions of this
> patch have gone in.

I guess you mean this commit:

bb42f2d13ffc mac80211: Move reorder-sensitive TX handlers to after TXQ dequ=
eue

(Just making sure that I have the same commit in my tree when I apply this)

> Any chance of seeing this merged during the current merge window? :)

I sent last new feature ("-next") patches for 4.9 last week, sorry. So
this has to wait for 4.10.

And I assume I need to take v5:

https://patchwork.kernel.org/patch/9311037/

--=20
Kalle Valo
