Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34592 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752435AbeGDPHz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Jul 2018 11:07:55 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: brcmfmac: define more bits for the flags of struct
 brcmf_sta_info_le
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180628061613.16648-1-zajec5@gmail.com>
References: <20180628061613.16648-1-zajec5@gmail.com>
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
Message-Id: <20180704150754.9AF4360791@smtp.codeaurora.org> (sfid-20180704_170800_199262_09BD36DF)
Date: Wed,  4 Jul 2018 15:07:54 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki wrote:

> From: Rafał Miłecki <rafal@milecki.pl>
> 
> That struct is passed by a firmware when querying for STA info. Flags
> are used to indicate what info could be obtained.
> 
> These new defines may allow passing more info to the cfg80211 in the
> future. They had been obtained from Broadcom's SDK file wlioctl_defs.h
> used by DD-WRT.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>

Patch applied to wireless-drivers-next.git, thanks.

4b4a8d808c58 brcmfmac: define more bits for the flags of struct brcmf_sta_info_le

-- 
https://patchwork.kernel.org/patch/10493139/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
