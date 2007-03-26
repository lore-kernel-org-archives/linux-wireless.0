Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59214 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753632AbXCZK25 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Mar 2007 06:28:57 -0400
Subject: Re: [PATCH] zd1211rw-mac80211: Fix for monitor mode bug
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Benc <jbenc@suse.cz>
Cc: Daniel Drake <dsd@gentoo.org>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, kune@deine-taler.de
In-Reply-To: <1174903199.1536.4.camel@johannes.berg>
References: <20070325231817.9C5887B409F@zog.reactivated.net>
	 <20070326115412.2786c8f4@griffin.suse.cz>
	 <1174903199.1536.4.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-TZje42hcfm2wm1dVEFK0"
Date: Mon, 26 Mar 2007 12:28:46 +0200
Message-Id: <1174904926.1536.6.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-TZje42hcfm2wm1dVEFK0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-03-26 at 11:59 +0200, Johannes Berg wrote:

> bcm43xx doesn't tell you when the CRC failed, nor does it tell you when
> the PLCP CRC failed (if you want to see those frames). Hence, we'd have
> to recheck the CRC(s).

Then again, it would be trivial to patch the firmware to include bits
for this, so we may want to be able to use them too if they exist.

johannes

--=-TZje42hcfm2wm1dVEFK0
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGB6Be/ETPhpq3jKURAqLWAJ98gwGo2rfyBqfREcH9rT4N8DwzYQCgiRh8
nAxJgxJJx0nsAcriZ7T7jkw=
=OnSP
-----END PGP SIGNATURE-----

--=-TZje42hcfm2wm1dVEFK0--

