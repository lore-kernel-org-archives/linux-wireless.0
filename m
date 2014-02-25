Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:51780 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752721AbaBYNGy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 08:06:54 -0500
Received: from fb07-iapwap2.localnet ([134.176.19.122]) by mail.gmx.com
 (mrgmx003) with ESMTPSA (Nemesis) id 0MLOMM-1WIpx53Gmw-000Yz2 for
 <linux-wireless@vger.kernel.org>; Tue, 25 Feb 2014 14:06:52 +0100
From: Marc Dietrich <marvin24@gmx.de>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	Chen-Yu Tsai <wens@csie.org>,
	Rhyland Klein <rklein@nvidia.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Alexandre Courbot <gnurou@gmail.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-tegra@vger.kernel.org
Subject: Re: [PATCHv2 1/5] ARM: tegra: remove obsolete gpio entries
Date: Tue, 25 Feb 2014 14:06:45 +0100
Message-ID: <5570705.i8uRb6OetD@fb07-iapwap2> (sfid-20140225_140728_299387_8448D697)
In-Reply-To: <1393330950-7283-2-git-send-email-heikki.krogerus@linux.intel.com>
References: <1393330950-7283-1-git-send-email-heikki.krogerus@linux.intel.com> <1393330950-7283-2-git-send-email-heikki.krogerus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Heikki,

Am Dienstag, 25. Februar 2014, 14:22:26 schrieb Heikki Krogerus:
> After moving to description based gpio interface in
> rfkill-gpio, the gpio numbers are not used any more.
> 
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>

Reviewed-by: Marc Dietrich <marvin24@gmx.de>

Thanks for taking care!

Marc

> ---
>  arch/arm/mach-tegra/board-paz00.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/arch/arm/mach-tegra/board-paz00.c
> b/arch/arm/mach-tegra/board-paz00.c index e4dec9f..9c6029b 100644
> --- a/arch/arm/mach-tegra/board-paz00.c
> +++ b/arch/arm/mach-tegra/board-paz00.c
> @@ -23,9 +23,7 @@
>  #include "board.h"
> 
>  static struct rfkill_gpio_platform_data wifi_rfkill_platform_data = {
> -	.name		= "wifi_rfkill",
> -	.reset_gpio	= 25, /* PD1 */
> -	.shutdown_gpio	= 85, /* PK5 */
> +	.name	= "wifi_rfkill",
>  	.type	= RFKILL_TYPE_WLAN,
>  };

