Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:26549 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750747AbcIMM0j (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Sep 2016 08:26:39 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: enable peer stats by default
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1473188728-14995-1-git-send-email-twp@qca.qualcomm.com>
To: "Pedersen, Thomas" <twp@qca.qualcomm.com>
CC: ath10k <ath10k@lists.infradead.org>,
        Thomas Pedersen <twp@qca.qualcomm.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Message-ID: <4a5367aa45274f368f50b790b06ab618@euamsexm01a.eu.qualcomm.com> (sfid-20160913_142642_055241_0EDD0377)
Date: Tue, 13 Sep 2016 14:26:28 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Pedersen, Thomas" <twp@qca.qualcomm.com> wrote:
> IFTYPE_MESH_POINT need to rely on these for accurate path
> selection metrics. Other modes will probably also find
> them useful. Enabling peer stats has the side effect of
> reducing max number of STAs from 128 to 118. There should
> be negligible performance impact.
> 
> If users really need 128 STAs and don't mind losing out on
> peer stats, they can still disable them:
> 
> echo 0 > debugfs/ieee80211/phyn/ath10k/peer_stats
> 
> Signed-off-by: Thomas Pedersen <twp@qca.qualcomm.com>

Thanks, 1 patch applied to ath-next branch of ath.git:

8c1d7fa53166 ath10k: enable peer stats by default

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9317865/
