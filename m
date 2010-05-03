Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:64663 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754921Ab0ECU7U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 May 2010 16:59:20 -0400
Subject: Re: [PATCH 2/4] rt2x00: Enable RT30xx by default.
From: Pavel Roskin <proski@gnu.org>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
In-Reply-To: <1272919385-18004-3-git-send-email-gwingerde@gmail.com>
References: <1272919385-18004-1-git-send-email-gwingerde@gmail.com>
	 <1272919385-18004-3-git-send-email-gwingerde@gmail.com>
Content-Type: text/plain
Date: Mon, 03 May 2010 16:59:18 -0400
Message-Id: <1272920358.4907.3.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-05-03 at 22:43 +0200, Gertjan van Wingerde wrote:
> Now that RT30xx support is at the same level as RT28xx support we can enable
> these devices by default.
> 
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
> ---
>  drivers/net/wireless/rt2x00/Kconfig |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
> index 5239e08..eea1ef2 100644
> --- a/drivers/net/wireless/rt2x00/Kconfig
> +++ b/drivers/net/wireless/rt2x00/Kconfig
> @@ -87,7 +87,7 @@ if RT2800PCI
>  
>  config RT2800PCI_RT30XX
>  	bool "rt2800pci - Include support for rt30xx (PCI/PCIe/PCMCIA) devices"
> -	default n
> +	default y

I believe defaulting booleans to "y" is discouraged, especially for
drivers.  Most users don't have any particular hardware device.

-- 
Regards,
Pavel Roskin
