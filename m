Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:32095 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750714AbdJ0OAu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Oct 2017 10:00:50 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: wcn36xx: Remove unnecessary rcu_read_unlock in
 wcn36xx_bss_info_changed
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1507467969-24016-1-git-send-email-baijiaju1990@163.com>
References: <1507467969-24016-1-git-send-email-baijiaju1990@163.com>
To: Jia-Ju Bai <baijiaju1990@163.com>
CC: <k.eugene.e@gmail.com>, <kvalo@codeaurora.org>,
        <wcn36xx@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jia-Ju Bai <baijiaju1990@163.com>
Message-ID: <884b0ccc727549b28df7f3705081f67a@euamsexm01a.eu.qualcomm.com> (sfid-20171027_160211_396170_976AE1AD)
Date: Fri, 27 Oct 2017 16:00:41 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jia-Ju Bai <baijiaju1990@163.com> wrote:

> No rcu_read_lock is called, but rcu_read_unlock is still called.
> Thus rcu_read_unlock should be removed.
> 
> Signed-off-by: Jia-Ju Bai <baijiaju1990@163.com>
> Acked-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Patch applied to ath-current branch of ath.git, thanks.

c0d5adc35c0b wcn36xx: Remove unnecessary rcu_read_unlock in wcn36xx_bss_info_changed

-- 
https://patchwork.kernel.org/patch/9991827/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
