Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:48758 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756795AbYBJB1f (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Feb 2008 20:27:35 -0500
From: Reinhard Biegel <r.biegel@gmx.at>
To: linux-wireless@vger.kernel.org
Subject: Re: prism54: Out of memory, cannot handle oid, card/socket may be faulty, or IRQ line too busy
Date: Sun, 10 Feb 2008 02:27:06 +0100
References: <47ACD136.4030705@wpkg.org> <20080208221009.GA2919@tuxdriver.com>
In-Reply-To: <20080208221009.GA2919@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200802100227.06799.r.biegel@gmx.at> (sfid-20080210_012803_024768_1AE70BE1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm having the same problem with my Netgear WG511 (PCMCIA, SoftMAC version) 
and Kernel 2.6.24.

With 2.6.23 and the drivers from www.linuxwireless.org (compat-wireless-2.6) 
it works. At least most of the time. More or less regulary there is an ACPI 
error message telling me that the IRQ of the card has been disabled. Then I 
have to replug it to get it up again. I'm using the same firmware with both 
kernels/drivers (v2.7.0.0).

Regards,
Reinhard Biegel


On Friday, 8. February 2008 23:10:09 you wrote:
> On Fri, Feb 08, 2008 at 11:01:26PM +0100, Tomasz Chmielewski wrote:
> > I just wanted to use a mini-PCI card using a prism54 module - however, it
> > fails to bring the interface up with "Out of memory, cannot handle oid"
> > and "Your card/socket may be faulty, or IRQ line too busy" messages.
>
> I vaguely recall seeing an error like that when I used the wrong
> firmware.  What firmware are you using?
>
> John


