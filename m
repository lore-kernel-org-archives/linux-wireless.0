Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:52389 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212Ab3BYOvp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2013 09:51:45 -0500
Date: Mon, 25 Feb 2013 08:51:42 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	linux-usb@vger.kernel.org,
	"Chen, Stephen" <scchen@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org
Subject: Re: carl9170 A-MPDU transmit problem
Message-ID: <20130225145142.GC13296@thinkpad-t410> (sfid-20130225_155151_610373_CC58477F)
References: <201302242330.56346.chunkeey@googlemail.com>
 <Pine.LNX.4.44L0.1302241833580.29714-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <Pine.LNX.4.44L0.1302241833580.29714-100000@netrider.rowland.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 24, 2013 at 06:41:06PM -0500, Alan Stern wrote:
> >  Or can you think of any other "interesting"
> > bits that could help to explain why the "Arrandale box [...] worked
> > perfectly" whereas (all his) Ivy Bridge ones have problems.
> > (Of course, I assume that it is always the same device, the
> > same firmware and the same kernel drivers in all tests, right)?
> 
> No, not really.  Unless one is using USB-2 and the other USB-3 -- the 
> device might have a bug in its USB-3 firmware.

This appears to be a high-speed device; at least, dmesg says "new
high-speed USB device ..." when I plug it in. So for the firmware isn't
it USB 2.0 even when plugged in a SuperSpeed port?

> What happens if xhci-hcd is unloaded before the test?

I'll test this, but I need to rebuild first. xhci-hcd is currently
built-in to my kenel.

Seth

