Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37943 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553AbYEMJRj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2008 05:17:39 -0400
Subject: Re: 11n + wpa_supplicant
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: Jouni Malinen <j@w1.fi>,
	Linux Wireless <linux-wireless@vger.kernel.org>,
	Tomas Winkler <tomasw@gmail.com>
In-Reply-To: <8704f27d0805130148t57a1dad5nf5ff535ae4ddf968@mail.gmail.com> (sfid-20080513_104857_603495_7A3A4A22)
References: <8704f27d0805130118p6f597743sebed5a2cdb6d59cb@mail.gmail.com>
	 <1210667328.3646.24.camel@johannes.berg>
	 <8704f27d0805130141s403167b8q49eecb645d0461c1@mail.gmail.com>
	 <1210668421.3646.43.camel@johannes.berg>
	 <8704f27d0805130148t57a1dad5nf5ff535ae4ddf968@mail.gmail.com>
	 (sfid-20080513_104857_603495_7A3A4A22)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-LdxFQ9I8JgOig9EoTsSE"
Date: Tue, 13 May 2008 11:17:28 +0200
Message-Id: <1210670248.3646.54.camel@johannes.berg> (sfid-20080513_111746_705121_993A0A4B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-LdxFQ9I8JgOig9EoTsSE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> >  Ah, so you mean if the user chose TKIP then we should associate as a
> >  legacy STA?
> >
>=20
> I think so... If the AP is N-only we would be in trouble...

Hm. I don't really see much reason to do this. Technically, you could
configure it this way, but in practice most people will just enable all
algorithms they can support (i.e. all).

I don't really care, but I wouldn't want to complicate wext further for
this.

johannes

--=-LdxFQ9I8JgOig9EoTsSE
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASClcp6Vg1VMiehFYAQLhlxAAqzw7+Uq3+ETu1h12umroji1qgjSdD5hH
O0SpKG9Du/kM7j4BEV3pr1hjn4Wyw8/G4i0Z8tslZuEaQ8BcQkdEHdq4gL3cQ0KX
ZCgu0weDj4/DHojBGfIEXbf56p1xxtad3Tul/wH97SBRNQLbxqMKhF798JeQEzZ4
d6D0H2H8i9ZH7tii5ir08CaJULrXual0bBEDl96dwZXLECigugCzZBUCO4HW3a3p
fPJcOAWq4zcr4y9zRMXc6UwHo+DzXQT+8G1IUmTcHYOtRh0jCwX56NGmk3oIUhRk
Ycr23hL2NMoZXWwb2n1+b+B5K7Sf3AbVjYD6Mu/VtRn+lrDy2tnBPuxBFNHr376t
NvHvfhvA6yShfFKFdUt30+APrOlDzhv3CiyUeJBkJ4p98pB1CsEuU98CKeWL49nu
JigqBeaOPbb6+SJ7Y7gaTQG37QL0ND79NfKQgPxR2dGPgcxGKPtZ6QdEOVSrnwKZ
GM/dMyw0A9rSDLPoiiOVt0O8DtALtKF7GkH7f6dnRmI6EF9o41kcNsUMbeXA9YcS
Pd7hp3SX9ngt38uVimphThNKnI5WUksIl8MV9j0xl3BOIjb4hlEUjNGlAAe9Em5o
FgOB1edgjvPcWtafukSEGbF9feIH89GK8Y8Xqpo8BVFTdo1h7uPTbY87L47KZ1F8
SdEAwTIHPkc=
=hzQi
-----END PGP SIGNATURE-----

--=-LdxFQ9I8JgOig9EoTsSE--

