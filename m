Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:47551 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751905AbZDSRpp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Apr 2009 13:45:45 -0400
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=iso-8859-1
Date: Sun, 19 Apr 2009 19:45:38 +0200
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <1240161550.28138.6.camel@johannes.local>
Message-ID: <20090419174538.140620@gmx.net> (sfid-20090419_194548_734575_0960F60E)
MIME-Version: 1.0
References: <1240094996.21583.1.camel@johannes.local>	
 (sfid-20090419_005015_625875_1781AFCD)
 <1240147370.898.0.camel@johannes.local>	 <20090419143337.158810@gmx.net>
 <20090419163204.158820@gmx.net>	 (sfid-20090419_183237_340935_6640098A)
 <1240160041.28138.0.camel@johannes.local>	 <20090419171546.158830@gmx.net>
 (sfid-20090419_191552_279073_CA045D96) <1240161550.28138.6.camel@johannes.local>
Subject: Re: [RFC/RFT] cfg80211/nl80211: add IBSS API
To: Johannes Berg <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Ahrg, can you stop sending mail to me and the list as two mails? If i=
t's
> a problem then just reply to the list -- although I prefer to be CC'e=
d.

Sorry, mannerism.

> It's not about optimisations, it's about correctness. If you don't se=
t
> all things at once you don't know what will happen since something el=
se
> might send commands too.

In the praxis you only don't need it, unlike the automatic and fixed ch=
annel config.

If you set a channel you want the IBSS on this this channel regardless =
if one already exist or not. If you don't, you never mind on the channe=
l, even if the IBSS don't exist.

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
