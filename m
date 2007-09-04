Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51389 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068AbXIDNmj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Sep 2007 09:42:39 -0400
Subject: Re: port of my recent patches to net-2.6.24
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Michael Wu <flamingice@sourmilk.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jiri Benc <jbenc@suse.cz>, Jiri Slaby <jirislaby@gmail.com>
In-Reply-To: <20070904002002.GU1835@jm.kir.nu>
References: <1188027470.9529.5.camel@johannes.berg>
	 <200708270029.35845.flamingice@sourmilk.net>
	 <1188211612.6756.8.camel@johannes.berg>  <20070904002002.GU1835@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/dtmSw00/eM7/nPjlAH4"
Date: Tue, 04 Sep 2007 15:43:22 +0200
Message-Id: <1188913402.9942.18.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/dtmSw00/eM7/nPjlAH4
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-09-03 at 17:20 -0700, Jouni Malinen wrote:

> For the original reason for adding this (making it easier to do some
> continuous TX tests), yes, it can be done in other ways. The only thing
> I can think of here would be some special frames (like broadcast data
> frames as a beacon of some upper layer service) that would be used by
> clients that are capable of receiving frames when not associated (e.g.,
> they use monitor mode). This is getting a bit speculative here, so
> unless someone can point out a real example that depends on this,=20

This sounds like something that Andy was working on with radiotap
injection etc. Penumbra.

> I
> would go ahead and remove it now.

I think it's already gone.

johannes

--=-/dtmSw00/eM7/nPjlAH4
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG3WD6/ETPhpq3jKURAi0kAJ43RjypVsbQ3qbmyorIv1VAE1Q2owCdEotI
raagXOO5AvR/sfhBDibE79I=
=hhnq
-----END PGP SIGNATURE-----

--=-/dtmSw00/eM7/nPjlAH4--

