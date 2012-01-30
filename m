Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4021 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752025Ab2A3LQ4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jan 2012 06:16:56 -0500
Message-ID: <4F267C1D.40704@broadcom.com> (sfid-20120130_121700_416594_81BF0D66)
Date: Mon, 30 Jan 2012 12:16:45 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "M. Lambert" <lambertm@westman.wave.ca>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: bcm43236 chipset
References: <1327859778.27653.5.camel@localhost>
In-Reply-To: <1327859778.27653.5.camel@localhost>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/29/2012 06:56 PM, M. Lambert wrote:
> Good morning,
> 
> I have seen a couple of posts where reference was made to usb support in
> broadcom drivers, and that the code would also support additional
> chipsets (such as the bcm43236 but not the 43231) when quote "my testing
> here is complete" unquote.

That is my line ;-) I am indeed testing/tinkering on adding USB support
to the brcmfmac driver with bcm43236 as chipset.

> As I have a Linksys AE2500 (13b1:003a) usb dongle, I am very interested
> in helping test this functionality no matter how reliable it is, or is
> not at this time.  Using Fedora 16 x64, kernel 3.2.2-1 at this time.  I
> believe I'd have to build my own kernel to enable bcma support but not
> positive about that yet.

BCMA is only needed for the brcmsmac driver. So no need to enable it.

> If the driver is near a point where testing by others with certain
> hardware could be helpful and/or useful I'd be happy to test and provide
> any feedback.

Thanks. I hope to submit the patch this week.

Gr. AvS

