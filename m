Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51814 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754767Ab3BFQfm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2013 11:35:42 -0500
Message-ID: <1360168561.7910.24.camel@jlt4.sipsolutions.net> (sfid-20130206_173555_899354_0EC3DE1D)
Subject: pull-request: mac80211 2013-02-06
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 06 Feb 2013 17:36:01 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-XoGbMmweb+pOTBmE0yid"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-XoGbMmweb+pOTBmE0yid
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Just the fix from Cong Ding for the bad sizeof() -- Stephen Hemminger
had pointed it out at the end of December but I promptly forgot about
it.

Please pull.

Thanks,
johannes


The following changes since commit c49dc9008b1c641a86837297df7c90cef070571b=
:

  cfg80211: off by one in ieee80211_bss() (2013-01-24 15:47:22 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john

for you to fetch changes up to 9887dbf5b2163bcf69cd4456c21352e9a81c6003:

  mac80211: fix error in sizeof() usage (2013-02-06 17:31:55 +0100)

----------------------------------------------------------------
Cong Ding (1):
      mac80211: fix error in sizeof() usage

 net/mac80211/cfg.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


--=-XoGbMmweb+pOTBmE0yid
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJREoZxAAoJEDBSmw7B7bqr43gP/3oNQFBLwA72tbX8S0DMP7QS
23QE6X9piHnS9lsaQp3FG84iie7vPusBQlgiGiLxVE+tos4yRLUXof3FMaVPFVr0
h9nMlGj07nqWfraGP4/j9YKSEW125FdE6UnCh/ea/OaTaIpz3BWyN85FTZ7oHg04
G3sPqQqkCXSgyElYcFpS9CQE1WuGcN5Xt/y7paikRPsuXVPvWRxHk08c46/f/tFL
DDxCCmdaHnOFZW5sJD6IbbuJPM9U6z2UuV0o6tsUpzMjWwdSpkWOGYnAS1myexMr
xCRTTAE4RflcgaI66i47HHVY4BNvwD/OXcpzKgEatFguqKLySGQ40uj54y3rgpEt
gjY9SaPt51AVS5BbkDqXz5VbqDlkLbVnIKnvJckqdn/QBYIiEzOADtSl+vFp3m0c
uqmGEVJcXZozf6u10MfuTy5gvx8vgSqdanAbUWQ/E7qgk/BYd6ojmIT1ThvRZsnf
P1uXKfxbEiMjVAdKp/4wGNx/gH8l8C+IjOnQz/yJ7Ccmz+pPzP+M1gDsX840qy4b
HdXzg5ZDFV00TPtLO85OzU2WzF6V1szMrqG2hjNDOcZbFkSNSzewGwvKMbFq3sw/
XiGog0nOAdLf2UVZPLiNte1t9aF7wAFJDVdDv4em0Lhb53LsVNzxVg50BkFthRg+
4XRNxyE+dwG5hDpxePoa
=8VsI
-----END PGP SIGNATURE-----

--=-XoGbMmweb+pOTBmE0yid--

