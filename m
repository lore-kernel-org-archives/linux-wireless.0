Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42520 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932105AbcI3Lrh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Sep 2016 07:47:37 -0400
Message-ID: <1475236046.17481.46.camel@sipsolutions.net> (sfid-20160930_134741_693225_B7001157)
Subject: Re: [PATCH 0/4] ath10k: fix mesh sync operation
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <twp@qca.qualcomm.com>,
        ath10k <ath10k@lists.infradead.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 30 Sep 2016 13:47:26 +0200
In-Reply-To: <20160928235631.9197-1-twp@qca.qualcomm.com> (sfid-20160929_015935_293622_5DEFFE7A)
References: <20160928235631.9197-1-twp@qca.qualcomm.com>
         (sfid-20160929_015935_293622_5DEFFE7A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-09-28 at 16:56 -0700, Thomas Pedersen wrote:
> This patchset introduces a new ieee80211_op offset_tsf(), which gives
> the driver a s64 TSF offset for TSF adjustment. This is more accurate
> than programming absolute TSF since programming delay is avoided.
> 

You were lucky we have patchwork, otherwise I would've missed the
mac80211 patches in this series :)

Applied both now - no reason to apply them in the order you sent them.

johannes
