Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-eopbgr40103.outbound.protection.outlook.com ([40.107.4.103]:10112
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S967778AbeCALaG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 06:30:06 -0500
Subject: [PATCH net-next 0/2] Converting pernet_operations (part #3)
 (wireless, mac80211_hwsim)
From: Kirill Tkhai <ktkhai@virtuozzo.com>
To: davem@davemloft.net, johannes@sipsolutions.net,
        kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, ktkhai@virtuozzo.com
Date: Thu, 01 Mar 2018 14:30:00 +0300
Message-ID: <151990341305.5011.3514278630677194656.stgit@localhost.localdomain> (sfid-20180301_123015_268638_D7F8D085)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These series fixes ID overflow of hwsim_netgroup [1/2],
and reviews and makes hwsim_net_ops as async [2/2].

The first pernet_operations requiring changes to make
the converting safe!

([1/2] may be need to [net], but better people see it's really need).

Thanks,
Kirill

---

Kirill Tkhai (2):
      mac80211_hwsim: Make hwsim_netgroup IDA
      net: Convert hwsim_net_ops


 drivers/net/wireless/mac80211_hwsim.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--
Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
