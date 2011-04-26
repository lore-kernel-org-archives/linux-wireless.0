Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:42422 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848Ab1DZMDc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2011 08:03:32 -0400
Received: from mail.atheros.com ([10.234.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 26 Apr 2011 05:03:05 -0700
Message-ID: <4DB6B48D.6080508@atheros.com> (sfid-20110426_140343_898744_89BD23A5)
Date: Tue, 26 Apr 2011 17:33:25 +0530
From: Mohammed Shafi <mshajakhan@atheros.com>
MIME-Version: 1.0
To: Lito Kriara <L.Kriara@sms.ed.ac.uk>
CC: Mohammed Shajakhan <Mohammed.Shajakhan@Atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: Add num_stations connected in debugfs
References: <1303646133-2809-1-git-send-email-mshajakhan@atheros.com>	<1303652185.3603.0.camel@jlt3.sipsolutions.net>	<4DB4318F.6070801@atheros.com>	<1303657150.3603.1.camel@jlt3.sipsolutions.net>	<4DB4415F.2070707@atheros.com>	<1303659120.3603.3.camel@jlt3.sipsolutions.net>	<4DB4F8D5.1060108@atheros.com> <20110426125801.q89ma5n6cgkwog80@www.sms.ed.ac.uk>
In-Reply-To: <20110426125801.q89ma5n6cgkwog80@www.sms.ed.ac.uk>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 26 April 2011 05:28 PM, Lito Kriara wrote:
> Hello,
> I was away the last couple of days and just saw these e-mails. It
> seems really interesting and helpful, but what if we need to know at
> runtime the number of stations connected to the AP?
> Is the first patch sent good to use? Should I do some modification to it?
>    
Yes this will be fine.
> Thank you all very much,
> Lito
>
>
> Quoting Mohammed Shafi<mshajakhan@Atheros.com>  on Mon, 25 Apr 2011
> 10:00:13 +0530:
>
>    
>> On Sunday 24 April 2011 09:02 PM, Johannes Berg wrote:
>>      
>>> On Sun, 2011-04-24 at 20:57 +0530, Mohammed Shafi wrote:
>>>
>>>        
>>>> On Sunday 24 April 2011 08:29 PM, Johannes Berg wrote:
>>>>
>>>>          
>>>>> iw wlan0 station dump | grep ... | wc -l
>>>>>
>>>>>            
>>>> thanks, that  works! I need to divide by 11 :)
>>>>
>>>>          
>>> Heh, yes, but that might change and/or be HW dependent, hence grep. So
>>> if you do
>>>
>>> iw wlan0 station dump | grep '^Station ' | wc -l
>>>
>>> you won't need to divide and won't be HW dependent.
>>>
>>>        
>> Oh ok, thanks!
>> regards,
>> shafi
>>
>>      
>>> johannes
>>>
>>>
>>>        
>
>
>    
