Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41190 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754594AbYLGSn4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Dec 2008 13:43:56 -0500
Subject: Re: [RFT] mac80211: fix HT channel selection
From: Johannes Berg <johannes@sipsolutions.net>
To: Mats Johannesson <spamcan1@abrasax.se>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Tomas Winkler <tomasw@gmail.com>
In-Reply-To: <20081207193826.3f2e1772@loke.fish.not>
References: <1228667447.22164.46.camel@johannes.berg>
	 <20081207193826.3f2e1772@loke.fish.not>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-QDFSnMm+S892rGAveB9x"
Date: Sun, 07 Dec 2008 19:43:53 +0100
Message-Id: <1228675433.22164.56.camel@johannes.berg> (sfid-20081207_194404_571238_1906BA1E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QDFSnMm+S892rGAveB9x
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-12-07 at 19:38 +0100, Mats Johannesson wrote:
> On Sun, 07 Dec 2008 17:30:46 +0100 Johannes Berg wrote:
> > HT management is done differently for AP and STA modes, unify
> > to just the ->config() callback since HT is fundamentally a
> > PHY property and cannot be per-BSS.
> >=20
> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> > ---
> > Please test. Mats, this might fix your problem (if it applies on top
> > of the patch that fixes the panic)
>=20
> Crazy results. Made two 2.6.28-rc7-wl kernels with different outcomes:

Ok, strange, but I don't know enough about ath9k to help you, sorry.

johannes

--=-QDFSnMm+S892rGAveB9x
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJPBllAAoJEKVg1VMiehFYmHYP/iOxkQdlmtl8Aj7YmOm+OXEh
XuHhhuvpdIS0lRlbLZzEipK4ch52i9LlOhop+q1dHvxG7tyJYuapZ91lAU6RFP63
Oqy9RxPPqxr8iiSRtooluGMqPkwBMI6b9onlTza4ptPdzW5sNBMFdtSiHB3JnH41
fCyY2Ctdrqx/rlGM5TlN/cfkxa4PBR4boGNi77JNl0dY0bhHQN1QeOJNMdh+Dt39
TLQhJ36kKMPNl3WIl9bO+ciFa97RRFxJ9oCVkSCdpxbwwUfOoXlttvFT6GdOisZF
JqOVH/1uh6ROsyDFV6fNSnS7/c4a+1N8VgVsfka8/eTOaq2RNlysfP3LrIYF8gBH
KoJFcHVLKwGUOdAbCGCZRnAnZMZLzkKymyC8ks/8/3OMZ3Ko2B1PEdz9OOWU5q+g
RTHckNQkbeiyHkghZUUwMkEsW6HejGfFoOQsTYmk7iyW/aI1iRmazMeBMQqoHplF
IQ4drl1+M+btHR4zXjbmKpgCd+0HT3h8gvz4g8Nyh2+VxapPWMah2UH1TzZrv/z3
V7LQPH/CIpaRfwSwsUdhoKEGlEln0IOK8Aze8tJbZYhcDZeRuvZxcDptsc+J3lFG
XVKUiZ4zBQJ/mXA/kUbxR9ZyaOC2Q4d+ODuoS83vwmzLLx57OY/cG0/kst5HQdEf
2P/+MNkHwL8HFndgGyj/
=JI1F
-----END PGP SIGNATURE-----

--=-QDFSnMm+S892rGAveB9x--

