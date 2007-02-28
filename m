Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55409 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933101AbXB1Q53 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 11:57:29 -0500
Subject: Re: [PATCH 0/28] rt2x00:
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200702281507.04933.IvDoorn@gmail.com>
References: <200702281507.04933.IvDoorn@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-IgLM0Z2LNJttT+t+qtlZ"
Date: Wed, 28 Feb 2007 17:57:07 +0100
Message-Id: <1172681828.5015.47.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-IgLM0Z2LNJttT+t+qtlZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-02-28 at 15:07 +0100, Ivo van Doorn wrote:

> Here is the patch series to bring rt2x00 up to date.

Unrelated to this particular patchset, but we've long said how rt*
drivers are a source of huge amounts of duplicate code.

I just diffed rt2400pci and rt2500pci just for example and noticed that
the hardware is basically identical except for the added features. After
cutting out spurious changes the diff is about 150 lines so it should be
really simple to support the hw in one driver. It'd be great if you
could do this, the code duplication currently in there is pretty awkward
if we change anything externally and need to update 5 almost-identical
drivers.

johannes

--=-IgLM0Z2LNJttT+t+qtlZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF5bRj/ETPhpq3jKURAnC8AKCtwgFIAQ1Va4z9pCCih4e/b0GGuwCgsaGG
2EHRmhYgv8Ayn6WtxQF4bBo=
=sBA9
-----END PGP SIGNATURE-----

--=-IgLM0Z2LNJttT+t+qtlZ--

