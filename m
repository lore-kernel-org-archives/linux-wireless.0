Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.compro.net ([12.186.155.4]:13234 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1424546Ab2LGVGU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2012 16:06:20 -0500
Message-ID: <50C25A4B.8030302@compro.net> (sfid-20121207_220624_484483_125B1035)
Date: Fri, 07 Dec 2012 16:06:19 -0500
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: dmarkh@cfl.rr.com, linux-wireless@vger.kernel.org
Subject: Re: Wireless network problem with Access Point selection using ifup
References: <50C0A743.3000305@compro.net>   (sfid-20121206_152423_356618_ADE5D3BC) <1354806200.18211.1.camel@jlt4.sipsolutions.net>  <50C1C103.1000803@cfl.rr.com> <50C256A9.7010008@compro.net> <1354913688.9124.2.camel@jlt4.sipsolutions.net>
In-Reply-To: <1354913688.9124.2.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/07/2012 03:54 PM, Johannes Berg wrote:

>
>> Thanks for responding. Do you think my problem is a wpa_supplicant
>> issue, a kernel issue, or a Dist issue?
>
> I'd say it's a wpa_s issue, but I can't remember any time that it didn't
> reconnect after getting disconnected, so maybe there's an issue with
> your driver/device that causes it to need a reset or something ... hard
> to tell more without at least the supplicant log.
>

I am wpa_supplicant stupid. I'll investigate and see if I can provide 
more info. I have 4 of these devices scattered about the house on Linux 
boxes. They all do the same thing. I also have 3 TV's and a windows 
laptop my wife uses that all connect properly to it's closest AP. As you 
can see this is a project to make the whole house wireless.

Also, personally I'm more concerned as to why the Linux boxes don't just 
pick the closest AP to begin with. If it did, and it actually has, it 
never disconnects and will be reliable until a reboot.

Thanks
Mark
