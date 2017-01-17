Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37548 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750884AbdAQMBo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Jan 2017 07:01:44 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/2] brcmfmac: don't preset all channels as disabled
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170107203605.24866-1-zajec5@gmail.com>
References: <20170107203605.24866-1-zajec5@gmail.com>
To: =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Message-Id: <20170117120128.6050E6079B@smtp.codeaurora.org> (sfid-20170117_130147_642775_55B0F79E)
Date: Tue, 17 Jan 2017 12:01:28 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> During init we take care of regulatory stuff by disabling all
> unavailable channels (see brcmf_construct_chaninfo) so this predisabling
> them is not really required (and this patch won't change any behavior).
> It will on the other hand allow more detailed runtime control over
> channels which is the main reason for this change.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>

2 patches applied to wireless-drivers-next.git, thanks.

9ea0c307609f brcmfmac: don't preset all channels as disabled
ab99063f8737 brcmfmac: setup wiphy bands after registering it first

-- 
https://patchwork.kernel.org/patch/9503277/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
