Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33920 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751201AbeEWPyj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 May 2018 11:54:39 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [V2,1/6] brcmfmac: move ALLFFMAC variable in flowring module
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1526472723-15758-2-git-send-email-arend.vanspriel@broadcom.com>
References: <1526472723-15758-2-git-send-email-arend.vanspriel@broadcom.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Message-Id: <20180523155439.31449601E8@smtp.codeaurora.org> (sfid-20180523_175551_515479_5D229EF7)
Date: Wed, 23 May 2018 15:54:39 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:

> The only user of ALLFFMAC is the flowring module so no need to
> expose it in a header file.
> 
> Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
> Reviewed-by: Franky Lin <franky.lin@broadcom.com>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>

6 patches applied to wireless-drivers-next.git, thanks.

f8793c26fe58 brcmfmac: move ALLFFMAC variable in flowring module
8e072168f75e brcmfmac: add support for sysfs initiated coredump
21c5c83ce833 mwifiex: support sysfs initiated device coredump
d2af9b566554 brcmfmac: validate user provided data for memdump before copying
8a3ab2f38f16 brcmfmac: trigger memory dump upon firmware halt signal
b8248236e927 brcmfmac: trigger memory dump on SDIO firmware halt message

-- 
https://patchwork.kernel.org/patch/10403713/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
