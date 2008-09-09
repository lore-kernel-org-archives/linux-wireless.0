Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39555 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753370AbYIIQ3d (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2008 12:29:33 -0400
Message-ID: <48C6A2B7.8030601@atheros.com> (sfid-20080909_182937_643844_07355C7B)
Date: Tue, 9 Sep 2008 21:52:15 +0530
From: vasanthakumar thiagarajan <vasanth.thiagarajan@atheros.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH] ath9k: Add RF kill support
References: <20080909153422.GA7651@vasanth-lnx.users.atheros.com>	 (sfid-20080909_173954_277503_9881BAF1) <1220974942.31304.180.camel@johannes.berg>
In-Reply-To: <1220974942.31304.180.camel@johannes.berg>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Tue, 2008-09-09 at 21:04 +0530, Vasanthakumar Thiagarajan wrote:
>   
>> This support is compiled in if CONFIG_RFKILL
>> option is set.
>>     
>
>   
>> +++ b/drivers/net/wireless/ath9k/Kconfig
>> @@ -4,6 +4,7 @@ config ATH9K
>>  	select MAC80211_LEDS
>>  	select LEDS_CLASS
>>  	select NEW_LEDS
>> +	select RFKILL
>>     
>
> You really want to drop that then though.
>
> johannes
>   
Yeah, I missed this one. Thanks.

Vasanth
