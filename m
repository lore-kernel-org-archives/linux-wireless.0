Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:55784 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751568AbdAMN21 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 08:28:27 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/2] ath10k: add accounting for the extended peer statistics
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <992a4e2676037a06f482cdbe2d3d39e287530be5.1480974623.git.chunkeey@googlemail.com>
References: <992a4e2676037a06f482cdbe2d3d39e287530be5.1480974623.git.chunkeey@googlemail.com>
To: Christian Lamparter <chunkeey@googlemail.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Message-ID: <270c5e95df7849f48fe0adf6ff448aed@euamsexm01a.eu.qualcomm.com> (sfid-20170113_142831_003970_20C46178)
Date: Fri, 13 Jan 2017 14:28:21 +0100
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

Patch applied to ath-next branch of ath.git, thanks.

c1e3330f22bc ath10k: add accounting for the extended peer statistics

-- 
https://patchwork.kernel.org/patch/9461631/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
