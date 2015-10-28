Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:34301 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715AbbJ1Fec (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 01:34:32 -0400
Received: by padhk11 with SMTP id hk11so245790956pad.1
        for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2015 22:34:31 -0700 (PDT)
Date: Wed, 28 Oct 2015 11:03:59 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Glen Lee <glen.lee@atmel.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	austin.shin@atmel.com, linux-wireless@vger.kernel.org,
	Nicolas.FERRE@atmel.com, adel.noureldin@atmel.com,
	tony.cho@atmel.com, leo.kim@atmel.com, adham.abozaeid@atmel.com
Subject: Re: [PATCH] staging: wilc1000: fix build error on SPI
Message-ID: <20151028053359.GB10698@sudip-pc> (sfid-20151028_063435_142921_01BD3CD2)
References: <1445937614-12127-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1445937614-12127-1-git-send-email-glen.lee@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 27, 2015 at 06:20:14PM +0900, Glen Lee wrote:
> wilc_netdev_init function has parameters to pass but no argument is passed
> when bus type SPI is selected. Which causes build error.
> This patch passes argument &wilc to the function wilc_netdev_init.
> 
> Signed-off-by: Glen Lee <glen.lee@atmel.com>
Fixes: 12ba5416dc77 ("staging: wilc1000: assign pointer of g_linux_wlan to sdio device data")

regards
sudip
