Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45306 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932609AbbKDUyD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2015 15:54:03 -0500
Date: Wed, 4 Nov 2015 12:54:02 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Chaehyun Lim <chaehyun.lim@gmail.com>
Cc: devel@driverdev.osuosl.org, chris.park@atmel.com,
	austin.shin@atmel.com, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com, tony.cho@atmel.com, leo.kim@atmel.com
Subject: Re: [PATCH V2 01/12] staging: wilc1000: fix return type of
 host_int_del_beacon
Message-ID: <20151104205402.GA3656@kroah.com> (sfid-20151104_215408_539867_6BACE7B7)
References: <1446160668-10747-1-git-send-email-chaehyun.lim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1446160668-10747-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 30, 2015 at 08:17:37AM +0900, Chaehyun Lim wrote:
> This patch changes return type of host_int_del_beacon from s32 to int.
> The result variable gets return value from wilc_mq_send that has return
> type of int. It should be changed return type of this function as well
> as data type of result variable.
> 
> Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
> ---
> V2: resend because 11/12 patch is changed.

Due to changes sent before your series, this series does not apply.
Please refresh and resend.

thanks,

greg k-h
