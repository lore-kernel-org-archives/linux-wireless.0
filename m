Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:54517 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759468Ab3BYWmU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2013 17:42:20 -0500
Date: Mon, 25 Feb 2013 16:42:15 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	linux-wireless@vger.kernel.org,
	USB list <linux-usb@vger.kernel.org>
Subject: Re: carl9170 A-MPDU transmit problem
Message-ID: <20130225224215.GK13296@thinkpad-t410> (sfid-20130225_234227_079851_E1ABC749)
References: <Pine.LNX.4.44L0.1302251024200.1526-100000@iolanthe.rowland.org>
 <201302251703.40801.chunkeey@googlemail.com>
 <20130225191357.GE6605@xanatos>
 <20130225194623.GI13296@thinkpad-t410>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130225194623.GI13296@thinkpad-t410>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 25, 2013 at 01:46:23PM -0600, Seth Forshee wrote:
> > Which kernel version are you testing under?  Can you please recompile
> > with CONFIG_USB_DEBUG and CONFIG_USB_XHCI_HCD_DEBUGGING turned on, and
> > send me dmesg?  I should be able to see if there's an unhandled pending
> > event on the xHCI rings if the data URB stalls for longer than say, a
> > minute.
> 
> I'll do this.

dmesg turned out to be rather large here, so I put in on a server rather
than attaching it. Here's the link.

http://people.canonical.com/~sforshee/dmesg-carl9170-usb-debug.txt

Thanks,
Seth

