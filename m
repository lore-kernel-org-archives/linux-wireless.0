Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752036AbeFAQTl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Jun 2018 12:19:41 -0400
Date: Fri, 1 Jun 2018 18:19:18 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-usb@vger.kernel.org,
        =?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
        Michael Thalmeier <michael.thalmeier@hale.at>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH resend 0/2] NFC: pn533: Fix DMA related USB errors
Message-ID: <20180601161918.GA10471@kroah.com> (sfid-20180601_181948_507946_53649AA7)
References: <20180601132200.25973-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180601132200.25973-1-hdegoede@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 01, 2018 at 03:21:58PM +0200, Hans de Goede wrote:
> Hi All,
> 
> These 2 simple bug-fixes seem to have fallen through the cracks,
> hence this resend.
> 
> Greg (gkh) despite a ping to Samuel about a month ago I still have not
> had any response from the NFC people to these fixes. Since these are
> really fixes for USB urb mis-handling, perhaps you can take these
> upstream through the USB tree?

Can you respin these against my usb-next branch of usb.git?  I applied a
big pn533 fix to make it actually work again, which causes your patches
to not be able to be applied at all :(

If you do that, I'll be glad to take them.

thanks,

greg k-h
