Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:53233 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753874AbYJBVKr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Oct 2008 17:10:47 -0400
Date: Thu, 2 Oct 2008 14:07:42 -0700
From: Greg KH <greg@kroah.com>
To: proski@gnu.org, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: at76_usb driver status
Message-ID: <20081002210742.GA27221@kroah.com> (sfid-20081002_231051_496464_2C911511)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

In my quest to suck drivers into drivers/staging/ I noticed that the
at76_usb driver is being shipped by both Fedora and Ubuntu in their
kernels.

So I was wondering what the status of this driver is, and if I
could/should add it to drivers/staging/?  If it's about to go into
2.6.28 then I'll hold off, but it would be nice to know what the status
is.

Also, it looks like it is being developed in a git tree, where is that
tree?

And, did you merge the USB DFU code into the driver itself?  Having that
kind of functionality in the USB core is fine with me if you want me to
add that portion there, no reason it needs to be burried in individual
drivers.

thanks,

greg k-h
