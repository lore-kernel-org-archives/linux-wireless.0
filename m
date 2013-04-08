Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from contumacia.investici.org ([178.255.144.35]:57444 "EHLO
	contumacia.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935156Ab3DHSd4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Apr 2013 14:33:56 -0400
Date: Mon, 8 Apr 2013 20:32:31 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wirelss <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>
Subject: Re: [PATCH 3/6] mac80211: ieee80211_queue_stopped returns reasons
Message-ID: <20130408183231.GD5938@ritirata.org> (sfid-20130408_203400_282369_371D8282)
References: <1365444377-9959-1-git-send-email-thomas@cozybit.com>
 <1365444377-9959-3-git-send-email-thomas@cozybit.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="xJK8B5Wah2CMJs8h"
In-Reply-To: <1365444377-9959-3-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--xJK8B5Wah2CMJs8h
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Thomas,

On Mon, Apr 08, 2013 at 11:06:14AM -0700, Thomas Pedersen wrote:
> Have ieee80211_queue_stopped() return a bitmap of enum
> queue_stop_reasons while checking queue status. This is
> handy when we care about the queue stop reason codes.
>=20
> Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
> ---
>  include/net/mac80211.h |   10 +++++++---
>  net/mac80211/util.c    |    8 ++++----
>  2 files changed, 11 insertions(+), 7 deletions(-)
>=20
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 64faf01..8bbe799 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -3589,15 +3589,19 @@ void ieee80211_stop_queue(struct ieee80211_hw *hw=
, int queue);
> =20
>  /**
>   * ieee80211_queue_stopped - test status of the queue
> + *

I think you added this new line by mistake.

Cheers,


--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--xJK8B5Wah2CMJs8h
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJRYw0/AAoJEADl0hg6qKeOL2QP/R/nMfzs/gimqpgWzD03ZmGO
aD/nOgnj4K6ZXErPZKmK/xCZmFVl3TgyrxwXKEHPM0Li8G3nsJ3KNUNeXGdJH/oU
Lezcc14yIHlAjjJVAmhmJrlG3fiVjt/jjDqLZmVLOyBNEqZSmtRqaplI/adR1PU7
zlHJZ3ktWYC3+0G6wJyDwa1MR1l1HU84IPvY/ye2VgkSBv5+W0sjLIQWlRA2QYCX
hW1GWxn5hPdmpTUihAGWNMkG/kdrolWbn+PeM9gVoZlPXa6K9nBsrzPucl58Qlab
JRls1vObXuWdw51l0dRqpE5EVINJQWmNP7c1nqNi95pIXqDgI5dQKZjua5yNeBeg
VBHGxHUCJh/ZVNpdhEda3yb4BVZcn8VP2yKGIFB/jRyVqO8r4i6Z7PquLT5q3C2I
zyUKeAFH617BPQIasY75UvDNzmM0iDIBHyZgkPrqSDeRpf3nZxBd/nLDncWdNnJ7
aq7BLSn6B6mhFTo9AZA63dTP3rg+fCQ7ORun0dnE4BRwl22tj3Co1/HYgfytxFkB
Q+iQrE4oe+mcy+Z4yDkQOg9cXl7I/R24LAfVo7DrkNavjDfYqMzrGF2723NcgA6H
FxwZW1zm8OAB1NUbPthN7v0c+UDCF9bZZm0IhYKKfaWi0R7uwuTXmbIyA5d+ZMXH
rk1A74bHw1LHMeUGa1KB
=nnI7
-----END PGP SIGNATURE-----

--xJK8B5Wah2CMJs8h--
