Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:32829 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751494AbYLXMKC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Dec 2008 07:10:02 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] ssb/b43: add new N PHY device
Date: Wed, 24 Dec 2008 13:09:26 +0100
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1230119049.4566.1.camel@johannes>
In-Reply-To: <1230119049.4566.1.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200812241309.27072.mb@bu3sch.de> (sfid-20081224_131011_366428_F14D43E9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 24 December 2008 12:44:09 Johannes Berg wrote:
> This is used on my macbook. N PHY, obviously nothing works
> yet, but we can detect the chip with this patch.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

ACK. Please queue for 2.6.29

> ---
>  drivers/net/wireless/b43/main.c |    1 +
>  drivers/ssb/b43_pci_bridge.c    |    1 +
>  2 files changed, 2 insertions(+)
> 
> --- wireless-testing.orig/drivers/ssb/b43_pci_bridge.c	2008-12-24 12:33:23.000000000 +0100
> +++ wireless-testing/drivers/ssb/b43_pci_bridge.c	2008-12-24 12:34:41.000000000 +0100
> @@ -29,6 +29,7 @@ static const struct pci_device_id b43_pc
>  	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4325) },
>  	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4328) },
>  	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4329) },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x432b) },
>  	{ 0, },
>  };
>  MODULE_DEVICE_TABLE(pci, b43_pci_bridge_tbl);
> --- wireless-testing.orig/drivers/net/wireless/b43/main.c	2008-12-24 12:43:09.000000000 +0100
> +++ wireless-testing/drivers/net/wireless/b43/main.c	2008-12-24 12:43:18.000000000 +0100
> @@ -97,6 +97,7 @@ static const struct ssb_device_id b43_ss
>  	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 10),
>  	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 11),
>  	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 13),
> +	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 16),
>  	SSB_DEVTABLE_END
>  };
>  
> 
> 
> 
> 



-- 
Greetings, Michael.
