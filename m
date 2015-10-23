Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25082 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbbJWHxI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2015 03:53:08 -0400
Date: Fri, 23 Oct 2015 10:52:53 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Tony Cho <tony.cho@atmel.com>
Cc: Glen Lee <glen.lee@atmel.com>, gregkh@linuxfoundation.org,
	devel@driverdev.osuosl.org, austin.shin@atmel.com,
	linux-wireless@vger.kernel.org, Nicolas.FERRE@atmel.com,
	adel.noureldin@atmel.com, leo.kim@atmel.com,
	adham.abozaeid@atmel.com
Subject: Re: [PATCH 05/28] staging: wilc1000: wilc_handle_isr: add argument
 wilc to wilc_handle_isr
Message-ID: <20151023075253.GA7289@mwanda> (sfid-20151023_095313_152594_DF44F071)
References: <1445578124-31486-1-git-send-email-glen.lee@atmel.com>
 <1445578124-31486-5-git-send-email-glen.lee@atmel.com>
 <20151023065703.GV7340@mwanda>
 <5629E367.1000006@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5629E367.1000006@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 23, 2015 at 04:36:07PM +0900, Tony Cho wrote:
> In addition, the function parameter names will be wilc
> for the variable of struct wilc.
> 
> The "wl" is local variable naming as well.

So if it is a parameter it is wilc but if it is a local variable then it
is wl?  That seems like an arbitrary meaningless distinction.  It just
makes searching harder and complicates things for no reason.

regards,
dan carpenter

