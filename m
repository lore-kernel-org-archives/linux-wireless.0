Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:42784 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750855AbYLOLxk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2008 06:53:40 -0500
Date: Mon, 15 Dec 2008 09:53:36 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Dan Williams <dcbw@redhat.com>
Cc: Tony Vroon <tony@linx.net>, Len Brown <lenb@kernel.org>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	linux-acpi@vger.kernel.org, jwoithe@physics.adelaide.edu.au,
	Peter Gruber <nokos@gmx.net>, linux-wireless@vger.kernel.org
Subject: Re: Fuijtsu Lifebook RFKILL support
Message-ID: <20081215115336.GD17648@khazad-dum.debian.net> (sfid-20081215_125346_876876_ACE1C7C0)
References: <1228957506.4045.11.camel@localhost> <20081211165247.GA4844@khazad-dum.debian.net> <1229016827.6446.6.camel@localhost> <20081211194734.GA18132@khazad-dum.debian.net> <1229046602.4030.13.camel@localhost> <20081212195331.GA12679@khazad-dum.debian.net> <alpine.LFD.2.00.0812121532580.4064@localhost.localdomain> <1229172465.4010.11.camel@localhost> <20081213132857.GA11428@khazad-dum.debian.net> <1229274343.6775.15.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1229274343.6775.15.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 14 Dec 2008, Dan Williams wrote:
> On Sat, 2008-12-13 at 11:28 -0200, Henrique de Moraes Holschuh wrote:
> > On Sat, 13 Dec 2008, Tony Vroon wrote:
> > > > What is the WLAN driver involved? Is it rfkill-aware?
> > > 
> > > The driver is iwlagn, which does indeed notice that it is killed.
> > > This information does not reach NetworkManager. Relevant log
> > > entries: Dec 12 00:59:01 amalthea iwlagn: Radio Frequency Kill
> > > Switch is On: Dec 12 00:59:01 amalthea Kill switch must be turned
> > > off for wireless networking to work.
> > 
> > Then, it is just a matter of time for it to be working correctly.  In
> > fact, it might already be if you use wireless-testing and latest
> > network manager.
> 
> If HAL's killswitch support doesn't know about the kernel killswitch
> device, or it cannot get the state of the killswitch, then certainly
> NetworkManager isn't going to know about it.

I see.  I have added "up-to-date HAL also required" to my mental list of
stuff needed in userspace.

Thanks, Dan.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
