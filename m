Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35014 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753059AbZKLSuQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2009 13:50:16 -0500
Subject: Re: Looking for the datasheet of zd1211rw...
From: Dan Williams <dcbw@redhat.com>
To: Simon Raffeiner <sturmflut@lieberbiber.de>
Cc: Andrey Yurovsky <andrey@cozybit.com>,
	tomas zheng <tomaswlan.zheng@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1258051444.2347.124.camel@localhost.localdomain>
References: <1d91afb90911112231n54696c5fh950ba0102740d444@mail.gmail.com>
	 <45e8e6c40911112302s7c5c3e5cq496289512410ecba@mail.gmail.com>
	 <200911120847.44150.sturmflut@lieberbiber.de>
	 <1258051444.2347.124.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 12 Nov 2009 10:50:00 -0800
Message-Id: <1258051800.2347.127.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-11-12 at 10:44 -0800, Dan Williams wrote:
> On Thu, 2009-11-12 at 08:47 +0100, Simon Raffeiner wrote:
> > Am Donnerstag, 12. November 2009 08:02:36 schrieben Sie:
> > 
> > > It looks like a Marvell device (and therefore not a zd1211) from what
> > > you posted.
> > 
> > It is a Marvell Libertas device, but it seems the USB ID is not claimed by the existing drivers ("libertas" and "libertas_tf").
> 
> It's a softmac device, likely an 8335-based card.  The 'mwl8k' driver
> upstream is the closest match, but mwl8k doesn't yet have support for
> the older softmac cards like the 8335 or 8361/8362 TopDog series.

I lie, it's a usb8338 (W833810).  There's code for this driver
"around" (mrvl_cb82 is the name) but it's the old vendor driver based on
net80211:

http://git.kernel.org/?p=linux/kernel/git/linville/marvell.git;a=summary

drivers/net/wireless/mrvl_cb82/driver/mwl_usb.c

Dan


