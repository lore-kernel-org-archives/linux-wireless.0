Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33292 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbZAEIRJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2009 03:17:09 -0500
Subject: Re: rate instability in wireless stack
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Andi Kleen <andi@firstfloor.org>, Michael Buesch <mb@bu3sch.de>,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <49619FF7.2030606@lwfinger.net>
References: <20090104164649.GV496@one.firstfloor.org>
	 <200901041736.47650.mb@bu3sch.de> <20090104174123.GW496@one.firstfloor.org>
	 <49615465.4090604@lwfinger.net> <20090105025302.GF496@one.firstfloor.org>
	 <49618497.50809@lwfinger.net> <20090105050248.GG496@one.firstfloor.org>
	 <496193A6.3040608@lwfinger.net> <20090105054830.GJ496@one.firstfloor.org>
	 <49619FF7.2030606@lwfinger.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-h9zklX+sr0/JRYKnUT+W"
Date: Mon, 05 Jan 2009 09:17:44 +0100
Message-Id: <1231143464.3286.1.camel@johannes> (sfid-20090105_091712_384323_B6DEC271)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-h9zklX+sr0/JRYKnUT+W
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-01-04 at 23:51 -0600, Larry Finger wrote:

> rate     throughput  ewma prob   this prob  this succ/attempt   success  =
  attempts
>      1         0.9       97.7      100.0          1(  1)       2086      =
  2206
>      2         0.1        7.0        0.0          0(  0)          1      =
     5
>      5.5       0.0        0.0        0.0          0(  0)          0      =
     1
>     11         0.0        0.0        0.0          0(  0)          0      =
     4
>      6         1.4       25.0      100.0          0(  0)          1      =
     2
>      9         0.0        0.0        0.0          0(  0)          0      =
     6
>     12         7.6       68.8        0.0          0(  0)        187      =
   192
>     18         7.0       43.3        0.0          0(  0)          3      =
     5
>     24        10.6       49.8      100.0          0(  0)         20      =
    40
>     36         8.5       28.0       50.0          0(  0)       1389      =
  1520
> T P 48        15.7       99.9      100.0          1(  1)       3277      =
  3525
>  t  54        21.7       50.1        0.0          0(  0)      19282      =
 20028
>=20
> Total packet count::    ideal 3800      lookaround 422
>=20
> Johannes,
>=20
> Any explanation as to why there are no attempts?

It only sent two probe packets? Remember that zd1211 is rather rate
control challenged. I don't know. nbd might be able to tell you more.

johannes

--=-h9zklX+sr0/JRYKnUT+W
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJYcIlAAoJEKVg1VMiehFYhVUQALJ4K6kQBIP+80rOWKV3hmMN
jeU7eX1iZG4sDRBj0VTyBHJZdZb4Kr+5t0kjk2YwI6Kdmv0LWWxc9EkICrWNNSXi
CL17glo0ONWHfvW3JMSCs/RxpAZOYbf3NOdXAmMQXNCSdo5JPLSpu2GEve68r/cv
MYXgThO7CMBG8lWAtEC7VPdHs1MxW09qWHva+Daks4Y7HorPUEXsnAzQRlVpT/8R
sVI292pS5d2n8/pqELnbkHa140FEUCgULZ0QSJwa8447Th9wYiPzUTX7nGRJOyW0
ou/T1TZy8QUlYdgQe6DXULVNNPyhu+WBliRddNFJuYST2WR23jSF/LQovMcp8nrt
sXsEH/ajaoCYH030W0s2EIzKA2VYhPT1D82H2jGXQEw8YhzyF9hk+TgGktaoO/Eh
oBq7p+bX7esn1kICKstY27vT5xCDYtnuKGUjo67vjpPyFpVqup4hzDfvV8VHTUh5
z/R106QBQHt0jaB9Wu2XMH1CbzK+n1GSqt+i/cLbXiPNafwnEtstEJmoIlhZlDvt
eEI4bZxqXk9u/StQKR50vRNmGB2lWbPq9dvTMxMJb3e2B3zSfIXgVJx6BjBAxasf
s2UiYrg+EADhpMDJuoClP3tulYPQwy4xl6fw6Q9mH5r5ePtN04XHPSI6QrOkY4Lu
LsnzkXwnGJL2C2nJYOhk
=fj2I
-----END PGP SIGNATURE-----

--=-h9zklX+sr0/JRYKnUT+W--

