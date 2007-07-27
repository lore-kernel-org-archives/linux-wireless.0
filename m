Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:64716 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109AbXG0I7A (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2007 04:59:00 -0400
Subject: Re: Request for help...
From: Zhu Yi <yi.zhu@intel.com>
To: Axj <axjslack@bluebottle.com>
Cc: Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
In-Reply-To: <200707270848.l6R8mqkh004526@mi1.bluebottle.com>
References: <1185289332.46a61474a444c@mail.bluebottle.com>
	 <1185355931.3131.13.camel@debian.sh.intel.com>
	 <200707261511.l6QFB2jK015121@mi0.bluebottle.com>
	 <1185466954.14557.5.camel@dv>
	 <200707270634.l6R6Yh2j003295@mi1.bluebottle.com>
	 <1185522251.3079.66.camel@debian.sh.intel.com>
	 <200707270848.l6R8mqkh004526@mi1.bluebottle.com>
Content-Type: text/plain
Date: Fri, 27 Jul 2007 16:56:52 +0800
Message-Id: <1185526612.3079.75.camel@debian.sh.intel.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2007-07-27 at 01:48 -0700, Axj wrote:
> Maybe.... but don't work... from the version 0.0.36 to no tell me 
> 
> Impossible to set ...etc etc.... at the first occasion I will post up the error code that give me...

With mac80211 you need to change wireless mode only when the interface
is down.

$ ifconfig wlan0 down
$ iwconfig wlan0 mode ad-hoc
$ ifconfig wlan0 up

Thanks,
-yi
