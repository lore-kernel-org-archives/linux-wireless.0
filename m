Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38234 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933758AbdDSLkM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Apr 2017 07:40:12 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: brcmfmac: only build fwsignal module for
 CONFIG_BRCMFMAC_PROTO_BCDC
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1492205257-18578-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1492205257-18578-1-git-send-email-arend.vanspriel@broadcom.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Message-Id: <20170419114011.661C161152@smtp.codeaurora.org> (sfid-20170419_134035_742362_6F81EDF5)
Date: Wed, 19 Apr 2017 11:40:11 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:
> The fwsignal module is only referenced by the bcdc module and part of the
> bcdc protocol. So only build it when CONFIG_BRCMFMAC_PROTO_BCDC is selected.
> 
> Fixes: acf8ac41dd73 ("brcmfmac: remove reference to fwsignal data from struct brcmf_pub")
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Patch applied to wireless-drivers-next.git, thanks.

26ecfe017903 brcmfmac: only build fwsignal module for CONFIG_BRCMFMAC_PROTO_BCDC

-- 
https://patchwork.kernel.org/patch/9681805/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
