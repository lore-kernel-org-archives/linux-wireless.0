Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:49082 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974Ab3BEVfv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2013 16:35:51 -0500
Received: by mail-pa0-f43.google.com with SMTP id bh2so384123pad.30
        for <linux-wireless@vger.kernel.org>; Tue, 05 Feb 2013 13:35:51 -0800 (PST)
Date: Tue, 5 Feb 2013 13:07:46 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] staging: vt6656: Fix sparse warning constant
 0xffffffff00000000U is so big it is unsigned long
Message-ID: <20130205210746.GA1589@kroah.com> (sfid-20130205_223559_766449_100DD817)
References: <1360097107.2856.3.camel@canaries64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1360097107.2856.3.camel@canaries64>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 05, 2013 at 08:45:07PM +0000, Malcolm Priestley wrote:
> 
> long long is needed for u64.
> 
> Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
> ---
>  drivers/staging/vt6656/card.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

You forgot to add a "Reported-by:" line to this patch, please do so and
resend.

thanks,

greg k-h
