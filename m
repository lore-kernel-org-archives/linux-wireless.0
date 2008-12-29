Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37267 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbYL2Q2s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Dec 2008 11:28:48 -0500
Subject: Re: [PATCH] mac80211: Add IWSPY support to mac80211 stack
From: Johannes Berg <johannes@sipsolutions.net>
To: Ville Nuorvala <ville.nuorvala@gmail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1230567920-16623-1-git-send-email-ville.nuorvala@gmail.com> (sfid-20081229_172527_880563_CC561A41)
References: <1230567920-16623-1-git-send-email-ville.nuorvala@gmail.com>
	 (sfid-20081229_172527_880563_CC561A41)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-HntM1XC/vfKoq2Qwd4vC"
Date: Mon, 29 Dec 2008 17:29:11 +0100
Message-Id: <1230568151.3116.63.camel@johannes> (sfid-20081229_172852_232432_0AC49248)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-HntM1XC/vfKoq2Qwd4vC
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-12-29 at 18:25 +0200, Ville Nuorvala wrote:
> The IWSPY ioctls and netlink events were supported in the old ieee80211
> stack. This patch adds them to mac80211.

missing very long explanation as to why this is needed

As far as I can tell, nobody uses iwspy support or could possibly want
it the way it is done.

johannes

--=-HntM1XC/vfKoq2Qwd4vC
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJWPrTAAoJEKVg1VMiehFYsQkP/0qcdBmVGn9+p5GVJhAm1qgu
kLhzOtRZ3XI7XYph95elaorwKU/fyliuVcvLV/CwZnIg8qztCPGjaFgcmHojHP6K
zSB/NdT30/7TdP0yq5KsF/RPcGn8uMSYeNgKufog6ges4wB4ZCmdtClGDxLnzSQM
bsixa/4cUKA4zMiDcOKTZHN3v2+HaV0o+krkRqXq6ImpH9uPkbXlYLGPmKjMOv+7
lrEUyDCCySJ/cyNsVtfMWVV3HeD/PEbRj6ZKd8tevGDb5HOPgbc+LGC+wEoqZX5K
okKDTMvZfEONnjd+F5nsFo84QaC6/NMDhHWCKXwV2dMThHTIUuZFyoJ/t9kEhJpq
pY1IFmNjjfVDqOsrZDDK8rnBWIEkMfwl9rj5fSfO3SM8m7ukiXXn0zQBrqM/cYC+
yaZYn5m1d8DgNl09N7gd5B7betXE3ysCFAYCD+q5tvSnDVrbwt+/nNtpNUuISLzA
/JWJLhFsgkBCoayU/Qlg2SdlVaUsCvHceyLmqMHtpM0KHL6x4/Xt/iwl6fdr/UL7
SiVjdmNeOxI1Zr7AGDf72Cw4cJzDvnB0Sio9bs4bE81PIl3rORNlRGk/RkzTppt5
UX36ikOO0OVkmrtgA+YD3lDnZZ+uCap4cC8tVE4P02dXVtfB2juAxup+cEwfaFmt
NI8ZoO8ZiSNZyr8gH3AE
=I1Sw
-----END PGP SIGNATURE-----

--=-HntM1XC/vfKoq2Qwd4vC--

