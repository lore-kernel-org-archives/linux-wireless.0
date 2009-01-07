Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39959 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296AbZAGPqE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2009 10:46:04 -0500
Subject: Re: [PATCH] p54: return NETDEV_TX_OK in p54_tx and fix sparse
	warnings
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@web.de>
Cc: wireless <linux-wireless@vger.kernel.org>,
	John W Linville <linville@tuxdriver.com>
In-Reply-To: <1231342997.3545.44.camel@johannes> (sfid-20090107_164257_031400_85F402D7)
References: <200901071640.08721.chunkeey@web.de>
	 <1231342997.3545.44.camel@johannes> (sfid-20090107_164257_031400_85F402D7)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-appnIpzrJ8oH0PdrwqLE"
Date: Wed, 07 Jan 2009 16:46:27 +0100
Message-Id: <1231343187.3545.46.camel@johannes> (sfid-20090107_164610_729998_A59CC72D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-appnIpzrJ8oH0PdrwqLE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-01-07 at 16:43 +0100, Johannes Berg wrote:

> > @@ -1750,7 +1750,7 @@ static int p54_set_ps(struct ieee80211_hw *dev)
> >  	int i;
> > =20
> >  	if (dev->conf.flags & IEEE80211_CONF_PS)
> > -		mode =3D cpu_to_le16(P54_PSM | P54_PSM_DTIM | P54_PSM_MCBC);
> > +		mode =3D P54_PSM | P54_PSM_DTIM | P54_PSM_MCBC;
>=20
> you also have to declare mode as u16, no?

Sorry, you do, I got confused.

johannes

--=-appnIpzrJ8oH0PdrwqLE
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJZM5RAAoJEKVg1VMiehFYGnEP/10Anx02W9iU+PHOXji2stTb
3N1Aq7pvDR61Z5t8q42Qa5btUWU+BuOfFAnqhrq8BP1VABLwuh74SOqaKztgOZgb
TyPOMT05Y9ADT+0GYat2ZymAiQUtGrcwMADwC/19qaCZqRz0hnZ+i2hyxHjpf737
pQuUtDxu38r76nSd9SC+rKr+aZdheq6ODipL8ZRH646K/kTxm82LVS5CtUWqGm8l
Kpv7z2DiH/ev1CFYZFzHbSoJkqzk6S8xPQ5uhdGuuXHF2VCpZ6A27gx8apoPlR3c
sVb2JACYRI+F1T+59skV1zR+U7rE3GpBeoePvN3e16tGfDwo4yCZ8TeVU7HPllVF
odjhq8l0BT9gRhN24bqNsU1r5H8nLB/eiG85dumEaR/6xR7MAJ6S8xE+YxszwTSH
nHrgxTR4x/jkAn/xvJi5Cke/OFTm73yFENOtcDj8DtKua37iZP2jB16NqLwE/ete
UR91xDjN8b4ZxoXfxhfbYlTk3iqgj1CikpFCYprkiYAnpkk5c5eI6z1g6KX7kMC/
7Nbn4BNaDQ6f5n3SEq/VYTIX3t78oTcq6s+f4cNN4q0X8bgQQOFlEh4QuvxWnnOL
OHyU/bn2ioilv9STchz5p+H9/GIUJH86ynNAe5p6wa1ulGJ7ODnHr/6jT/ktaNM8
LeC1L3NoDxusKF7cZp92
=C81+
-----END PGP SIGNATURE-----

--=-appnIpzrJ8oH0PdrwqLE--

