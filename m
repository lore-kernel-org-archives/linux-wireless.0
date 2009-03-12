Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56080 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027AbZCLWJb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2009 18:09:31 -0400
Subject: Re: [PATCH] mwl8k: Marvell TOPDOG wireless driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1236863270.20489.0.camel@johannes.local>
References: <20090310091333.GG4738@xi.wantstofly.org>
	 (sfid-20090310_101347_405119_5EF3E76C)  <1236863270.20489.0.camel@johannes.local>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-aYMALMNImyvtNugEHbPg"
Date: Thu, 12 Mar 2009 22:26:18 +0100
Message-Id: <1236893178.25931.8.camel@johannes.local> (sfid-20090312_230934_459421_19692C19)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-aYMALMNImyvtNugEHbPg
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-03-12 at 14:07 +0100, Johannes Berg wrote:
> On Tue, 2009-03-10 at 10:13 +0100, Lennert Buytenhek wrote:
> > Add a driver for Marvell 88w8xxx TOPDOG PCI/PCIe wireless parts.
> > This initial version supports the 88w8687 802.11b/g PCIe part on
> > channels 1-11, and only STA mode is currently implemented.
>=20
> my 64-bit powerpc box says:
>=20
> drivers/net/wireless/mwl8k.c: In function =E2=80=98mwl8k_rxq_init=E2=80=
=99:
> drivers/net/wireless/mwl8k.c:897: warning: large integer implicitly
> truncated to unsigned type

And sparse has something to say too:

drivers/net/wireless/mwl8k.c:1595:9: warning: incorrect type in assignment =
(different address spaces)
drivers/net/wireless/mwl8k.c:1595:9:    expected unsigned short [noderef] [=
usertype] <asn:2>*result
drivers/net/wireless/mwl8k.c:1595:9:    got unsigned short *<noident>
drivers/net/wireless/mwl8k.c:897:4: warning: cast truncates bits from const=
ant value (2000000 becomes 0)
drivers/net/wireless/mwl8k.c:1606:9: warning: dereference of noderef expres=
sion
drivers/net/wireless/mwl8k.c:1611:12: warning: dereference of noderef expre=
ssion

johannes

--=-aYMALMNImyvtNugEHbPg
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJuX34AAoJEKVg1VMiehFYx3UQAKF/sryJOVegaHY6PtWZ7GRo
w+izZD5Us/1SMcdJECfQt0ae7ApJB7qZ4LTciLOMeZQLaAclGLCEn+p82YzfZ0nq
h/U8gF+jHrLmm829Ep3dubHjaeDbFAXPFbsHKG5ShbqeHaf9Ywpn/V42Ohtb5DIC
m50aL949r5Po8HbQjzT7AGSw1KpgQlcsdGnIYl0OpmiAyR2J8gJXvtRVbb1zdybz
SOypWHJ5NGrVHuVnd6eeB4J3ukXDo8Y08YsJN6rLiCUywB8R7bcOJMj3f0V8ZeXQ
5CKLO4gQHFLyZIoGD60gYSBjVwAgCACs7Ta9wo1EoFdESNh2F5Vv20eAeeEy5yF9
2D/1Gq1MOprjVW3h2ADIsy6mMqLkCBwm0x829BR0XFYL4DB6lr2qT6V4aLECutEn
OBnx18QVWccv+r0+pAyMMsMiggwOq1b8+Osfo54T56E8nwznb+/zo1MuTHv6uFvJ
DAZwKDA8Uk4ybdVU3fDPYPIENiLRgB+nta7Mg7zXTtWIiQ5T4cTXUplEeFtC2RD+
Ia0h+y/JPkoist+acx91yZqcGfGhzg0zhRlnv78GwwTcyUoRIEXComUIcRi9sJXH
WDi4HqkLufC4/F3sWQ0f30l7rlkhxdcuehPx3DcWFsfpDqfWk7ejbHZ0dL+RLl3v
Uu78Bn7V03ZgepUnZOl/
=VIYN
-----END PGP SIGNATURE-----

--=-aYMALMNImyvtNugEHbPg--

