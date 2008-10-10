Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55651 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762361AbYJJTkx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2008 15:40:53 -0400
Subject: Re: [PATCH 1/2] ath9k: remove nasty FAIL macro from
	ath9k_hw_reset()
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1223641374-11872-1-git-send-email-lrodriguez@atheros.com> (sfid-20081010_212312_563798_A4C0EE32)
References: <1223641374-11872-1-git-send-email-lrodriguez@atheros.com>
	 (sfid-20081010_212312_563798_A4C0EE32)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jKxVN7kGEzM3VF+ih2JL"
Date: Fri, 10 Oct 2008 21:40:49 +0200
Message-Id: <1223667649.3748.38.camel@johannes.berg> (sfid-20081010_214057_357213_075C5DDF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jKxVN7kGEzM3VF+ih2JL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-10-10 at 05:22 -0700, Luis R. Rodriguez wrote:

>  	ecode =3D ath9k_hw_process_ini(ah, chan, macmode);
> -	if (ecode !=3D 0)
> +	if (ecode !=3D 0) {
> +		ecode =3D -EINVAL;
>  		goto bad;

didn't this actually want to pass up ecode?

johannes

--=-jKxVN7kGEzM3VF+ih2JL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI76++AAoJEKVg1VMiehFYBdEP/02J2XYdMvKBWCgdXyudFXfX
x+6eJg+1ch74x2c6Zkg5u3uMnzvQ24XDGQes0epi+ARTa0iiEQNin4KOJ1S1QhQJ
m5xsL6Ok052NpjWzyeJVjU9aWfsHbovFvioXQ6Qaz+jagG2+2fWHNhAsNLkyqbsW
B7OCgX+8LEOpc2NTHOcGWWSH1G+ted4oFOGbg97ouf5Ua87EKdUr8+et1hVEpd4M
NSf/RGuWPHY2F8EecOqYHd4JzvM2w9+jz+8oYSLCrtul3wgCkEAXHqXID0wdDnWh
sJUcOGod93Lj4TviMdEXjcliMJ1LGcxGcNuUbpfcDej+x3+nKXgoWRFv3zcll/rz
GDO4wWJ4NrtKK30EjDUcO/Y09afpgy13USr+ILWv+RKB4Qd2gNFaBJmq0YF4iIOf
Zio0qcvp84fdqcxsJMe6dEHY9r3ZkJMP4zyHnfinc/mDYHccb1Fy83KRYtIPyRah
LDws9Z0Pve3UMwHEuNgtMmFA0A3uzYgg2+GdUh2NFfWdYMYczNIStCZPekKzS4sE
fHz7IyZc84Yv6SQganVkwP+LGOC7Uj1hiBtinJA7JcDgAw/gcFK4dLhCYg/Q7SDV
hfMZ1p12XNKCXLAWmYa6/+A0V3iFj9FVSW6IOyd95xF5/y/0+Rm7/Bygc4F4C+VW
9uhSu2mFEeZI0n4zOzGj
=ZSMS
-----END PGP SIGNATURE-----

--=-jKxVN7kGEzM3VF+ih2JL--

