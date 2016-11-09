Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57964 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750724AbcKIB3f (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Nov 2016 20:29:35 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] rt2x00: add support for mac addr from device tree
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1472195813-30471-1-git-send-email-dev@kresin.me>
References: <1472195813-30471-1-git-send-email-dev@kresin.me>
To: Mathias Kresin <dev@kresin.me>
Cc: linux-wireless@vger.kernel.org
Message-Id: <20161109012935.0C8706135E@smtp.codeaurora.org> (sfid-20161109_022939_228419_94723492)
Date: Wed,  9 Nov 2016 01:29:35 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mathias Kresin <dev@kresin.me> wrote:
> On some devices the EEPROMs of Ralink Wi-Fi chips have a default Ralink
> MAC address set (RT3062F: 00:0C:43:30:62:00, RT3060F:
> 00:0C:43:30:60:00). Using multiple of these devices in the same network
> can cause nasty issues.
> 
> Allow to override the MAC in the EEPROM with (a known good) one set in
> the device tree to bypass the issue.
> 
> Signed-off-by: Mathias Kresin <dev@kresin.me>
> Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>

Patch applied to wireless-drivers-next.git, thanks.

9766cb709089 rt2x00: add support for mac addr from device tree

-- 
https://patchwork.kernel.org/patch/9300893/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
