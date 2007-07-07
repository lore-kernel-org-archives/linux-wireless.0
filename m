Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55486 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266AbXGGKAZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Jul 2007 06:00:25 -0400
Subject: Re: Multiple interfaces in mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Tomas Winkler <tomasw@gmail.com>, Jon Smirl <jonsmirl@gmail.com>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200707071146.48148.IvDoorn@gmail.com>
References: <9e4733910707041723g6f7a535ap1a62dd4473484d40@mail.gmail.com>
	 <200707062316.30009.IvDoorn@gmail.com>
	 <1ba2fa240707061533u7db0eda4i2d76576690b33dec@mail.gmail.com>
	 <200707071146.48148.IvDoorn@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-KpQBvKxciv3I2b5eRz9i"
Date: Sat, 07 Jul 2007 12:01:21 +0200
Message-Id: <1183802481.3779.30.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-KpQBvKxciv3I2b5eRz9i
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-07-07 at 11:46 +0200, Ivo van Doorn wrote:

> Well that wouldn't explain why the bug that Jon experiences occurs since =
that
> would mean that beacons from from example coming from channel 9 are repor=
ted
> to come from channel 10.

Sometimes you see across two channels, but never 10 :)

> But if it should be read from the beacon itself,

No, the radiotap info definitely should not be read from the beacon. The
MLME must adhere to what the beacon says, but for monitoring/radiotap
you're absolutely right: just specify what the card was tuned to.

johannes

--=-KpQBvKxciv3I2b5eRz9i
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGj2Rx/ETPhpq3jKURAkqOAJ9fklNg9TrB8JUJ+iulLpL1FwrL/QCgsyu9
k2aPtCLGK1xbgNwkLze/1SI=
=G1MV
-----END PGP SIGNATURE-----

--=-KpQBvKxciv3I2b5eRz9i--

