Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48530 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751598AbdIUOyK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Sep 2017 10:54:10 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Allen Pais <allen.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, arend.vanspriel@broadcom.com,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/1] wireless: broadcom: brcm80211: use setup_timer() helper
References: <1505997786-12815-1-git-send-email-allen.lkml@gmail.com>
Date: Thu, 21 Sep 2017 17:54:05 +0300
In-Reply-To: <1505997786-12815-1-git-send-email-allen.lkml@gmail.com> (Allen
        Pais's message of "Thu, 21 Sep 2017 18:13:06 +0530")
Message-ID: <87wp4s85ma.fsf@kamboji.qca.qualcomm.com> (sfid-20170921_165425_224086_A3087542)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allen Pais <allen.lkml@gmail.com> writes:

>     Use setup_timer function instead of initializing timer with the
>     function and data fields.
>
> Signed-off-by: Allen Pais <allen.lkml@gmail.com>

The commit log is weirdly indented and no need to have "wireless:
broadcom:" in the title. I can fix both of those.

-- 
Kalle Valo
