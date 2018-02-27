Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56124 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752359AbeB0QYg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 11:24:36 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: brcmfmac: reject too long PSK
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180219123045.8818-1-johannes@sipsolutions.net>
References: <20180219123045.8818-1-johannes@sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, arend.vanspriel@broadcom.com,
        Johannes Berg <johannes.berg@intel.com>
Message-Id: <20180227162436.142CF60854@smtp.codeaurora.org> (sfid-20180227_172440_406648_94C1AE1E)
Date: Tue, 27 Feb 2018 16:24:36 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> wrote:

> From: Johannes Berg <johannes.berg@intel.com>
> 
> nl80211 already allows specifying 48 bytes, but brcmfmac
> only supports 32. Reject keys that are too long.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Patch applied to wireless-drivers-next.git, thanks.

64d1519edc95 brcmfmac: reject too long PSK

-- 
https://patchwork.kernel.org/patch/10227649/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
