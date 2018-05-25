Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50872 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936026AbeEYKRC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 May 2018 06:17:02 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCHv2,
 1/2] ath: Add support to get the detected radar specifications
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1526375389-7106-2-git-send-email-srirrama@codeaurora.org>
References: <1526375389-7106-2-git-send-email-srirrama@codeaurora.org>
To: Sriram R <srirrama@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Sriram R <srirrama@codeaurora.org>
Message-Id: <20180525101702.140FD6076C@smtp.codeaurora.org> (sfid-20180525_121722_643732_98CD7558)
Date: Fri, 25 May 2018 10:17:02 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sriram R <srirrama@codeaurora.org> wrote:

> This enables ath10k/ath9k drivers to collect the specifications of the
> radar type once it is detected by the dfs pattern detector unit.
> Usage of the collected info is specific to driver implementation.
> For example, collected radar info could be used by the host driver
> to send to co-processors for additional processing/validation.
> 
> Note: 'radar_detector_specs' data containing the specifications of
> different radar types which was private within dfs_pattern_detector/
> dfs_pri_detector is now shared with drivers as well for making use
> of this information.
> 
> Signed-off-by: Sriram R <srirrama@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

2 patches applied to ath-next branch of ath.git, thanks.

f40105e67478 ath: add support to get the detected radar specifications
6f6eb1bcbeff ath10k: DFS Host Confirmation

-- 
https://patchwork.kernel.org/patch/10400505/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
