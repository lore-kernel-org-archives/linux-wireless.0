Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:35990 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbZH0PL5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Aug 2009 11:11:57 -0400
Received: by ewy2 with SMTP id 2so1287272ewy.17
        for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2009 08:11:58 -0700 (PDT)
Message-ID: <4A96A239.9000406@lwfinger.net>
Date: Thu, 27 Aug 2009 10:11:53 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>
CC: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, Mark Huijgen <mark@huijgen.tk>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] b43: Enable LP-PHY support by default and remove Kconfig
 warning
References: <4A969572.7060807@gmail.com>
In-Reply-To: <4A969572.7060807@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gábor Stefanik wrote:
> The most common LP-PHY device, BCM4312, is now fully functional.
> So, no need to say "probably won't work for you" anymore.
> It's also not "for debuggers and developers only", as it is
> perfectly usable for end-users now (at least for BCM4312).
> 
> Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
> ---
> This replaces the "remove scary message" patch.
> 
> drivers/net/wireless/b43/Kconfig |    4 +---
> 1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/b43/Kconfig
> b/drivers/net/wireless/b43/Kconfig
> index 237b1aa..2af3b35 100644
> --- a/drivers/net/wireless/b43/Kconfig
> +++ b/drivers/net/wireless/b43/Kconfig
> -82,15 +82,13 @@ config B43_NPHY
===

My copy of this patch is missing the @@ here. Is that true for everyone?

Larry
