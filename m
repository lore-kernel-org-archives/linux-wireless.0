Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57790 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030672AbXCCQIK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Mar 2007 11:08:10 -0500
Subject: Re: straw poll: new Kconfig symbol for mac80211 debugfs?
From: Johannes Berg <johannes@sipsolutions.net>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20070303075119.6fe0ae1c.rdunlap@xenotime.net>
References: <1172923924.4966.41.camel@johannes.berg>
	 <20070303075119.6fe0ae1c.rdunlap@xenotime.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mziaQbBKlFJQ36CAN52J"
Date: Sat, 03 Mar 2007 17:07:45 +0100
Message-Id: <1172938065.4966.82.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mziaQbBKlFJQ36CAN52J
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-03-03 at 07:51 -0800, Randy Dunlap wrote:
> On Sat, 03 Mar 2007 13:12:03 +0100 Johannes Berg wrote:
>=20
> > After moving all the sysfs stuff to debugfs I notice that it is quite a
> > large amount of code. Does anybody think having a new Kconfig symbol fo=
r
> > that like this one
> >=20
> > config MAC80211_DEBUGFS
> > 	bool "DebugFS support"
> > 	depends on MAC80211
> > 	---help---
> > 	  Select this to see extensive information about
> > 	  the internal state of mac80211 in debugfs.
> >=20
> > 	  Say N unless you know you need this.
> >=20
> > would make sense?
>=20
> Yes.  But it should also depend on DEBUG_FS... (maybe it does
> that somewhere else?)

Yeah, I only wrote this right into this email and forgot (and when I
noticed seconds after sending I didn't want to spam everybody again,
sent enough mail already today :) )

johannes

--=-mziaQbBKlFJQ36CAN52J
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF6Z1R/ETPhpq3jKURAigoAJ9Yvnl6CXXySeYlOYNGnmPU4j61BACcCcsY
KhK2hNGMtezh/COZOvZ5bec=
=iF3g
-----END PGP SIGNATURE-----

--=-mziaQbBKlFJQ36CAN52J--

