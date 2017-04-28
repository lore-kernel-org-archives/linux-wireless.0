Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49282 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755398AbdD1Igd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Apr 2017 04:36:33 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <johannes@sipsolutions.net>)
        id 1d41OA-0006ky-NC
        for linux-wireless@vger.kernel.org; Fri, 28 Apr 2017 10:36:30 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 0/4] mac80211 RX rate reporting refactoring
Date: Fri, 28 Apr 2017 10:36:22 +0200
Message-Id: <20170428083626.3463-1-johannes@sipsolutions.net> (sfid-20170428_103749_320468_4380DEB6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The mac80211 RX rate reporting has grown over the years - from just
CCK/OFDM rates, adding a flag for HT (that still made sense), then
adding a flag for VHT (that didn't - HT/VHT are mutually exclusive),
and now I'm looking at adding HE support ...

This really needed some cleanups, so here they are.

johannes
