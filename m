Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:60869 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbZDRVS7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Apr 2009 17:18:59 -0400
Received: by ewy24 with SMTP id 24so661264ewy.37
        for <linux-wireless@vger.kernel.org>; Sat, 18 Apr 2009 14:18:58 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] Add vt6656 driver to drivers/staging.
Date: Sat, 18 Apr 2009 23:18:56 +0200
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, dcbw@redhat.com,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
References: <49E632A1.1050605@gmail.com> <20090415212103.GA5202@kroah.com>
In-Reply-To: <20090415212103.GA5202@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200904182318.56512.IvDoorn@gmail.com> (sfid-20090418_231905_177254_5E71A97F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> > I hope rt2800pci/usb to be included *ASAP*, because rt2800usb supports
> > more than 1oo USB devices and rt2800pci is included in a lot of
> > laptops(ask Torvalds [1] [2])
> > 
> > [1] http://marc.info/?l=linux-netdev&m=121799144422863&w=2
> > [2] http://marc.info/?l=linux-kernel&m=123187052023831&w=2
> 
> That would be great to have in, what's keeping it from happening?

In short: A stable workable driver.

The rt2800usb driver is pretty far (at least on my testsetup), but
still has problems with transmitting frames immediately after
association.

As for rt2800pci that card still refuses to anything. The MCU registers
simply refuses the initialize, the TX and RX refuse to do anything.

I have some help from Ralink on this, as well as some patches from
others which have been merged. But I lack the time to really dive
into these issues. I don't get much further then a guick glance every
few days.

Ivo
