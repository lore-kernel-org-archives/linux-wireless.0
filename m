Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44226 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965539AbeEYJtZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 May 2018 05:49:25 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: Add support to configure channel dwell time
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1526088159-29912-1-git-send-email-pradeepc@codeaurora.org>
References: <1526088159-29912-1-git-send-email-pradeepc@codeaurora.org>
To: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
Message-Id: <20180525094924.C32A660C66@smtp.codeaurora.org> (sfid-20180525_114948_403686_82F39301)
Date: Fri, 25 May 2018 09:49:24 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pradeep Kumar Chitrapu <pradeepc@codeaurora.org> wrote:

> Configure channel dwell time from duration of the scan request
> received from mac80211 when the duration is non-zero. When the
> scan request does not have duration value, use the default ones,
> the current implementation.
> 
> Corresponding flag NL80211_EXT_FEATURE_SET_SCAN_DWELL is
> advertized.
> 
> Supported Chipsets:
>  -QCA988X/QCA9887 PCI
>  -QCA99X0/QCA9984/QCA9888/QCA4019 PCI
>  -QCA6174/QCA9377 PCI/USB/SDIO
>  -WCN3990 SNOC
> 
> Tested on QCA9984 with firmware ver 10.4-3.6-0010
> 
> Signed-off-by: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

be8cce96f14d ath10k: add support to configure channel dwell time

-- 
https://patchwork.kernel.org/patch/10395687/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
