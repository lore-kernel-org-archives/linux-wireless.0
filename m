Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:42044 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755556Ab0IYP7c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Sep 2010 11:59:32 -0400
Message-ID: <4C9E1C5D.4020805@candelatech.com>
Date: Sat, 25 Sep 2010 08:59:25 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: rebased version of wireless-testing?
References: <4C9CFD86.2080207@candelatech.com> <20100924200532.GH8077@tuxdriver.com> <4C9D14B6.70206@candelatech.com> <20100925134325.GD1948@tuxdriver.com>
In-Reply-To: <20100925134325.GD1948@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/25/2010 06:43 AM, John W. Linville wrote:
> On Fri, Sep 24, 2010 at 02:14:30PM -0700, Ben Greear wrote:
>
>>> You will be better-off pulling wireless-next-2.6 (and maybe
>>> wireless-2.6 as well).  The history there isn't always immutable
>>> (although I prefer it to be), but it will tend to be a lot cleaner
>>> than wireless-testing.
>>
>> Any chance you could push tags in wireless-next-2.6?
>
> Not sure what you mean -- are you not seeing the master-<date>  tags?

It didn't seem like the 2.6.36-rcX tags were there..but then again, maybe
I'm looking for something that doesn't exist?

Basically, my goal is to pull in most or all of the changes from wireless-testing
into a tree based on Linus's tree (2.6.36-rc5 currently).  But, I need to keep
my tree clean enough to deal with rebasing and following Linus's tree because I have
a bunch of my own patches to add as well.

If nothing else, I'll manually pull the virtual-wifi patches that I need out of wireless-testing
and apply them to my tree.

Thanks,
Ben

>
> John


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
