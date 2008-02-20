Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60452 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755982AbYBTScw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2008 13:32:52 -0500
Subject: implementing APSD?
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomasw@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	Michael Renzmann <mrenzmann@madwifi.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	bruno randolf <br1@einfach.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-sLj6AOAUP5oe7/oJqh5v"
Date: Wed, 20 Feb 2008 16:24:47 +0100
Message-Id: <1203521087.17534.74.camel@johannes.berg> (sfid-20080220_183255_105924_EDDCAB0D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-sLj6AOAUP5oe7/oJqh5v
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

I've long thought about implementing APSD but it seems to require
setting the "more data" bit in an ACK frame and various other things.
Ron, I think you're the QoS expert, is that really how APSD works? If
so, does iwl firmware implement that?

Also, does Atheros hardware implement that, and how? It doesn't look
like Broadcom firmware implements it, and I don't really understand how
one could implement it without many hardware queues, since it seems
timing critical to send out the frames to the station that is using
APSD.

Any clues?

johannes

--=-sLj6AOAUP5oe7/oJqh5v
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR7xGPqVg1VMiehFYAQJBJRAAueJyHHBbgogFV7eSdRlobMGjdyF0C2sH
wjkFzcko34/rRoXCOtfBER9YAW1U/ETeH1wWwl1R/Xm2Ne4JGGO5yCX3QjE2D34G
kGdUZFVHouObqCYVr2UGs7A3pKau1yclYPcclTql2ENVl0CztBGDpHOXKaJ19YTE
RTA4l5ufjvIJWCzeHZvVyoD5N7ikKoCFl1kxGz9jaZ2KKM3O/z4BOTjii5IgAB5k
o3ZU+Zr+tJ4DscSP/irAYe25JzIJ7toJLU1tEILizS3GuPl4S8RELFmQiJaUYfxQ
yy+QoEucaVVA0lRrZrYzydy2I9VsIl4I+UBk6l6w1lATRSJWyZN4No93lhqg9Aih
/ioIOVfR4bnss+Liz//4IVn7e0By1iCS7T2gKOUJpC6grqDz8yKjtX8fyvPA6zjX
UXOhcP86gXPL8HSMmfiscxL6kkPdMfahWTgZFpcDbq6MLjbGLSpghTZTsDqwc52f
9mt4O9l7KKjlu5PW+Em4aLi4OFNvK21Fm3eJV6gKqOvojq2UWqOo60VmujRVZFdt
cJWXPnI2xGWZUisL68yO+elfRa19UPiqiTuk4HzhhsMVFvxAg8Qit4m1pZa5x1Rh
97hFISAu7ryAmIIUnoSMEDMQ7Z0KML+S66GLeo8ywl3TGw1oYmOwiAUnz1kFHVXJ
5Uio28H6c2g=
=6XEP
-----END PGP SIGNATURE-----

--=-sLj6AOAUP5oe7/oJqh5v--

