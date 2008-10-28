Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36537 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbYJ1XPe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2008 19:15:34 -0400
Subject: Re: 2.6.28-rc regression: Can't stop Rx DMA
From: Johannes Berg <johannes@sipsolutions.net>
To: reinette chatre <reinette.chatre@intel.com>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1225225434.1115.217.camel@rc-desk> (sfid-20081028_212343_098446_12401F4B)
References: <20081018231046.GA10977@isilmar.linta.de>
	 <1ba2fa240810181630t781468dbi23b103e656f64153@mail.gmail.com>
	 <20081019075916.GA12904@isilmar.linta.de>
	 <1225145468.1115.139.camel@rc-desk>
	 <20081027230326.GA23250@isilmar.linta.de>
	 <1225154823.1115.149.camel@rc-desk>
	 <20081028194323.GA14303@isilmar.linta.de>
	 <1225225434.1115.217.camel@rc-desk> (sfid-20081028_212343_098446_12401F4B)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-7NY/aK1cTUxaA63vKii1"
Date: Wed, 29 Oct 2008 00:15:31 +0100
Message-Id: <1225235731.1369.8.camel@johannes.berg> (sfid-20081029_001538_795100_9A7867CB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-7NY/aK1cTUxaA63vKii1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-10-28 at 13:23 -0700, reinette chatre wrote:

> (adding linux-wireless so I am keeping the log below)
>=20
> This helps a lot - thanks!
>=20
> Could you please recompile wireless with CONFIG_WIRELESS_OLD_REGULATORY?

Btw, any idea why this helps? Shouldn't the driver just work, albeit
with a restricted channel set? Are we messing something up like no
usable channels at all? (I fixed a bug like that IIRC)

johannes

--=-7NY/aK1cTUxaA63vKii1
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJB50PAAoJEKVg1VMiehFY7uQQAMRUq5myQeLOTkfzW9/868UG
eebn2+0miMQswgEyF2GDkxd5ewIzuFhUjAuON30GPCPrCozGFQtJho7tX9cYeG1T
wYLkGwvbNmSPucsB1KX2pr5WsiClyLxwmn/ozef9woWO7BblCul7pGZwsHvVkcI/
qZwsGnvSaLWVqfdlitJAMiIkKqKaZw1J5Zq6AVrMUCn5FY2ZbklgNHkmuV3Q3089
UFnecpm+l9HxtnxcmN/I5VahSjEd2dd4LoDQAJKKIb0MV8Gk1A9/AV+gjZ/qAeOB
tX5T5HRCkwWFD4CG5MUs/dMjUp2xyY1+0ddDmvwOE8S48TNq2wSSEqKLh0bMROaM
EIWhMYjit5dXmQIoIUy36l3uD2dF/16U+HpB9I7auoovmqtT0LloY6+uhbEsYU7e
Lnd41kKfIzPBWookuDyVBKTC9mHBf0uoH822sCxqzRX46WnXBGNTqzlLXT3gjmo5
dj1XmFwiUVsDUEhN000+So6Sw86sBwBddk2yLXLSQiPQaELcHmyYXNsy8FOTFpLr
iQ0ArnZdkRuGrlPp8U6iFXuD9RUNxwfBIzEyCaSfblQRVWQ6TAU+WV38AFUnRUPp
eoDWFuUqBQpTPgUL+/iAHPcKPdtP19hMK6CF1UbfH1AjZ31k63EXkCv/X/a7IWxI
r4HcvNfWsF6QMi20mxVU
=zBzD
-----END PGP SIGNATURE-----

--=-7NY/aK1cTUxaA63vKii1--

