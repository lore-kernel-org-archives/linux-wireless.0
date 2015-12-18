Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54703 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312AbbLSAoX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Dec 2015 19:44:23 -0500
Date: Fri, 18 Dec 2015 14:38:42 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Glen Lee <glen.lee@atmel.com>
Cc: devel@driverdev.osuosl.org, austin.shin@atmel.com,
	linux-wireless@vger.kernel.org, Nicolas.FERRE@atmel.com,
	adel.noureldin@atmel.com, tony.cho@atmel.com, leo.kim@atmel.com,
	adham.abozaeid@atmel.com
Subject: Re: [PATCH 01/10] staging: wilc1000: sdio/spi: use device print api
 instead of custom one
Message-ID: <20151218223842.GA1390@kroah.com> (sfid-20151219_014426_098983_E0E1992B)
References: <1448272088-13973-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1448272088-13973-1-git-send-email-glen.lee@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 23, 2015 at 06:47:59PM +0900, Glen Lee wrote:
> This patch use device print api instead of driver defined print. Remove
> varialbe dPrint as well. String "[wilc sdio]" and "[wilc spi]" are also removed
> from all the print statment if exist because it shows which device the message
> is related to.
> 
> Signed-off-by: Glen Lee <glen.lee@atmel.com>

This series didn't apply :(
