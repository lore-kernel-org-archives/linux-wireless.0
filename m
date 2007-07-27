Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mi0.bluebottle.com ([206.188.25.15]:59173 "EHLO
	mi0.bluebottle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760844AbXG0JKz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2007 05:10:55 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by mi0.bluebottle.com (8.13.1/8.13.1) with ESMTP id l6R9AssD005317
	for <linux-wireless@vger.kernel.org>; Fri, 27 Jul 2007 02:10:54 -0700
Message-Id: <200707270910.l6R9AssD005317@mi0.bluebottle.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: Axj <axjslack@bluebottle.com>, Pavel Roskin <proski@gnu.org>,
	linux-wireless@vger.kernel.org
Date: Fri, 27 Jul 2007 02:10:53 -0700
From: Axj <axjslack@bluebottle.com>
Subject: Re: Request for help...
References: <1185289332.46a61474a444c@mail.bluebottle.com>  <1185355931.3131.13.camel@debian.sh.intel.com>  <200707261511.l6QFB2jK015121@mi0.bluebottle.com>  <1185466954.14557.5.camel@dv>  <200707270634.l6R6Yh2j003295@mi1.bluebottle.com>  <1185522251.3079.66.camel@debian.sh.intel.com>  <200707270848.l6R8mqkh004526@mi1.bluebottle.com> <1185526612.3079.75.camel@debian.sh.intel.com>
In-Reply-To: <1185526612.3079.75.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Zhu Yi <yi.zhu@intel.com>:

> On Fri, 2007-07-27 at 01:48 -0700, Axj wrote:
> > Maybe.... but don't work... from the version 0.0.36 to no tell me
> 
> > 
> > Impossible to set ...etc etc.... at the first occasion I will
> post up the error code that give me...
> 
> With mac80211 you need to change wireless mode only when the
> interface
> is down.
> 
> $ ifconfig wlan0 down
> $ iwconfig wlan0 mode ad-hoc
> $ ifconfig wlan0 up
> 
> Thanks,
> -yi
> 
Yes I know.....

I tryed 

iwconfig wlan0 essid "lago" mode Ad-Hoc 
and then give me error....

----------------------------------------------------------------------
Get a free email account with anti spam protection.
http://www.bluebottle.com/tag/2

