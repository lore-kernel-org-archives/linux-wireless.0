Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47942 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966158AbeEYLqT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 May 2018 07:46:19 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Guy Chronister <guylovesbritt@gmail.com>
Cc: linux-wireless@vger.kernel.org, guychronister@outlook.com
Subject: Re: [PATCH] Added support for Dell Wireless 1537 which is an Qualcomm Atheros AR6004X with an sdio ID of 0x19. hardware ID is 0271:0419. And tested it on a Dell Venue 11 Pro 7130 with a compiled kernel.
References: <20180521212644.7838-1-guylovesbritt@gmail.com>
Date: Fri, 25 May 2018 14:46:16 +0300
In-Reply-To: <20180521212644.7838-1-guylovesbritt@gmail.com> (Guy Chronister's
        message of "Mon, 21 May 2018 16:26:44 -0500")
Message-ID: <87vabcklfb.fsf@purkki.adurom.net> (sfid-20180525_134633_906356_F1521344)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Guy Chronister <guylovesbritt@gmail.com> writes:

> Signed-off-by: Guy Chronister <guylovesbritt@gmail.com>

The commit log formatting was wrong, I fixed like this in the pending
branch (also added the word "self"):

    ath6kl: add support for Dell Wireless 1537
    
    This is a Qualcomm Atheros AR6004X with an sdio ID of 0x19 and hardware ID of
    0271:0419. Tested on a Dell Venue 11 Pro 7130 with a self compiled kernel

-- 
Kalle Valo
