Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:48484 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758686AbXGRQA0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jul 2007 12:00:26 -0400
Subject: Re: [patch 3/5] A-MSDU Rx aggregation support
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	mabbas <mabbas@linux.intel.com>, linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240707180622p791168eax4fae712641e24cc4@mail.gmail.com>
References: <1174909200.1364.56.camel@dell-4965.jf.intel.com>
	 <1175111599.5151.123.camel@johannes.berg>
	 <46137FF2.6020203@linux.intel.com> <1182374019.3714.87.camel@johannes.berg>
	 <20070718000140.GA26907@tuxdriver.com>
	 <1184754598.4658.14.camel@johannes.berg>
	 <1ba2fa240707180622p791168eax4fae712641e24cc4@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-UUzkZe8J6PF29WKS1FWK"
Date: Wed, 18 Jul 2007 17:38:50 +0200
Message-Id: <1184773130.4002.0.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-UUzkZe8J6PF29WKS1FWK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-07-18 at 16:22 +0300, Tomas Winkler wrote:

> HT aggregtion is extension of QoS. Multicast and broadcast frames are
> not QoS frames and therefore such frames  want be incorporated into an
> A-MSDU.

Right. I do know what it is :)


> You also correctly add extra_tx_headroom, but it seems that this

Hm?

johannes

--=-UUzkZe8J6PF29WKS1FWK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGnjQK/ETPhpq3jKURAlk+AJ4q/CVD7xWTWNl78HXBaEZVe6/3TgCfd/E+
qUtCRLlNoOyJxl+zuUImZ5U=
=eMKN
-----END PGP SIGNATURE-----

--=-UUzkZe8J6PF29WKS1FWK--

