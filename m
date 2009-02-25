Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:40705 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756415AbZBYWob (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2009 17:44:31 -0500
Content-Type: text/plain; charset=iso-8859-1
Date: Wed, 25 Feb 2009 23:44:28 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <d38edefd935f0aa5c8cca9aee1cf1d7b@localhost>
Message-ID: <20090225224428.289250@gmx.net> (sfid-20090225_234444_766012_F3C31EA5)
MIME-Version: 1.0
References: <20090225215631.289250@gmx.net>
 (sfid-20090225_225703_350502_23B11EFA)
 <d38edefd935f0aa5c8cca9aee1cf1d7b@localhost>
Subject: Re: [PATCH] mac80211: Implement commit in wireless extensions
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Johannes!

> I don't think that we should do this -- "completeness" for wext is a =
bad
> argument and for debugging you can also do the other things.
>=20
> > I not so familiar with nl80211 at the moment, so I want add it to
> nl80211
> > in a second patch.
>=20
> No, you won't. nl80211 shall not require such hacks.

I personally think something like a "reload button" could be useful for=
 a wireless interface.

The wext code can removed when the other wext code is removed and it is=
 not much code.

Regards
Alina

--=20
Computer Bild Tarifsieger! GMX FreeDSL - Telefonanschluss + DSL
f=FCr nur 17,95 =BF/mtl.!* http://dsl.gmx.de/?ac=3DOM.AD.PD003K11308T45=
69a
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
