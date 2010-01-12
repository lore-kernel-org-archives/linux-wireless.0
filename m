Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56980 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965Ab0ALKbc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2010 05:31:32 -0500
Subject: Re: [PATCH PATCH v6 1/7] mac80211: add U-APSD client support
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	a.young.jason@gmail.com
In-Reply-To: <20100112084231.27492.77457.stgit@tikku>
References: <20100112084059.27492.86738.stgit@tikku>
	 <20100112084231.27492.77457.stgit@tikku>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-bKx8FaVI8wNbvmkbjj1E"
Date: Tue, 12 Jan 2010 11:31:16 +0100
Message-ID: <1263292276.3583.15.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-bKx8FaVI8wNbvmkbjj1E
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2010-01-12 at 10:42 +0200, Kalle Valo wrote:

> + *
> + * @IEEE80211_HW_SUPPORTS_UAPSD:
> + *	Hardware supports Unscheduled Automatic Power Save Delivery
> + *	(U-APSD) in managed mode. The mode is configured with
> + *	conf_tx() operation.

I think a little more detail would be good here, for example adding that
it must support staying awake with just the frame triggering it, and
that it won't be asked to wake up by mac80211? Or will it, actually?
We've had that discussion with PS-poll so ...

johannes

--=-bKx8FaVI8wNbvmkbjj1E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLTE9wAAoJEODzc/N7+QmaIn4QAK+3Fo/EM0obg0kyo7WpVIgW
jLIgNb2Z+g2gKghdPeOlC6hoq2epKnmGBD+Agz/7/INO7uRRY1vvMv5F5RY4PqZc
iob5xPyU/FUjr1G9dGl9Y9lEiCG5pykxzLfjMcJVrNVGvmnribKAqFAqrCNRNsUw
ZnUVZuIq6VqadMzGHWeS+2t0fDOFiPN3nxEQ+2g/VOcxdpGcQ08p4bQvN7ShSBqG
erGcwcNa26ejx7VqPRYH3js2hBeQqRKIkgv26ivI+xFXNxzZLrym0KeRbrDaK8XK
eDmeQdvPrcyaZcKFlgE/sfE2CivwGdeRiJbQ9FPJYtwLosOr1Dvhy2YGGX0eCjCh
8908U4Dv1Wif7n/yFVVaAjh+LKo/oBxpbnMysaDI+Y5YNub4YqaVWl+MBku292MQ
DI85+SZAHBwnOhgOheunyuV9+PUN61k6qb4dW2VNuuXrEDNw/hw411eMq8qTH/0O
w2hT5RKhw50iYsDM4pGURzUDd1rjIAoNg+oRH2yw2+5UKEqtFlTsaoGAlmDgw/y8
nXO6z3HRx1LaLLfRRfGSJ9LxJr+CkBzSH5Zlg2eBEVV75HHUFIpvjvmG6Htccj66
m7BFLQSHT0dqdVHV08t12qWGbJKr3yElmizxBR5QNhcn0k+FQzXX3cZVVzrhDUb/
RTnsWziZd6p/ToYkJfp4
=O8Yx
-----END PGP SIGNATURE-----

--=-bKx8FaVI8wNbvmkbjj1E--

