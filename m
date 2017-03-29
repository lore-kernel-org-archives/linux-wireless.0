Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:48254 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753895AbdC2Kqu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Mar 2017 06:46:50 -0400
Message-ID: <1490784401.13345.6.camel@coelho.fi> (sfid-20170329_124929_586104_5E61E596)
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
Date: Wed, 29 Mar 2017 13:46:41 +0300
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-dJSSyJXvbdY13XlkDvpf"
Mime-Version: 1.0
Subject: pull-request: iwlwifi 2017-03-29
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dJSSyJXvbdY13XlkDvpf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

Here are some fixes for 4.11.  More details in the tag description.

I have sent this out before and kbuildbot didn't find any issues.

Cheers,
Luca.


The following changes since commit 6be3b6cce1e225f189b68b4e84fc711d19b4277b=
:

  ath10k: fix incorrect wlan_mac_base in qca6174_regs (2017-03-20 17:11:31 =
+0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git t=
ags/iwlwifi-for-kalle-2017-03-29

for you to fetch changes up to 4d339989acd730f17bc814b5ddb9c54e405766b6:

  iwlwifi: mvm: support ibss in dqa mode (2017-03-24 17:15:25 +0200)

----------------------------------------------------------------
iwlwifi fixes for 4.11

Here are three patches intended for 4.11.  The first one is an RCU fix
by Sari.  The second one is a fix for a potential out-of-bounds access
crash by Dan.  And finally, the third and bigger one, is a fix for
IBSS, which has been broken since DQA was enabled in the driver.

----------------------------------------------------------------
Dan Carpenter (1):
      iwlwifi: mvm: writing zero bytes to debugfs causes a crash

Liad Kaufman (1):
      iwlwifi: mvm: support ibss in dqa mode

Sara Sharon (1):
      iwlwifi: mvm: fix accessing fw_id_to_mac_id

 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c  | 2 ++
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c | 3 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c      | 9 ++++++---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c       | 7 +++++--
 5 files changed, 16 insertions(+), 7 deletions(-)
--=-dJSSyJXvbdY13XlkDvpf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAljbkJEACgkQoUecoho8
xfoG5w/+MJqZLKaWG4GsBDgCUiO4WIUTk97UvaN14DBzhRTCGmcl+vymBQI9ildq
QIdDcJDic3/iJtAWeZNmO25z2TRPO52NHARl2m5GMVVPdwjd/XcQSgWuCnTedAf3
/dO69QIhTj0ACxDXd5/aExanLKd9lMJKignlOr7X/rZcu1OIYF94/rHg9qku+Iox
P/nBRBqQjihubJNnbhe6Ig4janVf8OtGhNb0pMwUlcCG33HuUfGKhQOjk6yoK9LY
U66SGKtgA6/XTmyVUrP6I7vaVsy4fg3pll570MFXdMY7kR8bGczbx7+XxwvTxj4/
kL47vKGFqf29q/iyJ5eQiFVC3U736t7uNt+UWdg2D0iIdaJkB9zAuR+cWXweH7TW
VpqZ2rHsbzjpwmJpcAfe5ga9GaX7WkujWZSVNYY4ZDj7LePjNR3lnwbE9FXsJflp
YiY2uxfmHd8fkTmtX48naBp8bohNlrFARWQoFvGtRPCfqe2RbNUviJKTNcxmZmmk
wVuXYl38gRxn+57QdTM/eFUi559LHnQ3tMPdIdLXCaAzZWxfInjAMyCa1ype3q+a
/wv/xvwxJc7z50obh4MhVeCwBxrc3xQB9UP/hZRD31yy2kwLLWBP4k3JHrI6sEQY
k1ecudm5hQ/dI7QUhtXKUNLc+ug9zAhcH7HTLKuaC7R/o/19TQg=
=TFSP
-----END PGP SIGNATURE-----

--=-dJSSyJXvbdY13XlkDvpf--
