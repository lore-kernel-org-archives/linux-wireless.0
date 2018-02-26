Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58842 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751550AbeBZQYs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Feb 2018 11:24:48 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/8] wil6210: add wil6210_vif structure for per-VIF data
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1518768283-2318-2-git-send-email-merez@codeaurora.org>
References: <1518768283-2318-2-git-send-email-merez@codeaurora.org>
To: Maya Erez <merez@codeaurora.org>
Cc: Lior David <liord@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, Maya Erez <merez@codeaurora.org>
Message-Id: <20180226162447.6193E60F72@smtp.codeaurora.org> (sfid-20180226_172454_606403_1EEACF2E)
Date: Mon, 26 Feb 2018 16:24:45 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maya Erez <merez@codeaurora.org> wrote:

> From: Lior David <liord@codeaurora.org>
> 
> For supporting multiple virtual interfaces in the future,
> introduce a wil6210_vif structure which will hold per-VIF
> data. Change the module initialization so wil6210_vif will
> be part of net_device structure, and wireless_dev will be
> embedded inside the wil6210_vif structure. This will allow
> us to find the appropriate wil6210_vif structure when we
> only have access to wireless_dev or net_device.
> 
> Signed-off-by: Lior David <liord@codeaurora.org>
> Signed-off-by: Maya Erez <merez@codeaurora.org>

Failed to apply:

error: patch failed: drivers/net/wireless/ath/wil6210/cfg80211.c:1606
error: drivers/net/wireless/ath/wil6210/cfg80211.c: patch does not apply
stg import: Diff does not apply cleanly

8 patches set to Changes Requested.

10224163 [1/8] wil6210: add wil6210_vif structure for per-VIF data
10224157 [2/8] wil6210: support concurrency record in FW file
10224159 [3/8] wil6210: infrastructure for multiple virtual interfaces
10224161 [4/8] wil6210: add support for adding and removing virtual interfaces
10224155 [5/8] wil6210: multiple VIFs support for start/stop AP
10224151 [6/8] wil6210: rename p2p_wdev_mutex to vif_mutex
10224153 [7/8] wil6210: multiple VIFs support for connections and data path
10224149 [8/8] wil6210: add debugfs 'mids' file

-- 
https://patchwork.kernel.org/patch/10224163/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
