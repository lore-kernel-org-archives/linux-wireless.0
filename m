Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:35273 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab3C0PxK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Mar 2013 11:53:10 -0400
Date: Wed, 27 Mar 2013 11:53:07 -0400
From: Solomon Peachy <pizza@shaftnet.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 12/15] cw1200: v5: Platform definitions, plus SDIO and
 SPI bus glue code
Message-ID: <20130327155306.GA20103@shaftnet.org> (sfid-20130327_165314_812207_3923853F)
References: <1363905589-8350-1-git-send-email-pizza@shaftnet.org>
 <1363905589-8350-13-git-send-email-pizza@shaftnet.org>
 <CACRpkdabdiA=bQX3nCyB2jP2hDQq0SEqVXqF1myN1jswXT2e6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3MwIy2ne0vdjdPXF"
In-Reply-To: <CACRpkdabdiA=bQX3nCyB2jP2hDQq0SEqVXqF1myN1jswXT2e6w@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 27, 2013 at 02:05:27PM +0100, Linus Walleij wrote:
> >  drivers/net/wireless/cw1200/cw1200_sdio.c | 415 ++++++++++++++++++++++=
++++
> >  drivers/net/wireless/cw1200/cw1200_spi.c  | 470 ++++++++++++++++++++++=
++++++++
> >  include/linux/cw1200_platform.h           |  46 +++
>=20
> I think platform data shall be in
> include/linux/platform_data/wireless-cw1200.h these
> days.

Hmm.  I'll fix this for the next submission. =20

FWIW there are still a handful of platform files under include/linux,=20
and the compat-driver tree I'm developing against doesn't even have a=20
include/linux/platform-data directory.  :)
=20
> Apart from that I do not understand WLAN drivers, sorry :-)

Thanks for the comments all the same, every bit of review helps.

 - Solomon
--=20
Solomon Peachy        		       pizza at shaftnet dot org	=20
Melbourne, FL                          ^^ (mail/jabber/gtalk) ^^
Quidquid latine dictum sit, altum viditur.

--3MwIy2ne0vdjdPXF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iD8DBQFRUxXiPuLgii2759ARArQMAKDSGLNc7kd61yLGIO50gqdg2SLCmACeN1G+
gJ9uZzUwKIZYY9lW6O1nYt8=
=UlLl
-----END PGP SIGNATURE-----

--3MwIy2ne0vdjdPXF--
