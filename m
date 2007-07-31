Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from madara.hpl.hp.com ([192.6.19.124]:59856 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764337AbXGaQ4H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 12:56:07 -0400
Date: Tue, 31 Jul 2007 09:55:05 -0700
To: Masakazu Mokuno <mokuno@sm.sony.co.jp>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] remove duplicated ioctl entries in compat_ioctl.c
Message-ID: <20070731165505.GB15450@bougret.hpl.hp.com>
Reply-To: jt@hpl.hp.com
References: <20070730144726.GA6586@tuxdriver.com> <20070730183729.GB7332@bougret.hpl.hp.com> <20070731133115.3288.MOKUNO@sm.sony.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070731133115.3288.MOKUNO@sm.sony.co.jp>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 31, 2007 at 01:45:06PM +0900, Masakazu Mokuno wrote:
> 
> On Mon, 30 Jul 2007 11:37:29 -0700
> Jean Tourrilhes <jt@hpl.hp.com> wrote:
> 
> > 	Testing with SIOCGIWSTATS or SIOCGIWPRIV would narrow down to
> > only the pointer problem, and the kernel fix should work with both old
> > and new version of the Wireless Tools. It's simple to test, either you
> > are getting valid data or garbage, the only issue is that some drivers
> > may be returning garbage for those calls.
> 
> As I'm outside of the firewall of the company this week,  I'll test in
> the next week.
> 
> I think it is sufficient to see these ioctls work, using 'iwpriv
> <interface>' for SIOCGIWPRIV and 'iwconfig <interface>' for SIOCGIWSTAT.
> Is that right?

	Correct. You should check what to expect to make sure the
returned data is valid.

>  Anything to add more?
> 
> For the 'old version' of wirelesstools,  which version should I use?
> wirelesstools 28?

	Yes, v28 is great, unless John has a specific version in mind.

> regards
> 
> --
> Masakazu MOKUNO

	Jean
