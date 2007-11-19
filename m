Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:59048 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751206AbXKSUJK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2007 15:09:10 -0500
Subject: Re: [BUG] libertas: probing for Marvell USB8388 fails
From: Dan Williams <dcbw@redhat.com>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20071119190749.7a9e857c@morte>
References: <20071117023548.79a7a33c@morte>
	 <1195493707.3248.14.camel@localhost.localdomain>
	 <20071119190749.7a9e857c@morte>
Content-Type: text/plain
Date: Mon, 19 Nov 2007 15:05:46 -0500
Message-Id: <1195502746.6479.11.camel@localhost.localdomain> (sfid-20071119_200914_091696_1DB0A6A1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2007-11-19 at 19:07 +0100, Stefano Brivio wrote:
> On Mon, 19 Nov 2007 12:35:07 -0500
> Dan Williams <dcbw@redhat.com> wrote:
> 
> > On Sat, 2007-11-17 at 02:35 +0100, Stefano Brivio wrote:
> > > Marvell USB8388, running on wireless-2.6. Firmware is:
> > > 421964206b0699014a11256ac48dd0a8  /lib/firmware/usb8388.bin
> > 
> > Try a later firmware from:
> > 
> > http://dev.laptop.org/pub/firmware/libertas/
> 
> I tried these ones, it still doesn't work.
> 
> > Is this a usb8388 dev board you got from OLPC?
> 
> Yes.

Which branch of wireless-2.6 are you running?  What kernel version?

Dan

