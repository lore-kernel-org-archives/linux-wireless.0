Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43214 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932119AbeAIIJs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Jan 2018 03:09:48 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,7/9] wil6210: configurable broadcast TX MCS
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1513270393-919-8-git-send-email-qca_merez@qca.qualcomm.com>
References: <1513270393-919-8-git-send-email-qca_merez@qca.qualcomm.com>
To: Maya Erez <qca_merez@qca.qualcomm.com>
Cc: Lior David <qca_liord@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
        Maya Erez <qca_merez@qca.qualcomm.com>
Message-Id: <20180109080947.E3DC260208@smtp.codeaurora.org> (sfid-20180109_090953_486851_C4E10A92)
Date: Tue,  9 Jan 2018 08:09:47 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maya Erez <qca_merez@qca.qualcomm.com> wrote:

> Add 2 module parameters that control broadcast/multicast
> TX packets:
> 1. bcast_mcs0_limit - specify the maximum packet size
> that will be sent with MCS 0.
> 2. bcast_mcs - specify the MCS index to use when sending
> packets larger than above limit.
> 
> Signed-off-by: Lior David <qca_liord@qca.qualcomm.com>
> Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

IMHO this kind of higher level protocol configuration belongs to nl80211.
Module parameters are more meant for lower level (hardware etc) configuration.

-- 
https://patchwork.kernel.org/patch/10112705/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
