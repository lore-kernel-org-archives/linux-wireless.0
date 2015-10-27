Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59969 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965271AbbJ0Tky (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2015 15:40:54 -0400
Date: Wed, 28 Oct 2015 04:40:51 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: Punit Vara <punitvara@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, johnny.kim@atmel.com
Subject: Re: [PATCH v2] Staging: wilc1000: Prefer eth_broadcast_addr over
 memset()
Message-ID: <20151027194051.GA1537@kroah.com> (sfid-20151027_204114_366339_1730E415)
References: <1445966499-6175-1-git-send-email-punitvara@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1445966499-6175-1-git-send-email-punitvara@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 27, 2015 at 10:51:39PM +0530, Punit Vara wrote:
> This patch is to the host_interface.c that fixes up following
> warning by checkpatch:
> 
> -prefer eth_broadcast_addr() over memset()
> 
> Signed-off-by: Punit Vara <punitvara@gmail.com>
> ---
>  drivers/staging/wilc1000/host_interface.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

What changed from v1?

Always put that information here below the --- line so that we know.

Please fix up and resend.

thanks,

greg k-h
