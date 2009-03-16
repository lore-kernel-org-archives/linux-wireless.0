Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:32970 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752768AbZCPQhe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2009 12:37:34 -0400
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=iso-8859-1
Date: Mon, 16 Mar 2009 17:37:31 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <43e72e890903160918p75c8ee5cja0ff4a308d24c407@mail.gmail.com>
Message-ID: <20090316163731.206110@gmx.net> (sfid-20090316_173740_510636_065CE67D)
MIME-Version: 1.0
References: <ee588a540903160324s59c83547jc7d2148642e00af4@mail.gmail.com>	
 <20090316155152.276920@gmx.net>
 <43e72e890903160918p75c8ee5cja0ff4a308d24c407@mail.gmail.com>
Subject: Re: well working usb wlan stick
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luis!

> 11n does work but currently only in the the otus driver, which is als=
o
> open but it just doesn't use mac80211. ar9170 is the driver which wil=
l
> eventually get merged.

Yes, but the otus driver is currently less stable then the ar9170 drive=
r. After my patches I haven't discovered a kernel panic anymore with it=
=2E

[STA, IBSS, not AP - max. ca. 2,4 MByte/s]

Regards
Alina

--=20
Neu: GMX FreeDSL Komplettanschluss mit DSL 6.000 Flatrate + Telefonansc=
hluss f=FCr nur 17,95 Euro/mtl.!* http://dsl.gmx.de/?ac=3DOM.AD.PD003K1=
1308T4569a
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
