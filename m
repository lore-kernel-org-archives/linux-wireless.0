Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:36669 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751056AbZAZOBd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2009 09:01:33 -0500
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=iso-8859-1
Date: Mon, 26 Jan 2009 15:01:30 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <b6c5339f0901250847i5f9f98bcl4ebec04027d7c93c@mail.gmail.com>
Message-ID: <20090126140130.14450@gmx.net> (sfid-20090126_150137_980049_0FE129DE)
MIME-Version: 1.0
References: <20090124081223.50440@gmx.net>	
 <b6c5339f0901250841r22635bd7q40532891293a6744@mail.gmail.com>	
 <1232901917.3837.0.camel@johannes.local>
 <b6c5339f0901250847i5f9f98bcl4ebec04027d7c93c@mail.gmail.com>
Subject: Re: [PATCH] ath5k: Set TSF fix
To: Bob Copeland <bcopeland@gmail.com>, johannes@sipsolutions.net
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

> > Either way, I think the changelog should back up the claim by
> > _something_. Even if it's just "tested on device XXX, old way doesn=
't
> > work, new way does" or "looked at legacy HAL code" or ...
>=20
> Agreed, "tested on..." would be good.  I looked at the HAL and it
> doesn't have a set tsf function, only reset.

The old code does not work on:
AR5418+AR2122 (ath9k)
AR5416+AR2133 (ath9k)

The new code is tested on:
AR5418+AR2122 (ath9k)
AR5416+AR2133 (ath9k)
AR5001X+ (ath5k)
AR5007EG (ath5k)

The old code was taken from:
https://dev.openwrt.org/browser/trunk/package/madwifi/patches/383-ibss_=
hostap.patch
(by Sven-Ola Tuecke)

Regards
Alina

--=20
NUR NOCH BIS 31.01.! GMX FreeDSL - Telefonanschluss + DSL=20
f=FCr nur 16,37 EURO/mtl.!* http://dsl.gmx.de/?ac=3DOM.AD.PD003K11308T4=
569a
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
