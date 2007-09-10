Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:41818 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754447AbXIJKaW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2007 06:30:22 -0400
Subject: Re: Kernel panic with rt2500pci built-in
From: Johannes Berg <johannes@sipsolutions.net>
To: Rob Hussey <robjhussey@gmail.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <6b8cef970709080939v42e88426n40b68a3aa85a951f@mail.gmail.com>
References: <6b8cef970709052006q43d5602ewde0cea45500deede@mail.gmail.com>
	 <1189244217.4506.16.camel@johannes.berg>
	 <6b8cef970709080857s69c055f2s1bc1ce6bd0ad4dfd@mail.gmail.com>
	 <200709081816.10143.IvDoorn@gmail.com>
	 <6b8cef970709080939v42e88426n40b68a3aa85a951f@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-I0v2QoM+VEWAgysRy4pK"
Date: Mon, 10 Sep 2007 12:31:37 +0200
Message-Id: <1189420297.4506.26.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-I0v2QoM+VEWAgysRy4pK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-09-08 at 12:39 -0400, Rob Hussey wrote:

> Not in the log, but on the screen. I should've noticed not everything
> was in there. Here's what shows up:
>=20
> wmaster0: Failed to select rate control algorithm
> phy0 -> rt2x00lib_probe_dev: Error - Failed to initialize hw.

Ok, then the change I proposed to you definitely fixed the bug, but this
is an unrelated one. I'll have to look why it fails to init the rate
control when that's built in.

johannes

--=-I0v2QoM+VEWAgysRy4pK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG5R0J/ETPhpq3jKURAgOJAKCNDfzI2PPlv/Hi2W5t4h2E2XKMMgCfR9uh
obOJHZA6z96FgR9DoYAzNvQ=
=oIQf
-----END PGP SIGNATURE-----

--=-I0v2QoM+VEWAgysRy4pK--

