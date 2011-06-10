Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34799 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035Ab1FJSB0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2011 14:01:26 -0400
Date: Fri, 10 Jun 2011 13:53:03 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: Re: pull request: bluetooth-2.6 2011-06-08
Message-ID: <20110610175302.GD2665@tuxdriver.com> (sfid-20110610_200131_874950_97592955)
References: <20110608194658.GD13036@joana>
 <20110609175933.GA16802@tuxdriver.com>
 <20110609183430.GA2533@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110609183430.GA2533@joana>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 09, 2011 at 03:34:31PM -0300, Gustavo F. Padovan wrote:
> * John W. Linville <linville@tuxdriver.com> [2011-06-09 13:59:34 -0400]:
> 
> > On Wed, Jun 08, 2011 at 04:46:58PM -0300, Gustavo F. Padovan wrote:

> > >       Bluetooth: Kill set but unused variable 'cmd' in cmtp_recv_capimsg()
> > 
> > Well, the patch submitter sounds familiar.  :-)  But killing an unused
> > variable isn't a bug fix.  It doesn't do any damage, but I suspect that
> > Dave expects to be held to the same standards as everyone else.
> > 
> > Can you drop that one (and reapply it for 3.1)?  Sorry for the trouble...
> 
> Sorry for that, I tough it was not that bad fix this for 3.0. New pull request
> follows. Thanks a lot!

> Stephen Boyd (1):
>       Bluetooth: Silence DEBUG_STRICT_USER_COPY_CHECKS=y warning

Sorry, I missed this one too -- can you redirect it for 3.1 as well?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
