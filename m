Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp4.pp.htv.fi ([213.243.153.38]:42416 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751628AbYFVM5n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Jun 2008 08:57:43 -0400
Date: Sun, 22 Jun 2008 15:55:53 +0300
From: Adrian Bunk <bunk@stusta.de>
To: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Subject: RFC: always enable MAC80211_RC_PID?
Message-ID: <20080622125553.GB22539@cs181133002.pp.htv.fi> (sfid-20080622_145752_345130_B7134146)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After the scheduled removal of MAC80211_RC_SIMPLE only 
MAC80211_RC_DEFAULT_PID and MAC80211_RC_DEFAULT_NONE are
left as choices.

Does MAC80211_RC_DEFAULT_NONE have any userbase serious enough to 
justify all the constructs made for this case or could we simply
always enable MAC80211_RC_PID?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

