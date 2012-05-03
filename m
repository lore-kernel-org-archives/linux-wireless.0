Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog134.obsmtp.com ([74.125.149.83]:44883 "EHLO
	na3sys009aog134.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754339Ab2ECNHz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 09:07:55 -0400
Received: by lagw12 with SMTP id w12so225008lag.38
        for <linux-wireless@vger.kernel.org>; Thu, 03 May 2012 06:07:52 -0700 (PDT)
Message-ID: <1336050471.12189.37.camel@cumari.coelho.fi> (sfid-20120503_150759_735515_824BD0D7)
Subject: pull request: wl12xx 2012-05-03
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Date: Thu, 03 May 2012 16:07:51 +0300
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-e1C9gOqGYtcbKlYV0KB6"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-e1C9gOqGYtcbKlYV0KB6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi John,

This is another pull request intended for 3.5.  A few fixes here and
there, stuff that has been pending for a while and I hadn't had the time
to apply.  Nothing really major.

Please pull or let me know if there's any problem. This tree is based on
wireless-next/master and the head I want you to pull from is
422823e85d3957b64c573a2f15c6172d78de1e00.=20

Thanks!=20

The following changes since commit 0a9b3782ef402d27c3e6d1b116f10076a9dd088c=
:

  {nl,cfg,mac}80211: Allow user to see/configure HT protection mode (2012-0=
5-02 14:30:55 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git for-linvill=
e

for you to fetch changes up to 422823e85d3957b64c573a2f15c6172d78de1e00:

  wlcore/wl12xx: implement better beacon loss handling (2012-05-03 15:45:03=
 +0300)

----------------------------------------------------------------
Bartosz.Markowski@tieto.com (1):
      wlcore/wl12xx: implement better beacon loss handling

Dan Carpenter (2):
      wlcore: release lock on error in wl1271_op_suspend()
      wlcore: fixup an allocation

Eyal Shapira (4):
      wlcore: add RX filters util functions
      wl12xx: add RX filters ACX commands
      wlcore: add RX filters driver state mgmt functions
      wl12xx: support wowlan wakeup patterns

Jesper Juhl (1):
      wlcore: fix size of two memset's in wl1271_cmd_build_arp_rsp()

Luciano Coelho (1):
      wlcore: use GFP_KERNEL together with GFP_DMA

Randy Dunlap (1):
      wireless: TI wlxxx depends on MAC80211

 drivers/net/wireless/ti/wl12xx/Kconfig  |    1 +
 drivers/net/wireless/ti/wlcore/Kconfig  |    2 +-
 drivers/net/wireless/ti/wlcore/acx.c    |   79 +++++++++++++
 drivers/net/wireless/ti/wlcore/acx.h    |   30 +++++
 drivers/net/wireless/ti/wlcore/boot.c   |    3 +-
 drivers/net/wireless/ti/wlcore/cmd.c    |    8 +-
 drivers/net/wireless/ti/wlcore/event.c  |   29 ++---
 drivers/net/wireless/ti/wlcore/main.c   |  322 +++++++++++++++++++++++++++=
+++++++++++++++++++++++--
 drivers/net/wireless/ti/wlcore/rx.c     |   36 ++++++
 drivers/net/wireless/ti/wlcore/rx.h     |    4 +
 drivers/net/wireless/ti/wlcore/wl12xx.h |   41 +++++++
 drivers/net/wireless/ti/wlcore/wlcore.h |    6 +
 12 files changed, 531 insertions(+), 30 deletions(-)


--=20
Cheers,
Luca.


--=-e1C9gOqGYtcbKlYV0KB6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPooMnAAoJEKFHnKIaPMX6CpQP/3ehPNSRSpMx34G1lZvHH9iU
MWaQL+QAKIOpWfooa+u26q4xWSy3+G/ohVsFHAoQacHeq9XLNhS9R62oJo+A9heI
PyaG2czO2AoOBzmW/uqPltF18m/sf42CaZ8YlTIO+wX/IAMkBaEWBQnJT7pqJaNv
gLlOG1bS3VjCEgEBBg6sAFDgZw7uR6yoCom2t14nWfL2qunl+YxKfS5IPro3+rmH
Aw33Soy9Ylmkv+6mvKHWP4ObPtNOtq8s+yVC+vMnecIw3p++RUxBqre4grUq1rcr
zcX+fIlBWX8Jwg/A55FRG7v78dllsiB0eDdEC51gyt66JJ6rNLyw+cMSZT5ZlWeh
7lG7Zitx3ir4JWGPYsakcZUoDh7Qo/nvc6BAws4W0QvIHJDVNYA27xemD3IN0yvO
x+Cw4GPrHNTEj1yE7W21zGtLW/DypkfWHR2jXFkp97Boe+9BmE+4HLZdzGj3fNdn
wBpwwqJXi5VCmrRg2VeAcMBWHhHs3NpGMWlAYRKBJi0Bsw0bsmOprJ9slOknlcB2
khoGSwG/MZGfYIjmgt46JIgNORMnJGo8Xz2pW8C1J56uabt5aaIMYDpUgPPG7+PJ
tM0khkvaIxz7NpJujz0XqzTUKQt6/dPFyGcZn7J6Z4CejZOJwIzhXelMCXdmUmOF
8Pc9OMxLQgffABv8SAEz
=Bo8Z
-----END PGP SIGNATURE-----

--=-e1C9gOqGYtcbKlYV0KB6--

