Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33784 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755809AbeDXFq1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Apr 2018 01:46:27 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/2] ath10k: Add WMI_SERVICE_AVAILABLE_EVENT support
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1522379640-6442-2-git-send-email-cjhuang@codeaurora.org>
References: <1522379640-6442-2-git-send-email-cjhuang@codeaurora.org>
To: Carl Huang <cjhuang@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Message-Id: <20180424054626.3CC0360881@smtp.codeaurora.org> (sfid-20180424_074637_511793_A4D8DB48)
Date: Tue, 24 Apr 2018 05:46:26 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Carl Huang <cjhuang@codeaurora.org> wrote:

> Add WMI_SERVICE_AVAILABLE_EVENT to extend WMI_SERVICE_READY_EVENT,
> the 128bit service map in WMI_SERVICE_READY_EVENT is not enough
> for firmware to notice new WLAN service to host driver. Hereby,
> for thoese new WLAN service, firmware will notice host driver by
> WMI_SERVICE_AVAILABLE_EVENT.
> 
> Signed-off-by: Alan Liu <alanliu@codeaurora.org>
> Signed-off-by: Carl Huang <cjhuang@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

2 patches applied to ath-next branch of ath.git, thanks.

cea19a6ce8bf ath10k: add WMI_SERVICE_AVAILABLE_EVENT support
60e1d0fb2901 ath10k: support MAC address randomization in scan

-- 
https://patchwork.kernel.org/patch/10316767/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
