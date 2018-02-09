Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34314 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751139AbeBIJlf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Feb 2018 04:41:35 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: ryanhsu@codeaurora.org
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k: update the IRAM banks number for QCA9377
References: <1518135631-29796-1-git-send-email-ryanhsu@codeaurora.org>
Date: Fri, 09 Feb 2018 11:41:30 +0200
In-Reply-To: <1518135631-29796-1-git-send-email-ryanhsu@codeaurora.org>
        (ryanhsu@codeaurora.org's message of "Thu, 8 Feb 2018 16:20:31 -0800")
Message-ID: <874lmqcxf9.fsf@kamboji.qca.qualcomm.com> (sfid-20180209_104230_591503_8D031901)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ryanhsu@codeaurora.org writes:

> From: Ryan Hsu <ryanhsu@codeaurora.org>
>
> QCA9377 firmware update the IRAM banks from 4 to 9.
>
> Signed-off-by: Ryan Hsu <ryanhsu@codeaurora.org>

As we discussed offline, I'll update the commit log to this:

ath10k: update the IRAM bank number for QCA9377

Prepared for new QCA9377 firmware support. With the new
firmware update, it required more IRAM banks, hence updated it.

The IRAM banks promotion won't break any backward compatibility,
as those IRAM banks were not getting used in previous firmware.

-- 
Kalle Valo
