Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41091 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbZCYM44 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2009 08:56:56 -0400
Subject: Re: [PATCH 2/2 v2] p54spi: fix p54spi_upload_firmware
From: Johannes Berg <johannes@sipsolutions.net>
To: Max Filippov <jcmvbkbc@gmail.com>
Cc: Christian Lamparter <chunkeey@web.de>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <73aaf0dd0903250550x37e6847x38be1f0dcc4b1bb3@mail.gmail.com> (sfid-20090325_135057_114254_83C2963E)
References: <1237959016-17311-1-git-send-email-jcmvbkbc@gmail.com>
	 <200903251221.38912.chunkeey@web.de>
	 <73aaf0dd0903250500g51494e04iab9382e23d44f695@mail.gmail.com>
	 <200903251345.01608.chunkeey@web.de>
	 <73aaf0dd0903250550x37e6847x38be1f0dcc4b1bb3@mail.gmail.com>
	 (sfid-20090325_135057_114254_83C2963E)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-QSTdc/KZ65S+n4mksYYm"
Date: Wed, 25 Mar 2009 13:56:21 +0100
Message-Id: <1237985781.4320.160.camel@johannes.local> (sfid-20090325_135701_203416_399DD997)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QSTdc/KZ65S+n4mksYYm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-03-25 at 15:50 +0300, Max Filippov wrote:

> > BTW: does p54spi really work now?
> I haven't tested your patch yet, but with the one that I sent it does
> work in IBSS mode.

Nice.

> My aim is to wind it up in mesh mode. This doesn't work, it cannot
> establish peer link.
> I'm going to investigate it. Does mesh mode work on conventional pci/usb =
p54?

There may or may not be beaconing problems -- try scanning at least on
the mesh interface.

johannes

--=-QSTdc/KZ65S+n4mksYYm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJyinyAAoJEKVg1VMiehFYNDwP/j2sYO2kN1uI/XfBU2cAI/Fu
iBkMXN/R1cobcnJOeNrVpAUkoCodMwzlQbTga6YUHYiUJ1V2550i+uCQaYScRXtX
Zl1hCBwrJ4WDt/paJv/1IRuyMQJMV3IbGngsxyDm7xxiPB2M2d+FNePP5TsoTGAE
WaUg1/kgnBZX3c1apLSlfu8aCLyl9cI0oPaXlnCTnzSYfmxb24Y/xi41yycimpiF
xj2qmjLJNUDTBI0t7rj7E0MT9W+qWmxsqiqI8z0Wk7GZIJXRD4q36eS1d/6vyW91
fQSpKGrVMrhUD/C9lOvZ6EvuDPW8vGQiLBh1KQF471EZGZ8dFVSpaTUb661XUeLN
fagTGgLuvvKO6Z7BOVzzr349NC34iA0OYEsP0NyGBoc5010YatAVI0Aqh6n87v29
V1dL50Tjq7STBXbvru1twv5lnsz4GO5UMOor8zHum2JKbYrXF1YUyzipBY/ROtem
irAnR+CnXDsWnJWHfkRhHP7Z0hdW96TwUoLZGfO6mfahoDXMldQsX3g8KqLFA4vy
EWJGtH+F6WOufDBn59EKmvhEe4IDHgBHE3f0SwSzMInWwJAPJgYWyvLB0mx4oudH
bDRLgr6WaLPXSi5jGHFJGxYe+UcbWPETPQlOX6pD9ZdF6d+VV5+n/blv8T5HmiUW
5MZR93n9XHxMzvYWZMc3
=Eduv
-----END PGP SIGNATURE-----

--=-QSTdc/KZ65S+n4mksYYm--

