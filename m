Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:53845 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996AbYFWQyb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jun 2008 12:54:31 -0400
Subject: Re: 802.11 pccard, Agere 0x0156,0x0003?
From: Dan Williams <dcbw@redhat.com>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Bernhard Reiter <bernhard@intevation.de>,
	linux-wireless@vger.kernel.org, Dave <kilroyd@googlemail.com>
In-Reply-To: <878wwwi0zr.fsf@nokia.com>
References: <200806181715.20516.bernhard@intevation.de>
	 <200806191023.39851.bernhard@intevation.de> <485A9A00.70700@gmail.com>
	 <200806200935.55882.bernhard@intevation.de>
	 <1213947479.8967.134.camel@johannes.berg>  <878wwwi0zr.fsf@nokia.com>
Content-Type: text/plain
Date: Mon, 23 Jun 2008 12:53:25 -0400
Message-Id: <1214240005.16075.42.camel@localhost.localdomain> (sfid-20080623_185435_228408_7C1C2B1A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-06-23 at 19:12 +0300, Kalle Valo wrote:
> "Johannes Berg" <johannes@sipsolutions.net> writes:
> 
> >> > Both versions can be found at <http://www.xs4all.nl/~pptp/agere>, which
> >> > also has patched versions for 2.6
> >> 
> >> Cool!
> >> Just to make sure: This is a driver that - despite being unmaintained - should 
> >> work? So could try it with 2.6.17, 2.6.24 and even newer?
> >
> > Just FYI, there are patches in the queue that will most likely make all
> > (out-of-tree) drivers using wireless extensions break, so even if it
> > works now it will probably not with 2.6.27.
> 
> What is breaking out-of-tree drivers in 2.6.27? David Miller's compat
> WEXT stuff, or what?

Yes.

Dan

