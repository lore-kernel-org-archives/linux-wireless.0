Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56211 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655AbZCYTlL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2009 15:41:11 -0400
Subject: Re: [PATCH v4 0/5] mac80211: beacon filtering
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Jouni Malinen <j@w1.fi>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <87eiwl1jo2.fsf@litku.valot.fi> (sfid-20090325_203441_242100_4CF900B0)
References: <20090322195619.26460.48292.stgit@tikku>
	 <1237900276.4320.86.camel@johannes.local> <87iqly0ydm.fsf@litku.valot.fi>
	 <1237973445.4320.135.camel@johannes.local>  <87eiwl1jo2.fsf@litku.valot.fi>
	 (sfid-20090325_203441_242100_4CF900B0)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-d9QzdrPzQDtQTP0XcJ4t"
Date: Wed, 25 Mar 2009 20:40:31 +0100
Message-Id: <1238010031.4320.164.camel@johannes.local> (sfid-20090325_204117_704846_3DBB751B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-d9QzdrPzQDtQTP0XcJ4t
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-03-25 at 21:34 +0200, Kalle Valo wrote:

> > It has to be dynamic, no? Much of the information in there would be
> > things wpa_supplicant is only interested in. If it was just the kernel
> > code -- yes, we could just have a static list somewhere -- but much of
> > the 11k things for instance are only useful for wpa_supplicant.
>=20
> But if we already know what wpa_supplicant needs, can't we do the
> first implementation with a static list? Sure, the dynamic list is
> something we should aim for.

True. The userspace part is easy to add though, just make it part of the
assoc() nl80211 command. So we just need the static list for the
mac80211 part.

> Do we have any knowledge how different hardware support beacon
> checksumming? I only know how stlc45xx does it.

Not really... how about wl12xx?

johannes

--=-d9QzdrPzQDtQTP0XcJ4t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJyoitAAoJEKVg1VMiehFYdr8P/3moGhghnqmGY5VnqlhM+UQP
LHSf8VEPN6+Stum83lJItAljyWOFDLnatpaAiqbAa+gj92l0ZS+U/5hXBRkHsVVk
+PmLPy+niUs+bkH0zetLR1ECrSrjT67+CRD2Fj2lMvxSRBohS7VCmiV/Tavc4f2x
QG9HO5lttQz3CM7CSN/JUzS0HtFyPUr2tVO0Pr7d3E9Uhchj5MRToh+336qGp0TD
cZwtfZjHWFl7KDPgdeTMtD4K4unFCWnpjY4Ak9UlIJbyOcvB0R2VgCaybmbqQrP4
S0F5ZVpdz2v8H0CRd+H2sgsU+LomoDaj49F4wVOdMwWn7rt4b4y8/lNbla8pb24z
E8UbNll2RYBbRueR3W7w1e9czUCn9BJCQuesI2WUxGa/pl/6nOEnzMZ9+Hoeno9D
WyRNCmXBLdOY+lBFJuebbpMWK8TBpE3FmMA1mnG3jy+sTa/KIwxqUKZnhwIFTy3G
JyBmpIXwgz915y/YwVln4pucsQezlTYysEBvAel8ahW/Te+t0WM0PDpeR7l3Wfcw
JiVRomU0Egf1CnlF8slvlY1P0FhCmBocnM2lh7Q8YnT9A0Ai9jizRQ8IPkGRXmzV
iTZ/SQPKr4Uu3E5PT7WqiCP2nNMr2YfvAAz7uwzh+0YwKMBpQ1+4ajJRM6JK9Zk1
t02x2NpEyEZtYkgKemB6
=qU05
-----END PGP SIGNATURE-----

--=-d9QzdrPzQDtQTP0XcJ4t--

