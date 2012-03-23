Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:63183 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753119Ab2CWOFM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2012 10:05:12 -0400
Message-ID: <4F6C8316.5080600@tieto.com> (sfid-20120323_150519_780777_ABF50507)
Date: Fri, 23 Mar 2012 15:05:10 +0100
From: =?UTF-8?B?TWljaGHFgiBLYXppb3I=?= <michal.kazior@tieto.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC 04/12] mac80211: prepare ieee80211_get_tx_channel_type to
 per-vif
References: <fee1d9db-75c7-4e26-a463-e5d436a24cc2@FIVLA-EXHUB02.eu.tieto.com>	 (sfid-20120320_155525_168969_C5FBFFE9) <1332491869.3506.2.camel@jlt3.sipsolutions.net>
In-Reply-To: <1332491869.3506.2.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
>
>>   enum nl80211_channel_type ieee80211_get_tx_channel_type(
>> -				struct ieee80211_local *local,
>> +				struct ieee80211_sub_if_data *sdata,
>>   				enum nl80211_channel_type channel_type)
>
> I have pending patches to delete this :)
>

You mean you have patches that remove the ieee80211_get_tx_channel_type 
function? Are they accessible publicly or do you have them in your local 
repository? Do you mind sharing them or are you going to push them soon?


-- Pozdrawiam / Best Regards, Michal Kazior.
