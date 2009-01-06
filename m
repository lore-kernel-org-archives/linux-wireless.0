Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41317 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbZAFUam (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2009 15:30:42 -0500
Date: Tue, 6 Jan 2009 15:27:40 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Pavel Roskin <proski@gnu.org>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Piter PUNK <piterpunk@unitednerds.org>,
	linux-wireless@vger.kernel.org
Subject: Re: rt2500usb vs rt73usb
Message-ID: <20090106202740.GE3544@tuxdriver.com> (sfid-20090106_213051_678808_174C313B)
References: <49571E29.8060204@unitednerds.org> <200812281034.07373.IvDoorn@gmail.com> <1230502494.25726.26.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1230502494.25726.26.camel@dv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Dec 28, 2008 at 05:14:54PM -0500, Pavel Roskin wrote:
> On Sun, 2008-12-28 at 10:34 +0100, Ivo van Doorn wrote:
> > On Sunday 28 December 2008, Piter PUNK wrote:
> 
> > > If the those 148f:2573 USB devices doesn't exists or
> > > if they exists and works fine with rt73usb, can we
> > > remove 148f:2573 from rt2500usb?
> > 
> > No we can't, you can blame manufacturers for shipping
> > USB sticks with different chipsets but the exact same USB ID.
> 
> Maybe there are some hints on the USB level that would make it possible
> to distinguish between the devices without loading the driver?
> Something like the number of endpoints?  Then we could ask USB
> developers to provide a way to specify them in the USB devece table.

Seems like a trouble to solve a non-problem...

> > On Sunday 28 December 2008, Piter PUNK wrote:
> > > Loading rt2500usb AND rt73usb don't have any functional
> > > problem. All wireless devices works fine. But is very
> > > annoying the additional modules loaded.

I'm not sure I see how it is annoying, but I'm sorry it annoys you.
Nevertheless, I don't think it is worth much effort to fix it.

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
