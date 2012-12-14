Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:55218 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756546Ab2LNTca (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Dec 2012 14:32:30 -0500
Message-ID: <50CB7EC9.7080003@candelatech.com> (sfid-20121214_203235_049846_36D0921A)
Date: Fri, 14 Dec 2012 11:32:25 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: RSSI threshold events?
References: <50CB66D5.6070900@candelatech.com>  (sfid-20121214_185024_393287_1E46F699) <1355512358.9571.11.camel@jlt4.sipsolutions.net>
In-Reply-To: <1355512358.9571.11.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/14/2012 11:12 AM, Johannes Berg wrote:
> On Fri, 2012-12-14 at 09:50 -0800, Ben Greear wrote:
>> I'm seeing lots of these events in the 3.7.0+ kernel (and in 3.5 as well).
>>
>> I *should* be connected to good APs that are only a few feet away.
>>
>> Either way, maybe we should report the threshold and actual value
>> that caused the event to make it easier to figure out what the
>> problem is?
>
> Are you saying you're seeing these events without even having configured
> them? They should only happen if you configured a CQM RSSI threshold
> (and hysteresis) so you should pretty much know what's going on?

I did not configure anything on purpose, at least...is this something
that would be configured through supplicant?

Thanks,
Ben
>
> johannes
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

