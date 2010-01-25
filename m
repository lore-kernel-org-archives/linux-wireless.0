Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36321 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920Ab0AYSgu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2010 13:36:50 -0500
Subject: Re: [PATCH v3 1/1] mac80211: tell driver when dtim change detected
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>, wey-yi.w.guy@intel.com,
	linux-wireless@vger.kernel.org, Kalle Valo <kalle.valo@nokia.com>
In-Reply-To: <20100125183224.GA19528@jm.kir.nu>
References: <1264109996-15995-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1264186981.2593.10.camel@johannes.local>
	 <43e72e891001221120i79c6525bo4852cb5a6c7a37@mail.gmail.com>
	 <1264189560.2593.14.camel@johannes.local>
	 <43e72e891001221544j1b1bd67ao8dfcf4d0dd12dd81@mail.gmail.com>
	 <20100125183224.GA19528@jm.kir.nu>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-PNnA5pJyFYGacS0a++ji"
Date: Mon, 25 Jan 2010 19:36:44 +0100
Message-ID: <1264444604.23766.55.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-PNnA5pJyFYGacS0a++ji
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2010-01-25 at 10:32 -0800, Jouni Malinen wrote:

> Anyway, that is just asking for
> problems due to the way a specific timestamps are defined to be used for
> the beacons that are followed by buffered multicast/broadcast frames.

That's actually an interesting point -- does anyone implement that
properly, or is that just a side note in the standard nobody even reads?
We certainly don't in mac80211 since we don't have that level of
synchronisation between the TSF and the beacon get function.

johannes


--=-PNnA5pJyFYGacS0a++ji
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLXeS5AAoJEODzc/N7+QmaMWkQAKokVhiIhIGYfG05JhmSz/cj
Hmv1iVdISoe+KTSNbXBejpd7xbMRQlw2F75Y8nsnxANig5OoznsifPUC5XVaXdd2
7G8uiuLDuqAoMCPnVl2ZmbCCBm63ihF66dk0jBvE3JuUblNF5GoBfs4L3XBMMAtJ
FcFUpn/haAP9iKvxJf/x4t51aimSze9VPHzxPUgnEUmkkZ2lB4/Ctb7kcxS7EPzN
RXGd0E+Y7gN95seUuG28CdhtG/15ZLs6KM1Afg0q69DPXVPPzp7kWENf+w0Pna8R
ycLvlmThbe6Tpmk9z7cX/DStROJmLXYyJl/l+t2jZs+EqLayRO9o81EnoK+4GTcg
3y6tFRo+nKACbkdcLUl9oda1hqxjCnNwU3f6twyJnpSAY7BB8NoElrymmG6wX4mR
c76oG/maLlcdVPEG13S7NCBNEA4RmNm4/fMRRtl7CkYZV+ur7Cxb7soT4hrLsCuT
cPlriBuI23ccFDx34Ae7Q34oxtUbWVb3Hy7Lz0XTOo6FEkd436rtPe7LzTdkL5GM
Pah8ub2jhHY193KTtNz0ilfOyiNxatisp5Y3AmCrlCoqZgfctRTAEX/zWu8wv6jq
YyOE8W7F26J4tdYCsnPfVpK2tIKdemlZAcBbBlgT8FKrYM5LLtSa6KicGHhCSVp8
veBYrQOvZ5f2GmdVecft
=4e+u
-----END PGP SIGNATURE-----

--=-PNnA5pJyFYGacS0a++ji--

