Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:65311 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbaIAHLX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Sep 2014 03:11:23 -0400
Received: by mail-wg0-f52.google.com with SMTP id m15so4906114wgh.35
        for <linux-wireless@vger.kernel.org>; Mon, 01 Sep 2014 00:11:21 -0700 (PDT)
Message-ID: <54041C13.7000905@gmail.com> (sfid-20140901_091127_094519_01851D65)
Date: Mon, 01 Sep 2014 10:11:15 +0300
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	ilw@linux.intel.com
Subject: pull request: iwlwifi 2014-09-01
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="vBpSL2VO7L20QDmxDEmTUteT10w9oNaN2"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--vBpSL2VO7L20QDmxDEmTUteT10w9oNaN2
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi John,

I just came back from a long period of travels and I am really just start=
ing to catch up.
So this is the first pull request with various things that piled up, but =
I am really only
in the middle of the patch list. I still wanted to send now these since t=
hey have been
waiting for a while already.

I revert a patch that disabled CTS to self in dvm because users reported =
issues. The revert
is CCed to stable since the offending patch was sent to stable too. I als=
o bump the firmware
API versions since a new firmware is coming up. On top of that, Marcel fi=
xes a bug I introduced
while fixing a bug in our Kconfig file.

Please pull and let me know if you have issues.
Thanks!


The following changes since commit 77b2f2865956b7573f9b040db7a9f808b434ac=
d1:

  iwlwifi: mvm: disable scheduled scan to prevent firmware crash (2014-08=
-14 19:47:41 +0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git=
 for-john

for you to fetch changes up to d88c8958dc13b4e4eb7fc57e3f06dc1c4abc7b1f:

  iwlwifi: bump firmware API version to 10 for 7000 and 8000 (2014-09-01 =
09:50:14 +0300)

----------------------------------------------------------------
Emmanuel Grumbach (2):
      Revert "iwlwifi: dvm: don't enable CTS to self"
      iwlwifi: bump firmware API version to 10 for 7000 and 8000

Marcel Holtmann (1):
      iwlwifi: Remove module build requirement for Intel Wireless WiFi

 drivers/net/wireless/iwlwifi/Kconfig    |  2 --
 drivers/net/wireless/iwlwifi/dvm/rxon.c | 12 ++++++++++++
 drivers/net/wireless/iwlwifi/iwl-7000.c |  4 ++--
 drivers/net/wireless/iwlwifi/iwl-8000.c |  2 +-
 4 files changed, 15 insertions(+), 5 deletions(-)



--vBpSL2VO7L20QDmxDEmTUteT10w9oNaN2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUBBwXAAoJEC0Llv5uNjIB2jsP/R1a7CetZaZStHLSUDjL6mAb
5+7ddSqIp+n+6yU8qpKbiF3OEkqVachnNLzBQHw9AM+OUN2iAnls07kPBdLUA+Au
qIzlq00yoZL7RSpYKSuCuTDGtig30map98o9InraMBsGXmAT6S4R5csa6bOo9Vt2
fdyU+aHBz8D011ueKSjP9jj8ve/K6cqI3G+5SMhaeMHlftu0C2UjcQANOFhyidux
+4hG1NkIPas6jk/RRHjBRbhjbkc5IHw+/Pf5+Qvh7UnuUw+iNiyaljTP7rtgFyN0
kxP7FWzp/ghXy9QwlKlxwY77BU/IpZDIuzAPYHqIlyJSu8NAUdYR3xHSvk577rmP
eeAn9zE7goJpS0UBkXBhlKwFJlxQFypg++xPl/sa0rIZDgFhWTDPiYHdvl9B0RFM
f7gbhr0aUDyhmrfMw5VcyNAqxA7+tJeGi3kys93+xOJKNJXttDIfEnJqPHGNa5J6
Y+c4NVZM2WWGnOouO39JmScVRxCUTntxq+Zw5eJyeQe9v04NajpZcjaNBo0qlWnB
kq+Oiowuk1e9KC8qNYs3FCUeRnYwWX0JxjYhr6y9mNJ6CWIslh+8FaEQyeKtmGP1
s/VkqeW+WiKCZkicPXfblsHwzFmNAhvB2qb/njen9C4X2kmcJXYHhs1I7U698GXK
gtphoGj+7NqNdfWrQ7nP
=JD9V
-----END PGP SIGNATURE-----

--vBpSL2VO7L20QDmxDEmTUteT10w9oNaN2--
