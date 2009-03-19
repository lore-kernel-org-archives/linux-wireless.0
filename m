Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40036 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbZCSSp3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2009 14:45:29 -0400
Subject: Re: [PATCH 1/4] mac80211: Fix a typo in assoc vs. reassoc check
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni.malinen@atheros.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090319114756.833749085@atheros.com>
References: <20090319113918.555693846@atheros.com>
	 <20090319114756.833749085@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-gnHbNETAklK7PaI8L552"
Date: Thu, 19 Mar 2009 19:45:23 +0100
Message-Id: <1237488323.5100.101.camel@johannes.local> (sfid-20090319_194532_599101_A7E4E73C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-gnHbNETAklK7PaI8L552
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-03-19 at 13:39 +0200, Jouni Malinen wrote:
> plain text document attachment (mac80211-mlme-typo.patch)
> Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/mac80211/mlme.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> --- uml.orig/net/mac80211/mlme.c	2009-03-19 00:18:40.000000000 +0200
> +++ uml/net/mac80211/mlme.c	2009-03-19 00:18:57.000000000 +0200
> @@ -103,7 +103,7 @@ static void ieee80211_send_assoc(struct=20
>  	u32 rates =3D 0;
>  	size_t e_ies_len;
> =20
> -	if (ifmgd->flags & IEEE80211_IBSS_PREV_BSSID_SET) {
> +	if (ifmgd->flags & IEEE80211_STA_PREV_BSSID_SET) {
>  		e_ies =3D sdata->u.mgd.ie_reassocreq;
>  		e_ies_len =3D sdata->u.mgd.ie_reassocreq_len;
>  	} else {
>=20
> --=20
>=20

--=-gnHbNETAklK7PaI8L552
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJwpLBAAoJEKVg1VMiehFY1DAP/3WfrgMHAgr3xrPJGyTLgj3n
HTl+6368pnyk7BIMlxgEVXqGXFbqTGWFF35jdS50maoAPXXfOS08RIdGHzuaHcjP
cueDPDBoDWwZR+A1vZlUqRPSNUbC/8G1npqoWFW+FndCueKj1/6sxr97SjCJDQGf
KvEMCGMnAHvQFbcgeKg0e0YGNZ9V/8Rnsn1MdspxQQWnUCDK9qEBVXmQHfwbQsxb
ei7lf9FCYOZRsOm75+NpEMq+dFOjXdnYwpH/ABhy3yvscBID7tVxMdx0MjF7I0Na
VbCVmzbdgFMHyxRgJdG2fZeI5/r8KqoWSqulSn4iLFzS8P2gOfqlD/8mW5DIWn1C
Ckjjau9sz1IAOB09vBJQ6OAGbLJteobOoBv+vx4VEZnpYOmBqevKvPzO6g1lzseh
ykN/ykzM20ScMNi2tOR86S4OnmD7RgsAUKCsGkyVfASp2pULP5+OlImGTxTOE2RK
efi+Lc6se9c4VRScfZu4K2CDIT0OXYOeTWRZIS0hdJfZSlLiH8/QSSB3zlm9iuCI
0UYz0S5emCxMgCWDHLiDfxf/mTWDQ5LUNr6ImPvYImoX35U2SyXd9TBbfCDoddJ+
RjuBuh9qZumlgLPp+DET6cMi748W8f6LANXM5VsPAItzkS9FGdjxIR6NE4dxYodY
ssLsFfHmrjMcsfA0TN89
=dAeC
-----END PGP SIGNATURE-----

--=-gnHbNETAklK7PaI8L552--

