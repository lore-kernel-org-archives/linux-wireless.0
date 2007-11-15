Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42467 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759706AbXKOQxT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2007 11:53:19 -0500
Subject: Re: 2.6.24-rc1 freezes on powerbook at first boot stage
From: Johannes Berg <johannes@sipsolutions.net>
To: Elimar Riesebieter <riesebie@lxtec.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20071114193340.GA14921@frodo.home.lxtec.de>
References: <20071024120739.GA4897@aragorn.home.lxtec.de>
	 <20071024124109.GA9442@frodo.home.lxtec.de>
	 <20071104032006.GG9695@localdomain>
	 <20071113220235.GB9008@frodo.home.lxtec.de>
	 <1195053964.4091.20.camel@johannes.berg>
	 <20071114193340.GA14921@frodo.home.lxtec.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-SeCLU7B+iajK0cReDtws"
Date: Thu, 15 Nov 2007 17:48:45 +0100
Message-Id: <1195145325.13846.70.camel@johannes.berg> (sfid-20071115_165324_397905_772CA051)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-SeCLU7B+iajK0cReDtws
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > [FWIW, my powerbook worked with -rc1]
> >=20
> > > 2.6.24-rc2 works so lala :)
> >=20
> > > b43 doesn't authenticate via wpa (bluetooth isn't loaded):
> > > WEXT auth param 4 value 0x0 - ioctl[SIOCSIWAUTH]: Operation not suppo=
rted
> > > WEXT auth param 5 value 0x1 - Internet Systems Consortium DHCP Client=
 V3.1.0
> >=20
> > Those error messages are unrelated. My b43 works fine, even with a
> > multi-MAC patch.
>=20
> I tried it as follows:
>=20
> wpa_supplicant -Dwext -ieth2 -c/etc/wpa_supplicant/wpa_supplicant.conf
>=20
> eth2 is renamed by udev via MAC address.
>=20
> b43-fwcutter intalled
>=20
> Could you please enlighten me.

Well, you haven't said what broke. Those "error" messages above are
perfectlly normal.

johannes

--=-SeCLU7B+iajK0cReDtws
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARzx4bKVg1VMiehFYAQJWABAAvyctKLFynhGwJVdaf63r3kfG2YJmpcUU
AHODPPEfUVUThewM9xl6JcBR6v1k485S/B4tKMq63bVzKTrU6tx2Mlnv2skvckWK
8zc2vI9qKKn14g58x0WL40lLWdchT6CDOlzAnrMCVQ52/+nVRGaeHk1QL6GvWDqE
IosH5/qUhjwwFXXuKDbunJNuDe3CdDfzxVYKJ9dQngard871hFLSqtZlFQxsh1c+
oIIpQidNp6yJQMtIc0TPo7HmdKvDx8FeBPCNpS78Twl+F60ZVJEnDfgFdtlZisYU
vIh0N3nMbVc944a6gZ0rk/5NJ5Wv9wMOZOhj7bjYmfAuDNGGzIN7bBzVDgKOwXCK
efv/E+4poR7JG0aueZBEu/CnJBH7X/7e8l58kjmaM3yt6O7u/5wWCl/p4BTkhigw
utynS9oo5KG6YLpExL+93QJVyi5j7h1UGPIsKzxhkfuG2xQwa30ZeQqkhYTw0J3v
5cPulAoJDjsvujFy5pCQWoWbwCP/fAPXm28m49FV/fBl9vOMD6NDBTXnCuUtS/AM
otRofZ4UTiAloBQH+sFXju/5ucClAB9Es3xCs8ZWIuS4L12vCc/SjVlaOqaQ3UTo
oClqXmG0Y+AgyABdnCKIEtlb/2esxszTfgFufCXw4GfmdxIP3644XzVBDSKoFnHl
Dv6Ww9re6Zw=
=+Xzz
-----END PGP SIGNATURE-----

--=-SeCLU7B+iajK0cReDtws--

