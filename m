Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:43649 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab1BIRKS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 12:10:18 -0500
Message-ID: <4D52CA73.9070506@candelatech.com>
Date: Wed, 09 Feb 2011 09:10:11 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: implicit band switch or not
References: <op.vqmzowhl3ri7v4@arend-laptop> <4D52A328.3010009@candelatech.com> <op.vqm4rpz93ri7v4@arend-laptop>
In-Reply-To: <op.vqm4rpz93ri7v4@arend-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/09/2011 06:48 AM, Arend van Spriel wrote:
> Hi Ben,
>
> On Wed, 09 Feb 2011 15:22:32 +0100, Ben Greear <greearb@candelatech.com>
> wrote:
>
>>> Any suggestions? Are we have a race condition here?
>>
>> What kernel revision was this happening in? I just changed the
>> scanning logic
>> a bit in wireless-testing...I don't think I would have caused this,
>> but it's possible.
>>
>
> I am running 2.6.38-rc3 from the staging-next repository. Last commit on
> net/mac80211/ is 'eb3e554 mac80211: fix a crash in
> ieee80211_beacon_get_tim on change_interface'.

Looks like my change went in after that, so must be something
else...

Thanks,
Ben

>
>> Thanks,
>> Ben
>>
>>>
>>> Gr. AvS
>>
>>
>
> Gr. AvS


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

