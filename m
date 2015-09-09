Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40565 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbbIITwg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Sep 2015 15:52:36 -0400
Date: Wed, 9 Sep 2015 10:47:39 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tony Cho <tony.cho@atmel.com>
Cc: devel@driverdev.osuosl.org, rachel.kim@atmel.com,
	chris.park@atmel.com, austin.shin@atmel.com,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	Nicolas.FERRE@atmel.com, adel.noureldin@atmel.com,
	leo.kim@atmel.com, adham.abozaeid@atmel.com
Subject: Re: [PATCH 1/5] staging: wilc1000: define undefined operation mode
Message-ID: <20150909174739.GA30350@kroah.com> (sfid-20150909_215241_377494_A18ECB62)
References: <1441699683-31463-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1441699683-31463-1-git-send-email-tony.cho@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 08, 2015 at 05:07:59PM +0900, Tony Cho wrote:
> From: Johnny Kim <johnny.kim@atmel.com>
> 
> This patch adds new define, IDLE_MODE to change comparison statement which
> is wrong due to typecasting to null.
> 
> Signed-off-by: Johnny Kim <johnny.kim@atmel.com>
> Signed-off-by: Tony Cho <tony.cho@atmel.com>
> ---
>  drivers/staging/wilc1000/host_interface.c | 2 +-
>  drivers/staging/wilc1000/host_interface.h | 1 +
>  2 files changed, 2 insertions(+), 1 deletion(-)

With this series I don't see any more build warnings, can you send a
patch to now enable the driver (i.e. remove the BROKEN Kconfig
dependancy?)

thanks,

greg k-h
