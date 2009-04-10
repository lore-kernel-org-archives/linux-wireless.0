Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58150 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938911AbZDJHcL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Apr 2009 03:32:11 -0400
Subject: Re: b43 rfkill LED broken in 2.6.30-rc1 from wireless-testing
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <49DE6ABE.30207@lwfinger.net>
References: <49DE6ABE.30207@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Isg89kng+C/Iu7E/L6Il"
Date: Fri, 10 Apr 2009 09:32:07 +0200
Message-Id: <1239348727.17031.15.camel@johannes.local> (sfid-20090410_093224_650967_56E5A7C1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Isg89kng+C/Iu7E/L6Il
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Larry,

> Boy is the rfkill subsystem fragile.
>=20
> After all our debugging of the control of the b43 LED with the rfkill swi=
tch, it
> is broken again with 2.6.30-rc1.

Is that really _again_? My patch, which contained the fix, didn't go
into the tree yet, as I still need to fix up a few things and get
toshiba/sony/thinkpad converted :)

johannes

--=-Isg89kng+C/Iu7E/L6Il
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ3vX0AAoJEKVg1VMiehFYIAEP/jArJ6u3calEebkclYiJB4z0
D1WmKhuqkR6ck9ivQOTS2+gHsvJIF9KnQEZHulHBES+7f2X+CyQNjYvxgepMzR9B
unUtS2mbjzetZkq43I9Ol5slb6vgNROg5k1CPurRkDLkXC5SzZhQ5jzJ9Pa+UBUB
e9i6ncz1OwzzJhg2+2t45qDaHx/pgvgIu2EAg2nhKD3IUWcPvDZLgEcs/u2TmPRz
6tNjeUihEOgs7hD36DxcWa5dEKS7u996O0+ucptwtX4Xl9YCR6aDhLz2W7b88JPV
eebi6eE6/jA9Edorybbog8ukaJvyzu+BVzfbHUS+oYaypIUgKLxlls9/dI3gV6+V
AL1+eosAJ6B9QDHs5bCwRq3kS6t2GC4/jQfitcu5a5N4Wl4BHkTS8OV1L5CMxUyp
Xj+kzD6yEJTciN2szJxfegbx6OQqn4n1/Tn1dYLgnRyfWbx1EVVIqIbhi4ZffU0P
bQUn+3jeS+6Ta1EYCPbjNMY5iHez1OEgt0CoaVwIQrbYB29sOk9j/GrV67HuQMoP
CuipeV7pivRyma39VQnlsgYtFXrSdTjRicBqz9iogoXQHT6REMm4rhc/fCCO679F
9S01QqOLU1dWxwXSNPzkSapuriaA1WHy6JNl2UMPKIYEzKp1L/RVnjjkVZc26EAp
H810AExfTv7K3NXtGdlw
=wgFd
-----END PGP SIGNATURE-----

--=-Isg89kng+C/Iu7E/L6Il--

