Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36909 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbYIYPsq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Sep 2008 11:48:46 -0400
Date: Thu, 25 Sep 2008 11:47:54 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Zhu Yi <yi.zhu@intel.com>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: pull request: wireless-2.6 2008-09-24
Message-ID: <20080925154753.GA3277@tuxdriver.com> (sfid-20080925_174852_471914_7CD0A258)
References: <20080924231720.GD3639@tuxdriver.com> <1222321622.2510.455.camel@debian.sh.intel.com> <20080925114133.GA5044@tuxdriver.com> <1ba2fa240809250757x32aa450k523d71e555c221e4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1ba2fa240809250757x32aa450k523d71e555c221e4@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 25, 2008 at 05:57:33PM +0300, Tomas Winkler wrote:
> On Thu, Sep 25, 2008 at 2:41 PM, John W. Linville
> <linville@tuxdriver.com> wrote:
> > On Thu, Sep 25, 2008 at 01:47:02PM +0800, Zhu Yi wrote:
> >> On Wed, 2008-09-24 at 17:17 -0600, John W. Linville wrote:
> >> > Dave,
> >> >
> >> > One more for 2.6.27 -- a fix for a possible interrupt storm.  There is
> >> > even a link in the commit log to a youtube video of the storm in
> >> > progress. :-)
> >> >
> >> > Let me know if there are problems!
> >>
> >> Can you also add this one? It doesn't panic the kernel when a frame from
> >> firmware is invalid.
> >>
> >> http://marc.info/?l=linux-wireless&m=122219037706528&w=2
> >
> > Is there an open bug report for that anywhere?  Is this something
> > that real users (no offense to Johannes) are likely to hit?
> 
> I'm just exporting the major bugs from our internal database to
> buzilla, 5000 is new so
> we are hitting the problems during testing  before users report them.
> 
> Now I don't know if it was good idea to push the driver upstream same
> time as it hits the market.

You're right -- pushing it sooner rather than sitting on it internally
probably would have helped to give it more visibility sooner.

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
