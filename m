Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52743 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293Ab2IGMQi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 08:16:38 -0400
Message-ID: <1347020234.4256.22.camel@jlt4.sipsolutions.net> (sfid-20120907_141653_416516_9205F2FE)
Subject: Re: [PATCH v2] p54: connect to 11w protected networks
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Date: Fri, 07 Sep 2012 14:17:14 +0200
In-Reply-To: <1346770467.3737.32.camel@jlt4.sipsolutions.net> (sfid-20120904_165356_208297_322195F0)
References: <1346622538.10113.3.camel@jlt4.sipsolutions.net>
	 <E1T8tYj-00051o-3z@debian64.localnet>
	 (sfid-20120904_155321_955424_2D6B3F4B) <1346768149.3737.29.camel@jlt4.sipsolutions.net>
	 <1346769184.26638.7.camel@dcbw.foobar.com>
	 <1346769429.3737.30.camel@jlt4.sipsolutions.net>
	 (sfid-20120904_163651_735748_490095D0) <1346770467.3737.32.camel@jlt4.sipsolutions.net>
	 (sfid-20120904_165356_208297_322195F0)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-09-04 at 16:54 +0200, Johannes Berg wrote:

> > > We can't get this to happen without a module option?  Is there a way to
> > > turn the crypto offloading off when we know we're connecting to a W
> > > protected AP?
> > 
> > Yeah that's what I was thinking. I suppose we *could* somehow do this by
> > setting some key flag in mac80211 that the driver can check.
> 
> Something like this perhaps:
> 
> http://p.sipsolutions.net/76d17d49f4685cda.txt

If you want this for your driver, I'll commit this:

http://p.sipsolutions.net/ea2e3dbe980f5db8.txt

johannes

