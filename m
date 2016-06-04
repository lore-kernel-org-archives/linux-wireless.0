Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:34717 "EHLO
	mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbcFDVX3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jun 2016 17:23:29 -0400
Subject: Re: [PATCH v3 1/2] b43: Remove unused phy_a code
To: Guenter Roeck <linux@roeck-us.net>,
	Kalle Valo <kvalo@codeaurora.org>
References: <1465052053-26740-1-git-send-email-linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	b43-dev@lists.infradead.org, netdev@vger.kernel.org, m@bues.ch
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <575346CF.9040003@lwfinger.net> (sfid-20160604_232353_012199_FF0FBC8A)
Date: Sat, 4 Jun 2016 16:23:27 -0500
MIME-Version: 1.0
In-Reply-To: <1465052053-26740-1-git-send-email-linux@roeck-us.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/04/2016 09:54 AM, Guenter Roeck wrote:
> gcc-6 reports the following error with -Werror=unused-const-variable.
>
> drivers/net/wireless/broadcom/b43/phy_a.c:576:40: error:
> 	'b43_phyops_a' defined but not used
>
> Per Michael Büsch: "All a-phy code is usused", so remove it all,
> and move the remaining Type-G initialization code into phy_g.c.
>
> Reported-by: Fengguang Wu <fengguang.wu@intel.com> [0-day test robot]
> Cc: Michael Büsch <m@bues.ch>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
> v3: Do not rename b43_phy_inita()
> v2: Remove phy_a.c; move left-over code into phy_g.c
>      Remove now unused data structure

These two patches have been tested on a BCM4318.

Larry

