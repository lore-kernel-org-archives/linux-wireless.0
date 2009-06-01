Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:56063 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759106AbZFAPgW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2009 11:36:22 -0400
Date: Mon, 1 Jun 2009 12:36:20 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	Marcel Holtmann <marcel@holtmann.org>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] rfkill: create useful userspace interface
Message-ID: <20090601153620.GB15485@khazad-dum.debian.net>
References: <1243763887.19302.29.camel@johannes.local> <1243796509.6570.35.camel@localhost.localdomain> <1243841639.5299.8.camel@johannes.local> <4A238EA2.4040106@tuffmail.co.uk> <20090601122839.GB11011@khazad-dum.debian.net> <1243859931.5299.17.camel@johannes.local> <20090601124553.GE11011@khazad-dum.debian.net> <1243860606.5299.21.camel@johannes.local> <20090601133351.GI11011@khazad-dum.debian.net> <1243866545.5299.25.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1243866545.5299.25.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 01 Jun 2009, Johannes Berg wrote:
> On Mon, 2009-06-01 at 10:33 -0300, Henrique de Moraes Holschuh wrote:
> 
> > I don't know if I have any gripes with your latest patch ;)  Can't test it
> > right now.  I was reacting to the comments in the thread.
> 
> Well could you read it and see if the API does what you require? A
> discussion about that would be so much more useful than handwaving about
> LED blinking and security issues...

LEDs?  I mean the device being rfkilled/unrfkilled (which often means the
entire device is kicked off the USB bus and hotplugged back)... I must cut
down on comparisons and analogies.

I will look at your patch as soon as I can, I just can't do it right now.

> > On a related note, Johannes, would you be opposed to exporting something I
> > could call from thinkpad-acpi to request a radio state change on a rfkill
> > struct?   This would allow me to remove some of the mess in thinkpad-acpi.
> 
> I don't think I understand what you want? What do you mean by "request a
> radio state change"?

As in "please try to block this _specific_ radio", and "please try to
unblock this _specific_ radio".

I.e. what one would do by a write to the "state" attribute of the _old_
rfkill sysfs (and which would get overriden the next time someone changed
the global state, etc).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
