Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57706 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030180AbXCBVeH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2007 16:34:07 -0500
Subject: Re: [PATCH] move per-netdev and key stuff to debugfs
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1172869853.8247.12.camel@johannes.berg>
References: <1172852882.8247.2.camel@johannes.berg>
	 <1172869853.8247.12.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-IYDRiJOqImPO16dg7hnF"
Date: Fri, 02 Mar 2007 22:33:34 +0100
Message-Id: <1172871214.8247.15.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-IYDRiJOqImPO16dg7hnF
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-03-02 at 22:10 +0100, Johannes Berg wrote:
> Found a small bug and did some cleanups, I'll post a link to the series
> to not spam you with these huge patches again.

Here we go:
http://johannes.sipsolutions.net/patches/mac80211-debugfs/

It relies on
	[PATCH] add privid field to wiphy

and applies after bluetape's patches.

I've tested association, a key, the default_key symlink works, and some
more. I couldn't really test per-sta keys since I don't run an AP but
I'm pretty sure they should be fine.

johannes

--=-IYDRiJOqImPO16dg7hnF
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF6Jgu/ETPhpq3jKURAqntAJ48w/dCm6TbQv7dKNRtk2w19U85pgCeJs9f
16GKZXzliRwXZnwy1LYSH08=
=ETNb
-----END PGP SIGNATURE-----

--=-IYDRiJOqImPO16dg7hnF--

