Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39298 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbZBFUnI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2009 15:43:08 -0500
Subject: Re: [RFC 1/2] mac80211: don't add BSS when creating IBSS
From: Johannes Berg <johannes@sipsolutions.net>
To: Alina Friedrichsen <x-alina@gmx.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20090206190012.260110@gmx.net> (sfid-20090206_200044_110756_7814C10D)
References: <1233917883.4099.9.camel@johannes.local>
	 (sfid-20090206_115848_195519_25A34D99) <1233931364.4175.13.camel@johannes.local>
	 <20090206190012.260110@gmx.net> (sfid-20090206_200044_110756_7814C10D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4TEAR5vpHUwQYPpksI5R"
Date: Fri, 06 Feb 2009 21:43:04 +0100
Message-Id: <1233952984.4175.25.camel@johannes.local> (sfid-20090206_214311_452075_A0CF928D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4TEAR5vpHUwQYPpksI5R
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-02-06 at 20:00 +0100, Alina Friedrichsen wrote:
> Hello Johannes!
>=20
> > Tested both together with IBSS, works fine. Haven't tested fixed channe=
l
> > and/or fixed BSSID though.
>=20
> I have tested both, it works fine, too. :)

Thanks Alina, I'll have to split up the second patch (cfg80211 changes)
and look at the function naming you suggested, and then repost in a few
days as [PATCH]

johannes

--=-4TEAR5vpHUwQYPpksI5R
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJjKDVAAoJEKVg1VMiehFYVHEP/0hiJENWV5rbuh2tbm0dlBEM
eYa6nSq3NXXlbBSvv0h0gUo1WPnJ1XJbL/bRA8UxoifivAsuSyTJ16ygdMSen5xH
3W0TQnU6/Otj0wZBbk+zDWoEW8KyDGKrhKp+VxNmT/Z6XtojqnUr7y5GIhbU8Tx/
4DwQXRPqeZYTbNZTr34DX02feXhpdSd8mnhkgkhQtyzi5yD5ySkxjUmH6EEAa+eT
k4WJiKpI4l80NzZ0xUT/Leh7EG+bHZVMyEQrFSK0sDpkC177sPmB0fm4/Zg8mgV/
q8F0RzT1pngSg1poPPsW08ZrUal4UrV1xk1W74Bg6ffE2VQ2w7piLuIqk3/w/kFL
mIils2sGq0C66nCuRoDvuSpR4odwKOYH9mh/JOOUye42n/3JFjTAbbRsFCADOXhY
u6s94HVMFjIn/es84h0igbyZHcMTLHFhwlCgR0fcn9EieS42GpBl3Jyit7W1pRPW
IAXLbJiWvneh5CVub5yt4pQNe5rdtVdCmoxBVBlCK43QQEa5bxjk49J0aDTFkd47
+Ul6nqUb3/pnTw5R2SMqW5M14xgjcUeRAoMdeUrSe30ehkXEs5RYUP3sK1E2drJt
bLYKYIDJdQXoOoEZxcjMDNIiGyH7Dtvn/mV9vJSHoqkvPVTQnvB3PxOf8qPFNEU8
dnMQLihPDxO+3Cy8ii1Z
=s0H2
-----END PGP SIGNATURE-----

--=-4TEAR5vpHUwQYPpksI5R--

