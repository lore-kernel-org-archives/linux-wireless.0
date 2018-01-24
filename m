Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56586 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934241AbeAXQCK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Jan 2018 11:02:10 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [01/11] qtnfmac: remove struct qlink_cmd_set_mac_acl
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180122124634.8430-2-sergey.matyukevich.os@quantenna.com>
References: <20180122124634.8430-2-sergey.matyukevich.os@quantenna.com>
To: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Vasily Ulyanov <vulyanov@quantenna.com>
Message-Id: <20180124160210.433FF60A06@smtp.codeaurora.org> (sfid-20180124_170237_195627_1FBEC221)
Date: Wed, 24 Jan 2018 16:02:10 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> wrote:

> From: Vasily Ulyanov <vulyanov@quantenna.com>
> 
> TLV is used to pass ACL data to firmware in start_ap cfg80211 callback.
> Use the same approach in set_mac_acl cfg80211 callback.
> 
> Signed-off-by: Vasily Ulyanov <vulyanov@quantenna.com>

11 patches applied to wireless-drivers-next.git, thanks.

33f9899234a2 qtnfmac: remove struct qlink_cmd_set_mac_acl
87affddef94e qtnfmac: fix warnings when mBSS setup is stopped
04b01affb824 qtnfmac: support 64-bit network interface stats
5ec5b532dabc qtnfmac: get more hardware info from card
0b419d0182bc qtnfmac: report hardware/firmware information via ethtool
537faf269d76 qtnfmac: modify supported interface combinations
01efff526235 qtnfmac: validate interface combinations on changes
39845020b39e qtnfmac: fix STA disconnect procedure
f2cddd5469b0 qtnfmac: do not use mutexes in timer context
237d29f6ce46 qtnfmac: do not use bus mutex for events processing
c93fe71c91d0 qtnfmac: remove redundant 'unlikely' checks

-- 
https://patchwork.kernel.org/patch/10178447/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
