Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42455 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932899AbXH2MIA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Aug 2007 08:08:00 -0400
Subject: Re: [PATCH] Fix breakage on WEP for cards that rely on software  decoding
From: Johannes Berg <johannes@sipsolutions.net>
To: Adam Baker <adam@baker-net.org.uk>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	rt2400-devel@lists.sourceforge.net
In-Reply-To: <200708282345.53016.adam@baker-net.org.uk>
References: <200708282345.53016.adam@baker-net.org.uk>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-gGKiO3WPzphk4+D9povW"
Date: Wed, 29 Aug 2007 14:09:42 +0200
Message-Id: <1188389382.19891.12.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-gGKiO3WPzphk4+D9povW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-08-28 at 23:45 +0100, Adam Baker wrote:
> The test to drop out of ieee80211_rx_h_load_key if we don't know the IV s=
hould
> check if the packet has already been decrypted, otherwise we need to load
> the key to be able to decrypt it

I think this patch ought to fix it as well:
http://johannes.sipsolutions.net/patches/kernel/all/2007-08-29-12:08/023-re=
work-hardware-crypto-flags.patch

but it should probably have a few more changes.

johannes

--=-gGKiO3WPzphk4+D9povW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG1WIG/ETPhpq3jKURAtyUAJ0b5QGAzRtNeCtwp6ANbRvFP0/1IwCeJ095
q9SByYkfTosG/aYLzivzjaU=
=KoMF
-----END PGP SIGNATURE-----

--=-gGKiO3WPzphk4+D9povW--

