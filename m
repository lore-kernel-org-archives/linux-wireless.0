Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33070 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441AbZCIPHh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2009 11:07:37 -0400
Subject: Re: [PATCH] mac80211: handle failed scan requests in STA mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <200903091603.59050.helmut.schaa@gmail.com> (sfid-20090309_160440_260431_36631558)
References: <200903091547.09223.helmut.schaa@gmail.com>
	 <1236610200.4205.82.camel@johannes.local>
	 <200903091603.59050.helmut.schaa@gmail.com>
	 (sfid-20090309_160440_260431_36631558)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-G9gfGyZC8nZDWgC3B0HP"
Date: Mon, 09 Mar 2009 16:07:30 +0100
Message-Id: <1236611250.4205.84.camel@johannes.local> (sfid-20090309_160750_927870_70363E8E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-G9gfGyZC8nZDWgC3B0HP
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-03-09 at 16:03 +0100, Helmut Schaa wrote:
> Am Montag, 9. M=C3=A4rz 2009 schrieb Johannes Berg:
> > On Mon, 2009-03-09 at 15:47 +0100, Helmut Schaa wrote:
> > > Johannes, do you think it is worth to add something like a scan watch=
dog that
> > > triggers after 30 seconds to cfg80211 and prints "scan request failed=
", cancels
> > > the scan request and notifies user space?
> >=20
> > But I don't really think it's worth doing that.
>=20
> Fine with me. This was just a quick idea on how we could easily spot such=
=20
> bugs in the future (for example when fullmac drivers start using cfg80211=
).

Yeah, might be worth it later, but I suspect that other drivers will
have state machines that are easier to verify.

johannes

--=-G9gfGyZC8nZDWgC3B0HP
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJtTCvAAoJEKVg1VMiehFYWtAP/iLF5OuOwgfsOs6upItajCE6
zO/FE8YXoNkLCysZNGwksU81CPBdHso+ck2rKwnR2Na0GYUCFBRO4qsHWJBst4y8
JGvkCOE7Sq3ag09QoHLqOtZQMKrqDcOZSK6tdRblij80YUCi0crACshQKHF1R66r
Nt30U/9DjHogI35bA/xg7jZa8CiWxAES8CzkreiRCoxHwizYjOX4i8l314XKw4eH
UxKD/VRb6Pgm2PP+tb5bgcnaJUzVk7+oDULBKx703hHSJRKSaKz4Pn+Q+My1YrVe
aumY6LIOqPUguugZ7YrY5VAKP+SfR34onD9qkIE8JNbDPlG0zHGJ3Ifg/nOUL/MA
5bOU4iZ4SAmmwXiX3F8uVofYKvb6bbDMfi3Yunp3/hpOurorPErLHovWiN7sJ747
IU05DEI4G8/f2f+DDSt5OMyMBWSCr72ctQlL9SaJtRQlQRxnmcPLoEjNHaoXMecO
lZqW7lUC5TOiLvCAMfBHmbDSX843bGJkESa1bCnkx+Bn5Dzc8ngE8sRuENczOpY7
nR40wJgOH7/KYomnnraZwORxlOVTD/Lb3DxOrj6YTAt42hFATBp+CoCmcxHedOyi
x7PKp/ksKaaDzPNpFtrGm5eTq0QlIO8zqsXnpHoRII22FR8R3Jl62BNy7pK2y7Sa
kcHi6P4xzJnh/JBx5MwD
=ejXb
-----END PGP SIGNATURE-----

--=-G9gfGyZC8nZDWgC3B0HP--

