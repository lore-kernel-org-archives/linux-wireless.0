Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:53629 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755177Ab3FCOru (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 10:47:50 -0400
Message-ID: <1370270859.8227.4.camel@jlt4.sipsolutions.net> (sfid-20130603_164753_265310_2A6F7781)
Subject: pull-request: mac80211 2013-06-03
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 03 Jun 2013 16:47:39 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-5EOJ8XMZftJXdPEX6ZXF"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-5EOJ8XMZftJXdPEX6ZXF
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Here's one more fix for mac80211 (along with a constify patch it depends
on) to work around problems with certain (broken) APs that forget to
include HT IEs in their association responses.

johannes


The following changes since commit ac20976dcaeea3e77e40e9aac8f3799d2a22ea2b=
:

  mac80211: Allow single vif mac address change with addr_mask (2013-05-27 =
11:26:48 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john

for you to fetch changes up to c2c15e215e860c99b86ddfc4be4bb25cf180fed0:

  mac80211: work around broken APs not including HT info (2013-05-29 00:56:=
13 +0200)

----------------------------------------------------------------
Johannes Berg (2):
      mac80211: constify ieee802_11_parse_elems() argument
      mac80211: work around broken APs not including HT info

 net/mac80211/ieee80211_i.h |  5 +--
 net/mac80211/mlme.c        | 87 ++++++++++++++++++++++++++++++++++++++++++=
----
 net/mac80211/util.c        |  4 +--
 3 files changed, 85 insertions(+), 11 deletions(-)


--=-5EOJ8XMZftJXdPEX6ZXF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJRrKyLAAoJEDBSmw7B7bqrC7MP/3RNaIH8/slTCwY4IIaWjYmz
/zre/LZr5KcG3wMNqL9QAhCq0GKrFJhLvlKcqtSBGZt9Tus1tfDnH0Y66kb+wva2
tN3g8580etYNJ+lKbS/yNzbHqMoszVdNGUiGSAV3QWS09KQ0EdY1KdINBLk1+6yE
KLh6PaLyj7CgzX1hjig8jo0YXgYOE40kXLNHnPqqZFvK46rF9CL6Gw8V+jZsMq55
zIqTeAwLx16Nwso6xkzSgnjVYbv8SRdHDOEdtHaODmqvBTKqWxWTyqyA36i87C21
KiWWRfufVNoNQy4OLUUJkmLnfjgv1F2gFzH5bibI3TOfJgqloh6Xwr49xq0ddHwd
0GWJggzV6g4nNYMJGMErwOrAfZ4dIjYf47Ui6ySnrHnsg4N9BO9pyFlvSswmU6hn
tI5e5RrFZJ1a38TZO0M59NsKikJ3C7ryUpd+x2x0k1zJ5ROWOCFN9RGtTFZJpXBC
1aXJDAw7P/qLyIg6e/E8KwuYmNkn0qKPSnJNNOS1aCFqr5D4DL8u3HivHt2GZ6Mj
U61VNeh4wuytAzcQwSORn+/Ccf+1en+0WDoeSIY4/eX7o0UkY+S97wmWYoG9aY+4
VtsFP/nrAlm31EGszi7nym8jPefMPAcgvMtXA0jxLsV28Rup5X9d5CwDXqw/bjK/
rsCgaOErARkGxmBSNUIR
=L/wh
-----END PGP SIGNATURE-----

--=-5EOJ8XMZftJXdPEX6ZXF--

