Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60247 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbZKGOAH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2009 09:00:07 -0500
Date: Sat, 7 Nov 2009 08:46:27 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: David Dreggors <ddreggors@cfl.rr.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] This adds support for the wifi led on the Compaq
	CQ60-206US.
Message-ID: <20091107134626.GC25893@tuxdriver.com>
References: <1257582989.23806.85.camel@mobile-tek.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1257582989.23806.85.camel@mobile-tek.home>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Need a Signed-of-by...

On Sat, Nov 07, 2009 at 03:36:29AM -0500, David Dreggors wrote:
> ---
>          drivers/net/wireless/ath/ath5k/led.c |    2 ++
>          1 files changed, 2 insertions(+), 0 deletions(-)
>         
>         diff --git a/drivers/net/wireless/ath/ath5k/led.c
>         b/drivers/net/wireless/ath/ath5k/led.c
>         index 7ce98bd..ce6ce0a 100644
>         --- a/drivers/net/wireless/ath/ath5k/led.c
>         +++ b/drivers/net/wireless/ath/ath5k/led.c
>         @@ -57,6 +57,8 @@ static const struct pci_device_id
>         ath5k_led_devices[] = {
>                 { PCI_VDEVICE(ATHEROS, PCI_DEVICE_ID_ATHEROS_AR5211),
>         ATH_LED(0, 0) },
>                 /* HP Compaq nc6xx, nc4000, nx6000 */
>                 { ATH_SDEVICE(PCI_VENDOR_ID_COMPAQ, PCI_ANY_ID),
>         ATH_LED(1, 1) },
>         +       /* HP Compaq CQ60-206US */
>         +       { ATH_SDEVICE(PCI_VENDOR_ID_HP, 0x137a), ATH_LED(3,
>         1) },
>                 /* Acer Aspire One A150 (maximlevitsky@gmail.com) */
>                 { ATH_SDEVICE(PCI_VENDOR_ID_FOXCONN, 0xe008), ATH_LED(3,
>         0) },
>                 /* Acer Aspire One AO531h AO751h
>         (keng-yu.lin@canonical.com) */
>         -- 
>         1.6.4.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
