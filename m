Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53699 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754777Ab1ITI7o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Sep 2011 04:59:44 -0400
Received: by wwf22 with SMTP id 22so479077wwf.1
        for <linux-wireless@vger.kernel.org>; Tue, 20 Sep 2011 01:59:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87hb47ip7q.fsf@purkki.adurom.net>
References: <1316347394-21276-1-git-send-email-eliad@wizery.com>
 <1316408970.2157.9.camel@cumari> <87aaa0k0a1.fsf@purkki.adurom.net>
 <CAB3XZEdiTRDJGUHWJ5UorQq2w-ZLP+TP0b-qSSVUTzhPG4H2rg@mail.gmail.com>
 <1316450319.5995.33.camel@jlt3.sipsolutions.net> <87hb47ip7q.fsf@purkki.adurom.net>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 20 Sep 2011 11:59:23 +0300
Message-ID: <CAK=WgbY1cbQ-5k6Hc1O=SmULACmUd32UXXKkGhGggbUFPt8PQA@mail.gmail.com> (sfid-20110920_105947_736359_058117E2)
Subject: Re: [PATCH] mac80211: add ieee80211_set_dyn_ps_timeout()
To: Kalle Valo <kvalo@adurom.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Eliad Peller <eliad@wizery.com>,
	Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 20, 2011 at 11:37 AM, Kalle Valo <kvalo@adurom.com> wrote:
> One extreme is that wl12xx would set IEEE80211_HW_SUPPORTS_DYNAMIC_PS
> and reimplement the dynps timer in the driver. That way the driver
> would have full control how it works and not complicate the mac80211
> implementation.

That sounds like an awful code duplication just to prevent a small API
extension.

Yes, adding API complicates the code, but isn't the whole point of
mac80211 is to prevent egregious code duplication ?
