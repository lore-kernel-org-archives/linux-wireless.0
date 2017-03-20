Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55540 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756085AbdCTRw1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Mar 2017 13:52:27 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/5] brcmfmac: move brcmf_txflowblock to bcdc layer
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1489180626-6722-2-git-send-email-arend.vanspriel@broadcom.com>
References: <1489180626-6722-2-git-send-email-arend.vanspriel@broadcom.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Franky Lin <franky.lin@broadcom.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Message-Id: <20170320171518.8F514609F7@smtp.codeaurora.org> (sfid-20170320_185307_286954_EA5C7673)
Date: Mon, 20 Mar 2017 17:15:18 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:
> From: Franky Lin <franky.lin@broadcom.com>
> 
> brcmf_txflowblock is invoked by sdio and usb bus module which are using
> bcdc protocol. This patch makes it a bcdc API instead of a core module
> function.
> 
> Reviewed-by: Arend Van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Franky Lin <franky.lin@broadcom.com>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>

5 patches applied to wireless-drivers-next.git, thanks.

20ec4f57498f brcmfmac: move brcmf_txflowblock to bcdc layer
7b584396b7a7 brcmfmac: move brcmf_txcomplete to bcdc layer
9fdc64bbdbe7 brcmfmac: wrap brcmf_fws_add_interface into bcdc layer
c02a5eb82056 brcmfmac: wrap brcmf_fws_del_interface into bcdc layer
66ded1f8b33c brcmfmac: wrap brcmf_fws_reset_interface into bcdc layer

-- 
https://patchwork.kernel.org/patch/9617985/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
