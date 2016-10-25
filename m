Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:47128 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751690AbcJYKEb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Oct 2016 06:04:31 -0400
Message-ID: <1477389867.17122.29.camel@coelho.fi> (sfid-20161025_120435_220764_29836D9A)
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        linuxwifi <linuxwifi@intel.com>
Date: Tue, 25 Oct 2016 13:04:27 +0300
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-EkDLyrJ6TnR4nOLCnK3n"
Mime-Version: 1.0
Subject: pull-request: iwlwifi-next 2016-10-25
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-EkDLyrJ6TnR4nOLCnK3n
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

Here's my first pull-request intended for 4.10. =C2=A0It contains the usual
improvements and bugfixes, with the major thing being that we have
finally enabled dynamic queue allocation.  Some more details in the tag
description.

These patches were sent out for review on 2016-10-19,=C2=A0and pushed to a
pending branch.=C2=A0 Kbuildbot didn't find any issues.

Let me know if everything's fine (or not). :)

Luca.


The following changes since commit 15b95a15950238eff4d7f24be1716086eea67835=
:

  Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/a=
th.git (2016-09-28 16:37:33 +0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git ta=
gs/iwlwifi-next-for-kalle-2016-10-25

for you to fetch changes up to a048dcc71e701cb1771b2e0aca23181a45658023:

  iwlwifi: mvm: use dev_coredumpsg() (2016-10-19 12:46:37 +0300)

----------------------------------------------------------------
* Finalize and enable dynamic queue allocation;
* Use dev_coredumpmsg() to prevent locking the driver;
* Small fix to pass the AID to the FW;
* Use FW PS decisions with multi-queue;

----------------------------------------------------------------
Aviya Erenfeld (1):
      iwlwifi: mvm: use dev_coredumpsg()

Emmanuel Grumbach (1):
      iwlwifi: mvm: tell the firmware about the AID of the peer

Johannes Berg (1):
      iwlwifi: mvm: use firmware station PM notification for AP_LINK_PS

Liad Kaufman (5):
      iwlwifi: mvm: update txq metadata to current owner
      iwlwifi: mvm: fix reserved txq freeing
      iwlwifi: mvm: support MONITOR vif in DQA mode
      iwlwifi: mvm: fix dqa deferred frames marking
      iwlwifi: mvm: operate in dqa mode

Sara Sharon (1):
      iwlwifi: mvm: assign cab queue to the correct station

Sharon Dvir (1):
      iwlwifi: pcie: give a meaningful name to interrupt request

 drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h    |   2 ++
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h  |  26 ++++++++++++++++=
++++
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-sta.h |   9 ++++---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h     |   1 +
 drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c     | 100 ++++++++++++++++=
+++++++++++++++++++++++++----------------------------------
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c   |  24 +++++++++-------=
--
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c   |  86 ++++++++++++++++=
+++++++++++++++++++++++++++++++++++++++++++++---
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h        |   6 ++---
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c        |   3 +++
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c        |  37 ++++++++++++++++=
++++++------
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h        |   1 +
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c     |  29 ++++++++++++++++=
+++++-
 12 files changed, 249 insertions(+), 75 deletions(-)
--=-EkDLyrJ6TnR4nOLCnK3n
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJYDy4rAAoJEKFHnKIaPMX62RAP/Ang3mmibc9Ca41m3eCDHCG2
ia29cf6l3TYuwAymmZCIlmBT/CRpml2/c8h9N6uPG9DlnBvLQGB/c1YeLF5NlsWV
cp0TGvXIy2RsNIPptEBcg+G84RASZkmk2kEwI7XF1AJ0GmRTkUTNgJM8hW74a4h9
AtwdQLX1g82b4wG7Pxc5isO30pGXmSlB/zAKIiVGqQtZMRrui5huuShXhZmV6CVb
73akFJj6ZT42kPAHUv3P5tDCfXcuhDrqYTUK4ukVtMZTPN9PYnTyymwNTpKkjWPZ
U0lFxGA5hnGHwkT5WzWK3ASdjOQaIg1MAOtW1KHJJ5KPtculv+YsHRnXCGc8AckF
SVxa9n1LZGoFem+e7lJa1foFQkG5K8SUXyUWCwfqT94vR8sN9grCKkVbVPCfcWw7
XpHGFsJXdsIBuw7ydnOWgJOLLjYBgvoOFVVbnFGQIPDGheNL//NajSF6QMR+pOP5
eshjvVxHEBfYe3GKA5iip8vR5qGBuB8ugLXPySL0wxknCCGT15mZaR5JU7vcQh+i
uRDT1cYIbgnYJRL+UnBsOJ4bQ59sBuyG/iwyXjZJoULwcmS/s8qSTSyTtwOxbxU/
64/jgxlxi3WKOYNXAUAgj5EI95QsGMlFMcv/VZGmIOvx7QuBc3EjTRtMkrDdJiVV
VWOPO8Hw6BwO3ecUSYQt
=ocIY
-----END PGP SIGNATURE-----

--=-EkDLyrJ6TnR4nOLCnK3n--
