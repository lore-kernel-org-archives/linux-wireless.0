Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58943 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764792AbXJZVJa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2007 17:09:30 -0400
Subject: Re: [PATCH] mac80211: reorder association debug output
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: stable@kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <1193432681145-git-send-email-linville@tuxdriver.com>
References: <11934326793639-git-send-email-linville@tuxdriver.com>
	 <11934326801557-git-send-email-linville@tuxdriver.com>
	 <11934326803769-git-send-email-linville@tuxdriver.com>
	 <11934326803330-git-send-email-linville@tuxdriver.com>
	 <11934326811535-git-send-email-linville@tuxdriver.com>
	 <11934326813508-git-send-email-linville@tuxdriver.com>
	 <1193432681145-git-send-email-linville@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-kUu3PQLQKNTQR3ebS8oq"
Date: Fri, 26 Oct 2007 23:10:39 +0200
Message-Id: <1193433039.15686.12.camel@johannes.berg> (sfid-20071026_220947_274037_599952B8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-kUu3PQLQKNTQR3ebS8oq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Fri, 2007-10-26 at 17:04 -0400, John W. Linville wrote:
> From: Johannes Berg <johannes@sipsolutions.net>
>=20
> There's no reason to warn about an invalid AID field when the
> association was denied.

I don't really see a reason to have this in stable, do we really want
that? And if so, we should roll in the fix for the warning :)

johannes

--=-kUu3PQLQKNTQR3ebS8oq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARyJXzqVg1VMiehFYAQL//A//c6gVwxD1NB9BfI8funClj/I26zVmUIDu
d5ObDM1atq0z0x9T5cUPmwmMlvLRUnYfjTaxZxxk2MImu7ou/vZ2ixIQZT3rDOHg
jqPUGDYCVlEHWz0G76ob/Ltizo/R1hTyKHqRoGA6KmTmfWT+6JrAikHjbDClMwxT
OMXdAVgwAq7ejZrlWaFal/59BAitbHah2PADXPuS28l6y3PwHW8K/kFfS/5UXXDm
hZgnzQ5G8ua66nanItIGaCBcnOtxN8uG9Rui1DAEsPxPXxNDTTvsuZcI9vSvKtDE
Mzpwi9gqhe4L2vE11E3CIEW5FmPU7hMQB7tkfYLd0dkg2y6nYMyLl57NGOsUGSvv
/xKgfMsr3s/P2Qqa5+wKGUgkmVHn6rRVohrWHfkWwAnHZh56td2TelhVkJCBrsXn
r2l9wM/2MiVYnhAefDN0YcKzj+a3b9Z049rSMKdp6Mazj5/GOvfEkIsPcdXAljei
Y2xjR5Mh3LeljC2QisSNJk59vvGAi49B1+KaxmAC1gtlgGyMOzGjqUvpg6VSaZuG
JkyJX5H2g05kXaogB8BfEKLqMoICtYflhTVz/fUgBfJ1e/oOfWD73O/lerNj8Ygu
GGFlNv8L8UvT0HUSm3lrjvij3GqhYNW2fYY+TmbsnFWvp8pOtWsUira1h4nhfGmm
+9M214/Cyqw=
=ieey
-----END PGP SIGNATURE-----

--=-kUu3PQLQKNTQR3ebS8oq--

