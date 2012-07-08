Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:49747 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751385Ab2GHNjk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jul 2012 09:39:40 -0400
Received: by lbbgj10 with SMTP id gj10so15765577lbb.9
        for <linux-wireless@vger.kernel.org>; Sun, 08 Jul 2012 06:39:37 -0700 (PDT)
Message-ID: <1341754768.4354.44.camel@cumari.coelho.fi> (sfid-20120708_154002_542111_6D287FEF)
Subject: pull request: TI wireless drivers 2012-06-27 (for 3.6)
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, arik@wizery.com, assaf@ti.com
Date: Sun, 08 Jul 2012 16:39:28 +0300
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-BLkZIMUm/m9G1KN5nNON"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-BLkZIMUm/m9G1KN5nNON
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi John,

A few more patches with some bugfixes and an update in the firmware APIs
intended for 3.6.  The new firmware has already been applied in
linux-firmware.git and renamed, so this should work with the latest
stuff from there.

Please let me know if there are any problems with this.


The following changes since commit abb14fc399bb895bc5ab86af5d4defc2dfec4e70=
:

  Merge tag 'nfc-next-3.6-2' of git://git.kernel.org/pub/scm/linux/kernel/g=
it/sameo/nfc-3.0 (2012-07-06 16:20:33 -0400)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git for-linvill=
e

for you to fetch changes up to b950b01308bdcb07b16eb0ea63a76901d029bfd8:

  Merge branch 'wl12xx-next' into for-linville (2012-07-08 16:27:26 +0300)

----------------------------------------------------------------

Arik Nemtsov (9):
      wlcore/wl12xx/wl18xx: check min FW version
      wlcore: don't stop tx queue via watermark if already stopped
      wlcore: remove recover cmd from testmode
      wlcore: avoid debug prints during intended FW recovery
      wlcore: always clear recovery flag during recovery_work
      wlcore: don't set SDIO_FAILED flag when driver state is off
      wlcore: define number of supported bands internally
      wl12xx/wl18xx: use a dynamic PS timeout of 1.5sec
      wlcore: determine AP extra rates correctly

Dan Carpenter (1):
      wlcore: fix a couple small memory leaks

Eliad Peller (2):
      wlcore: implement .flush callback
      wlcore: check ssid length against the correct element

Ido Yariv (1):
      wlcore: Prevent processing of work items during op_stop

Luciano Coelho (2):
      wl12xx/wlcore: increase FW filename version
      Merge branch 'wl12xx-next' into for-linville

Victor Goldenshtein (1):
      wlcore: enable sched scan while connected

Yoni Divinsky (2):
      wlcore: add probe request templates for sched and one-shot scans
      wlcore: change the wait for event mechanism

 drivers/net/wireless/ti/wl12xx/main.c     |   26 ++++++++++++++-----
 drivers/net/wireless/ti/wl12xx/wl12xx.h   |   14 ++++++++++
 drivers/net/wireless/ti/wl18xx/main.c     |   27 ++++++++++++++-----
 drivers/net/wireless/ti/wl18xx/wl18xx.h   |    7 +++++
 drivers/net/wireless/ti/wlcore/boot.c     |   55 +++++++++++++++++++++++++=
++++++++++++--
 drivers/net/wireless/ti/wlcore/cmd.c      |   22 +++++++++++++---
 drivers/net/wireless/ti/wlcore/cmd.h      |    6 ++---
 drivers/net/wireless/ti/wlcore/init.c     |   16 ++++++++++++
 drivers/net/wireless/ti/wlcore/io.c       |    6 +++++
 drivers/net/wireless/ti/wlcore/io.h       |   13 +++++-----
 drivers/net/wireless/ti/wlcore/main.c     |   75 +++++++++++++++++++++++++=
+++++-----------------------
 drivers/net/wireless/ti/wlcore/scan.c     |   11 ++++----
 drivers/net/wireless/ti/wlcore/sdio.c     |    6 -----
 drivers/net/wireless/ti/wlcore/spi.c      |    6 -----
 drivers/net/wireless/ti/wlcore/testmode.c |   13 +---------
 drivers/net/wireless/ti/wlcore/wlcore.h   |   25 ++++++++++++++++--
 drivers/net/wireless/ti/wlcore/wlcore_i.h |   16 ++++--------
 17 files changed, 242 insertions(+), 102 deletions(-)


--=20
Cheers,
Luca.




--=-BLkZIMUm/m9G1KN5nNON
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP+Y2QAAoJEKFHnKIaPMX6jboQAKiqN6yL5sRyGawV4/7QHlvK
paN6Wu4z4vlGXA4bjBbm5LU7w+VbADXIBkxtdCPqyoU4YCaPd58P6QJBJTuZkNfl
vZpsi3pSrVv5MTtS+iZA32le1KrZwRf/kxM+3Qdh5qMMlCkrXMoHr1IM3W0Nx51m
cL9f7TQKk7r5rBdXtYD0KXKYNzWmVtqM8IEvg18bPWBMfXhhfYcns9wIMBcBAjVL
/6yyv3E0vSrkFwfDctv94yziGcUNxET7ry4qa61/6MM83RXzjaIDeiY0AWPiGf19
cjH+EbVtKg6DtIcX6V+1Zj1szRNPdeYox4gwwm9aq8q1cCDQPCnkzOqI7uCVmOb5
k6+vViWwPVoi8b7hrrn/t1mbHcleCUpdOjyzKkrAxDP5Gz5MbonhoMMwcZcHL7BJ
QLK+XEoZ0nh59zJk1fKOvBWawDsS8de7iogYq3yyPzzHJfygoruiR2GR5RGm1Exr
VWPrUOKCWRZtOpRT6YOR67VZR1UR4YHmYar2n5LcDhrLZ1MYBZXcnNWomoz6+Toi
utnaU2J/wqYfGugaBK2mRn2w3Sy1o6qPh2WzFM8mTsqyBzka6QWM6Tr+n1sW7Ino
n+gjkwLpNnHLwg4OyYHY29lenK+DHoaORQnh0GVp+U3+Q6vfcX+eazKKkNVqE6kb
vfjaNXJriDMLv+wKJGK9
=o/oL
-----END PGP SIGNATURE-----

--=-BLkZIMUm/m9G1KN5nNON--

