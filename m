Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:35994 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757092AbYBWU0W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Feb 2008 15:26:22 -0500
Message-ID: <47C0815F.7020100@pobox.com> (sfid-20080223_202627_127192_27742B3F)
Date: Sat, 23 Feb 2008 15:26:07 -0500
From: Jeff Garzik <jgarzik@pobox.com>
MIME-Version: 1.0
To: Sebastian Siewior <netdev@ml.breakpoint.cc>
CC: Masakazu Mokuno <mokuno@sm.sony.co.jp>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] [PS3] gelic wireless driver needs MAC80211 support
References: <20080223193517.GA6704@Chamillionaire.breakpoint.cc>
In-Reply-To: <20080223193517.GA6704@Chamillionaire.breakpoint.cc>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sebastian Siewior wrote:
> so select it.
> Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
> ---
>  drivers/net/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
> index f337800..a116056 100644
> --- a/drivers/net/Kconfig
> +++ b/drivers/net/Kconfig
> @@ -2363,6 +2363,7 @@ config GELIC_NET
>  config GELIC_WIRELESS
>         bool "PS3 Wireless support"
>         depends on GELIC_NET
> +       select MAC80211

Given that this is straying clearly into wireless territory, I think the 
linux-wireless folks and John Linville (wireless maintainer) are 
appropriate patch targets.

	Jeff


