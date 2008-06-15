Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:1077 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751428AbYFOXVt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Jun 2008 19:21:49 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1212428729.10093.13.camel@localhost.localdomain>
References: <1212354884.4722.26.camel@deadeye.i.decadent.org.uk>
	 <1212428729.10093.13.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-BbuN2SJ6jkaW8LJv2Xr7"
Date: Mon, 16 Jun 2008 00:20:33 +0100
Message-Id: <1213572033.27679.6.camel@deadeye.i.decadent.org.uk> (sfid-20080616_012155_016474_615BF9C8)
Mime-Version: 1.0
Subject: Re: IW_SCAN_CAPA_ESSID vs hidden ESSID
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-BbuN2SJ6jkaW8LJv2Xr7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-06-02 at 13:45 -0400, Dan Williams wrote:
[...]
> You might also want:
>=20
> http://lists.shmoo.com/pipermail/hostap/2008-June/017873.html
>=20
> that patch.  It fixes an issue that caused wpa_supplicant to never
> probe-scan the AP in with a hidden SSID test configuration with ipw2200.

Thanks.  I'm running Debian unstable and the latest package of
wpasupplicant has that patch, but unfortunately it doesn't fix the
problem for me.

Ben.

--=20
Ben Hutchings
If more than one person is responsible for a bug, no one is at fault.

--=-BbuN2SJ6jkaW8LJv2Xr7
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBIVaO679ZNCRIGYgcRAk+hAKDWBfpXIQg8fBwJeaHhtLBYNPOxygCfRpXu
AhqXogT2RZhmjnEbjNcF6TU=
=bSgI
-----END PGP SIGNATURE-----

--=-BbuN2SJ6jkaW8LJv2Xr7--
