Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from void.printf.net ([89.145.121.20]:56926 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752633Ab0J1F5S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Oct 2010 01:57:18 -0400
Date: Thu, 28 Oct 2010 06:57:04 +0100
From: Chris Ball <cjb@laptop.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Daniel Drake <dsd@laptop.org>, dcbw@redhat.com, pgf@laptop.org,
	linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
Subject: Re: [PATCH v2] libertas: Fix sd8686 firmware reload
Message-ID: <20101028055704.GA16352@void.printf.net>
References: <20101027142052.9607A9D401B@zog.reactivated.net> <20101027195427.GB2410@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20101027195427.GB2410@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Wed, Oct 27, 2010 at 03:54:27PM -0400, John W. Linville wrote:
>   CC [M]  drivers/net/wireless/libertas/if_sdio.o
> drivers/net/wireless/libertas/if_sdio.c: In function ‘if_sdio_prog_firmware’:
> drivers/net/wireless/libertas/if_sdio.c:718: error: ‘IF_SDIO_MODEL_8686’ undeclared (first use in this function)
> drivers/net/wireless/libertas/if_sdio.c:718: error: (Each undeclared identifier is reported only once
> drivers/net/wireless/libertas/if_sdio.c:718: error: for each function it appears in.)
> 
> What tree has this definition?

Odd, it's been upstream in if_sdio.h since 2.6.31; mainline commit e70a5ac5.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
