Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:35265 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756256Ab3HOPq4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Aug 2013 11:46:56 -0400
Message-ID: <1376581601.14084.14.camel@jlt4.sipsolutions.net> (sfid-20130815_174706_983718_F445FE8B)
Subject: pull-request: mac802111 2013-08-15
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 15 Aug 2013 17:46:41 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-tzXf47qFs0hXbmwoJIeq"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-tzXf47qFs0hXbmwoJIeq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

I have two more fixes ...

This time, I have one fix from Dan Carpenter for users of
nl80211hdr_put(), and one fix from myself fixing a regression with the
libertas driver.

Please let me know if there's any problem.

johannes

The following changes since commit ddfe49b42d8ad4bfdf92d63d4a74f162660d878d=
:

  mac80211: continue using disabled channels while connected (2013-07-31 21=
:18:17 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john

for you to fetch changes up to dee8a9732e713480075adbbca8eb220c5b8d1216:

  cfg80211: don't request disconnect if not connected (2013-08-14 14:00:19 =
+0200)

----------------------------------------------------------------
Dan Carpenter (1):
      nl80211: nl80211hdr_put() doesn't return an ERR_PTR

Johannes Berg (1):
      cfg80211: don't request disconnect if not connected

 net/wireless/nl80211.c | 22 +++++++++++-----------
 net/wireless/sme.c     | 10 ++++------
 2 files changed, 15 insertions(+), 17 deletions(-)


--=-tzXf47qFs0hXbmwoJIeq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJSDPfhAAoJEDBSmw7B7bqrI1kP/2Y/3cgfCNPmhCari9+rOL2Z
ZjZnOWvgYbJSBGJLV7UWWIPVg7wPIO5WVsGW84+1YxT9vS1DcUrfTNjgJ159QgsR
V7g6ZkpwuYVV5CyX1r+Djgur2EfAzjyCacGabkI5mnWCieC1cWKMlAh4h1jGevLK
sDYkCZOzFCLSEOpC07J3IBMVK6XQA7uUd3FdNGLu+K9AbN/9HEA67LAuWsGytrIT
yPxH7TMZlGoHbM9fhVm02yV6m322Qr3mq2hf6OULcHcSdj9xNPfS8oXWyhWUYBxE
fGK9iauwYwdIo4vLddqHmahFQmz9PCbelIKQjLm2Dw7vgMod7VlogwZ3pUXzjf4l
Grfb9TVWKdeqClb+LA7TXHO52Hs2T1cUrFY9phk7MybD/wBdRlv8GwHH5CiY/0it
6tj+1STsKWRfmihF+a5lHXX+Jy60afI4YX406HpUvk3XbRmW78dCn4Vt/0NcmTr5
IG2SBS6vRcm/2I6gPrfrSWefKiJGA5pmJUsAJqhZxhVcZZ9kpFzJOILroJhRMKyh
EpsDIvAa2j8CZrw1DtD3A9xOmOt/YidktjuVj1jUT+hAwM4qUgOnzCStjR/7nTQB
w0841h9+0ZDlDsIYliC/ff+wo3kJEYaXP2HNVRke4rXZsG/mil2YeNiCwNSw268R
onsWli8pYvKSUeXVtvGD
=nW/G
-----END PGP SIGNATURE-----

--=-tzXf47qFs0hXbmwoJIeq--

