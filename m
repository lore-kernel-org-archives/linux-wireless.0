Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:36996 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493AbcCULBR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Mar 2016 07:01:17 -0400
Date: Mon, 21 Mar 2016 12:01:13 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: kev@ti.com, "Andrew F. Davis" <afd@ti.com>,
	Guy Mishol <guym@ti.com>, Yaniv Machani <yanivma@ti.com>,
	Arik Nemtsov <arik@wizery.com>,
	Felipe Balbi <balbi@kernel.org>,
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
Message-ID: <20160321110113.GG8413@pali> (sfid-20160321_120123_055873_E62EA594)
References: <201603200040.26045@pali>
 <878u1cglu3.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <878u1cglu3.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 21 March 2016 12:35:32 Kalle Valo wrote:
> Pali Rohár <pali.rohar@gmail.com> writes:
> 
> > In linux-firmware repository [1] is missing AP firmware for TI wl1251 
> > chip. There is only STA firmware wl1251-fw.bin which supports managed 
> > and ad-hoc modes.
> >
> > For other TI wilink chips there are <CHIP>-ap.bin firmware files 
> > (wl1271-fw-ap.bin and wl128x-fw-ap.bin) which support AP mode. But for 
> > wl1251 firmware file with guessed name "wl1251-fw-ap.bin" is missing.
> >
> > Do you have any idea what happened with AP firmware for ti wilink4 
> > wl1251 wifi chip? Or where can be found? Guys from TI, can you help?
> 
> It's a long time ago but IIRC wl1251 has not ever supported AP mode and
> wl1271 was the first one to support it. But I might be wrong of course.

Support for AP mode in current kernel driver wl1251.ko is missing, but I
could try to write it if there will be firmware for it.

According to some TI whitepaper about TI wilink4 devices (wl1251 and
wl1253) those devices have support for some Soft-AP mode.

-- 
Pali Rohár
pali.rohar@gmail.com
