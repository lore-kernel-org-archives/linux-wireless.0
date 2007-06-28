Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:47780 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754734AbXF1Jys (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2007 05:54:48 -0400
Subject: Re: ieee80211_rx_mgmt: pushing fake 'management' frames into  userspace
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200706271730.59591.hs4233@mail.mn-solutions.de>
References: <A2CE5E0A70B68046A98EB5145552E27701173B8F@sinse303.ap.infineon.com>
	 <1182952910.4769.20.camel@johannes.berg>
	 <200706271730.59591.hs4233@mail.mn-solutions.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-DIjG9q99ylxhDPyMg4nf"
Date: Thu, 28 Jun 2007 11:55:02 +0200
Message-Id: <1183024502.4769.78.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-DIjG9q99ylxhDPyMg4nf
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-06-27 at 17:30 +0200, Holger Schurig wrote:
> > Also, I thought you were doing a fullmac chipset? Then you
> > shouldn't be worrying about mac80211 *at all*
>=20
> Yes, unfortunately.

[...]

I think Mandy's got the right idea here, just use the userspace MLME.
But that chipset actually doesn't do any management tasks at all if I
understand correctly.

Feel free to decouple these things in mac80211 though.

johannes

--=-DIjG9q99ylxhDPyMg4nf
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGg4V2/ETPhpq3jKURAlUzAJ9FtrOfK/CHAoKDE9zQCDUJ6rHZlwCdGreE
qYH+Nfa8XrXZzZqxmqgtc9w=
=oMe2
-----END PGP SIGNATURE-----

--=-DIjG9q99ylxhDPyMg4nf--

