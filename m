Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f222.google.com ([209.85.219.222]:63146 "EHLO
	mail-ew0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755168Ab0C2Ka1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 06:30:27 -0400
Received: by mail-ew0-f222.google.com with SMTP id 22so1763369ewy.37
        for <linux-wireless@vger.kernel.org>; Mon, 29 Mar 2010 03:30:27 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH 3/3] wireless: rt2x00: rt2800pci: new id
Date: Mon, 29 Mar 2010 11:30:25 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	linville@tuxdriver.com
References: <1269791285-8678-1-git-send-email-xose.vazquez@gmail.com>
In-Reply-To: <1269791285-8678-1-git-send-email-xose.vazquez@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <201003291230.25549.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 28 March 2010, Xose Vazquez Perez wrote:
> Taken from latest ralink linux driver, it's a RT3593 PCI/PCIe.
> 
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

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


