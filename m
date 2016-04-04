Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:36702 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143AbcDDMju (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Apr 2016 08:39:50 -0400
Date: Mon, 4 Apr 2016 14:39:44 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
To: Luciano Coelho <coelho@ti.com>, Felipe Balbi <balbi@ti.com>,
	kev@ti.com, Shahar Levi <shahar_levi@ti.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	"Andrew F. Davis" <afd@ti.com>, Guy Mishol <guym@ti.com>,
	Yaniv Machani <yanivma@ti.com>, Arik Nemtsov <arik@wizery.com>,
	Gery Kahn <geryk@ti.com>, Felipe Balbi <balbi@kernel.org>,
	Luciano Coelho <luca@coelho.fi>
Cc: David Woodhouse <dwmw2@infradead.org>, Pavel Machek <pavel@ucw.cz>,
	Aaro Koskinen <aaro.koskinen@iki.fi>,
	Ben Hutchings <ben@decadent.org.uk>,
	David Gnedt <david.gnedt@platinumzone24.at>,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	Sebastian Reichel <sre@kernel.org>,
	Tony Lindgren <tony@atomide.com>, Nishanth Menon <nm@ti.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: AP firmware for TI wl1251 wifi chip (wl1251-fw-ap.bin)
Message-ID: <20160404123944.GA8413@pali> (sfid-20160404_144014_033890_47F47AEC)
References: <201603200040.26045@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <201603200040.26045@pali>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 20 March 2016 00:40:25 Pali Rohár wrote:
> Hi!
> 
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
> 
> I see that STA firmware was added into linux-firmware tree in year 2013 
> by this pull request [2].
> 
> [1] - https://git.kernel.org/cgit/linux/kernel/git/firmware/linux-firmware.git/tree/ti-connectivity
> 
> [2] - http://thread.gmane.org/gmane.linux.kernel/1566500/focus=1571382
> 

Hi! Anybody has some idea about that AP firmware?

-- 
Pali Rohár
pali.rohar@gmail.com
