Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:44540 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbXIAJXC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Sep 2007 05:23:02 -0400
Subject: Re: [PATCH] mac80211: get STA after tx radiotap snipped
From: Johannes Berg <johannes@sipsolutions.net>
To: warmcat <andy@warmcat.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20070901090244.7234.51990.stgit@localhost>
References: <20070901090244.7234.51990.stgit@localhost>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jA7zVf2eM+oYwqRqMo8t"
Date: Sat, 01 Sep 2007 11:24:19 +0200
Message-Id: <1188638659.7585.126.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jA7zVf2eM+oYwqRqMo8t
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-09-01 at 10:02 +0100, warmcat wrote:
> Johannes Berg noticed that in __ieee80211_tx_prepare() we try to get the
> STA from addr1 of the ieee80211 header when the radiotap header is actual=
ly
> still at the front of the packet.  This patch defers doing that until the
> radiotap header is gone.

looks good to me, thanks, will adopt for mac80211 unless somebody else
wants to?

johannes

--=-jA7zVf2eM+oYwqRqMo8t
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG2S/D/ETPhpq3jKURAhhzAJ49tz73Mk49a1h+1WygW71c1vgzXwCdFlgr
NG0fDLJ8U1HR+JpD0jvyq2c=
=Raxp
-----END PGP SIGNATURE-----

--=-jA7zVf2eM+oYwqRqMo8t--

