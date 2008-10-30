Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36439 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823AbYJ3U1C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 16:27:02 -0400
Subject: Re: Guidelines regarding separate directory
From: Johannes Berg <johannes@sipsolutions.net>
To: Dave <kilroyd@googlemail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
In-Reply-To: <490A17F3.5050802@gmail.com> (sfid-20081030_212430_202054_36F37BEC)
References: <4909EA78.3060700@lwfinger.net>
	 (sfid-20081030_181107_189082_5740895D) <1225387309.3690.73.camel@johannes.berg>
	 <490A17F3.5050802@gmail.com> (sfid-20081030_212430_202054_36F37BEC)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-KuHDDfxNgctf63Ecf742"
Date: Thu, 30 Oct 2008 21:26:53 +0100
Message-Id: <1225398413.3690.80.camel@johannes.berg> (sfid-20081030_212709_066963_B262D22A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-KuHDDfxNgctf63Ecf742
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-10-30 at 20:24 +0000, Dave wrote:
> Johannes Berg wrote:
> > On Thu, 2008-10-30 at 10:10 -0700, Larry Finger wrote:
> >> I am planning on adding code to control the LEDs on the RTL8187 device=
s based on
> >> the latest vendor driver. From the expected size of the code, I think =
that
> >> separate files will be best.
> >>
> >> What number of files in a driver make it advisable to create a separat=
e
> >> directory? Between the rtl8180 and rtl8187 drivers, there are now 15 f=
iles and I
> >> will be adding at least 2 more. Is this the time to create a rtl818x d=
irectory
> >> under drivers/net/wireless?
> >=20
> > I for one think that should have been done already, makes finding
> > drivers easier imho. But I don't think there are strict guidelines in
> > any way.
>=20
> On a similar note, would anyone object to collecting the orinoco files
> in a subdirectory? I'm looking at doing some refactoring of orinoco.c
> which I think can be split into at least 3 files.

Go for it! Well, I'd appreciate if you'd let me repost the ieee80211
removal first :) Will get to that right now.

johannes

--=-KuHDDfxNgctf63Ecf742
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJChiJAAoJEKVg1VMiehFY8zEP/0xaRIXjkjrTgh1JnzEpX5Hu
rr4C1SBcCaC5t+ez1SVd8UEgzeda9nvlG8iroERxFkMoCXG7aPfdngZLe5YvhdHM
JiidkTlzVAyoTSwEdUZwp/mbhAXR0R67Koitg5H8ggJ7xy/1E5zblEHb+D7VXPnF
7QEyGJXc4nALfz/Uy7TcZm5VHPt00gGxtrNxftxBQmyPmzhk+Dom/yjAS3KiyJf0
DoTyUHxzT6mrmMjV1qvX5aOFgnxywW9jFiJnauiUMkWfutCwaq3SxYDrFzcX8l30
SpbhYON640f8wnpHj5P0yK7DnvNh87JFMNp6ZepX9XfX8VVMu6juCfozU+FpHwc5
tnM4J2V3j45gbMAQRBdAiNb9JnxRk5z/C0E6aioPfas6KiSlfn82ybVaXKsrUrCH
b8ME5EqiCkjaAt+HSWIYK+iizYwKG52X4oOXn/mTyr4TE3qEjgQ3Go4h0LZg+pxp
zgbSNpp2U6On2R5FqhydrqflvJHZKK3KAz+oDnnI0gq5irGuiuNVl4iFSnzU+02M
5cYaubKyyKv/F1mIBPIH4Qm28S/cFR2B7f70JHBfJxxLGetRnXwaAeRu3gTSrOB0
ix+LN3RF/B0SN4iUSqzblQVLFJzoqtwLSvtn3+Rv8F1GiUXJisWw0Iua7YuTYgOd
A7/6rNzHWt7mALrTX46h
=skHK
-----END PGP SIGNATURE-----

--=-KuHDDfxNgctf63Ecf742--

