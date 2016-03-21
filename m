Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41739 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925AbcCUKfm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Mar 2016 06:35:42 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Pali =?utf-8?Q?Roh=C3=A1r?= <pali.rohar@gmail.com>
Cc: Luciano Coelho <coelho@ti.com>, Felipe Balbi <balbi@ti.com>,
	kev@ti.com, Shahar Levi <shahar_levi@ti.com>,
	"Andrew F. Davis" <afd@ti.com>, Guy Mishol <guym@ti.com>,
	Yaniv Machani <yanivma@ti.com>, Arik Nemtsov <arik@wizery.com>,
	Gery Kahn <geryk@ti.com>, Felipe Balbi <balbi@kernel.org>,
	Luciano Coelho <luca@coelho.fi>,
	David Woodhouse <dwmw2@infradead.org>,
	Pavel Machek <pavel@ucw.cz>,
	Aaro Koskinen <aaro.koskinen@iki.fi>,
	Ben Hutchings <ben@decadent.org.uk>,
	David Gnedt <david.gnedt@platinumzone24.at>,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	Sebastian Reichel <sre@kernel.org>,
	Tony Lindgren <tony@atomide.com>, Nishanth Menon <nm@ti.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: AP firmware for TI wl1251 wifi chip (wl1251-fw-ap.bin)
References: <201603200040.26045@pali>
Date: Mon, 21 Mar 2016 12:35:32 +0200
In-Reply-To: <201603200040.26045@pali> ("Pali =?utf-8?Q?Roh=C3=A1r=22's?=
 message of "Sun, 20 Mar
	2016 00:40:25 +0100")
Message-ID: <878u1cglu3.fsf@kamboji.qca.qualcomm.com> (sfid-20160321_113611_597759_B1CECC67)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pali Rohár <pali.rohar@gmail.com> writes:

> In linux-firmware repository [1] is missing AP firmware for TI wl1251 
> chip. There is only STA firmware wl1251-fw.bin which supports managed 
> and ad-hoc modes.
>
> For other TI wilink chips there are <CHIP>-ap.bin firmware files 
> (wl1271-fw-ap.bin and wl128x-fw-ap.bin) which support AP mode. But for 
> wl1251 firmware file with guessed name "wl1251-fw-ap.bin" is missing.
>
> Do you have any idea what happened with AP firmware for ti wilink4 
> wl1251 wifi chip? Or where can be found? Guys from TI, can you help?

It's a long time ago but IIRC wl1251 has not ever supported AP mode and
wl1271 was the first one to support it. But I might be wrong of course.

-- 
Kalle Valo
