Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:37766 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754418AbXFLPaW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2007 11:30:22 -0400
Subject: Re: Please pull libertas-2.6
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200706121715.33187.hs4233@mail.mn-solutions.de>
References: <1181102122.18061.8.camel@xo-28-0B-88.localdomain>
	 <200706121519.09758.hs4233@mail.mn-solutions.de>
	 <20070612140529.GD310@tuxdriver.com>
	 <200706121715.33187.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Tue, 12 Jun 2007 11:26:42 -0400
Message-Id: <1181662002.2904.0.camel@xo-28-0B-88.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2007-06-12 at 17:15 +0200, Holger Schurig wrote:
> > FWIW, waiting for the merge window is generally frowned upon. 
> > If at all possible you should submit patches now or ASAP so
> > that Jeff and I have a reasonable chance to review them and
> > they can make their way into -mm for some testing BEFORE the
> > merge window opens.
> 
> Yeah, but I'm still very much unfinished. It can:
> 
> * detect the card
> * setup the IO window
> * setup the ISR
> * download helper firmware
> * download real firmware
> * react to some (not ALL!) interrupts
> 
> But, for example, it can not:
> 
> * send commands to the device (I'm close, but
>   not yet there)
> * receive results from the device (dito)
> * receive data from the device (hey, even skb's
>   are new to me)
> * send data to the device
> 
> So, in short: the driver isn't yet usable in any way. And so I 
> doubt you would want to see my current skeleton :-)
> 
> 
> 
> I referred to the merge window because I doubt that I'll get my 
> code early enought into a submitable form -- and if I can't it 
> submit to YOU before the merge window closes, then you can't put 
> it upstream either. And so it might be that the libertas_cs code 
> will end up in 2.6.24, not 2.6.23. And Dan even mentioned 
> 2.6.22, which is out-of-the-question, because a new driver is 
> hardly a fix.
> 
> So, my plan is to submit the driver (or the patchset for the 
> driver) to either libertas-dev or wireless-dev as soon as I get 
> my first association to an AP via it. We can than think if the 
> driver should be added to some GIT tree. From then on I'll start 
> sending incremental patches.
> 
> Do you think that makes sense?

Yeah; either put it in a git tree and send a pull request to
libertas-dev, or mail patches to the libertas list.

Dan


