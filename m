Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:60496 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628Ab1FBTPR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2011 15:15:17 -0400
Message-ID: <4DE7E13D.60701@candelatech.com> (sfid-20110602_211531_225604_92EA2C9C)
Date: Thu, 02 Jun 2011 12:15:09 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] wireless: Support can-scan-one logic.
References: <1305586296-23147-1-git-send-email-greearb@candelatech.com> <1305759738.8827.6.camel@jlt3.sipsolutions.net> <4DD4569C.7080303@candelatech.com> <BANLkTinozbG2SfOCRd1U__8-Pz9-8HCkPQ@mail.gmail.com>
In-Reply-To: <BANLkTinozbG2SfOCRd1U__8-Pz9-8HCkPQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/02/2011 12:12 PM, Luis R. Rodriguez wrote:
> On Wed, May 18, 2011 at 4:30 PM, Ben Greear<greearb@candelatech.com>  wrote:
>> On 05/18/2011 04:02 PM, Johannes Berg wrote:
>>>
>>> On Mon, 2011-05-16 at 15:51 -0700, greearb@candelatech.com wrote:
>>>>
>>>> From: Ben Greear<greearb@candelatech.com>
>>>>
>>>> Enable this by passing a -1 for a scan frequency.
>>>
>>> I still don't think we should do that, especially not with -1. That's
>>> totally non-netlink like inband signalling. I'll also reply to your
>>> other mail though since I don't think it makes sense to have this sort
>>> of convenience function in the kernel.
>>
>> It's virtually impossible (as far as I can tell) to carry an
>> out-of-tree netlink patch that uses a new netlink message
>> and still keep things backwards-compat when someone adds a
>> new message to the upstream kernel.  So, the -1 hack works
>> well for me.
>>
>> If it were to go into the kernel proper, then we could
>> add a proper flag to the netlink API and start using
>> that.
>>
>> If you just don't like the feature, thats OK...it is a pretty
>> specialized feature, and easy enough to carry in my own tree.
>
> Since this shit was merged can you add a respective documentation
> extension for the command for nl80211.h?

You un-merged it almost immediately, as far as I can tell.

What tree is it merged in?

Thanks,
Ben

>
>    Luis


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

