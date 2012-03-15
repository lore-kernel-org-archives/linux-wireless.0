Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:36054 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919Ab2COSwn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 14:52:43 -0400
Message-ID: <4F623A78.4010909@candelatech.com> (sfid-20120315_195247_596415_39DA5B8C)
Date: Thu, 15 Mar 2012 11:52:40 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC 1/2] cfg80211:  Add framework to support ethtool stats.
References: <1331833159-12694-1-git-send-email-greearb@candelatech.com>  (sfid-20120315_183939_019754_FB9DFB9F) <1331837442.3432.35.camel@jlt3.sipsolutions.net>
In-Reply-To: <1331837442.3432.35.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/15/2012 11:50 AM, Johannes Berg wrote:
> On Thu, 2012-03-15 at 10:39 -0700, greearb@candelatech.com wrote:
>
>> --- a/net/mac80211/sta_info.h
>> +++ b/net/mac80211/sta_info.h
>> @@ -379,6 +379,8 @@ struct sta_info {
>>   	struct ieee80211_sta sta;
>>   };
>>
>> +#define NUM_STA_INFO_STATS 12
>> +
>
> That doesn't seem to belong into this patch?

Er, no..it does not.  I'll fix that.

Ben

>
> johannes


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

