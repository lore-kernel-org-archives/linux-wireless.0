Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34591 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060AbZESLaP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2009 07:30:15 -0400
Date: Tue, 19 May 2009 07:29:12 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	linux-wireless@vger.kernel.org
Subject: Re: DHCP broken when using A-band only
Message-ID: <20090519112912.GA2691@tuxdriver.com>
References: <1242701451.3147.2.camel@localhost.localdomain> <1242720983.29049.16.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1242720983.29049.16.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 19, 2009 at 10:16:23AM +0200, Johannes Berg wrote:
> On Mon, 2009-05-18 at 19:50 -0700, Marcel Holtmann wrote:
> > Hi Johannes,
> 
> Heh. Hi Marcel :)
> 
> > so I am running the latest wireless-testing.git tree based on 2.6.30-rc6
> > and when connecting to my A-band only configured AP, I don't get any
> > packets through. Even DHCP fails. The only thing I see in dmesg is
> > 
> > [ 3221.246392] wlan0: dropped frame to 00:1f:f3:xx:xx:xx (unauthorized port)
> > 
> > The wireless-testing.git tree based on 2.6.30-rc5 was working fine with
> > that access point. I was actually happily using the A-band since it is
> > less busy here. Any ideas why this might broke?
> 
> Not at all, sorry. Were there any driver changes? There shouldn't be
> many changes at all maybe you could bisect?

Use merge-2009-05-18 and master-2009-05-18 (or later) as your endpoints
for bisection.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
