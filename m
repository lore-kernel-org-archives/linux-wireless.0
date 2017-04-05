Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41884 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753238AbdDEMnf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Apr 2017 08:43:35 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/5] brcmfmac: wrap brcmf_fws_init into bcdc layer
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1490697808-5538-2-git-send-email-arend.vanspriel@broadcom.com>
References: <1490697808-5538-2-git-send-email-arend.vanspriel@broadcom.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Franky Lin <franky.lin@broadcom.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Message-Id: <20170405124333.651DC60DCF@smtp.codeaurora.org> (sfid-20170405_144739_399189_CE18C475)
Date: Wed,  5 Apr 2017 12:43:33 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:
> From: Franky Lin <franky.lin@broadcom.com>
> 
> Create a new protocol layer interface brcmf_proto_init_cb for protocol
> layer to finish initialzation after core module components(fweh and
> etc.) are initialized.
> 
> Signed-off-by: Franky Lin <franky.lin@broadcom.com>
> Reviewed-by: Arend Van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>

5 patches applied to wireless-drivers-next.git, thanks.

62c50a34883c brcmfmac: wrap brcmf_fws_init into bcdc layer
8f9dd1a97438 brcmfmac: move brcmf_fws_deinit to bcdc layer
0cc0236cf713 brcmfmac: add support to move wiphy instance into network namespace
49fe9b59f0e9 brcmfmac: restore bus state when enter_D3 fails
78b9ccb81377 brcmfmac: no need for d11inf instance in brcmf_pno_start_sched_scan()

-- 
https://patchwork.kernel.org/patch/9648789/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
