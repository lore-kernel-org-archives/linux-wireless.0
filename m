Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51186 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750771AbdCNKgy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Mar 2017 06:36:54 -0400
Date: Tue, 14 Mar 2017 11:36:47 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Daniel Golle <daniel@makrotopia.org>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        linux-wireless@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH] mac80211: rt2x00: add support for MT7620
Message-ID: <20170314103646.GA2622@redhat.com> (sfid-20170314_113657_073420_20CEB37D)
References: <20170311103750.GA17556@redhat.com>
 <20170311193011.GA6809@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170311193011.GA6809@makrotopia.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 11, 2017 at 08:30:23PM +0100, Daniel Golle wrote:
> From: Roman Yeryomin <roman@advem.lv>
> 
> Basic support for MT7620 built-in wireless radio was added to
> OpenWrt in r41441. It has seen some heavy cleaning and refactoring
> since in order to match the Kernel's code quality standards.

> Signed-off-by: Roman Yeryomin <roman@advem.lv>
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>

Good job!

Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>

> tx_pin should only be modified as higher bits contain setting polarity
> for external LNA and PA which should not be reset. If you believe it
> would cause regressions, let's only read it for RT6352 and set it to 0
> for all other chips.

I checked patch on various RTxxxx USB devices and do not find
any regression, beside this was also tested with OpenWRT on various
SOCs, so I think it is ok

Thanks
Stanislaw
