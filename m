Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:59089 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753885AbXKSRi2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2007 12:38:28 -0500
Subject: Re: [BUG] libertas: probing for Marvell USB8388 fails
From: Dan Williams <dcbw@redhat.com>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20071117023548.79a7a33c@morte>
References: <20071117023548.79a7a33c@morte>
Content-Type: text/plain
Date: Mon, 19 Nov 2007 12:35:07 -0500
Message-Id: <1195493707.3248.14.camel@localhost.localdomain> (sfid-20071119_173833_886997_EC7D3E94)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2007-11-17 at 02:35 +0100, Stefano Brivio wrote:
> Marvell USB8388, running on wireless-2.6. Firmware is:
> 421964206b0699014a11256ac48dd0a8  /lib/firmware/usb8388.bin

Try a later firmware from:

http://dev.laptop.org/pub/firmware/libertas/

Is this a usb8388 dev board you got from OLPC?

Dan


> Loading the usb8xxx module, I get:
> [203681.684283] usb8xxx: URB in failure status: -71
> [203681.814072] usb 1-4: reset high speed USB device using ehci_hcd and address 6
> [203683.193744] usb 1-4: reset high speed USB device using ehci_hcd and address 6
> [203684.563428] usb 1-4: reset high speed USB device using ehci_hcd and address 6
> [203685.933099] usb 1-4: reset high speed USB device using ehci_hcd and address 6
> [203687.303025] usb 1-4: reset high speed USB device using ehci_hcd and address 6
> [203688.672443] usb 1-4: reset high speed USB device using ehci_hcd and address 6
> [203690.042118] usb 1-4: reset high speed USB device using ehci_hcd and address 6
> [203691.411789] usb 1-4: reset high speed USB device using ehci_hcd and address 6
> [203692.781455] usb 1-4: reset high speed USB device using ehci_hcd and address 6
> [203694.151134] usb 1-4: reset high speed USB device using ehci_hcd and address 6
> [203695.520804] usb 1-4: reset high speed USB device using ehci_hcd and address 6
> [203695.672729] usb8xxx: probe of 1-4:1.0 failed with error -12
> [203695.672915] usbcore: registered new interface driver usb8xxx
> 
> Any clues?
> 
> 

