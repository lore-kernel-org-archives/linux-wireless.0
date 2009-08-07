Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56357 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932358AbZHGSp0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 14:45:26 -0400
Subject: Re: [PATCH] mac80211: allow DMA optimisation
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200908072021.53221.IvDoorn@gmail.com>
References: <1249656135.7194.6.camel@johannes.local>
	 <200908071855.38921.IvDoorn@gmail.com>
	 <1249668106.7194.10.camel@johannes.local>
	 <200908072021.53221.IvDoorn@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-yL+BPR/IAeYTCU9pqIzV"
Date: Fri, 07 Aug 2009 20:45:22 +0200
Message-Id: <1249670722.7194.12.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-yL+BPR/IAeYTCU9pqIzV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-08-07 at 20:21 +0200, Ivo van Doorn wrote:

> > Initially, yes, but I think we should eventually use it for sending out
> > multiple frames after restarting queues etc. For instance after
> > scanning, we could send out a bunch of frames at once.
>=20
> This would work for PCI devices, but USB devices can spoil the
> fun (as usual) because those devices use the queue in the hardware
> and you can't control the actual "kick".

Sure, but it's meant as an optimisation anyway.

johannes

--=-yL+BPR/IAeYTCU9pqIzV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKfHY+AAoJEODzc/N7+QmarNUP/3ExxauIA1G30AUHYApWtV0X
ujgWdloRc65PyaG3UeSts+II9I+HsB01ok09I+BwW2SbSg+ArNQOEk/fwkZpWpTu
mfBHXjqLfJYZhaS82HBIDs+o8GthJ3s8BosD9mLVG5QwWLyFp7PPbk0InLGFpYW8
S9zSWuOj2B28RSSmOyz+Kst9GnQhtvOdJ4gYrq9tQpXP90H5udVwEG+E1zdoAe+O
I+jxp+/WhMfUDr3j2mgZN6Kme+IWWR0ojL6QhgSVUSJdeVia4CT1n7Bkbufjijdp
AyYx5sySld5ZKctAE55Ti+XdonJgxxak0g9pU4hr9NpSj766HhbNLhPslzY2IDLL
qBsjRe8zV66BDL3Hyh/XnafC+ZbdY8jkcqb14tSPPHHyDjfvCXdMRM1zCKEki538
83Zgi4J3X0Br4VJdxeS0UuylPnJYF5Zm33Eya8zo6+77g/tfxuBgKGc2gJzmxxUi
fBqXbvH3YsUHJAvpAXa6eNoKICsUL1QwsC7bHvvSazpcl1NJ481iKVeCF7CBC8Vd
pSLdSADlK/2QdP+HOhnooOwVNw/R56U7d2EtdhQEwA2g4oir2h0QoX2IUwSBfnVz
waqEBaSDv5ElnbSTXlnW0Cnj0oP6/fDIdHxivnAshu0dYFDz/aNuojn9gZ8VxpB0
NSJBErL5PnNfLVgx4KFh
=zpJp
-----END PGP SIGNATURE-----

--=-yL+BPR/IAeYTCU9pqIzV--

