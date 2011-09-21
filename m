Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:34355 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736Ab1IUGe7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Sep 2011 02:34:59 -0400
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Eliad Peller <eliad@wizery.com>, Luciano Coelho <coelho@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: add ieee80211_set_dyn_ps_timeout()
References: <1316347394-21276-1-git-send-email-eliad@wizery.com>
	<1316408970.2157.9.camel@cumari> <87aaa0k0a1.fsf@purkki.adurom.net>
	<CAB3XZEdiTRDJGUHWJ5UorQq2w-ZLP+TP0b-qSSVUTzhPG4H2rg@mail.gmail.com>
	<87litjipda.fsf@purkki.adurom.net>
	<CAK=WgbZM5zdgOurFfGbQR3V_mqd85qjS_u1_tU35oaVPCh0Rkg@mail.gmail.com>
	<87aa9zi80v.fsf@purkki.adurom.net>
	<CAK=WgbaELpStOx-K7dKwztTYgM-fZ2WvHrGxOvx775k3eiSUFA@mail.gmail.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Wed, 21 Sep 2011 09:34:57 +0300
In-Reply-To: <CAK=WgbaELpStOx-K7dKwztTYgM-fZ2WvHrGxOvx775k3eiSUFA@mail.gmail.com> (Ohad Ben-Cohen's message of "Wed\, 21 Sep 2011 00\:44\:31 +0300")
Message-ID: <87y5xih08e.fsf@purkki.adurom.net> (sfid-20110921_083502_812759_DCB79FBB)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ohad Ben-Cohen <ohad@wizery.com> writes:

> On Tue, Sep 20, 2011 at 5:49 PM, Kalle Valo <kvalo@adurom.com> wrote:
>> Ohad Ben-Cohen <ohad@wizery.com> writes:
>> > A lot has happened since then :) The wl12xx firmware today is vastly
>> > different and much improved.
>>
>> Yeah, quite a turn. That's good :)
>
> And it's getting even better.. we have some news:
>
> One of the things we've been pushing for for some time is to get real
> IEEE80211_HW_SUPPORTS_DYNAMIC_PS support. Coincidentally we've been
> just notified that this is materializing for wl12xx as we speak, so
> we'll be shifting to IEEE80211_HW_SUPPORTS_DYNAMIC_PS very soon.
>
> In that case, I can happily say this whole discussion is moot. We
> agree not to agree, but at least we don't have to resolve it :)

Wow, that's great!

Having the dynps implementation in hardware makes perfect sense. That
way you get to do all sorts of optimisation without affecting the host
and will save some power as well.

Thanks for kicking some sense to your firmware engineers ;)

-- 
Kalle Valo
