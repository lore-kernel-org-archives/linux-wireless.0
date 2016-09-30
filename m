Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41290 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752307AbcI3XfU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Sep 2016 19:35:20 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
        stable@vger.kernel.org, Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 0/2] rtl8xxxu: Fix driver reload issues with 8723bu and 8192eu
Date: Fri, 30 Sep 2016 19:35:16 -0400
Message-Id: <1475278518-18527-1-git-send-email-Jes.Sorensen@redhat.com> (sfid-20161001_013529_397344_001F500E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Hi,

These two patches fix issues where rtl8723bu and rtl8192eu dongles
would stop receving data if one reloaded the driver module, requiring
it to be physically removed and reinserted.

Both issues are applicable to 4.9. The first patch for 8723bu is
applicable to stable 4.7 and 4.8. The second patch will only be
applicable to stable 4.8, once patches currently in flight are merged
by the network maintainers.

Cheers,
Jes


Jes Sorensen (2):
  rtl8xxxu: Fix rtl8723bu driver reload issue
  rtl8xxxu: Fix rtl8192eu driver reload issue

 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c | 8 +++++++-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c | 4 ++++
 2 files changed, 11 insertions(+), 1 deletion(-)

-- 
2.7.4
