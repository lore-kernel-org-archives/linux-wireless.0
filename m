Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:41595 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762Ab3LPOx4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 09:53:56 -0500
Message-ID: <1387205627.2057.16.camel@jlt4.sipsolutions.net> (sfid-20131216_155359_776319_F527BAAA)
Subject: pull-request: mac80211 2013-12-16
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 16 Dec 2013 15:53:47 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-1g88B7B51D2R9Q8S1gbC"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1g88B7B51D2R9Q8S1gbC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Two more fixes ...

Here's a fix for another potential radiotap parser buffer overrun thanks
to Evan Huus, and a fix for a cfg80211 warning in a certain corner case
(reconnecting to the same BSS).

Let me know if there's any problem.

johannes

The following changes since commit 0834ae3c3af44480834cce128b6fef83006e537f=
:

  mac80211: check csa wiphy flag in ibss before switching (2013-12-02 11:54=
:13 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john

for you to fetch changes up to bd02cd2549cfcdfc57cb5ce57ffc3feb94f70575:

  radiotap: fix bitmap-end-finding buffer overrun (2013-12-16 12:06:43 +010=
0)

----------------------------------------------------------------
Johannes Berg (1):
      radiotap: fix bitmap-end-finding buffer overrun

Ujjal Roy (1):
      cfg80211: fix WARN_ON for re-association to the expired BSS

 net/wireless/radiotap.c |  4 ++++
 net/wireless/sme.c      | 22 ++++++++++++----------
 2 files changed, 16 insertions(+), 10 deletions(-)


--=-1g88B7B51D2R9Q8S1gbC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJSrxP7AAoJEDBSmw7B7bqrHncQAMs9u1T35reIItkNKK5HzQAX
9G6W4yisU2mfGL9BhUIwBJ0LVW+k0wv1X8fFQi7y2sLGCYWZTh6l/+mlzJfkOOaz
uCmjHcPiT7k0R2D50Egwv2X0a4v82vOOE+qjdavgum3jVPnSlr7RF/3QKBiaPI2H
FvN7IC3GSrW+srOvmYU12geQf6jc6ADmDrsVAb9qP+5/L9RDbK1bh23dS8KrDafL
7n2QtfrmUmDVPaOo4g/ls8scGIO7SVM8Xv0GWuG+y5jApR2inK4JHIA4GdYA/Dcr
3uQZUGQVtVzU0v6TgRtjvM3Viv+Kw4U6ZLVKpaiIpbuWFKJCgvvN/r93CuiF09pL
Q4FGpYG+7VP3jXXctrZj+Lz4ux3ngxS7aKF7nWFLgKtmC4EWzCVlFUL6L7dzzkTI
5AoOyyVjJtKe9I9Ak5ejrwW6F75fo1HL6AYCen6Vl3ntlrxfburTW5OObFxGaWbT
rFVw/vVfW08K3n/btDyXyrS2DOt+5dP5SZKlFoSJdlgPnmEOriiIbr/k6et1Z/Yo
OM582gK5YEh5HuYuFLaz1XIRUyF0fxyOKIvCqgIjk7kC9TspcvxfF+Ig2vO6VDgO
cElNdmC7tZoOy4/lzUSz0HqlgJhbeT/T+gloTp8W82Y7F+8LgRSgknXa4SpbKG/1
FrCx25BHwPqUCiowBRmy
=xVP8
-----END PGP SIGNATURE-----

--=-1g88B7B51D2R9Q8S1gbC--

