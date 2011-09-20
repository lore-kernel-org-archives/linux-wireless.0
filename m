Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39307 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754437Ab1ITIuQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Sep 2011 04:50:16 -0400
Received: by wyg34 with SMTP id 34so268477wyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Sep 2011 01:50:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87litjipda.fsf@purkki.adurom.net>
References: <1316347394-21276-1-git-send-email-eliad@wizery.com>
 <1316408970.2157.9.camel@cumari> <87aaa0k0a1.fsf@purkki.adurom.net>
 <CAB3XZEdiTRDJGUHWJ5UorQq2w-ZLP+TP0b-qSSVUTzhPG4H2rg@mail.gmail.com> <87litjipda.fsf@purkki.adurom.net>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 20 Sep 2011 11:49:55 +0300
Message-ID: <CAK=WgbZM5zdgOurFfGbQR3V_mqd85qjS_u1_tU35oaVPCh0Rkg@mail.gmail.com> (sfid-20110920_105020_574756_DA218D74)
Subject: Re: [PATCH] mac80211: add ieee80211_set_dyn_ps_timeout()
To: Kalle Valo <kvalo@adurom.com>
Cc: Eliad Peller <eliad@wizery.com>, Luciano Coelho <coelho@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 20, 2011 at 11:34 AM, Kalle Valo <kvalo@adurom.com> wrote:
> IIRC Juuso added ieee80211_enable/disable_dyn_ps() to make it possible
> use BT COEX with wl12xx.

A lot has happened since then :) The wl12xx firmware today is vastly
different and much improved.

> Now you are saying that you actually want the opposite?

Yes. The firmware is now capable of doing coex without enforcing PSM.
This leads to a much better WLAN TP while BT is on.

> But nevertheless I'm not still convinced that doing all this in
> mac80211 is the right thing. Especially that this seems to be very
> wl12xx specific, right?

Not really, why do you consider this wl12xx specific more than any
other hw offloading or mac80211 API that is used by a single driver ?
