Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40886 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755986AbYJMXI0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Oct 2008 19:08:26 -0400
Subject: Re: [RFC/RFT] p54: Fix for big-endian architecture
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: Christian Lamparter <chunkeey@web.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1223939151.27769.3.camel@dv>
References: <48EE20FB.4060700@lwfinger.net>
	 <1223936680.10113.7.camel@johannes.berg> <1223937392.27118.2.camel@dv>
	 <200810140055.34065.chunkeey@web.de>  <1223938526.27118.6.camel@dv>
	 <1223939151.27769.3.camel@dv>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-nL92g0xXv0V033HbDxj2"
Date: Tue, 14 Oct 2008 01:07:51 +0200
Message-Id: <1223939271.10113.10.camel@johannes.berg> (sfid-20081014_010828_539926_CA333E01)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-nL92g0xXv0V033HbDxj2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-13 at 19:05 -0400, Pavel Roskin wrote:

> And if I set rx_status.rate_idx to 0, I still get that badness for the
> same reason (status->rate_idx =3D 12, sband->n_bitrates =3D 8). =20

??
That's not right, if you set rx_status.rate_idx to 0 status->rate_idx
should be 0 :)

> Also, there
> is another badness reported sometimes:

That's new. On a whim I decided that I wanted to know why config() had a
return value ;) Will see why p54 makes it fail, maybe there's a mac80211
bug.

johannes

--=-nL92g0xXv0V033HbDxj2
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI89TDAAoJEKVg1VMiehFYGYsP/0LoobCquny+hhfVsL/zwG1P
Gf6ElRBWwcGXRqlAKj8ar/Z8McZ9lnF4M+RdWp9vXNl7fpYNAUXOZ8FHPJVWtJdo
gU9MCRm+XHTRc6HwuZZFVc9ItS+Kis80uU8nd6ie9cXJvrhN79si+mUeZFbU+Sbo
I21PgA7FLTp6+lZ7597PmuYsfgwEhN6kx/fDVkpomBP64E91UlCjDlcIfiKGCN/v
cUluDFSvM1dMUs9zTsvHhuuyBiNfSczqqsOtKhTloVYGFN29g3K6JjfoGKQ9TO+7
UZpDQ8g+yeqxtmFYm0WC1rah5sbRZw+IWEXuXVVJxc9KK4KnMsNZgcc7xhKRwY78
R2d7ZvO7+c5MO4Z79eQFNM8K6mxSeGl0rpiMQUkkiKSPrtl2pXqUayYBpc4MwYxq
TH5ZYMl7GM3211DgHLva1C52CoJpTgER2MyKvMBe7BVDh9nP4JAwjoWquV719jsG
O8A8IgP5pWmtV/sgZyt+UGq/BgWK1Gh2xE2KyzzM21cMFTmKZceHadgxPFoXZDVU
88/grCFgJaTo8A8ZdcBrmfvtEIfcXsf/UzLjVY0HN5kURlFsIYHvv+x9KcG9sqAU
3M50ZISgvhcNl0Bi7n3EHoYcJs3iBKI6D6xm+PeIwJalTNPTzYlsWkK0oHdy6cCO
Q4ouomfkl8u6jI0w4FAH
=HVf4
-----END PGP SIGNATURE-----

--=-nL92g0xXv0V033HbDxj2--

