Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32815 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756057AbcDGOtj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2016 10:49:39 -0400
Date: Thu, 7 Apr 2016 07:49:33 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Shyam Saini <mayhs11saini@gmail.com>
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 525/525] Staging: Wilc1000: Fixed coding style
 ether_addr_copy
Message-ID: <20160407144933.GA11500@kroah.com> (sfid-20160407_164955_275409_89098927)
References: <1460021835-8370-1-git-send-email-mayhs11saini@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1460021835-8370-1-git-send-email-mayhs11saini@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 07, 2016 at 03:07:15PM +0530, Shyam Saini wrote:
> Fixed following warning detected by checkpatch.pl:
> warning: Prefer ether_addr_copy() over memcpy() if the Ethernet addressesare __aligned(2)
> 
> Signed-off-by: Shyam Saini <mayhs11saini@gmail.com>
> ---
>  drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 25 +++++++++++------------
>  1 file changed, 12 insertions(+), 13 deletions(-)

Where are the 524 other patches in this series?  I don't seem to see
them in my inbox anywhere, so I can't apply this last one either :(

thanks,

greg k-h
