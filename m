Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60864 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752253AbdFMGNN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Jun 2017 02:13:13 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [for-4.12] brcmfmac: fix brcmf_fws_add_interface() for USB devices
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1497268595-4836-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1497268595-4836-1-git-send-email-arend.vanspriel@broadcom.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Message-Id: <20170613061312.8B39C607C4@smtp.codeaurora.org> (sfid-20170613_081358_785412_9690D629)
Date: Tue, 13 Jun 2017 06:13:12 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:

> USB devices rely on queuing functionality provided by the fwsignal
> module regardless the mode fwsignal is operating in. For this some
> data structure needs to be reserved which is tied to the interface,
> which is done by brcmf_fws_add_interface(). However, it checks the
> mode. Replace that by checking result from brcmf_fws_queue_skbs().
> 
> Fixes: fc0471e3e884 ("brcmfmac: ignore interfaces when fwsignal is disabled")
> Reviewed-by: Franky Lin <franky.lin@broadcom.com>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Same here, a short description of the bug would be nice.

-- 
https://patchwork.kernel.org/patch/9780809/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
