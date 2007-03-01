Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:52835 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965175AbXCAPVf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2007 10:21:35 -0500
Subject: Re: Question about packet injection
From: Johannes Berg <johannes@sipsolutions.net>
To: Andy Green <andy@warmcat.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <45E6ED0B.20100@warmcat.com>
References: <45E41A9E.2020908@warmcat.com>
	 <20070227164727.GA10048@devicescape.com> <45E497A1.90400@warmcat.com>
	 <45E6ED0B.20100@warmcat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-rxklM7VP/IqYoWpa/LnZ"
Date: Thu, 01 Mar 2007 16:21:12 +0100
Message-Id: <1172762472.11911.65.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-rxklM7VP/IqYoWpa/LnZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-03-01 at 15:11 +0000, Andy Green wrote:

> Is this in fact the correct way to try to inject a packet with fine=20
> control over its encryption and rate?

Right you need to create a management interface and dump it into there I
think. Subject to change, still under discussion though.

johannes

--=-rxklM7VP/IqYoWpa/LnZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF5u9n/ETPhpq3jKURAiLTAJ4kFgTetPK/O5O3plQ0qAfTCWqHRgCcClye
hN6wzRp/SDvc4/rVfHCHVOI=
=FSTj
-----END PGP SIGNATURE-----

--=-rxklM7VP/IqYoWpa/LnZ--

