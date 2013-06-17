Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:38091 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754868Ab3FQJXW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jun 2013 05:23:22 -0400
Message-ID: <1371460994.3028.8.camel@cumari.coelho.fi> (sfid-20130617_112340_730092_2D682A73)
Subject: Re: [PATCH] net/wireless/ti/wlcore/spi: Use module_spi_driver to
 register driver
From: Luciano Coelho <coelho@ti.com>
To: Peter Huewe <peterhuewe@gmx.de>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Felipe Balbi <balbi@ti.com>, Ido Yariv <ido@wizery.com>,
	Arik Nemtsov <arik@wizery.com>,
	<linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Date: Mon, 17 Jun 2013 12:23:14 +0300
In-Reply-To: <1369079560-6101-1-git-send-email-peterhuewe@gmx.de>
References: <1369079560-6101-1-git-send-email-peterhuewe@gmx.de>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-05-20 at 21:52 +0200, Peter Huewe wrote:
> Removing some boilerplate by using module_spi_driver instead of calling
> register and unregister in the otherwise empty init/exit functions
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> ---

Applied.  Thanks, Peter.

--
Luca.

