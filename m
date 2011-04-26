Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:42688 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773Ab1DZMOu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2011 08:14:50 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 26 Apr 2011 05:14:23 -0700
Message-ID: <4DB6B734.4070509@atheros.com> (sfid-20110426_141503_422373_EF413F10)
Date: Tue, 26 Apr 2011 17:44:44 +0530
From: Mohammed Shafi <mshajakhan@atheros.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Mohammed Shajakhan <Mohammed.Shajakhan@Atheros.com>,
	Lito Kriara <L.Kriara@sms.ed.ac.uk>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: Add num_stations connected in debugfs
References: <1303646133-2809-1-git-send-email-mshajakhan@atheros.com>	 <1303652185.3603.0.camel@jlt3.sipsolutions.net>	 <4DB4318F.6070801@atheros.com>	 <1303657150.3603.1.camel@jlt3.sipsolutions.net>	 <4DB4415F.2070707@atheros.com>	 <1303659120.3603.3.camel@jlt3.sipsolutions.net>	 <4DB4F8D5.1060108@atheros.com>	 <20110426125801.q89ma5n6cgkwog80@www.sms.ed.ac.uk>	 <4DB6B48D.6080508@atheros.com> <1303819622.4784.3.camel@jlt3.sipsolutions.net>
In-Reply-To: <1303819622.4784.3.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 26 April 2011 05:37 PM, Johannes Berg wrote:
> On Tue, 2011-04-26 at 17:33 +0530, Mohammed Shafi wrote:
>    
>> On Tuesday 26 April 2011 05:28 PM, Lito Kriara wrote:
>>      
>>> Hello,
>>> I was away the last couple of days and just saw these e-mails. It
>>> seems really interesting and helpful, but what if we need to know at
>>> runtime the number of stations connected to the AP?
>>> Is the first patch sent good to use? Should I do some modification to it?
>>>
>>>        
>> Yes this will be fine.
>>      
> Or you can use what I wrote without patching:
>    
Ok.
>    
>>>>> iw wlan0 station dump | grep '^Station ' | wc -l
>>>>>            
> FWIW, I wouldn't mind adding the num_sta to debugfs, but as we discussed
> in this thread it's a different number.
>    
sure, thanks.
> johannes
>
>    
