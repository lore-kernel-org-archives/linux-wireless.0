Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:40943 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752726AbbFCHYS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2015 03:24:18 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: "kvalo@codeaurora.org" <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: pull request: iwlwifi-next 2015-06-03
Date: Wed, 3 Jun 2015 07:24:12 +0000
Message-ID: <1433316253.25661.3.camel@intel.com> (sfid-20150603_092422_258876_2A95DEBC)
References: <1432667798.26624.3.camel@intel.com>
	 <1432811748.26741.3.camel@intel.com>
	 <87zj4htglg.fsf@kamboji.qca.qualcomm.com>
	 <0BA3FCBA62E2DC44AF3030971E174FB31B762261@hasmsx107.ger.corp.intel.com>
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB31B762261@hasmsx107.ger.corp.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="=-ZEidSTHQ5mLku2dXTz2e"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--=-ZEidSTHQ5mLku2dXTz2e
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

As promised, here is the enlarged pull request for 4.2. I double checked
that the tag is signed this time.
I also signed this email, just in case...

I'll reply to this pull request with the diff between the previous one
and this one. All the other patches have been sent to the ML already.
The good thing with this new pull request is that it allows us to jump
to -15.ucode which is starting validation right now. I hope its first
version will be available in 3 weeks-ish.=09

Let me know if you have issues with this.

Thank you.

The following changes since commit bbbe8c8c596b3784a2ed08772900e827f8ba72c5=
:

  mac80211: add missing documentation for rate_ctrl_lock (2015-05-06 16:00:=
32 +0200)

are available in the git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git =
tags/iwlwifi-for-kalle-2015-06-03

for you to fetch changes up to 5f4c02e2b8c9251c827abf87c4ead4496c67492a:

  iwlwifi: mvm: advertise only HW-supported ciphers (2015-06-03 10:12:26 +0=
300)

----------------------------------------------------------------
* a few fixes (re-enablement of interrupts for certain new
  platforms that have special power states)
* Rework completely the RBD allocation model towards new
  multi RX hardware.
* cleanups
* scan reworks continuation (Luca)

----------------------------------------------------------------
Andrei Otcheretianski (1):
      iwlwifi: mvm: Configure agg. queue before assigning it to STA

Arik Nemtsov (1):
      iwlwifi: mvm: clean interfaces on drv_stop

Avraham Stern (3):
      iwlwifi: mvm: print scanned channel list on scan iteration complete n=
otification
      iwlwifi: mvm: add UMAC scan iteration complete notification
      iwlwifi: mvm: add support for 8 level scan priority API

Avri Altman (3):
      iwlwifi: pcie: don't disable the busmaster DMA clock for family 8000
      iwlwifi: pcie: Remove redundant check for family type
      iwlwifi: pcie: Control access to the NIC's PM registers via iwl_cfg

David Spinadel (2):
      iwlwifi: mvm: add inactive state to ebs status
      iwlwifi: mvm: don't use EBS for P2P find

Eliad Peller (4):
      iwlwifi: mvm: avoid use-after-free on iwl_mvm_d0i3_enable_tx()
      iwlwifi: mvm: fix ROC reference accounting
      iwlwifi: tracing: add rx cmd header fields
      iwlwifi: pcie: re-enable interrupts on resume

Emmanuel Grumbach (13):
      iwlwifi: mvm: forbid MIMO on devices that don't support it
      iwlwifi: 7000: modify the firmware name for 3165
      iwlwifi: mvm: fix MLME trigger
      iwlwifi: mvm: BT Coex - duplicate the command if sent ASYNC
      Merge remote-tracking branch 'iwlwifi-fixes/master' into iwlwifi-next
      iwlwifi: bump API to 14
      iwlwifi: pcie: simplify return value
      iwlwifi: mvm: BT Coex - remove useless code
      iwlwifi: mvm: BT Coex - allocate a short command on the stack
      iwlwifi: mvm: BT Coex - fix shared antenna check with new API
      Merge tag 'mac80211-next-for-davem-2015-05-06' into iwlwifi-next
      iwlwifi: mvm: implement the BlockAck related debug triggers
      iwlwifi: bump the iwlmvm API number to 15

Eran Harary (1):
      iwlwifi: 8000: fallback to default NVM file

