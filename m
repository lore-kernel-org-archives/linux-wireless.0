Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:38399 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010AbYCBN42 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Mar 2008 08:56:28 -0500
Subject: Re: p54: fix EEPROM structure endianness
From: Johannes Berg <johannes@sipsolutions.net>
To: Florian Fainelli <florian.fainelli@telecomint.eu>
Cc: John Linville <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200803021324.51010.florian.fainelli@telecomint.eu>
References: <1204289793.3938.20.camel@johannes.berg>
	 <200803021324.51010.florian.fainelli@telecomint.eu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-1tPCCC6Ye6WmO4B8yUTC"
Date: Sun, 02 Mar 2008 14:40:44 +0100
Message-Id: <1204465244.3917.17.camel@johannes.berg> (sfid-20080302_150143_390986_AF97DA73)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1tPCCC6Ye6WmO4B8yUTC
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


On Sun, 2008-03-02 at 13:24 +0100, Florian Fainelli wrote:
> Hi Johannes,
>=20
> Le vendredi 29 f=C3=A9vrier 2008, Johannes Berg a =C3=A9crit :
> > ---
> > Does anybody have a p54 card and big endian hardware to test it on? I'm
> > fairly sure this is a correct change but if it currently works on big
> > endian the change would be bad (and I'd be rather surprised.)
> >
>=20
> This patch fixes the eeprom fields reading errors that I mentionned on th=
e=20
> list : http://article.gmane.org/gmane.linux.kernel.wireless.general/11794=
.=20
> This also makes the dongle work on my iBook G4.
>=20
> Can you pleas merge it ?

You mean my patch fixes it?

johannes

--=-1tPCCC6Ye6WmO4B8yUTC
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR8quW6Vg1VMiehFYAQKhXhAAtQ3FMC16+Wut0CN53USN1WW8WZ49/6YN
5L5zSr566oe42zG47MNkyZQncZe2z5Pq7QARf/1IFG1hFriHKFAsZh23lFlIuMgY
Y9/YFEW/FYa0d8dq0stGnt2jhJbQlHTQGuNUXSVnlto2IDTsBXlZBBQ+m8gaYa94
o8ieHsoG0xJb1dEYyWTrWIvhsnsX/qES+4y1SJ+3jEbxxHKkq88IWRZjqoKx9yHb
HUtaJLVLixjT/Iq5K7vtTnJyvTsTiJa4jajYhTdPl+4qXTXw0c2wdOlaXh8M2n8v
GOId7CDGkQk4Vb/PHwzNP006ecNrr7oujmsTR5utSAvQv5u6rYpM0P8VeRSBSojK
W3AS7WhVu96NJbBMWg1o0aWa+pMgeb8MWio+RAl9JHfixMEIOq+DblkKVDBnQPuZ
ArHsYECfHcgEE1deOIDnn6hmpJ0wzDeKwKD8/wxc85nP8yPUpKHRLqZ9yY3yaVC6
qN6aS8PtBhzskm4A+S5/l4pBYo3IKx+7wPwdn9ggdCgVM8yzIH5k5/E9zjtt06MN
xcWs3HXwfpxbSD1KJ8sl0x6cdi2lgSOKFnDS+kicHDG/sNM6CidG7DUWLjm+CEt9
Cm8ZD+yZbg1lmMyMVOMB63ERw9edBOFsmiVqtZMad/UNz8ty21+iVeqRhmPxgWHi
+lzhHMa40vk=
=T+Kd
-----END PGP SIGNATURE-----

--=-1tPCCC6Ye6WmO4B8yUTC--

