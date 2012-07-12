Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:8961 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932560Ab2GLPdP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2012 11:33:15 -0400
Message-ID: <4FFEEE2F.9040104@qca.qualcomm.com> (sfid-20120712_173325_641998_2FF9F1B7)
Date: Thu, 12 Jul 2012 21:03:03 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] nl80211: Avoid checking for empty WoWLAN triggers
References: <1341914875-14647-1-git-send-email-mohammed@qca.qualcomm.com>    <1341918365.4475.9.camel@jlt3.sipsolutions.net>    <4FFC0F22.6040906@qca.qualcomm.com>   <1341919201.4475.11.camel@jlt3.sipsolutions.net>   <4FFD1014.2000109@qca.qualcomm.com>  <1342103072.4531.26.camel@jlt3.sipsolutions.net>  <4FFEE9ED.6020906@qca.qualcomm.com> <1342106232.4531.31.camel@jlt3.sipsolutions.net>
In-Reply-To: <1342106232.4531.31.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 12 July 2012 08:47 PM, Johannes Berg wrote:
> Hi,
>
>>> Maybe something like this would make sense then?
>>>
>>> http://p.sipsolutions.net/2aac79bcfe3a9b8b.txt
>>
>> yeah this was the thing i am proposing
>> http://www.spinics.net/lists/linux-wireless/msg94023.html
>>
>> your patch is better optimized as it avoids a bool variable to check for
>> wow disable command, so this should be fine with the other iw
>> patch to check for empty triggers ?
>> http://www.spinics.net/lists/linux-wireless/msg94022.html
>
> Well, my patch is different, it actually allows empty triggers to go
> through as I had explained.

oops, sorry i misread it.

>
> I'm just not sure which one makes more sense? I kinda feel that allowing
> empty triggers might be a corner case but useful, while disallowing it
> now would make it hard to ever support such a case?

i am fine with your approach itself and don't want to break that use case.


>
> johannes
>


-- 
thanks,
shafi


