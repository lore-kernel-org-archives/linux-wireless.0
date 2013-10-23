Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:41740 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab3JWHMA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Oct 2013 03:12:00 -0400
Message-ID: <1382512252.21526.16.camel@porter.coelho.fi> (sfid-20131023_091204_578736_C229A4DE)
Subject: pull request: TI wireless drivers 2013-10-23 (for 3.13)
From: Luca Coelho <luca@coelho.fi>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>
Date: Wed, 23 Oct 2013 10:10:52 +0300
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-Ir/3HZ98ks71nTXw9c10"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Ir/3HZ98ks71nTXw9c10
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Hi John,

Some patches intended for 3.13.  Eliad continues upstreaming pending
patches from the internal tree.

Please let me know if you have any problems with it!


The following changes since commit a1b13b9ad3759dca24c6b721ee026c540a4e6564=
:

  rt2x00: rt2800pci: use module_pci_driver macro (2013-10-18 14:07:00 -0400=
)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git for-linvill=
e

for you to fetch changes up to 8d3c1fd8c3a4a4a1a319491cdd09bd7eca23ba3b:

  wlcore: save last regdom configuration on stop (2013-10-23 09:47:45 +0300=
)

----------------------------------------------------------------
Barak Bercovitz (3):
      wlcore: read fw panic log only in host mode
      wlcore: Allow stopping fw log in recovery
      wlcore: wakeup from ELP before starting recovery

Eliad Peller (3):
      wlcore: add ap_event_mask
      wlcore: fix started_vifs calculation
      wlcore: save last regdom configuration on stop

Ido Reis (2):
      wlcore: fwlog dynamic mem_block control
      wl12xx/wl18xx: update default fw logger's settings

Igal Chernobelsky (3):
      wl18xx: default config alignment with phy defaults
      wlcore: fix interrogate command length
      wlcore/wl18xx/wl12xx: FW log params per chip arch

Victor Goldenshtein (1):
      wlcore: print active channel in the driver_state

 drivers/net/wireless/ti/wl12xx/main.c     |   16 +++++++++---
 drivers/net/wireless/ti/wl18xx/main.c     |   32 +++++++++++++++--------
 drivers/net/wireless/ti/wlcore/acx.c      |   10 +++++---
 drivers/net/wireless/ti/wlcore/cmd.c      |   12 +++++----
 drivers/net/wireless/ti/wlcore/cmd.h      |    3 ++-
 drivers/net/wireless/ti/wlcore/conf.h     |    5 +++-
 drivers/net/wireless/ti/wlcore/debugfs.c  |   18 ++++++++++++-
 drivers/net/wireless/ti/wlcore/event.c    |    1 +
 drivers/net/wireless/ti/wlcore/hw_ops.h   |    9 +++++++
 drivers/net/wireless/ti/wlcore/init.c     |    6 +++++
 drivers/net/wireless/ti/wlcore/io.h       |    4 +--
 drivers/net/wireless/ti/wlcore/main.c     |   74 +++++++++++++++++++++++++=
+++++++++++++----------------
 drivers/net/wireless/ti/wlcore/scan.c     |   24 +++++++++++++++++-
 drivers/net/wireless/ti/wlcore/testmode.c |    3 ++-
 drivers/net/wireless/ti/wlcore/wlcore.h   |    9 +++++++
 drivers/net/wireless/ti/wlcore/wlcore_i.h |    2 --
 16 files changed, 175 insertions(+), 53 deletions(-)

--=20
Cheers,
Luca.

--=-Ir/3HZ98ks71nTXw9c10
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAABAgAGBQJSZ3Z8AAoJEKFHnKIaPMX6tVcP/0n3LX/btxRqV5ANnmiskFD7
aHCQNzFqUIoOhik5EwrwiAdp7ZUj/ePtLe/iiZCQuI2L4jQ9TJgesC5iy33TVcya
wphw4OYwPAxfw0tM4bOU6UF8t7iRRQ0nPLybOi7d+WnKF4N5CiIoA2TRYmlptVvS
EB+ewyTsv2yIv2i7QFQd918UDQiGklzKWa/vk7LUhokwk2LQcZt5eEyiQfG+eBmp
+KkqXqBzQToFubfSnU7cRZ+DAuwut7QjVpWxctxWVkr2ME2wsP2WcnWbu8m/tCf1
HQxRUi8qCkKx9py0PwKTJw3zo0mpYo4YYjgA5RZnOt7gUozmigs3qHiAg/ytjZUp
TKBo0ZLrtRDGCPsriC3kNsotawFAEsv7E31eEvh9lKiUW4waUnmjD5YO4KJ1spRA
ImYUL3T82sdZxsWJTwearhrt7FDEJXsuzcNbXVk4vzNoTbh2Nv0RWiX9MEUPWbhI
pNGOoEkGKSBULUGedI7yWY1Td1L9Xrk6pqqIky5cUhEdNohiZa9AmVsL04UEq5nZ
JPCvhLGNorgvNc4yRdms61UWuMXj5BlzdCO32f2QreGp811fePD2Lf947vfIjMFs
/TyRUEZSIq8PdcQH0CImn1eICrT7sSDNQI+iXD1q8khcQxPbInr2+twKfhOcgYTm
nt3/TOcvzFhfCtR/yqVV
=9wG8
-----END PGP SIGNATURE-----

--=-Ir/3HZ98ks71nTXw9c10--

