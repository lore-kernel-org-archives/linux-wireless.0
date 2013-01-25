Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:28755 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757609Ab3AYRJG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2013 12:09:06 -0500
Date: Fri, 25 Jan 2013 09:09:03 -0800
From: Tony Lindgren <tony@atomide.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org, balbi@ti.com,
	linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/5] wlcore: move wl12xx_platform_data up and make
 it truly optional
Message-ID: <20130125170903.GZ22517@atomide.com> (sfid-20130125_180927_754590_F95615DD)
References: <1358952038-5982-6-git-send-email-coelho@ti.com>
 <1359108334-18459-1-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1359108334-18459-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Luciano Coelho <coelho@ti.com> [130125 02:09]:
> The platform data is used not only by wlcore-based drivers, but also
> by wl1251.  Move it up in the directory hierarchy to reflect this.
> 
> Additionally, make it truly optional.  At the moment, disabling
> platform data while wl1251_sdio or wlcore_sdio are enabled doesn't
> work, but it will be necessary when device tree support is
> implemented.
> 
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> Reviewed-by: Felipe Balbi <balbi@ti.com>
> ---
> 
> In v2:
>    * Fix ti/Makefile
>    * Modify board_omap3evm.c which was still using the old Kconfig define
> 
> Tony, is it okay if I add this change in the omap3evm board in this
> patch and queue it via wireless so that the whole thing is in sync?

OK, this should not cause additional merge conflicts:

Acked-by: Tony Lindgren <tony@atomide.com> 
