Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:62667 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753545Ab0KHJQU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Nov 2010 04:16:20 -0500
Subject: Re: [PATCH v4] wl1271: Change wl12xx Files Names
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Kalle Valo <kvalo@adurom.com>
Cc: ext =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>,
	ext Grazvydas Ignotas <notasas@gmail.com>,
	Shahar Levi <shahar_levi@ti.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <87oca1zbt0.fsf@purkki.adurom.net>
References: <1288883257-30060-1-git-send-email-shahar_levi@ti.com>
	 <AANLkTincpxdpmf5J38LiGsF-d9dG7sG9-bjbkH-B8Ld0@mail.gmail.com>
	 <1288891196.17643.6.camel@powerslave>
	 <AANLkTi=Luv2+5Hys2PcrH+G8jmc4vwz8PM0LFKm+fTt8@mail.gmail.com>
	 <1288907555.17643.14.camel@powerslave>  <87oca1zbt0.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Nov 2010 11:16:08 +0200
Message-ID: <1289207768.8423.15.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2010-11-07 at 11:07 +0100, ext Kalle Valo wrote:
> Luciano Coelho <luciano.coelho@nokia.com> writes:
> 
> >> What about wl1251 vs. wl12agn (or wl12bgn if no .11a support), like iwlwifi?
> >
> > Hmmm... wl1251 supports bg.  wl12xx supports abgn.  I don't really see
> > the logic in this? What difference does it make comparing to calling it
> > wl12xx? From wl12agn the user still doesn't know whether wl1251 is
> > supported or not.
> 
> Just to confuse even more: TI wl1253 (the chip) supports 11a and it
> would be easy to add wl1253 (the chip) support to wl1251 (the driver).
> I just haven't seen any linux devices using wl1253 yet.

Oh, I didn't even know that wl1253 even existed. :) But yeah, it
complicates things even more indeed.


-- 
Cheers,
Luca.

