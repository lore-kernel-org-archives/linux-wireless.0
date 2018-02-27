Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53926 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751735AbeB0Qwv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 11:52:51 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,1/8] wil6210: add wil6210_vif structure for per-VIF data
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1519668738-16912-2-git-send-email-merez@codeaurora.org>
References: <1519668738-16912-2-git-send-email-merez@codeaurora.org>
To: Maya Erez <merez@codeaurora.org>
Cc: Lior David <liord@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, Maya Erez <merez@codeaurora.org>
Message-Id: <20180227165250.DADBB607E5@smtp.codeaurora.org> (sfid-20180227_175254_914636_9EFC399F)
Date: Tue, 27 Feb 2018 16:52:50 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maya Erez <merez@codeaurora.org> wrote:

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
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

8 patches applied to ath-next branch of ath.git, thanks.

9f38f2862455 wil6210: add wil6210_vif structure for per-VIF data
7bfe9e22e487 wil6210: support concurrency record in FW file
e00243fab84b wil6210: infrastructure for multiple virtual interfaces
4aebd3bdbd8a wil6210: add support for adding and removing virtual interfaces
3ada9314b4ea wil6210: multiple VIFs support for start/stop AP
404bbb3cca3c wil6210: rename p2p_wdev_mutex to vif_mutex
5bd609825210 wil6210: multiple VIFs support for connections and data path
3a3b745f1eae wil6210: add debugfs 'mids' file

-- 
https://patchwork.kernel.org/patch/10242993/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
