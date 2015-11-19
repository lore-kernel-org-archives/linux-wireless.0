Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33959 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbbKSGXz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2015 01:23:55 -0500
Date: Thu, 19 Nov 2015 09:23:44 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Glen Lee <glen.lee@atmel.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	austin.shin@atmel.com, linux-wireless@vger.kernel.org,
	Nicolas.FERRE@atmel.com, adel.noureldin@atmel.com,
	tony.cho@atmel.com, leo.kim@atmel.com, adham.abozaeid@atmel.com
Subject: Re: [PATCH 3/4] staging: wilc1000: rename index to
 tcp_pending_ack_idx
Message-ID: <20151119062343.GR18797@mwanda> (sfid-20151119_072358_502045_5B57FAA0)
References: <1447898761-6938-1-git-send-email-glen.lee@atmel.com>
 <1447898761-6938-3-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1447898761-6938-3-git-send-email-glen.lee@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 19, 2015 at 11:06:00AM +0900, Glen Lee wrote:
> This patch renames "index" of struct txq_entry_t to tcp_pending_ack_idx since
> this name could be confused index of txq_entry_t. It is index of tcp pending
> ack.
> 
> It fixes 8e55639d066f4ef402ba88fca08ed1be70e1c4da
> 

It is just a cleanup patch and not a bugfix patch so "fix" is the wrong
word here.  But the correct format for fixes tags is:

Fixes: 123456789012 ('Title of patch')

regards,
dan carpenter

