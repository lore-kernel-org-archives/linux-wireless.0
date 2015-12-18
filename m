Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54878 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932215AbbLSAo3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Dec 2015 19:44:29 -0500
Date: Fri, 18 Dec 2015 14:44:45 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Glen Lee <glen.lee@atmel.com>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	tony.cho@atmel.com, leo.kim@atmel.com, austin.shin@atmel.com,
	adel.noureldin@atmel.com, adham.abozaeid@atmel.com,
	Nicolas.FERRE@atmel.com
Subject: Re: [PATCH 01/12] staging: wilc1000: pass vif to hostIFthread
Message-ID: <20151218224445.GA9147@kroah.com> (sfid-20151219_014527_557198_BC55D524)
References: <1450072023-13013-1-git-send-email-glen.lee@atmel.com>
 <1450072023-13013-2-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1450072023-13013-2-git-send-email-glen.lee@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 14, 2015 at 02:46:52PM +0900, Glen Lee wrote:
> We will pass vif, which is currently being used as net_device, instead of
> hif_dev. This is the first step to use index of vif to pass to the driver.
> Add new argument vif to all the functions that send message to hostIFthread and
> set vif to msg.vif. As a result, hostIfthread will get vif.
> In later patch, we will remove drv of host_if_msg and use vif instead of it.
> 
> Signed-off-by: Glen Lee <glen.lee@atmel.com>

Series did not apply :(

Please rebase all of your pending patches against my staging-testing
branch now and resend what I did not apply.

thanks,

greg k-h
