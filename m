Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59244 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763693AbYEHPFm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 May 2008 11:05:42 -0400
Subject: Re: 015-mac80211-tx-info-skb-cb.patch
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200805081710.03869.IvDoorn@gmail.com> (sfid-20080508_170026_206395_174B3092)
References: <200805081503.41025.IvDoorn@gmail.com>
	 <200805081657.27976.IvDoorn@gmail.com>
	 <1210258216.3547.56.camel@johannes.berg>
	 <200805081710.03869.IvDoorn@gmail.com>
	 (sfid-20080508_170026_206395_174B3092)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-5JBIGSi8t6y/s3pPQVz+"
Date: Thu, 08 May 2008 17:05:30 +0200
Message-Id: <1210259130.3547.59.camel@johannes.berg> (sfid-20080508_170502_222337_7BAC745B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-5JBIGSi8t6y/s3pPQVz+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > Right :) I'm pretty much done with the skb->cb conversion too except fo=
r
> > ath5k (nick) and rt2x00 (you)
>=20
> I'm going to rebase rt2x00.git this weekend to update from wireless-testi=
ng,
> since the skb->cb patches now depends on HW crypto which is not ready
> for upstream yet, I am going to reverse the patch order so the skb->cb pa=
tches
> and some other updates can go upstream more easily.

Cool, thanks. If you have a single patch that can pretty much go into
wireless-testing you can send it to me and I'll roll it into my patch.
If it depends on another rt2x00 merge then just let me know, I can wait
with this. I'd like to do it soonish though, it removes ~200 lines of
code (touching roughly 1000) and a lot of kmemdup/memcpy/kmalloc calls.

I'm just rebasing things a bit myself as well so I can give people a
patch to test.

johannes

--=-5JBIGSi8t6y/s3pPQVz+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASCMWuaVg1VMiehFYAQIiwhAAnngx8FckAj2Xrgsfv/4P0ZSUviDd5xFG
wnHX8FfV9KyAeU7JLJLBDN2liud9iRBYkw1c3v42E/jVwlc7FHB78GjdEDWKYbIw
ymeS8B2uzZA3sgeYRq1kAIJVDrGga7qKE+tK8QJDj3fuB37S+ewg3v6s4okbfyKk
2FLTwEYGYvkRJddlbisVKjZWzT5eYQlSSlUF1oNw/xo/0Jk0NOGo6Y16CKJ59uf5
JiQwEaGJbdblG/nclm9y9PZhj+ykbIH2dVeJhJ5axfCha3h3suzL5TiEcWt8m+R9
e63tGbq3WfemQPGFbuYjePrySHLR4Df6wULnZyk2m17zPkQzHS2louer8/VP8eMv
9B+QcaVgNWLaMTRBIkKdt/2DIiRnN/WmNChp27Y1N5KYogjA9EdbQGcy+/uEm6ye
CjjRTMAs8y1LugVsHptBFMJxOg9JxnDwVHKXtCiCBf/V2IBVFm0zfK3J8S1L6O+l
dQZhJgJRWRGoqHMxmIA8LVNR24PiKwvTiHxBJLfR53mrs2jO1nsUP43x93OKLUPs
OynqinlW1Gb6ClJEYAyNKOTyvFWzzKcXctGI/bAwMxcmSPt8724JbNjI39qGa8eT
e49nOs4ikNPiOAWuGpRkirC7cjV7llx4HAF2Hg2WbcyKoGAyKd8dkiBtlQHuI3Gq
l31BFTjfRYU=
=KvRe
-----END PGP SIGNATURE-----

--=-5JBIGSi8t6y/s3pPQVz+--

