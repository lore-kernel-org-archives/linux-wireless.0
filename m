Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41092 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755865Ab2J3IIg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Oct 2012 04:08:36 -0400
Message-ID: <1351584547.10097.3.camel@jlt4.sipsolutions.net> (sfid-20121030_090841_705989_3E2246A3)
Subject: Re: [PATCH 0/4] iwlwifi: some 3.8 updates
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 30 Oct 2012 09:09:07 +0100
In-Reply-To: <1351584463-11469-1-git-send-email-johannes@sipsolutions.net> (sfid-20121030_090719_610608_09EBA71A)
References: <1351584463-11469-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121030_090719_610608_09EBA71A)
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-SerGQF30qogJjNFtA4zA"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-SerGQF30qogJjNFtA4zA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Please pull these changes as per the pull request below.

Thanks,
Johannes

The following changes since commit 4e760f1ab267edcd6e4b232ff732fc9cdc659ebb=
:

  iwlwifi: don't WARN when a non empty queue is disabled (2012-10-16 16:41:=
40 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git fo=
r-john

for you to fetch changes up to 3e2c159260eed10c44f0dd028c328a40a27ad235:

  iwlwifi: clarify NOCOPY/DUP documentation (2012-10-29 11:27:33 +0100)

----------------------------------------------------------------
Assaf Krauss (1):
      iwlwifi: remove MFP Kconfig option

Emmanuel Grumbach (1):
      iwlwifi: don't leak Tx skb when a queue is disabled

Johannes Berg (2):
      iwlwifi: support host command with copied data
      iwlwifi: clarify NOCOPY/DUP documentation

 drivers/net/wireless/iwlwifi/Kconfig         |    9 ----
 drivers/net/wireless/iwlwifi/dvm/mac80211.c  |    2 -
 drivers/net/wireless/iwlwifi/iwl-trans.h     |   11 ++++-
 drivers/net/wireless/iwlwifi/pcie/internal.h |    3 ++
 drivers/net/wireless/iwlwifi/pcie/rx.c       |    3 ++
 drivers/net/wireless/iwlwifi/pcie/trans.c    |    5 ++-
 drivers/net/wireless/iwlwifi/pcie/tx.c       |   59 ++++++++++++++++++++++=
----
 7 files changed, 68 insertions(+), 24 deletions(-)


--=-SerGQF30qogJjNFtA4zA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJQj4sjAAoJEDBSmw7B7bqrHjsP/1uYJGLZrJgRqKpZAeUEBdoN
3qBQcS+OVlIeKr+RZsfOZkQu4tb1ctnXGxpc7erY4OMp3Qk1wEhFHnGfo1qMtVhQ
0GJYWkgmIaYYc46wrV3PRI6mby8RpBZYCAjb3r1I0kkGIikT+EHL6h6mJ191gw9x
Y++Fxn0CgH1s0aMoMsgKPFXZUx58X9GbRJrAD90k4dE06gSIlDxPEjHzv5LsvADg
avr5ogagyqSVMl15yyNe0EGYt+6e0Z3xUMF67e6WZtG0ELTTt8hquCcgCgkargkr
1JftGlEcww7rmOBSOUBsS4Ed4vOGi4jWQ9gOWtenkdd5KZTgTn0yjD8j184v8AiZ
BS1iaFkH5mSHioFUPDkQSmZKRhBeoTDQvoy6RHMAzNbv9zQHd1okcJmO08qWbeFD
3TZoTe//CL7ECKr+Y/XNh8xn8mJAuIVHtlBGWfTD1AGv5ALzWgRtciYUsO75k5aR
wiX6pSMpL0jfrD5hhPGXm4wD8ot+ehjrot6Cd2ba9Cr6F+WKuB0QLYe+HhnFQ8Js
GbvBil46LRLTr5AyDc93vAAY1+DNOsHlZFlhUNMHFESkNbyzBGM/ge268Zah94p5
igr/3nwg2VWnzx4/mGbN7/CG5v3GsjynLiKZP9Z5jcxUQYbcIEfpXUFKHRpKV0A8
0k+zfYedB08BWovjp5Zl
=PzVy
-----END PGP SIGNATURE-----

--=-SerGQF30qogJjNFtA4zA--

