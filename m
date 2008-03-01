Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:44551 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755820AbYCAU4q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Mar 2008 15:56:46 -0500
Subject: Re: [PATCH] mac80211: always insert key into list
From: Johannes Berg <johannes@sipsolutions.net>
To: drago01 <drago01@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <f6ca9fed0803011057k5e2999e1vbb8d69a7306d6f29@mail.gmail.com> (sfid-20080301_185704_042703_F792CF5A)
References: <1204396338.3917.9.camel@johannes.berg>
	 <f6ca9fed0803011057k5e2999e1vbb8d69a7306d6f29@mail.gmail.com>
	 (sfid-20080301_185704_042703_F792CF5A)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-7mfaOTGUk5KYfPc1CLYg"
Date: Sat, 01 Mar 2008 21:56:33 +0100
Message-Id: <1204404993.3917.10.camel@johannes.berg> (sfid-20080301_205649_971183_D92D72B5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-7mfaOTGUk5KYfPc1CLYg
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Sat, 2008-03-01 at 19:57 +0100, drago01 wrote:
> On Sat, Mar 1, 2008 at 7:32 PM, Johannes Berg <johannes@sipsolutions.net>=
 wrote:
> > Today I hit one of my new WARN_ONs in the mac80211 code because
> >  a key wasn't being freed correctly. After wondering for a while
> >  I finally tracked it to the fact that STA keys aren't added to
> >  the per-sdata key list correctly, they are supposed to always be
> >  on that list, not just for default keys. This patch fixes that.
>=20
> can this be somehow related to the "wep decrypt failed" message that I
> get when using dynamic wep?
> (I didn't have time to create any additional debug info for it yet ...)

No, not at all.

johannes

--=-7mfaOTGUk5KYfPc1CLYg
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR8nDAKVg1VMiehFYAQLRFxAAslHp95TNYTPWd0En6vsEuExPghmXqzdP
ML3JQEyFkiggpjp2zninipndrNqrPjDBvdYujgpJlwybfrmm5SD7/ghBScPnSd7z
GLj3oFjBM1WNaAsHny7Ro/TZcv5xyxTej2qiZ6uLzMaRV7lpIWmpz2u3c9xBgENy
s0dvV7KQ5YoVPmg2NSmH0iRuC4+LLjxpeN5z971531hLfIqj3JTCphHtAzutLVFU
pkmF9FMyyu7f3wt2lC19PPXaK4FUxjgy7eaiZSCrh/hwN6rUt6XhjmFuLnN2BP6Z
6GR1hivM7g8qoyfG5geA4jBf01W6rJLYbbk2tH8CZec8W908sHziLWkldZRhx+hD
tjeCPopxDinSOKCuUXqHmO4PvCrnzBSKpe0bYB1oZpvzmQq8j3GqhwQKQvd9ycGj
7KnqLSZ5QTDSl0CTZ0QSxDpDGBpcCuHO5Z6BQPPHzu0MbsEfD9JlO/h0wS7pRQzA
s5af+/p/W7M1BQT0wzejZw/eSic6soIxCYOXdIMKj8dnHUCTNN8EA7czSaE4RSLY
BLwVaRf3eBkgb6hTP1PEw407IEP/+Q9Kq/gT4p9BwxaMAunm7dqZNEIEsGsGk2XH
rEQ1/M3N2f6+p4ZoD/RLP+HEyTGM+iTUQyKuxPfCuGrcCtZVRxhDAMGPoyRpwCkt
SiGoUomr9zY=
=SzKq
-----END PGP SIGNATURE-----

--=-7mfaOTGUk5KYfPc1CLYg--

