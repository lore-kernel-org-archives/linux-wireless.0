Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45236 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751839AbdLNMmj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Dec 2017 07:42:39 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: brcmfmac: enlarge buffer size of caps to 512 bytes
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1512977901-12726-1-git-send-email-wright.feng@cypress.com>
References: <1512977901-12726-1-git-send-email-wright.feng@cypress.com>
To: Wright Feng <wright.feng@cypress.com>
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        wright.feng@cypress.com, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com
Message-Id: <20171214124239.156AD60A5F@smtp.codeaurora.org> (sfid-20171214_134243_175700_EA76F5C4)
Date: Thu, 14 Dec 2017 12:42:39 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wright Feng <wright.feng@cypress.com> wrote:

> The buffer size of return of cap iovar is greater than 256 bytes in some
> firmwares. For instance, the return size of cap iovar is 271 bytes in 4373
> 13.10.246.79 firmare. It makes feature capability parsing failed because
> caps buffer is default value.
> So we enlarge caps buffer size to 512 bytes and add the error print for
> cap iovar error.
> 
> Signed-off-by: Wright Feng <wright.feng@cypress.com>
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Patch applied to wireless-drivers-next.git, thanks.

7762bb134e3b brcmfmac: enlarge buffer size of caps to 512 bytes

-- 
https://patchwork.kernel.org/patch/10104357/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
