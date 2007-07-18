Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57956
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755257AbXGRWct (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jul 2007 18:32:49 -0400
Date: Wed, 18 Jul 2007 15:32:48 -0700 (PDT)
Message-Id: <20070718.153248.82378078.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Please pull 'upstream-davem' branch of wireless-2.6
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070718153449.GA6625@tuxdriver.com>
References: <20070718021607.GB26907@tuxdriver.com>
	<20070717.201716.112622844.davem@davemloft.net>
	<20070718153449.GA6625@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 18 Jul 2007 11:34:49 -0400

> On Tue, Jul 17, 2007 at 08:17:16PM -0700, David Miller wrote:
> > From: "John W. Linville" <linville@tuxdriver.com>
> > Date: Tue, 17 Jul 2007 22:16:07 -0400
> > 
> > > A few more for 2.6.23...individual patches available here:
> > > 
> > >   http://www.kernel.org/pub/linux/kernel/people/linville/wireless-2.6/upstream-davem
> > 
> > What about this warning which I reported to you right after the last
> > merge?  Did this get fixed?
> > 
> > net/mac80211/ieee80211.c:4989: warning: comparison of distinct pointer types lacks a cast
> > 
> > Please fix that up first, then I'll pull from your tree.
> 
> Fair enough! :-)

As I pointed out to Jiri, you need to spell out the complete type
warning fix, rather than just "unsigned".
