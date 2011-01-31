Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58559 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649Ab1AaUAS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 15:00:18 -0500
Date: Mon, 31 Jan 2011 14:47:27 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Mathias Krause <minipli@googlemail.com>
Cc: linux-wireless@vger.kernel.org, Kalle Valo <kvalo@adurom.com>
Subject: Re: [PATCH] wl12xx: fix use after free
Message-ID: <20110131194727.GA3065@tuxdriver.com>
References: <1296383387-20151-1-git-send-email-minipli@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1296383387-20151-1-git-send-email-minipli@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 30, 2011 at 11:29:47AM +0100, Mathias Krause wrote:
> When DEBUG_SPI is included in the debug log level wl1271_spi_reset()
> will dump the already freed memory instead of the SPI buffer.
> 
> This bug was spotted by the semantic patch tool coccinelle using the
> script found at scripts/coccinelle/free/kfree.cocci.
> 
> More information about semantic patching is available at
> http://coccinelle.lip6.fr/
> 
> Signed-off-by: Mathias Krause <minipli@googlemail.com>

Luca, I'll go ahead and apply this one directly to wireless-2.6.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
