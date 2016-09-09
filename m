Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53780 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752151AbcIISB1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Sep 2016 14:01:27 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 0/2] Fix spelling and reset device on module unload
Date: Fri,  9 Sep 2016 14:01:23 -0400
Message-Id: <1473444085-6363-1-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160909_200132_051047_6ED2313E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Hi,

Two fixes for the rtl8xxxu driver.

I am working on a much larger set which adds 8188eu support, and while
it's close to there, I am still chasing one issue where it doesn't
come back if reloading the driver module.

In the interim, these two should be good to apply.

Cheers,
Jes


Colin Ian King (1):
  rtl8xxxu: fix spelling mistake "firmare" -> "firmware"

Jes Sorensen (1):
  rtl8xxxu: Reset device on module unload if still attached

 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

-- 
2.7.4
