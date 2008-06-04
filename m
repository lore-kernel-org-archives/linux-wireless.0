Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56647 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758366AbYFDT2L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2008 15:28:11 -0400
Subject: Re: Regression (?) with wireless-testing and mainline 2.6.26-rcX
	kernels
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4846EB9D.1080303@lwfinger.net>
References: <4846EB9D.1080303@lwfinger.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mPTjO+LzviYweNsKq5Xu"
Date: Wed, 04 Jun 2008 21:27:16 +0200
Message-Id: <1212607636.14371.46.camel@johannes.berg> (sfid-20080604_212814_223542_187795A0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mPTjO+LzviYweNsKq5Xu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Larry,

> I have found what I think is a regression where b43 appears to be connect=
ed;=20
> however, no data can be transferred. Not very much information has been=20
> logged; however, I think it correlates with a switch from short to long=20
> barker preamble.

Interesting. Doesn't your AP support short preambles? That'd be the only
reason for anything going wrong here to actually break your connection.
hmm.

> Do you have any suggestions on what should be logged in=20
> ieee80211_handle_protect_preamb or any other mac80211 routine so that I c=
an=20
> isolate the problem? I use NM to control the connection and authenticatio=
n to=20
> a WPA-PSK TKIP network.

Well I guess you should log what state it changes to (maybe even in b43)
and at the same time monitor with say wireshark on a monitor interface
to see what the AP is announcing. Not sure really, I have a hard time
imagining this being the problem.

johannes

--=-mPTjO+LzviYweNsKq5Xu
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASEbsk6Vg1VMiehFYAQIBKxAAr6IjIsuy/nn6DOCwOU4nn3wbt60v2h/Y
swxKUsc3IhmP62wOnd/59KiSMnKBZEtN79xPcBM3WccSpPJA8oqEUG5YPOBnPhJ7
cilZ5EhlsrOzDwAQcIqC80/BrTo/nJR5y80M2trm0KYR8+l7Wclf2I/IPhoOrDVw
i5p9s1gBFW0GDDHy6q5ZuETq83IanENsn1aZy2+S2bf2v7RGUerTDYslJ3L5erPg
sBD7eitxmg9wvPg8dVFulgFUASq0qV8DK8cRzFYoEEo2pSdRNjhpz50GwNbNzxo/
DL3ArHD5ondoAClESyyAWsnK2tQvWpdGUIoL4mSD/m941b++Rf0Ieh8d++snV+32
gxj06LSgoC6gnTyc5G2zhXytcv65BCFOru3OGNa4hc8IipBK+NeQnmpalOAMZwG0
gu0mYs7+rjXywtGy2nrbK9zM3uYO2wVaRCUDLg9roTqfNwqmFUC7O3BoLDMWwm0Y
mRBj/PUKHhsooSAe9ok6RFOC4cVGnvfGjv5YBYKCpipmOQrNcK0fLdTedvKSSofM
kM2KCC+iKgGB3JM93sgQ16NYxrPIbQVP58D8P+hW8OiwC9dld8Jhn9sJdVK4rGJW
6IEayd61HhpcDu7lIOFASMHfTi3nPsulv8XfceWwKJmf8CpkX5eMYspKd9ctOMr5
yUNZXt7NR3w=
=2ouY
-----END PGP SIGNATURE-----

--=-mPTjO+LzviYweNsKq5Xu--

