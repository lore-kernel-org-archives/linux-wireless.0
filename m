Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44538 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525AbYEMXeR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2008 19:34:17 -0400
Subject: Re: 4311 v2 Bail - 2.6.26-rc2
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de, Daniel <dan@f-box.org>,
	linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
In-Reply-To: <200805140127.22302.mb@bu3sch.de> (sfid-20080514_012747_829356_A0E41B5F)
References: <48294F0B.4040908@f-box.org> <200805131119.09964.mb@bu3sch.de>
	 <482A08A5.3000204@f-box.org>  <200805140127.22302.mb@bu3sch.de>
	 (sfid-20080514_012747_829356_A0E41B5F)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-xlC/rfYPFNrHnSABVrwq"
Date: Wed, 14 May 2008 01:33:23 +0200
Message-Id: <1210721604.4279.40.camel@johannes.berg> (sfid-20080514_013420_793116_3CAFC237)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xlC/rfYPFNrHnSABVrwq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Where does this "wrong buffer size" message come from, and what does it m=
ean?
>=20
> > b43-phy1 debug: Using hardware based encryption for keyidx: 1, mac:=20
> > ff:ff:ff:ff:ff:ff
> > wlan0: wrong buffer size<7>wlan0: wrong buffer size<7>wlan0: wrong=20
> > buffer size<7>wlan0: wrong buffer size

It comes from mac80211 when the AP is sending invalid A-MSDU frames.

johannes

--=-xlC/rfYPFNrHnSABVrwq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASColQ6Vg1VMiehFYAQJI7Q/8DBtHB9KImz4M+sca95FQ2yJyyoKeoAqS
y4vSWSoAeEHRZ/Qo6QmzLy8CcLA27U3g0uoCZeGW6CXyGe1a2WD/FhBL1vKE8DyO
NlXGVfLEYOlSMHbt19LejmXAL95B7DHt7XxU5g7LX2Gvljx9xQcXwCbR3VCX+Cis
x/W67n/KH74qwc5/jC9TJM7eUo+MldSmipoX4hxzeRBt/G/170LoGhaTiFm2Q4rD
mI3TKnFylOkzxHOUSq6pg4ML8oGO0Rdsk8dup3uWmPq6EV/5J0zevfKkGnkOEwJF
/po4RNuTrlMfO7sOx0gnZrbVaKOekDJDXDYmWB3JBiqsekGDQ3ii/MEkuqaLLsRQ
DbUdBUThwV1v46aOeUNw9LJB4DzCzZ7KhxkHMrgSgtwh6UAGSueGQ+8uckddmi5V
xCxvC98gVvKL1ToDZu/qPJwH8Pt0tDDtg9S6E7feKQORsPnR1qfKIHbm1RPchToB
h4l50siiGN6In9nRU4K4hBigjznGAdo4IXTueYSbpAVknoumohO5DzuQV3wsfwy0
KwwjN6r2qzC6pzCtIV3MVv7VaRup8jhXs+mdrO8k6XQGOY/OVvSqceaat9dIfrni
DqWGBt8rLE3H/G+5Zb5l9256D4mewOOznf7MDqwBfiHJX3Xv15ztuYW1UejnuKKs
WKkVfvQ/Soo=
=IRwn
-----END PGP SIGNATURE-----

--=-xlC/rfYPFNrHnSABVrwq--

