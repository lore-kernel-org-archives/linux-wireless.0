Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:54419 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753830AbYC0PYj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Mar 2008 11:24:39 -0400
Subject: Re: [PATCH] libertas: the compact flash driver is no longer
	experimental
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200803261326.55437.hs4233@mail.mn-solutions.de>
References: <200803261326.55437.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Thu, 27 Mar 2008 11:23:19 -0400
Message-Id: <1206631399.23336.45.camel@localhost.localdomain> (sfid-20080327_152443_879038_B9DA1CC7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-03-26 at 13:26 +0100, Holger Schurig wrote:
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Acked-by: Dan Williams <dcbw@redhat.com>

It works better than some other drivers already :)

> Index: wireless-testing/drivers/net/wireless/Kconfig
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/Kconfig	2008-03-26 12:25:36.000000000 +0100
> +++ wireless-testing/drivers/net/wireless/Kconfig	2008-03-26 12:25:44.000000000 +0100
> @@ -283,7 +283,7 @@ config LIBERTAS_USB
>  
>  config LIBERTAS_CS
>  	tristate "Marvell Libertas 8385 CompactFlash 802.11b/g cards"
> -	depends on LIBERTAS && PCMCIA && EXPERIMENTAL
> +	depends on LIBERTAS && PCMCIA
>  	select FW_LOADER
>  	---help---
>  	  A driver for Marvell Libertas 8385 CompactFlash devices.

