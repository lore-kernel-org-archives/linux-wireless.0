Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42332 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752760AbeAZLDi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Jan 2018 06:03:38 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Felix Fietkau <nbd@nbd.name>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mt76: implement AP_LINK_PS
References: <20180126104742.14315-1-nbd@nbd.name>
Date: Fri, 26 Jan 2018 13:03:33 +0200
In-Reply-To: <20180126104742.14315-1-nbd@nbd.name> (Felix Fietkau's message of
        "Fri, 26 Jan 2018 11:47:42 +0100")
Message-ID: <87o9lgubju.fsf@kamboji.qca.qualcomm.com> (sfid-20180126_120347_283771_81C5AEE4)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@nbd.name> writes:

> With software A-MPDU reordering in place, frames that notify mac80211 of
> powersave changes are reordered as well, which can cause connection
> stalls. Fix this by implementing powersave state processing in the
> driver.
>
> Fixes: aee5b8cf2477 ("mt76: implement A-MPDU rx reordering in the driver code")
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

I'm planning to queue this to 4.16.

-- 
Kalle Valo
