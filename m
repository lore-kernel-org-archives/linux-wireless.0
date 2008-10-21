Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52477 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303AbYJUV2A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2008 17:28:00 -0400
Subject: Re: [PATCH 4/5] crda: Updated regulatory information for France
	(FR)
From: Johannes Berg <johannes@sipsolutions.net>
To: Benoit PAPILLAULT <benoit.papillault@free.fr>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <48FE399E.6050907@free.fr> (sfid-20081021_222053_979649_39DDEB3E)
References: <cover.1223583376.git.benoit.papillault@free.fr>
	 ,	<cover.1223583376.git.benoit.papillault@free.fr>
	 <48FE399E.6050907@free.fr> (sfid-20081021_222053_979649_39DDEB3E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-iqDCAnqcKYdJkzX4neG3"
Date: Tue, 21 Oct 2008 23:27:54 +0200
Message-Id: <1224624475.28639.13.camel@johannes.berg> (sfid-20081021_232806_019903_022AC77F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-iqDCAnqcKYdJkzX4neG3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-10-21 at 22:20 +0200, Benoit PAPILLAULT wrote:

> +# Data from http://www.arcep.fr/index.php?id=3D9272#12931
> +# Updated 2008-10-04
> +# 1W =3D> 30dBm, 200mW =3D> 23dBm, 100mW =3D> 20dBm, 10mW =3D> 10dBm

You can say "200mW" in the definitions and the tool will automatically
convert it.

> +# TPC is needed for 5250-5350 and 5470-5725, which flag to use?
>  country FR:
> -	(2402 - 2482 @ 40), (N/A, 20)
> -	(5170 - 5250 @ 40), (N/A, 20)
> -	(5250 - 5330 @ 40), (N/A, 20), DFS
> -	(5490 - 5710 @ 40), (N/A, 27), DFS
> +	(2400 - 2454 @ 40), (N/A, 20)

i.e.

(2400 - 2454 @ 40), (N/A, 100mW)

I think I did this for the DE one.

johannes

--=-iqDCAnqcKYdJkzX4neG3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI/klXAAoJEKVg1VMiehFYniIP/ji5MGGjy6Si8z3oHHA/SBu9
vFNfOSiRMagv8zdaK5Aj3XsBlOU4DFr6EFaKm2fWK6JryHon0pz/YyVvtJWANkPG
DHRwcKc7JpaERNPtHv1VRigEsANsKdId41SzKniIEP42exn0GxSmRSAkJj5BL6J1
XIi5Xg17uhcnhAEZ5Vfwg2dA5k0atPZXA5q9GXCDahsO8CS0HamkW8uJADC4W24T
zpFRPkaa9jmwk02yI877mR7lXsGWa5hCD9GJkZWHUmhEtVAmP+Gka9bm0jbJd3y0
A6DpiBv1xXgMS/XSDdnvfxhKC+WGajnkC4UDqEiKg2LTjgxClKR2Tk1kx+orozUj
3F8h9qE3GDLOjsp8EeEyAZrrNjtlsNYjs/c1gqMqU1bCxYhb/z1a/Cr/TxdxKQwY
qn/4Q1AntCguB8Q0kI4aYY6cXfGpJHyxDRR14fbSE5ckVBmvuOl7n9IVEXRZwdOA
q+kSsW+cKKxHWBPE/zThG9+ZB2iqAkgos2cU7pf2eEqJhOlJreYVVgBDYQ5eQpgO
TFuVCZ2pCj1Whn0pE/7t9ro+8cQQYAWKNX+IFNpgneBbasanAnz8GQbWl4AfpMtj
SvZqC1mrFelSPsDJXKB6h/6OK7GGyPuvKWzHJSedVX0uKjuTDe+hnH6oSIp2hOZH
sYaQ5k7QNXloDAiC1erl
=HBC/
-----END PGP SIGNATURE-----

--=-iqDCAnqcKYdJkzX4neG3--

