Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51923 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbZH0Hkh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Aug 2009 03:40:37 -0400
Subject: Re: [PATCH] rt2x00: Cleanup rt2x00mac_bss_info_changed()
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200908262104.09230.IvDoorn@gmail.com>
References: <200908262104.09230.IvDoorn@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-GIAt924nnBmTN8hPR8I1"
Date: Thu, 27 Aug 2009 09:40:06 +0200
Message-Id: <1251358806.20531.9.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-GIAt924nnBmTN8hPR8I1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-08-26 at 21:04 +0200, Ivo van Doorn wrote:
> Since patch "rt2x00: bss_info_changed() callback is allowed to sleep" the
> variable delayed wasn't used anymore. This means it can be removed
> along with the call to schedule_work which depended on that variable.

I just wanted to say thanks for doing all the cleanups. It's really nice
to see all my work on making callbacks non-atomic pay off in that way :)

johannes

--=-GIAt924nnBmTN8hPR8I1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKljhSAAoJEODzc/N7+QmaNAEP/0DvZuvD4OE82bGoURDTlLWo
8RXuzs9ndtK3rpZpqq/8SDVYLovpowfILd1Ebk/QegI53waHYnM4wX3cLEZbg/NY
K37Ta791xxZ9T9/NqV+dV6CSLY3ebQNGplGkrzoMeaqaxO4XOS+WA01fLVGFw8kR
HNqHe04M+C2QB024EWdHggCXq4Wxrz+Ahu81jpLpUrnbiG07s9C8cisn7aSm9LzZ
Ke//Nvm8u9sZXZz3WH9jHEideomf01ovJ9T2KWiAgxtVvqayrsoYevmknoS5CGNy
zm6S8WSbGEt41MoqBV9ZYTp2XUirylpcSq4V+LPKYx5tryFbLK8iOhevwUkXAJpP
dPCgpLSusg9ZJXFxVJyweTXyfcHIvbM0CMM1cuvAQ0rZ2HeI4RTNmLpBgnSyn7iZ
fY6GwpjSM4riPMUSzD0ohKFZx2TtZwFQimPK2u7rW2Zq0ZtIqISWTLmixXsBJH2w
LCVDwMUDjWgpgFCIWpyDktUP+wCipio6D1v93PGRycHDt5LjjwXq4hk7Hk8WkFe9
v8nEjksCexXfhsCCCxWdEnvCp4yauZP5RZScFOv6sU6YdoY4wnRZHgPgSlOLNj+9
NopwUI7XZYDo5qCD3wwN8+zUOJJzL/ilfGlZrQZTXpqlKbAkJ7cpLsZ2DlzvNxQX
LijPQ2qPva8EgsKtNwnc
=FZjF
-----END PGP SIGNATURE-----

--=-GIAt924nnBmTN8hPR8I1--

