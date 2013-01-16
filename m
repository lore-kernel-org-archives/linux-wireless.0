Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37650 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455Ab3APNrI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2013 08:47:08 -0500
Message-ID: <1358344048.22862.0.camel@jlt4.sipsolutions.net> (sfid-20130116_144713_103626_95DE4674)
Subject: pull-request: iwlwifi-fixes 2013-01-16
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 16 Jan 2013 14:47:28 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-CTTVRjzG9TgJLqDTI0q9"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-CTTVRjzG9TgJLqDTI0q9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Please pull to get a single fix from Emmanuel for a bug I introduced due
to misunderstanding the code.

Thanks,
johannes


The following changes since commit f590dcec944552f9a4a61155810f3abd17d6465d=
:

  iwlwifi: fix the reclaimed packet tracking upon flush queue (2013-01-03 1=
5:31:15 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git f=
or-john

for you to fetch changes up to c3e5d7181afb66657393066bccce0956fab09ab3:

  iwlwifi: audit single frames from AGG queue in RS (2013-01-16 14:20:20 +0=
100)

----------------------------------------------------------------
Emmanuel Grumbach (1):
      iwlwifi: audit single frames from AGG queue in RS

 drivers/net/wireless/iwlwifi/dvm/tx.c | 2 ++
 1 file changed, 2 insertions(+)


--=-CTTVRjzG9TgJLqDTI0q9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJQ9q9wAAoJEDBSmw7B7bqr/9cP/1jlo5if2q3XvpryyqiOC8BP
zjkpkUUwIIIGHdOka/OS0NWoEeXHWC6Lk1xU0OrQgn9UY36FY1c0YybIn9cBOnnP
EUMHBF6Bike4MvBbFk4f+xdTsi4GGEXcUVkR9jNaKQTkjU0lqDUEoK3mt7V3Vmn/
9hSWe27qTIzPIUWE2Kfyf2of+QzHW6NGElp+ClPKnKaijQH1BlLx/xL/HgiXd+tl
xc0NFC6FcyvkDz1wTTkvTpTEel/m9I+DLZd0+BXhjgMU18O24rM7zoO0W19WOxBG
PeV2HbyG9VTmihIQ/EgSlLygEEKnv4DrNaE6fGKq/vTUr+5pbjxUHGSBrxEgZAQ5
vcfxywxCUsKQQ6eeUhQs2xeNcN50Xyi4qH5Cq1UdINMPPZkYX1Wz7cZUFb0qan2j
RcZ5fVgHsOpL0cTD9PSqX7jnfg4z1YH2E10FA/oRiSRUZs8uGqJWZzqN4IHBMRja
q3bhLEI/dA5W17V3xWucMkU1FnTQN9IQfuBU8C1aiKnOtM2Asajsg4Jfh65R8sPM
LwV5HfUqumFPa9SnHss01shFLUGg2JA89diDYHV4EG51vBrIoD07SgV/B+rMUeRT
Com9lCJvrr55IQWKnd3zyFcrp5+A2J/Etcn/9H3SEEfCkfGIu3b8siagsMPClSph
xj65btuxC0/TPtqAxjgj
=+a60
-----END PGP SIGNATURE-----

--=-CTTVRjzG9TgJLqDTI0q9--

