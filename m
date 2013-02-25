Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:52340 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755982Ab3BYOoa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2013 09:44:30 -0500
Date: Mon, 25 Feb 2013 08:44:25 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
	"Chen, Stephen" <scchen@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org
Subject: Re: carl9170 A-MPDU transmit problem
Message-ID: <20130225144425.GB13296@thinkpad-t410> (sfid-20130225_154435_154608_2B2E1DA1)
References: <Pine.LNX.4.44L0.1302241048230.22522-100000@netrider.rowland.org>
 <201302242330.56346.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201302242330.56346.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 24, 2013 at 11:30:56PM +0100, Christian Lamparter wrote:
> Did you plug the DWA-160 device into a USB 3.0 port on your ivy bridge
> system or does it react in the same way on the 'legacy' USB 2.0 ports as
> well [so we are not comparing xhci (Ivy Bridge) to ehci (Arrandale)]?

Those two machines only have USB 3.0 ports, but I did manage to find an
Ivy Bridge machine with both. On that machine I get a stable connection
on the USB 2.0 ports and a flaky connection on the USB 3.0 ports. I
didn't actually sniff the frames, but the behavior is consistent with
what I saw on the other machines.

Seth

