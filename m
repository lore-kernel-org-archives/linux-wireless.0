Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:35490 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754647Ab2KZQj0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 11:39:26 -0500
Message-ID: <50B39B31.8040707@candelatech.com> (sfid-20121126_173929_748734_1DEAD84D)
Date: Mon, 26 Nov 2012 08:39:13 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: saravanad@posedge.com, linux-wireless@vger.kernel.org
Subject: Re: [RFC] mac80211: add debugfs file for current tx rate
References: <3cce329ee6381f0ab4dd4d86ea76c2da@posedge.com> <1353942595.2800.2.camel@jlt4.sipsolutions.net>
In-Reply-To: <1353942595.2800.2.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/26/2012 07:09 AM, Johannes Berg wrote:
> On Mon, 2012-11-26 at 05:22 -0800, saravanad@posedge.com wrote:
>> Add a debugfs file showing the current tx rate.
>> The information available in the rc_stats file
>> doesn't evidently provides us the current tx rate.
>> This patch adds the support for the same.
>
> I don't see any value in this, you can just do "iw station dump" to get
> the information.

Perhaps the missing bits could be added to the ethtool stats
logic...that is easily parsed on the command line and relatively
straight-forward to use programatically as well...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

