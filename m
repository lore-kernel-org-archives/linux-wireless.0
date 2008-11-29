Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:35214 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701AbYK2Guf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Nov 2008 01:50:35 -0500
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC v3 1/4] mac80211: enable IEEE80211_CONF_PS only when associated
References: <1227901784-5325-1-git-send-email-kalle.valo@nokia.com>
	<1227901784-5325-2-git-send-email-kalle.valo@nokia.com>
	<1227910263.3543.0.camel@johannes.berg>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Sat, 29 Nov 2008 08:50:19 +0200
In-Reply-To: <1227910263.3543.0.camel@johannes.berg> (ext Johannes Berg's message of "Fri\, 28 Nov 2008 23\:11\:03 +0100")
Message-ID: <87zljj10wk.fsf@nokia.com> (sfid-20081129_075041_546765_098AFEE6)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

>> +set:
>> +	local->powersave = ps;
>> +
>> +	if (ifsta->flags && IEEE80211_STA_ASSOCIATED) {
>
> This really needs to check you're actually in STA mode.

Thanks, I'll fix it. 

I'm going with the assumption that we don't support power save in IBSS
mode. I think we talked about this a long time ago.

-- 
Kalle Valo
