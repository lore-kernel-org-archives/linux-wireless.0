Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38165 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060AbYE3Oqq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2008 10:46:46 -0400
Subject: Re: suspend vs. b43
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <200805301642.05248.mb@bu3sch.de>
References: <1212150713.4117.2.camel@johannes.berg>
	 <200805301606.25556.mb@bu3sch.de> <1212158238.4117.4.camel@johannes.berg>
	 <200805301642.05248.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-MhwLNvQ99bD3n6uq42Xa"
Date: Fri, 30 May 2008 16:46:22 +0200
Message-Id: <1212158782.4117.8.camel@johannes.berg> (sfid-20080530_164649_920505_87CD1E90)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-MhwLNvQ99bD3n6uq42Xa
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-05-30 at 16:42 +0200, Michael Buesch wrote:
> On Friday 30 May 2008 16:37:18 Johannes Berg wrote:
> > Odd. Resume itself works just fine here, except when b43 is up. But the=
n
> > again, you might not notice that this is the problem because by default=
,
> > nothing gets printed on the resume console and then it will indeed hang
> > with a black screen.
>=20
> How can I change the printing?

Hmm. It seems I might have been wrong here. Rafael, do we still have
console suspend stuff?

johannes

--=-MhwLNvQ99bD3n6uq42Xa
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASEATPKVg1VMiehFYAQLe3A//dlahm1Gvy9C2s6wpYA/iyGim2U90vqmw
HsP2W1qOyI9H2bSJHz0KhT26ccqGWII7n07j/UU3III0XAMQS3msd1IfUsBCyvEl
I5gFL36G/YA3N0tusrNevoqLzRiPzaaltdPUF/u9DIXgBevOLgeUq+vk3lCTiTkE
Ye5f3CPoTkTgbxVV26A+RwEVXBRy2nK34REqK7LoVfrV0Ru69+RATofXh59Vzmae
8hOIi7WJMM0hgTXDFxU3p5r2fAlct99GwBMVDLZfhVS+yyhzeIdAIwpWedgdleeV
Yz+k5hKCQ8p9R3gZayEpwNpmdOuzqJb2w2VgRD8sARGNC4OFdozb2a0Iv9vBnblz
KYuVBbeQyw9bs5NsxfS8ZWIeeNUlBecckF6H4T7PZGrWwpjzhwfYQXhVXuZDCp3w
EHQU0MzX0bIkxwwXbh+kzlgAMT7uYUT/DaNSF6hqg9ndM54qwWs/WVLjhflRbdat
jQHUqb8AQjRcfOcSOhRHMGh1QaZmbPZBEMKqJ7ion2Ore4Uww3ifuUys4MXx/RXJ
xgl2/z6XjhquY97jz2uiRCmWFcC9u2PWGIEnHCLuHGUEH5Pd3q9HL0L5Id1S9leO
vpC5lj/Yu0/d+yz7CS1em2PwSmBFMEvwF4S2rFy6JNJhbP1wyp+oC0MuitMwPn1K
C+id6isz66k=
=OEKx
-----END PGP SIGNATURE-----

--=-MhwLNvQ99bD3n6uq42Xa--

