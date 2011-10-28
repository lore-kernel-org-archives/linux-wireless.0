Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:54440 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836Ab1J1QZy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Oct 2011 12:25:54 -0400
Message-ID: <4EAAD78F.8000009@candelatech.com> (sfid-20111028_182557_290010_8F6CE5C3)
Date: Fri, 28 Oct 2011 09:25:51 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [wireless-next PATCH 2/5] wifi: Support disabling ht40.
References: <1319778680-11405-1-git-send-email-greearb@candelatech.com>  <1319778680-11405-2-git-send-email-greearb@candelatech.com>  (sfid-20111028_071139_530762_135DB41A) <1319789370.3914.11.camel@jlt3.sipsolutions.net>
In-Reply-To: <1319789370.3914.11.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/28/2011 01:09 AM, Johannes Berg wrote:
> On Thu, 2011-10-27 at 22:11 -0700, greearb@candelatech.com wrote:
>
>>   struct vif_params {
>>   	int use_4addr;
>>   	int disable_11n;
>> +	int disable_ht40;
>>   };
>
> All the comments on patch 1 apply -- per connection parameter,
> capability flag etc.
>
> I do wonder if it would be worthwhile to make it a u32 "connection
> flags" or so instead of defining them separately.

I don't care either way.  If you want a single variable to hold
the flags that is easy enough.  We'd need to pass in a mask to
allow user-space to change only a subset of flags at a time
though.

Thanks,
Ben

>
> johannes
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

