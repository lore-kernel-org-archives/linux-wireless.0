Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55211 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751549AbcJGLZq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Oct 2016 07:25:46 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/2] rtl8xxxu: Fix rtl8723bu driver reload issue
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1475278518-18527-2-git-send-email-Jes.Sorensen@redhat.com>
References: <1475278518-18527-2-git-send-email-Jes.Sorensen@redhat.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
        stable@vger.kernel.org, Jes Sorensen <Jes.Sorensen@redhat.com>
Message-Id: <20161007112446.2056361AC6@smtp.codeaurora.org> (sfid-20161007_132551_538398_389C1F23)
Date: Fri,  7 Oct 2016 11:24:46 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jes Sorensen <Jes.Sorensen@redhat.com> wrote:
> From: Jes Sorensen <Jes.Sorensen@redhat.com>
> 
> The generic disable_rf() function clears bits 22 and 23 in
> REG_RX_WAIT_CCA, however we did not re-enable them again in
> rtl8723b_enable_rf()
> 
> This resolves the problem for me with 8723bu devices not working again
> after reloading the driver.
> 
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
> Cc: stable@vger.kernel.org # 4.7+

2 patches applied to wireless-drivers.git, thanks.

ab05e5ec81c7 rtl8xxxu: Fix rtl8723bu driver reload issue
29d5e6fbd65b rtl8xxxu: Fix rtl8192eu driver reload issue

-- 
https://patchwork.kernel.org/patch/9359015/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
