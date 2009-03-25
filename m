Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35020 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251AbZCYUSI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2009 16:18:08 -0400
Subject: Re: [PATCH v4 0/5] mac80211: beacon filtering
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Jouni Malinen <j@w1.fi>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <871vsl1i2q.fsf@litku.valot.fi> (sfid-20090325_210903_864239_7426B7FC)
References: <20090322195619.26460.48292.stgit@tikku>
	 <1237900276.4320.86.camel@johannes.local> <87iqly0ydm.fsf@litku.valot.fi>
	 <1237973445.4320.135.camel@johannes.local> <87eiwl1jo2.fsf@litku.valot.fi>
	 <1238010031.4320.164.camel@johannes.local>  <871vsl1i2q.fsf@litku.valot.fi>
	 (sfid-20090325_210903_864239_7426B7FC)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-CeIYObuReMDebsobAFfm"
Date: Wed, 25 Mar 2009 21:17:28 +0100
Message-Id: <1238012248.4320.172.camel@johannes.local> (sfid-20090325_211814_896078_74AAB21D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-CeIYObuReMDebsobAFfm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-03-25 at 22:08 +0200, Kalle Valo wrote:

> >> Do we have any knowledge how different hardware support beacon
> >> checksumming? I only know how stlc45xx does it.
> >
> > Not really... how about wl12xx?

> Name:       ACX_BEACON_FILTER_TABLE
>=20
> Desc: This information element configures beacon filtering handling
>       for the set of information elements. An information element in a
>       beacon can be set to be: ignored (never compared, and changes
>       will not cause beacon transfer), checked (compared, and
>       transferred in case of a change), or transferred (transferred to
>       the host for each appearance or disappearance).
>=20
>       The table contains all information elements that are subject to
>       monitoring for host transfer.
>=20
>       All information elements that are not in the table should be
>       ignored for monitoring.

Seems easy enough... Only concern is vendor IEs since we cannot ignore
them (WMM) but others might change frequently... oh well.

johannes

--=-CeIYObuReMDebsobAFfm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJypFSAAoJEKVg1VMiehFYoT4QAIq8jreGy7AzW9hR0FPCUVeQ
ulNB276lP5wXI/1FRXASDzG96fJ+mJOFVaINYWvrhrQhkYzvAlOl9nDyJemjneqx
QQWjUnfzL9KGY2td0K+hVwyrQ55kmFDWl3p0qIKFqQsIDfc2yZBSMDJOmj5+oF2Z
8LBoBDBf3dOBgubjyZJsAVbxkjfu5gq77AnJn0DX1Z7qkl1wqwF9IEB7beNNuMuM
ujlMfADICBIbghSxsSx8T+EcZENq0EYcXVD6syA6OGm2QQBijBOytGsqRaL4H4hV
uMIrHj4GuSCNl0MdQmGDU0GvFEdbOGUIr0Cx9OgwAAbSolEgPUQ/yVRLf7AyaP+o
0LMM12L2V0hzgcrN/WDTEs4v76NS/Jb9ykAT4K6/iDbArbqxlp4g5xAzWAPFrxET
8t2Kaz8DRdMGg8PDo6wVxHyRTvSAv0OIecCYsrUFvBfNRphuprrX2z9UcYYjYBTd
D0Cg7aHDQRPizBbxdh8TyLPoEEdRAzhpNz/QFTjim8JG5wbLo33RTHT0Ts3LVzct
Oab65LXBrJ3kYsmRYvRgU/9iyp1O1cXsruHUSYEpB/Gl4461sxbN4Ymjgn8HQ02j
A8cIphcNTdMyPx4ZTpDFP0lyc0D8afgVdu4P0L+tsG0V9Zxg5ZQwfN7oSYxHu+0/
ljjXFVfJrnTnCsz8dq6c
=sFs9
-----END PGP SIGNATURE-----

--=-CeIYObuReMDebsobAFfm--

