Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46001 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752011AbcJCHaw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Oct 2016 03:30:52 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Jes.Sorensen@redhat.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/2] rtl8xxxu: Fix rtl8192eu driver reload issue
References: <1475278518-18527-1-git-send-email-Jes.Sorensen@redhat.com>
        <1475278518-18527-3-git-send-email-Jes.Sorensen@redhat.com>
Date: Mon, 03 Oct 2016 10:30:47 +0300
In-Reply-To: <1475278518-18527-3-git-send-email-Jes.Sorensen@redhat.com> (Jes
        Sorensen's message of "Fri, 30 Sep 2016 19:35:18 -0400")
Message-ID: <87k2dpsxco.fsf@kamboji.qca.qualcomm.com> (sfid-20161003_093101_535610_56CE6A16)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jes.Sorensen@redhat.com writes:

> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>
> The 8192eu suffered from two issues when reloading the driver.
>
> The same problems as with the 8723bu where REG_RX_WAIT_CCA bits 22 and
> 23 didn't get set in rtl8192e_enable_rf().
>
> In addition it also seems prone to issues when setting REG_RF_CTRL to
> 0 intead of just disabling the RF_ENABLE bit. Similar to what was
> causing issues with the 8188eu.
>
> With this patch I can successfully reload the driver and reassociate
> to an APi with an 8192eu dongle.
>
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>

I'll add:

Cc: stable@vger.kernel.org # 4.8+

-- 
Kalle Valo
