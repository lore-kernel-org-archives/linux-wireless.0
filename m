Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54610 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752335AbeD3Km6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Apr 2018 06:42:58 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [2/6] brcmfmac: reports boottime_ns while informing bss
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1524737915-2217-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1524737915-2217-1-git-send-email-arend.vanspriel@broadcom.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: Dmitry Shmidt <dimitrysh@google.com>,
        linux-wireless@vger.kernel.org,
        Franky Lin <franky.lin@broadcom.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Message-Id: <20180430104257.BAA5360AF9@smtp.codeaurora.org> (sfid-20180430_124306_315574_77185576)
Date: Mon, 30 Apr 2018 10:42:57 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:

> From: Franky Lin <franky.lin@broadcom.com>
> 
> Provides a timestamp in bss information so user space can see when the
> bss info was updated. Since tsf is not available from the dongle events
> boottime is reported instead.
> 
> Reported-by: Dmitry Shmidt <dimitrysh@google.com>
> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Franky Lin <franky.lin@broadcom.com>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Patch applied to wireless-drivers-next.git, thanks.

7742fce4c007 brcmfmac: reports boottime_ns while informing bss

-- 
https://patchwork.kernel.org/patch/10365337/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
