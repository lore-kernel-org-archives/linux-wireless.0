Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40001 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887AbYAWRLW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jan 2008 12:11:22 -0500
Subject: Re: [PATCH] mac80211: enable IBSS merging
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Bruno Randolf <bruno@thinktube.com>,
	Michael Wu <flamingice@sourmilk.net>,
	ath5k-devel@lists.ath5k.org, jirislaby@gmail.com,
	mickflemm@gmail.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, Ulrich Kunitz <kune@deine-taler.de>,
	Daniel Drake <dsd@gentoo.org>
In-Reply-To: <200801201143.09488.IvDoorn@gmail.com> (sfid-20080120_104335_663754_C9E4538E)
References: <20080118125252.6455.41047.stgit@one>
	 <43e72e890801200217i7a7e5349uebf56d42c63cf48e@mail.gmail.com>
	 <200801201143.09488.IvDoorn@gmail.com>
	 (sfid-20080120_104335_663754_C9E4538E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-hv8Bi8jOtfwSHvPxMMQa"
Date: Wed, 23 Jan 2008 15:49:51 +0100
Message-Id: <1201099791.3454.19.camel@johannes.berg> (sfid-20080123_171128_654872_EEFBF7DC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-hv8Bi8jOtfwSHvPxMMQa
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Then there is a problem for rt2x00. Since the mactime isn't known.
> rt2400pci is the _only_ device which has a RX_END_TIME field in the
> RX descriptor.

I don't think it's required for IBSS to function, only for this from my
POV dubious "merge" functionality.

johannes

--=-hv8Bi8jOtfwSHvPxMMQa
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR5dUDaVg1VMiehFYAQIfng/6A9sRmILMZ8GHrr3sjIO+tfdhnwDLbahM
Vo6XSI/qY6xYaRl80uuZTUCZtTdRS2Qu2BFwWRKxbNoDlEiUidR7jnGG9Vmr3Ec/
k57WRrhhRAlQdltC9yRBb125PXkvmI35NKfA4hQXcGhANTPzPFwj7l7Z+1IDFRt/
/m6IWbdEuqJJD0q071VlmddqFeQHmtotFs+wmVT5zLyWLXD76BNlUFftioN2NuT9
/s5cF7SsxE9v4jlV7lA/asAvV1+EpqeBraG8k8Nrt9XvnWTw6MZozjvdgmgaAcy9
pYpxr0DB5mQ+C+2UOdSpRzLFQk6rVfCDPK5LFQqcK4RR/BPAQAm+Cyuct4n1T1x4
naYSCl8s3cJ2uF+ddEqP8dO6KtppD1oQvNtN8SNq2TeLsACGVeJjpH/1FLLA1O3F
aNoTHwYJc0DwOsw2Xxv6IygaAUaz89Ajq0IU/Q0NB/c0YX6LU+jyQkBoLuJRwKTb
7dzuTCBUMvySTi0rMRCKQGVBKCFbR4oGHsuf2y6uGRneUxUGx+G+zVP9Fjoy9hpI
WjFzTwoWKaK+AdTpN/hUJs7HDd9zgDeLDaczh/X5KQLXoyCQg2SDGJSgI1a/DRAN
s8m5sRL8jAAvPSkpW4yPfUozyZ0IYTDdhEgYkOgptMcPdEZy/OB5Hil1/bSOcure
dN0CyhPHubQ=
=FOKO
-----END PGP SIGNATURE-----

--=-hv8Bi8jOtfwSHvPxMMQa--

