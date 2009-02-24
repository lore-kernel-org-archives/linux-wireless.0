Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35704 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913AbZBXCVf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2009 21:21:35 -0500
Subject: Re: [PATCH v2 2/5] cfg80211: enable 5 GHz world roaming channels
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1235193641-17993-3-git-send-email-lrodriguez@atheros.com>
References: <1235193641-17993-1-git-send-email-lrodriguez@atheros.com>
	 <1235193641-17993-3-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-w824wYHjzxvwqU5fBjo8"
Date: Mon, 23 Feb 2009 17:57:31 -0800
Message-Id: <1235440651.4455.49.camel@johannes.local> (sfid-20090224_032138_293426_AE74AEF3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-w824wYHjzxvwqU5fBjo8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-02-21 at 00:20 -0500, Luis R. Rodriguez wrote:
> The current static world regulatory domain is too restrictive,
> we can use some 5 GHz channels world wide so long as they do not
> touch frequencies which require DFS. The compromise is we must
> also enforce passive scanning and disallow usage of a mode of
> operation that beacons: (AP | IBSS | Mesh)

We should actually start enforcing no-mesh on those channels.

johannes

--=-w824wYHjzxvwqU5fBjo8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJo1QJAAoJEKVg1VMiehFYRkcQAKGDVP0ebsFaa0gNgt/lOP1T
NDROJjeK9msUS/T/9tRNjA7PWGMtfODXG8FCODUG3W4Yq1s3E+i7CT2Grcln0hxF
xhNBF9o00DR8SvXL0FHEjjBWhZ8t1W8C3zH1eN8kXn8GMivvoNaxL0i4o0I/Yuta
D+ZTkQtxgWLdLUVacjJZurY4iycQ6Mo7unhJv8xyFNSHiFYdp017r+D5HDjik8uR
zo4kSbuLm9pRk9V4U6f5vMaGCJ1z38exZAxCTHDu5Jzt3Kt0Bb71NGuWB8gnh0yR
wntsPLDrpKsT6Zm/RDXPrxO1hlPRe37hy2fC084vDkh0h/ZhRn8mgxZ1tboN21Br
CHWRKJE4mvZxgM9H/9rSPUa8Q46OmOMr4f9uSGkOW3Hvz26X1t39xqq0Ib7NxKMb
smNNI4V5PqR1FuCNl/y42JN+fI82yVUB6CYNNn7c0my4E2iAy+uCdsPgEIXj4vAR
MiWqxJevjfBgNSqTAnwajwhFav8JAmSIpjCRnKuhYAYHYpyMt2RBgyM4qgSkOJxL
X+C/aiOcnB+FKEBmtqJn0tOo1o/Z8mDYSs1t2Tnzk2WyPANPaOo47ZN2Dfyjh0ZD
+OuJUKNSL4wlPM3RqWaEgUPmy69x+RBUPn/ZeFNjW2MDYXWuRJ0EqzpWCCFUpTEy
HeAn+c4xfDaHb5X5jrd8
=91Ka
-----END PGP SIGNATURE-----

--=-w824wYHjzxvwqU5fBjo8--

