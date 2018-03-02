Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50780 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1425025AbeCBOYq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Mar 2018 09:24:46 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Cc: Vasanthakumar Thiagarajan <vthiagar@codeaurora.org>,
        "ath10k\@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Add sta rx packet stats per tid
References: <1517400072-9204-1-git-send-email-vthiagar@codeaurora.org>
        <87606hs17h.fsf@kamboji.qca.qualcomm.com>
        <b1fcd67d-e149-acc4-ebbb-23da9a06da02@qti.qualcomm.com>
Date: Fri, 02 Mar 2018 16:24:41 +0200
In-Reply-To: <b1fcd67d-e149-acc4-ebbb-23da9a06da02@qti.qualcomm.com>
        (Vasanthakumar Thiagarajan's message of "Fri, 2 Mar 2018 08:21:25
        +0000")
Message-ID: <87h8pyo8ra.fsf@kamboji.qca.qualcomm.com> (sfid-20180302_152450_781693_8153E236)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com> writes:

>> This added new ath10k-check warnings, I fixed those in the pending
>> branch:
>> 
>> drivers/net/wireless/ath/ath10k/debug.h:203: Alignment should match open parenthesis
>> drivers/net/wireless/ath/ath10k/debug.h:226: Alignment should match open parenthesis
>> drivers/net/wireless/ath/ath10k/debugfs_sta.c:24: Alignment should
>> match open parenthesis
>> drivers/net/wireless/ath/ath10k/debugfs_sta.c:40: Alignment should
>> match open parenthesis
>> drivers/net/wireless/ath/ath10k/debugfs_sta.c:60: Alignment should
>> match open parenthesis
>> 
>> Also I fixed the typo "rages" in debug.h. My changes:
>
> Thanks for fixing it. In most of the cases, fixing above warnings
> would result in lines > 80 chars.
> May be we need not be very strict about > 80 char limit?

In ath10k-check I set the limit to 90 chars, but I guess it could be
even higher than that. But on the other it shouldn't be too long, not
everyone like to have one huge window for editor :)

-- 
Kalle Valo
