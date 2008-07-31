Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:49784 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198AbYGaTlL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jul 2008 15:41:11 -0400
Date: Thu, 31 Jul 2008 09:38:43 -0700
From: Greg KH <greg@kroah.com>
To: Tilman Schmidt <tilman@imap.cc>
Cc: linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: Q: support for AVM Fritz! WLAN USB in kernel 2.6.25+
Message-ID: <20080731163843.GB9606@kroah.com> (sfid-20080731_214116_990963_A684AA02)
References: <4891D1B9.70703@imap.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4891D1B9.70703@imap.cc>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 31, 2008 at 04:52:41PM +0200, Tilman Schmidt wrote:
> Commit 782e70c6fc2290a0395850e8e02583b8b62264d8, which went into
> 2.6.25, broke AVM's closed-source driver for this device:
>
> ID 057c:62ff AVM GmbH WLAN USB v1.1 (cdrom mode)
> ID 057c:6201 AVM GmbH WLAN USB v1.1
>
> Is there an open source alternative for that driver, or do systems
> with that device have to stay with kernel 2.6.24?

Please ask AVM, they have known about this for over 2 years now.

There is nothing we can do about closed source kernel modules, that is
between you and the company producing it.

good luck,

greg k-h
