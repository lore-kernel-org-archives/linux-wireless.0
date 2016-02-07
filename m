Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54094 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754886AbcBGVvN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Feb 2016 16:51:13 -0500
Date: Sun, 7 Feb 2016 13:51:13 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Chaehyun Lim <chaehyun.lim@gmail.com>
Cc: devel@driverdev.osuosl.org, chris.park@atmel.com,
	austin.shin@atmel.com, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com, tony.cho@atmel.com, leo.kim@atmel.com
Subject: Re: [PATCH 5/8] staging: wilc1000: fix return type of
 wilc_send_config_pkt
Message-ID: <20160207215113.GA19185@kroah.com> (sfid-20160207_225156_060817_E0F40C32)
References: <1454636118-9943-1-git-send-email-chaehyun.lim@gmail.com>
 <1454636118-9943-5-git-send-email-chaehyun.lim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1454636118-9943-5-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 05, 2016 at 10:35:15AM +0900, Chaehyun Lim wrote:
> wilc_send_config_pkt is returned 0 or -ETIMEDOUT according to return
> value of wilc_wlan_cfg_get or wilc_wlan_cfg_set.
> It is better to use int type to represent linux standard error code.
> 
> Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
> ---
>  drivers/staging/wilc1000/coreconfigurator.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

This, and the remaining patches in the series, don't apply anymore due
to patches I took right before your series.  Can you refresh these and
resend?

thanks,

greg k-h
