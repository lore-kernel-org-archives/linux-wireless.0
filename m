Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:21226 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752311AbcL2OLg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Dec 2016 09:11:36 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/2] ath10k: add accounting for the extended peer statistics
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <992a4e2676037a06f482cdbe2d3d39e287530be5.1480974623.git.chunkeey@googlemail.com>
References: <992a4e2676037a06f482cdbe2d3d39e287530be5.1480974623.git.chunkeey@googlemail.com>
To: Christian Lamparter <chunkeey@googlemail.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Message-ID: <c3f99e7634384475b475b97ff46bec76@euamsexm01a.eu.qualcomm.com> (sfid-20161229_151140_122604_6DACDDEA)
Date: Thu, 29 Dec 2016 15:11:21 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter <chunkeey@googlemail.com> wrote:
> The 10.4 firmware adds extended peer information to the
> firmware's statistics payload. This additional info is
> stored as a separate data field and the elements are
> stored in their own "peers_extd" list.
> 
> These elements can pile up in the same way as the peer
> information elements. This is because the
> ath10k_wmi_10_4_op_pull_fw_stats() function tries to
> pull the same amount (num_peer_stats) for every statistic
> data unit.
> 
> Fixes: 4a49ae94a448faa ("ath10k: fix 10.4 extended peer stats update")
> Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>

My understanding is that I should skip this patch 1. Please let me know if
I misunderstood. But I'm still plannning to apply patch 2.

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/9461631/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
