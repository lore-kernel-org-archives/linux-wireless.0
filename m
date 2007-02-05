Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49825 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933497AbXBEVvj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Feb 2007 16:51:39 -0500
Subject: Re: d80211: current TKIP hwcrypto implementation seems to be broken
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Benc <jbenc@suse.cz>
Cc: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org
In-Reply-To: <1170711946.30959.5.camel@johannes.berg>
References: <200702041344.19117.mb@bu3sch.de>
	 <20070205214333.4e77948e@griffin.suse.cz>
	 <1170711496.30959.3.camel@johannes.berg>
	 <1170711946.30959.5.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-TqVo/eSwO2STPSoKqcX2"
Date: Mon, 05 Feb 2007 22:48:10 +0100
Message-Id: <1170712091.30959.7.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-TqVo/eSwO2STPSoKqcX2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-02-05 at 22:45 +0100, Johannes Berg wrote:
> On Mon, 2007-02-05 at 22:38 +0100, Johannes Berg wrote:
> > On Mon, 2007-02-05 at 21:43 +0100, Jiri Benc wrote:
> >=20
> > > What if the key is changed by the user space? You won't know that and
> > > won't call the library function then. I think it needs to be designed
> > > in the opposite way - the stack will call a driver's callback.
> > >=20
> > > Or am I missing something?
> >=20
> > Wouldn't you have to reset the TSC to zero in that case?
>=20
> Ah, but the driver will need to know for the RX path. Sorry about the
> confusion.

And of course, it is told by way of the set_key callback.. we're talking
hw crypto after all.

johannes

--=-TqVo/eSwO2STPSoKqcX2
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBFx6Ya/ETPhpq3jKURAkKyAJ9bKvtGNQwp9BpwTO/20UHhLVAoQQCeIY/a
Ff8gHf9/rGgAruR9SNLamBw=
=nrAy
-----END PGP SIGNATURE-----

--=-TqVo/eSwO2STPSoKqcX2--

