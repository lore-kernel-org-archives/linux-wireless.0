Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:30455 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751653AbdAMNgD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 08:36:03 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: Fix Tx legacy rate reporting
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1484063603-13652-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1484063603-13652-1-git-send-email-mohammed@qca.qualcomm.com>
To: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <mohammed@codeaurora.org>,
        <linux-wireless@vger.kernel.org>,
        Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Message-ID: <cbac3fa290ef42358b6717b801afbb2d@euamsexm01a.eu.qualcomm.com> (sfid-20170113_143606_398525_06C9BF0B)
Date: Fri, 13 Jan 2017 14:35:51 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com> wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> 
> Tx legacy rate is reported 10 fold, as below
> 
> iw dev wlan#N station dump | grep "tx bitrate"
>         tx bitrate:     240.0 MBit/s
> 
> This is because by mistake we muliply by the hardware reported
> rate twice by 10, fix this.
> 
> Fixes: cec17c382140 ("ath10k: add per peer htt tx stats support for 10.4")
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

cd59102779ac ath10k: fix tx legacy rate reporting

-- 
https://patchwork.kernel.org/patch/9508075/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
