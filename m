Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35303 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbZCJHV1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2009 03:21:27 -0400
Subject: Re: [PATCH] mac80211: ieee80211_ibss_commit() cleanup
From: Johannes Berg <johannes@sipsolutions.net>
To: Alina Friedrichsen <x-alina@gmx.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <20090309234946.99940@gmx.net> (sfid-20090310_005017_999744_57F45C40)
References: <20090309234946.99940@gmx.net>
	 (sfid-20090310_005017_999744_57F45C40)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-RVIXk49d4GyJD3N3cJS6"
Date: Tue, 10 Mar 2009 08:21:22 +0100
Message-Id: <1236669682.9658.34.camel@johannes.local> (sfid-20090310_082130_262932_E46F87D4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-RVIXk49d4GyJD3N3cJS6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-03-10 at 00:49 +0100, Alina Friedrichsen wrote:
> Don't call ieee80211_sta_find_ibss() directly, like it's done in STA
> mode, so that the commit() call is more harmless respectively has less
> site-effects.

And now to explain why this is desired? Are you going to post "commit"
patches again that I will reject?

johannes

--=-RVIXk49d4GyJD3N3cJS6
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJthTwAAoJEKVg1VMiehFYnewP/i80M617P54IBjBCE4nqoKP3
IljwnbfBAeqsl5/NmfDEDV8uptziW5b9AmCxFe2arMMYD4AmztfCBbOWYEy6xRDW
T442609u+LYE4DZafMRs08QfBRwEHhZAx88L/Cah70CYJGfwzb8/LHUQ/w/b8zPm
k3LbklTR7uidziDuY4DGW+XBsxatIxolh28SVxVzvcAAzij0UpyVYslr1QcpF+2h
C5zKt5ud9CJ297Ch1GJ+18St5OLMIDLAA7UucxECyiDW0H2ylRWHiIoUYPeQZxcg
MPY+soC1QVUDBdV5Nmd9hYD5lRFvDGXc/O9GsoUFoY1kmhvQ9Ux96zCgeWNDJh6U
izsvuzNEuTc/OGzSTY+6SqJXguJ0kyZRxCOBbcVz+deuRWtAADqdYvDXSelDSOwt
ka+jKGnON7NIl8h0OWrB6o+lLq0RXAoAIUsq2pso5MdGzUyV7NFFOLnMt3SnUrWJ
XsQW7mH1+OECFtuU3h7qjkRsgiPbbJsVPfshUfnuGkMW+vNB9E8C30KJjHk9+h1H
D6QbxHspgD3jVkiFzbpLgVBbgWLrm8AAMulJqx5HZJsusqZ3kz1zLMajIU1GunwE
MILtBkJN2LUR5Hd1h92Ionr5N7WlDDHTWlxS+u5Qr9Ij8MWb42EgD/mvI+nYKe2n
hdQBqnLnnKnUw48bFFHg
=c/1I
-----END PGP SIGNATURE-----

--=-RVIXk49d4GyJD3N3cJS6--

