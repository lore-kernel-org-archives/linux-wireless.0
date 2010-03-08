Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:30384 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755328Ab0CHQDN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Mar 2010 11:03:13 -0500
Date: Mon, 8 Mar 2010 19:02:50 +0300
From: Dan Carpenter <error27@gmail.com>
To: Jason Dreisbach <jtdreisb@gmail.com>
Cc: jt@hp1.hp.com, gregkh@suse.de--to, jpirko@redhat.com,
	linville@tuxdriver.com, jtdreisb@gmail.com--cc,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] staging: wavelan: fix coding style of first 1000 lines
	in wavelan.c
Message-ID: <20100308160250.GC19256@bicker>
References: <1268043630-5893-1-git-send-email-jtdreisb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1268043630-5893-1-git-send-email-jtdreisb@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 08, 2010 at 02:20:30AM -0800, Jason Dreisbach wrote:
> From: Jason <jtdreisb@gmail.com>

>  		/* Check mc_config command */
>  		if ((status & AC_SFLD_OK) != AC_SFLD_OK)
>  			printk(KERN_INFO
> -			       "%s: wv_config_complete(): set_multicast_address failed; status = 0x%x\n",
> +			       "%s: wv_config_complete(): \
> +			       set_multicast_address failed; status = 0x%x\n",
>  			       dev->name, status);
>  

This patch introduces several bugs like the one above.

I know it's depressing to send a patch and have criticized, but besides
this bug which affects users there are some other whitespace changes 
in this patch which are not correct.

If you want to resend this once you fix the errors, feel free, it does 
fix quite a few white space issues.  

But really it's always better to focus on fixing actual bugs.  I know that
Greg says fixing white space is a great way to learn the patch submission
process, but anyone can do that.  The most important thing is to learn how
to fix bugs.  We can deal with malformed patches so long as they fix 
something.

regards,
dan carpenter
