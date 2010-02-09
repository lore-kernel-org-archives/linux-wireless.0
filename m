Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52639 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754296Ab0BIPJQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Feb 2010 10:09:16 -0500
Subject: Re: CFG80211 depends on RFKILL or not
From: Johannes Berg <johannes@sipsolutions.net>
To: Jaswinder Singh Rajput <jaswindernetwork@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <74ccb2ee1002090631i4a29d320u2756af13de05cb97@mail.gmail.com>
References: <74ccb2ee1002090631i4a29d320u2756af13de05cb97@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-4aNmUUIbEOVj/w2P7IXX"
Date: Tue, 09 Feb 2010 16:09:12 +0100
Message-ID: <1265728152.3783.37.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4aNmUUIbEOVj/w2P7IXX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2010-02-09 at 20:01 +0530, Jaswinder Singh Rajput wrote:

> I am trying to understand what is the magic behind :
>=20
> 19 config CFG80211
> 20         tristate "cfg80211 - wireless configuration API"
> 21         depends on RFKILL || !RFKILL
>=20
> Do we really need RFKILL and !RFKILL

Yes. You can not have RFKILL, or you can have CFG80211 depend on RFKILL,
but you can NOT have CFG80211=3Dy and RFKILL=3Dm.

johannes

--=-4aNmUUIbEOVj/w2P7IXX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLcXqVAAoJEODzc/N7+QmaUZMQAIXah261pTeGxRoGd2DDsqoK
mZjaBlB9W/2KD36UBobwKOfL23tT0hOE4oM6joIV1zEqggR/TqaIrBlEctTqlAS8
xUJxDI56ILthmqPb+D5zYBHJh+HhCnidMKha0uFb7pzhxIdaKS5lVWrRkqtyz76U
S/R09isazVhdIgOFnwy715S9kzNKJp0UU54+doaiHRB/u//DvKGDebAL5xYfu+56
UMa7OYfB9pUNIqc3O0Xycml1QbTwa8dIIuri3Zu1bQXDtDNr7HKSNLnnV++gop1E
YvdbjPOjGVEkVszDAT/vFLCYrXjPtfpyVZVGNrcU4W5HKw36D98UIBxCFpjw/npp
8jioFQKZP89s911k7zsG4ZLbec6VYonoM2EwDOk45WXHKZFiKuC9oDmg+/TehUQt
6SN6m/2zwG8Fn5oUHJ2yxzyaGz9XiPUzsL3uQmD6KmtGLsnoh+OS6Qs7wc8WgPlb
divuuD7u3sxcXfnTC45H/myO1VWLvJJnkPjVGnDIiaMjMsPHK4wBktC8kmyR2ZHG
z5n/WuCXULJVS50H/kazTtTXwgHh9t69mNC80cJYr2ocWOzS93V/5oLWI9yE1uI+
9T6tx7WUmQTmyt9RZyI/3R3TV9Fv2qnTr7O1Ko4DB6Vy+SgHi4qx3TfWVV3IMseG
qkwBaCR0X/+t3oemu0Q3
=9rGm
-----END PGP SIGNATURE-----

--=-4aNmUUIbEOVj/w2P7IXX--

