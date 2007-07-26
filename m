Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49890 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764946AbXGZPSE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2007 11:18:04 -0400
Subject: RE: [PATCH 1/1] mac80211: Replace overly "sticky" averagingfilters  for rssi, signal, noise.
From: Johannes Berg <johannes@sipsolutions.net>
To: "Cahill, Ben M" <ben.m.cahill@intel.com>
Cc: Jiri Benc <jbenc@suse.cz>, benmcahill@gmail.com,
	flamingice@sourmilk.net, linux-wireless@vger.kernel.org
In-Reply-To: <4220499A1B034C4FA93B547BA01E1FF00174623A@orsmsx413.amr.corp.intel.com>
References: <4220499A1B034C4FA93B547BA01E1FF00174623A@orsmsx413.amr.corp.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-kRNsRLryhGetDMgLo6uq"
Date: Thu, 26 Jul 2007 17:17:54 +0200
Message-Id: <1185463074.4006.23.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-kRNsRLryhGetDMgLo6uq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-07-25 at 11:50 -0700, Cahill, Ben M wrote:
> Sorry, had to put this aside for awhile ... Actually, I like the way
> things behave without a filter at all (see other mail), but I just
> wanted to follow up ... and thank Johannes for his thoughtful comments.

:)

> Actually, "arithmetic" right shift works for either signed or unsigned.
> Arithmetic shift looks at the most-significant bit, and shifts more of
> that in from the left, preserving the sign.

Eh, right. And I suppose it can actually optimise /16 by an arithmetic
shift.

> [IIR vs FIR]

Ah, cool, I wasn't aware of these terms.

johannes

--=-kRNsRLryhGetDMgLo6uq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGqLsi/ETPhpq3jKURAn1hAJ4791GUr+xMCIoTsKL4Myw5BhzwZQCZAYEJ
iQm/ZD89XJi8mmV7Nf4OOn0=
=QX5Z
-----END PGP SIGNATURE-----

--=-kRNsRLryhGetDMgLo6uq--

