Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33235 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763294AbXGRKaV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jul 2007 06:30:21 -0400
Subject: Re: [patch 3/5] A-MSDU Rx aggregation support
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: mabbas <mabbas@linux.intel.com>, linux-wireless@vger.kernel.org
In-Reply-To: <20070718000140.GA26907@tuxdriver.com>
References: <1174909200.1364.56.camel@dell-4965.jf.intel.com>
	 <1175111599.5151.123.camel@johannes.berg>
	 <46137FF2.6020203@linux.intel.com> <1182374019.3714.87.camel@johannes.berg>
	 <20070718000140.GA26907@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-1z5wYpwtZ1fAs5SDQWRo"
Date: Wed, 18 Jul 2007 12:29:57 +0200
Message-Id: <1184754598.4658.14.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1z5wYpwtZ1fAs5SDQWRo
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-07-17 at 20:01 -0400, John W. Linville wrote:

> > Here you allocate a new frame which can be sent back to the device when
> > one of the aggregated frames was a multicast frame and we're an AP
> > device. You also correctly add extra_tx_headroom, but it seems that thi=
s
> > is missing some skb_reserve(extra_tx_headroom), no? Could you make a
> > patch adding it? I'm not sure I fully understand the code there.
>=20
> Was there ever any reply to this?

I didn't get one but never double-checked the code either, the relevant
patches I had touching this have fallen off the list anyway :)

johannes

--=-1z5wYpwtZ1fAs5SDQWRo
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGneul/ETPhpq3jKURAqzZAJ4vpugP/6iK34C5rGoCzdy0e11p2ACdH4Nj
5BxjuYBg4xlkk6q6NaVHQY8=
=JijT
-----END PGP SIGNATURE-----

--=-1z5wYpwtZ1fAs5SDQWRo--

