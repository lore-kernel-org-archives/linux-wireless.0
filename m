Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:42300 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab2EUQ1A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 May 2012 12:27:00 -0400
Message-ID: <4FBA6CD3.8020201@candelatech.com> (sfid-20120521_182706_022845_ABE9BD7B)
Date: Mon, 21 May 2012 09:26:59 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Eliad Peller <eliad@wizery.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: lockdep splat related to wifi regulatory in 3.3.6+
References: <4FB6D114.4050802@candelatech.com> <CAB3XZEem=2P36WgWXynoscemAhMrcgh0mKFocBbGhy8C-cJigQ@mail.gmail.com>
In-Reply-To: <CAB3XZEem=2P36WgWXynoscemAhMrcgh0mKFocBbGhy8C-cJigQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/19/2012 03:42 PM, Eliad Peller wrote:
> hi Ben,
>
> On Sat, May 19, 2012 at 1:45 AM, Ben Greear<greearb@candelatech.com>  wrote:
>> This appears to be this bug:
>>
>> https://bugzilla.redhat.com/show_bug.cgi?id=734519
>>
>> Test case was to create 40 (virtual) stations against an AP that can only
>> handle
>> 30, so the remaining 10 constantly try to re-associate, get DHCP if
>> they manage, etc....

Thanks, I will try your patch.

But, it has a fairly scary comment about race conditions.
Any idea why sort of symptoms I might see from this potential
race?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

