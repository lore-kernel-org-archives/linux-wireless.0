Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:33608 "EHLO
	mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbcDKLlX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Apr 2016 07:41:23 -0400
Date: Mon, 11 Apr 2016 13:41:18 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
To: Pavel Machek <pavel@denx.de>
Cc: "Machani, Yaniv" <yanivma@ti.com>, "Chalmers, Kevin" <kev@ti.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	"Davis, Andrew" <afd@ti.com>, "Mishol, Guy" <guym@ti.com>,
	Arik Nemtsov <arik@wizery.com>, Gery Kahn <geryk@ti.com>,
	Felipe Balbi <balbi@kernel.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Aaro Koskinen <aaro.koskinen@iki.fi>,
	Ben Hutchings <ben@decadent.org.uk>,
	David Gnedt <david.gnedt@davizone.at>,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	Sebastian Reichel <sre@kernel.org>,
	Tony Lindgren <tony@atomide.com>,
	"Menon, Nishanth" <nm@ti.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: AP firmware for TI wl1251 wifi chip (wl1251-fw-ap.bin)
Message-ID: <20160411114118.GT8413@pali> (sfid-20160411_134153_861795_8F006037)
References: <201603200040.26045@pali>
 <20160404123944.GA8413@pali>
 <AE1C82FB3D0EC64DB1F752C81CBD1101390F6305@DFRE01.ent.ti.com>
 <201604061412.43684@pali>
 <AE1C82FB3D0EC64DB1F752C81CBD1101390F685E@DFRE01.ent.ti.com>
 <20160410115141.GD30188@xo-6d-61-c0.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20160410115141.GD30188@xo-6d-61-c0.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 10 April 2016 13:51:41 Pavel Machek wrote:
> Is it "hardware can't do AP", "firmware can't do AP" or "current drivers 
> do not support AP"?

We know that current linux TI wl1251.ko driver does not support AP. And
I'm still do not know if "hardware can do AP" or not. Also I'm not sure...
maybe current firmware can be "forced" for implementing AP mode.

David Gnedt implemented packet injection for wl1251.ko via JOIN firmware
command. And he wrote me that aircrack utils contains one application
which implementing full AP station in userspace just via packet
injection radiotap (which is supported by wl1251).

So maybe using other firmware (filter) commands together with current
packet injection implementation could be possible to create AP mode
(usable for standard hostapd daemon)? Just thinking...

Anyway, other TI wilink devices have different firmware for AP mode...

-- 
Pali Rohár
pali.rohar@gmail.com
