Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from csmtp1.one.com ([195.47.247.21]:30246 "EHLO csmtp1.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345Ab1KQU44 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Nov 2011 15:56:56 -0500
Date: Thu, 17 Nov 2011 21:56:31 +0100
From: Daniel Kuehn <daniel@kuehn.se>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org
Subject: Re: [PATCH] Seeing as alot of ath9k devices is PCI/PCIe or their
 mini equivalent it makes sense to set ATH9K_PCI to y by default
Message-ID: <20111117215631.2c2064b1@Artemis> (sfid-20111117_215700_771105_CB2DBA51)
In-Reply-To: <4EC5562B.4050001@openwrt.org>
References: <20111109235757.79821a20@Artemis>
	<4EC524B1.2070200@openwrt.org>
	<20111117163947.1749dfb1@Artemis>
	<4EC5562B.4050001@openwrt.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/s/GGj0CndH6K/peJa.hVR5L"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/s/GGj0CndH6K/peJa.hVR5L
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 17 Nov 2011 19:44:59 +0100
Gabor Juhos <juhosg@openwrt.org> wrote:

> 2011.11.17. 16:39 keltez=C3=A9ssel, Daniel Kuehn =C3=ADrta:
>=20
> > I agree with you there if it was removed before, maybe then only the he=
lp=20
> > section of ath9k should be changed to say that you have to enable eithe=
r=20
> > PCI/PCIe or AHB support for it to work?
>=20
> Yes, adding a comment there would make sense, although that does not prev=
ent
> to build ath9k without bus support.

Yeah, that is the initial problem I found that I wanted to try and patch, b=
ut
seeing as it only stands between either always enabling it, or forcing one =
or
the other bus always on if you choose ath9k I don't know what else could be
done except note in the help that you also need to enable bus support.

I haven't poked around that much with Kconfig but it clearly seems like the=
re
isn't a way to default select y but make it possible to disable it...

So there doesn't seem to be a clear way to automagically include the most
common bus support for ath9k.

>=20
> -Gabor

Kind regards,
Daniel Kuehn

--Sig_/s/GGj0CndH6K/peJa.hVR5L
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJOxXUWAAoJEOYWIJmjnr1S0YEP/RJrcb1S+hGJOtsibrbV5W1X
fZiPlROWVIJ/ytXfhtansSNFvBxycVgCLlqSXiorsJ43l0ebHQlK/vAJSw6ta7Qs
31WSnI5oVFTmkv6/v7oVKdWaOIKm0hXzCpbzJPIgLjQbH5Iumi7PY63cfVEIqTJT
X1jOt+PiGCFPvjru3US9bveLC/7A0lNsvozKsiMPbYFnVMCjZFLh8jejcuR1wDVu
17sfjVCyT0mJYoe4WtmpcAOKSLp/V86awKHMhlSJErIbIGSl+XqOFCx9CChrM1WY
bBv01uhw9fBne/MMbdYJof9/ifDcxQB+FnV/4rbaYyWOjyUutYtQ6tscb708C2C5
LqyRxUn4x1gftLGUIU8oiq5LM44fMjzwejGtKDR8KUzOFniXqj+hkfSAmM6fvkoE
KPjkYGEjfZMQhlM8eKpXiqjcHZY8A0OTiV1HSA65ZhWGSFwdjt/K1pMqcshN7vSL
qbE7gddvfniMkl5fEi9g583b9idr31i/rwA57dsFGe1pDx1ceWQavnqZFxAU21YF
wsyVHv+z/8kE1PGUFUl8HrhflKhu0ftg/Gjb9YPH4osGiPXYzxPFh3a30liLlN9s
cOnrKmcFa6i5pNB5yvtlF+KVwAKQh8hXxQ/SGLrU6J0KNmFrmHcfJzjSKt3V0+A1
NBfrEyNl81nafV2wDDcu
=e5cL
-----END PGP SIGNATURE-----

--Sig_/s/GGj0CndH6K/peJa.hVR5L--
