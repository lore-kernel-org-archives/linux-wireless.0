Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45788 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751152AbcKSHNp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 19 Nov 2016 02:13:45 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v4,1/3] mwifiex: Allow mwifiex early access to device structure
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1479216964-3328-1-git-send-email-akarwar@marvell.com>
References: <1479216964-3328-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <rajatja@google.com>, <briannorris@google.com>,
        <dmitry.torokhov@gmail.com>, Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20161119071344.B5A89614C2@smtp.codeaurora.org> (sfid-20161119_081358_231202_50FA290F)
Date: Sat, 19 Nov 2016 07:13:44 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> wrote:
> From: Rajat Jain <rajatja@google.com>
> 
> Today all the interface drivers (usb/pcie/sdio) assign the
> adapter->dev in the register_dev() callback, although they
> have this piece of info well before hand.
> 
> This patch makes the device structure available for mwifiex
> right at the beginning, so that it can be used for early
> initialization if needed.
> 
> This is needed for subsequent patches in this patchset that
> intend to unify and consolidate some of the code that would
> otherwise have to be duplicated among the interface drivers
> (sdio, pcie, usb).
> 
> Signed-off-by: Rajat Jain <rajatja@google.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

3 patches applied to wireless-drivers-next.git, thanks.

2e02b5814217 mwifiex: Allow mwifiex early access to device structure
5e28e5fbdcf0 mwifiex: Introduce mwifiex_probe_of() to parse common properties
853402a00823 mwifiex: Enable WoWLAN for both sdio and pcie

-- 
https://patchwork.kernel.org/patch/9429835/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
