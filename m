Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54872 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932212AbbLSAo2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Dec 2015 19:44:28 -0500
Date: Fri, 18 Dec 2015 14:43:11 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Glen Lee <glen.lee@atmel.com>
Cc: devel@driverdev.osuosl.org, austin.shin@atmel.com,
	linux-wireless@vger.kernel.org, Nicolas.FERRE@atmel.com,
	adel.noureldin@atmel.com, tony.cho@atmel.com, leo.kim@atmel.com,
	adham.abozaeid@atmel.com
Subject: Re: [PATCH 2/5] staging: wilc1000: remove unneeded function
Message-ID: <20151218224311.GA8961@kroah.com> (sfid-20151219_014434_592650_024E98C8)
References: <1448514243-14181-1-git-send-email-glen.lee@atmel.com>
 <1448514243-14181-2-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1448514243-14181-2-git-send-email-glen.lee@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 26, 2015 at 02:04:00PM +0900, Glen Lee wrote:
> wilc_spi_init in linux_wlan_spi.c is unneeded. It just return true. Rename
> _wilc_spi_init in wlan_spi.c to wilc_spi_init.
> 
> Signed-off-by: Glen Lee <glen.lee@atmel.com>

Series did not apply :(
