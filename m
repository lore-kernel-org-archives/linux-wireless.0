Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:2245 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753928Ab2EJC5o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 May 2012 22:57:44 -0400
Message-ID: <4FAB2EA6.80702@gmail.com> (sfid-20120510_045748_145484_2CBE374D)
Date: Thu, 10 May 2012 04:57:42 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Zero Lin <zero.lin.0203@gmail.com>
CC: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	"Zero.Lin" <Zero.Lin@mediatek.com>
Subject: Re: [PATCH] rt2x00:Add RT539b chipset support
References: <1336615591-2017-1-git-send-email-zero.lin.0203@gmail.com>
In-Reply-To: <1336615591-2017-1-git-send-email-zero.lin.0203@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/10/12 04:06, Zero Lin wrote:
> From: "Zero.Lin" <Zero.Lin@mediatek.com>
> 
> Signed-off-by: Zero.Lin <Zero.Lin@mediatek.com>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800pci.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
> index 931331d..cad25bf 100644
> --- a/drivers/net/wireless/rt2x00/rt2800pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.c
> @@ -1192,6 +1192,7 @@ static DEFINE_PCI_DEVICE_TABLE(rt2800pci_device_table) = {
>  	{ PCI_DEVICE(0x1814, 0x5390) },
>  	{ PCI_DEVICE(0x1814, 0x5392) },
>  	{ PCI_DEVICE(0x1814, 0x539a) },
> +	{ PCI_DEVICE(0x1814, 0x539b) },
>  	{ PCI_DEVICE(0x1814, 0x539f) },
>  #endif
>  	{ 0, }


-- 
---
Gertjan
