Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50010 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754960AbdIGMyw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Sep 2017 08:54:52 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] brcmfmac: Correctly fail to suspend when SDIO does not
 support power on suspend
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <AC37C967-209B-4BC3-9AF2-9CC4C27391C0@lairdtech.com>
References: <AC37C967-209B-4BC3-9AF2-9CC4C27391C0@lairdtech.com>
To: Eric Bentley <eric.bentley@lairdtech.com>
Cc: Steve deRosier <derosier@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "arend.vanspriel@broadcom.com" <arend.vanspriel@broadcom.com>
Message-Id: <20170907125451.AE5A66072F@smtp.codeaurora.org> (sfid-20170907_145456_158874_4210C8A6)
Date: Thu,  7 Sep 2017 12:54:51 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Eric Bentley <eric.bentley@lairdtech.com> wrote:

> Return error when failing to set power management capabilities flag.  This will
> cause the suspend to fail but the radio will continue to operate.  Allowing this
> to fail without reporting error will cause the radio to be non-functional on 
> resume as it will have lost power.
> 
> Signed-off-by: Eric Bentley eric.bentley@lairdtech.com

The patch is corrupted. It seems you used outlook to submit it which is
a recipe for a disaster:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#format_issues

Also please improve the commit log like Arend mentioned.

fatal: corrupt patch at line 23
error: could not build fake ancestor
Applying: brcmfmac: Correctly fail to suspend when SDIO does not support power on suspend
Patch failed at 0001 brcmfmac: Correctly fail to suspend when SDIO does not support power on suspend
The copy of the patch that failed is found in: .git/rebase-apply/patch

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/9934065/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
