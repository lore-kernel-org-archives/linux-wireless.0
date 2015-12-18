Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54393 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbbLSAlR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Dec 2015 19:41:17 -0500
Date: Fri, 18 Dec 2015 14:32:41 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Glen Lee <glen.lee@atmel.com>
Cc: devel@driverdev.osuosl.org, austin.shin@atmel.com,
	linux-wireless@vger.kernel.org, Nicolas.FERRE@atmel.com,
	adel.noureldin@atmel.com, tony.cho@atmel.com, leo.kim@atmel.com,
	adham.abozaeid@atmel.com
Subject: Re: [PATCH] staging: wilc1000: fix bug in sdio/spi
Message-ID: <20151218223241.GB9349@kroah.com> (sfid-20151219_014119_986928_D53CCD82)
References: <1447295726-24486-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1447295726-24486-1-git-send-email-glen.lee@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 12, 2015 at 11:35:26AM +0900, Glen Lee wrote:
> sdio_init and wilc_spi_init always return error, so it fails everytime.
> Fix this by removing else statement.
> 
> This fixes c1af9db78950a778ec18343c5c5a6d4cfbf58a61,
> bacd388547f55eb415ce266c8723cc6f1281a25d

Please fix up how these git commit ids are referenced here and resend.

thanks,

greg k-h
