Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41481 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbbIQEq7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2015 00:46:59 -0400
Date: Wed, 16 Sep 2015 21:46:47 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chaehyun Lim <chaehyun.lim@gmail.com>
Cc: rachel.kim@atmel.com, devel@driverdev.osuosl.org,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com, tony.cho@atmel.com, leo.kim@atmel.com
Subject: Re: [PATCH 03/10] staging: wilc1000: remove INLINE macro
Message-ID: <20150917044647.GA10073@kroah.com> (sfid-20150917_064724_422516_9ED0CD1D)
References: <1442401895-7463-1-git-send-email-chaehyun.lim@gmail.com>
 <1442401895-7463-3-git-send-email-chaehyun.lim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1442401895-7463-3-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 16, 2015 at 08:11:28PM +0900, Chaehyun Lim wrote:
> This patch removes INLINE macro that is used anymore.
> 
> Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
> ---
>  drivers/staging/wilc1000/coreconfigurator.c | 1 -
>  drivers/staging/wilc1000/wilc_wlan.c        | 1 -
>  2 files changed, 2 deletions(-)

This doesn't apply to my tree anymore, can you refresh it and resend
this and the rest of this series?

thanks,

greg k-h
