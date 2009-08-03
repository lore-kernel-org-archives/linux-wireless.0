Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:43168 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754474AbZHCTQ6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 15:16:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: chris2553@googlemail.com
Subject: Re: [Bug #13846] Possible regression in rt61pci driver
Date: Mon, 3 Aug 2009 21:17:36 +0200
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	linux-wireless@vger.kernel.org
References: <Su1q3S6JjyO.A.jeB.hcgdKB@chimera> <iZB3Pj-uj3M.A.pRC.1cgdKB@chimera> <200908031931.27427.chris2553@googlemail.com>
In-Reply-To: <200908031931.27427.chris2553@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <200908032117.36856.rjw@sisk.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 03 August 2009, Chris Clayton wrote:
> Hi Rafael,
> 
> On Sunday 02 August 2009, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.30.  Please verify if it still should be listed and let me know
> > (either way).
> >
> 
> The folks on the wireless project have concluded that the problem I reported is down to a hardware 
> problem when power saving is switched on on for my Belkin cardbus wireless adapter, so now I simply 
> turn power-saving off when wlan0 comes up. I did, however, ask whether anyone was going to fix the 
> fact that once power-saving turns the LEDs off, they never come back on again, but I haven't had an 
> answer. Is that a regression? I guess the answer is no, because power saving in the rt61pci driver 
> is feature that is new to 2.6.31.

Well, IMO it is a regression, because it had worked before the power saving
feature was added.

> Should it be fixed? I think the answer is yes, but being unable to do it
> myself, I probably don't have a vote :-)

Well, if you remind the developers about the issue from time to time, it may
help. ;-)

Thanks,
Rafael
