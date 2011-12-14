Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:60111 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753734Ab1LNRWN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Dec 2011 12:22:13 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 3.2] iwlwifi fix for 3.2
Date: Wed, 14 Dec 2011 08:22:34 -0800
Message-Id: <1323879756-3817-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111214_182229_200936_C54B269D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix introduced a bug: bad pointer in unload in
commit 34a5b4b6af104cf18eb50748509528b9bdbc4036.

Also fix a bug introduced by P2P work.

Johannes Berg (1):
  iwlwifi: tx_sync only on PAN context

Wey-Yi Guy (1):
  iwlwifi: allow to switch to HT40 if not associated

this patch will be also available from wireless branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi.git

 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    6 ++++++
 2 files changed, 8 insertions(+), 2 deletions(-)

