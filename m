Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:48631 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752218Ab1LTVEP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Dec 2011 16:04:15 -0500
Received: by lago2 with SMTP id o2so3643162lag.24
        for <linux-wireless@vger.kernel.org>; Tue, 20 Dec 2011 13:04:11 -0800 (PST)
Subject: pull request: wl12xx 2011-12-20
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-gYyRX8EKYgzTlc818vQN"
Date: Tue, 20 Dec 2011 23:04:08 +0200
Message-ID: <1324415048.2182.82.camel@cumari> (sfid-20111220_220419_491014_7CF4BDC1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-gYyRX8EKYgzTlc818vQN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi John,

My final (hopefully) pull request for 3.3.  I'm sending a bit earlier
than I was planning due to your "threats" of going away for long
holidays.  You lucky boy! :)

We have a handful of fixes to the multi-vif stuff by Eliad, a couple of
sched_scan fixes by Eyal and one copyright notice addition by me, as
required by our legal.=20

Please pull or let me know if there's any problem. This tree is based on
wireless-next/master.

Thanks!=20

The following changes since commit 27bf88829f50cf1af2b052ecee2f6f0dbe4a5141=
:

  mac80211: Fixing sparse warning at sta_info.c (2011-12-19 15:06:09 -0500)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git for-linvill=
e

Eliad Peller (7):
      wl12xx: implement change_interface
      wl12xx: remove redundant code from wl1271_op_conf_tx
      wl12xx: make WL1271_FLAG_IDLE flag per-vif
      wl12xx: flush packets before stopping dev role
      wl12xx: fix checking of started dev role
      wl12xx: stop device role on remove_interface
      wl12xx: check the actual vif operstate in wl1271_dev_notify

Eyal Shapira (2):
      wl12xx: fix sched scan of DFS channels
      wl12xx: mark no sched scan only after FW event

Luciano Coelho (1):
      wl12xx: add missing copyright notice

 drivers/net/wireless/wl12xx/cmd.c                  |    3 +
 drivers/net/wireless/wl12xx/event.c                |    2 +-
 drivers/net/wireless/wl12xx/main.c                 |  104 ++++++++++------=
----
 drivers/net/wireless/wl12xx/ps.c                   |   10 ++-
 drivers/net/wireless/wl12xx/scan.c                 |   18 ++--
 drivers/net/wireless/wl12xx/wl12xx.h               |    2 +-
 drivers/net/wireless/wl12xx/wl12xx_platform_data.c |   21 ++++
 7 files changed, 96 insertions(+), 64 deletions(-)

--=20
Cheers,
Luca.





--=-gYyRX8EKYgzTlc818vQN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO8Pg9AAoJEKFHnKIaPMX6s3QQAJMv8cD71Zfv73EvJ9+KllZA
ORWzk5XZEEwyCpbBQ3miik0IrSz6hTRrHq1p20Gk0gJxqO6qzpQdC7PRFENEJc/M
rUy/WkF9EL9MHwOdJC+AjaMkt6tqv20sCZVh/QnKFedc/cJWG7wUAqQOgO4Pl29G
hAGram6+5zh67dzQjzmTaxmc3+LOqay66y+AOtWOrXg5rctckt3PCA6PTYIRoh/d
+KIKGYbcRJ5WUNd6o7hhDrCsGX9+hXtvpUQc17WEPbnvTCf3v+U49+dsWQtuHbTZ
EiGSkpEyPNrP3q8etGVZIe+ZtnDx7VmC9lzaZnXGoRG4zzhDR/iICkdTKNa6FSbU
RIQg+D7Z79gWILaD0p2fFHhYuIqExFCL8B4YJ3ckrLKX20vuX4zy1x28iKfvwJDg
xv6giDa+ZmXvlYLPT8+Y/OoLYASoolC6L6Xph2WvQKxKxXUZnmV6jWAbeUfeAoPc
9KxT2IjcE1kde1seZDHokHfTsjZCAhLtYUfKt61DWgFQ6vUPNTwfo1v4AA2boQHg
MP58PbOyYymL5/wgfBM25joIfzxZL5sEcPKFbK08VLpjM83oCfu1qS4jChqCuVYq
btBOulB5HQ01yqKUe6qao9fm/TFbxDWqf+JtUNVcC7iJ2hjsVaYiNB6LkAWJCSU4
o1PCU2qKlbVEXtzdChHy
=DgRb
-----END PGP SIGNATURE-----

--=-gYyRX8EKYgzTlc818vQN--

