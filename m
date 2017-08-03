Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45348 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751238AbdHCKVJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Aug 2017 06:21:09 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v5] rtlwifi: Replace hardcode value with macro
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170802122915.GA4759@symbol-HP-ZBook-15>
References: <20170802122915.GA4759@symbol-HP-ZBook-15>
To: Souptick Joarder <jrdr.linux@gmail.com>
Cc: arend.vanspriel@broadcom.com, Larry.Finger@lwfinger.net,
        linux-wireless@vger.kernel.org
Message-Id: <20170803102108.C5EC060763@smtp.codeaurora.org> (sfid-20170803_122112_806264_137FCC9C)
Date: Thu,  3 Aug 2017 10:21:08 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Souptick Joarder <jrdr.linux@gmail.com> wrote:

> In _rtl_init_mac80211(), hardcoded value for hw->max_listen_interval
> and hw->max_rate_tries are replaced by macro and removed the comment.
> 
> Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Patch applied to wireless-drivers-next.git, thanks.

9d546198705a rtlwifi: Replace hardcode value with macro

-- 
https://patchwork.kernel.org/patch/9876703/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
