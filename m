Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34616 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbbEXUh6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 May 2015 16:37:58 -0400
Date: Sun, 24 May 2015 13:37:57 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Johnny Kim <johnny.kim@atmel.com>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	rachel.kim@atmel.com, dean.lee@atmel.com, chris.park@atmel.com,
	Nicolas.FERRE@atmel.com, tony.cho@atmel.com
Subject: Re: [PATCH v3 1/2] staging: wilc1000: Add SDIO/SPI 802.11 driver
Message-ID: <20150524203757.GA12556@kroah.com> (sfid-20150524_223801_757357_AEFC65B5)
References: <b442bf7ee73817953edb91ab0646d6371b6e71b3.1431320004.git.johnny.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b442bf7ee73817953edb91ab0646d6371b6e71b3.1431320004.git.johnny.kim@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 11, 2015 at 02:30:56PM +0900, Johnny Kim wrote:
> This driver is for the wilc1000 which is a single chip IEEE 802.11
> b/g/n device.
> The driver works together with cfg80211, which is the kernel side of
> configuration management for wireless devices because the wilc1000
> chipset is fullmac where the MLME is managed in hardware.
> 
> The driver worked from kernel version 2.6.38 and being now ported
> to several others since then.
> A TODO file is included as well in this commit.

There are some build warnings with this patch.  Expect an email from the
0-day bot about them.  I suggest sending me patches to fix those up as
soon as possible.

thanks,

greg k-h
