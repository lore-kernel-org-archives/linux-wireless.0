Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:39636 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755722AbZAXVxY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2009 16:53:24 -0500
Content-Type: text/plain; charset=iso-8859-1
Date: Sat, 24 Jan 2009 22:53:22 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <1232807356.2870.23.camel@localhost.localdomain>
Message-ID: <20090124215322.259390@gmx.net> (sfid-20090124_225343_013775_138C8E23)
MIME-Version: 1.0
References: <20090124081542.50450@gmx.net>	
 (sfid-20090124_091614_136619_417AC6BC)
 <1232806972.4036.10.camel@johannes.local>
 <1232807356.2870.23.camel@localhost.localdomain>
Subject: Re: [PATCH] ath9k: Set TSF fix
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hallo Dan!

> > Why don't you back that claim by something more substantial?
>=20
> Yeah, at *least* which hardware likes it better,

The old version I have taken from an several years old madwifi patch. I=
t works only with old ath5k hardware. With my new Atheros-Cards the low=
er 32 bits of the TSF are only set to zero, not set to the new value. T=
he new code does work with all my ath5k and ath9k cards.

> and some regression
> testing to ensure that other hardware doesn't break with the change.

This does break nothing, because it's only debugging code, which I have=
 submitted a few day ago, and is not used for any other things.

By the way the TSF in ath5k is completely broken. I'm looking with this=
 patch for the reasons...

Regards
Alina

--=20
Psssst! Schon vom neuen GMX MultiMessenger geh=F6rt? Der kann`s mit all=
en: http://www.gmx.net/de/go/multimessenger

--=20
NUR NOCH BIS 31.01.! GMX FreeDSL - Telefonanschluss + DSL=20
f=FCr nur 16,37 EURO/mtl.!* http://dsl.gmx.de/?ac=3DOM.AD.PD003K11308T4=
569a
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
