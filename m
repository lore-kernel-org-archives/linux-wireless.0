Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:45554 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbYKAOYk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Nov 2008 10:24:40 -0400
To: "Jouni Malinen" <j@w1.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Allow AP mode to be enabled
References: <20081030175030.GD3923@jm.kir.nu> <878ws3ptrh.fsf@nokia.com>
	<20081101114754.GY3923@jm.kir.nu>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sat, 01 Nov 2008 16:23:50 +0200
In-Reply-To: <20081101114754.GY3923@jm.kir.nu> (ext Jouni Malinen's message of "Sat\, 1 Nov 2008 13\:47\:54 +0200")
Message-ID: <871vxvmsnd.fsf@nokia.com> (sfid-20081101_152446_095106_99C21E16)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jouni Malinen <j@w1.fi> writes:

> On Sat, Nov 01, 2008 at 01:31:30PM +0200, Kalle Valo wrote:
>
>> I tried to test this with latest hostapd (commit b6a55236) and
>> wireless-testing (commit d80fe0040), but unfortunately I wasn't
>> succesful. Here's the output from hostapd with b43:
>
>> ioctl[SIOCSIWESSID]: Operation not supported
>> len=4
>> Could not set SSID for kernel driver
>
> Thanks for reporting this. I fixed it now in hostap.git. Johannes
> removed SSID configuration from AP mode and I was just waiting for this
> to hit wireless-testing before committing the change into hostapd.

Thanks a lot, I updated to hostap commit 4aac554c and it works now
with b43. I was able to associate with N810 and ping worked. Even PSM
seems to work, but I haven't made any power consumption measurements
yet.

I'm very happy now, thank you Johannes and Jouni! :D

-- 
Kalle Valo
