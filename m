Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:56731 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756376Ab0I0P5U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 11:57:20 -0400
Message-ID: <4CA0BED9.3050601@candelatech.com>
Date: Mon, 27 Sep 2010 08:57:13 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: rebased version of wireless-testing?
References: <4C9CFD86.2080207@candelatech.com> <20100924200532.GH8077@tuxdriver.com> <4C9D14B6.70206@candelatech.com> <20100925134325.GD1948@tuxdriver.com> <4C9E1C5D.4020805@candelatech.com> <20100927150235.GB11086@tuxdriver.com>
In-Reply-To: <20100927150235.GB11086@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/27/2010 08:02 AM, John W. Linville wrote:
> On Sat, Sep 25, 2010 at 08:59:25AM -0700, Ben Greear wrote:
>> On 09/25/2010 06:43 AM, John W. Linville wrote:
>>> On Fri, Sep 24, 2010 at 02:14:30PM -0700, Ben Greear wrote:
>>>
>>>>> You will be better-off pulling wireless-next-2.6 (and maybe
>>>>> wireless-2.6 as well).  The history there isn't always immutable
>>>>> (although I prefer it to be), but it will tend to be a lot cleaner
>>>>> than wireless-testing.
>>>>
>>>> Any chance you could push tags in wireless-next-2.6?
>>>
>>> Not sure what you mean -- are you not seeing the master-<date>   tags?
>>
>> It didn't seem like the 2.6.36-rcX tags were there..but then again, maybe
>> I'm looking for something that doesn't exist?
>
> Ah...well, they probably won't be in there until after 2.6.36 is
> released.  I generally don't pull from Linus into that tree during
> the release cycle in order to avoid surprising Dave when he pulls it.
> But if you are basing on linux-2.6 then you should already have those
> tags anyway?

I was going to run some diffs in wt against 2.6.36-rc5 to try to figure out
the changes I needed to pull in.

A straight pull of wt into 2.6.36-rc5 didn't work well for me, and it
appeared a rebase was going to be even worse.

So, I'm going to try manually applying patches...after I make another
stab at getting the ath5k virtual AP/STA patch acceptable.

Thanks,
Ben

>
> John


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
