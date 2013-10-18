Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48345 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739Ab3JROOd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Oct 2013 10:14:33 -0400
Message-ID: <1382105667.14393.5.camel@jlt4.sipsolutions.net> (sfid-20131018_161437_252522_019CEAD6)
Subject: pull-request: mac80211 2013-10-18
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 18 Oct 2013 16:14:27 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-YleSUcR+rf+oipm7q3QM"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-YleSUcR+rf+oipm7q3QM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

I'm flushing out patches ... one more for mac80211.

This time I have two fixes for P2P (which requires not using CCK rates)
and a workaround for APs with broken WMM information.

Let me know if there's any problem.

johannes


The following changes since commit d86aa4f8ca58898ec6a94c0635da20b948171ed7=
:

  mac80211: fix crash if bitrate calculation goes wrong (2013-10-14 09:47:0=
8 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john

for you to fetch changes up to 095d81cee742fc31e1218077ca6ca8f0df07c613:

  mac80211: disable WMM with invalid parameters (2013-10-17 15:38:22 +0200)

----------------------------------------------------------------
Andrei Otcheretianski (2):
      mac80211: fix honouring rate flags in low-rate transmit
      mac80211: respect rate mask in TX

Johannes Berg (1):
      mac80211: disable WMM with invalid parameters

 net/mac80211/ieee80211_i.h |  1 +
 net/mac80211/mlme.c        | 95 +++++++++++++++++++++++++++++++++++++++++-=
----
 net/mac80211/rate.c        | 15 ++++++--
 3 files changed, 99 insertions(+), 12 deletions(-)


--=-YleSUcR+rf+oipm7q3QM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJSYUJDAAoJEDBSmw7B7bqr4xUP/A1GbuVMtbf6pBcaSDSO01Pn
EUXjZeZ8xszjj6rPP+gGin/Ce766YMnBP54zox0e9oUtTYSh93snJrBk6FhkMi++
RoSvKeh46tqehEu0abKDBaNwt0/MavOPGdpRfYGzTzkkjPtxBzUHlE9NMge6dRU9
zZaBd5k3WyuRFl+QD8UancPDs5c/g4ID80TlH+iiM1LG44H/xOTAYU8qvmywR8ta
frxmPhpv0zV/B9BJyKMz1YtBg8zYCwsROJ5vkVq9/5+Lux+V+PYUrzn4+8y9U8I/
84uP/wMVIn9XojzgpAs3wzMg289wHv4V1bUCIdr0JZwpw+RFGDTpPYqcVUfBtxdQ
vl5BzG96I2iTb2WjD0lm+3I1kKa5ALyHBuOz2QI9Mz2KsFQXwq3i6SgORT6SyDFZ
fTN4qmc8EOBNp+NpgaRTyQjromTaBxLmclpxfIwzUF5KAeD1rDRbUcgYMwvVUYjh
VCkkz3QOBIpgElq2GH5LOFNbpkTVjLYpMOh12L6kofvWfTFuQLc8tuj6Mm2aozwY
5cxT6IJyhIFrNph8E5rDONBaD2IoOI1BqFEZjPy+zojebpoRqY2BqAofv73EB+RV
IxYnCJqUQ92B+cmHi6Xbjy9R9MSkX1edLIwpbflmYmIlzjykSx/JawhFRhLCOBvD
zkoyZy/JsFp8dqyrIMSA
=m+A5
-----END PGP SIGNATURE-----

--=-YleSUcR+rf+oipm7q3QM--

