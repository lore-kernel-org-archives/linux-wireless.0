Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:46115 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755030AbYGaVyw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jul 2008 17:54:52 -0400
Date: Thu, 31 Jul 2008 14:50:55 -0700
From: Greg KH <greg@kroah.com>
To: Tilman Schmidt <tilman@imap.cc>
Cc: linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: Q: support for AVM Fritz! WLAN USB in kernel 2.6.25+
Message-ID: <20080731215055.GB4817@kroah.com> (sfid-20080731_235457_055782_67E2567C)
References: <4891D1B9.70703@imap.cc> <20080731163843.GB9606@kroah.com> <48922FE2.70705@imap.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <48922FE2.70705@imap.cc>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 31, 2008 at 11:34:26PM +0200, Tilman Schmidt wrote:
> On Thu, 31 Jul 2008 09:38:43 -0700, Greg KH wrote:
> > On Thu, Jul 31, 2008 at 04:52:41PM +0200, Tilman Schmidt wrote:
> >> Commit 782e70c6fc2290a0395850e8e02583b8b62264d8, which went into
> >> 2.6.25, broke AVM's closed-source driver for this device:
> >>
> >> ID 057c:62ff AVM GmbH WLAN USB v1.1 (cdrom mode)
> >> ID 057c:6201 AVM GmbH WLAN USB v1.1
> >>
> >> Is there an open source alternative for that driver, or do systems
> >> with that device have to stay with kernel 2.6.24?
> > 
> > Please ask AVM, they have known about this for over 2 years now.
> 
> Please let's keep the politics out of this. I know who wrote that
> patch, I know the agenda behind it and the discussion accompanying it.
> Conversely, I'm sure you know fully well that I have no way of putting
> that question to any relevant person at AVM, and even if I had, it would
> achieve exactly nothing at all. I am not interested in such fruitless
> political discussions. I have a simple question, to which I would like
> a simple answer.

There's no "politics" here at all.

And why wouldn't you go ask AVM, they are the ones producing the driver
for this hardware, how could it be our responsibility to get their code
to work properly, when we have absolutely no way to do so?

This is between you and AVM.  I really suggest contacting the company.
I have talked to them in the past and they seem willing to help out
where they can.

thanks,

greg k-h
