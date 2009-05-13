Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45760 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310AbZEMJzq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2009 05:55:46 -0400
Subject: Re: [RFC v2 3/5] cfg80211: add WoW support
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1242206461-30793-4-git-send-email-lrodriguez@atheros.com>
References: <1242206461-30793-1-git-send-email-lrodriguez@atheros.com>
	 <1242206461-30793-4-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-k4z+EJKZkFpj8OLTs3PW"
Date: Wed, 13 May 2009 11:55:15 +0200
Message-Id: <1242208515.29288.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-k4z+EJKZkFpj8OLTs3PW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-05-13 at 05:20 -0400, Luis R. Rodriguez wrote:

> +/**
> + * enum nl80211_wow_triggers - Wake-on-Wireless-LAN triggers
> + *
> + * NL80211_WOW_TRIGGER_MAGIC_PACKET: a wake signal will be sent to the
> + *     devices if a magic packet is received.
> + * NL80211_WOW_TRIGGER_BMISS: WoW signal will be sent to the device when
> + *     a beacon has been missed by the associated AP.
> + * NL80211_WOW_TRIGGER_LINK_CHANGE: a wake signal will be sent to
> + *     the device if a link change is detected on the device.
> + * NL80211_WOW_TRIGGER_USER_PATTERN: a wake sigal will be sent to the
> + *     device if a user configurable pattern is received by
> + *     the device.
> + */
> +enum nl80211_wow_triggers {
> +	NL80211_WOW_TRIGGER_MAGIC_PACKET	=3D 1 << 0,
> +	NL80211_WOW_TRIGGER_BMISS		=3D 1 << 1,
> +	NL80211_WOW_TRIGGER_LINK_CHANGE		=3D 1 << 2,
> +	NL80211_WOW_TRIGGER_PATTERN		=3D 1 << 3,
> +};

Seems like you need to have a way to set the pattern and magic packet?

johannes


--=-k4z+EJKZkFpj8OLTs3PW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKCpj+AAoJEODzc/N7+QmaiQcP/0Auv9RSaFHDVUohZCEe1nuo
GT7hgIUu/Fwf9CPwoTWV4GfqczBxzlDhfZd0We3hLEEfYjPql8MlzXkIuptqMmTZ
Cz5FgVZdVz2AA7oGueXCHicQsl9/yDf+/8ep8hGIECCmnSIl0J6iRTP/MfFzZdGv
z3CFE1MhkLU181hvXv5cQ9be6rDER3ZrrBaYBH01P0sjI3uE+P58Zdc/ly6R/92C
Zth5L5cr6jkLFZm71fMZhlu/EYddJAiZ8yL6KqFPYPJ5y4voICfFHf6VKYZV2hQt
iCsdrFU02Uj4qkGYAlZeHrn7C5zsF6/0RagVXCJ8XrDARD2LhsFMdq3gZcEp4jWH
nHOwv5zU0JsjFQX2nMUtfDEPKRll/cVj3nLrm23eMHH6CrNRoKnitr+RXfu8eet+
pC0Ng56q1Mf1px9je9wjYVBYsq0b2Y54IWRiWdjw0X2Mjk6He+eWTiZB36LGaq64
2goho3VLzjfiPAUSvi3dn2giVLuwEXKaGBdEhlr6kVpHoPpTL6XFBLiPlm5qSzyJ
2DWX2Hd1OC/lTAJSZscc6GRkPSHiX704YOINrnuCWx597BamaM5r5HPsMVdSHSTK
hkzvogYjzt2Q5tiyL843nWNxlsWhiQnsxDL0KVP17OP1pYKU4UvrrS041N5lBB/N
8fvL0xmtqRyxUjYQsylX
=3EMa
-----END PGP SIGNATURE-----

--=-k4z+EJKZkFpj8OLTs3PW--

