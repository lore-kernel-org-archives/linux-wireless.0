Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43865 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580Ab3BRTaI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2013 14:30:08 -0500
Message-ID: <1361215785.8555.46.camel@jlt4.sipsolutions.net> (sfid-20130218_203014_135267_BA8F1934)
Subject: Re: pull-request: iwlwifi-next 2013-02-18
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 18 Feb 2013 20:29:45 +0100
In-Reply-To: <1361215715.8555.45.camel@jlt4.sipsolutions.net> (sfid-20130218_202853_285271_74FED3FD)
References: <1361215715.8555.45.camel@jlt4.sipsolutions.net>
	 (sfid-20130218_202853_285271_74FED3FD)
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-wgOVoyZx68167VnpEJP3"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-wgOVoyZx68167VnpEJP3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-02-18 at 20:28 +0100, Johannes Berg wrote:

>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git=
=20

Hmm, I lost the branch there, let's try that again.

The following changes since commit 9e97d14b4923da524d202f2e005d5d30b70db9d6=
:

  Merge branch 'for-linville' of git://github.com/kvalo/ath6kl (2013-02-15 =
14:06:32 -0500)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git fo=
r-john

for you to fetch changes up to cfe418287c61f4c4a3ccb94e8a286434d64e0236:

  iwlwifi: dvm: improve (again) the prints in reclaim path (2013-02-18 20:1=
9:25 +0100)

----------------------------------------------------------------
Emmanuel Grumbach (1):
      iwlwifi: dvm: improve (again) the prints in reclaim path

Eytan Lifshitz (1):
      iwlwifi: dvm: fix delayed enter to CT-kill bug

Ilan Peer (3):
      iwlwifi: mvm: Set the scan type according to the vif type
      iwlwifi: mvm: Fix resource allocation for P2P Device
      iwlwifi: mvm: Reserve MAC id 0 for managed interfaces

Johannes Berg (6):
      Merge remote-tracking branch 'wireless-next/master' into iwlwifi-next
      iwlwifi: mvm: fix merge error
      iwlwifi: mvm: program DTIM timings properly
      iwlwifi: mvm: fix GO powersave client manipulation
      iwlwifi: mvm: add debug statement to time event add
      iwlwifi: mvm: fix time event command handling race

 drivers/net/wireless/iwlwifi/dvm/commands.h   |  1 +
 drivers/net/wireless/iwlwifi/dvm/tt.c         |  2 +-
 drivers/net/wireless/iwlwifi/dvm/tx.c         | 51 +++++++++++++++++++----=
----
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c   | 47 +++++++++++++++++++++--=
-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c   | 10 +++---
 drivers/net/wireless/iwlwifi/mvm/rx.c         |  1 +
 drivers/net/wireless/iwlwifi/mvm/scan.c       |  7 +++-
 drivers/net/wireless/iwlwifi/mvm/sta.c        | 14 +++++---
 drivers/net/wireless/iwlwifi/mvm/sta.h        |  6 ++--
 drivers/net/wireless/iwlwifi/mvm/time-event.c | 10 +++++-
 10 files changed, 114 insertions(+), 35 deletions(-)


--=-wgOVoyZx68167VnpEJP3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJRIoEpAAoJEDBSmw7B7bqr4bAQAM69LvRCmadoypvQz/tOx0Q7
+VrRGrnn2jNWACUUPHwwDMwqZ09b56MoGexNb1Q34uA3NN7HecleKxQPun0Pz06K
6+btfNlnYv51SjkrAKgFKJKIKj5CM4m8wcdsCMNDuPBEZdeb5ObpU+sWekUl5bRY
fJDo7xSBu3RWS0SedT86zqXNGZR3tOaQhpyQLDgdKq/cqniIiDjZlE2xOtgK7JhJ
aJudhHAUntDSltR5gsT3og+dRVULb6bXiRWY2RE0Gx2FZDqiR98H3FzqizXRlmIe
YbuQTY+YAZK/urZEvs4207fhmVBO88CDQtz2k5QoAZ9pHARQFGJtiAb17TDJyTmr
VslRksDyQiUUB76WTs9uQbU8Ww4CcxsD3oP6UfHoalsyrHFpP6w5c66DOlxyiYbZ
aemLO/xFhlBqoOUvgkyuDe53o6LJpkGHvhX72g/0/a2pFlFx7m9P7AZZqIA8Hs3B
Mnl84ky/lXf5QUSFlhwsVFWfoggQMDAH/N9/mUCZ8tRuPA+/1BkBu4fqW3MT2Ic3
TPL3IumZv+4EeN/ntkyMtBGdXzNnfES6TYQWSoOnANNd1AmFju7li6UynqBtVpiZ
wNXr/H/DX5pDJJ6Dj6rMlqw083MWWfjvsoxP9tV0GN8eXNR/B2TOycLf/ea1x0M/
mYCa8TRUkY8oJVcpEh5X
=OerN
-----END PGP SIGNATURE-----

--=-wgOVoyZx68167VnpEJP3--

