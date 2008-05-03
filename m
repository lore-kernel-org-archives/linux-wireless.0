Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56116 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506AbYECXRv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 May 2008 19:17:51 -0400
Subject: Re: multiqueue
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200805040115.24553.IvDoorn@gmail.com> (sfid-20080504_010930_015290_5B70D2E9)
References: <200805040035.05512.IvDoorn@gmail.com>
	 <1209854340.3673.23.camel@johannes.berg>
	 <200805040115.24553.IvDoorn@gmail.com>
	 (sfid-20080504_010930_015290_5B70D2E9)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-F0tBAIwifmsGnFRGQOp2"
Date: Sun, 04 May 2008 01:17:43 +0200
Message-Id: <1209856663.3920.2.camel@johannes.berg> (sfid-20080504_011721_168699_A9DBFFE0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-F0tBAIwifmsGnFRGQOp2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> 	if (!mdev)
> 		goto fail_mdev_alloc;
> 	if (hw->queues > 1)
> 		mdev->flags |=3D NETIF_F_MULTI_QUEUE;
>=20
> So theoretically this flag should be set.
> However /sys/class/net/wmaster1/features contains the value 0x0

Yes, umm, guess why. That line should be mdev->features |=3D ...

Not really my week, sorry.

johannes

--=-F0tBAIwifmsGnFRGQOp2
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASBzylqVg1VMiehFYAQLIqw//eeUQpIYTgHh5/dlPUh9mAdoWYt2mHG+U
gwfo8h4WiTTVw7v7fC+Uw/EHxaBdb6zwuDG6Y6eLz2MYBiBRlgEfDghRVoR9cFT+
vImb3BSE0NTg77S1z7ASNmfJ0yNhrZNcmHNeP7xxs55Se8DRzx6q3nYmAZouclJ2
fj96qmnnAbiqUXkgnFKr2Cs03vkkno5R1mbhw6HEBSCdtMIw1gEfMhGYq2c7tgof
nGwzvpueTLiuXOyvb9ynpojYbkfRBB7XenZZFkyDy9r4aU1sKedpEclm7J8vvRfT
4LfVgTxoX+9eeNq+8alHgSdChDfhO3PeBhPwmMu+odHSRwKqvi2SfKy7ipRb83JJ
XczPKCVbxpORrcANfQTpGxbayjvjmXlfOS1fZxeTHyoSPwXLBuN+2zPiXuuQZRVf
bVlk9jt3dK+0ry4D557IT9Rc3OQLui2WEG/JEy9Nnee+mw47RS/9hXPpErUbIvSw
h2cReT5K3s3bbQLK/DUhVkeCDIlKK8KvWmBlFLh+56pKKSzjG0mh3lNbML2HkxVX
AI6/RQ5CJVNb1SEO09PvUwB/FeHKWzLPpv3DzNBKxaLUk3xB/Ty8Di6Wf0yIz78b
TruQGEmFxJikNl8nkxtJJYPG9G/yOKPPlE/h5i/DeHELzNb/H/bB4bzDvhZ2wkwX
XS+lF9+Wgo0=
=Iisu
-----END PGP SIGNATURE-----

--=-F0tBAIwifmsGnFRGQOp2--

