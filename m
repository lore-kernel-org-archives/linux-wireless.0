Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:60270 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933422AbYEHRto (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 May 2008 13:49:44 -0400
Subject: Re: Update: [RFC][PATCH] mrv8k: Driver for "Marvell 88w8335
	[Libertas]"
From: Dan Williams <dcbw@redhat.com>
To: David Woodhouse <David@Woodhou.se>
Cc: Markus Becker <mab@comnets.uni-bremen.de>,
	Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org, John Daiker <daikerjohn@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	julian.calaby@gmail.com, andreamrl@tiscali.it
In-Reply-To: <1210258953.25560.1112.camel@pmac.infradead.org>
References: <Pine.LNX.4.64.0803191037220.21835@bugs.comnets.uni-bremen.de>
	 <1209057680.9212.1065.camel@pmac.infradead.org>
	 <4821F389.6070905@gmail.com>
	 <200805080912.49903.hs4233@mail.mn-solutions.de>
	 <Pine.LNX.4.64.0805081022470.24384@bugs.comnets.uni-bremen.de>
	 <1210257822.24803.0.camel@localhost.localdomain>
	 <1210258953.25560.1112.camel@pmac.infradead.org>
Content-Type: text/plain
Date: Thu, 08 May 2008 13:45:17 -0400
Message-Id: <1210268717.24803.9.camel@localhost.localdomain> (sfid-20080508_194914_587608_709C31BE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-05-08 at 16:02 +0100, David Woodhouse wrote:
> On Thu, 2008-05-08 at 10:43 -0400, Dan Williams wrote:
> > Yeah, I'll get David to make a git tree.  You should still ask for an
> > account and send him your SSH key so that you can push to the tree as
> > well.
> 
> I've created git://git.infradead.org/mrv8k.git and the mrv8k group,
> which has schurig,mab,dwmw2,dcbw in it.
> 
> I'm a little confused by the request, because I thought wireless
> development was stuck in the 1990s and didn't use git -- I thought it
> was done by patches. But I'll let you work that one out for
> yourselves. :)

We've got a ways to go before we can upstream the driver.  There's still
quite a bit of cleanup to do.  Best to do that with a git tree first
before submitting the cleaned up patch set.

Dan


