Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:38585 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbYK2GzP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Nov 2008 01:55:15 -0500
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC v3 3/4] mac80211: add IEEE80211_HW_NO_DYNAMIC_PS flag
References: <1227901784-5325-1-git-send-email-kalle.valo@nokia.com>
	<1227901784-5325-4-git-send-email-kalle.valo@nokia.com>
	<1227910525.3543.5.camel@johannes.berg>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Sat, 29 Nov 2008 08:55:03 +0200
In-Reply-To: <1227910525.3543.5.camel@johannes.berg> (ext Johannes Berg's message of "Fri\, 28 Nov 2008 23\:15\:25 +0100")
Message-ID: <87r64v10oo.fsf@nokia.com> (sfid-20081129_075519_137146_47428D9C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Fri, 2008-11-28 at 21:49 +0200, Kalle Valo wrote:
>> Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
>> ---
>>  include/net/mac80211.h |    1 +
>>  net/mac80211/tx.c      |    3 ++-
>>  2 files changed, 3 insertions(+), 1 deletions(-)
>> 
>> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
>> index 6a1d4ea..53a0dc5 100644
>> --- a/include/net/mac80211.h
>> +++ b/include/net/mac80211.h
>> @@ -858,6 +858,7 @@ enum ieee80211_hw_flags {
>>  	IEEE80211_HW_NOISE_DBM				= 1<<8,
>>  	IEEE80211_HW_SPECTRUM_MGMT			= 1<<9,
>>  	IEEE80211_HW_AMPDU_AGGREGATION			= 1<<10,
>> +	IEEE80211_HW_NO_DYNAMIC_PS			= 1<<11,
>
> Add documentation please.

Will do. Actually it was on my TODO list already.

-- 
Kalle Valo
