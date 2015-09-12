Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57801 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588AbbILEfN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Sep 2015 00:35:13 -0400
Date: Fri, 11 Sep 2015 19:35:03 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tony Cho <tony.cho@atmel.com>
Cc: devel@driverdev.osuosl.org, rachel.kim@atmel.com,
	chris.park@atmel.com, austin.shin@atmel.com,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	Nicolas.FERRE@atmel.com, adel.noureldin@atmel.com,
	leo.kim@atmel.com, adham.abozaeid@atmel.com
Subject: Re: [PATCH v2 1/2] staging: wilc1000: remove unused enum
Message-ID: <20150912023503.GA32162@kroah.com> (sfid-20150912_063726_650331_1AB9E246)
References: <1441940660-5925-1-git-send-email-tony.cho@atmel.com>
 <1441940660-5925-2-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1441940660-5925-2-git-send-email-tony.cho@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 11, 2015 at 12:04:19PM +0900, Tony Cho wrote:
> From: Glen Lee <glen.lee@atmel.com>
> 
> This patch removes a unused enum tenuFrameClass.
> 
> Signed-off-by: Glen Lee <glen.lee@atmel.com>
> Signed-off-by: Tony Cho <tony.cho@atmel.com>
> ---
>  drivers/staging/wilc1000/coreconfigurator.c | 8 --------
>  1 file changed, 8 deletions(-)

I already applied this, why resend it?

greg k-h
