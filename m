Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:2159 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750978AbYGDSVV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jul 2008 14:21:21 -0400
Date: Fri, 4 Jul 2008 14:21:20 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Chr <chunkeey@web.de>
cc: Ivo Couckuyt <iv0co@yahoo.co.uk>, <linux-usb@vger.kernel.org>,
	<linux-wireless@vger.kernel.org>
Subject: Re: PROBLEM: p54usb doesn't work with my Philips CPWUA054 usb adapter
In-Reply-To: <200807041956.34051.chunkeey@web.de>
Message-ID: <Pine.LNX.4.44L0.0807041420430.10060-100000@netrider.rowland.org> (sfid-20080704_202127_077757_1A042F78)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 4 Jul 2008, Chr wrote:

> So, maybe someone of the linux-usb people knows why this happens?!
> How to fix it, or how to DEBUG?! (any tips/hints? or is there a util like 
> strace/usbsnopper which can monitor/compare the function-calls and
> the resulting traffic of ndiswrapper AND the p54usb driver?)
> (Chipset seems to be a nForce 2 OHCI/EHCI):

See Documentation/usb/usbmon.txt.

Alan Stern

