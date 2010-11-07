Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:48419 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228Ab0KGKH6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Nov 2010 05:07:58 -0500
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: ext =?utf-8?Q?G=C3=A1bor?= Stefanik <netrolller.3d@gmail.com>,
	ext Grazvydas Ignotas <notasas@gmail.com>,
	Shahar Levi <shahar_levi@ti.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v4] wl1271: Change wl12xx Files Names
References: <1288883257-30060-1-git-send-email-shahar_levi@ti.com>
	<AANLkTincpxdpmf5J38LiGsF-d9dG7sG9-bjbkH-B8Ld0@mail.gmail.com>
	<1288891196.17643.6.camel@powerslave>
	<AANLkTi=Luv2+5Hys2PcrH+G8jmc4vwz8PM0LFKm+fTt8@mail.gmail.com>
	<1288907555.17643.14.camel@powerslave>
From: Kalle Valo <kvalo@adurom.com>
Date: Sun, 07 Nov 2010 12:07:55 +0200
In-Reply-To: <1288907555.17643.14.camel@powerslave> (Luciano Coelho's message of "Thu\, 04 Nov 2010 23\:52\:35 +0200")
Message-ID: <87oca1zbt0.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luciano Coelho <luciano.coelho@nokia.com> writes:

>> What about wl1251 vs. wl12agn (or wl12bgn if no .11a support), like iwlwifi?
>
> Hmmm... wl1251 supports bg.  wl12xx supports abgn.  I don't really see
> the logic in this? What difference does it make comparing to calling it
> wl12xx? From wl12agn the user still doesn't know whether wl1251 is
> supported or not.

Just to confuse even more: TI wl1253 (the chip) supports 11a and it
would be easy to add wl1253 (the chip) support to wl1251 (the driver).
I just haven't seen any linux devices using wl1253 yet.

I agree with Luca, name wl12agn would not help.

-- 
Kalle Valo
