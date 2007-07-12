Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49306 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936304AbXGMJH3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jul 2007 05:07:29 -0400
Subject: RE: [PATCH 1/1] mac80211: Replace overly "sticky" averaging  filters for rssi, signal, noise.
From: Johannes Berg <johannes@sipsolutions.net>
To: "Cahill, Ben M" <ben.m.cahill@intel.com>
Cc: Jiri Benc <jbenc@suse.cz>, benmcahill@gmail.com,
	flamingice@sourmilk.net, linux-wireless@vger.kernel.org
In-Reply-To: <4220499A1B034C4FA93B547BA01E1FF07FC284@orsmsx413.amr.corp.intel.com>
References: <4220499A1B034C4FA93B547BA01E1FF07FC284@orsmsx413.amr.corp.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-7n91Q3VJWS8nkBrV7A5G"
Date: Fri, 13 Jul 2007 00:03:40 +0200
Message-Id: <1184277820.6669.78.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-7n91Q3VJWS8nkBrV7A5G
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-07-10 at 21:59 -0700, Cahill, Ben M wrote:

> If we do the division when passing to user space, how should STA_FILE be
> handled, if necessary?

This should work due to the way the macros are set up:

STA_READ_D(last_rssi, last_rssi/16)
STA_OPS(last_rssi);

johannes

--=-7n91Q3VJWS8nkBrV7A5G
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGlqU7/ETPhpq3jKURAkvCAJ9Zcy+3Huqhg8igb7a8m9YqF8QpCACgqmwe
nvhlX8f+hSWJNxNhaB1LShk=
=NLUa
-----END PGP SIGNATURE-----

--=-7n91Q3VJWS8nkBrV7A5G--

