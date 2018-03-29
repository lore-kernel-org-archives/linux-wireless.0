Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34046 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750946AbeC2JBA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Mar 2018 05:01:00 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v7,2/5] ath10k: Enable TDLS peer buffer STA feature
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1508835074-3384-3-git-send-email-yintang@qti.qualcomm.com>
References: <1508835074-3384-3-git-send-email-yintang@qti.qualcomm.com>
To: yintang@qti.qualcomm.com
Cc: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Message-Id: <20180329090059.994F660C54@smtp.codeaurora.org> (sfid-20180329_110103_837663_012394FA)
Date: Thu, 29 Mar 2018 09:00:59 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

yintang@qti.qualcomm.com wrote:

> Enable TDLS peer buffer STA feature.
> QCA6174 firmware(version: WLAN.RM.4.4) support TDLS peer buffer STA,
> it reports this capability through wmi service map in wmi service ready
> event. Set related parameter in TDLS WMI command to enable this feature.
> 
> Signed-off-by: Yingying Tang <yintang@qti.qualcomm.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

4 patches applied to ath-next branch of ath.git, thanks.

802ca335496e ath10k: enable TDLS peer buffer STA feature
4c9f8d114660 ath10k: enable TDLS peer inactivity detection
c3816c9ee12c ath10k: avoid to set WEP key for TDLS peer
9cdd00575029 ath10k: fix TDLS peer TX data failure issue on encryped AP

-- 
https://patchwork.kernel.org/patch/10023753/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
