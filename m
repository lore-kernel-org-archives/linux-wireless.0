Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34872 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751728AbeAIIEM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Jan 2018 03:04:12 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,1/9] wil6210: support Scheduled scan
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1513270393-919-2-git-send-email-qca_merez@qca.qualcomm.com>
References: <1513270393-919-2-git-send-email-qca_merez@qca.qualcomm.com>
To: Maya Erez <qca_merez@qca.qualcomm.com>
Cc: Dedy Lansky <qca_dlansky@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
        Maya Erez <qca_merez@qca.qualcomm.com>
Message-Id: <20180109080411.CEDF560BDF@smtp.codeaurora.org> (sfid-20180109_090417_391442_3E99AE15)
Date: Tue,  9 Jan 2018 08:04:11 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maya Erez <qca_merez@qca.qualcomm.com> wrote:

> Add support for sched_scan_start/stop by sending PNO commands to FW.
> Driver reports max_sched_scan_reqs and invokes
> cfg80211_sched_scan_results upon receiving WMI_SCHED_SCAN_RESULT_EVENTID
> from FW.
> 
> Signed-off-by: Dedy Lansky <qca_dlansky@qca.qualcomm.com>
> Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

7 patches applied to ath-next branch of ath.git, thanks.

a5dc68839273 wil6210: support Scheduled scan
3dc2c13b5238 wil6210: support 40bit DMA addresses
38e4c25d6069 wil6210: add platform capabilities bitmap
594b59ec70e1 wil6210: set platform features based on FW capabilities
a8fd16d7a14f wil6210: prevent parallel suspend and dump collection
83957bc3aeaf wil6210: remove leftover "FIXME"s
7d3e4dbe570e wil6210: remove reference to preset_chandef

-- 
https://patchwork.kernel.org/patch/10112711/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
