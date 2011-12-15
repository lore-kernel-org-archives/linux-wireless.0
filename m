Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:43242 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751520Ab1LOOcK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Dec 2011 09:32:10 -0500
Received: by mail-lpp01m010-f53.google.com with SMTP id r15so1123436lag.26
        for <linux-wireless@vger.kernel.org>; Thu, 15 Dec 2011 06:32:07 -0800 (PST)
Subject: pull request: wl12xx 2011-12-15
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-tbjgN4wRqKHOaclxZF8k"
Date: Thu, 15 Dec 2011 16:32:03 +0200
Message-ID: <1323959523.2800.190.camel@cumari> (sfid-20111215_153216_326153_24A013B2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-tbjgN4wRqKHOaclxZF8k
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi John,

Another pull request intended for 3.3.  This time it's much smaller. ;)
It contains a couple of fixes for bugs that were causing oopses by
Pontus and me, one compilation warning removal and a couple of other
clean-ups and improvements.=20

Please pull or let me know if there's any problem. This tree is based on
wireless-next/master.

Thanks!=20

The following changes since commit d646960f7986fefb460a2b062d5ccc8ccfeacc3a=
:

  NFC: Initial LLCP support (2011-12-14 14:50:13 -0500)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git for-linvill=
e

Eliad Peller (1):
      wl12xx: use ieee80211_free_txskb()

Luciano Coelho (5):
      wl12xx: don't write out of bounds when hlid > WL12XX_MAX_LINKS
      wl12xx: call extended radio parameters for wl127x AP mode
      wl12xx: remove deprecated packet detection threshold config
      wl12xx: remove unused firmware version macros
      wl12xx: alloc buffer in driver_state_read to prevent compilation warn=
ing

Pontus Fuchs (2):
      wl12xx: Restore testmode ABI
      Set wlvif->ps_compl to NULL in before return

 drivers/net/wireless/wl12xx/acx.c      |   26 -----------------
 drivers/net/wireless/wl12xx/acx.h      |    8 -----
 drivers/net/wireless/wl12xx/debugfs.c  |   16 +++++++++--
 drivers/net/wireless/wl12xx/init.c     |   47 ++++++++++------------------=
---
 drivers/net/wireless/wl12xx/init.h     |    1 -
 drivers/net/wireless/wl12xx/main.c     |   19 +++++--------
 drivers/net/wireless/wl12xx/rx.c       |    8 ++++-
 drivers/net/wireless/wl12xx/testmode.c |    1 +
 drivers/net/wireless/wl12xx/tx.c       |    9 +++++-
 drivers/net/wireless/wl12xx/wl12xx.h   |    7 -----
 10 files changed, 50 insertions(+), 92 deletions(-)

--=20
Cheers,
Luca.




--=-tbjgN4wRqKHOaclxZF8k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO6gTWAAoJEKFHnKIaPMX6zT8QAKPbFPF5ygJGmwjxGqxHlBQv
fCZEaWDS+ZZ7rUUwdwG9Rutx+gvKesBa99H7Ui2nSp1VAqzY81aeqpEudJtRvqBJ
NRf8zoY/OF4hLhA3B282eDagAAaNyden1Xz1SyqhwPd4evJy7F0cNWTMMZVGzghA
BVYLxnQ4WTUgaiMb0IQLFTyZit8HIc7I7HA2O1wrFJCxcz2YuovuN6mjTfNo4EAq
BpxHkptUjJ6iEQtY6MQmAXN4OH6e0wBgm0c49Baxw5g8WGa8psJJ2Zp3j1lq5Wkb
czCSlF6v7XRIKtIZX8k+hzBTwGNTU9DH5kdR9asKI7vsXXLjT6Hyuv4I2jzrTud9
c6snhblCkyrrndOylOoSKpJx2fEMz7yNQpvMEtGEPCXHE6TIQSgywsx/8k+hpsak
vGQh7tMU7TsvLYqR99uk2kkmfe4TA/IGg+Cy6/7My0NIHrDqo4oRhlItQ3pgn/Qa
FMTWGfhZTGbJ1JvBxTVMWe+CQi8F9nkuCQ6bJ2QHGInDfkR8WAGt1JmxR8gbIxdj
WgRGke5aVceghYhYQm0+1pgj953Y9toWePleV+xFd7flCXNUR6zpqWKKV42vB0o1
YD/26GjXSNgs1KehqZXtH1QOKwgCyII1FdIKW8Er37Q5aAduzAzfhdKGDuyR5bLo
hPX4u/6Q04XIZuX9F16L
=s+Ce
-----END PGP SIGNATURE-----

--=-tbjgN4wRqKHOaclxZF8k--

