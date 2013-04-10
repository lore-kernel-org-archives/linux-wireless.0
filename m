Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:32868 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757Ab3DJTuA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Apr 2013 15:50:00 -0400
Message-ID: <1365623386.4235.40.camel@jlt4.sipsolutions.net> (sfid-20130410_215007_554743_33B94E05)
Subject: pull-request: mac80211 2013-04-10
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 10 Apr 2013 21:49:46 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-lZ7xsKj0gNr24z/GTYKY"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-lZ7xsKj0gNr24z/GTYKY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Yet one more!

This fixes a fairly important/annoying bug -- when roaming between
multiple APs of the same network, the system could get stuck thinking it
was connected to the old one while it really wasn't.

I hope this can still go to 3.9, but it's tagged for stable either way.

johannes


The following changes since commit 62a40a15554d6924a58b3e9f8756e0d683dc9c0c=
:

  mac80211: fix LED in idle handling (2013-04-08 13:12:05 +0200)

are available in the git repository at:

  git://x-git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-jo=
hn

for you to fetch changes up to 7b119dc06d871405fc7c3e9a73a6c987409ba639:

  mac80211: fix cfg80211 interaction on auth/assoc request (2013-04-10 21:3=
8:36 +0200)

----------------------------------------------------------------
Johannes Berg (1):
      mac80211: fix cfg80211 interaction on auth/assoc request

 net/mac80211/mlme.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)


--=-lZ7xsKj0gNr24z/GTYKY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJRZcJaAAoJEDBSmw7B7bqrwnwQALfYAE6wp16dxQz15OC90FZv
Afsz49+WVyx+eU3r6LiOXm8fYiZl45ShAHAhw2cAvk5TeBC7ukNhlhwD0XHAHB0l
mC8KQOW88NG9a4h0wvZWrU6H7BEJmm+eXZCVrtrRolu3KC16wjSMTMV8sl541u60
l4n8apVRsJS6V9rbGgKl1lSckJCJrDr3fHZ3kXr+4htKR8ibGgLV9DAlCLtKovqq
HvMoT4JH2cX/Aeqsiva+IbcEwX/QXxTHfzXLoK0ChTNMAXv7P+38a30YoYHB3ZqD
+vInlm6YiRQZR6vCMYqzbNxhNNobNEGiNmudy1yDt/YJuqDGwv7ojjEEY7CPwk6A
s7Tke4uj7uqB/2LZrUXOtfxiITHCylBd8czEo/QGyrug6+8hyhepsPPEG8SRYedE
HRUa0MYUA+Z3tdPlFxInxf0AhEabCS8DoSmoOOZ24t7ZCilwYT4YY7dZqPXvpIOz
FcqHScfrup0x2Bc/PB8lRutb5qO9F5cVHFOwJKSY2V7Sq0BPLzhHZN2EaXFPSjao
XSx85iJBv/ML1gs5sCS6J9UdAhhTP/35p6+xez/9h4iU+gvGUo8qrOQn/FBcyAO3
evTJX+YcAG6x3NMj9ZUit4GBNvJmpxcJH/CPV68/ipRBdYEKD+156EtqOyZIzRWe
s3dSK5oP56olOR7whdfl
=cTDS
-----END PGP SIGNATURE-----

--=-lZ7xsKj0gNr24z/GTYKY--

