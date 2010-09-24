Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:36349 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755034Ab0IXVOe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Sep 2010 17:14:34 -0400
Message-ID: <4C9D14B6.70206@candelatech.com>
Date: Fri, 24 Sep 2010 14:14:30 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: rebased version of wireless-testing?
References: <4C9CFD86.2080207@candelatech.com> <20100924200532.GH8077@tuxdriver.com>
In-Reply-To: <20100924200532.GH8077@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/24/2010 01:05 PM, John W. Linville wrote:
> On Fri, Sep 24, 2010 at 12:35:34PM -0700, Ben Greear wrote:
>> Is there a rebased version of wireless-testing, or is there a way to
>> tell git to not apply any patch that was later reverted when pulling?
>>
>> I'd like to pull wireless-testing changes into a tree based on linux-2.6,
>> but I want it clean enough to easily see what changes I actually
>> pulled in.
>>
>> If not, I can manually pull in some patches as needed.
>
> Don't do that -- wireless-testing is and likely always will be a mess.
> It really only exists as a "-next lite" for those that only want
> bleeding-edge wireless while keeping-up with linux-2.6 release
> candidates.
>
> You will be better-off pulling wireless-next-2.6 (and maybe
> wireless-2.6 as well).  The history there isn't always immutable
> (although I prefer it to be), but it will tend to be a lot cleaner
> than wireless-testing.

Any chance you could push tags in wireless-next-2.6?

Thanks,
Ben

>
> John


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

