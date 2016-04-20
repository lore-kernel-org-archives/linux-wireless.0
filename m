Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52233 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753921AbcDTPIQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Apr 2016 11:08:16 -0400
Message-ID: <1461164882.28559.61.camel@decadent.org.uk> (sfid-20160420_170829_819770_130B4353)
Subject: RSS configuration in iwlwifi
From: Ben Hutchings <ben@decadent.org.uk>
To: Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 20 Apr 2016 16:08:02 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-BMUiQ4m+WPAUVhhEv/kd"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-BMUiQ4m+WPAUVhhEv/kd
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm not sure if you were aware, but there is a standard API for
configuring RSS in network drivers, part of ethtool_ops. =C2=A0I think
iwlwifi should implement that rather than a driver-specific debugfs
interface.

Ben.

--=20
Ben Hutchings
Never attribute to conspiracy what can adequately be explained by stupidity=
.

--=-BMUiQ4m+WPAUVhhEv/kd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJXF5tSAAoJEOe/yOyVhhEJfssP/2AA5j2Lvg+sJwVpOCmpq7zb
kA1VHXdTGqicEneQzNrCEXqh8o+AC7FDZfshNrEaVud32FbU8xh5lbsslBZMK1XV
JdpatH58FzodKW+zlrSHNLZPballDunoF+r6mAGYFnHhluXsEanU3QlU+wWeYUsq
Cy+vpG8AjzJz/G+ex86oyl+kattsaudBN6VnKpM/DZ9rIiVbI53nnAXldITjrNKt
Fb1BlaV74N1WWq3h6RySDAGwvbrm57ljKPMia7RKLFE+sJFSZLTxzaHsTFwjK9Fn
D7RmUFm16vPb/diqf5Rob9BwiK60jcW0ErphuZ5JDiRMEMRPFjL/KQzKTPWvw9g/
+VE1XQ60hd1lQRBspw5Tqd2lidct4KFHsnO2vguDCuGNmvTDW/8Ah2N98LLCASX4
I7eCBcu4o8S/T0kyZc3qV9ZZtt2zhvgpCJVfJ+WlE+j1WhIQ13F07ibMXKDWmBPm
gguY1vSaoRnhDNiUknDMfaMway1bdh+NITVeXuU7AQWzmIDbpzzHtJKCEDq+K2Of
rrrJ9+z5DbPBeSeoET1JkaiVfGr9CB8UkEr/JOZO4geEffwxS3070aij0YgyMKpV
HiKtnbsGjGeWbqI7YmO5EmItV4YRs6XKeNuFYSifi4o4wVNaZ/oitpZltyezi3a2
GrAkufcsnZOAePg8NUGK
=Oq8j
-----END PGP SIGNATURE-----

--=-BMUiQ4m+WPAUVhhEv/kd--
