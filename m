Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58883 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782Ab0AEJvH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2010 04:51:07 -0500
Subject: Re: [RFC PATCH v5 0/7] mac80211 client U-APSD support
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org, a.young.jason@gmail.com
In-Reply-To: <20091231133626.29899.95683.stgit@tikku>
References: <20091231133626.29899.95683.stgit@tikku>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-sOrGlV1+ssaSqayig5BY"
Date: Tue, 05 Jan 2010 10:51:01 +0100
Message-ID: <1262685061.21956.2.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-sOrGlV1+ssaSqayig5BY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-12-31 at 15:37 +0200, Kalle Valo wrote:
> Hello,
>=20
> here is my proposal how to add U-APSD client support to mac80211. I
> also included example driver implementation for wl1251.
>=20
> Please comment. Also I would like to get comments how U-APSD needs to
> be implemented in different hardware.

Looks ok to me (very few comments inline), but I haven't researched
Intel hardware yet.

johannes

--=-sOrGlV1+ssaSqayig5BY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLQwt/AAoJEODzc/N7+QmasPUQAJdaBaCy0pVQ5oT1BqIGtDDT
imZ8f0eBtCGijOUXFVQdGwf04Vu7bquD8zCXzP3t6H0AvG9+MbIiNYTmQNq0X6XJ
ueyo02Vnmvy5N10BmYGwAWQfaTmV4ehAirZRK+/Je7CC3z2ZUMKD/f6a91MgawvW
oQITjJNKr5frIqvcIrtCDvWmWRoANrwGjOU8ydz0dZDWhn34snjDlca8Jd1MMSZL
Js4Fgjempkfu8HI/AqYEMe5Z7DaE47WjU2i2E3tsbJqVp+1X+bxeNdgFKnQeSdVl
+lF+nggYPeMYc4+wjyb1xjjTidqAerlyMWbm9f56ZQRXA31p9wJxOFXqUVyJP5fL
/VtC/NdWxBY4bdOhmtRleAK/7iia0KmXv87bonwm7pSDlToYerd711F2Qoq5a0UW
5r5Om2g/oINWwH/jq4cBpGXRnofQ8sP9ciFdqREAET34vM5UChFu+DZlxyV4Jt/P
ywmcil8psLgUTF37afkZBBGPRECRi9CG96o94mpg0XRPhnYN+z434c6jUBz3mlK8
d/tAemMN1tQXv7cQTyoqkXwodXkczWGs/bCM3oVoKNZYwAfCsd0yQOQf4wa28YGS
SK/qVPYKnU4xPQAlHnDgqAmODtFLzahmCxmg56QqnVekSA4q8jDqUK0QYTupFsoO
S0/u5fnj6keb4XMt8Wu9
=cGxe
-----END PGP SIGNATURE-----

--=-sOrGlV1+ssaSqayig5BY--

