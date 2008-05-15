Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53608 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228AbYEOQTd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2008 12:19:33 -0400
Subject: Re: 4311 v2 Bail - 2.6.26-rc2
From: Johannes Berg <johannes@sipsolutions.net>
To: Daniel <dan@f-box.org>
Cc: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	bcm43xx-dev@lists.berlios.de,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
In-Reply-To: <482C530C.8060101@f-box.org>
References: <48294F0B.4040908@f-box.org>
	 <1210721604.4279.40.camel@johannes.berg>
	 <1210721764.4279.41.camel@johannes.berg>	<200805140146.06910.mb@bu3sch.de>
	 <1210722537.4279.43.camel@johannes.berg>
	 (sfid-20080514_014950_992691_D85478C3) <1210722731.4279.45.camel@johannes.berg>
	 <482C530C.8060101@f-box.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-OsP7sWvldvOXFuKHBCBk"
Date: Thu, 15 May 2008 18:18:23 +0200
Message-Id: <1210868303.3900.11.camel@johannes.berg> (sfid-20080515_181939_400683_F0CE9961)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-OsP7sWvldvOXFuKHBCBk
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > We really need a raw monitor frame capture.
>=20
> Not sure how I go about that one?
>=20
> I have an external RTL8187 device I can stick into monitor mode? But=20
> then it wouldn't be associated/encryption keys...
>=20
> Tips anyone?

In this case, adding a monitor interface to your local b43 machine (with
iw: http://wireless.kernel.org/en/users/Documentation/iw) might be
preferable.

johannes

--=-OsP7sWvldvOXFuKHBCBk
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASCxiTaVg1VMiehFYAQK2ww/9G5ELaY4biyFwGQiLKLQ1mPh4SFe728ww
6kiUfH13eqAjKy7AB+gAV9pR7C1mJEVgSAXJqtedveU+oZFR8ibfwWHsJ1O0tt6f
P1OvRhpbDJval8B/NV3Xak8HfxTCkAgKjIw6/tEBgrxGt4BRp3LM5S5k3RTEKepi
W4vVmzSeFrODt6NuHnkBitGZS/mO1kz6UkTsfuBrBzx+/7lVOuPh9iM3hvmm6McW
Eyl4DZqpUMAOXsndBbqx/U5t4PAUaF2SmwewUFy2uKY4ZXN8gl0aSO5t5d6RBnI1
/CRaL3BobOiqXF4wiej9Kn2pty5t6PzbP+JB4uMduW4LnAwHfngOmjhNivysRfuD
sd6AmH11OZKodXECoDypm3d38AwStKCC7so9vmvn6b3/tVJOKMsNmESoBhrIknbc
vg7duxs7vk7x25GmnMzvJLBiqa0fCyeuayYmwAual0PLZVw2RaMBYe7D6xrq/khE
pWqHtuuwSwi44HOCNFFEeQ+xi9QV/T2naFWXrXNyPphQQPhb5GborQNYSGfuRcCd
hPKiSRANw/jqJRipJemvcTj1tOH3JJejFBrTp5GtRWch8MOh0uAv8I1Wq3NLSFvh
EltuC7a/QtaUQKnAoa1ya4n8kn2ZgovG2HSA1i+TAdBcZlCQa47Wq+HNO4hWoqa+
CVOOcDPWT9Q=
=MWKN
-----END PGP SIGNATURE-----

--=-OsP7sWvldvOXFuKHBCBk--

