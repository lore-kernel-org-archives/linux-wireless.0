Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:34353 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab1BRN5M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Feb 2011 08:57:12 -0500
Received: by qwd7 with SMTP id 7so361085qwd.19
        for <linux-wireless@vger.kernel.org>; Fri, 18 Feb 2011 05:57:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1298035629-12989-1-git-send-email-xose.vazquez@gmail.com>
References: <1298035629-12989-1-git-send-email-xose.vazquez@gmail.com>
Date: Fri, 18 Feb 2011 14:57:11 +0100
Message-ID: <AANLkTi=QC_LgkkLz6dyFDexBA53a9dbz=PP84sTquz0g@mail.gmail.com>
Subject: Re: [PATCH] wireless: rt2x00: rt2800pci.c: add two ids
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> taken two RT35XX EDIMAX from DPO_RT3562_3592_3062_LinuxSTA_V2.4.1.1_20101217
>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800pci.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
> index aa97971..7951cda 100644
> --- a/drivers/net/wireless/rt2x00/rt2800pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.c
> @@ -1065,6 +1065,8 @@ static DEFINE_PCI_DEVICE_TABLE(rt2800pci_device_table) = {
>        { PCI_DEVICE(0x1814, 0x3390), PCI_DEVICE_DATA(&rt2800pci_ops) },
>  #endif
>  #ifdef CONFIG_RT2800PCI_RT35XX
> +       { PCI_DEVICE(0x1432, 0x7711), PCI_DEVICE_DATA(&rt2800pci_ops) },
> +       { PCI_DEVICE(0x1432, 0x7722), PCI_DEVICE_DATA(&rt2800pci_ops) },
>        { PCI_DEVICE(0x1814, 0x3060), PCI_DEVICE_DATA(&rt2800pci_ops) },
>        { PCI_DEVICE(0x1814, 0x3062), PCI_DEVICE_DATA(&rt2800pci_ops) },
>        { PCI_DEVICE(0x1814, 0x3562), PCI_DEVICE_DATA(&rt2800pci_ops) },
> --
> 1.7.4
>
>
