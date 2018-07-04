Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34212 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752607AbeGDPHO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Jul 2018 11:07:14 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [V4,1/3] brcmfmac: detect firmware support for monitor interface
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180624194437.28766-1-zajec5@gmail.com>
References: <20180624194437.28766-1-zajec5@gmail.com>
To: =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Message-Id: <20180704150713.89FE3606FC@smtp.codeaurora.org> (sfid-20180704_170718_938080_D8965B4C)
Date: Wed,  4 Jul 2018 15:07:13 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki wrote:

> From: Rafał Miłecki <rafal@milecki.pl>
> 
> Many/most of firmwares support creating monitor interface but only the
> most recent ones explicitly /announce/ it using a "monitor" entry in the
> list of capabilities.
> 
> Check for that entry and store internally info about monitor mode
> support using a new feature flag. Once we sort out all details of
> handling monitor interface it will be used when reporting available
> interfaces to the cfg80211.
> 
> Later some fallback detecion method may be added for older firmwares.
> For now just stick to the "monitor" capability which should be 100%
> reliable.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

3 patches applied to wireless-drivers-next.git, thanks.

01f69dfafdbe brcmfmac: detect firmware support for monitor interface
e63410ac65e0 brcmfmac: detect firmware support for radiotap monitor frames
a8d7631858af brcmfmac: handle msgbuf packets marked with monitor mode flag

-- 
https://patchwork.kernel.org/patch/10484843/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
