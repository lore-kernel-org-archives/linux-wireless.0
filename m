Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:46092 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754118AbYFXVuU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2008 17:50:20 -0400
Subject: Re: [PATCH 04/13] rfkill: add parameter to disable radios by
	default
From: Dan Williams <dcbw@redhat.com>
To: Fabien Crespel <fabien@crespel.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <48615925.8010203@crespel.net>
References: <1214252588-30723-1-git-send-email-hmh@hmh.eng.br>
	 <1214252588-30723-5-git-send-email-hmh@hmh.eng.br>
	 <g3quvb$8sa$1@ger.gmane.org>  <g3r9hn$av5$1@ger.gmane.org>
	 <1214330213.23127.9.camel@localhost.localdomain>
	 <48615925.8010203@crespel.net>
Content-Type: text/plain
Date: Tue, 24 Jun 2008 17:49:19 -0400
Message-Id: <1214344159.11980.21.camel@localhost.localdomain> (sfid-20080624_235024_018764_C26027A8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-06-24 at 22:29 +0200, Fabien Crespel wrote:
> Dan Williams wrote :
> > On Tue, 2008-06-24 at 19:06 +0200, Fabien Crespel wrote:
> >   
> >> Indeed, I think it would be better to let the driver choose the default state 
> >> (initialization) instead of forcing it when registering. This would allow drivers 
> >> to restore the device state after a reboot or shutdown (provided the firmware 
> >> stores it, which is the case at least on my ASUS F3JC laptop).
> >>     
> >
> > Do you mean your laptop BIOS stores the value in nvram somewhere?  What
> > specific driver reads that value back out?
> >
> > Dan
> >   
> Yes, the laptop BIOS stores the value. Reading it back is done the same 
> way as reading the WLAN/BT status later (through an ACPI method), so the 
> driver only has to read and write the status at initialization to 
> restore the device status & LEDs (because the reported status doesn't 
> reflect the hardware status at boot time).

Yeah, but what driver -is- that?  asus-laptop or something?

Dan

