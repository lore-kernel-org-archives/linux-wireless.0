Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22783 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbbJWG5U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2015 02:57:20 -0400
Date: Fri, 23 Oct 2015 09:57:03 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Glen Lee <glen.lee@atmel.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	austin.shin@atmel.com, linux-wireless@vger.kernel.org,
	Nicolas.FERRE@atmel.com, adel.noureldin@atmel.com,
	tony.cho@atmel.com, leo.kim@atmel.com, adham.abozaeid@atmel.com
Subject: Re: [PATCH 05/28] staging: wilc1000: wilc_handle_isr: add argument
 wilc to wilc_handle_isr
Message-ID: <20151023065703.GV7340@mwanda> (sfid-20151023_085746_610879_3A9BE0BB)
References: <1445578124-31486-1-git-send-email-glen.lee@atmel.com>
 <1445578124-31486-5-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1445578124-31486-5-git-send-email-glen.lee@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 23, 2015 at 02:28:21PM +0900, Glen Lee wrote:
> This patch add new argument wilc to wilc_handle_isr and pass wilc to
> the function.

It's not important enough to redo the patch but why are we sometimes
using "wl" and sometimes "wilc"?

regards,
dan carpenter

