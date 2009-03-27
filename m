Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50362 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297AbZC0NHM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 09:07:12 -0400
Subject: rfkill-input madness
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-vltPQ3g4JBfFdWIz0dS6"
Date: Fri, 27 Mar 2009 14:06:36 +0100
Message-Id: <1238159196.4452.1.camel@johannes.local> (sfid-20090327_140716_749508_2394CEF9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-vltPQ3g4JBfFdWIz0dS6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

The doc says:

        ******IMPORTANT******
        When rfkill-input is ACTIVE, userspace is NOT TO CHANGE THE STATE O=
F AN RFKILL
        SWITCH IN RESPONSE TO AN INPUT EVENT also handled by rfkill-input, =
unless it
        has set to true the user_claim attribute for that particular switch=
.  This rule
        is *absolute*; do NOT violate it.
        ******IMPORTANT******
       =20
        ...
       =20
        When rfkill-input is not active, userspace must initiate a rfkill s=
tatus
        change by writing to the "state" attribute in order for anything to=
 happen.
       =20


How the hell is userspace supposed to know whether rfkill-input is
active or not? Does anybody fucking care to implement any of this mess
in userspace?

johannes

--=-vltPQ3g4JBfFdWIz0dS6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJzM9aAAoJEKVg1VMiehFY7A8P/0R67dTAO+wtusGtvkWFgqq6
WdIa2pndTmNIbnZu2PDOq+mY5bWxlBsCYEfQ6jOTSoktA7+ZZI+88EiUDDFHNDo5
TGhWMXUzhT/krHYE3ejOkjm/pOAZOesc4b5CwojlFtBsL0mVEB3TI0URb3IoHEl0
mYD9xlXgBpCC1szO1JZs/Sm5yRjzfe1V4c0FFh0i0baEwyAwb5CRLr88ULNjmxVk
/a/Y4Aw/4VAbXrbN8KZ2fOy33s/i/UYSD+H7CX84DX6V0UJFF7xymP4vlwdCGVZ3
16KCHsvVSHW8oGi9ki2W0679qTzViiahFaSrN99DTXkVlYCkn6wGZ2bR6zBFdHEp
TKK9t8vAIR+idy4kIGherCMwznVIUIw6FRu0s/56VrqrBmYJk9RqpqgHJ5kcbNBH
cL2dAIn+xBLOBkE7P83Qyo5bg+4/Pu9pUctUzvfPA2KMUEIh+7Vxz5QbvnU904Gu
OfuAVkvTkWRnW+nU6JDRW29Ba2Kv+jtBenoIE7lDafiyBqt8oVYCJBXq4hyNBPXM
9CbLNkl2g3agdB262gbxPSyr2fsQ1R0mgFr6rS9ObvYYYAUsh+N/5QfQH9sa+sBV
aSh06DqVb8T4M6kKwpIoSXjVpjGU2Ol88w110RoANErHelBv9hQObk+A7WdB/Xe9
t6iwFC/Hkumx8KZNtJAQ
=/dim
-----END PGP SIGNATURE-----

--=-vltPQ3g4JBfFdWIz0dS6--

