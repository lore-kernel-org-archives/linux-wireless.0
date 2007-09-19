Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from madara.hpl.hp.com ([192.6.19.124]:61326 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761311AbXISQdb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2007 12:33:31 -0400
Date: Wed, 19 Sep 2007 09:32:37 -0700
To: Larry Finger <larry.finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>,
	YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
	Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org
Subject: Re: 2.6.23-rc regression: bcm43xx does not work after commit 4cf92a3c
Message-ID: <20070919163237.GA7914@bougret.hpl.hp.com>
Reply-To: jt@hpl.hp.com
References: <20070917.042418.19962472.yoshfuji@linux-ipv6.org> <20070917165435.GA26926@bougret.hpl.hp.com> <46EF5534.3030609@lwfinger.net> <20070918174202.GB1466@bougret.hpl.hp.com> <46F09167.5020606@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <46F09167.5020606@lwfinger.net>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 18, 2007 at 10:03:03PM -0500, Larry Finger wrote:
> Jean Tourrilhes wrote:
> > 
> > 	Could you be more explicit ? Reverting the patch will just
> > bring back the old bug, and the old code was obviously wrong. I don't
> > like the idea of trading one bug for another bug. It looks to me like
> > nobody knows what's exactly happening in the driver and we are just
> > trying random fixes and see what breaks.
> > 	Could you figure out what's exactly happening and make a
> > proper fix ?
> > 	Regards,
> 
> It took me nearly two days, but I finally found the correct fix for the bug that made it impossible
> to set the essid. The resulting patch has been sent to John.
> 
> Larry

	Yes, the fix looked more extensive than I though, and I guess
you also fixed other corner cases in the process. Thanks for your
work, I think you did the right thing...
	Regards,

	Jean

