Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58242 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751068AbeC0JIW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Mar 2018 05:08:22 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [V2,
 01/12] brcmfmac: do not convert linux error to firmware error string
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1521750511-12345-2-git-send-email-arend.vanspriel@broadcom.com>
References: <1521750511-12345-2-git-send-email-arend.vanspriel@broadcom.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Message-Id: <20180327090822.1DE966030F@smtp.codeaurora.org> (sfid-20180327_110827_555031_66A16B92)
Date: Tue, 27 Mar 2018 09:08:22 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:

> In case of a linux error brcmf_fil_cmd_data() blurts an error message
> in which the error code is translated to an error string. However, it
> maps it to a firmware error string which should not happen. Simply
> print only the numeric error code and be done with it.
> 
> Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
> Reviewed-by: Franky Lin <franky.lin@broadcom.com>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>

12 patches applied to wireless-drivers-next.git, thanks.

1170f6d1be6a brcmfmac: do not convert linux error to firmware error string
756a2b390874 brcmfmac: use brcmf_chip_name() to store name in revinfo
c88cfa075de3 brcmfmac: use brcmf_chip_name() for consistency
856d5a011c86 brcmfmac: allocate struct brcmf_pub instance using wiphy_new()
34789d0cf682 brcmfmac: use wiphy debugfs dir entry
41f573dbb534 brcmfmac: derive firmware filenames from basename mapping
d09ae51a4b67 brcmfmac: pass struct in brcmf_fw_get_firmwares()
2baa3aaee27f brcmfmac: introduce brcmf_fw_alloc_request() function
bf7a7b37f6ef brcmfmac: add extension to .get_fwname() callbacks
18c2b20e276e brcmfmac: get rid of brcmf_fw_map_chip_to_name()
bf291b7247e5 brcmfmac: get rid of brcmf_fw_get_full_name()
48eaee3f272a brcmfmac: add kerneldoc for struct brcmf_bus::msgbuf

-- 
https://patchwork.kernel.org/patch/10302277/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
