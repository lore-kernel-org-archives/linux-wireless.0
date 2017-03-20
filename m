Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58516 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753172AbdCTRUw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Mar 2017 13:20:52 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: rt2x00: add support for MT7620
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170311193011.GA6809@makrotopia.org>
References: <20170311193011.GA6809@makrotopia.org>
To: Daniel Golle <daniel@makrotopia.org>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        linux-wireless@vger.kernel.org
Message-Id: <20170320172050.E166F60EA5@smtp.codeaurora.org> (sfid-20170320_182118_275220_5A2B40E4)
Date: Mon, 20 Mar 2017 17:20:50 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Daniel Golle <daniel@makrotopia.org> wrote:
> From: Roman Yeryomin <roman@advem.lv>
> 
> Basic support for MT7620 built-in wireless radio was added to
> OpenWrt in r41441. It has seen some heavy cleaning and refactoring
> since in order to match the Kernel's code quality standards.
> 
> Signed-off-by: Roman Yeryomin <roman@advem.lv>
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>

Failed to apply even if I had the dependency patch already applied:

error: Failed to merge in the changes.
Applying: rt2x00: add support for MT7620
Using index info to reconstruct a base tree...
M	drivers/net/wireless/ralink/rt2x00/rt2800.h
Falling back to patching base and 3-way merge...
Auto-merging drivers/net/wireless/ralink/rt2x00/rt2800.h
CONFLICT (content): Merge conflict in drivers/net/wireless/ralink/rt2x00/rt2800.h
Patch failed at 0001 rt2x00: add support for MT7620
The copy of the patch that failed is found in: .git/rebase-apply/patch

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/9618995/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
