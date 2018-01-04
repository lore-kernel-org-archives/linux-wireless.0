Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43990 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752344AbeADQs5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Jan 2018 11:48:57 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] wcn36xx: Fix dynamic power saving
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1512982342-10343-1-git-send-email-loic.poulain@linaro.org>
References: <1512982342-10343-1-git-send-email-loic.poulain@linaro.org>
To: Loic Poulain <loic.poulain@linaro.org>
Cc: linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, k.eugene.e@gmail.com,
        bjorn.andersson@linaro.org, Loic Poulain <loic.poulain@linaro.org>
Message-Id: <20180104164857.3862B602B9@smtp.codeaurora.org> (sfid-20180104_174901_670761_0CC50527)
Date: Thu,  4 Jan 2018 16:48:57 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Loic Poulain <loic.poulain@linaro.org> wrote:

> Since driver does not report hardware dynamic power saving cap,
> this is up to the mac80211 to manage power saving timeout and
> state machine, using the ieee80211 config callback to report
> PS changes. This patch enables/disables PS mode according to
> the new configuration.
> 
> Remove old behaviour enabling PS mode in a static way, this make
> the device unusable when power save is enabled since device is
> forced to PS regardless RX/TX traffic.
> 
> Acked-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-current branch of ath.git, thanks.

0856655a2547 wcn36xx: Fix dynamic power saving

-- 
https://patchwork.kernel.org/patch/10104441/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
