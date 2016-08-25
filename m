Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44034 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759764AbcHYP3b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Aug 2016 11:29:31 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 0/3] mwifiex: FW downloading debug printing improvements
Date: Thu, 25 Aug 2016 17:05:15 +0200
Message-Id: <1472137518-10431-1-git-send-email-sgruszka@redhat.com> (sfid-20160825_172938_514715_87604BD3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

3 small patches that make FW downloading prints more informative

Stanislaw Gruszka (3):
  mwifiex: make "PCI-E is not the winner" print more informative
  mwifiex: print status of FW ready event
  mwifiex: do not print dot when downloading FW

 drivers/net/wireless/marvell/mwifiex/pcie.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

-- 
1.8.3.1
