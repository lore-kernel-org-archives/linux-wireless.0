Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:21700 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351Ab1HMQmd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 12:42:33 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 0/2] iwlwifi fix for 3.1
Date: Sat, 13 Aug 2011 09:02:42 -0700
Message-Id: <1313251364-6633-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110813_184243_883630_F0C9B609)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix introduced a bug: bad pointer in unload in
commit cc1a93e68f6c0d736b771f0746e8e4186f483fdc.

ALso fix bug has been introduced by:
d593411084a56124aa9d80aafa15db8463b2d8f7

Emmanuel Grumbach (2):
  iwlagn: Revert "iwlagn: sysfs couldn't find the priv pointer"
  iwlagn: sysfs couldn't find the priv pointer

these patches are also available from wireless-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/iwl-pci.c |   39 +++++++++++++++++++++++---------------------------
 1 files changed, 26 insertions(+), 31 deletions(-)


