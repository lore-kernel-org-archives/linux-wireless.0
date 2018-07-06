Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:60163 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753810AbeGFOhl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Jul 2018 10:37:41 -0400
Date: Fri, 6 Jul 2018 16:37:28 +0200
From: Boris Brezillon <boris.brezillon@bootlin.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        linux-mtd@lists.infradead.org,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 21/27] bcma: Allow selection of this driver when
 COMPILE_TEST=y
Message-ID: <20180706163728.30485acd@bbrezillon> (sfid-20180706_163744_464563_8CC67F14)
In-Reply-To: <87zhz4tox9.fsf@purkki.adurom.net>
References: <20180705094522.12138-1-boris.brezillon@bootlin.com>
        <20180705094522.12138-22-boris.brezillon@bootlin.com>
        <87zhz4tox9.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 06 Jul 2018 17:32:50 +0300
Kalle Valo <kvalo@codeaurora.org> wrote:

> Boris Brezillon <boris.brezillon@bootlin.com> writes:
> 
> > This allows us to increase compile-test coverage without having to build
> > a kernel for MIPS.  That's particularly interesting for subsystem
> > maintainers that want to test as many drivers as possible in a single
> > build.
> >
> > We also add a dependency on HAS_IOMEM in BCMA_HOST_SOC to make sure the
> > driver is not selected when the arch does not implement IO accessors.
> >
> > Signed-off-by: Boris Brezillon <boris.brezillon@bootlin.com>
> > ---
> >  drivers/bcma/Kconfig | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)  
> 
> Acked-by: Kalle Valo <kvalo@codeaurora.org>
> 
> I assume this patch will go via some other tree and I can drop it.
> 

Yep. We can create an immutable tag if needed.
