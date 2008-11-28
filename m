Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43401 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714AbYK1WP3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2008 17:15:29 -0500
Subject: Re: [RFC v3 3/4] mac80211: add IEEE80211_HW_NO_DYNAMIC_PS flag
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1227901784-5325-4-git-send-email-kalle.valo@nokia.com> (sfid-20081128_205010_097030_BDDD13FB)
References: <1227901784-5325-1-git-send-email-kalle.valo@nokia.com>
	 <1227901784-5325-4-git-send-email-kalle.valo@nokia.com>
	 (sfid-20081128_205010_097030_BDDD13FB)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-FhQ0s07d/oEzQLpdzAJy"
Date: Fri, 28 Nov 2008 23:15:25 +0100
Message-Id: <1227910525.3543.5.camel@johannes.berg> (sfid-20081128_231533_199095_2971E40D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-FhQ0s07d/oEzQLpdzAJy
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-11-28 at 21:49 +0200, Kalle Valo wrote:
> Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
> ---
>  include/net/mac80211.h |    1 +
>  net/mac80211/tx.c      |    3 ++-
>  2 files changed, 3 insertions(+), 1 deletions(-)
>=20
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 6a1d4ea..53a0dc5 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -858,6 +858,7 @@ enum ieee80211_hw_flags {
>  	IEEE80211_HW_NOISE_DBM				=3D 1<<8,
>  	IEEE80211_HW_SPECTRUM_MGMT			=3D 1<<9,
>  	IEEE80211_HW_AMPDU_AGGREGATION			=3D 1<<10,
> +	IEEE80211_HW_NO_DYNAMIC_PS			=3D 1<<11,

Add documentation please.

johannes

--=-FhQ0s07d/oEzQLpdzAJy
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJMG16AAoJEKVg1VMiehFYbC8P+wW6qilROQgkxL7HMo3Mbgba
vyIsaNRuQWqR3jQ6IV8ap+l6xu1IIcNnIsMV5g1OgXwEJc65EXhATw0UWCFmPCry
956/KcCuBPBu9B5TsSnFI8yrdtKZn2tX8DI7LA/bxJkZvcodKu6+JCFvJ75Cul+0
aw5CtDg6vpRnBHyKxdVjlh7LvJnUBSWTaeYL/kIl83+yViRClvGc390BkkSsdQu2
vHb7sdtSvV6Dp3VQKcpsn5fQIjHrF6+VX8cxrz+wCdf8KwmMks+z6pQDRLhESQM0
+axFOZhpc2FavFLG/ihDP27YP4JXqyX6lWWtmgnvI5nDFl10FO4seHkrP4rhBtrb
Mea311YE6QRlaWSEHp2Kj4wIFCH2ylvlz7WIqCcfja/tQkBe/j6COBrUTKSl0yOo
BPUGQgw+Lej/6qWFgWOoaIYr2MmsBh5uyUAfl3e/OJkPrfPnmtHk5/mGYEeODe9S
ige0s2nqKod3Gu1dm5NVcZrRt8iILVAZkOWWEl04V/P7F286LC4huyzvAkCvvBCA
a3wsVmfc6lmnUpEl7pmql/Y/+NITq29V7qsG1EYBCrJGgRTJzxFcnSbWlsqFUihj
PpN/AhHSYxKyVTTbssEIRnMSiEK06RM3uo0RTeikR/hIjBFSimSXrDGA4a/6ykGN
GUML1oNzvYjKV6AlJzNW
=3h7K
-----END PGP SIGNATURE-----

--=-FhQ0s07d/oEzQLpdzAJy--

