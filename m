Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:46543 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751962Ab3FRKzm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 06:55:42 -0400
Message-ID: <1371552937.10702.15.camel@cumari.coelho.fi> (sfid-20130618_125545_362226_14AD36FE)
Subject: pull request: TI wireless drivers 2013-06-18 (for 3.11)
From: Luciano Coelho <coelho@ti.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Date: Tue, 18 Jun 2013 13:55:37 +0300
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="=-4s+xtV2SS2B9asIUWLmR"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--=-4s+xtV2SS2B9asIUWLmR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi John,

Here are a few patches intended for 3.11.  There's nothing major.  A
bunch of bug fixes here and there, a hardware bug workaround and some
small clean-ups.

Please let me know if you have any problems with it!

The following changes since commit 1105a13bb8ad29cf83d46989ee462d196038be87=
:

  orinoco_usb: fix memory leak in ezusb_access_ltv() when device disconnect=
ed (2013-06-14 13:37:16 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git for-linvill=
e

for you to fetch changes up to 789e90e567d7d93edc1b2001d17209c21cc37850:

  net: wireless: wl1251: Fix commenting style (2013-06-17 12:24:09 +0300)

----------------------------------------------------------------
Arik Nemtsov (2):
      wlcore: cancel channel switch work on interface removal
      wlcore: hold jiffies in unsigned long

Eliad Peller (1):
      wlcore: configure rates in multiple cases

Ido Reis (1):
      wl18xx: FDSP Code RAM Corruption fix

Luciano Coelho (3):
      wlcore: some non-functional clean-ups in main.c
      wlcore: move sysfs handling to a separate file
      wl18xx: use locally administered MAC address if not available from fu=
se

Peter Huewe (1):
      net/wireless/ti/wlcore/spi: Use module_spi_driver to register driver

Sachin Kamat (2):
      net: wireless: wl1251: Use module_spi_driver macro
      net: wireless: wl1251: Fix commenting style

Victor Goldenshtein (1):
      wlcore: fix occasional AP TX stop after recovery

Yoni Divinsky (1):
      wlcore: set default_wep_key when configured

 drivers/net/wireless/ti/wl1251/spi.c    |   30 +------
 drivers/net/wireless/ti/wl18xx/main.c   |   47 +++++++++-
 drivers/net/wireless/ti/wl18xx/reg.h    |   15 ++++
 drivers/net/wireless/ti/wlcore/Makefile |    2 +-
 drivers/net/wireless/ti/wlcore/main.c   |  265 ++++++++++++---------------=
-----------------------------
 drivers/net/wireless/ti/wlcore/ps.c     |    2 +-
 drivers/net/wireless/ti/wlcore/spi.c    |   14 +--
 drivers/net/wireless/ti/wlcore/sysfs.c  |  216 +++++++++++++++++++++++++++=
++++++++++++++++++
 drivers/net/wireless/ti/wlcore/sysfs.h  |   28 ++++++
 drivers/net/wireless/ti/wlcore/tx.c     |    2 +-
 10 files changed, 367 insertions(+), 254 deletions(-)
 create mode 100644 drivers/net/wireless/ti/wlcore/sysfs.c
 create mode 100644 drivers/net/wireless/ti/wlcore/sysfs.h

--=20
Cheers,
Luca.

--=-4s+xtV2SS2B9asIUWLmR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJRwDypAAoJEKFHnKIaPMX6qUoP+wZz2lgfN4WpE0AXbfLZET8j
POmB32tOoW/9q7mSOPGG/Z9V+PlcY0SQ/Fk3/4uh9sLECdicgbQV1cTWrBJ4E5sk
LvIsmqvl7QLpYxorkmiI1Iep6Wdr7DL7LcKh/r/zyGZramWaHOQBn4OyFPerHWOZ
ZzgU7gysK+3sEjfmVBKIwcc1LpdtszBqHfwhkaEGVcyE4b0c8x9L9mJeZ5fYYnGQ
6xBZ/cSn9L8P3Ux05jMZYhH6l7iWiUVAB0XMRFszcoRwC5LMoZcdADJhl0v6lqvz
YDAp0/wmizHcKsM3Qf7YQ4omQpjrWvpEzzfpDXrGp7Kgqy9Yyxu7NQ8DyQGj+Z/1
zqxCPmp+ol2t3nDC2hcnAD6UC6kA2ZkkZI5eDMqHpdBzac/8kcbuyT/tygZB3rS1
GUscdHct/u6PccXTVI8atIZpXeSZc//0F62TfwdZdcZiKyj1/jRiOUQTxshfdAmd
khsYURQCqHwri7I05QcVg8+ZGcddrQWqIDyasHeEmSXmBOiqoghlFd0gGfZVHitT
gi4Z6dzz2y6/n5fitXeK/IXuOAmuTtbOVHc5PctfOBf2wUZcucHghujLEGf/Bk9G
LeRd8qZrEBxXwQP6hvuKKrza0T+kvz1GeT7dVUIWsTcT6ZnYc0u/uDn9YFlbqWsJ
tpO02Tu8ZWH/UVn0asBc
=d21w
-----END PGP SIGNATURE-----

--=-4s+xtV2SS2B9asIUWLmR--
