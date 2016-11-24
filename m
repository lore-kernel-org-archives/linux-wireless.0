Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:34822 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754726AbcKXEp3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Nov 2016 23:45:29 -0500
From: Kirtika Ruchandani <kirtika.ruchandani@gmail.com>
Date: Wed, 23 Nov 2016 20:45:23 -0800
To: Johannes Berg <johannes.berg@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Marek Kwaczynski <marek.kwaczynski@tieto.com>,
        David Spinadel <david.spinadel@intel.com>,
        Alexander Bondar <alexander.bondar@intel.com>,
        Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/4] Fix -Wunused-but-set-variable in net/mac80211/
Message-ID: <cover.1479962513.git.kirtika@chromium.org> (sfid-20161124_054535_974361_648CC55D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset is part of the effort led by Arnd Bergmann to clean up
warnings in the kernel. This and following patchsets will focus on
"-Wunused-but-set-variable" as it among the noisier ones. These were
found compiling with W=1.

Kirtika Ruchandani (4):
  mac80211: Removed unused 'i' variable
  mac80211: Remove unused 'len' variable
  mac80211: Removed unused 'struct ieee80211_supported_band*' variable
  mac80211: Remove unused 'beaconint_us' variable

 net/mac80211/chan.c | 4 +---
 net/mac80211/mlme.c | 4 ----
 net/mac80211/scan.c | 8 +++-----
 net/mac80211/vht.c  | 4 ----
 4 files changed, 4 insertions(+), 16 deletions(-)

-- 
2.8.0.rc3.226.g39d4020
