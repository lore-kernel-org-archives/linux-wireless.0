Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40169
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753282AbYFNDrR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jun 2008 23:47:17 -0400
Date: Fri, 13 Jun 2008 20:47:17 -0700 (PDT)
Message-Id: <20080613.204717.121643605.davem@davemloft.net> (sfid-20080614_054726_955327_431911E2)
To: linville@tuxdriver.com
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull request: wireless-next-2.6 2008-06-13
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080614032116.GA9171@tuxdriver.com>
References: <20080613214114.GA1077@tuxdriver.com>
	<20080614032116.GA9171@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 13 Jun 2008 23:21:16 -0400

> On Fri, Jun 13, 2008 at 05:41:14PM -0400, John W. Linville wrote:
> 
> > Another slew of updates intended for 2.6.27...please let me know if
> > there are problems!
> 
> If you are not in a hurry, you may want to delay this one.  One of
> the mac80211 cleanup patches has a one-line endian problem.  Beer and
> fatigue suggest that I should look at reworking the tree tomorrow
> instead of now.

That's fine.

I'm doing the linux-2.6 --> net-2.6 --> net-next-2.6 merging
right now anyways.
