Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:38380 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab3FCLjH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 07:39:07 -0400
Message-ID: <1370259433.31905.7.camel@cumari.coelho.fi> (sfid-20130603_133911_036214_8C471040)
Subject: pull request: TI wireless drivers fixes 2013-06-03 (for 3.10)
From: Luciano Coelho <coelho@ti.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Date: Mon, 3 Jun 2013 14:37:13 +0300
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="=-fTclRqC3vXS2ti6NganY"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--=-fTclRqC3vXS2ti6NganY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi John,

Here are three patches that I'd like to get into 3.10.  Two of them, by
me, are related to the firmware version checks in our driver.  Without
them, the firmwares fail to load.  The other one, by Eliad, fixes a typo
bug in our 5GHz scanning code.

Please let me know if you have any problems with it!

The following changes since commit 4ab21db2202895e2c9d3520fed8e7fb061b29605=
:

  rtlwifi: rtl8192cu: Fix problem in connecting to WEP or WPA(1) networks (=
2013-05-31 13:00:33 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git wl12xx-fixe=
s

for you to fetch changes up to 1b5346776c6688006380c2bb491ebf28bc3f3a19:

  wl12xx/wl18xx: scan all 5ghz channels (2013-06-03 11:43:41 +0300)

----------------------------------------------------------------
Eliad Peller (1):
      wl12xx/wl18xx: scan all 5ghz channels

Luciano Coelho (2):
      wl12xx: fix minimum required firmware version for wl127x multirole
      wl12xx: increase minimum singlerole firmware version required

 drivers/net/wireless/ti/wl12xx/scan.c   |    2 +-
 drivers/net/wireless/ti/wl12xx/wl12xx.h |    6 +++---
 drivers/net/wireless/ti/wl18xx/scan.c   |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)


--=20
Cheers,
Luca.


--=-fTclRqC3vXS2ti6NganY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJRrH/pAAoJEKFHnKIaPMX6ajkQAKNdft49HqDw7gWsC0xfVC+G
MCXlnpj2IQ9hLrd7gOa6jmCp8nTzozDVFWXSt90HwlcAVYU8VPwrqUvra4dNmfXr
dN5qg4IEYX0Q8H4Ahf08jJhCc0EY7dY2CQ7Jxv+ifI3z2PVcRMRXnJcvcGQ63GT0
Aqtcr7Kq6Oe5ipOXKeAvp2yeTKeqcTqbyEwclXzI/b8gwm63mdLD4wWgIglUQ6Et
Tfiqg+j0YDnSvaLVbAOA36TgUvXcEhFhGWii7rE2n19X+i+Ixi+OYDgSqn2EK+um
CAH38H+f40l1KeIQK7eiZIAuDqpWnCYeiEiM+LV8gkQB4zgv81Nhg+rwBQT94PYB
o8nnQAfeHJ7fGUrMBwMmJQT23bUdJdwDflhhhO9DZUw1k2bTZeXxPa9+cxGxzFCO
99siAD3ct8e6WTovBMtZf6/bca9EQMcCFpDjNr/Z4UOGcyb1G0RMVcjh5QS51tIy
Ut0dZ+bMz1QruKUo4Y02u00TRtk8qp2/o2szllq9CddvtMkYEXy/xGLeNpNUzPpR
Jn6M3udKltjl/HjsR6f9Lq7WdX0cKkkimkFKtKpJBwFJ+YWonE2pL8wb9XgMw4W7
vhDLFVUbQsw8O2K9B6gMQn9aLRMfNHsmZoS5XxdVh50xJit1qc1g8/Wl14oLS6AL
j5xzl4ilwvhZ2yHmr8Ef
=S7Mv
-----END PGP SIGNATURE-----

--=-fTclRqC3vXS2ti6NganY--
