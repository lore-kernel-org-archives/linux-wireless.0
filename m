Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54347 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755399AbYKEL4b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2008 06:56:31 -0500
Subject: Re: [PATCH 1/7] cfg80211: mark negative frequencies as invalid
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1225853406-16322-2-git-send-email-lrodriguez@atheros.com>
References: <1225853406-16322-1-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-2-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-lFwQlmJrTD5mrHPSJpu+"
Date: Wed, 05 Nov 2008 12:56:29 +0100
Message-Id: <1225886189.3619.76.camel@johannes.berg> (sfid-20081105_125634_992650_127431CB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-lFwQlmJrTD5mrHPSJpu+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-11-04 at 18:50 -0800, Luis R. Rodriguez wrote:
> Regulatory rules with negative frequencies are now
> marked as invalid in is_valid_reg_rule().
>=20
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/wireless/reg.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index 4c7e39d..7a2ce27 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -330,7 +330,7 @@ static bool is_valid_reg_rule(const struct ieee80211_=
reg_rule *rule)
>  	const struct ieee80211_freq_range *freq_range =3D &rule->freq_range;
>  	u32 freq_diff;
> =20
> -	if (freq_range->start_freq_khz =3D=3D 0 || freq_range->end_freq_khz =3D=
=3D 0)
> +	if (freq_range->start_freq_khz <=3D 0 || freq_range->end_freq_khz <=3D =
0)
>  		return false;
> =20
>  	if (freq_range->start_freq_khz > freq_range->end_freq_khz)

--=-lFwQlmJrTD5mrHPSJpu+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJEYnpAAoJEKVg1VMiehFYE0UP/RHycQvuQdqFE+4xF4K6jQLn
YtNC53K1zV679rS/ML2eEVVLuR/VyLm9DuY+BVuTabahGBPL6TYLg4JRfBKWCscG
JrDLes6NR7ajEceIQ8UAVIR/C9Qdx+0MocV9X18SJQrHLQHPr1HpF66/AHm2F16I
d39rKUHkn/FaRu94bzhf33s24d7+k7iJbv5+fZjBdq3utNMEd1oqBZGlOBIYdHNj
zf/I3eFHjqpqovrkJgjQzHTCT4+KqOE+FZshkmsmqdZye4SGK25TgL0dXBqmpQZX
3ajB2MpKYDPPpoC6J7jox/Rv6bUTL+4PDCbptc+iWTPhht4g6kGe29mYEmakgrDo
SKx8/FZwZSLh5LZeHTB/kWIZojM0nTtQ9Dir5O/w6dyT+B3qTG8pAE4Mdd9BtCIB
KbPbcIeFbQtI+D3t39z7zPxwolHeV3vLz+hlX2ml9yPzLh/rSVp61wlrqLdWeJUZ
Di7au23LuRXy/Q3pq4Ql0MXU3uhLVJNm3PgkBsIHtUdmZ76ITXlxYj1vkQNPVY8f
WPFcgw1sh6By615e93YFgW4H0iicRSV9GKWsH7luz42dT5rgImoOyidU6omTImjb
DDbQuWio5FkL9UOjgKcpz2GLWnu363ypdCAa5LD3w84vlagmmxRg8cFaQ2jpq9it
VHYBXGWkvNrwi7NAK5eJ
=T4HO
-----END PGP SIGNATURE-----

--=-lFwQlmJrTD5mrHPSJpu+--

