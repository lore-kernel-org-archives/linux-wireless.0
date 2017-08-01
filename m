Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f178.google.com ([209.85.220.178]:34862 "EHLO
        mail-qk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751571AbdHAMoJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 Aug 2017 08:44:09 -0400
Received: by mail-qk0-f178.google.com with SMTP id d145so8151425qkc.2
        for <linux-wireless@vger.kernel.org>; Tue, 01 Aug 2017 05:44:09 -0700 (PDT)
Subject: Re: [PATCH 3/3] brcmfmac: fix wrong num_different_channels when mchan
 feature enabled
To: Wright Feng <wright.feng@cypress.com>, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
References: <1501577287-28904-1-git-send-email-wright.feng@cypress.com>
 <1501577287-28904-3-git-send-email-wright.feng@cypress.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <0c5bb3ef-f5e3-24b7-7287-3dd8350080b9@broadcom.com> (sfid-20170801_144413_613051_E01DACF7)
Date: Tue, 1 Aug 2017 14:44:05 +0200
MIME-Version: 1.0
In-Reply-To: <1501577287-28904-3-git-send-email-wright.feng@cypress.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01-08-17 10:48, Wright Feng wrote:
> The num_different_channels in wiphy info is not correct when firmware
> supports mchan. When mchan is on, num_different_channels is always
> overridden to 1 in brcmf_setup_ifmodes. Correct the logic by moving
> num_different_channels setting forward.

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Wright Feng <wright.feng@cypress.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
