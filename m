Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60817 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbYLUT5e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Dec 2008 14:57:34 -0500
Subject: Re: [PATCH 2/2] p54: enable proper frame injection
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@web.de>
Cc: wireless <linux-wireless@vger.kernel.org>,
	John W Linville <linville@tuxdriver.com>
In-Reply-To: <200812212055.04707.chunkeey@web.de> (sfid-20081221_205514_615160_EFD85DCA)
References: <200812212055.04707.chunkeey@web.de>
	 (sfid-20081221_205514_615160_EFD85DCA)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-oRXbUIL9ouejsJYSFY+F"
Date: Sun, 21 Dec 2008 20:57:31 +0100
Message-Id: <1229889451.3050.12.camel@johannes> (sfid-20081221_205737_768895_C6843854)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-oRXbUIL9ouejsJYSFY+F
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-12-21 at 20:55 +0100, Christian Lamparter wrote:

> @@ -2145,6 +2188,7 @@ struct ieee80211_hw *p54_init_common(siz
> =20
>  	dev->wiphy->interface_modes =3D BIT(NL80211_IFTYPE_STATION) |
>  				      BIT(NL80211_IFTYPE_ADHOC) |
> +				      BIT(NL80211_IFTYPE_MONITOR) |

that's pointless, mac80211 adds that anyway.

johannes

--=-oRXbUIL9ouejsJYSFY+F
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJTp+oAAoJEKVg1VMiehFY4KYP/R9UMCzIg10nuCdcWlrax/q8
ASfnp9EOvT8Z0S2gGWumz+kg2dm4IsMri1oz30N6Gr6oG6cC5kiFQ95uQop4XnDr
EzqNJIcMhzDaTndqplcE7+hdge2YVxJ7VBWfWTDE5lWZ9gCQk5VxRTSPGzS+SFp4
ypirouiB75FMadcg3QvRzhOc67lHIgP6onLnUiC2Wx0jiPAb8R7hAF5XN4eHypr4
t2sc0oSehvk4pU8/+Ud4Dsz/NveCP8l3hRq/vUUR9dlxUSVIblOoX/UBu7JtM0tN
BCSKb7NRhl4MaAuckGcMRq2jAnl+PViIK7mylr7MzGsq1BXSesF5MyNqBxsg7wvz
tURwddW1x0POU9O2os1vZjBmNLkidmaOjHo45BLAfWn/vXx/f10hi8WgLnTYXrLl
BhpA2EZ5lrUBZodEfMI/Cn+ZLQMENUbk7zuqFAOaNdwrb6I5ZxugXX7soUbNV2Sp
9f45nVQJQFHZMG86vwBBO7naqZX/y4e5BIHsws9gcOFar7lj9x8RaKLhLMxMP5xk
oCOuY5dcRUCtuuSaQOBY1hLK/LiIQMHmVegNn9oI2IH5xb9w3mm0Jn5L26A9GTaF
k5FC16cb9FPZRYsw2eGqgp7O0vCDAz9aeeOpxztPbanrh7mgkD08UTbVflTTfL3y
kTw77JawhdfYHUOOKzxZ
=1xzU
-----END PGP SIGNATURE-----

--=-oRXbUIL9ouejsJYSFY+F--

