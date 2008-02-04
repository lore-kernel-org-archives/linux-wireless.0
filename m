Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:40836 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016AbYBDTkA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2008 14:40:00 -0500
To: Sam Leffler <sam@errno.com>
Cc: Tomas Winkler <tomasw@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: Re: cfg80211 API changes
References: <1ba2fa240802030539h132c7365g1bc1c20b1c560c0@mail.gmail.com>
	<1ba2fa240802030555v28873634wceff4ecea67d3530@mail.gmail.com>
	<1202049444.4188.125.camel@johannes.berg>
	<1ba2fa240802030651x58ab6c63yd1b4d9ccaa2ecd42@mail.gmail.com>
	<87ve55b74j.fsf@nokia.com> <47A74923.8040201@errno.com>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Mon, 04 Feb 2008 20:20:22 +0200
In-Reply-To: <47A74923.8040201@errno.com> (ext Sam Leffler's message of "Mon\, 04 Feb 2008 09\:19\:31 -0800")
Message-ID: <87zlug4m8p.fsf@nokia.com> (sfid-20080204_194016_996203_F74BED5F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sam Leffler <sam@errno.com> writes:

>>> I see.  Rate scale algorithm only tels FW from what rate to start
>>> transmission. FW is responsible to do downscaling.  Which is quite
>>> reasonable as retransmission is real time process. Instead of
>>> retransmitting on the same rate FW downscales. T X response provides
>>> to the rate scaling algorithm the successful rate.
>>
>> I just want to point out this is an important feature when the bus is
>> very slow, for example SPI bus in embedded devices. Retransfering
>> frames through SPI for every rate restransmit would make such a device
>> extremely slow.
>
> I don't know of a part that does repeated DMA to implement retransmit;
> do you have an example?

Asking me? No, I have never heard of such a device.

-- 
Kalle Valo
