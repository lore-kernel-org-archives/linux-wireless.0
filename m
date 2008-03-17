Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60379 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbYCQJbr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2008 05:31:47 -0400
Subject: Re: Intel 4965AGN and 802.11n
From: Johannes Berg <johannes@sipsolutions.net>
To: "Tanner \"Xero\" Ezell" <tanner.ezell@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <47DE2517.9070601@gmail.com> (sfid-20080317_080045_786637_D26A2A52)
References: <47DE2517.9070601@gmail.com>
	 (sfid-20080317_080045_786637_D26A2A52)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-G6qp31LCRPpPIUOqSrma"
Date: Mon, 17 Mar 2008 10:31:36 +0100
Message-Id: <1205746296.1614.9.camel@johannes.berg> (sfid-20080317_093151_618821_51A23E09)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-G6qp31LCRPpPIUOqSrma
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> I've been trying for the last few days to get .11n support working on my
> Thinkpad with the 4965 card to no avail, i have downloaded, compiled and
> ran the kernel from wireless experimental git repo, and although i
> enabled it in the configuration, when loaded, (modprobe iwl4965
> qos_enable=3D1) dmesg reports "Tunable channels" to 802.11bg and 802.11a,
> but no n. is there something special i must do? Is there a guide or
> anything anywhere to get 11n support working at all? I'm using ubuntu
> 7.10 and have tried the compat-wireless package to no avail.
>=20
> Any help would be most appreciated!

Get an 11n access point and just use it? There's absolutely nothing you
have to do, the thought that tunable channels are b/g and a only and
thus n is missing is rather odd if you know what the n spec actually
is...

johannes

--=-G6qp31LCRPpPIUOqSrma
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR946d6Vg1VMiehFYAQLw5Q/+MxfWMKyDf5AGa9Z/ldAWwHFP4PDv7TFt
FCGe8hyAwcx6w828yLEwFkv3Jy948O1KixVPKxebkcishZwxQ9G0tqBq9hU8EV1V
NCBMaPlPMkTn1sBI65cpwhBxOUWMowYJi1usSdfbiIgblAxYnjBpjTnGjVoGDhxi
+Tcj6gKnnfX6JAq2bZHOvJwVg5aUYKCOGndIE9qZmRm6VA9emMhP2wgXTLM5yQzh
O+u2wccj3F/1DSaOlZo024PBhFbywvL8ac0ye9x8YrA6krG4LihmKcvtQV07Nvg+
RxxcZPAbXC7aE929fk+hJcHhF125gNrlG1fD1Zt4SlIgtE/yjmy4l49Ot4bvGH67
M2dpWOKubhQU2cYQRT9vBIZjp3y00oqHHdFizMrK94Jpsq+Kc/i+JbjJitRvPXAs
HYqru1qj0ak3xHZ5a7Pa2L6kpqVXDWcf1in9wItkF1WmxCVLsrwf+7Rpvv8QStyc
NhdNXFvssHoVG0YeVWAbwfVXQhnMMAi7HQt2mEZ70ibnMhWBCxv/DeQ/9h6OTsb1
i0nllh8tB1aoX/loMctgAtt0+pmSUSNKN3eTsOUQTu+aEkM2F7vTaX4+aWXBd8bO
xqr+CdArbJTfe9cUXXNQ62dKtZ6GIBRz9VEEmlhz1ORuO5pn1JQFOjltqDdx9fsB
t3N2Gyzdro0=
=wbsr
-----END PGP SIGNATURE-----

--=-G6qp31LCRPpPIUOqSrma--

