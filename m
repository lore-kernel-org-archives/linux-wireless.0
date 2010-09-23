Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:59859 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714Ab0IWNMb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Sep 2010 09:12:31 -0400
Message-ID: <4C9B5234.1060002@candelatech.com>
Date: Thu, 23 Sep 2010 06:12:20 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [mac80211] mac80211:  Support multiple VIFS per AP in debugfs.
References: <1285071310-11440-1-git-send-email-greearb@candelatech.com>	 <4C98DC5D.2000108@candelatech.com>	 <1285086618.12764.3.camel@jlt3.sipsolutions.net>	 <4C98E05B.8050609@candelatech.com>	 <1285088605.12764.5.camel@jlt3.sipsolutions.net>	 <1285091341.12764.7.camel@jlt3.sipsolutions.net>	 <4C9A35FD.8060201@candelatech.com>	 <1285174896.3684.71.camel@jlt3.sipsolutions.net>	 <4C9A3E1C.8070306@candelatech.com>	 <1285180265.3684.74.camel@jlt3.sipsolutions.net>	 <20100922184846.GI5515@tuxdriver.com>  <4C9A5CEB.9010708@candelatech.com> <1285230639.3691.1.camel@jlt3.sipsolutions.net>
In-Reply-To: <1285230639.3691.1.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/23/2010 01:30 AM, Johannes Berg wrote:
> On Wed, 2010-09-22 at 12:45 -0700, Ben Greear wrote:
>
>> This look better?
>>
>> diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
>> index e81ef4e..ebd5b69 100644
>> --- a/net/mac80211/debugfs.c
>> +++ b/net/mac80211/debugfs.c
>> @@ -368,7 +368,6 @@ void debugfs_hw_add(struct ieee80211_local *local)
>>           if (!phyd)
>>                   return;
>>
>> -       local->debugfs.stations = debugfs_create_dir("stations", phyd);
>>           local->debugfs.keys = debugfs_create_dir("keys", phyd);
>>
>>           DEBUGFS_ADD(frequency);
>
> Yeah, but completely whitespace damaged, you're going to have to work on
> your submissions :)
>
> Also, why do you do "[mac80211] mac80211" rather than "[PATCH]
> mac80211"?

That was just pasted into email..I'll fix up your other suggestions and
re-submit using git.  I'll see if I can get the email subject more correct
as well.

Thanks,
Ben

>
> johannes


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
