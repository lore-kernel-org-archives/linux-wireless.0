Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43278 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754004Ab3H0XzX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Aug 2013 19:55:23 -0400
Date: Tue, 27 Aug 2013 16:57:42 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] staging: vt6656: device.h Replace typedef struct _RCB
Message-ID: <20130827235742.GA31061@kroah.com> (sfid-20130828_015526_564707_B30CF506)
References: <1377603883.3320.93.camel@canaries32-MCP7A>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1377603883.3320.93.camel@canaries32-MCP7A>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 27, 2013 at 12:44:43PM +0100, Malcolm Priestley wrote:
> Replace with struct vnt_rcb
> 
> Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
> ---
>  drivers/staging/vt6656/device.h   | 20 +++++++++-----------
>  drivers/staging/vt6656/dpc.c      | 10 +++++-----
>  drivers/staging/vt6656/dpc.h      |  4 ++--
>  drivers/staging/vt6656/main_usb.c | 14 ++++++++------
>  drivers/staging/vt6656/usbpipe.c  |  4 ++--
>  drivers/staging/vt6656/usbpipe.h  |  2 +-
>  6 files changed, 27 insertions(+), 27 deletions(-)

This patch only applies with fuzz, which means we are starting to get
out of sync.  Can you refresh this one against my staging-next tree,
which I've applied all of your other patches to, and resend it?

thanks,

greg k-h
