Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:34814 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752983AbdBGJAP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Feb 2017 04:00:15 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: wcn36xx: Implement cancel_hw_scan
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20170201152747.838-1-bjorn.andersson@linaro.org>
References: <20170201152747.838-1-bjorn.andersson@linaro.org>
To: Bjorn Andersson <bjorn.andersson@linaro.org>
CC: Eugene Krasnikov <k.eugene.e@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        <wcn36xx@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, "Mart Raudsepp" <leio@gentoo.org>
Message-ID: <f5840edc6a4f41d7a8183b8a90219235@eusanexr01a.eu.qualcomm.com> (sfid-20170207_100045_458222_A5C0925F)
Date: Tue, 7 Feb 2017 01:00:06 -0800
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bjorn Andersson <bjorn.andersson@linaro.org> wrote:
> In the event that the wcn36xx interface is brought down while a hw_scan
> is active we must abort and wait for the ongoing scan to signal
> completion to mac80211.
> 
> Reported-by: Mart Raudsepp <leio@gentoo.org>
> Fixes: 886039036c20 ("wcn36xx: Implement firmware assisted scan")
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> Tested-by: Mart Raudsepp <leio@gentoo.org>

Patch applied to ath-next branch of ath.git, thanks.

03c95dbef642 wcn36xx: Implement cancel_hw_scan

-- 
https://patchwork.kernel.org/patch/9550795/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
