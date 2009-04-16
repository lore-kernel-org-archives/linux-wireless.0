Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57218 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753651AbZDPKRn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 06:17:43 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <johannes@sipsolutions.net>)
	id 1LuOf8-0005yW-KM
	for linux-wireless@vger.kernel.org; Thu, 16 Apr 2009 12:17:42 +0200
Subject: Re: [ANN] iw: v0.9.12
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
In-Reply-To: <E1LrX4n-0007Z2-7S@sipsolutions.net>
References: <E1LrX4n-0007Z2-7S@sipsolutions.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-nPFa/eK/bDaBZleDWNpg"
Date: Thu, 16 Apr 2009 12:17:11 +0200
Message-Id: <1239877031.9737.15.camel@johannes.local> (sfid-20090416_121754_484410_6AB70D23)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-nPFa/eK/bDaBZleDWNpg
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

I forgot to bump this so everybody notices:

> A new release of iw (v0.9.12) is available at:
>=20
> http://wireless.kernel.org/download/iw/iw-0.9.12.tar.bz2


> Johannes Berg -  add plain "scan" command that triggers, waits and dumps

So now use

	iw dev wlan0 scan

instead of trigger/dump!

johannes

--=-nPFa/eK/bDaBZleDWNpg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ5wWkAAoJEKVg1VMiehFYldUP/2jkOrpZdJHNEmmMY4ImRApr
N+FpaVZZG9ztjSyNe+RO4ksYUxTkaZ1asbzD1daS38TsrLnLrTdDNEqz8M8sKLpM
7kqmdKhDACd34y16fQcOQAIO4tPAgkptCfMCK4IKNxRqRo8/iXP71XAtbzBAaOu3
OKXcEutAZIdDoyAh0jXJpptS9sqJj0SP3wPYjZaMm/thJbF4H6DeDiolndrNnSZ1
dz/AlBrEuz485VjFZEU43s4cWvOc8v//zZeW4hh1wP8Zm7za3O+v3lzI9PJ/XpxT
TBOjq2ZPb//YHzdn+QrZlFWsGRPQyYVDQnP6JgK65vgeZYi92mNNdhuyCpOqRNHR
FTRMpllCAn8GVRtg3otD7vp1Dwe+vt1H5jchyFf1cuAFYIXv9iES8BYqRrRm8ldG
VmSDKeaFoEKNiMksfUSceetQTwrsbtzLIUlL7a22dC4QEkYgmztPPHhzMop1rGMF
Q+X/NSO01+anOTgkYJG3OS5vufaik9a2WZ8YSMw0kAKodLPSrnsRjLAYaO7oY9av
1CZ3x7v5feHlsHjaJbok99eTJHHyyPOIRRvuMVPwPDslGK8sxZew5XGavwlZMEqz
PszxarCNdsILNMYY83IkUWduHVVO81gj1A3eXXLqa157FiU3kO5XPSTHWk5L+dxL
x9QkbwTPvIIUD92Niy0Z
=uo5g
-----END PGP SIGNATURE-----

--=-nPFa/eK/bDaBZleDWNpg--

