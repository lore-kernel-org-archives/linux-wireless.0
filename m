Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42190 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932538AbeEHPYY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 May 2018 11:24:24 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,
 06/10] wil6210: use country specific board file upon reg domain change
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1524473533-24524-7-git-send-email-merez@codeaurora.org>
References: <1524473533-24524-7-git-send-email-merez@codeaurora.org>
To: Maya Erez <merez@codeaurora.org>
Cc: Dedy Lansky <dlansky@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Maya Erez <merez@codeaurora.org>
Message-Id: <20180508152424.6C03A605FD@smtp.codeaurora.org> (sfid-20180508_172450_072048_324DEBDE)
Date: Tue,  8 May 2018 15:24:24 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maya Erez <merez@codeaurora.org> wrote:

> From: Dedy Lansky <dlansky@codeaurora.org>
> 
> wil6210 device needs to use country specific board file while in China
> regulatory domain.
> Register cfg80211 reg_notifier and switch board file if needed
> according to new regulatory domain.
> This feature is disabled by default and can be enabled with a new
> country_specific_board_file module parameter.
> 
> Signed-off-by: Dedy Lansky <dlansky@codeaurora.org>
> Signed-off-by: Maya Erez <merez@codeaurora.org>

This looks fishy, especially the addition of a new module parameter.
I'll drop this as I don't have time to investigate in detail.

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/10356435/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