Eyal Shapira (1):
      iwlwifi: mvm: rs: pass rate directly to column checks

Haim Dreyfuss (1):
      iwlwifi: mvm: Free fw_status after use to avoid memory leak

Ido Yariv (1):
      iwlwifi: update thermal throttling values for 8000 devices

Johannes Berg (8):
      iwlwifi: refactor common transport alloc/init code
      iwlwifi: mvm: advertise randomised netdetect MAC address
      iwlwifi: mvm: handle device start failure correctly
      iwlwifi: mvm: enable IEEE80211_HW_SUPPORT_FAST_XMIT
      iwlwifi: dvm: enable IEEE80211_HW_SUPPORT_FAST_XMIT
      iwlwifi: mvm: simplify iwl_mvm_stop_roc()
      iwlwifi: prepare for higher API/CAPA bits
      iwlwifi: mvm: advertise only HW-supported ciphers

Liad Kaufman (2):
      iwlwifi: nvm: force mac from otp in case nvm mac is reserved
      iwlwifi: wrt: add mipi type to debug types

Luciano Coelho (18):
      iwlwifi: mvm: take the UCODE_DOWN reference when resuming
      iwlwifi: mvm: clean net-detect info if device was reset during suspen=
d
      iwlwifi: pcie: don't call set_pwr functions for family 8000
      iwlwifi: mvm: small fix in a comment about UMAC scan schedules
      iwlwifi: mvm: remove the UMAC specific scan types
      iwlwifi: mvm: fix the net-detect SSIDs report order
      iwlwifi: mvm: make iwl_mvm_config_sched_scan_profiles() static
      iwlwifi: mvm: reorganize scan stopping functions
      iwlwifi: mvm: don't stop regular scans when going out of idle state
      iwlwifi: mvm: combine part of the scan stop flows
      iwlwifi: mvm: rename umac scan stop function
      iwlwifi: mvm: rename some LMAC-specific scan functions
      iwlwifi: mvm: refactor UMAC scan UID handling
      iwlwifi: mvm: remove code that stops multiple UMAC scans of a type
      iwlwifi: mvm: combine UMAC and LMAC scan_stop functions
      iwlwifi: mvm: combine regular and sched scan stop functions
      iwlwifi: mvm: make UMAC scans use the stopping scan status
      iwlwifi: mvm: treat scan races also on UMAC scans

Matti Gottlieb (3):
      iwlwifi: mvm: Add debugfs entry for Tx power limit
      iwlwifi: mvm: Remove old scan commands
      iwlwifi: mvm: Add DC2DC_CONFIG_CMD (0x83) cmd & TLV

Nicholas Krause (1):
      iwlwifi: Remove use of the deprecacted PTR_RET

Sara Sharon (1):
      iwlwifi: pcie: New RBD allocation model

 drivers/net/wireless/iwlwifi/Kconfig                |   13 +-
 drivers/net/wireless/iwlwifi/Makefile               |    1 +
 drivers/net/wireless/iwlwifi/dvm/mac80211.c         |    1 +
 drivers/net/wireless/iwlwifi/iwl-7000.c             |   41 ++++-
 drivers/net/wireless/iwlwifi/iwl-8000.c             |   71 +++++---
 drivers/net/wireless/iwlwifi/iwl-config.h           |   45 +++++
 drivers/net/wireless/iwlwifi/iwl-devtrace-iwlwifi.h |   15 +-
 drivers/net/wireless/iwlwifi/iwl-drv.c              |   32 +++-
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c     |    5 +
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.h     |    3 +
 drivers/net/wireless/iwlwifi/iwl-fh.h               |    6 -
 drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h    |    6 +-
 drivers/net/wireless/iwlwifi/iwl-fw-file.h          |  107 +++++++----
 drivers/net/wireless/iwlwifi/iwl-fw.h               |   24 ++-
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c        |   30 +++-
 drivers/net/wireless/iwlwifi/iwl-prph.h             |    3 +
 drivers/net/wireless/iwlwifi/iwl-trans.c            |  113 ++++++++++++
 drivers/net/wireless/iwlwifi/iwl-trans.h            |   63 ++++---
 drivers/net/wireless/iwlwifi/mvm/coex.c             |  103 +++--------
 drivers/net/wireless/iwlwifi/mvm/coex_legacy.c      |    2 +-
 drivers/net/wireless/iwlwifi/mvm/d3.c               |   46 +++--
 drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c      |   21 ++-
 drivers/net/wireless/iwlwifi/mvm/debugfs.c          |   14 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-power.h     |   34 ++++
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h      |  135 ++++++--------
 drivers/net/wireless/iwlwifi/mvm/fw-api.h           |   76 +++++---
 drivers/net/wireless/iwlwifi/mvm/fw.c               |   71 +++-----
 drivers/net/wireless/iwlwifi/mvm/mac80211.c         |  440 +++++++++++++++=
