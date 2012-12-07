Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.compro.net ([12.186.155.4]:17588 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1424112Ab2LGUuu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2012 15:50:50 -0500
Message-ID: <50C256A9.7010008@compro.net> (sfid-20121207_215053_597936_F1FCCAF5)
Date: Fri, 07 Dec 2012 15:50:49 -0500
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: dmarkh@cfl.rr.com, linux-wireless@vger.kernel.org
Subject: Re: Wireless network problem with Access Point selection using ifup
References: <50C0A743.3000305@compro.net>  (sfid-20121206_152423_356618_ADE5D3BC) <1354806200.18211.1.camel@jlt4.sipsolutions.net> <50C1C103.1000803@cfl.rr.com>
In-Reply-To: <50C1C103.1000803@cfl.rr.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/07/2012 05:12 AM, Mark Hounschell wrote:
> On 12/06/2012 10:03 AM, Johannes Berg wrote:
>> On Thu, 2012-12-06 at 09:10 -0500, Mark Hounschell wrote:
>>>   I'm using
>>> traditional ifup with static configurations.
>>
>> You should at least run wpa_supplicant, which will pick a better network
>> and reconnect if the connection drops etc. Almost no device does that by
>> itself any more.
>
>   wpa_supplicant is running.
>
> #ps ax | grep wpa
>
> wpa_supplicant -iwlan0 -c/var/run/wpa_supplicant-wlan0.conf
> -Dnl80211,wext -P/var/run/wpa_supplicant/wlan0.pid -B
>
>
> When the router in the middle of the house is chosen, as opposed to the
> range extender in the very same room, the network works for a time but
> eventually disassociates, usually reason 7, and never reconnects to
> anything.
>

Hi Johannes,

Thanks for responding. Do you think my problem is a wpa_supplicant 
issue, a kernel issue, or a Dist issue?

Regards
Mark
