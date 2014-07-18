Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58016 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084AbaGRH57 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2014 03:57:59 -0400
Message-ID: <1405670268.19195.3.camel@jlt4.sipsolutions.net> (sfid-20140718_095805_198859_1B91B3E9)
Subject: pull-request: mac80211 2014-07-18
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 18 Jul 2014 09:57:48 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-exNP11rr5SBaDS2dNDq+"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-exNP11rr5SBaDS2dNDq+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

This is late - maybe it won't come in time. I was busy moving to our new
house.

I have two fixes: one for tracing that fixes a long-standing NULL
pointer dereference, and one for a mac80211 issue that causes iwlmvm to
send invalid frames during authentication/association.

Let me know if there any problems.

johannes


The following changes since commit 02df00eb0019e7d15a1fcddebe4d020226c1ccda=
:

  nl80211: move set_qos_map command into split state (2014-06-24 16:13:10 +=
0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git HEAD

for you to fetch changes up to 8c26d458394be44e135d1c6bd4557e1c4e1a0535:

  cfg80211: fix mic_failure tracing (2014-07-18 09:53:56 +0200)

----------------------------------------------------------------
Eliad Peller (1):
      cfg80211: fix mic_failure tracing

Johannes Berg (1):
      Revert "mac80211: move "bufferable MMPDU" check to fix AP mode scan"

 net/mac80211/tx.c    | 20 ++++++++++----------
 net/wireless/trace.h |  3 ++-
 2 files changed, 12 insertions(+), 11 deletions(-)



--=-exNP11rr5SBaDS2dNDq+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJTyNN9AAoJEDBSmw7B7bqr2MAQALQg89KT6d+xxiXDUTEWW1Rr
LM1joTEGZh5317fN3kZUy2Fhk4ciTX728z/G7VKQQKyFo71Q9UoBNr21BAD77ehd
DELH7vp4vQPgKhUXKcwU0MywlvZLzDP24/Z+Im+wnWzag3+Tmu7/azmwLdI9U2n/
mQzPiF6fhNbhDMrHWejsjUJHYB6p82ebPyg5S2lWvtgHioYLDSBRAetELiDC+9k7
CF+sGfm2ZhYdar+ClNFFabiuGIxUys+slh1pVzLZrF95oMPkyDT0PaV4SYemP3aj
YgttiM8KX/ejZQcDjw5KTGF5KNLgtPgAq2BvcEltUadto4FICAM1+HfPcqgG5bOM
UrNM2mxmrZLY01T0t3hnnpf8vIlVexlW4o0m6T8VWmY30Kd22fTQX2Lxr3bt9eVF
MVPSF3OAudIV6z4IihWTdrOgZ4I8ctreE6jCvnAfgU7eDFgrEeU2lLOH2P92TC83
9k3VisCtdPTWjJNOQ1jCJHeuBIfUhfZB/cXUlaC210QEBLnl8ItxKpDg0pdj1rNI
TvQCRjNcuXaAGbWHmYtpARhR3VvxdTm+6j8ySd1qlkkbqXDKCKAhtguoB/+kfjPV
w7970kD2uLwsz0Cl1o2GQYKv9/JyM5Hrp7NQu+uRxLuepHNorK2FBWzSLTAP1sry
5lAPF/x/DEy9ME8Asa2t
=EwEc
-----END PGP SIGNATURE-----

--=-exNP11rr5SBaDS2dNDq+--

