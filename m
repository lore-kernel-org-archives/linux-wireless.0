Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58871 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973Ab0ECQAN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 May 2010 12:00:13 -0400
Date: Mon, 3 May 2010 11:47:46 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "rain_maker@root-forum.org" <rain_maker@root-forum.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rt2x00: remove USB-ID 148f:2573 from rt2500usb driver
Message-ID: <20100503154745.GB24781@tuxdriver.com>
References: <201005031624.45409.rain_maker@root-forum.org>
 <20100503145815.GA24781@tuxdriver.com>
 <201005031720.36288.rain_maker@root-forum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201005031720.36288.rain_maker@root-forum.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 03, 2010 at 05:20:36PM +0200, rain_maker@root-forum.org wrote:
> Am Monday 03 May 2010 16:58:16 schrieben Sie:

> > So I'm curious, how can you be sure that 148f:2573 is _always_ wrong
> > for rt2500usb?  I do acknowledge that the "73" part makes it suspicious...

> But of course the problem in such cases is, you can't prove it, you can only 
> add more and more examples for "not being wrong" while finding one example 
> where actually a device with 148f:2573 working with rt2500usb und not working 
> with rt73usb would prove me wrong once and for all.

http://osdir.com/ml/linux-wireless/2009-07/msg00267.html

This seems to be such an example?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
