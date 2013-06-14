Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:50226 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126Ab3FNKm4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Jun 2013 06:42:56 -0400
Message-ID: <1371206567.8278.3.camel@jlt4.sipsolutions.net> (sfid-20130614_124302_999225_DCFED2CB)
Subject: pull-request: iwlwifi-fixes 2013-06-14
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 14 Jun 2013 12:42:47 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-tKi7kj13WytVV4XIJ928"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-tKi7kj13WytVV4XIJ928
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

I have two more fixes that I think would be worthwhile for 3.10 but
admittedly the scenario is somewhat unlikely, so if you want to hold
them for 3.11 I can live with that. In that case, I can put them into my
-next tree, or you can pull this into -next (but if you don't pull
wireless.git first you'd get some more fixes you already have.)

These two patches fix two issues with using rfkill randomly during
traffic, which would then cause our driver to stop working and not be
able to recover at all.

johannes


The following changes since commit 622ebe994f6866b8d46ee5d3bcc329ed65d3722d=
:

  iwlwifi: fix rate control regression (2013-06-12 14:13:39 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git f=
or-john

for you to fetch changes up to 8a487b1a7432b20ff3f82387a8ce7555a964b44e:

  iwlwifi: pcie: wake the queue if stopped when being unmapped (2013-06-13 =
16:44:04 +0200)

----------------------------------------------------------------
Emmanuel Grumbach (2):
      iwlwifi: pcie: fix race in queue unmapping
      iwlwifi: pcie: wake the queue if stopped when being unmapped

 drivers/net/wireless/iwlwifi/pcie/tx.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)


--=-tKi7kj13WytVV4XIJ928
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJRuvOnAAoJEDBSmw7B7bqr+vkQALrKvP28IV95N/WuygSMc6PH
KoE1Z39Zg2Qdlqb7+0y39XjPnEK+S+DgWlmpZBXHGkxoZqbEa7K+GuDMDyvY4oc0
BSLZ83fjvS8+dH3IpBqCtSxrKy3TDBDQviGmlJ4c95QZ8iHOsLtNFnTmWTxhwyXS
XKpCKnAUd5Y0Pfmy2xaNGmuA+maqmuoyQFpjhx18AW5+4OkwpOJJi0MabNRIMVb4
dfTjEWnM+QuYmwsgeojBuAUVRNwjG4ql3/GsuHP5N3EERQx6Ij2mFbw8inXbGnb2
OE1aHy2alOVVy4lw7tIe12bTgWDxVjxUYbTdfgo408gnp5RJ/R0TTFhb0Z4cnlsV
ShPm+pY1V4wS4a9cUfOMpeVY6th1LOeDS+8CWO3pGl6QcamAF1Nyh5gnddm7D1xM
AAxmdegI7XJcxt27luZ3fygouw8OH7ERJ0pDuJ4sLaHMcl/8wH1kAWKvcWvgHIbO
D0AVfc9736YlA7Jna2H5cT7izv1iMLDHmZ5jE0tQJ3x0EbzSuaHxO42svd6iu/9Y
jrNrIGqnQzxyknUXMX96qve8CE50UIzv/A1ymXa8U/BBUU4VSl/W1A4paHZ6UscJ
AN9P5p+ZvfRkhMthsqr7YlgBRlGFh27tUPhN0PqAnkzvh3fOurOHzJVGVp6I+DOl
nSRxQTYDAfbMnTnloOoP
=aeOn
-----END PGP SIGNATURE-----

--=-tKi7kj13WytVV4XIJ928--

