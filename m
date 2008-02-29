Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:49693 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756911AbYB2XOk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Feb 2008 18:14:40 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: pull request: wireless-2.6 2008-02-27
Date: Sat, 1 Mar 2008 00:13:11 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	David Miller <davem@davemloft.net>,
	gordonfarquharson@gmail.com, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <20080228014125.GI3078@tuxdriver.com> <20080229162629.GB3234@tuxdriver.com> <1204302853.3938.40.camel@johannes.berg>
In-Reply-To: <1204302853.3938.40.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200803010013.11458.mb@bu3sch.de> (sfid-20080229_231447_363538_EA5321F8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 29 February 2008 17:34:13 Johannes Berg wrote:
> 
> On Fri, 2008-02-29 at 11:26 -0500, John W. Linville wrote:
> > On Fri, Feb 29, 2008 at 01:16:59PM +0100, Michael Buesch wrote:
> > 
> > > I'm wondering if we can't simply pass a commandline parameter to file2alias
> > > that tells it whether we are crosscompiling. It should simply omit the sanity check
> > 
> > Sounds reasonable to me.
> 
> In fact, file2alias shouldn't need a command line argument ...

Well, if...

> > > in that case. Is there any easy and reliable way to find out whether we
> > > are crosscompiling from a makefile (I don't know the makefile core that much)?
> > 
> > Non-empty CROSS_COMPILE definition?
> 
> ... it can just check whether CROSS_COMPILE is set in its environment.
> No?

Is that exported to the environment?

-- 
Greetings Michael.
