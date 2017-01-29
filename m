Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48248 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750803AbdA2LWs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 29 Jan 2017 06:22:48 -0500
Date: Sun, 29 Jan 2017 12:16:27 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Felix Fietkau <nbd@nbd.name>
Cc: linux-wireless@vger.kernel.org,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Gabor Juhos <juhosg@openwrt.org>,
        Serge Vasilugin <vasilugin@yandex.ru>,
        Mathias Kresin <dev@kresin.me>,
        Michel Stempin <michel.stempin@wanadoo.fr>
Subject: Re: [PATCH v4 1/3] rt2x00: add copy of clk for soc devices
Message-ID: <20170129111626.GA7489@redhat.com> (sfid-20170129_122251_838455_D4D9245E)
References: <1484918906-21856-1-git-send-email-sgruszka@redhat.com>
 <1484918906-21856-2-git-send-email-sgruszka@redhat.com>
 <52ba40db-0f58-e982-2fd0-31d62343203d@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52ba40db-0f58-e982-2fd0-31d62343203d@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 28, 2017 at 08:39:15PM +0100, Felix Fietkau wrote:
> >  	rt2x00dev->hw = hw;
> >  	rt2x00dev->irq = platform_get_irq(pdev, 0);
> >  	rt2x00dev->name = pdev->dev.driver->name;
> > +	rt2x00dev->clk = clk_get(&pdev->dev);
> This looks broken, clk_get takes two parameters, not just one.

Err, since patch was already applied in -next, I will post fix
in separate patch.  

Thanks
Stanislaw
