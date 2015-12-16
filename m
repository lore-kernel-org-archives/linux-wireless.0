Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:39580 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754382AbbLPIPO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2015 03:15:14 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: "Kalle Valo <kvalo@adurom.com> Kalle Valo" <kvalo@adurom.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: pull request: iwlwifi 2015-12-16
Date: Wed, 16 Dec 2015 08:15:09 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB32E91F275@hasmsx107.ger.corp.intel.com> (sfid-20151216_091522_471360_B84653A0)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

This is a pull request with small fixes for 4.4.
Note that due to the large number of files being renamed, you need to
set merge.renameLimit to a big number to merge wl-drv into wl-drv-next
but you probably noticed that already :)

The following changes since commit 9513c5e18a0dc55a1fc9c890715098ba2315830b:

  iwlwifi: mvm: Avoid dereferencing sta if it was already flushed
(2015-11-15 21:18:01 +0200)

are available in the git repository at:

 
https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git tags/iwlwifi-for-kalle-2015-12-16

for you to fetch changes up to 4585436091cd812b1165aab71bd4847ea1cb08ec:

  iwlwifi: mvm: protect RCU dereference in iwl_mvm_get_key_sta_id
(2015-12-13 13:38:26 +0200)

----------------------------------------------------------------
* don't load firmware that won't exist for 7260
* fix RCU splat

----------------------------------------------------------------
Johannes Berg (2):
      iwlwifi: separate firmware version for 7260 devices
      iwlwifi: mvm: protect RCU dereference in iwl_mvm_get_key_sta_id

 drivers/net/wireless/iwlwifi/iwl-7000.c | 49
+++++++++++++++++++++++++++++++++++--------------
 drivers/net/wireless/iwlwifi/mvm/sta.c  | 15 +++++++++------
 2 files changed, 44 insertions(+), 20 deletions(-)

