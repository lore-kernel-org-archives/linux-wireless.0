Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:18592 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbYITIRo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Sep 2008 04:17:44 -0400
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: Re: stlc45xx: mac80211 driver for N800 and N810
References: <877i98iw4h.fsf@nokia.com>
	<1221819119.10419.75.camel@johannes.berg>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Sat, 20 Sep 2008 11:16:51 +0300
In-Reply-To: <1221819119.10419.75.camel@johannes.berg> (ext Johannes Berg's message of "Fri\, 19 Sep 2008 12\:11\:59 +0200")
Message-ID: <87abe3mdu4.fsf@nokia.com> (sfid-20080920_101746_879158_6B776EF7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Fri, 2008-09-19 at 07:43 +0300, Kalle Valo wrote:
>> Hello all,
>> 
>> Nokia yesterday published stlc45xx, which is a mac80211 driver for
>> N800 and N810. Webpage here:
>> 
>> http://stlc45xx.garage.maemo.org/
>
> quick look at the code

Thanks a lot! I didn't send any code for review yet because, as you
noticed, the code is in early stages still. I will go through your
comments next week and fix them.

> Overall looks pretty good, I'm concerned that the binary helper is
> _required_, we had this with ipw3945 and it wasn't accepted. Any way to
> make it not required?

I guess I'll have to find a way. Maybe have very convervative default
values in the driver which the binary tool can update? That way the
driver would work without stlc45xx-cal (with the cost of worse
performance) and still our requirements would be fulfilled.

-- 
Kalle Valo
