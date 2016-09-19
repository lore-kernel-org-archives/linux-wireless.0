Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:55796 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S934453AbcISH2D (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 03:28:03 -0400
Message-ID: <1474270071.5664.89.camel@coelho.fi> (sfid-20160919_092836_820445_F59F6C2C)
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        linuxwifi <linuxwifi@intel.com>
Date: Mon, 19 Sep 2016 10:27:51 +0300
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-RiaTcnV7asYESZY8LFO2"
Mime-Version: 1.0
Subject: pull-request: iwlwifi-next 2016-09-19
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-RiaTcnV7asYESZY8LFO2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

Here we go again, now I'm almost catching up with the pending stuff in
our internal tree, just in time for 4.9. =C2=A0This pull contains a bunch o=
f
fixes to DQA and new HW support code, a few new features and some
cleanups. =C2=A0More details in the tag description.

Let me know if everything's fine (or not). :)

Luca.


The following changes since commit 80ba4f1d365af206b9e818d17d22fed02fe5def0=
:

=C2=A0 mwifiex: fix null pointer deference when adapter is null (2016-09-17=
 18:26:32 +0300)

are available in the git repository at:

=C2=A0 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.g=
it tags/iwlwifi-next-for-kalle-2016-09-19

for you to fetch changes up to e9dd5c83fd1c8d36d9b8180a1ca7576f823442fd:

=C2=A0 iwlwifi: pcie: use LIST_HEAD() macro (2016-09-19 10:10:19 +0300)

----------------------------------------------------------------
* added support for MU-MIMO sniffer
* added support for RRM by scan
* added support for packet injection
* migrate to devm memory allocation handling
* some fixes, mostly in DQA and new HW support
* other generic cleanups

----------------------------------------------------------------
Arik Nemtsov (1):
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: move BIOS MCC retrieval to com=
mon code

Aviya Erenfeld (1):
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: mvm: add support for MU-MIMO a=
ir sniffer

Avrahams Stern (1):
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: mvm: Add support for RRM by sc=
an

Emmanuel Grumbach (1):
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: don't export trace points that=
 are used in iwlwifi only

Haim Dreyfuss (1):
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: check for valid ethernet addre=
ss provided by OEM

Ido Yariv (1):
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: mvm: Add mem debugfs entry

Johannes Berg (6):
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: mvm: compare full command ID
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: mvm: make iwl_mvm_update_sta()=
 an inline
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: mvm: document passing unexpect=
ed Block Ack Request frames
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: mvm: move AP-specific code to =
right function
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: mvm: use LIST_HEAD() macro
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: pcie: use LIST_HEAD() macro

Liad Kaufman (1):
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: mvm: remove variable shadowing

Oren Givon (1):
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: add new 8265 series PCI ID

Roee Zamir (1):
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: mvm: Add debugfs function for =
clocks diff

Sara Sharon (9):
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: pcie: fix typo in struct name =
for a000 devices
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: mvm: cleanup skb queue functio=
ns use
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: mvm: fix DQA AP mode station a=
ssumption
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: mvm: support BAR in reorder bu=
ffer
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: mvm: support packet injection
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: pcie: log full command sequenc=
e
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: move to wide ID for all comman=
ds
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: mvm: disable P2P queue on mac =
context release
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: mvm: set HCMD_NAME for PHY_DB =
as well

Sharon Dvir (1):
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: migrate to devm_* API

=C2=A0drivers/net/wireless/intel/iwlwifi/iwl-devtrace.c=C2=A0=C2=A0=C2=A0=
=C2=A0|=C2=A0=C2=A0=C2=A03 --
=C2=A0drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0|=C2=A0=C2=A0=C2=A05 ++
=C2=A0drivers/net/wireless/intel/iwlwifi/iwl-notif-wait.c=C2=A0=C2=A0|=C2=
=A0=C2=A0=C2=A08 +++-
=C2=A0drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c=C2=A0=C2=A0=C2=A0|=
 104 ++++++++++++++++++++++++++++++++++++++++--
=C2=A0drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h=C2=A0=C2=A0=C2=A0|=
=C2=A0=C2=A020 +++++++-
=C2=A0drivers/net/wireless/intel/iwlwifi/iwl-phy-db.c=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A02 +-
=C2=A0drivers/net/wireless/intel/iwlwifi/iwl-trans.c=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A011 ++---
=C2=A0drivers/net/wireless/intel/iwlwifi/iwl-trans.h=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A05 +-
=C2=A0drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c |=C2=A0=C2=A026 =
+++++++++++
=C2=A0drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0| 184 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
++++++++++++++
=C2=A0drivers/net/wireless/intel/iwlwifi/mvm/fw-api-scan.h |=C2=A0=C2=A020 =
++++----
=C2=A0drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0|=C2=A0=C2=A052 ++++++++++++++++++++-
=C2=A0drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c=C2=A0=C2=A0=C2=A0=
=C2=A0|=C2=A0=C2=A047 ++++++++++---------
=C2=A0drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c=C2=A0=C2=A0=C2=A0=
=C2=A0|=C2=A0=C2=A018 ++++++++
=C2=A0drivers/net/wireless/intel/iwlwifi/mvm/mvm.h=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A06 +++
=C2=A0drivers/net/wireless/intel/iwlwifi/mvm/nvm.c=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A093 +----------------------------=
--------
=C2=A0drivers/net/wireless/intel/iwlwifi/mvm/ops.c=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A032 +++++++------
=C2=A0drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A030 ++++++++----
=C2=A0drivers/net/wireless/intel/iwlwifi/mvm/scan.c=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A061 ++++++++++++++++++++++---
=C2=A0drivers/net/wireless/intel/iwlwifi/mvm/sta.c=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A013 ++----
=C2=A0drivers/net/wireless/intel/iwlwifi/mvm/sta.h=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A011 +++--
=C2=A0drivers/net/wireless/intel/iwlwifi/mvm/tx.c=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A035 +++++++++++---
=C2=A0drivers/net/wireless/intel/iwlwifi/pcie/drv.c=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A01 +
=C2=A0drivers/net/wireless/intel/iwlwifi/pcie/internal.h=C2=A0=C2=A0=C2=A0|=
=C2=A0=C2=A0=C2=A02 -
=C2=A0drivers/net/wireless/intel/iwlwifi/pcie/rx.c=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A09 ++--
=C2=A0drivers/net/wireless/intel/iwlwifi/pcie/trans.c=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0|=C2=A0=C2=A084 ++++++++++++++--------------------
=C2=A0drivers/net/wireless/intel/iwlwifi/pcie/tx.c=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A02 +-
=C2=A027 files changed, 632 insertions(+), 252 deletions(-)
--=-RiaTcnV7asYESZY8LFO2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJX35N3AAoJEKFHnKIaPMX6HVQP/06OULNubM+OATq5juJC3tCo
3gzbiOELS3/9BVg0jgTbHyI0XYoEPD05MUEbk1h3SPHm9uhKoZ3NSSuxwHGY5guh
+Gq50UBUD444Zsq5DQSHs3vFPLSGkmpS6fNzArIBmgWQAF7sTxtDGJZ0/wNSDCsr
OBJiBGuqspdvZrqouqpL0ZlbaEX1JUmYg65GPlra+0DvqWZ/hsjQOE5jHGvxZH9D
EX+LruXzk8nw7ZjXmh6CVQHrrZXJCrl7Vqr17Ry6fdIJEqDf7HKUh7VDC3skd7FK
c7FHnti/t3XPyA8B+nRkR1BRkID0KJXD0q+jpdVXJAjLiRkz36jFHqZlmxFivNrP
Csz4fouZk8762et0J49HqxkHieyW8sxjXlaSjkiUG/mGcW4k/8+772qbOKqTjgM6
p1t5Gr/i+bNSKsazf2i7hsR7rVma5HRiG+f3jLEYX3dCUATrQ/LFg4MC6pQHyRfK
O/0hpQyxBymMqa2oazN2gJfjepCXDYCLGbNiP/4auGMNhzW6cPwLY0an8TaUo1S1
NtHi9QPtGLVhEyrUH2UNdpaf46E/DM38lQB4fdI5URuI7gvjF341dLwPmU4seKrz
B6rHKyNvmDXEp3BO0s7SCBcWhgWzh/md+b6V6pj1PJRIdVhsNp3bOe0/uFtlbqu0
jfM2PhnwfdgwpwZTKI3e
=LKmh
-----END PGP SIGNATURE-----

--=-RiaTcnV7asYESZY8LFO2--
