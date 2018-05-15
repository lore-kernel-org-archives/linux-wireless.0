Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41384 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752539AbeEOPJK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 May 2018 11:09:10 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/8] brcmfmac: fix initialization of struct cfg80211_inform_bss
 variable
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1526375691-31789-2-git-send-email-arend.vanspriel@broadcom.com>
References: <1526375691-31789-2-git-send-email-arend.vanspriel@broadcom.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
        Franky Lin <franky.lin@broadcom.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Message-Id: <20180515150909.AC09A60A06@smtp.codeaurora.org> (sfid-20180515_170914_392476_E7C7938E)
Date: Tue, 15 May 2018 15:09:09 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:

> From: Franky Lin <franky.lin@broadcom.com>
> 
> This patch fixes a sparse warning "Using plain integer as NULL pointer"
> about cfg80211_inform_bss structure initialization.
> 
> Reported-by: kbuild test robot <lkp@intel.com>
> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Franky Lin <franky.lin@broadcom.com>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Patch applied to wireless-drivers-next.git, thanks.

763ece85f45a brcmfmac: fix initialization of struct cfg80211_inform_bss variable

-- 
https://patchwork.kernel.org/patch/10400587/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
