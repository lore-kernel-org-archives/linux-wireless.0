Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:55248 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757911Ab3DXKwU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Apr 2013 06:52:20 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC v2] cfg80211: Android P2P-Device workaround
References: <1366791988-11309-1-git-send-email-johannes@sipsolutions.net>
	<87mwso5jbx.fsf@purkki.adurom.net>
	<1366800294.11111.7.camel@jlt4.sipsolutions.net>
Date: Wed, 24 Apr 2013 13:52:19 +0300
In-Reply-To: <1366800294.11111.7.camel@jlt4.sipsolutions.net> (Johannes Berg's
	message of "Wed, 24 Apr 2013 12:44:54 +0200")
Message-ID: <87ehe05hgc.fsf@purkki.adurom.net> (sfid-20130424_125226_580381_A5A78CA9)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Wed, 2013-04-24 at 13:11 +0300, Kalle Valo wrote:
>> Johannes Berg <johannes@sipsolutions.net> writes:
>> 
>> > +#ifndef CONFIG_CFG80211_ANDROID_P2P_HACK
>> >  	if (WARN_ON(wdev->netdev))
>> >  		return;
>> > +#endif
>> 
>> With my favorite kernel macro, config_enabled(), you could get rid of
>> quite a lot of the ugly ifdefs.
>
> Yeah, but as long as this isn't going upstream I don't really want to
> though since then it touches the code and is less obvious. Anyway we'll
> see.

Ah, makes send.

FWIW, I think we should push this, and other wireless Android support,
upstream. We should first get them to use upstream interfaces and then
start fixing the problematic areas one by one.

-- 
Kalle Valo
