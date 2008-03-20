Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60267 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703AbYCTBeG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2008 21:34:06 -0400
Subject: Re: 2.6.25-rc6, rausb0 or wlan0 or both???
From: Johannes Berg <johannes@sipsolutions.net>
To: Adam Turk <bofh1234@hotmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <BAY101-W2F265A1ACEEAD6E11D953C8000@phx.gbl> (sfid-20080320_011109_826246_EC8219A9)
References: <BAY101-W2F265A1ACEEAD6E11D953C8000@phx.gbl>
	 (sfid-20080320_011109_826246_EC8219A9)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9yysIdG3kPntewVIppmz"
Date: Thu, 20 Mar 2008 02:33:48 +0100
Message-Id: <1205976828.16475.92.camel@johannes.berg> (sfid-20080320_013411_142060_17D94BD4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9yysIdG3kPntewVIppmz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> When I do the airmon-ng start wlan0 I get the following error message:
> Interface       Chipset         Driver
> wlan0           Ralink 2573 USB rt73usb - [phy0]
>=20
> ERROR: Neither the sysfs interface links nor the iw command is available.
> Please download and install iw from http://git.sipsolutions.net/iw.git
>=20
> If I do a airmon-ng start rausb0 I don't get the error, but the packet
> injection test doesn't succeed.  I am using aircrack beta 2 version
> 1007
>=20
> Can this please get fixed for 2.6.25?

Have you considered reading the error message?

johannes

--=-9yysIdG3kPntewVIppmz
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR+G++6Vg1VMiehFYAQL09Q//UgZKM1+fsqbuyAcpcsusHMutOTbpK5Vg
xKuwE5PprcKHvrtJa6+Rorha7m5Lj+5cszg7LIQMYEedZtz0WsmepzvJYHDs5JFz
U+QGCkniRbiD2aZQPsKNPHGDmiF2ZpNSXrA4qmouhHnQvo6BVQgHbwNsZrzj4T29
OE/TFZpI1H0wfa5rvEsTqa/3WjQ7DmXko3K/JwU77HS2ARJLlSTRilO4wOlMGCCa
2OVsy0aGZVR+a3i3+LKGTWp045hwCjPLXt1wtbzM0MZ8GWONybYlj0KCthxMXPA8
pSRS33Icl2SxKTx/GhZn9eiqiG8SRSBAR1uvy+xxraNhQC+1DYEDfaTUyR3NC5OR
vHJWWt7kzTSbkHM2D48uJeiFe/Gaegb2ehqdSlOe4SXrnKIAWjIh3v7ukns7SwYK
84HHbYu/irnyh9yIKaaF31khi1DYErXG41sSPb68Te/tR8GhEAuIve12gN08jZmV
8q7kw1KbzldPlqb0mNWOsAcc7bnyD9I5zVlRjnP6QyGj5ichGXXBpYADDWDfIoyJ
XUylYG3xrfDpj4oHXSt7Pr+X35W5DKao05vmGuxyizio4kPclJkKyg5vtKApveX6
ZCkoSFAFazu1M1Vz7M9JhIAJ6Dh0DbWuxOoIJ3I8LSUOtDE2CY/uGy+hkZCgDOcA
e76atprfWGM=
=C0Mk
-----END PGP SIGNATURE-----

--=-9yysIdG3kPntewVIppmz--

