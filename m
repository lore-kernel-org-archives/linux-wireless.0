Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:37657 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751178Ab1BOGHr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 01:07:47 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 14 Feb 2011 22:07:27 -0800
Message-ID: <4D5A182D.8090903@atheros.com>
Date: Tue, 15 Feb 2011 11:37:41 +0530
From: Mohammed Shafi <mshajakhan@atheros.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Mohammed Shajakhan <Mohammed.Shajakhan@Atheros.com>,
	Felix Fietkau <nbd@openwrt.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH] ath9k: make use of slot time macros
References: <1297407704-4029-1-git-send-email-mshajakhan@atheros.com> <4D553107.3020402@openwrt.org> <20110211161551.GA2224@tuxdriver.com> <4D5561F2.3050404@openwrt.org> <20110211162944.GD2224@tuxdriver.com> <4D58B25D.4040507@atheros.com> <20110214201429.GF2722@tuxdriver.com>
In-Reply-To: <20110214201429.GF2722@tuxdriver.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 15 February 2011 01:44 AM, John W. Linville wrote:
> On Mon, Feb 14, 2011 at 10:11:01AM +0530, Mohammed Shafi wrote:
>    
>> On Friday 11 February 2011 09:59 PM, John W. Linville wrote:
>>      
>>> On Fri, Feb 11, 2011 at 05:21:06PM +0100, Felix Fietkau wrote:
>>>        
>>>> On 2011-02-11 5:15 PM, John W. Linville wrote:
>>>>          
>>>>> On Fri, Feb 11, 2011 at 01:52:23PM +0100, Felix Fietkau wrote:
>>>>>            
>>>>>> On 2011-02-11 8:01 AM, Mohammed Shafi Shajakhan wrote:
>>>>>>              
>>>>>>> From: Mohammed Shafi Shajakhan<mshajakhan@atheros.com>
>>>>>>>
>>>>>>> Instead of using raw numbers to assign slot time it would be better to
>>>>>>> make use of predefined slot time macros
>>>>>>>                
>>>>>> How does this make it better?
>>>>>>              
>>>>> Maybe if it was ATH9K_SHORT_SLOT_TIME it would make more sense?
>>>>>            
>>>> Well, neither the unit of this variable, nor the values that can be used
>>>> are ath9k specific.
>>>>          
>>> True -- the patch is probably an unnecessarily zealous attempt to avoid
>>> "magic numbers" in the code. :-)
>>>        
>> John there are two instances where these macros are used:
>>
>> htc_drv_beacon.c 242 if (ah->slottime == ATH9K_SLOT_TIME_20)
>>   init.c           517 sc->beacon.slottime = ATH9K_SLOT_TIME_9;
>>      
> Maybe you should just get rid of those instead?
>    
Ok John, thanks.
