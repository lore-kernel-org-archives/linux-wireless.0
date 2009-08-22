Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35092 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933072AbZHVSNt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Aug 2009 14:13:49 -0400
Subject: Re: Abour linux driver supports BCM4325
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: feng tian <feng.of.tian@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <4A90005B.3030101@lwfinger.net>
References: <f42a38140908202319y5c352aa3s37fec67e5cb8d7a3@mail.gmail.com>
	 <4A8E8F59.9050706@lwfinger.net>	 <1250858409.5137.2.camel@johannes.local>
	 <f42a38140908212242h1ce0339fw1243dbacf54000ab@mail.gmail.com>
	 <4A90005B.3030101@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-LG56m+/f0SDpWbfqp1ge"
Date: Sat, 22 Aug 2009 20:13:43 +0200
Message-Id: <1250964823.23605.22.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-LG56m+/f0SDpWbfqp1ge
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-08-22 at 09:27 -0500, Larry Finger wrote:
> feng tian wrote:
> > Instead of waiting for the codes, we decide to do someting on
> > supporting the BCM 4325 running in linux via SDIO.
> > The linux wireless dirver supports another chip (marvel 8686) with
> > SDIO interface, the sources codes locate in
> > drivers/net/wireless/libertas.
> > We are wondering to develop the BCM4325 driver in the reference to the
> > marvel 8686 SDIO driver.
> > Please give comments on this, thanks.
>=20
> The SDIO routines might be transferable; however, the radio and PHY
> code will be completely different.

Very few of them will be, afaict the SDIO bus access is vastly
different. Learning how to write an SDIO driver might be possible, but I
suspect transferring code won't make much sense.

Either way, isobel has some b43 sdio code already.

johannes

--=-LG56m+/f0SDpWbfqp1ge
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKkDVSAAoJEODzc/N7+QmaskoQAMItPZ0nTfj/Dn69QSvNwo72
cpsF3voEUcPWLMha1STalPOjbAacB30pd7w5aqR0h5Zabr4EHJL4i2aLioD8g78h
vo6BqZ+Zyg63wV4BYU4CGXKrsPQLaYrg9IBV/HlRehxI1CDjDCnpeM/35Zq3DBun
i0po7sw8jDj3GH1AXt2UknXHaXbS5D5F3CBPujFfYOAgGC7VT5+Vl2Gndq3OsU6B
TQBhoeDlbTzZKH0idZzsuZtF7aFrEx+7356LeIYHR5MjOdzkrlQx0KoKRxPXH+qX
JXr6Y9qPGGRWPDCh/Uf716w+PspZc0chTvbv8f9RHOXL9rmN/xmpz/0swt9yIqu6
SLfZ10XZQlm7F2CjxBRyV/7a4NO3kK5c4AGdmcE1I4uWUHoiF+Apt7yVfE7IstxD
/zgcKW/Qgiimz/pfUU7valuTghEV7ilBTsaaN1e5f5sWTXfF8+IHhMcUygMWIT82
zJqnOj+dDr5LADBg/tm1ndE0ZSJqF3lwj2VGpjeCaLcLaaSNPl+J81i3cJ6jZH3g
Ax23ThUlfBarJ3NowvtIvMjT8pRkBuwxG3rJX9CISeTZeDnMfX7OdgOZk2y5ub4A
y7+kXQv6E1hupuKbtTi5+Iq9y+JzVq2de7AcKJzCoiXMA+WDGLiIgEPCOWQc3s1Y
mSuuHzlEZcPKKXRVkiFK
=KAkr
-----END PGP SIGNATURE-----

--=-LG56m+/f0SDpWbfqp1ge--

