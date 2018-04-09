Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40496 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751633AbeDIP7Y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Apr 2018 11:59:24 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] brcmfmac: fix firmware request processing if nvram load fails
References: <1522743495-13004-1-git-send-email-arend.vanspriel@broadcom.com>
Date: Mon, 09 Apr 2018 18:59:20 +0300
In-Reply-To: <1522743495-13004-1-git-send-email-arend.vanspriel@broadcom.com>
        (Arend van Spriel's message of "Tue, 3 Apr 2018 10:18:15 +0200")
Message-ID: <87y3hwjrqf.fsf@purkki.adurom.net> (sfid-20180409_175928_160720_29CA8CAB)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

> When nvram loading fails a double free occurred. Fix this and reorg the
> code a little.
>
> Fixes: commit d09ae51a4b67 ("brcmfmac: pass struct in brcmf_fw_get_firmwares()")
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Applied to wireless-drivers, thanks.

0b5c0305e57c brcmfmac: fix firmware request processing if nvram load fails

(My script failed so sending this mail manually)

-- 
Kalle Valo
