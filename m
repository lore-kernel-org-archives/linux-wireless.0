Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:48080 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755069AbZFYUXP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Jun 2009 16:23:15 -0400
Subject: Re: [PATCH 11/19] drivers/net/wireless: Use PCI_VDEVICE
From: reinette chatre <reinette.chatre@intel.com>
To: Joe Perches <joe@perches.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	James Ketrenos <jketreno@linux.intel.com>,
	"Zhu, Yi" <yi.zhu@intel.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"ipw2100-devel@lists.sourceforge.net"
	<ipw2100-devel@lists.sourceforge.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
In-Reply-To: <10b896c1a1e1f65a4a342ee5aa3452ab8cb43dfb.1245906152.git.joe@perches.com>
References: <cover.1245906151.git.joe@perches.com>
	 <10b896c1a1e1f65a4a342ee5aa3452ab8cb43dfb.1245906152.git.joe@perches.com>
Content-Type: text/plain
Date: Thu, 25 Jun 2009 13:30:34 -0700
Message-Id: <1245961834.17896.91.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-06-24 at 22:13 -0700, Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/net/wireless/ipw2x00/ipw2200.c        |   10 +++++-----
>  drivers/net/wireless/prism54/islpci_hotplug.c |    4 +---
>  2 files changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
> index 44c29b3..d726b3c 100644
> --- a/drivers/net/wireless/ipw2x00/ipw2200.c
> +++ b/drivers/net/wireless/ipw2x00/ipw2200.c
> @@ -11436,11 +11436,11 @@ static struct pci_device_id card_ids[] = {
>  	{PCI_VENDOR_ID_INTEL, 0x1043, 0x8086, 0x2754, 0, 0, 0},
>  	{PCI_VENDOR_ID_INTEL, 0x1043, 0x8086, 0x2761, 0, 0, 0},
>  	{PCI_VENDOR_ID_INTEL, 0x1043, 0x8086, 0x2762, 0, 0, 0},
> -	{PCI_VENDOR_ID_INTEL, 0x104f, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
> -	{PCI_VENDOR_ID_INTEL, 0x4220, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},	/* BG */
> -	{PCI_VENDOR_ID_INTEL, 0x4221, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},	/* BG */
> -	{PCI_VENDOR_ID_INTEL, 0x4223, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},	/* ABG */
> -	{PCI_VENDOR_ID_INTEL, 0x4224, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},	/* ABG */
> +	{PCI_VDEVICE(INTEL, 0x104f), 0},
> +	{PCI_VDEVICE(INTEL, 0x4220), 0},	/* BG */
> +	{PCI_VDEVICE(INTEL, 0x4221), 0},	/* BG */
> +	{PCI_VDEVICE(INTEL, 0x4223), 0},	/* ABG */
> +	{PCI_VDEVICE(INTEL, 0x4224), 0},	/* ABG */
>  
>  	/* required last entry */
>  	{0,}

ack for the ipw2200 parts

Thank you

Reinette



