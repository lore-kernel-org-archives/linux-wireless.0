Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:55438 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830Ab2GJTUC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2012 15:20:02 -0400
Message-ID: <4FFC805B.909@candelatech.com> (sfid-20120710_212008_037467_0C4CC588)
Date: Tue, 10 Jul 2012 12:19:55 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Can one program see another's scan-results?
References: <4FFC7C4F.9020804@candelatech.com>  (sfid-20120710_210252_194820_A6A69A50) <1341947332.4475.32.camel@jlt3.sipsolutions.net>
In-Reply-To: <1341947332.4475.32.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/10/2012 12:08 PM, Johannes Berg wrote:
> On Tue, 2012-07-10 at 12:02 -0700, Ben Greear wrote:
>> Is there a way to open a netlink socket and have it receive
>> all scan results (even those requested by other applications)?
>
> What do you mean by scan results? The results themselves? No, they are a
> dump and unicast to one application. The fact that a scan finished? Yes,
> of course.

I'd like the results themselves..for instance, just piggyback on whatever
supplicant is already doing to get periodic updates, and of course I'd
end up requesting some scans myself from time to time if a user wanted
an immediate update.

I was hoping it could be something like just listening for network-device
and route updates like netlink already supports.

Since scanning is relatively slow and expensive, it seems like a good
idea to allow re-using the results...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com



