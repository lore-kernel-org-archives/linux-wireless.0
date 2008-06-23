Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:33337 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751241AbYFWFJl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jun 2008 01:09:41 -0400
Date: Mon, 23 Jun 2008 02:09:36 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Matthew Garrett <mjg@redhat.com>,
	Dan Williams <dcbw@redhat.com>,
	Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH 12/12] rfkill: document rw rfkill switches and clarify
	input subsystem interactions
Message-ID: <20080623050936.GB9926@khazad-dum.debian.net> (sfid-20080623_070945_088385_293D3BE6)
References: <1214149128-5913-1-git-send-email-hmh@hmh.eng.br> <1214149128-5913-13-git-send-email-hmh@hmh.eng.br> <20080623022412.GC24992@anvil.corenet.prv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080623022412.GC24992@anvil.corenet.prv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 22 Jun 2008, Dmitry Torokhov wrote:
> Hi Henrique,

Hi Dmitry,

Thanks for looking into these in detail.

> > +The rfkill-input module provides the kernel with the ability to implement
> > +a basic response when the user presses a key or button (or toggles a switch)
> > +related to rfkill functionality.  This is optional, and can also be done in
> > +userspace.
> > +
> > +The rfkill-input module also provides EPO (emergency power-off) functionality
> > +for all wireless transmitters.  This function cannot be overriden, and it is
> > +always active.  rfkill EPO is related to *_RFKILL_ALL input events.
> > +
> 
> I think I would like to see the statement that rfkill-input is an
> in-kernel implementation of default policy of reacting to Wifi-related
> (in wide sense) button presses and neither mandatory nor required for
> wireless drivers to operate.

Agreed, will add it.  I already wrote it somewhere, I think, but it is
always good to repeat that information in any place it would be useful to
drive the point home.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