++++++++++++------------------
 drivers/net/wireless/iwlwifi/mvm/mvm.h              |  163 +++++++--------=
--
 drivers/net/wireless/iwlwifi/mvm/nvm.c              |   16 +-
 drivers/net/wireless/iwlwifi/mvm/ops.c              |   53 +++---
 drivers/net/wireless/iwlwifi/mvm/rs.c               |   47 ++---
 drivers/net/wireless/iwlwifi/mvm/rs.h               |    2 -
 drivers/net/wireless/iwlwifi/mvm/rx.c               |    9 +-
 drivers/net/wireless/iwlwifi/mvm/scan.c             | 1420 +++++++++++++++=
++++++++++++++++++++++++++++++++++++++++++++++++++++-----------------------=
------------------------------------------------------
 drivers/net/wireless/iwlwifi/mvm/sta.c              |   14 +-
 drivers/net/wireless/iwlwifi/mvm/time-event.c       |   33 ++--
 drivers/net/wireless/iwlwifi/mvm/tt.c               |   40 +----
 drivers/net/wireless/iwlwifi/mvm/tx.c               |   35 +++-
 drivers/net/wireless/iwlwifi/mvm/utils.c            |    2 +-
 drivers/net/wireless/iwlwifi/pcie/drv.c             |   17 +-
 drivers/net/wireless/iwlwifi/pcie/internal.h        |   51 +++++-
 drivers/net/wireless/iwlwifi/pcie/rx.c              |  415 +++++++++++++++=
++++++++++++++++++---------
 drivers/net/wireless/iwlwifi/pcie/trans.c           |  158 +++++++++------=
-
 drivers/net/wireless/iwlwifi/pcie/tx.c              |    2 -
 45 files changed, 2287 insertions(+), 1711 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-trans.c


--=-ZEidSTHQ5mLku2dXTz2e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAABAgAGBQJVbqudAAoJEC0Llv5uNjIBNaoP/2n59gOeBEksBJ9rz7buMl22
SbJYEZlqxLPNHSdNEMjJJfJav6PTGn8oUbZcUcjK55ghC+gi7hmn9gXbi1rZSkXV
BPNAlYH1CmB6giN5lcXa9EcK9+eqhuqpWgDJNHzunE5V3y/k0kz6omnEDX4R1s85
MXmrnr+Y9QlirB/6l7Wmh09l7JT4Tdj758AZ2KI7phhko0xt3jBOPRFpjAB1vSjo
r4WXAZ3eFeHr0jtjZ0qbg3Z2Xj19BSw1MAw12YTWmwYWviAjBMrQj3f5OspfYGci
G4bFmmTlRqY94hYaJN6nn9K2WwwIL9ga1z3nyN4QaT01lL/pGTRuSnSscEvShrBD
SID4gPHQf6+igSMNfxZc0uVp1tJUqRZCoNo8tzZJ1FOHLXIkqAqtmlKoJEO5eNNn
lGd7DfAcjFyQmg56T+Muv4BPvLDKuSFEkl9vFVVL5snZacsYqNDH7RyQdeQka541
ybKDL9oxJOVutmvbmpuW06gYwkwy3CbRcCJv9WmH0s/TC8yEd2d2gB3XDVL4qSVg
fYiYMuH5jLjz66xgx7Ft1B8QDnJt+RYCQx/p6HbWCqjpP8mC5nRGdCj/xGzTVGaF
JVt21TREuAcX4iPm0wGlHrg+f3Txv/HZgbMVMoBnnSI8VFoeSbE0IJ0h/3i3k0Pt
cn/KrzZPeEFs0O2GiZQp
=Pims
-----END PGP SIGNATURE-----

--=-ZEidSTHQ5mLku2dXTz2e--
