Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:55893 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753167AbYJBXVI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Oct 2008 19:21:08 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 02 Oct 2008 16:21:08 -0700
Date: Thu, 2 Oct 2008 09:20:54 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Greg KH <greg@kroah.com>
CC: "proski@gnu.org" <proski@gnu.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: at76_usb driver status
Message-ID: <20081002162054.GI5960@tesla> (sfid-20081003_012114_342344_F2FC7E50)
References: <20081002210742.GA27221@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20081002210742.GA27221@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 02, 2008 at 02:07:42PM -0700, Greg KH wrote:
> Hi,
> 
> In my quest to suck drivers into drivers/staging/ I noticed that the
> at76_usb driver is being shipped by both Fedora and Ubuntu in their
> kernels.
> 
> So I was wondering what the status of this driver is, and if I
> could/should add it to drivers/staging/?  If it's about to go into
> 2.6.28 then I'll hold off, but it would be nice to know what the status
> is.
> 
> Also, it looks like it is being developed in a git tree, where is that
> tree?
> 
> And, did you merge the USB DFU code into the driver itself?  Having that
> kind of functionality in the USB core is fine with me if you want me to
> add that portion there, no reason it needs to be burried in individual
> drivers.

Also, it may help to keep this status here, once we find out what it is:

http://wireless.kernel.org/en/users/Drivers/at76_usb

  Luis
