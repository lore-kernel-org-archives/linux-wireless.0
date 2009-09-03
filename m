Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36783 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932244AbZICUyq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Sep 2009 16:54:46 -0400
Date: Thu, 3 Sep 2009 13:50:57 -0700
From: Greg KH <gregkh@suse.de>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: greg@kroah.com, linux-wireless@vger.kernel.org
Subject: Re: patch staging-remove-at76_usb-wireless-driver.patch added to
 gregkh-2.6 tree
Message-ID: <20090903205057.GA26980@suse.de>
References: <12520044192286@kroah.org>
 <87tyzj93u0.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87tyzj93u0.fsf@litku.valot.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 03, 2009 at 11:21:43PM +0300, Kalle Valo wrote:
> <gregkh@suse.de> writes:
> 
> > From: Greg Kroah-Hartman <gregkh@suse.de>
> > Subject: Staging: remove at76_usb wireless driver.
> >
> > There is already an in-kernel driver for this hardware (since 2.6.30),
> > at76c50x-usb, and it supports all of the same devices.  So this driver
> > can now be deleted.
> >
> > Cc: Kalle Valo <kalle.valo@iki.fi> 
> > Cc: linux-wireless <linux-wireless@vger.kernel.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> Thanks.
> 
> Acked-by: Kalle Valo <kalle.valo@iki.fi>

Thanks, I've added this to the patch.

greg k-h
