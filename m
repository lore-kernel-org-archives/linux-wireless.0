Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:41663 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbXJJL3x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2007 07:29:53 -0400
Subject: Re: rt2500pci 2.0.9 not working
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcus Better <marcus@better.se>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <feibbk$de1$1@sea.gmane.org> (sfid-20071010_120403_687462_921C8576)
References: <fdqhn4$qab$1@sea.gmane.org> <fei4sd$mm0$1@sea.gmane.org>
	 <1192008384.12541.8.camel@johannes.berg> <fei71k$tu7$1@sea.gmane.org>
	 <1192009901.12541.15.camel@johannes.berg>   <feibbk$de1$1@sea.gmane.org>
	 (sfid-20071010_120403_687462_921C8576)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-SJkf9+lwkNwpjoNyi8Xw"
Date: Wed, 10 Oct 2007 13:30:48 +0200
Message-Id: <1192015848.12541.20.camel@johannes.berg> (sfid-20071010_123000_124462_80C8748A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-SJkf9+lwkNwpjoNyi8Xw
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-10-10 at 12:56 +0200, Marcus Better wrote:
> Johannes Berg wrote:
> > Looking at the code... Ahh, I see. You've selected the B mode instead o=
f
> > G and the AP requires G. I think my "[PATCH] mac80211: fix set_channel
> > regression" will fix this for you.
>=20
> No, I still get the same result.

The same error 19? That's weird because if you select a G mode we do
advertise short slot/short preamble.

johannes

--=-SJkf9+lwkNwpjoNyi8Xw
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARwy356Vg1VMiehFYAQJ9yw/6AiF3pGAjkcQgH0ko/pClbrs0bt5nx5t1
EI3bMfhI0ZGf3KSmcXD0C5bIy70QWZ7iJg3JRAssPEN8hTDE+rars3nUj83grA4W
mkLgWPxYP0DWSNvDUlgUj60aJMLypxrc+LPX1QGQrekOIEqje3SA1TWjF7PdrUR5
1Fe/Jzw2pOBsSmy+r20TcwMW9xzZrN9SPXNqqWrG+XehSbGGn5+uiUkfdbCeBlxT
oIrYMtP+BKu0jFqXgBq90A1SM0bmPS/UTxsAOph76FsLlEB+3pgp2iPE7nIJa/qY
9C7FucBR/rE+iOFiQhW0c/iiQmzffbB1pYfTYqHyU+8za/sOUbA6bkpuAeCvXnc4
J1irTZpwuJ+xUCwDwkgBBUNkksJYmGl/mJH4hqBOUezLM158mV/R5k2k4ol9WuYn
i7IkQ4uiWbQaU7ikqqfdwgXQEUWpo71zkFZs5TwDFgvE2xybk5l4HEXp4jatFyK2
JUNESSgADnPKST2X20iOr5xptzB5W0phc7I2tMLsQg32FC+LmV8azTglE4sGyUDT
ixpWdqnop6NgBogfFscYlJA6R0mRfIeumMGk1KJupbz2KvMHBwdPFeiYkL6HyHSQ
dvjBKPG8omrxoU6PReJblSr+y0+JUFqzCuoOmryb6ZLs2EEMhyd7xADbjqIvxLLz
W8cAkF/r6Gs=
=Y7PC
-----END PGP SIGNATURE-----

--=-SJkf9+lwkNwpjoNyi8Xw--

