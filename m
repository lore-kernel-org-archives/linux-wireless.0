Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50445 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755363AbbE2Nrz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 May 2015 09:47:55 -0400
Message-ID: <1432907257.6319.50.camel@decadent.org.uk> (sfid-20150529_154758_274328_DC3BD71A)
Subject: Re: debian: crda package depends on iw?
From: Ben Hutchings <ben@decadent.org.uk>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 29 May 2015 14:47:37 +0100
In-Reply-To: <1432905874.11687.4.camel@coelho.fi>
References: <1432905874.11687.4.camel@coelho.fi>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-44cvFbfrrOUS7Eo+Zx7n"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-44cvFbfrrOUS7Eo+Zx7n
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2015-05-29 at 16:24 +0300, Luca Coelho wrote:
> Hi Ben,
>=20
> I just noticed that the crda package depends on the iw package in Debian
> (I'm using jessie):
>=20
> luca@weizen:~$ apt-cache show crda
> Package: crda
> Version: 3.13-1
> Installed-Size: 293
> Maintainer: Ben Hutchings <ben@decadent.org.uk>
> Architecture: amd64
> Depends: libc6 (>=3D 2.7), libnl-3-200 (>=3D 3.2.7), libnl-genl-3-200 (>=
=3D 3.2.7), libssl1.0.0 (>=3D 1.0.0), wireless-regdb, iw (>=3D 3.2-1~)
> Description-en: wireless Central Regulatory Domain Agent
>  This package provides a Central Regulatory Domain Agent (CRDA) to be use=
d by
>  the Linux kernel cfg80211 wireless subsystem to query and apply the regu=
latory
>  domain settings wireless devices may operate within for a given location=
.
>  .
>  CRDA queries operational frequency regulations stored within the regulat=
ory
>  database provided by the wireless-regdb package.
> Description-md5: bacfc9c20ed2cf2120d3c95c8e749666
> Multi-Arch: foreign
> Homepage: http://wireless.kernel.org/en/developers/Regulatory/CRDA
> Tag: role::program
> Section: net
> Priority: optional
> Filename: pool/main/c/crda/crda_3.13-1_amd64.deb
> Size: 59958
> MD5sum: 6eacfbb62c7647ee3bba653ee5adfe70
> SHA1: 0f02aebc61f68b87189c867369dbd5df74f4e5ca
> SHA256: 52d114e826944a492d68b3e4e77aed0feeee9c28f6a7c3d5c587027eb283f2cc
>=20
> Is there a specific reason for this or is it just accidental?

setregdomain is a script that runs iw.

Ben.

--=20
Ben Hutchings
Make three consecutive correct guesses and you will be considered an expert=
.

--=-44cvFbfrrOUS7Eo+Zx7n
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVWhuAue/yOyVhhEJAQrjlA//VnRmLAahdP8tYBUjpKv8vqJCjKywumqx
Bn50CdHZGWhHfcVPtT5rLJG3ph6ZPXoTlZwph7524naF2XfN3CRbVVWkoV+YY/+1
DLSrZiEPBI/XKBisosGBTrtWGsHGFxLwWE4DwY3naZc8Y3e+zFyDF0vqacUBGyVO
LLD4Ot6FHGwkQULksVOOt2L7sxuVjkfC1XoS68sAeGzRpO8lKV/QzKflrX6Zesjn
R6poKLt6Utt++Pmj9mPRkMOERzLuUl13+SbJP81HN/mz99e2c8iJAN0dgg06we+c
A/p+g0tWFPWU3URLjEi9N3boZjEbUWwgd8mtZgmMQp1LbwMEtTJ8vVCW0Vy6TipA
otmlH4HVWpyTiVVN0WEQgcPgdCeiPbkoVpk11Krc15VfDr5Tuz/KpQ5u0u+a/2+L
eNjMoJrc2Dz26iPWPS+SJgy3o8sEVOE/vEpohJcnDi75KcgmbbcYMVEyt8pHmu2Y
9fKq82RoXdV1Tb1XiNwDqGWmjjQdSIFnJ1bDG9gLiSM/jmARYdVoGMn8/4c2Jfsb
ZT9qH/7dVEtr/UG/F4Es74PZZMqGPRb8RcJlM/YAp6WZ0GxNcNPST09K9iESw85Z
rjGzXn6tghNY/ZeafZfuUYu4XnMCdvevZSNCapO8QP+YDP6nRNZt7XcHFfc/pa00
8VPTFkJD7pc=
=NUo5
-----END PGP SIGNATURE-----

--=-44cvFbfrrOUS7Eo+Zx7n--
