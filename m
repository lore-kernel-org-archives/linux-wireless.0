Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51187 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757308AbXF1K7Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2007 06:59:25 -0400
Subject: Re: [PATCH 00/14] major mac80211 restructuring/cleanups
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
In-Reply-To: <1182503355.21939.70.camel@johannes.berg>
References: <20070621221603.778432000@sipsolutions.net>
	 <1182503355.21939.70.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-DP/PAYXzb5n/W5r/A0Rm"
Date: Thu, 28 Jun 2007 12:59:43 +0200
Message-Id: <1183028384.4769.86.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-DP/PAYXzb5n/W5r/A0Rm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-06-22 at 11:09 +0200, Johannes Berg wrote:
> Apparently 1 and 8 were too large:
>=20
> (1)
> http://johannes.sipsolutions.net/patches/kernel/all/2007-06-22-09:08/033-=
split-rx.patch
>=20
> (8)
> http://johannes.sipsolutions.net/patches/kernel/all/2007-06-22-09:08/040-=
split-out-tx-handlers.patch

I should have mentioned that these also reorder the rx handlers to be in
the same order as they're invoked in which makes reading that code a lot
easier since you can just read it top-down without worrying about
jumping around to find the correct order all the time.

johannes

--=-DP/PAYXzb5n/W5r/A0Rm
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGg5Sf/ETPhpq3jKURAhAlAJ91s1NTtv083uWzWStraGWf+og51gCgrKE7
VkL1QVgYC1TuMGGdiLg5Fgs=
=1KsE
-----END PGP SIGNATURE-----

--=-DP/PAYXzb5n/W5r/A0Rm--

