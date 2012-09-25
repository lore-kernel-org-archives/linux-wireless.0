Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39704 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548Ab2IYHxt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2012 03:53:49 -0400
Message-ID: <1348559661.10041.25.camel@jlt4.sipsolutions.net> (sfid-20120925_095352_000309_EF542488)
Subject: pull-request: iwlwifi-next 2012-09-25
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 25 Sep 2012 09:54:21 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-Hmpp62Nyuqdx4rC+x3kR"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Hmpp62Nyuqdx4rC+x3kR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Two more changes for iwlwifi, one to fix a recently introduced crash and
another to use eth_broadcast_addr().

Please pull.

johannes


The following changes since commit 83f84d7bd49f9e4deea0a77a76c9882673ee1f3c=
:

  iwlwifi: load firmware in chunks (2012-09-10 19:14:30 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git fo=
r-john

for you to fetch changes up to 513aa3b0d14be809490d5c151994cc7f047b0718:

  iwlwifi: fix async station command crash (2012-09-20 16:37:40 +0200)

----------------------------------------------------------------
Johannes Berg (2):
      iwlwifi: use eth_broadcast_addr
      iwlwifi: fix async station command crash

 drivers/net/wireless/iwlwifi/dvm/scan.c |    4 ++--
 drivers/net/wireless/iwlwifi/dvm/sta.c  |    7 ++++---
 2 files changed, 6 insertions(+), 5 deletions(-)


--=-Hmpp62Nyuqdx4rC+x3kR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJQYWMtAAoJEDBSmw7B7bqryfkQAK4U1VQStmRIm/t6gSTW9uit
p+aNk9DNALzI77ec5QXLaOrAI61W3WEwL4Kf/fJiopuN+9noIn+/fKGpaLa0ppyU
P/GfkXu5gqwFj+LOuRbiee9QZDHB9+yahYgkqaayixajwhNyiA/CHTjS7DQJLqcD
XkO1Sovtihxe+1kwUnuGCJMzlYa/oPNp3hH+HedWL8rLVkBFc0iEjoPGKDs6BMdQ
i3/dg3GWQwVPg7M0zXEJJ0CpowUSAN5hh+c1VfR6YYkAcfdF7hm676KLkM5TB/4B
G6MB7x8N3jPkp+FVFkGE8OPoYIq0cqgugu5seONVrVPxwQoQ2CkWQY5fPBQ/2vYc
8YrbNjinpost098kTPl9KK2qHlyrJJac30EpUJrlG9OiCzkcvS25ddmX0AeBWJYW
u8j8MR0Ge7GgbnV9AarCmjdlc22nZnAjeI3SsObHHdcYrp4E2VPMZlkvgFFu213w
dsaTc1fCExOXrzDU83x0E2rEBgbCk9/k5si+fYdrwE659e3ZA0ndA/rz2VJ8o3yi
Twe0z+pOoE8iLz5C5GIODEYpeGN0Cu4laq5PYj6LAgMU0ZIh7cFjr41BZDipipCD
hJkqIfpySwHZV16Zf3vhr1Q7DNyJ0twBMFMwK/6X9M0gBZZwB7PPkO+0TQHDV1Sr
Llo0AsozhMTxpEOYyABP
=MQKB
-----END PGP SIGNATURE-----

--=-Hmpp62Nyuqdx4rC+x3kR--

