Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:36848 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750774AbcKIFuK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Nov 2016 00:50:10 -0500
Received: by mail-pf0-f196.google.com with SMTP id n85so22248428pfi.3
        for <linux-wireless@vger.kernel.org>; Tue, 08 Nov 2016 21:49:39 -0800 (PST)
From: Kirtika Ruchandani <kirtika.ruchandani@gmail.com>
Date: Tue, 8 Nov 2016 21:49:30 -0800
To: Luca Coelho <luciano.coelho@intel.com>
Cc: linux-wireless@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sara Sharon <sara.sharon@intel.com>,
        Eran Harary <eran.harary@intel.com>,
        Liad Kaufman <liad.kaufman@intel.com>,
        Eyal Shapira <eyal@wizery.com>,
        Alexander Bondar <alexander.bondar@intel.com>
Subject: [PATCH v2 0/3] Fix -Wunused-but-set-variable in iwlwifi/pcie/trans
 and iwlwifi/mvm/rs
Message-ID: <20161109054930.GA26716@google.com> (sfid-20161109_065019_531541_6BFE92A1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset is part of the effort led by Arnd Bergmann to clean up
warnings in the kernel. This and following patchsets will focus on 
"-Wunused-but-set-variable" as it among the noisier ones. These were
found compiling with W=1.

-- 
Changes in v2:
- Made the following changes suggested by Arnd in all 3 patches
  1. Each patch has a unique subject line.
  2. Add the commit that introduced/led to the warning with the "Fixes:" line.
  3. cc linux-wireles, cc commit authors.

Kirtika Ruchandani (3):
  iwlwifi: mvm: rs: Remove unused 'mvmvif'/'mvmsta' variables
  iwlwifi: mvm: rs: Remove unused 'mcs' variable
  iwlwifi: pcie: trans: Remove unused 'shift_param'

 drivers/net/wireless/intel/iwlwifi/mvm/rs.c     | 10 +---------
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c |  3 ---
 2 files changed, 1 insertion(+), 12 deletions(-)

-- 
2.8.0.rc3.226.g39d4020
