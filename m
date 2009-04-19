Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:57806 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753462AbZDSQcI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Apr 2009 12:32:08 -0400
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=iso-8859-1
Date: Sun, 19 Apr 2009 18:32:04 +0200
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <20090419143337.158810@gmx.net>
Message-ID: <20090419163204.158820@gmx.net> (sfid-20090419_183212_246067_0771E669)
MIME-Version: 1.0
References: <1240094996.21583.1.camel@johannes.local>	
 (sfid-20090419_005015_625875_1781AFCD)
 <1240147370.898.0.camel@johannes.local> <20090419143337.158810@gmx.net>
Subject: Re: [RFC/RFT] cfg80211/nl80211: add IBSS API
To: Johannes Berg <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> In cfg80211 an indication for channel auto select is needed for IBSS =
and
> _STA_ mode, to implement with it the old wext interface. If not set t=
he
> channel shouldn't be changed. If you not want store this flag in cfg8=
0211, you
> must store it in the channel functions of wext to have the same behav=
ior
> like now.

I looked in the Source:

> @chan: The channel to use or %NULL if not specified
> (auto-select based on scan results)

I think this is enough for this purpose.

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
