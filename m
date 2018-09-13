Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726930AbeIMU7i (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Sep 2018 16:59:38 -0400
Received: from mail-qt0-f176.google.com (mail-qt0-f176.google.com [209.85.216.176])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A436D2146E
        for <linux-wireless@vger.kernel.org>; Thu, 13 Sep 2018 15:49:33 +0000 (UTC)
Received: by mail-qt0-f176.google.com with SMTP id z8-v6so5794615qto.9
        for <linux-wireless@vger.kernel.org>; Thu, 13 Sep 2018 08:49:33 -0700 (PDT)
MIME-Version: 1.0
References: <1536822475-177949-1-git-send-email-chi-hsien.lin@cypress.com>
In-Reply-To: <1536822475-177949-1-git-send-email-chi-hsien.lin@cypress.com>
From: Josh Boyer <jwboyer@kernel.org>
Date: Thu, 13 Sep 2018 11:49:21 -0400
Message-ID: <CA+5PVA55iwSPQ0geTw4kM5xDkMwc4Q5vJ_o2d19TOxtXyGFuTg@mail.gmail.com> (sfid-20180913_174936_532110_BA0098D5)
Subject: Re: [PATCH] brcm: update firmware for bcm43362 sdio
To: chi-hsien.lin@cypress.com
Cc: Linux Firmware <linux-firmware@kernel.org>,
        Linux Wireless <linux-wireless@vger.kernel.org>,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, jwboyer@kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        wright.feng@cypress.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 13, 2018 at 6:42 AM Chi-Hsien Lin <chi-hsien.lin@cypress.com> wrote:
>
> This firmware includes p2p fixes.
>
> Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
> ---
>  brcm/brcmfmac43362-sdio.bin | Bin 200801 -> 202107 bytes
>  1 file changed, 0 insertions(+), 0 deletions(-)

Applied and pushed out.

josh
