Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45260 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750791AbdBOJMC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Feb 2017 04:12:02 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v5] wlcore: disable multicast filter in AP mode
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170209143728.22831-1-i-hunter1@ti.com>
References: <20170209143728.22831-1-i-hunter1@ti.com>
To: Iain Hunter <drhunter95@gmail.com>
Cc: linux-wireless@vger.kernel.org, kvalo@aurora.org,
        Iain Hunter <i-hunter1@ti.com>
Message-Id: <20170215091201.AD57B6087A@smtp.codeaurora.org> (sfid-20170215_101224_015321_91EE912F)
Date: Wed, 15 Feb 2017 09:12:01 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Iain Hunter <drhunter95@gmail.com> wrote:
> Enable AP support for allmulticast for MDNS. It can be enabled by bringing
> up the interface with ip command with argument allmulticast on
> 
> Signed-off-by: Iain Hunter <i-hunter1@ti.com>

Patch applied to wireless-drivers-next.git, thanks.

1f8665320fa1 wlcore: disable multicast filter in AP mode

-- 
https://patchwork.kernel.org/patch/9564711/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
