Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:44393 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751359AbZDSRPu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Apr 2009 13:15:50 -0400
Content-Type: text/plain; charset=iso-8859-1
Date: Sun, 19 Apr 2009 19:15:46 +0200
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <1240160041.28138.0.camel@johannes.local>
Message-ID: <20090419171546.158830@gmx.net> (sfid-20090419_191552_279073_CA045D96)
MIME-Version: 1.0
References: <1240094996.21583.1.camel@johannes.local>	
 (sfid-20090419_005015_625875_1781AFCD)
 <1240147370.898.0.camel@johannes.local>	 <20090419143337.158810@gmx.net>
 <20090419163204.158820@gmx.net>	 (sfid-20090419_183237_340935_6640098A)
 <1240160041.28138.0.camel@johannes.local>
Subject: Re: [RFC/RFT] cfg80211/nl80211: add IBSS API
To: linux-wireless@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I don't think so -- how would I express "use channel 5 if you can't f=
ind
> anything" in a single nl80211 command?

In the normal usage, you don't need it. Either you want make all settin=
gs fixed if you build a stationary node, or you set only the SSID if yo=
u join the IBSS temporary with your notebook. I don't see a real reason=
 to have an optimized one command solution for that. And on multi inter=
face wifis it's better set the channel and join the IBSS in two differe=
nt steps. The channel setting has site-effects on the other interfaces,=
 the IBSS joining mostly don't. (except TSF and so)

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
