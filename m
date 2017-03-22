Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55230 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751370AbdCVJM2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Mar 2017 05:12:28 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v3] rt2x00: add support for MT7620
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170320234255.GA3154@makrotopia.org>
References: <20170320234255.GA3154@makrotopia.org>
To: Daniel Golle <daniel@makrotopia.org>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        linux-wireless@vger.kernel.org
Message-Id: <20170322090520.1DBD9609FF@smtp.codeaurora.org> (sfid-20170322_101232_014599_9EEE49B3)
Date: Wed, 22 Mar 2017 09:05:20 +0000 (UTC)
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

Patch applied to wireless-drivers-next.git, thanks.

41977e86c984 rt2x00: add support for MT7620

-- 
https://patchwork.kernel.org/patch/9635519/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
