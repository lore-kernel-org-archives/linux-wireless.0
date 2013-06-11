Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38609 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238Ab3FKSVT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jun 2013 14:21:19 -0400
Message-ID: <1370974866.8356.60.camel@jlt4.sipsolutions.net> (sfid-20130611_202122_369239_844DFB56)
Subject: Re: pull-request: iwlwifi-next 2013-06-11
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 11 Jun 2013 20:21:06 +0200
In-Reply-To: <1370974531.8356.56.camel@jlt4.sipsolutions.net> (sfid-20130611_201543_141311_7A590D93)
References: <1370974531.8356.56.camel@jlt4.sipsolutions.net>
	 (sfid-20130611_201543_141311_7A590D93)
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-lDVxpaVAmJrjF5RwMYUV"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-lDVxpaVAmJrjF5RwMYUV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi John,

Still it's mostly cleanups, with a few fixes thrown in. I had to merge
wireless-next/master to get the interface combinations revert that I had
to do due to my own stupidity :-)

Emmanuel contributed two AP mode fixes, removed an unused field, fixed a
comment and added a warning for something that shouldn't happen in
practice, and I removed the declaration of a function that doesn't even
exist and cleaned up a small include.

johannes

The following changes since commit 8b3e7be437a6b62118d0485ad971e724afe23fdf=
:

  cw1200: Fix an assorted pile of checkpatch warnings. (2013-06-11 12:48:10=
 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git fo=
r-john

for you to fetch changes up to 8eb3871076875f247483f4a1fe6713e6d440c53e:

  iwlwifi: mvm: Update the supported interface combinations (2013-06-11 20:=
17:06 +0200)

----------------------------------------------------------------
Emmanuel Grumbach (5):
      iwlwifi: mvm: remove unused wait_for_ba field
      iwlwifi: mvm: fix irrelevant comment
      iwlwifi: ignore 0-length PHY DB sections
      iwlwifi: mvm: properly tell the fw that a STA is awake
      iwlwifi: mvm: don't set the MCAST queue in STA's queue list

Ilan Peer (1):
      iwlwifi: mvm: Update the supported interface combinations

Johannes Berg (3):
      iwlwifi: mvm: remove iwl_mvm_dbgfs_set_fw_dbg_log declaration
      iwlwifi: include export.h instead of module.h
      Merge remote-tracking branch 'wireless-next/master' into iwlwifi-next

 drivers/net/wireless/iwlwifi/iwl-drv.h      |  3 +--
 drivers/net/wireless/iwlwifi/iwl-phy-db.c   |  3 +++
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c |  5 +----
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |  9 ++++-----
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |  5 -----
 drivers/net/wireless/iwlwifi/mvm/sta.c      | 11 +----------
 drivers/net/wireless/iwlwifi/mvm/sta.h      |  2 --
 7 files changed, 10 insertions(+), 28 deletions(-)


--=-lDVxpaVAmJrjF5RwMYUV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJRt2qSAAoJEDBSmw7B7bqr/2wP/0NnzMcsbf4tbSiShlH19mPU
NpcE88fJJdbJSqJZpx6rCCHLpfOT0Pq7q75FMGpfCCkL7mgir2RODSfNqpPqxUvi
jin7+v6GG6qfbgfMJ/L1vkuIucaUHa91p6s81wXI0TUSSrhwJ20JbRHifFX3TGEy
CRcr2FyaapWhiguxqQ38XjV6eE8Sp0cmK7yOim+Qx0FEOv9UMinwAU+tS7wLT55c
/q+X7nRhsYHZ5b9h5K8My6WMiAPIq1hZU45J+op0HaUSPlnrwmZBELER0RrYI6oE
7P55Gx1STYjBm9mgDYOhV0cCXQq5Yh0ja70oJ3ai/+RHybBtC5RPWYVQdNbuuIb/
2Ie6eEinD/u2AchUksipwck5F7j2W/FR0VJXZiFeePwfEk7riuI/Mo1y+JzFMEVF
WpQo23/YIkB5dkjeJQnME8SQm7rk1LE46Z0I9iNb1TQJpdoGVPATl6SETs4tCtBy
w+W4ahk27jNdHIgz9OhuWzQ5y7tSqPkjlVRbAjlex7s0smBxBVkXMqcRPinjzXAA
E6ZNHoS7i74HW+B6s47l9GZEHrmTvgm+zjDuaQWm3jXpMJCLtwlQtZxH5waXPDY2
mLPTfq+YgWJNU8gOgSIoQgov63nC4ZqCM8UUO7ZZ2E2qnMeRDXXp/MXBHQvsJO2K
F0gUK3/QOt+0GTaQHsGA
=ijsy
-----END PGP SIGNATURE-----

--=-lDVxpaVAmJrjF5RwMYUV--

