Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51030 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbXHCTdS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2007 15:33:18 -0400
Subject: Re: [PATCH 18/24] rt2x00: Add Multicast/Broadcast filtering
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200708031804.04234.IvDoorn@gmail.com>
References: <200707312037.33060.IvDoorn@gmail.com>
	 <200708031736.27782.IvDoorn@gmail.com>
	 <1186155722.4647.55.camel@johannes.berg>
	 <200708031804.04234.IvDoorn@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-tHS45r6CR419cziRL863"
Date: Fri, 03 Aug 2007 21:34:47 +0200
Message-Id: <1186169687.4647.57.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-tHS45r6CR419cziRL863
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-08-03 at 18:04 +0200, Ivo van Doorn wrote:

> Next rt2x00 release will not treat monitor mode interfaces special.
> Just read the http://www.linuxwireless.org/en/developers/mac80211/semanti=
cs article
> So the next rt2x00 will comply with that.

Wait until we finish discussing the CRC checks though :) I still think
they should be done even in monitor mode and enabled by some extra flag;
and only enabled when you have only monitor interfaces. Or mac80211
needs to be taught to drop packets with failed CRC on non-monitor
interfaces.

johannes

--=-tHS45r6CR419cziRL863
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGs4NX/ETPhpq3jKURAr3JAKCARW1cOgvOl4789KTyI5xkoTK+SACfZfI4
ynCF3ehMOo9yvBm0eXYqqs8=
=EcSV
-----END PGP SIGNATURE-----

--=-tHS45r6CR419cziRL863--

