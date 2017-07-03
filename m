Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44084 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752650AbdGCL3s (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Jul 2017 07:29:48 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: "Reizer\, Eyal" <eyalr@ti.com>
Cc: "\,Tony Lindgren" <tony@atomide.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] wlcore: add missing nvs file name info for wilink8
References: <8665E2433BC68541A24DFFCA87B70F5B363E1A3D@DFRE01.ent.ti.com>
Date: Mon, 03 Jul 2017 14:29:32 +0300
In-Reply-To: <8665E2433BC68541A24DFFCA87B70F5B363E1A3D@DFRE01.ent.ti.com>
        (Eyal Reizer's message of "Mon, 3 Jul 2017 10:54:43 +0000")
Message-ID: <87y3s5kbc3.fsf@kamboji.qca.qualcomm.com> (sfid-20170703_132951_918053_FDE39A06)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Reizer, Eyal" <eyalr@ti.com> writes:

> When working with wl18xx the nvs file is used for defining an alternate
> mac address and override the default mac address that is stored inside
> the wl18xx chip.
> update the structure field with the same default nvs file name that has
> been used in the past, otherwise userspace backward compatibility is
> broken when upgrading from older kernels, as the alternate mac address
> would not be read from the nvs that is already present in the file system
> (lib/firmware/ti-connectivity/wl1271-nvs.bin) causing mac address change
> of the wlan interface.
>
> Signed-off-by: Eyal Reizer <eyalr@ti.com>

Should we also cc stable? And a Fixes line would be nice.

-- 
Kalle Valo
