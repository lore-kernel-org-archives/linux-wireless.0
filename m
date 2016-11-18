Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:35072 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754322AbcKRRHB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Nov 2016 12:07:01 -0500
Date: Fri, 18 Nov 2016 11:06:58 -0600
From: Rob Herring <robh@kernel.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>, rajatja@google.com,
        briannorris@google.com, dmitry.torokhov@gmail.com,
        devicetree@vger.kernel.org, Xinming Hu <huxm@marvell.com>
Subject: Re: [PATCH v8] mwifiex: parse device tree node for PCIe
Message-ID: <20161118170658.iar5xzh7pu4qfjgg@rob-hp-laptop> (sfid-20161118_180717_814774_2357E98F)
References: <1479472624-22340-1-git-send-email-akarwar@marvell.com>
 <87oa1coj1m.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87oa1coj1m.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 18, 2016 at 06:21:41PM +0200, Kalle Valo wrote:
> Amitkumar Karwar <akarwar@marvell.com> writes:
> 
> > From: Xinming Hu <huxm@marvell.com>
> >
> > This patch derives device tree node from pcie bus layer framework.
> > Device tree bindings file has been renamed(marvell-sd8xxx.txt ->
> > marvell-8xxx.txt) to accommodate PCIe changes.
> >
> > Signed-off-by: Xinming Hu <huxm@marvell.com>
> > Signed-off-by: Rajat Jain <rajatja@google.com>
> > Reviewed-by: Brian Norris <briannorris@chromium.org>
> > Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> 
> [...]
> 
> > @@ -10,6 +10,8 @@ Required properties:
> >    - compatible : should be one of the following:
> >  	* "marvell,sd8897"
> >  	* "marvell,sd8997"
> > +	* "pci11ab,2b42"
> > +	* "pci1b4b,2b42"
> 
> Are these correct? In v6 Rob said:

Yes, Marvell has 2 vendor IDs it turns out.

> 
> "I think I already said this, but you have the vendor and product IDs 
> reversed."
> 
> https://patchwork.kernel.org/patch/9390225/
> 
> -- 
> Kalle Valo
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
