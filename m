Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53127 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087Ab0J0UAR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Oct 2010 16:00:17 -0400
Date: Wed, 27 Oct 2010 15:54:27 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Daniel Drake <dsd@laptop.org>
Cc: linux-wireless@vger.kernel.org, dcbw@redhat.com,
	libertas-dev@lists.infradead.org, pgf@laptop.org
Subject: Re: [PATCH v2] libertas: Fix sd8686 firmware reload
Message-ID: <20101027195427.GB2410@tuxdriver.com>
References: <20101027142052.9607A9D401B@zog.reactivated.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20101027142052.9607A9D401B@zog.reactivated.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 27, 2010 at 03:20:52PM +0100, Daniel Drake wrote:
> From: Paul Fox <pgf@laptop.org>
> 
> For the SD8686, we cannot rely on the scratch register to read the firmware
> load status, because the same register is used for storing RX packet length.
> Broaden the check to account for this.
> 
> The module can now be unloaded/reloaded successfully.
> 
> Based on the implementation from libertas_tf.
> 
> Signed-off-by: Daniel Drake <dsd@laptop.org>

  CC [M]  drivers/net/wireless/libertas/if_sdio.o
drivers/net/wireless/libertas/if_sdio.c: In function ‘if_sdio_prog_firmware’:
drivers/net/wireless/libertas/if_sdio.c:718: error: ‘IF_SDIO_MODEL_8686’ undeclared (first use in this function)
drivers/net/wireless/libertas/if_sdio.c:718: error: (Each undeclared identifier is reported only once
drivers/net/wireless/libertas/if_sdio.c:718: error: for each function it appears in.)

What tree has this definition?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
