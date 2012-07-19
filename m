Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46687 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602Ab2GSJfH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jul 2012 05:35:07 -0400
Message-ID: <1342690499.6383.3.camel@jlt3.sipsolutions.net> (sfid-20120719_113511_183338_AF63ED76)
Subject: pull-request: mac80211-next 2012-07-19
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 19 Jul 2012 11:34:59 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-38pPZZzcgqch6l60E2gt"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-38pPZZzcgqch6l60E2gt
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Please pull these two patches, the important one is the regulatory mutex
fix (for which Luis should go wear a brown paper bag ;-)) )

johannes

The following changes since commit 88bc40e8c3d3bca7d26c756bb0b823d4abad3355=
:

  mac80211: go out of PS before sending disassoc (2012-07-17 12:17:42 +0200=
)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for=
-john

for you to fetch changes up to 99102bd380f27b8dd5e058e69e3203bfad0cad94:

  mac80211: flush stations before stop beaconing (2012-07-18 17:03:51 +0200=
)

----------------------------------------------------------------
Eliad Peller (1):
      mac80211: flush stations before stop beaconing

Mohammed Shafi Shajakhan (1):
      cfg80211: Fix mutex locking in reg_last_request_cell_base

 net/mac80211/cfg.c |    1 +
 net/wireless/reg.c |    4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)


--=-38pPZZzcgqch6l60E2gt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJQB9TDAAoJEDBSmw7B7bqr2TkQAIKRHzXCk8WI0RKJ6YXXzM2m
y//rpUsscLL2ZZc9WWADjc2zSewtTJCOilpeWJU30eys3oGSsuEy2Uukl0gi8BoO
dbroW1k5C8JJzCcdVQjQVDsN62Lr19ni5Vh3syLfFGMYgg4hAsl/yoW9OSZLTYN/
ZfxZgtqEIgD/SqAIM4KKNEFcDyyorhH6xZJmv7Zu9PmyvVm6mH7XwG+d5fsoVFbe
OFi7N+lYow5oQ3X5uPZZp5+FjZ8FpdzEuhC7YecjW9XxyPE0GwLfE7lxd7U2byXm
Y3HFrT9R3EWJjNQ1IliJD5ekHwMlY59fM6lf6q/04EebIBRK70XB20nmJje2lGo2
XRZIbirVz263SWfbHT2Xah5eTRVJaep/HDoRIp0lsNs/748fdxiCOYMPwXf98EWp
8x5xvBJ5CbVkQ2GAZN7TbSqWoWHOJfvhnHh0C7/6FkgtElMm6nhoOvyWgjaLM8vC
0Qd6KoEJwLB7xDEQ3YufuezjktaPXMMeH1wmuEkOGgwVraH7oQWcisfmeIu51Tcp
NZ/1lVfNzYggfQDE2jVLrtARK8dkaR/UDtyqNxtWNgrZF/Yl+KSJ2zZc0l2DYTQo
oiLn08iYPqkWpxunjkTPs/QmKEh1CpXS0J3kSmifCBVkjbYOE3DrqPC0mEnGPcWx
VzdREMG8+qESNJqSy5T1
=h2C2
-----END PGP SIGNATURE-----

--=-38pPZZzcgqch6l60E2gt--

