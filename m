Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41052 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756306AbbI3KUi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2015 06:20:38 -0400
Date: Wed, 30 Sep 2015 12:20:34 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Chaehyun Lim <chaehyun.lim@gmail.com>
Cc: rachel.kim@atmel.com, devel@driverdev.osuosl.org,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com, tony.cho@atmel.com, leo.kim@atmel.com
Subject: Re: [PATCH] staging: wilc1000: fix build error for
 openrisc-allmodconfig
Message-ID: <20150930102034.GA6737@kroah.com> (sfid-20150930_122043_985913_80871CF9)
References: <1443603134-11582-1-git-send-email-chaehyun.lim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1443603134-11582-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 30, 2015 at 05:52:14PM +0900, Chaehyun Lim wrote:
> The kbuild test robot reports the following build error for
> openrisc-allmodconfig.
> 
> >> drivers/staging/wilc1000/wilc_sdio.c:584:2: error: implicit
> >> declaration of function 'memset'
> 
> The error occurs due to missing a standard header file as
> <linux/string.h> so that three .c files are included it.
> 
> Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>

You forgot to add a Reported-by: line giving credit to kbuild, I've done
that by hand.

thanks,

greg k-h
