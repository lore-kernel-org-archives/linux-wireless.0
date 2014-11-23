Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:33716 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbaKWT41 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Nov 2014 14:56:27 -0500
Received: by mail-wi0-f173.google.com with SMTP id r20so3789259wiv.12
        for <linux-wireless@vger.kernel.org>; Sun, 23 Nov 2014 11:56:25 -0800 (PST)
Message-ID: <54723BE7.6040607@gmail.com> (sfid-20141123_205721_731055_46F5A9F7)
Date: Sun, 23 Nov 2014 21:56:23 +0200
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: pull request: iwlwifi 2014-11-23
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

I have a trivial patch for 3.18. details below.
Thanks!

The following changes since commit 87dd634ae72bb8f6d0dd12f1cbbc67c7da6dba3b:

  iwlwifi: pcie: fix prph dump length (2014-11-11 07:24:57 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git tags/iwlwifi-for-john-2014-11-23

for you to fetch changes up to 5ac6c72e594471acfa5b00210c51d533a73413ad:

  iwlwifi: mvm: check TLV flag before trying to use hotspot firmware commands (2014-11-23 21:50:57 +0200)

----------------------------------------------------------------
Not all the firmware know how to handle the HOT_SPOT_CMD.
Make sure that the firmware will know this command before
sending it. This avoids a firmware crash.

----------------------------------------------------------------
Luciano Coelho (1):
      iwlwifi: mvm: check TLV flag before trying to use hotspot firmware commands

 drivers/net/wireless/iwlwifi/iwl-fw.h       |  2 ++
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 12 +++++++++---
 2 files changed, 11 insertions(+), 3 deletions(-)
