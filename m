Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60870 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbYEFKsz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 May 2008 06:48:55 -0400
Subject: Re: [PATCH 25/25] iwlwifi: map A-MPDU HW queue to mac80211 A-MPDU
	SW queue
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
In-Reply-To: <1ba2fa240805060346r617a53d1qb421f3d71ec14a1d@mail.gmail.com> (sfid-20080506_124610_845764_EFC202D5)
References: <1209954172-3092-1-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-23-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-24-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-25-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-26-git-send-email-yi.zhu@intel.com>
	 <1ba2fa240805060209x3765abf6lf5ece51055b0d60@mail.gmail.com>
	 <1ba2fa240805060211j3730f29w30313dcb3fd34c44@mail.gmail.com>
	 <1210066688.8012.75.camel@johannes.berg>
	 <1ba2fa240805060334y2add302aua2e4461451a3f95b@mail.gmail.com>
	 <1210070251.13316.4.camel@johannes.berg>
	 <1ba2fa240805060346r617a53d1qb421f3d71ec14a1d@mail.gmail.com>
	 (sfid-20080506_124610_845764_EFC202D5)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-+K4gNIih+FlfkH+FicPK"
Date: Tue, 06 May 2008 12:48:15 +0200
Message-Id: <1210070895.13316.6.camel@johannes.berg> (sfid-20080506_124807_798011_C6BBDDC3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+K4gNIih+FlfkH+FicPK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> >  > >  Disable the 5000 in that kernel and make people use compat?
> >  >
> >  > Huh, why disabling?
> >
> >  Well if it's not going to work then wouldn't disabling it be better so
> >  people realise it won't work?
>=20
> 5000 won't be in vanilla 2.6.26 so there is nothing to disable. Hoped
> just that I won't need
> compat so back porting will be reduced to driver and not to mac80211
> i.e. kernel.

Ah, ok, makes sense.

johannes

--=-+K4gNIih+FlfkH+FicPK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASCA3baVg1VMiehFYAQLXkg//Ut3HByIG0xHqHcOqwb5M8tO+1nDU+8mf
9cfJJQ/o59INHr/ZYGQ7hWa4X7RK5ttFBszUL5R+wif3Qgm8XASQQrtBI8TU9A4l
FmEbcpK95Cwv4bLTCu6XG7pQUHmt9+7hTnR5puQ38KBItDh5ZAJApQ8AaLGwDebg
7rUJP+3/UshfkTgooaj6xgO3h9V9sWEg5ZKTcjUysP9IblMmusHd7tsJIpobuyMY
KOMdqMJXMOm4eWLgnbKkcxVP8otv/X0AQHbg+7gEhVUT3Ebqo5z788hR08EKFbg/
3ZftM/m4UrSepFinCJJZ/9gp0kNXOYddOecuQBVYROykKdNR4dELmJFAB5ZE0Exh
8n0oNfGVV1eCjVSgcp2Zj1EDrpspD6f6acok/smH7Xif9ESj9+PjKgfj2FPPKiUp
QaaaYASQ5gxO2GumOnUW3FfbWgf/hwgLdrAsh+6pu4dZKxebBPVSmi7rfPGRDKap
PusMluTIqfrchzDxZl2jM9Ub4qEt0kBdTKSVO4tGM4dO3ky3GTDyaIofHL7MesL7
KObPlMnfv0lq50XjY4s2d5FDiI0p42ZGh6DwgWqKzXNLIzvbU+EDgjK3A2bWozyJ
JMXIcf6xXABW0vAEVQDWphxvfrPSkZKrffGAImD4/6tUZ/Rwg1j/Np4O/uVaK+Gz
mcUt1Cl0hws=
=+AJQ
-----END PGP SIGNATURE-----

--=-+K4gNIih+FlfkH+FicPK--

