Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33800 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933219AbXB1RQ6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 12:16:58 -0500
Subject: Re: [PATCH 0/28] rt2x00:
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200702281807.28551.IvDoorn@gmail.com>
References: <200702281507.04933.IvDoorn@gmail.com>
	 <1172681828.5015.47.camel@johannes.berg>
	 <200702281807.28551.IvDoorn@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-tkADfJXH3oxfrE43D98g"
Date: Wed, 28 Feb 2007 18:16:33 +0100
Message-Id: <1172682993.5015.52.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-tkADfJXH3oxfrE43D98g
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-02-28 at 18:07 +0100, Ivo van Doorn wrote:

> That is where rt2x00lib is coming in. This is only a recent addition to r=
t2x00
> so not everything has moved in correctly. So you can expect more to be
> merged into rt2x00lib.

Yeah, I see that.

> Merging rt2400pci and rt2500pci doesn't sound like a good idea to me,
> once rt2x00lib has been optimally used most duplicate code is out,

Well you'll still have a lot of the registration code etc. duplicated.

> and merging those 2 could make the implementation of hardware encryption
> for rt2500pci harder. rt2400pci is the only Ralink chip that is not capab=
le of
> hardware encryption.

That I don't understand at all; if it's a 2400pci chip you just return
early from the set_key() callback and thereby tell mac80211 to use sw
crypto.

johannes

--=-tkADfJXH3oxfrE43D98g
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD4DBQBF5bjx/ETPhpq3jKURAnxMAJ9jL/x3AXyNYieWBzo8E6aAXWeO1gCXdw6x
OOBSOQgvo4Xi1Rm9FvCAZA==
=WXyU
-----END PGP SIGNATURE-----

--=-tkADfJXH3oxfrE43D98g--

