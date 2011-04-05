Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:25260 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754102Ab1DEO7g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2011 10:59:36 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 05 Apr 2011 07:59:11 -0700
Message-ID: <4D9B2E53.7080209@atheros.com>
Date: Tue, 5 Apr 2011 20:29:31 +0530
From: Mohammed Shafi <mshajakhan@atheros.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Mohammed Shajakhan <Mohammed.Shajakhan@Atheros.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] mac80211: Add station uptime in debugfs
References: <1302010795-2522-1-git-send-email-mshajakhan@atheros.com>	 <201104051604.16143.helmut.schaa@googlemail.com>	 <4D9B28D0.7020306@atheros.com> <1302015045.4968.0.camel@jlt3.sipsolutions.net>
In-Reply-To: <1302015045.4968.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 05 April 2011 08:20 PM, Johannes Berg wrote:
> On Tue, 2011-04-05 at 20:06 +0530, Mohammed Shafi wrote:
>    
>> On Tuesday 05 April 2011 07:34 PM, Helmut Schaa wrote:
>>      
>>> Am Dienstag, 5. April 2011 schrieb Mohammed Shafi Shajakhan:
>>>
>>>        
>>>> From: Mohammed Shafi Shajakhan<mshajakhan@atheros.com>
>>>>
>>>> Add station uptime parameter in debugfs. This will be helpful to get a
>>>> measure of stability of connection and also during stress testing.
>>>>
>>>>          
>>> It might even make sense to make this available through nl80211. At least
>>> in AP mode it would be interesting to see how long each STA is already
>>> connected.
>>>
>>> Helmut
>>>
>>>        
>> Thanks, will do it  once the maintainers are ok with this patch.
>>      
> Fine with me, but you should probably not call it "uptime" but rather
> "connected_time" or something, and address Felix's point.
>    
Thanks for the review, I will look to address both the things.
thanks,
shafi
> johannes
>
>    
