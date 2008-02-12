Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37228 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760424AbYBLLdu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2008 06:33:50 -0500
Subject: Re: [PATCH] mac80211: Extend filter flag documentation about
	unsupported flags
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200802111825.42078.mb@bu3sch.de> (sfid-20080211_172712_872245_EEF7EB2B)
References: <200802111825.42078.mb@bu3sch.de>
	 (sfid-20080211_172712_872245_EEF7EB2B)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-RK3B9LMuOz9RLeOzR8i8"
Date: Tue, 12 Feb 2008 12:33:43 +0100
Message-Id: <1202816024.8931.4.camel@johannes.berg> (sfid-20080212_113353_753249_5B58D9D3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-RK3B9LMuOz9RLeOzR8i8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> + * All unsupported flags in @total_flags must be cleared.
> + * Hardware does not support a flag if it is incapable of _passing_
> + * the frame to the stack. Otherwise it must simply ignore the flag,
> + * but not clear it.

I think mentioning the driver is important:

"Otherwise the driver must ignore the flag but not clear it."

> + * So for example, you should clear @FIF_CONTROL, if your hardware
> + * always filters control frames. If your hardware does always pass

s/does always pass/always passes/

Other than that,

Acked-by: Johannes Berg <johannes@sipsolutions.net>

so please add that when you resend.

johannes

--=-RK3B9LMuOz9RLeOzR8i8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR7GEFqVg1VMiehFYAQLOkw/8D4e+CGLIorZaBmMIpo6w6iH5XspBxQ/j
TDlPxcosv6+QduI4+PgGWhQ64rqfdmCjoCY2S0TqMgAxNWLxvBy2TP9RA9uy/2TC
lOJYeCFGi5SuC6zXZoglh5ZpaK8bknNepb8eneRCfSYWdXs8OBH4ncO0nLlChcCE
X0y9wxmp37Su5Oa1klQzawRsq7GDVxZwGrw0aRDXwxcifEnGOXttG3qP+mTrUFBf
V2GTasWjvXq2JrHY/oVgmY128bsMC1gcjyYZfhx5KOBQFegPo05m6XoB/QIuZ3EF
oRGpT1/mC0WBcS1G4JBYjm3bhVWxE//KGEsHlfYYaQINqhjBhlfQwtMkr+gDD3DI
gj7xJ5e4v3O0FHBAcxQsG3ndlLh8gs2E2fEHUW+68YYO+GsLNt6P1TVA3EeRLdN+
Z+CH0ZqKfIUK0Bh+y6TUJgRT3mCcBPB4dsJpyBRldX0uQHNrcU0WOhfRYK3QJ5mB
RRJurZROjVaENnMVWBJ0Y3JwqoAg8T3Y5PpLD4BEBUX8AYtW58HmC9eIdqhMcGz2
PZO7QTwVvSpTXK81Gpf5muJHFLan3vFk2iEcUm0mRVA8u/ROT7aRegbvwJUr0Ijt
7BIoOV95K4BB0b3yIKUGa71bSUgJoXwremEHCdUy43AYaSUnsONDZ4BrKbdgCqaZ
CeoydX52ih8=
=E6wx
-----END PGP SIGNATURE-----

--=-RK3B9LMuOz9RLeOzR8i8--

