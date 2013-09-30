Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:37933 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755525Ab3I3Svx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Sep 2013 14:51:53 -0400
Message-ID: <1380567110.4185.4.camel@porter.coelho.fi> (sfid-20130930_205157_253717_2494F82C)
Subject: pull request: TI wireless drivers 2013-09-30 (for 3.13)
From: Luca Coelho <luca@coelho.fi>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>
Date: Mon, 30 Sep 2013 21:51:50 +0300
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-p5ZNToWeGujHzZBeam7q"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-p5ZNToWeGujHzZBeam7q
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi John,

Here are some patches intended for 3.13.  Eliad is upstreaming a bunch
of patches that have been pending in the internal tree.  Mostly bugfixes
and other small improvements.

Please let me know if you have any problems with it!

The following changes since commit 772eb433357704ec3d6e0daa727d9ec3e85f50c1=
:

  rt2x00: Fix rf register for RT3070 (2013-09-26 15:17:30 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git for-linvill=
e

for you to fetch changes up to f2cede49ae7b9f51a6fe97ada16c27e4d03d05a3:

  wlcore: always register dummy hardirq (2013-09-30 21:12:22 +0300)

----------------------------------------------------------------
Arik Nemtsov (3):
      wlcore: ROC on AP channel before auth reply
      wlcore: re-enable idle handling
      wlcore: always register dummy hardirq

Eliad Peller (2):
      wlcore: remove unsupported channels
      wlcore: clarify and fix regulatory domain bit translation

Victor Goldenshtein (4):
      wlcore: cleanup scan debug prints
      wlcore: fix unsafe dereference of the wlvif
      wl18xx: fix boot process in high temperature environment
      wl18xx: print new RDL versions during boot

Yair Shapira (2):
      wlcore: add new plt power-mode: CHIP_AWAKE
      wlcore: disable elp sleep while in plt mode

 drivers/net/wireless/ti/wl18xx/main.c     |   95 +++++++++++++++++++++++++=
+++++---
 drivers/net/wireless/ti/wl18xx/reg.h      |   33 ++++++++----
 drivers/net/wireless/ti/wlcore/cmd.c      |   58 +++++++++++---------
 drivers/net/wireless/ti/wlcore/main.c     |  156 +++++++++++++++++++++++++=
++++++++++++++++++++---------
 drivers/net/wireless/ti/wlcore/ps.c       |    4 ++
 drivers/net/wireless/ti/wlcore/scan.c     |   27 +++++-----
 drivers/net/wireless/ti/wlcore/testmode.c |   13 ++++-
 drivers/net/wireless/ti/wlcore/tx.c       |   27 +++++++---
 drivers/net/wireless/ti/wlcore/tx.h       |    3 ++
 drivers/net/wireless/ti/wlcore/wlcore.h   |    2 +
 drivers/net/wireless/ti/wlcore/wlcore_i.h |   11 ++++
 11 files changed, 342 insertions(+), 87 deletions(-)

--=20
Cheers,
Luca.

--=-p5ZNToWeGujHzZBeam7q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAABAgAGBQJSSchGAAoJEKFHnKIaPMX67U0QAKaq8CffM2XfUNGyr/aFj8uF
tNR+uLeIPbbeRF9ZxWX+WyS/eqjLfxUDGGa8xN7fUzqwNjluN6idCQXQy7mUeHmb
vTI/OFE7bSQ/1PK4w9lCC2KsvALdQ/UjFQdUk/H4dbUlgpU0CXX/AO8ScavceVDo
vWA0o/+IrEsNOFinNrLbcolwNJhrgn2OPIN+1GXZttJRmboz3bLUJGjNKCHdLp0W
6NJdrSh3bcIIc0Pn17Ufx6rQkCFF2ZPNGXBnqQp6PXECPzUu/e6Bk3KqCW814QA+
QJxud9AqH0BcW/Jt/tn0sceVyyrzoJ5dJTDWqGQQqZFu0gchkgvk2VFqUEbXCn/C
jO60t/mgESE+mwT1qEgCHGOzm/j0v149zctulqc5VrTPOoP3F+J7YMgtii9Qowim
Mtqc7ERLXSsJgiYPhIoeSu+Y0nAJpIzYOQf4tgsDFQ1MNkv0C7OOQl/I4785/pf3
YKNZoq2xQ5jzDKvVrwFS5qEztbM1jkWngNFvOSL32iBzYGNVOky8uq3dWP2Qq7Dy
u7sOaLHvy8YX6X5LbaUJoFFuwAXB0OfOrKhGP44x1vaGvBB4cSFeSflxOFbPAcGc
pxzJyqfoLSAnn9NfLuflt9uoJeoFkIecx9VHvz8Nx6mtqKw4ebC+1p3KEguwTX9d
5uO5b+gPrbgf8C01nDEM
=lOyj
-----END PGP SIGNATURE-----

--=-p5ZNToWeGujHzZBeam7q--

