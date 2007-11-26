Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50079 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853AbXKZQ3x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 11:29:53 -0500
Subject: Re: [PATCH 04/15] mac80211: adding 802.11n IEs handling
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com
In-Reply-To: <1196086490284-git-send-email-ron.rindjunsky@intel.com>
References: <11960864823402-git-send-email-ron.rindjunsky@intel.com>
	 <1196086490284-git-send-email-ron.rindjunsky@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-y9fr82MUDp686FN7Axzc"
Date: Mon, 26 Nov 2007 17:29:46 +0100
Message-Id: <1196094586.4149.297.camel@johannes.berg> (sfid-20071126_162955_838491_1BCF4F03)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-y9fr82MUDp686FN7Axzc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Mon, 2007-11-26 at 16:14 +0200, Ron Rindjunsky wrote:
> This patch presents the ability to parse and compose HT IEs, and to put
> the IE relevant data inside the mac80211's internal HT structures
>=20
> Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>

Looks good.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
> index 9e5b3a9..9caf124 100644
> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -89,6 +89,8 @@ struct ieee80211_sta_bss {
>  	size_t rsn_ie_len;
>  	u8 *wmm_ie;
>  	size_t wmm_ie_len;
> +	u8 *ht_ie;
> +	size_t ht_ie_len;

At some point we probably should reorder the fields here to avoid all
the padding... Not in this patch though, of course.

johannes

--=-y9fr82MUDp686FN7Axzc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0r0eaVg1VMiehFYAQJc3w/+MhaQs1YirlcUi1wPtMiIk3wA3cCNl9Zu
82yVTTqlp4eOqOwVE4fSsUtoXRNtF2Q3xA9moDoq3IEgD2eCAn6a0/eFGwNNBRl9
jJmq/dUL427RkICsE6i4++pEyaO37hKB1odz4/21BM2UomvDdNYcLeMBlo15Il5o
OydGo7vLfKoqw6LaJkmR/ZZD39YpEoNnrpyNeJTRHcZ5KK5ZmmufqRPjHuvM5Com
gxmmUOn+y8/oQyCna7Zt7xnCcXmAvQ4wRuGJfC6Q75R6xy/Hesp7Yo+nAedOz7Cg
bmG6IfDgoxifYXFJdISrLoj0UJDOpOc84KxJ2PAhFUwFz3SF3NuVqZ9DCt87aGQ6
1szc8F8VkN1Wo1vHvtfijEkupuB3IL7l8lVzyWXFkuon2q0yNH7evBgk4iea0gPX
q8mtMV0HsYnjTj2mi8s0w1K5x7b5HXExIHoInrogKSe0sCpL+7+m2PhZ+dQtKNcR
/Fuzat3U6jp+uXGzbPXryN51GKU23bRCMs2WjoPDTM9CLnGqzaA98ZmLVRDEe1Ao
MPo7k8BTS5nCe+ie2Y++QvaTsR+As7ZY6r23+je1soNGPt6VOjVlCMs+7AHRdYYa
hC7qWwQ14lMIEzEmuO7Z2vY6gCBjLjB9AVg3a54OcQ4ZBovXTxjrr8asI2VyMf32
oSCEIyl6d5M=
=UCAb
-----END PGP SIGNATURE-----

--=-y9fr82MUDp686FN7Axzc--

