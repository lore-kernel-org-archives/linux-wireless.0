Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:40761 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbYIVLWz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Sep 2008 07:22:55 -0400
From: Chr <chunkeey@web.de>
To: Kalle Valo <kalle.valo@nokia.com>
Subject: Re: stlc45xx: mac80211 driver for N800 and N810
Date: Mon, 22 Sep 2008 13:22:41 +0200
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <877i98iw4h.fsf@nokia.com> <43e72e890809191055o4085fab1k8a85fe9266ae8aab@mail.gmail.com> <87wsh438r6.fsf@nokia.com>
In-Reply-To: <87wsh438r6.fsf@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809221322.41239.chunkeey@web.de> (sfid-20080922_132300_101575_A8203D13)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 22 September 2008 10:06:05 Kalle Valo wrote:
> Luis R. Rodriguez <mcgrof@gmail.com> writes:
> I don't have the p54 hardware (for regression testing) or the time to
> add stlc45xx support to p54, and most probably there might be even
> some legal implications which might prevent me of doing the work. So
> somebody else would have to do the converge between p54 and stlc45xx.
>
Hmm, don't worry... you won't break p54 hardware with these chances,
we did this before and I still could connect to my APs.
Even better, Johannes wrote most of the code for "p54spi.c" already.
I guess, we can reuse and fix his code, rather than reinventing the wheel once again.
I'll take a look what can be done when I'm back next week.

OT: Do you know if there's some way to get a card with a stlc45xx for or in a normal PC?

> > Is this driver targeted for inclusion upstream?
>
> I'm very interested in mac80211 and would like to see it suitable for
> embedded devices like N800/N810. The just announced stlc45xx driver
> would be a perfect tool for that kind of development and having the
> driver upstream would make development a lot easier.
>
> Features that I am interested in, just from the top of my head, are
> proper roaming support, power save mode and beacon filtering. In my
> opinion the biggest areas needing work are everything related to
> mobility or the power consumption.
Yes, this is definitely stuff that should go right into mac80211 stack and nowhere else.
Therefore FULL ACK.

Regards,
	Chr

