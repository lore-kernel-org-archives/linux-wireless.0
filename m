Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48579 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbaCQVsH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2014 17:48:07 -0400
Date: Mon, 17 Mar 2014 14:50:08 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] staging: vt6656: [BUG] Fix Warning BOGUS urb xfer, pipe
 3 != type 1
Message-ID: <20140317215008.GB22663@kroah.com> (sfid-20140317_224812_052495_B780661B)
References: <1394973251-3055-1-git-send-email-tvboxspy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1394973251-3055-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Mar 16, 2014 at 12:34:11PM +0000, Malcolm Priestley wrote:
> Stable kernels will need patches
> staging: vt6656: s_nsInterruptUsbIoCompleteRead remove usb_fill_bulk_urb
> staging: vt6656: PIPEnsInterruptRead use usb_fill_int_urb
> 
> and a backported version of this patch.

So can you send those backported patches to the stable list when this
patch hits Linus's tree?

thanks,

greg k-h
