Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45734 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754922AbdHYI1j (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Aug 2017 04:27:39 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 25 Aug 2017 11:27:28 +0300
Message-Id: <20170825082730.31388-1-luca@coelho.fi> (sfid-20170825_102746_944621_393E2736)
Subject: [PATCH 0/2] iwlwifi: updates intended for v4.14 2017-08-25
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

A very tiny set of patches for v4.14. :) Nothing is backlogged in our
internal tree anymore and this has been a very slow week due to
vacations in our team.

These are the changes:

* Fix a queue hang problem due to 11w behavior
* Fix a warning caused by a too long debug print

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.


David Spinadel (1):
  iwlwifi: mvm: Avoid deffering non bufferable frames

Liad Kaufman (1):
  iwlwifi: fix long debug print

 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c | 9 +++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  | 9 +++++----
 2 files changed, 12 insertions(+), 6 deletions(-)

-- 
2.14.1
