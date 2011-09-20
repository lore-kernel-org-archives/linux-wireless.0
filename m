Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:63041 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab1ITVox (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Sep 2011 17:44:53 -0400
Received: by ewy4 with SMTP id 4so756572ewy.5
        for <linux-wireless@vger.kernel.org>; Tue, 20 Sep 2011 14:44:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87aa9zi80v.fsf@purkki.adurom.net>
References: <1316347394-21276-1-git-send-email-eliad@wizery.com>
 <1316408970.2157.9.camel@cumari> <87aaa0k0a1.fsf@purkki.adurom.net>
 <CAB3XZEdiTRDJGUHWJ5UorQq2w-ZLP+TP0b-qSSVUTzhPG4H2rg@mail.gmail.com>
 <87litjipda.fsf@purkki.adurom.net> <CAK=WgbZM5zdgOurFfGbQR3V_mqd85qjS_u1_tU35oaVPCh0Rkg@mail.gmail.com>
 <87aa9zi80v.fsf@purkki.adurom.net>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 21 Sep 2011 00:44:31 +0300
Message-ID: <CAK=WgbaELpStOx-K7dKwztTYgM-fZ2WvHrGxOvx775k3eiSUFA@mail.gmail.com> (sfid-20110920_234456_742736_38057FBA)
Subject: Re: [PATCH] mac80211: add ieee80211_set_dyn_ps_timeout()
To: Kalle Valo <kvalo@adurom.com>
Cc: Eliad Peller <eliad@wizery.com>, Luciano Coelho <coelho@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 20, 2011 at 5:49 PM, Kalle Valo <kvalo@adurom.com> wrote:
> Ohad Ben-Cohen <ohad@wizery.com> writes:
> > A lot has happened since then :) The wl12xx firmware today is vastly
> > different and much improved.
>
> Yeah, quite a turn. That's good :)

And it's getting even better.. we have some news:

One of the things we've been pushing for for some time is to get real
IEEE80211_HW_SUPPORTS_DYNAMIC_PS support. Coincidentally we've been
just notified that this is materializing for wl12xx as we speak, so
we'll be shifting to IEEE80211_HW_SUPPORTS_DYNAMIC_PS very soon.

In that case, I can happily say this whole discussion is moot. We
agree not to agree, but at least we don't have to resolve it :)
