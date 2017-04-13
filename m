Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37166 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753612AbdDMN7E (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 09:59:04 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Xinming Hu <huxinming820@gmail.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>, rajatja@google.com,
        Amitkumar Karwar <akarwar@marvell.com>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: Re: [PATCH v4 4/4] mwifiex: pcie: extract wifi part from combo firmware during function level reset
References: <1492066102-31251-1-git-send-email-huxinming820@gmail.com>
        <1492066102-31251-4-git-send-email-huxinming820@gmail.com>
Date: Thu, 13 Apr 2017 16:58:54 +0300
In-Reply-To: <1492066102-31251-4-git-send-email-huxinming820@gmail.com>
        (Xinming Hu's message of "Thu, 13 Apr 2017 06:48:22 +0000")
Message-ID: <87wpaobe8x.fsf@purkki.adurom.net> (sfid-20170413_155912_788321_DCBEABE5)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Xinming Hu <huxinming820@gmail.com> writes:

> From: Xinming Hu <huxm@marvell.com>
>
> A seprate wifi-only firmware was download during pcie function level reset.
> It is in fact the tail part of wifi/bt combo firmware. Per Brian's and
> Dmitry's suggestion, this patch extract the wifi part from combo firmware.
>
> After that, we can discard the redudant image in linux-firmware repo.

If you mean with discarding removing the actual image from
linux-firmware, then you cannot do that. The image is still needed so
that linux-firmware works with older kernels.

-- 
Kalle Valo
