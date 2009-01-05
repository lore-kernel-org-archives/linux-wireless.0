Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:44886 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbZAEFel (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2009 00:34:41 -0500
Date: Mon, 5 Jan 2009 06:48:30 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Andi Kleen <andi@firstfloor.org>, Michael Buesch <mb@bu3sch.de>,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: Re: rate instability in wireless stack
Message-ID: <20090105054830.GJ496@one.firstfloor.org> (sfid-20090105_063443_765612_53379AB1)
References: <20090104164649.GV496@one.firstfloor.org> <200901041736.47650.mb@bu3sch.de> <20090104174123.GW496@one.firstfloor.org> <49615465.4090604@lwfinger.net> <20090105025302.GF496@one.firstfloor.org> <49618497.50809@lwfinger.net> <20090105050248.GG496@one.firstfloor.org> <496193A6.3040608@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <496193A6.3040608@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 04, 2009 at 10:59:18PM -0600, Larry Finger wrote:
> Andi Kleen wrote:
> > On Sun, Jan 04, 2009 at 09:55:03PM -0600, Larry Finger wrote:
> > 
> > Minstrel stays constantly at 1 Mbit/s
> 
> Do you have mac80211 debugging turned on? If so, then do a
> 
> sudo cat /sys/kernel/debug/ieee80211/phyXX/stations/<MAC ADDR>/rc_stats
> 
> and post them.

Lots of zeroes.

-Andi

rate     throughput  ewma prob   this prob  this succ/attempt   success    attempts
TtP  1         0.0        0.0        0.0          1(  0)          0           0
     2         0.0        0.0        0.0          0(  0)          0           0
     5.5       0.0        0.0        0.0          0(  0)          0           0
    11         0.0        0.0        0.0          0(  0)          0           0
     6         0.0        0.0        0.0          0(  0)          0           0
     9         0.0        0.0        0.0          0(  0)          0           0
    12         0.0        0.0        0.0          0(  0)          0           0
    18         0.0        0.0        0.0          0(  0)          0           0
    24         0.0        0.0        0.0          0(  0)          0           0
    36         0.0        0.0        0.0          0(  0)          0           0
    48         0.0        0.0        0.0          0(  0)          0           0
    54         0.0        0.0        0.0          0(  0)          0           2

Total packet count::    ideal 46      lookaround 2


-- 
ak@linux.intel.com
