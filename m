Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:47368 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbYKAOvM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Nov 2008 10:51:12 -0400
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jouni Malinen <j@w1.fi>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Allow AP mode to be enabled
References: <20081030175030.GD3923@jm.kir.nu> <878ws3ptrh.fsf@nokia.com>
	<20081101114754.GY3923@jm.kir.nu> <871vxvmsnd.fsf@nokia.com>
	<1225549954.3619.4.camel@johannes.berg>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sat, 01 Nov 2008 16:51:04 +0200
In-Reply-To: <1225549954.3619.4.camel@johannes.berg> (Johannes Berg's message of "Sat\, 01 Nov 2008 15\:32\:34 +0100")
Message-ID: <87vdv7wld3.fsf@litku.valot.fi> (sfid-20081101_155147_815545_D26F1DF4)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

>> Thanks a lot, I updated to hostap commit 4aac554c and it works now
>> with b43. I was able to associate with N810 and ping worked. Even PSM
>> seems to work, but I haven't made any power consumption measurements
>> yet.
>
> I'd be interested in power consumption measurements, but it should work
> fine.

I did some quick measurements with N810 and, like you mentioned,
hostapd/mac80211/b43 combination seems to work just fine. Tried with
DTIM 1 and 10 with beacon period of 100 ms and power consumption of
N810 is just like what I was expecting.

I have seen a lot of APs with buggy PSM implementation and this setup
isn't one of them :)

> There might be a slight bug in b43 wrt. the beacon timestamp offset
> though.

If there's a bug in b43 I cannot see it from my measurements. Usually
I have seen any problems with the TBTT right away.

-- 
Kalle Valo
