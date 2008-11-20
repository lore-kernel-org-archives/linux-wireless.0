Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59804 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949AbYKTRxY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2008 12:53:24 -0500
Subject: Re: [PATCH ] zd1211rw: enable master mode. (wireless-testing)
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Rami Rosen <ramirose@gmail.com>,
	linux-wireless@vger.kernel.org, kune@deine-taler.de
In-Reply-To: <20081120082750.GG5078@jm.kir.nu>
References: <eb3ff54b0811170751p56544c8fic38d046a868f3bb8@mail.gmail.com>
	 <1226943608.3902.36.camel@johannes.berg>
	 <eb3ff54b0811190559g39c2176h86bd9fb1956d6730@mail.gmail.com>
	 <1227106146.26243.43.camel@johannes.berg>
	 <eb3ff54b0811190709q76e8b073ic71831fd38ceba18@mail.gmail.com>
	 <1227107869.26243.52.camel@johannes.berg>
	 <20081119160135.GB3485@tuxdriver.com>
	 <1227126620.26243.71.camel@johannes.berg> <20081120082750.GG5078@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-84cvlquOhZxdYqMiKzpr"
Date: Thu, 20 Nov 2008 18:52:45 +0100
Message-Id: <1227203565.3766.18.camel@johannes.berg> (sfid-20081120_185328_261812_A91FABD4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-84cvlquOhZxdYqMiKzpr
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-11-20 at 10:27 +0200, Jouni Malinen wrote:

> I would be fine adding such a warning into hostapd if someone comes up
> with the patch and mac80211/nl80211 changes to provide the
> working-PS-mode capability flag.

Alright. I don't particularly care, so I'm not going to do that ;)

> Is the problem with zd1211rw just in PS buffering of multicast/broadcast
> frames or does it also have problems with unicast? Many use cases could
> handle the multicast/broadcast case, but if unicast PS buffering does
> not work properly, there may be more issues.. Anyway, this leaves a
> nasty surprise for the end user who may not even realize what power
> saving really means in context of 802.11 and would not have any way of
> figuring out why the connection does not work suddenly when the STA goes
> to power save mode.

unicast buffering should be doable well in software though, no?

johannes

--=-84cvlquOhZxdYqMiKzpr
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJJaPpAAoJEKVg1VMiehFYr+MP/2TCoCOx79Hx802GZD1GQzJj
+8C+TimKqXcvNa94EvGhy5Ci7vSJzJ1DrcGm8nXyAh2hozYW5Yh8L5eOvRbFXG6E
1fMeCCTmuajfGLUeYuY7canp9f9/AQtKGVZn9cbPa3wPONhTVXKGeclnXVHHksjj
OPaS1bGc9x6uXCAWmbbmCFHiX2Q70ma0rALCryFEp7NkUp1upXiIGqRSbgSUoXRN
ckVTMndsH7yCnA5E9CbtvVP53YKLo1gsLdLWm31Fuqbqk4EYxEJyD+PzPhYP8rNV
I4MF+iEc8ZBDvhTdOVsGRBA8mcxeWdFZQzpGZ7WgLymFj82H8ax7JRdAUIYsgIL4
3evFWf+WLTxKGq3l1e3HEMl502DMOTcux+A1MHRd8f4OMquilOTntp3bfDLREG74
Af5HTNESfzz7sh6b/Gk5dEDWhOq1oa6vPs+Hc5ZISkxDrCQpHlWNrmIQbcXkwYMJ
hqp6H99MofzklgkMFyus5R4C2Y0icKyClvy/guja1ZZ9zAM74eCifEyABJHZwvWw
56vvo5jZzWDadNyvnNoY+bin9FtCQMgf64yJEvV7UMMfZ5IgPtTBxDUMNzVOuQ6F
HePOF2nsIl7vcqRQIk/X6fmRtCehJgDnMvdghgYAXNkJr8OYiVgBkr1BkAxW4yJt
FEla59AUAo058j/C5yQ8
=N4dS
-----END PGP SIGNATURE-----

--=-84cvlquOhZxdYqMiKzpr--

