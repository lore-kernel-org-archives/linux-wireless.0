Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:34430 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750968AbdBLAqP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 11 Feb 2017 19:46:15 -0500
Received: by mail-ot0-f194.google.com with SMTP id 73so7463528otj.1
        for <linux-wireless@vger.kernel.org>; Sat, 11 Feb 2017 16:46:15 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 0/3] rtlwifi: btcoexist: Fix if == else warnings
Date: Sat, 11 Feb 2017 18:46:02 -0600
Message-Id: <20170212004605.1308-1-Larry.Finger@lwfinger.net> (sfid-20170212_014627_744930_CA0EE6D1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The 0-DAY kernel test infrastructure reports several warnings where the
code in an if block is exactly the same as that of the else block.
These instances are simplified.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Julia Lawall <julia.lawall@lip6.fr>

Larry Finger (3):
  rtlwifi: btcoexist: Fix if == else warnings in halbtc8821a2ant.c
  rtlwifi: btcoexist: Fix if == else warnings in halbtc8821a1ant.c
  rtlwifi: btcoexist: Fix if == else warnings in halbtc8723b1ant.c

 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.c    |  24 +--
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.c    |  18 +-
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.c    | 185 +++------------------
 3 files changed, 31 insertions(+), 196 deletions(-)

-- 
2.10.2
