Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dreamhostlb1.dreamhost.com ([208.97.187.133]:43666 "EHLO
	webmail5.dreamhost.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753919AbXLLAPb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2007 19:15:31 -0500
Message-ID: <50633.68.40.216.125.1197418099.squirrel@webmail.nostar.net> (sfid-20071212_001534_960262_6F3499B8)
Date: Tue, 11 Dec 2007 16:08:19 -0800 (PST)
Subject: Re: Problems with b43 using BCM4306 r3
From: doug@nostar.net
To: "Michael Buesch" <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
References: <475DA27F.2040004@nostar.net> <200712102258.29802.mb@bu3sch.de>
In-Reply-To: <200712102258.29802.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The problems only exist on the planet CCRMA

http://ccrma.stanford.edu/planetccrma/software/

low-lat patched kernel that I was using.  I'm now running a stock Fedora 
8 2.6.23.8-63.fc8 kernel and there dont appear to be anymore wifi 
problems.  My reasons for using the ccrma kernel werent low latency 
performance so much as a working firewire stack (fedora 7 and above uses 
a new, broken stack) but I found another method.

Michael Buesch wrote:
> On Monday 10 December 2007 21:33:03 Doug McLain wrote:
>> I have an emachines M6805 with the BCM4306 r3 wifi chip.  Using the
ndiswrapper driver, all is ok, but using the b43 driver results in
constant flow of dmesg output (see link), eventual lockup of wifi under
heavy network traffic, and constant xruns when using JACK audio server.
>>   Again, when I use the ndiswrapper driver, everything works ok.
>> http://nostar.net/ardour/dmesg.txt
>
> That's weird. These messages say that interrupts are not disabled in the
IRQ handler. Which driver are you using? Please try vanilla
> wireless-2.6.
>





