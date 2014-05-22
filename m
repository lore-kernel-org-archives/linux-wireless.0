Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:62533 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbaEVHXP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 03:23:15 -0400
Received: by mail-wi0-f169.google.com with SMTP id hi2so9493101wib.2
        for <linux-wireless@vger.kernel.org>; Thu, 22 May 2014 00:23:14 -0700 (PDT)
Message-ID: <537DA58C.5050003@gmail.com> (sfid-20140522_092724_883829_35079880)
Date: Thu, 22 May 2014 10:21:48 +0300
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	ilw@linux.intel.com
Subject: pull request: iwlwifi-next 2014-05-22
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="Uwug7Velx7a8K1K82cN8MUvU6jG3leMRJ"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Uwug7Velx7a8K1K82cN8MUvU6jG3leMRJ
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi John,

This pull request is intended for 3.16.

The regular amount of housekeeping here. I merged iwlwifi-fixes.git to be=
 able to add the patch you didn't want in wireless.git at that stage of t=
he -rc cycle.
Luca has a few preparations for CSA implementation and also what seems to=
 be a bugfix for P2P but hasn't caused issues we could notice.

Please pull.

The following changes since commit af7c603eb476216f1c27d82b802f0ce879c54a=
b3:

  iwlwifi: fix LED support Kconfig dependencies (2014-05-15 19:56:18 +030=
0)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git =
for-john

for you to fetch changes up to 999609f1206a14039db534058b251c6d5ab39322:

  iwlwifi: mvm: remove vif argument from power_update_mac (2014-05-22 10:=
11:17 +0300)

----------------------------------------------------------------
Arik Nemtsov (1):
      iwlwifi: mvm: remove vif argument from power_update_mac

Avri Altman (2):
      iwlwifi: mvm: Remove redundant initialization
      iwlwifi: mvm: don't filter out the first beacon

Emmanuel Grumbach (6):
      iwlwifi: mvm: don't allow diversity if BT Coex / TT forbid it
      iwlwifi: mvm: disable beacon filtering
      Merge remote-tracking branch 'iwlwifi-fixes/master' into iwlwifi-ne=
xt
      iwlwifi: mvm: disable reduced Tx power when not applicable
      iwlwifi: mvm: remove debugfs hook for reduced tx power
      iwlwifi: mvm: make iwl_mvm_update_beacon_abort static

Luciano Coelho (4):
      iwlwifi: mvm: update power after phy_ctxt is NULL when unassigning =
chanctx
      iwlwifi: mvm: enable MAC_FILTER_IN_BEACON when forced_assoc_off is =
set
      iwlwifi: mvm: set the MAC_FILTER_IN_BEACON flag also for P2P
      iwlwifi: mvm: pass force_assoc_off all the way down to avoid hacks

 drivers/net/wireless/iwlwifi/mvm/coex.c        |  12 +-
 drivers/net/wireless/iwlwifi/mvm/d3.c          |   8 +-
 drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c |  44 +-----
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c    |  26 ++--
 drivers/net/wireless/iwlwifi/mvm/mac80211.c    |  44 +++---
 drivers/net/wireless/iwlwifi/mvm/mvm.h         |  16 +-
 drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c    |   3 +-
 drivers/net/wireless/iwlwifi/mvm/power.c       | 162 +++++++++----------=
-
 drivers/net/wireless/iwlwifi/mvm/scan.c        |   2 +-
 drivers/net/wireless/iwlwifi/mvm/sta.h         |   3 -
 drivers/net/wireless/iwlwifi/mvm/utils.c       |  51 ++++--
 11 files changed, 169 insertions(+), 202 deletions(-)


--Uwug7Velx7a8K1K82cN8MUvU6jG3leMRJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTfaXIAAoJEC0Llv5uNjIBui4QAJzSsDHmenp/rd6WCwnVN0lF
mJbv6KNwlar67FJswq01O7Zb6v4DFMNxanHCCHM4br4B2Sb14C7zBENZMNTlxJBJ
nFyZ9/qx2FbBzDPRg4fHmit3uMlnjTem0UJuJ1UVucxqGC5bXET5si4CiocfaAbP
LJC/onF6l4ju4IYvoEEJSOqGbRkuLCM+IU5GtJyGna/S6pcfyTTlUjzbYsOLGa/d
EUY97uLUCII6xCoWyFMgbdH1zi2O1NBm/01S2voYBhv3NZV5rf4pMjyVhQcqDI9h
H7xuTPGH7t1p8t/Xl8saHzWkLbuZI51FE/GUnbNcV/CFE0Pzivupls1knVXUJ9Vj
O24/VJnZvqsZGgdZPfZf5plvOTa2p1r2TdwolFZrRfhmkg81nQOPSwc5SCDxmfcp
H3ZmS9TNsUFBNNwKqvbV1+y+mKqlI9quXbNzc+o0jEnc1r3GygTODCi3ksIU6viZ
m+L86CRkrRiKMS31jCFnyPDqJSzlovaz/Z5z+7nqd0BsdHjW7tA9HsRqIV21ralA
f66NSCbSUK2MLbvKd6X3Eux8/1Dq+bpboZWs6hEGUz3Uc8l4qifY4QnGvIj751yG
Y1+si1X9P+xMY2BuMVbUlU1eoHO0DbxyAOlHOQ0nSsQ6Q5QQ7KdSAFRLSMUZD3X8
mtnerfshhjncoGp73/Vo
=ca3P
-----END PGP SIGNATURE-----

--Uwug7Velx7a8K1K82cN8MUvU6jG3leMRJ--
