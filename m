Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55555 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762230AbXHCPke (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2007 11:40:34 -0400
Subject: Re: [PATCH 18/24] rt2x00: Add Multicast/Broadcast filtering
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200708031736.27782.IvDoorn@gmail.com>
References: <200707312037.33060.IvDoorn@gmail.com>
	 <200708031709.39208.IvDoorn@gmail.com>
	 <1186154435.4647.50.camel@johannes.berg>
	 <200708031736.27782.IvDoorn@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-IidvTHNUMjtFNS1KHsws"
Date: Fri, 03 Aug 2007 17:42:02 +0200
Message-Id: <1186155722.4647.55.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-IidvTHNUMjtFNS1KHsws
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-08-03 at 17:36 +0200, Ivo van Doorn wrote:

> But that would mean that when a non-monitor and monitor interface are
> enabled at the same time, the montitor interface is quite pointless since
> all frames can be caught on the regular interface as well.=20

Not true, monitor mode interfaces gives you a lot more info (radiotap.)

> A monitor interface is supposed to catch as many frames as possible,
> if a monitor interface does not catch frames not directly send to it, it =
won't
> catch anything except beacons.

Not if we want to use monitor interfaces for the userspace mlme.

> Even when there is only 1 interface which is in monitor mode, the user sh=
ouldn't
> have to set the device into promisc mode right?

Actually, imho they should have to. And tcpdump always does anyway.

johannes

--=-IidvTHNUMjtFNS1KHsws
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGs0zK/ETPhpq3jKURAheUAJwILYRljwAjD/Kyr/Kcb/KOwvX97QCcD3H3
paHDHNRxiXJLPZ5hzAOqsOU=
=pkTe
-----END PGP SIGNATURE-----

--=-IidvTHNUMjtFNS1KHsws--

