Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:24905 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932371AbcIBQAq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Sep 2016 12:00:46 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v5] ath10k: Fix broken NULL func data frame status for 10.4
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1472199140-8404-1-git-send-email-mohammed@qca.qualcomm.com>
To: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <mohammed@codeaurora.org>,
        Tamizh chelvam <c_traja@qti.qualcomm.com>,
        <linux-wireless@vger.kernel.org>,
        "Mohammed Shafi Shajakhan" <mohammed@qti.qualcomm.com>
Message-ID: <48c9092d7f6c468092ef093779624a36@euamsexm01a.eu.qualcomm.com> (sfid-20160902_180049_744344_DB85250E)
Date: Fri, 2 Sep 2016 18:00:33 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com> wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> 
> Older firmware with HTT delivers incorrect tx status for null func
> frames to driver, but this fixed in 10.2 and 10.4 firmware versions.
> Also this workaround results in reporting of incorrect null func status
> for 10.4. Fix this is by introducing a firmware feature flag for 10.4
> so that this workaround is skipped and proper tx status for null func
> frames are reported
> 
> Signed-off-by: Tamizh chelvam <c_traja@qti.qualcomm.com>
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Thanks, 1 patch applied to ath-next branch of ath.git:

2cdce425aa33 ath10k: Fix broken NULL func data frame status for 10.4

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9300961/
