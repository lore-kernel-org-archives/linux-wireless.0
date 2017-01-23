Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36004 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750742AbdAWL4d (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Jan 2017 06:56:33 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 23 Jan 2017 13:56:20 +0200
Message-Id: <20170123115622.23587-1-luca@coelho.fi> (sfid-20170123_125636_640279_9B8B2944)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Subject: [PATCH 0/2] iwlwifi: updates intended for v4.10 2017-01-23
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

These are a couple of fixes intended for v4.10.  One avoids a crash in
specific scenarios, the other prevents a firmware load failure due to
wrong file name.

--
Luca.

Johannes Berg (1):
  iwlwifi: mvm: avoid crash on restart w/o reserved queues

Jürg Billeter (1):
  iwlwifi: fix double hyphen in MODULE_FIRMWARE for 8000

 drivers/net/wireless/intel/iwlwifi/iwl-8000.c | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c  | 7 ++++---
 2 files changed, 5 insertions(+), 4 deletions(-)

-- 
2.11.0
