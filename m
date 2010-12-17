Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web56803.mail.re3.yahoo.com ([66.196.97.77]:23399 "HELO
	web56803.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754209Ab0LQQdx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Dec 2010 11:33:53 -0500
Message-ID: <75430.80149.qm@web56803.mail.re3.yahoo.com>
Date: Fri, 17 Dec 2010 08:33:51 -0800 (PST)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: Re: [PATCH 04/17] rt2x00: fix hang when unplugging USB device in use
To: Johannes Stezenbach <js@sig21.net>
Cc: Ivo Van Doorn <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com
In-Reply-To: <20101217150206.GA6805@sig21.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > > Odd I have been testing this while stresstesting
> the card,
> > > and either
> > > unplugging, rmmod or ifdown, and I couldn't
> > > reproduce any crashes. Has the stacktrace changed
> after
> > > these patches?
> > 
> > I can confirm when the rt2800usb is loaded and an
> rt3070 chip is connected to
> > a network, running 'rmmod rt2800usb rt2x00lib
> rt2x00usb rt2800lib' causes
> > immediate system hang (and hard-reset).
> 
> FWIW, I did not test this case.  I only tested
> hot-unplug of the
> USB device.  However, I think usually when the network
> interface
> is up the module use count should be incremented so that
> you
> cannot unload the module.
> 


Hi, Johannes

I can rmmod the zd1211rw for example, even the interface is up and connected to a network, whereas the rt2800usb forces the system to freeze. Why the difference?

Walter


      
