Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:48355 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756082AbXGRQ53 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jul 2007 12:57:29 -0400
Subject: Re: [patch 3/5] A-MSDU Rx aggregation support
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	mabbas <mabbas@linux.intel.com>, linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240707180851y22ead404g1c87d73903e939e3@mail.gmail.com>
References: <1174909200.1364.56.camel@dell-4965.jf.intel.com>
	 <1175111599.5151.123.camel@johannes.berg>
	 <46137FF2.6020203@linux.intel.com> <1182374019.3714.87.camel@johannes.berg>
	 <20070718000140.GA26907@tuxdriver.com>
	 <1184754598.4658.14.camel@johannes.berg>
	 <1ba2fa240707180622p791168eax4fae712641e24cc4@mail.gmail.com>
	 <1ba2fa240707180851y22ead404g1c87d73903e939e3@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Dior/f6L5D5Z2vPpfKym"
Date: Wed, 18 Jul 2007 18:56:15 +0200
Message-Id: <1184777775.8125.0.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Dior/f6L5D5Z2vPpfKym
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-07-18 at 18:51 +0300, Tomas Winkler wrote:

> > HT aggregtion is extension of QoS. Multicast and broadcast frames are
> > not QoS frames and therefore such frames  want be incorporated into an
> > A-MSDU.
> Oops
> s/want/won't/

Ah, ok, I didn't bother to re-check. Mind doing a patch then that rips
out this code?

johannes

--=-Dior/f6L5D5Z2vPpfKym
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGnkYv/ETPhpq3jKURAv4OAJ0RRnf6Wqeu7mx09rzGxMQ/jePc2QCfdsDH
ggcLlotcAkU3lMXcA/F6EqQ=
=0KTg
-----END PGP SIGNATURE-----

--=-Dior/f6L5D5Z2vPpfKym--

