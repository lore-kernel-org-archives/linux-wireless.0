Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51721 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899AbXK0ONo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2007 09:13:44 -0500
Subject: Re: [RFC/T][PATCH][V3] mac80211: Exponential moving average
	estimate for rc80211_simple
From: Johannes Berg <johannes@sipsolutions.net>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <1196112605.8318.6.camel@localhost> (sfid-20071126_213044_416915_EDBE20FD)
References: <1196112605.8318.6.camel@localhost>
	 (sfid-20071126_213044_416915_EDBE20FD)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-f/uOGEA3qX8FsjBCGQqP"
Date: Tue, 27 Nov 2007 15:13:34 +0100
Message-Id: <1196172814.6058.23.camel@johannes.berg> (sfid-20071127_141348_000748_0A331296)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-f/uOGEA3qX8FsjBCGQqP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Mon, 2007-11-26 at 22:30 +0100, Mattias Nissler wrote:
> This changes rc80211_simple failed frame percentage estimation to use an
> exponential moving average method. Failed frames percentage is sampled ov=
er
> time and a smoothed average is computed. This average is examined periodi=
cally
> and the rate adjusted eventually.
>=20
> Compared to the old method this new approach is much more responsive. The=
 old
> method used plain tx success/failure counters. This made rate control ver=
y
> unresponsive after a short time of using the interface, since old data wo=
uldn't
> age properly.

Sounds sane and better than before. If it works we can apply this I
guess.

johannes

--=-f/uOGEA3qX8FsjBCGQqP
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0wmDaVg1VMiehFYAQIIzQ//cESKDahfMvLKfreuxxij2Lafl7+nBEus
4W/9Pk+UxJbITG+NO4E66hMU5h7r8vTS1ZV+DdR97IVeCEy6jJxnCS2ZA7s1iGnv
5UUj2/3cRlQafbkKGSaGWcUJj6NILgzgTwC6sVAy18XEG42r41dAE1X9lqLXKGVD
k2a3JF+fonljbbi3qARtn/lTJbOvfHEYEDGwVHX8cVa+6VkFRBl5Hj2/YtD2q4ub
uENjXm1B8qbzan5UddgSpinlG7YvsbY6LriBEnydk3Zr0ivlYoSqgKEnD4FjOiJF
TSIc7vlJIxmakQgkPY/ppaxBAPrnv+i+DAS1RsxE8sL42K0sORWMBvOrw+NTGjFO
EIsfeD0fpYD5RmaGluw9COp82esjZ3aEXA0uvyfhNghJCox6kvIf3Sral2nxaL8k
3wKq8kQl0l3zkz8Xs+kh/8vdBPPRC8eSTC0ETxAU8/QhLwzlx+R2z4qeb8Hq/nIq
AW/mMhOGeEhKGh5DEhh2+6NV4ct3+R/fMOrYMFPmlDN1sm7ginY98IM0z3rXNUb9
lMibsMSq5XMSbuDhWQKTwYq78dsGxPr+2Dd6XHt/6xhQJN6QnH7ai/pi9NgVyZhE
rbmPYnSBjnH6p92YUfw/TK2hV199+tHEJ9K9761nEHAktPtux2KafOH4IhUfpmm2
iD5FPD6u5ks=
=W6tp
-----END PGP SIGNATURE-----

--=-f/uOGEA3qX8FsjBCGQqP--

