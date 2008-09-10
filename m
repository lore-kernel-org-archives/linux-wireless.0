Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53275 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390AbYIJVjs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2008 17:39:48 -0400
Subject: Re: [PATCH 1/2] ath9k: Re-order functions in main.c
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Jouni Malinen <Jouni.Malinen@atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>
In-Reply-To: <43e72e890809101345i7b5ded8bnb7a8a4e7c16470ff@mail.gmail.com> (sfid-20080910_224544_602156_28B7FF6F)
References: <20080910131927.GA7779@vasanth-lnx.users.atheros.com>
	 <43e72e890809101345i7b5ded8bnb7a8a4e7c16470ff@mail.gmail.com>
	 (sfid-20080910_224544_602156_28B7FF6F)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-047yzPLQsVpEhx5IGddx"
Date: Wed, 10 Sep 2008 23:39:13 +0200
Message-Id: <1221082753.3804.47.camel@johannes.berg> (sfid-20080910_233951_772809_9FF5B80B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-047yzPLQsVpEhx5IGddx
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-09-10 at 13:45 -0700, Luis R. Rodriguez wrote:
> On Wed, Sep 10, 2008 at 6:19 AM, Vasanthakumar Thiagarajan
> <vasanth@atheros.com> wrote:
> > Some of the functions in main.c are re-ordered in such
> > a way that all local functions are defined before mac80211
> > and pci callbacks.
>=20
> Please split the re-ordering of functions into a separate patch to
> make it easier for review.

Huh? Wasn't this just the separate patch?

johannes

--=-047yzPLQsVpEhx5IGddx
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIyD59AAoJEKVg1VMiehFY19QQAKd4gWBrOvCcsvyWZmd+MPNa
Ghe4R5LQPiOtFabd0F6g5g4hQ14BsRmc0kSkxIkOdVvVtZsHNW3q27fcMPIs8zzO
wk3J+gOGYWoJaxZvVaU3df2anzlFiWQaERgkt0FsMPQfzl7NpE1OXlryfXa4Iang
5pdqWwVCbWnlKsyQJj8GwmPJ2p7guI7g82P7TIsCi6BRZYFPzrGk3EhZAFW81iGg
K6nWNe/tB9xjHZwP7nm/g+dIdjGkmu6RE/qgOVa5hnRowV/nKYuAsXTXgj30i6RT
H/uJai0by2WRf5EYe/oPXMopFJiGGy2eVJ4DHY8vhNOzHHuNxPjl2WLdKWS+xvqs
eNAXk4M3l7KX0NMjKGpmx3MNtYeYT7pxcbYi50c4dYHsZ28oxKIJipBS06dTveLi
g1tvDqwzZArhANQfZpGmTpFTgLB0JIxtwWkK+OVHaMg0BFQ1d/SXDAE5Lj9P3MJP
3facnZ0RO6n9C9AwWjz0g/5vkAB71qQp90WFdLrZ5IdPjV5/qTWGCvLl5gttyad3
EOMtC6VTWkF/NipsXy5QZqlaeBkzZvsgffuYDJUarYjHlRjEr/fpmHnQulIRW96+
/VkjJp1vAFujXmi6pyO2/8NgiJYSYhk1UqAkmCtMOPZZNzGJGwZt924szDnpltBO
mHG20mN9+CJE51OTl0LL
=pF57
-----END PGP SIGNATURE-----

--=-047yzPLQsVpEhx5IGddx--

