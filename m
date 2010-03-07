Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f220.google.com ([209.85.219.220]:62902 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab0CGRcx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Mar 2010 12:32:53 -0500
Received: by ewy20 with SMTP id 20so1224916ewy.1
        for <linux-wireless@vger.kernel.org>; Sun, 07 Mar 2010 09:32:52 -0800 (PST)
To: Andrey Yurovsky <yurovsky@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	David MOUSSAUD <d.moussaud@gmail.com>,
	Dan Williams <dcbw@redhat.com>,
	Holger Schurig <holgerschurig@gmail.com>,
	linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Holger Schurig <holgerschurig@googlemail.com>
Subject: Re: [PATCH] libertas: cfg80211 support
References: <20100202000934.GA19847@sortiz.org>
	<201002151146.48156.holgerschurig@gmail.com>
	<cdd918981002240005o1fa50956yfb2a692716c06a55@mail.gmail.com>
	<1267054502.6162.9.camel@localhost.localdomain>
	<cdd918981002250042m16cdf34ap8305ed2fbfd7804d@mail.gmail.com>
	<1267087684.3796.0.camel@jlt3.sipsolutions.net>
	<c1545bb51002251005o396130e9g906e5efff024c78@mail.gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sun, 07 Mar 2010 19:32:48 +0200
In-Reply-To: <c1545bb51002251005o396130e9g906e5efff024c78@mail.gmail.com> (Andrey Yurovsky's message of "Thu\, 25 Feb 2010 10\:05\:30 -0800")
Message-ID: <87d3zgdolb.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andrey Yurovsky <yurovsky@gmail.com> writes:

>>> Do you know an other sdio chipset that would do the job ?
>>
>> libertas_tf driver has AP iirc.
>
> Yes but it only supports one variant with USB (88w8388) and special
> firmware, there's no SDIO equivalent.
>
> The only soft-MAC/mac80211 hardware/driver that I can think of that
> has an SDIO variant right now is the TI wl12xx stuff but I don't know
> anything about it or whether it can do enough to support AP via
> mac80211.

wl1251 at least doesn't support AP mode. Maybe it's possible to hack
something in the driver, but because firmware doesn't support it it
would be incomplete anyway.

-- 
Kalle Valo
