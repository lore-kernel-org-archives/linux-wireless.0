Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:60884 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754794AbZCPRdF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2009 13:33:05 -0400
Cc: linux-wireless@vger.kernel.org, feldmann_markus@gmx.de
Content-Type: text/plain; charset=iso-8859-1
Date: Mon, 16 Mar 2009 18:33:01 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <ee588a540903160948u6b5c758ay5addec857b3cf913@mail.gmail.com>
Message-ID: <20090316173301.92330@gmx.net> (sfid-20090316_183309_683489_8745B162)
MIME-Version: 1.0
References: <ee588a540903160324s59c83547jc7d2148642e00af4@mail.gmail.com>	
 <20090316155152.276920@gmx.net>
 <ee588a540903160948u6b5c758ay5addec857b3cf913@mail.gmail.com>
Subject: Re: well working usb wlan stick
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

> feldmann markus requested "well supported wlan stick". And they are
> missing in distribution kernels.
>=20
> ar9170(ZyDAS/Atheros) or rt2800usb(Ralink) should be fine, *when they
> hit mainline*

=46or my proposes this driver works better than the others. rt73usb cou=
ldn't transmit packages in IBSS until a short time ago and with zd1211r=
w I get a kernel panic when I remove the stick while the network is run=
ning.

Conclusion: There are no USB sticks that are really "well supported" at=
 the moment.

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
