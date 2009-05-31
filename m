Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36915 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753893AbZEaNyf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 May 2009 09:54:35 -0400
Subject: Re: [PATCH] rfkill: create useful userspace interface
From: Johannes Berg <johannes@sipsolutions.net>
To: alan-jenkins@tuffmail.co.uk
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <9b2b86520905310651g41babab2hb05729b0699dd81f@mail.gmail.com>
References: <1243524688.10632.0.camel@johannes.local>
	 <9b2b86520905310651g41babab2hb05729b0699dd81f@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-T2bMwGoYWhEnOfI8rIRp"
Date: Sun, 31 May 2009 15:54:29 +0200
Message-Id: <1243778069.5299.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-T2bMwGoYWhEnOfI8rIRp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> How should userspace test CONFIG_RFKILL_INPUT to determine whether
> it's safe to start the daemon?  With the old core, debian-eeepc
> scripts check if the module rfkill-input exists (which should work
> even if it's built in).  If it exists, the scripts don't perform any
> rfkill actions.  (Yeah, according to the doc this is not allowed
> because the scripts don't use "claim", but you can see how it's
> useful).
>=20
> The new rfkill-input isn't a module, so I'm not sure how your daemon
> would test for it.

Maybe we should add an ioctl that disables rfkill-input if present.

johannes

--=-T2bMwGoYWhEnOfI8rIRp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKIowRAAoJEODzc/N7+QmabtkP/3JugyrdxnMtCoaUFI1AAQwj
GixbVksj88raEYwv01k7ThGn42JyWiEZFDTEvdZ3N0eqNa5X/YREJfPynec4q7GQ
HL1Y0bHzM8/pWsdIXJ6lFq+NskHhHKowJPN3r9r6zumTiEYJ7KVFOEDxvmDHSYVj
zp/ppYfai4k8ex5hFRibHngr1jt5X8sZ7QTeSNCyrqESt3qgGZkcjzzKuNfneqEa
2s6AnRC79/BuLmFRmPmc47NESudPm1alVHLARiXF+WRWPDd8et3J54vywsuB6TAK
k9FnSaF3q21L8+dMJQGJghaipQprsGxNuoTRKEPapr5PSb17B0kef2QTGE8432aK
pzBhKPJPxbHpSvkuw+A8vAceeiRkItCyLvhKn4gZkD4Qe+Ey2GX8QGb19484D+1/
uxKo+ozBKhN+z2x+9QdrOtsOEmDjH6lx39Yb/oX0cG8Zpbcv83P2ybBizTkvTY0n
2gko2ofenBu/oDktAeaIh97F0vm+UwNe1vf5Z7jC/jPENrB77dHkha46rkmDnChg
vuSuPhezuLrH6r6kvRgeX2UVZDAS1e2Jw461RErKQln7ECgiF5xN/Cr6K0aFLXQG
whBG+g9oHCR8A3IEfduKIFej84VUGkS5G+4/FsdpBdFw8o7JrAVwugserFd9owrS
XqyA5z/qwhLaeWPzEMC4
=9afa
-----END PGP SIGNATURE-----

--=-T2bMwGoYWhEnOfI8rIRp--

