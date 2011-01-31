Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:38098 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553Ab1AaUOb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 15:14:31 -0500
Subject: Re: [PATCH] wl12xx: fix use after free
From: Luciano Coelho <coelho@ti.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: Mathias Krause <minipli@googlemail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@adurom.com>
In-Reply-To: <20110131194727.GA3065@tuxdriver.com>
References: <1296383387-20151-1-git-send-email-minipli@googlemail.com>
	 <20110131194727.GA3065@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 Jan 2011 22:14:10 +0200
Message-ID: <1296504850.3069.653.camel@pimenta>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-01-31 at 20:47 +0100, John W. Linville wrote:
> On Sun, Jan 30, 2011 at 11:29:47AM +0100, Mathias Krause wrote:
> > When DEBUG_SPI is included in the debug log level wl1271_spi_reset()
> > will dump the already freed memory instead of the SPI buffer.
> > 
> > This bug was spotted by the semantic patch tool coccinelle using the
> > script found at scripts/coccinelle/free/kfree.cocci.
> > 
> > More information about semantic patching is available at
> > http://coccinelle.lip6.fr/
> > 
> > Signed-off-by: Mathias Krause <minipli@googlemail.com>
> 
> Luca, I'll go ahead and apply this one directly to wireless-2.6.

Okay, thanks John!

-- 
Cheers,
Luca.

