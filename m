Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:61839 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517AbbHWKFS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Aug 2015 06:05:18 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: pull request: iwlwifi-next 2015-08-23
Date: Sun, 23 Aug 2015 10:05:13 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB32E827CB7@hasmsx107.ger.corp.intel.com> (sfid-20150823_120536_189112_5B8974AD)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

one very last pull request for 4.3 before the merge windows opens. I
hope it will make it.
Let me know if you have issues with it.

Thanks!

The following changes since commit ecc7c518b3017821a6b26fb5fdaa548afa8ee236:

  iwlwifi: mvm: fix a race in D0i3 vs. Tx path (2015-08-18 10:25:26 +0300)

are available in the git repository at:

 
https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git
tags/iwlwifi-next-for-kalle-2015-08-23

for you to fetch changes up to 5865f3658ba37c54e346b0fdee08a1c7a152681b:

  iwlwifi: mvm: bump firmware API to 17 (2015-08-23 12:54:16 +0300)

----------------------------------------------------------------
* new Tx power firmware API
* bump max firmware API to 17
* fix bug in debug prints
* static checker fix
* fix unused defines
* fix command list on newest firmware

----------------------------------------------------------------
Ayala Beker (1):
      iwlwifi: mvm: split debug message to avoid exceeding 110 characters

Dan Carpenter (1):
      iwlwifi: mvm: catch underflow error earlier

Emmanuel Grumbach (1):
      iwlwifi: mvm: bump firmware API to 17

Johannes Berg (2):
      iwlwifi: correctly size command string arrays
      iwlwifi: mvm: support new TX power command

Sara Sharon (1):
      iwlwifi: mvm: update wakeup reason enum

 drivers/net/wireless/iwlwifi/dvm/agn.h          |  2 +-
 drivers/net/wireless/iwlwifi/dvm/rx.c           |  2 +-
 drivers/net/wireless/iwlwifi/iwl-7000.c         |  2 +-
 drivers/net/wireless/iwlwifi/iwl-8000.c         |  2 +-
 drivers/net/wireless/iwlwifi/iwl-fw-file.h      |  3 +++
 drivers/net/wireless/iwlwifi/mvm/debugfs.c      |  5 +++--
 drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h    |  7 ++++++-
 drivers/net/wireless/iwlwifi/mvm/fw-api-power.h | 29
+++++++++++++++++++++++++----
 drivers/net/wireless/iwlwifi/mvm/mac80211.c     | 15 +++++++++------
 drivers/net/wireless/iwlwifi/mvm/ops.c          |  2 +-
 drivers/net/wireless/iwlwifi/mvm/scan.c         | 20 ++++++++++++--------
 11 files changed, 63 insertions(+), 26 deletions(-)

