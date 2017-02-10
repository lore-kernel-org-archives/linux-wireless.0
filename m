Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57096 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752144AbdBJOCq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Feb 2017 09:02:46 -0500
Date: Fri, 10 Feb 2017 15:02:45 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Franck Demathieu <fdemathieu@gmail.com>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH] staging: wilc1000: remove unnecessary local array
Message-ID: <20170210140245.GC28966@kroah.com> (sfid-20170210_150257_350407_6AB4DC73)
References: <20170209134839.12138-1-fdemathieu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170209134839.12138-1-fdemathieu@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 09, 2017 at 02:48:39PM +0100, Franck Demathieu wrote:
> It fixes the following warning reported by sparse:
> 
>   drivers/staging/wilc1000/linux_wlan.c:67:33: warning: too long initializer-string for array of char(no space for nul char)
> 
> Signed-off-by: Franck Demathieu <fdemathieu@gmail.com>
> ---
>  drivers/staging/wilc1000/linux_wlan.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)


Always use scripts/get_maintainer.pl to determine who to send patches
to.

Please fix up and try again.

thanks,

greg k-h
