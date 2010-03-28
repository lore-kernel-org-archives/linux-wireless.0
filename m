Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Cpsmtpm-eml106.kpnxchange.com ([195.121.3.10]:57499 "EHLO
	CPSMTPM-EML106.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754800Ab0C1Q4Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Mar 2010 12:56:16 -0400
Message-ID: <4BAF8A2E.2010306@gmail.com>
Date: Sun, 28 Mar 2010 18:56:14 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Xose Vazquez Perez <xose.vazquez@gmail.com>, linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	IvDoorn@gmail.com
Subject: Re: [PATCH 3/3] wireless: rt2x00: rt2800pci: new id
References: <1269791285-8678-1-git-send-email-xose.vazquez@gmail.com>
In-Reply-To: <1269791285-8678-1-git-send-email-xose.vazquez@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/28/10 17:48, Xose Vazquez Perez wrote:
> Taken from latest ralink linux driver, it's a RT3593 PCI/PCIe.
> 
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800pci.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
> index b1f5643..ce7e88e 100644
> --- a/drivers/net/wireless/rt2x00/rt2800pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.c
> @@ -1212,6 +1212,7 @@ static DEFINE_PCI_DEVICE_TABLE(rt2800pci_device_table) = {
>  	{ PCI_DEVICE(0x1814, 0x3062), PCI_DEVICE_DATA(&rt2800pci_ops) },
>  	{ PCI_DEVICE(0x1814, 0x3562), PCI_DEVICE_DATA(&rt2800pci_ops) },
>  	{ PCI_DEVICE(0x1814, 0x3592), PCI_DEVICE_DATA(&rt2800pci_ops) },
> +	{ PCI_DEVICE(0x1814, 0x3593), PCI_DEVICE_DATA(&rt2800pci_ops) },
>  #endif
>  	{ 0, }
>  };

