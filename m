Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39992 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751133AbdHCJgX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Aug 2017 05:36:23 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] rtlwifi: Fix fallback firmware loading
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <87d18gmvsq.fsf_-_@turtle.gmx.de>
References: <87d18gmvsq.fsf_-_@turtle.gmx.de>
To: Sven Joachim <svenjoac@gmx.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>
Message-Id: <20170803093623.101DC6037B@smtp.codeaurora.org> (sfid-20170803_113627_201880_A4C8319E)
Date: Thu,  3 Aug 2017 09:36:22 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sven Joachim <svenjoac@gmx.de> wrote:

> Commit f70e4df2b384 ("rtlwifi: Add code to read new versions of
> firmware") added code to load an old firmware file if the new one is
> not available.  Unfortunately that code is never reached because
> request_firmware_nowait() does not wait for the firmware to show up
> and returns 0 even if the file is not there.
> 
> Use the existing fallback mechanism introduced by commit 62009b7f1279
> ("rtlwifi: rtl8192cu: Add new firmware") instead.
> 
> Fixes: f70e4df2b384 ("rtlwifi: Add code to read new versions of firmware")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sven Joachim <svenjoac@gmx.de>

Patch applied to wireless-drivers-next.git, thanks.

1d9b168d8ea9 rtlwifi: Fix fallback firmware loading

-- 
https://patchwork.kernel.org/patch/9872413/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
