Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:54675 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab0IWN57 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Sep 2010 09:57:59 -0400
Message-ID: <4C9B5CE4.9040806@candelatech.com>
Date: Thu, 23 Sep 2010 06:57:56 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [mac80211] mac80211:  Support receiving data frames on multiple
 vifs.
References: <1285018776-21795-1-git-send-email-greearb@candelatech.com> <1285051641.3710.8.camel@jlt3.sipsolutions.net>
In-Reply-To: <1285051641.3710.8.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/20/2010 11:47 PM, Johannes Berg wrote:
> On Mon, 2010-09-20 at 14:39 -0700, greearb@candelatech.com wrote:
>> From: Ben Greear<greearb@candelatech.com>
>>
>> When using multiple STA interfaces on the same radio, some
>> data packets need to be received on all interfaces
>> (broadcast, for instance).
>>
>> Make the STA loop look similar to the mgt-data loop.
>>
>> Also, add logic to check RX_FLAG_MMIC_ERROR for last
>> interface in mgt-data loop.
>>
>> This needs review.
>
> Looks fine to me, I think.

Does this need any more work before being accepted upstream?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
