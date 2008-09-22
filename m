Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:56574 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbYIVLdy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Sep 2008 07:33:54 -0400
To: "Chr" <chunkeey@web.de>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: stlc45xx: mac80211 driver for N800 and N810
References: <877i98iw4h.fsf@nokia.com>
	<43e72e890809191055o4085fab1k8a85fe9266ae8aab@mail.gmail.com>
	<87wsh438r6.fsf@nokia.com> <200809221322.41239.chunkeey@web.de>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Mon, 22 Sep 2008 14:33:07 +0300
In-Reply-To: <200809221322.41239.chunkeey@web.de> (ext Chr's message of "Mon\, 22 Sep 2008 13\:22\:41 +0200")
Message-ID: <8763oo1klo.fsf@nokia.com> (sfid-20080922_133356_950345_8BB51163)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chr <chunkeey@web.de> writes:

> On Monday 22 September 2008 10:06:05 Kalle Valo wrote:
>> Luis R. Rodriguez <mcgrof@gmail.com> writes:
>> I don't have the p54 hardware (for regression testing) or the time to
>> add stlc45xx support to p54, and most probably there might be even
>> some legal implications which might prevent me of doing the work. So
>> somebody else would have to do the converge between p54 and stlc45xx.
>
> Hmm, don't worry... you won't break p54 hardware with these chances,

Heh, you don't know how good I'm breaking things ;)

> we did this before and I still could connect to my APs. Even better,
> Johannes wrote most of the code for "p54spi.c" already. I guess, we
> can reuse and fix his code, rather than reinventing the wheel once
> again. I'll take a look what can be done when I'm back next week.

Thanks.

> OT: Do you know if there's some way to get a card with a stlc45xx
> for or in a normal PC?

No idea. If you find a way, please tell me. stlc45xx supports both SPI
and SDIO buses, but N800/N810 use only SPI. So you would need some
kind of SPI bridge and solder the chip somehow with all the antennas
etc. Not an easy task.

-- 
Kalle Valo
