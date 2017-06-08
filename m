Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f49.google.com ([209.85.213.49]:32879 "EHLO
        mail-vk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751035AbdFHEu0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Jun 2017 00:50:26 -0400
Received: by mail-vk0-f49.google.com with SMTP id p62so12822165vkp.0
        for <linux-wireless@vger.kernel.org>; Wed, 07 Jun 2017 21:50:25 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>
From: Xuebing Wang <xbing6@gmail.com>
Subject: [linux-wireless] [mac80211] Does IEEE80211_IBSS_MAX_STA_ENTRIES (in
 net/mac80211/ibss.c) work?
Message-ID: <0d40c0dc-4476-0567-6cb9-149a3fcc83e4@gmail.com> (sfid-20170608_065030_455925_0924E9C8)
Date: Thu, 8 Jun 2017 12:50:20 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi community,

Does IEEE80211_IBSS_MAX_STA_ENTRIES (in net/mac80211/ibss.c) work?

I hard-code it to be 2 (from original 128), and update kernel for one 
node, and start IBSS network with 5 nodes. In the node with hard-coded 
IBSS_MAX_STA_ENTRIES = 2, I still can see and ping all other 4 nodes. I 
am using kernel v3.18.29, does IBSS_MAX_STA_ENTRIES work with latest 
kernel source code?

My purpose is to limit the max number of peers (for all nodes in IBSS 
network) to be 12 or 20.

I apologize if I should dive deeper instead of posting this question. I 
will check here too, just to see if I can get any quick answers. :-)

Thanks a lot.

Xuebing Wang
