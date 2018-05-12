Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58434 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750749AbeELJaI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 12 May 2018 05:30:08 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v3,1/8] wil6210: disable tracing config option
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1525860419-6514-2-git-send-email-merez@codeaurora.org>
References: <1525860419-6514-2-git-send-email-merez@codeaurora.org>
To: Maya Erez <merez@codeaurora.org>
Cc: Alexei Avshalom Lazar <ailizaro@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Maya Erez <merez@codeaurora.org>
Message-Id: <20180512093005.BA7E06079C@smtp.codeaurora.org> (sfid-20180512_113011_988044_081E50D8)
Date: Sat, 12 May 2018 09:30:05 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maya Erez <merez@codeaurora.org> wrote:

> Disable WIL6210_TRACING by default to avoid its performance overhead.
> 
> Signed-off-by: Alexei Avshalom Lazar <ailizaro@codeaurora.org>
> Signed-off-by: Maya Erez <merez@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

8 patches applied to ath-next branch of ath.git, thanks.

777b4690fc4a wil6210: disable tracing config option
8a4fa21438e3 wil6210: align to latest auto generated wmi.h
9861bf3b818f wil6210: fix call to wil6210_disconnect during unload
5f85c7e702d2 wil6210: change reply_size arg to u16 in wmi_call
1c21cc5fc4df wil6210: move WMI functionality out of wil_cfg80211_mgmt_tx
807b086053df wil6210: Initialize reply struct of the WMI commands
37f8d26d8347 wil6210: remove unused rx_reorder members
3d6b72729cc2 wil6210: rate limit wil_rx_refill error

-- 
https://patchwork.kernel.org/patch/10388987/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
