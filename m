Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:63926 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755470Ab1BNEfd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Feb 2011 23:35:33 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 13 Feb 2011 20:35:12 -0800
Message-ID: <4D58B10F.60907@atheros.com>
Date: Mon, 14 Feb 2011 10:05:27 +0530
From: Mohammed Shafi <mshajakhan@atheros.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Felix Fietkau <nbd@openwrt.org>,
	Mohammed Shajakhan <Mohammed.Shajakhan@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH] ath9k: make use of slot time macros
References: <1297407704-4029-1-git-send-email-mshajakhan@atheros.com> <4D553107.3020402@openwrt.org> <20110211161551.GA2224@tuxdriver.com>
In-Reply-To: <20110211161551.GA2224@tuxdriver.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 11 February 2011 09:45 PM, John W. Linville wrote:
> On Fri, Feb 11, 2011 at 01:52:23PM +0100, Felix Fietkau wrote:
>    
>> On 2011-02-11 8:01 AM, Mohammed Shafi Shajakhan wrote:
>>      
>>> From: Mohammed Shafi Shajakhan<mshajakhan@atheros.com>
>>>
>>> Instead of using raw numbers to assign slot time it would be better to
>>> make use of predefined slot time macros
>>>        
>> How does this make it better?
>>      
> Maybe if it was ATH9K_SHORT_SLOT_TIME it would make more sense?
>    
John I never thought of that, but we have three macros in the driver :

mac.h             72 #define ATH9K_SLOT_TIME_6 6
mac.h             73 #define ATH9K_SLOT_TIME_9 9
mac.h             74 #define ATH9K_SLOT_TIME_20 20

both slot times 6,9 can be classified as short

thanks,
shafi


