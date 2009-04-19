Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:53246 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758300AbZDSOlK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Apr 2009 10:41:10 -0400
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=iso-8859-1
Date: Sun, 19 Apr 2009 16:41:08 +0200
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <1240151561.898.12.camel@johannes.local>
Message-ID: <20090419144108.158790@gmx.net> (sfid-20090419_164113_792546_E9501C21)
MIME-Version: 1.0
References: <1240094996.21583.1.camel@johannes.local>	
 (sfid-20090419_005015_625875_1781AFCD)
 <1240147370.898.0.camel@johannes.local>	 <20090419142631.158790@gmx.net>
 (sfid-20090419_162703_506410_10175D69) <1240151561.898.12.camel@johannes.local>
Subject: Re: [RFC/RFT] cfg80211/nl80211: add IBSS API
To: Johannes Berg <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Johannes!

> That's not what I was referring to -- and wext doesn't actually allow
> what I'm referring to afaik.

You must budget it, when you want implement the old wext code clean wit=
h cfg80211.

> When you want to create an IBSS on channel 5, what do you do?
>=20
> I think you have to
> 	iwconfig wlan0 essid test
> 	iwconfig wlan0 channel 5
> 	iwconfig wlan0 ap off # clear fixed channel bit
>=20
> which is ... weird.

Why not make simply the following?

iwconfig wlan0 channel 5
iwconfig wlan0 essid test

Regards
Alina

--=20
Neu: GMX FreeDSL Komplettanschluss mit DSL 6.000 Flatrate + Telefonansc=
hluss f=FCr nur 17,95 Euro/mtl.!* http://dslspecial.gmx.de/freedsl-surf=
flat/?ac=3DOM.AD.PD003K11308T4569a
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
