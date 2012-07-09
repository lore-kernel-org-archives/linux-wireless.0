Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:48559 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754949Ab2GIOu4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 10:50:56 -0400
Message-ID: <4FFAEFCB.2080109@candelatech.com> (sfid-20120709_165102_333720_59A4DC9E)
Date: Mon, 09 Jul 2012 07:50:51 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: use full power if off-channel
References: <1341740130-6199-1-git-send-email-johannes@sipsolutions.net>  <4FF99A80.9040700@candelatech.com> <1341822596.4455.6.camel@jlt3.sipsolutions.net>
In-Reply-To: <1341822596.4455.6.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/09/2012 01:29 AM, Johannes Berg wrote:
> On Sun, 2012-07-08 at 07:34 -0700, Ben Greear wrote:
>> On 07/08/2012 02:35 AM, Johannes Berg wrote:
>>> From: Johannes Berg <johannes.berg@intel.com>
>>>
>>> Instead of using full power when scanning, use
>>> full power when off-channel. This is different
>>> since off-channel can be remain-on-channel.
>>
>> What if we are scanning on our current channel?  Shouldn't
>> it be full-power then as well?
>
> Arguable. If we're on the channel that the AP explicitly told us to use
> less power on, and we're not stopping normal traffic, then I'm not sure
> we should.

Well, if you are scanning, you might be wanting to find other APs that
perhaps require full power to reach, so it seems to me it should scan
at full power...

Thanks,
Ben

>
> johannes
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


