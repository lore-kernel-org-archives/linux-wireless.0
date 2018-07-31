Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60272 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729409AbeGaJD1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jul 2018 05:03:27 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH] wlcore: Set rx_status boottime_ns field on rx
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1532709023-1237-1-git-send-email-loic.poulain@linaro.org>
References: <1532709023-1237-1-git-send-email-loic.poulain@linaro.org>
To: Loic Poulain <loic.poulain@linaro.org>
Cc: linux-wireless@vger.kernel.org,
        Loic Poulain <loic.poulain@linaro.org>
Message-Id: <20180731072431.B7F3460AFF@smtp.codeaurora.org> (sfid-20180731_092448_779265_F67D114C)
Date: Tue, 31 Jul 2018 07:24:31 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Loic Poulain <loic.poulain@linaro.org> wrote:

> When receiving a beacon or probe response, we should update the
> boottime_ns field which is the timestamp the frame was received at.
> (cf mac80211.h)
> 
> This fixes a scanning issue with Android since it relies on this
> timestamp to determine when the AP has been seen for the last time
> (via the nl80211 BSS_LAST_SEEN_BOOTTIME parameter).
> 
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>

Patch applied to wireless-drivers-next.git, thanks.

37a634f60fd6 wlcore: Set rx_status boottime_ns field on rx

-- 
https://patchwork.kernel.org/patch/10547433/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
