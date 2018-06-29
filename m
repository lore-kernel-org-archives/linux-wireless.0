Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51852 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750761AbeF2GzU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Jun 2018 02:55:20 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/6] brcmfmac: remove fallback mechanism for BRCMF_FEAT_MONITOR
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1529693004-20569-2-git-send-email-arend.vanspriel@broadcom.com>
References: <1529693004-20569-2-git-send-email-arend.vanspriel@broadcom.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Message-Id: <20180629065520.1F0E5605A5@smtp.codeaurora.org> (sfid-20180629_085524_708700_6AB65AE7)
Date: Fri, 29 Jun 2018 06:55:20 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:

> Commit 19f505aa3ae0 ("brcmfmac: detect firmware support for monitor
> interface") introduced a fallback mechanism attempting BRCMF_C_MONITOR
> command. However, that does not indicate firmware support. Unfortunately,
> it only indicates the core part of the stack supports it, but not whether
> it is supported in full-dongle mode, ie. firmware has means to transfer
> the monitor packets to the host. Firmwares that return the "monitor"
> flag in the "cap" iovar are able to send the packets to the host.
> 
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Dropping per Arend's request

6 patches set to Changes Requested.

10482829 [1/6] brcmfmac: remove fallback mechanism for BRCMF_FEAT_MONITOR
10482837 [2/6] brcmfmac: rename BRCMF_FEAT_MONITOR_FMT_RADIOTAP to BRCMF_FEAT_RADIOTAP
10482833 [3/6] brcmfmac: fix for proper support of 160MHz bandwidth
10482835 [4/6] brcmfmac: increase buffer for obtaining firmware capabilities
10482827 [5/6] brcmfmac: add new feature flags for monitor mode operation
10482831 [6/6] brcmfmac: fallback mechanism to determine monitor mode features

-- 
https://patchwork.kernel.org/patch/10482829/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
