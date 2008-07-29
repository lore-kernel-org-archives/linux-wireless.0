Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48812 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332AbYG2M1f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 08:27:35 -0400
Subject: Re: iwlwifi aggregation info
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240807290525o41832ccei92ff554bef876b37@mail.gmail.com> (sfid-20080729_142558_246289_C169E16A)
References: <1217331138.10489.24.camel@johannes.berg>
	 <1217331408.10489.26.camel@johannes.berg>
	 <1ba2fa240807290525o41832ccei92ff554bef876b37@mail.gmail.com>
	 (sfid-20080729_142558_246289_C169E16A)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-BbhWi/GR12B9MpZoBkOE"
Date: Tue, 29 Jul 2008 14:27:32 +0200
Message-Id: <1217334452.10489.42.camel@johannes.berg> (sfid-20080729_142736_875110_ED00708A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-BbhWi/GR12B9MpZoBkOE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-07-29 at 15:25 +0300, Tomas Winkler wrote:

> > Never mind, the queue won't get reassigned. I was just confused by a
> > bunch of superfluous code in iwl-tx.c. You cannot ever run into having
> > IWL_EMPTYING_HW_QUEUE_ADDBA set because you wait for the queue to drain
> > before fully disabling it.
>=20
> Correct.

I suppose you won't mind me removing that particular code then? I'm
working on the agg refactoring right now.

johannes

--=-BbhWi/GR12B9MpZoBkOE
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIjwywAAoJEKVg1VMiehFYkXwP+gM1gfBLhOpglkD0KAaRtsmq
f/vZChebphSVfLEA9rDziTht9FhW7dXEWuOlT9TN0qyb6qLl5v5Lu9sAOMqFzLds
UMv/O17Rjq+WNDRLIK0uxQ2yXJ9GUPKrsLqByiw0j20Q9W24eLXYFzpoRTkNpx3n
3hHDysrE6SoNlnA1eDIVDNoFm637f5qXQb7lpL4HzyM1QLlMIzEwtexBeZkx6bhw
za5WgYgeTfIMT2oGD92+rjeBlp10bv0zXv3VunsKmYzxBgT+QJy1kIx8fdUetFPl
GkdYQHiOPg5wF54ZvVaMp4Oj87A66AiZJTxdLaWz5FkUTH2luIDziztt0gkXwTyV
t2owrhpqEAAwOGOcvu04VAzfNtz8W2LSQywngWMrSlFa3rPag1Ms1pj/Ns5INgJ4
O+cj22Gv+5icRLz1QTInoZivDpjOAphVGxcKlCaA6xM1dNBc9lYwcr1wku8q62CA
bo4Agd5O9Tn4KkoDHG/Hh8kjQyu/tY4yozc+9AuRKXkSXhklBpRCUMvrxjXonOIH
eoqSBA14LDPLxKlej1p7teL/px5r5zNxRGU4/0nhWWe+UN7aMRArgZBiS6FKC8Pl
cyGpbQRMxY9CKQDS3cNf2GXOwBR1xkKxQ0e5WOIfgG6qHOfs+4JH9ADVxyxC8xs5
RUtrmll0IHtEKxKDbAWC
=Sf5n
-----END PGP SIGNATURE-----

--=-BbhWi/GR12B9MpZoBkOE--

