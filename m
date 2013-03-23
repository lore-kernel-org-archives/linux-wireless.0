Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from elasmtp-spurfowl.atl.sa.earthlink.net ([209.86.89.66]:47948
	"EHLO elasmtp-spurfowl.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751820Ab3CWUAj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Mar 2013 16:00:39 -0400
Date: Sat, 23 Mar 2013 16:00:38 -0400
From: Marco Fonseca <marco@tampabay.rr.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: carl9170: monitor mode hangs due to channel changes
Message-ID: <20130323200037.GA8332@192.168.1.10> (sfid-20130323_210045_275051_5508DA6F)
References: <20130320205013.GA3462@192.168.1.10>
 <201303202309.47596.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201303202309.47596.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As far as I can tell those patches fixed it.  I wasn't paying
attention and applied both patches though.  My environment
is a little different today and I will test some more on Monday.

If you think it would help, I can test the patches individually.

Thanks!

Marco

On Wed, Mar 20, 2013 at 11:09:47PM +0100, Christian Lamparter wrote:
> Hello,
> 
> On Wednesday, March 20, 2013 09:50:13 PM Marco Fonseca wrote:
> > I'm seeing a problem with the carl driver. If I change channels
> > repeatedly on the 2.4ghz band, monitoring (e.g. tcpdump) will
> > eventually halt.  I've seen this on various versions of the carl
> > driver/firmware (both from 1.9.4 to 1.9.7)
> thanks for reporting this. You could try either of the attached
> patch and test if it alleviate the issue. If the patches do help
> then the problem is caused by rf/phy (code) [which is a problem
> since the rf/phy parts are taken from the vendor driver as we
> have no docs or specs for it].
> 
> Regards,
> 	Chr
