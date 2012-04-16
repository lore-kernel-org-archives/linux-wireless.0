Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47198 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753801Ab2DPOQL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 10:16:11 -0400
Message-ID: <1334585757.3209.125.camel@deadeye> (sfid-20120416_161614_751893_18DA30E9)
Subject: Re: [PATCH 0/2] linux-firmware: ath6k update 20120410
From: Ben Hutchings <ben@decadent.org.uk>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: dwmw2@infradead.org, ath6kl-devel@qualcomm.com,
	linux-wireless@vger.kernel.org
Date: Mon, 16 Apr 2012 15:15:57 +0100
In-Reply-To: <1334541087.3209.39.camel@deadeye>
References: <20120410121708.15361.62740.stgit@x201>
	 <1334541087.3209.39.camel@deadeye>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-ERZyAsruYclJpRlCkDEO"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ERZyAsruYclJpRlCkDEO
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-04-16 at 02:51 +0100, Ben Hutchings wrote:
> On Tue, 2012-04-10 at 15:18 +0300, Kalle Valo wrote:
> > (Resending as my --cc had a space and stgit didn't send this to the mai=
ling
> > lists.)
> >=20
> > Hi Ben,
> >=20
> > here's a firmware update for ath6k. We update the AR6003 hw2.1.1 to the
> > latest in our 3.2.0 branch and add a new firmware for AR6004.
> >=20
> > This is the first time I'm sending patches for linux-firmware so please
> > let me know if there are any errors.
>=20
> I've applied these.  However, in future please only add File: lines to
> WHENCE for regular files.  I've now removed all such lines from the
> listings for ath6kl.

What I meant to say is that I removed File: lines that referred to
directories.

Ben.

--=20
Ben Hutchings
This sentence contradicts itself - no actually it doesn't.

--=-ERZyAsruYclJpRlCkDEO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT4wpnee/yOyVhhEJAQpDmA/7BScwEgREoTcvdyejpwAYLRGa/Ksy6Z8d
yfWLX0+wv/bIWtCRtIr0N70l/kP2d74P+EPDDnXhOdCMo8ZEoJcC6yhJ6Yb4VNhg
ef9fKUTOH/lQ3kY/ag5XxbRWUMA7Ykz49aTd7q3p+xBTey446Lww4dl89sCQAgbz
/JO21BK1Sy2C6jBYguosFt0SjFziE3X5g+evWDFUUEWjyeKnPHliZJOZEtuN+KdU
bYRhE6Wewnj6ergY6iun3NEpa2BSZP/pk+oyJaeQ/i3Tmjg1J1k+zofr2iq5xM4R
UXUwZuJgw0dYzyxzuhxqXeCDIiSnfIkLVsJ+G/Tuq2Bk+4gAI4DKDvOZRl1S3PGM
fV6HM9NHd2qY6rTmdYUMBVcGUFl9UghMqShJeSAtIFhtkHp4zn8nSun3+uaul82I
1nyJhD31pVYACyinLggo56EQbROyPhI5Ol+pNYK6z1ABtj2Uw4FKshGcmMX6h3ca
mSPgGJTX+YXFm1DQFhetGcl2ipC4Ss0SxjlZs+e0GbgIvG/kPJEVtozVtEQ431Bn
IFQczIhneY3LZrL+/NbM/vyJtz3JMEBHyFM8Jy1b1m1Ln6jp/kW4sIXFfKFGItIy
9MJNOoDPs0IgMximIBdW6AtnDQr/zPg0JcKwLcqAH3rf3t9aq4BnvzE5nN4xYAqA
ZycLLQ0zZmU=
=KhP5
-----END PGP SIGNATURE-----

--=-ERZyAsruYclJpRlCkDEO--
