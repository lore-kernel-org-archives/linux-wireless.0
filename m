Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:32164 "EHLO
        sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751114AbdFUNT0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Jun 2017 09:19:26 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v3,1/3] wil6210: prevent platform callbacks after uninit
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1497508008-9536-2-git-send-email-qca_merez@qca.qualcomm.com>
References: <1497508008-9536-2-git-send-email-qca_merez@qca.qualcomm.com>
To: Maya Erez <qca_merez@qca.qualcomm.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
        Dedy Lansky <qca_dlansky@qualcomm.com>,
        <linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>,
        Maya Erez <qca_merez@qca.qualcomm.com>
Message-ID: <c8e53ed1f61f4b7c9ce262da7b95a5bc@euamsexm01a.eu.qualcomm.com> (sfid-20170621_151929_660236_CBE89CBC)
Date: Wed, 21 Jun 2017 15:19:18 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maya Erez <qca_merez@qca.qualcomm.com> wrote:

> After calling platform_ops.uninit() it is still possible to invoke
> platform callbacks.
> To prevent this, zero platform_ops right after invoking uninit.
> 
> Signed-off-by: Dedy Lansky <qca_dlansky@qca.qualcomm.com>
> Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

3 patches applied to ath-next branch of ath.git, thanks.

5b49ee9f13c7 wil6210: prevent platform callbacks after uninit
fe9ee51e6a43 wil6210: add support for PCIe D3hot in system suspend
a520b49ec155 wil6210: remove ioctl interface

-- 
https://patchwork.kernel.org/patch/9788123/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
