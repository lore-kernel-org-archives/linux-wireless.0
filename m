Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36178 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751459AbdATJu3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Jan 2017 04:50:29 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/5] rtl8xxxu: Mark 8192eu device 0x0bda:0x818b as tested
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170117231856.5075-2-Jes.Sorensen@gmail.com>
References: <20170117231856.5075-2-Jes.Sorensen@gmail.com>
To: Jes Sorensen <jes.sorensen@gmail.com>
Cc: linux-wireless@vger.kernel.org
Message-Id: <20170120094921.EFCBE607CD@smtp.codeaurora.org> (sfid-20170120_105045_345858_961985B4)
Date: Fri, 20 Jan 2017 09:49:21 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jes Sorensen <jes.sorensen@gmail.com> wrote:
> From: Jes Sorensen <Jes.Sorensen@redhat.com>
> 
> Device reported as working fine, so tell the driver not to warn about
> it being untested.
> 
> Reported-by: Aex Aey <aexaey@gmail.com>
> Signed-off-by: Jes Sorensen <Jes.Sorensen@gmail.com>

5 patches applied to wireless-drivers-next.git, thanks.

d607e396566a rtl8xxxu: Mark 8192eu device 0x0bda:0x818b as tested
c14239f23adb rtl8xxxu: Add another 8192eu device to the USB list
66dfa26ebca8 rtl8xxxu: Add USB ID for D-Link DWA-131 rev E1 (rtl8192eu)
5407fd7de69f rtl8xxxu: Add additional USB IDs for rtl8192eu devices
1ee83789fc1f rtl8xxxu: Update author/maintainer contact info

-- 
https://patchwork.kernel.org/patch/9522313/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
