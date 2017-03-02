Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47660 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754201AbdCBIvk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Mar 2017 03:51:40 -0500
Message-ID: <1488444698.8390.9.camel@sipsolutions.net> (sfid-20170302_095145_205883_5C68A538)
Subject: Re: [PATCHv2 3/4] cfg80211: Add Support set btcoex priority value
From: Johannes Berg <johannes@sipsolutions.net>
To: c_traja@qti.qualcomm.com, linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org
Date: Thu, 02 Mar 2017 09:51:38 +0100
In-Reply-To: <1488029873-14600-4-git-send-email-c_traja@qti.qualcomm.com>
References: <1488029873-14600-1-git-send-email-c_traja@qti.qualcomm.com>
         <1488029873-14600-4-git-send-email-c_traja@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch will also (and correctly so) cause compilation warnings in
mac80211, so you really should have just two patches.

johannes
