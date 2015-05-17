Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58846 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbbEQTrd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 May 2015 15:47:33 -0400
Date: Sun, 17 May 2015 12:47:32 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Johnny Kim <johnny.kim@atmel.com>, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, chris.park@atmel.com,
	rachel.kim@atmel.com, dean.lee@atmel.com, tony.cho@atmel.com,
	Patrice VILCHEZ <patrice.vilchez@atmel.com>
Subject: Re: [PATCH v3 1/2] staging: wilc1000: Add SDIO/SPI 802.11 driver
Message-ID: <20150517194732.GA26140@kroah.com> (sfid-20150517_214736_626513_24275925)
References: <b442bf7ee73817953edb91ab0646d6371b6e71b3.1431320004.git.johnny.kim@atmel.com>
 <5558E3B8.3040008@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <5558E3B8.3040008@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 17, 2015 at 08:53:44PM +0200, Nicolas Ferre wrote:
> Le 11/05/2015 07:30, Johnny Kim a écrit :
> > This driver is for the wilc1000 which is a single chip IEEE 802.11
> > b/g/n device.
> > The driver works together with cfg80211, which is the kernel side of
> > configuration management for wireless devices because the wilc1000
> > chipset is fullmac where the MLME is managed in hardware.
> > 
> > The driver worked from kernel version 2.6.38 and being now ported
> > to several others since then.
> > A TODO file is included as well in this commit.
> > 
> > Signed-off-by: Johnny Kim <johnny.kim@atmel.com>
> > Signed-off-by: Rachel Kim <rachel.kim@atmel.com>
> > Signed-off-by: Dean Lee <dean.lee@atmel.com>
> > Signed-off-by: Chris Park <chris.park@atmel.com>
> > Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> > ---
> > Changes in v3:
> > - fix the permissions.
> > - fix the folder tree.
> > - forget to add the mailing-list during the previous sending.
> 
> Hi Greg,
> 
> Do you have any comment on this v3 series (aka ping ;-)).

Sorry, been swamped last week, will catch up on staging patches this
week and will let you know then.

thanks,

greg k-h
