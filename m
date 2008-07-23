Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46008 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753670AbYGWTEG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 15:04:06 -0400
Subject: Re: Commit 741b4fbc44 (mac80211: fix TX sequence numbers) breaks
	rtl8187
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <hintak.leung@gmail.com>,
	Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
In-Reply-To: <48877260.7040008@lwfinger.net>
References: <487f5f20.2lT57D3i0q99wrfY%Larry.Finger@lwfinger.net>
	 <200807221613.34434.herton@mandriva.com.br>
	 <3ace41890807221525r67716ea0r251068df773fe53f@mail.gmail.com>
	 <200807221940.20009.herton@mandriva.com.br> <4886AA3B.3000406@lwfinger.net>
			 <4886C50E.6040304@lwfinger.net> <1216824917.13587.9.camel@johannes.berg>
		  <48874F09.7060400@lwfinger.net> <1216830449.13587.17.camel@johannes.berg>
	  <48877260.7040008@lwfinger.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-AKoJ0QdR+UxpU/KTU9zO"
Date: Wed, 23 Jul 2008 21:03:44 +0200
Message-Id: <1216839824.13587.30.camel@johannes.berg> (sfid-20080723_210408_938841_B1E80B2C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-AKoJ0QdR+UxpU/KTU9zO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-07-23 at 13:03 -0500, Larry Finger wrote:
> Johannes Berg wrote:
> >=20
> > Odd, that looks like it should work. Can you try printing the seqno and
> > see if it does increase? Or maybe I messed up something with the
> > flags...
>=20
> It is increasing just as expected, but no connection.

Strange, don't understand that. Can you monitor with another card? I'll
see if John has an rtl8187 here.

johannes

--=-AKoJ0QdR+UxpU/KTU9zO
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIh4CNAAoJEKVg1VMiehFY1JcP+wZ/X2pKDAVecHdj4zGoKbqx
ayrB91u4yisQTag73Wgjlf6GmUQX7zGWtEEWM4cMZIhIdlS57mcBABpUiQQi9XHq
E0ZFs0m7KDX84kRWccF8mZYGYOT4OnuP8/4YujXC9Fl2BqvCsEk3EfW3FKQymwJE
A3/rOq4wbYuvXrtny4iX7PytXZVNyENGq+Sd5ywfp8R7jIYIcovGSbxlxgTEzz0F
Rng9CBsGuejv+pM87Rt1ynz1Z9YbIoeLGKNGxiJUKMxlgn0SuSMaac7QPIkEkiGX
7tNfGendlXBNaGutzdvMgFf4sApPwUgiPNq6w5vnfc3l61AwFpFF6NaCJZ6MKKii
JLSRe69ApxxA7i4b+BlJ3kt5knaEuLic1OBldiydkOnixT1pRnMgPH/QQ5uNrpKd
78Lvp77chWkOIF3jwvWJrNkxfp948E2ybVvIQDCiEiMzMpGcSCww0alSfBcBynIO
Ny7BdgSG2BikyxVPobi7yQLKYAzcPxb2QXcsq+hHPb+48pPJ2z8cu5AMcYZ9Gw1J
410CaqJytBHr8XvBOtlj7tJxwmHxFbbK2n2FCmvbZeetJnC/YWDE+sY9kxPbpEl9
UZ/t6T0fXvRy/z4VJNqSpeaLEjvfRRMhdRVu40XeBxEPVMqjrMXLgA5r58YjwVx1
A6U8YLiSr98qiE0LWO+0
=uW8S
-----END PGP SIGNATURE-----

--=-AKoJ0QdR+UxpU/KTU9zO--

