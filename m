Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:54315 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751191Ab2BNBtC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Feb 2012 20:49:02 -0500
Message-ID: <1329184138.4939.18.camel@joe2Laptop> (sfid-20120214_024912_292230_25AC0368)
Subject: Re: RTLWIFI_DEBUG bug
From: Joe Perches <joe@perches.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 13 Feb 2012 17:48:58 -0800
In-Reply-To: <1329167246.3458.0.camel@jlt3.sipsolutions.net>
References: <1329142387.3365.6.camel@jlt3.sipsolutions.net>
	 <1329165326.4939.16.camel@joe2Laptop>
	 <1329167246.3458.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-02-13 at 22:07 +0100, Johannes Berg wrote:
> On Mon, 2012-02-13 at 12:35 -0800, Joe Perches wrote:
> > On Mon, 2012-02-13 at 15:13 +0100, Johannes Berg wrote:
> > > config RTLWIFI_DEBUG
> > >         tristate "Additional debugging output"
> > >         depends on RTL8192CE || RTL8192CU || RTL8192SE || RTL8192DE
> > >         default y
> > > 
> > > should be
> > > 
> > > config RTLWIFI_DEBUG
> > >         bool "..."
> > > 
> > > as otherwise
> > > 
> > > +#ifdef CONFIG_RTLWIFI_DEBUG
> > > can never be true in a modular build.
> > 
> > If you know the correct solution,
> > perhaps you should submit a patch.
> 
> If I knew your attitude was going to be a problem, I'd never said
> anything. I have better things to do.

If you know a problem exists and the
proper solution, it's not necessary to
do anything other than create the
appropriate patch and cc the appropriate
people.  Doing something else just creates
more work for more people.



