Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44244 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755977AbeARN1h (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Jan 2018 08:27:37 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: rtlwifi: Support A-MSDU in A-MPDU capability
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180118012614.6724-1-pkshih@realtek.com>
References: <20180118012614.6724-1-pkshih@realtek.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Message-Id: <20180118132737.5DD1D60818@smtp.codeaurora.org> (sfid-20180118_142742_835652_A14E2428)
Date: Thu, 18 Jan 2018 13:27:37 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ping-Ke Shih <pkshih@realtek.com> wrote:

> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> Due to the fact that A-MSDU deaggregation is done in software,
> we set this flag to support the A-MSDU in A-MPDU
> 
> Signed-off-by: Steven Ting <steventing@realtek.com>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-drivers-next.git, thanks.

5f9066930b5d rtlwifi: Support A-MSDU in A-MPDU capability

-- 
https://patchwork.kernel.org/patch/10172213/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
