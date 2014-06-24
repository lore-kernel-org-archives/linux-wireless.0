Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49072 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199AbaFXOUP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2014 10:20:15 -0400
Message-ID: <1403619592.10831.9.camel@jlt4.sipsolutions.net> (sfid-20140624_162019_776218_0A308EFD)
Subject: pull-request: mac80211 2014-06-24
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 24 Jun 2014 16:19:52 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-39ZX1aPuXgw9Z6MhP3gS"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-39ZX1aPuXgw9Z6MhP3gS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi John,

Due to travel etc. I've been a little slow this cycle, but we do have a
few fixes that should go into the current rc series ...

We have a fix from Eliad for a time calculation, a fix from Max for
head/tailroom when sending authentication packets, a revert that Felix
requested since the patch in question broke regulatory and a fix from
myself for an issue with a new command that we advertised in the wrong
place.

Let me know if there are any issues.

johannes

--=-39ZX1aPuXgw9Z6MhP3gS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJTqYkLAAoJEDBSmw7B7bqr8iEP/A+mfPtVZj76mpc874TUM7Ks
QzdNc4hsjSvj5YRg+sI4vlzfyHGcac+AUmnIHaWzJ0zAkQHMi3adqQz1D1JFJfSv
dZYje4sHu+Xu/Kelfxs3aiDfGCOrhBWI2owfxjbV5RQVnLdK4TQ/o2l4BpMKzy7H
d4VU+W8WyZMH3AorHnKEbHmI8Cw5UKYhhfqjhpFzjuQQZdcSSqW57ZQJVHEMt1ME
4kxDTnBZqt2wtMTh0tRsO5NdvL6mLlIVuJ4gpzlPe2ANnQNjwCeABdny/EhY5gKn
Op5CekuvRPx126m85WQZv3ZA2kZLYtHERfB9scnCJxqW2R6neEEdTUY4Sk1atQGr
/M/G/y1ZAEseqqCq8Raw/k7G6Fs+XsDH13nPwhmQUo0Ao1dV2CmXmkONagQlWdMG
H5PisOaoz1gJNNM5ZieklaFHna7c7xjj+p3L+JK2VWoi6rm+ojc+vQyaAzIA36eG
0sxup290oMSMe9tkHoIyJwtRyJG+yqEC+5LHxzf+/xIL9N6+KislKdkZa4F5AZkC
DkcWrBOoUta7azKYVcbsWl/jGAAU1rbfki3CDnlQibJ/gyiDEGUezZcJMGWE2tdO
i+hkYSty59PJ1QuY+kM09kmdn6qFXbXJ4GwJtXc1Q00q9o01566PApLTmoZfY/Eu
iNp0MkOVSBw5j8WRrtcM
=eOj4
-----END PGP SIGNATURE-----

--=-39ZX1aPuXgw9Z6MhP3gS--

