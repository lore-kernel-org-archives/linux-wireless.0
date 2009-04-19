Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:38023 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756323AbZDSOtG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Apr 2009 10:49:06 -0400
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=iso-8859-1
Date: Sun, 19 Apr 2009 16:49:03 +0200
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <1240151862.898.14.camel@johannes.local>
Message-ID: <20090419144903.158820@gmx.net> (sfid-20090419_164910_305220_3FBD5865)
MIME-Version: 1.0
References: <1240094996.21583.1.camel@johannes.local>	
 (sfid-20090419_005015_625875_1781AFCD)
 <1240147370.898.0.camel@johannes.local>	 <20090419142631.158790@gmx.net>	
 (sfid-20090419_162703_506410_10175D69)
 <1240151621.898.13.camel@johannes.local>	
 (sfid-20090419_163346_662878_5F0F1754) <1240151862.898.14.camel@johannes.local>
Subject: Re: [RFC/RFT] cfg80211/nl80211: add IBSS API
To: Johannes Berg <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Johannes!

> Ah, there's "iwconfig wlan0 channel auto" as an alias for this, I gue=
ss
> that's an acceptable way to do it.

Yes, if you want join/assoc to a network regardless of the channel. If =
the channel is set to a different value then auto you only join/assoc n=
etworks on the same channel.

Something is needed to implement it with cfg80211.

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
