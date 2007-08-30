Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49287 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431AbXH3OYo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2007 10:24:44 -0400
Subject: Re: mac80211, iwlwifi and packet injection
From: Johannes Berg <johannes@sipsolutions.net>
To: Andy Green <andy@warmcat.com>
Cc: Dan Williams <dcbw@redhat.com>, ian <ischram@telenet.be>,
	Robert =?ISO-8859-1?Q?F=FChricht?=
	<the_master_of_disaster@gmx.at>, linux-wireless@vger.kernel.org
In-Reply-To: <46D6D18F.2080108@warmcat.com>
References: <20070829161655.7f68542c@doppelhertz>
	 <46D5B8B9.8000803@telenet.be>  <46D5CE9B.8080401@warmcat.com>
	 <1188481073.27590.11.camel@xo-3E-67-34.localdomain>
	 <46D6D18F.2080108@warmcat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-TUio4B+EdqRDqG1ZJ+2d"
Date: Thu, 30 Aug 2007 16:25:50 +0200
Message-Id: <1188483950.3978.15.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-TUio4B+EdqRDqG1ZJ+2d
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-08-30 at 15:17 +0100, Andy Green wrote:

> There is *a* device.  There are multiple logical network interfaces that
> are bound to that device.  I can spawn five logical network interfaces
> and still only have one device.  NM thinks I spawned five devices: that
> behaviour can be improved (by de-aliasing them via /sys or whatever I
> don't mind).

No, it can't really do that because you may actually want NM to control
multiple virtual interfaces if your hardware supports multiple STA
interfaces. NM should probably just be taught to not change the mode of
an interface all the time unless explicitly requested by the user.

Normal users will never have monitor interfaces. Hence, NM could display
monitor interfaces as "moni0 (monitor mode)" and only when you click on
them it asks "put into managed mode?" or something.

johannes

--=-TUio4B+EdqRDqG1ZJ+2d
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG1tNu/ETPhpq3jKURArtrAJ431f2KdHGwWb/0bWnpkLZz5IVaGACfSRYM
PxPs+uTKdYJvlZxquwmJmgM=
=0Qu7
-----END PGP SIGNATURE-----

--=-TUio4B+EdqRDqG1ZJ+2d--

