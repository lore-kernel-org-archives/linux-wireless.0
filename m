Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:50067 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753440Ab0CFCm2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Mar 2010 21:42:28 -0500
From: Malte Gell <malte.gell@gmx.de>
To: Pavel Roskin <proski@gnu.org>
Subject: Re: Kernel 2.6.33: ar9170.fw firmware file not found
Date: Sat, 6 Mar 2010 03:42:19 +0100
Cc: linux-wireless@vger.kernel.org
References: <201003040835.29387.malte.gell@gmx.de> <1267827995.3068.33.camel@mj>
In-Reply-To: <1267827995.3068.33.camel@mj>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201003060342.19623.malte.gell@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Pavel Roskin <proski@gnu.org> wrote

> On Thu, 2010-03-04 at 08:35 +0100, Malte Gell wrote:
> > Hello,
> >
> > I just upgraded from Kernel 2.6.32 to 2.6.33 and the ar9170 driver
> > suddenly says "firmware file not found". 
 
Ok, this is what the kernel says:

 <6>[   12.020028] usb 1-3: firmware: requesting ar9170.fw
<3>[   72.050094] usb 1-3: ar9170.fw firmware file not found, trying old 
firmware...
<6>[   72.066421] usb 1-3: firmware: requesting ar9170-1.fw
<3>[  132.080085] usb 1-3: file with init values not found.
<4>[  132.096535] ar9170usb: probe of 1-3:1.0 failed with error -2
<6>[  132.113558] usbcore: registered new interface driver ar9170usb

I have the same firmware in /lib/firmware I use with 2.6.32 and it is actually a 
Fritz WLAN N stick...

Thanx
Malte
