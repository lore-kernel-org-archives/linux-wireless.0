Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37191 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756881Ab1IIBG1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Sep 2011 21:06:27 -0400
Subject: File name for libertas_tf_usb firmware
From: Ben Hutchings <ben@decadent.org.uk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 09 Sep 2011 02:06:16 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-hzFaF4vxUYHe0nBXAID3"
Message-ID: <1315530381.23168.56.camel@deadeye> (sfid-20110909_030631_155603_9F8DB580)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-hzFaF4vxUYHe0nBXAID3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The driver wants to load "lbtf_usb.bin", but we have it in
linux-firmware.git as "libertas/lbtf_usb.bin".  It seems like we should
rename it in the repository, as the driver has always used the former
name.

If no-one has any objections, I'll do the rename here and push the
change when I can...

Ben.

--=20
Ben Hutchings
I say we take off; nuke the site from orbit.  It's the only way to be sure.

--=-hzFaF4vxUYHe0nBXAID3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATmlmiOe/yOyVhhEJAQpUgA//eX9koQ34eCzcdge50YnzCOIkQAlodGLO
RBEYCX7lJ4hKCUfK6CKB24Q2+XvnfvTOjZYwcOWcyCLbyy+9d8c/bRqlASHEPqhY
+qLOQ+Z8qD7h24wDEgPjjowDc/z1ifY1sPitqtswfw5Yz6AwZw3hv4WSeKYHkBbS
166Wut4MDlV50lkwWPJuo2L4JmI1Of00EmvvTakYpvoM+c4hCb1tuxyD7rpe56/I
lTFdtn3CXhBt4erWpz04Rl/1jTgdYTeilAJ2HCv9CpqH5p2cP7Ga9dCtQ85QWKIo
OyN7lS4O5fultmYtR74EeQcdAAxS6rCwRwEC3PwF40nT4rF5o32JCex1Wn+I/Mgv
YM5xbZPQyK8pFG+w+lDfw9b+j1mfv+qonoKyhQ8+d84NRzHhJ/H/CDBfGzaQna7o
AzQRiMt7iKIDs7AK0IAa96bDGuYIMqy94XmpdBcfhiYtK4COFB0KC6esTtfzeLS5
E4OyW3L2UUDGevUpu3vs6KQy5isubOTEopRhcsx0wBQDDcWsVyDeVWLjlhtxJi8B
QLiIQGnpDhByZWVh5sePUF4aCdmTllkgjP1f1dDSaayPeFSWcr/dmLIGHO9GbphS
/v4xQWIR0DhnVaFMorjXXtLxAf0jee8U0cJdmPwX2EgAB/7oP0nbfnB6iTPRvcKC
LTg+3GdVDU0=
=k8LU
-----END PGP SIGNATURE-----

--=-hzFaF4vxUYHe0nBXAID3--
