Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fudo.makrotopia.org ([185.142.180.71]:43228 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751059AbdCSGdr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 19 Mar 2017 02:33:47 -0400
Date: Sun, 19 Mar 2017 07:02:57 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        linux-wireless@vger.kernel.org
Subject: Re: mac80211: rt2x00: add support for MT7620
Message-ID: <20170319060256.GC1706@makrotopia.org> (sfid-20170319_093705_667604_138BFF18)
References: <20170311193011.GA6809@makrotopia.org>
 <20170316080104.4949C60DA6@smtp.codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170316080104.4949C60DA6@smtp.codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 16, 2017 at 08:01:04AM +0000, Kalle Valo wrote:
> Daniel Golle <daniel@makrotopia.org> wrote:
> > From: Roman Yeryomin <roman@advem.lv>
> > 
> > Basic support for MT7620 built-in wireless radio was added to
> > OpenWrt in r41441. It has seen some heavy cleaning and refactoring
> > since in order to match the Kernel's code quality standards.
> > 
> > Signed-off-by: Roman Yeryomin <roman@advem.lv>
> > Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> > Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>
> 
> I'll remove the "mac80211:" prefix during commit, that should be only used with
> mac80211 patches.

Thanks, I forgot about changing the subject line for v2.
Also make sure that https://patchwork.kernel.org/patch/9612163/ gets
applied before this one, because it doesn't apply cleanly otherwise.


> 
> -- 
> https://patchwork.kernel.org/patch/9618995/
> 
> Documentation about submitting wireless patches and checking status
> from patchwork:
> 
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
> 
