Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34172 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753986AbeEWIB7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 May 2018 04:01:59 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [V2] brcmfmac: add debugfs entry for reading firmware capabilities
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180514064820.24305-1-zajec5@gmail.com>
References: <20180514064820.24305-1-zajec5@gmail.com>
To: =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Message-Id: <20180523080159.917DB604D4@smtp.codeaurora.org> (sfid-20180523_100311_033706_DA8F6F5B)
Date: Wed, 23 May 2018 08:01:59 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki wrote:

> From: Rafał Miłecki <rafal@milecki.pl>
> 
> This allows reading all capabilities as reported by a firmware. They are
> printed using native (raw) names, just like developers like it the most.
> It's how firmware reports support for various features, e.g. supported
> modes, supported standards, power saving details, max BSS-es.
> 
> Access to all that info is useful for trying new firmwares, comparing
> them and debugging features AKA bugs.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Patch applied to wireless-drivers-next.git, thanks.

88001968245c brcmfmac: add debugfs entry for reading firmware capabilities

-- 
https://patchwork.kernel.org/patch/10396811/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
