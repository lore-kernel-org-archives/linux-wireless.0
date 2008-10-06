Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43954 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644AbYJFUSP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 16:18:15 -0400
Subject: Re: p54 build failure
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@web.de>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200810062219.42475.chunkeey@web.de>
References: <1223322501.3778.20.camel@johannes.berg>
	 <200810062219.42475.chunkeey@web.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-gSKfFNPXqeZeuH6Hh4rP"
Date: Mon, 06 Oct 2008 22:17:45 +0200
Message-Id: <1223324265.3778.24.camel@johannes.berg> (sfid-20081006_221819_662649_7B6EC24C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-gSKfFNPXqeZeuH6Hh4rP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

can you turn off html?

On Mon, 2008-10-06 at 22:19 +0200, Christian Lamparter wrote:
> On Monday 06 October 2008 21:48:21 Johannes Berg wrote:
>=20
> > p54_parse_eeprom must not be static, or it fails to build on
> powerpc:
>=20
> >
>=20
> > drivers/net/wireless/p54/p54common.c:482: error:
>=20
> > __ksymtab_p54_parse_eeprom causes a section type conflict
>=20
> >
>=20
> Kind of funny, remember the sparse warning?!
>=20
> .../p54common.c:313:5: warning: symbol 'p54_parse_eeprom' was not
> declared.
> Shou

Well, if it's exported then clearly it must be declared in some header
file; therefore the file needs to include that header file. Mindlessly
fixing sparse warnings has never brought anything forward.

johannes

--=-gSKfFNPXqeZeuH6Hh4rP
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI6nJlAAoJEKVg1VMiehFYg5sQAMYox3LAcNP71cNCQ/qE97/+
VjFvU88l+3eO8RPH0Gf9NfvfhE+ZtHXga1D9Ckqj2cVoro6yEvf7/RZxzYubwggJ
8X1dHCa6JUOnp5QYGIiaFCld7d8UztTwui4JMgrlZhmEyoYBUvBQcP9ExCqz7YXo
rxr9CZwZacMoX0yOXzht2mD5nWIqcnLi/6vWYDfqsCpHaSgD00g3u0X9muVNlA2S
xQggxTvo0XGdIO+J6ZSDz7QUZOVjOSh4FK2cxnm9YUog39jzXbMRoYaFWtF6g9ry
PH56PzUX/Adz0mbc/vApl91L4MItylokHaeYd1i4qLI8Nflap7fWX2LT/Yz6dXiq
sTrWgvRmR9f2CaZ6QlU3JCoLBHQJ8pP+bD4AeaDQNIC01CQ8VkqhgpmP3hd4grXj
y4rcAR66ClmtRY77IEGNz/V5IMtMzwFiCuf4EmXq1ZWfC+zCYW/K3SqmQCBFr9hz
ZCIykwq2hXL+T6bD/3/fbZkx0XuBFvEHUMYKCsJyfCzRRfisZS/DNvtmvKoyEnZw
u/dNPeiNuaEtTfLJ/KU3zf20Zsb709O/c/FRGrnQMyfgk+hEbxOmXsrm/FKWhPvL
cBx+jYefRVq75KiMqY5u/uEaiirofd44/A4kpx/X8yU6mjADjyWRUhVhjWdq2eM0
1vu2oQPx9Z5uxhwnON6m
=FZpt
-----END PGP SIGNATURE-----

--=-gSKfFNPXqeZeuH6Hh4rP--

