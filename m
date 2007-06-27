Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:47977 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbXF0Jjk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2007 05:39:40 -0400
Subject: Re: mac80211/bcm43xx deadlock
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200706261617.45713.mb@bu3sch.de>
References: <1182848382.3830.5.camel@johannes.berg>
	 <200706261617.45713.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-xPs3aF7jROyeUospBwR8"
Date: Wed, 27 Jun 2007 11:38:26 +0200
Message-Id: <1182937106.4769.10.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xPs3aF7jROyeUospBwR8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-06-26 at 16:17 +0200, Michael Buesch wrote:

> That's a known bug.
> See the FIXME at stop_core() where we stop the mac80211-queues.
> mac80211 needs to be fixed to fix this. ;)
> We need a function to stop and flush the TX queues from
> _outside_ of the TX handlers.

Are you sure it's the same bug? I don't think we get into
ieee80211_if_shutdown from bcm43xx itself.

johannes

--=-xPs3aF7jROyeUospBwR8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGgjAS/ETPhpq3jKURAjELAJ94OYUL5fswb71BcpHEmO8vt0WlzQCeMqh5
awLHiuE+NTDJ9Pps0ZG8PUo=
=w+WW
-----END PGP SIGNATURE-----

--=-xPs3aF7jROyeUospBwR8--

