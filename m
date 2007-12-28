Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49868 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771AbXL1WF3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Dec 2007 17:05:29 -0500
Subject: Re: cfg80211 API for channels/bitrates, mac80211 and driver
	conversion
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20071228.140103.159573237.davem@davemloft.net> (sfid-20071228_220113_025956_3B2CF6B8)
References: <1198878633.4172.19.camel@johannes.berg>
	 <20071228.140103.159573237.davem@davemloft.net>
	 (sfid-20071228_220113_025956_3B2CF6B8)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-O/2VxNidq9WbBcRNgGiz"
Date: Fri, 28 Dec 2007 23:05:14 +0100
Message-Id: <1198879515.4172.21.camel@johannes.berg> (sfid-20071228_220553_214757_4CA4EE3C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-O/2VxNidq9WbBcRNgGiz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> >  include/net/wireless.h                       |  168 ++++++++++=20
>=20
> Are the datastructures in this file the ones that go over
> netlink and thus userland sees?

No. These are purely the internal definitions, I'm just working on
defining the netlink attributes for the information going over to
userland (in include/linux/nl80211.h).

johannes

--=-O/2VxNidq9WbBcRNgGiz
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR3VzGaVg1VMiehFYAQJX+g//eiNvx1ihCoGqJN1ffVVt/sxaya1Keqqr
bgziH/C5wL8lgnPVBLDr01cy9OH4QJQwfM3SPqG+h9bSCHlARFsyIxUilZ3pvSnp
AqA1kz0FujbZQ2XZ2i1jqEwhet6uRm1+cBFWBCw6MF9gyE6eoFQrvAw778cr3UVN
uLDAVOcc+yRt25+BW2Z13gUNNQv+JnzL08lbJ0YpPbJMlRFPyavvrHncCY7z0xeE
/OHtIhY6rPEQsKgxRAItufqEYKvC0w8NFZzAkMm7sUdL35Ocgz1LI1RYm7jthBRx
LXLnmaOH6gNr1ThgkxBBXUx9RmWbUw21IChBwvVKm2MsiDHzhKStje88dnf1pOi+
/rYajKlxtrt8DdH7JWV0pM3lUq9/GROsiVmOTYAEf4F3toqTjnb5/S3yqJ8Xbqta
3aLkvjDcfNNg7vBk0QMOJKjIuB7bckwYTf8osNinh8Z1R3wyDBVoXwtokHZuiM8K
XfBaP37UrLM7fZDr8DE2L4D+2F6Eg+zdli+R878zfzkBH+6wGUlAI0seUjv2EQBL
Fs5bOdIQ9o5rVzD/cNPgkAxkzsPpRUjm1jNfROHoervH0O7G3R8OIT/CFgQBiiRN
ta7CoQ7Sz+9OqOJ9m/LL+DhYzEChbBlYbuk/+uNcMLckTHZhPSwuljTgcQw/p4qY
90EiaNr1DYY=
=twmF
-----END PGP SIGNATURE-----

--=-O/2VxNidq9WbBcRNgGiz--

