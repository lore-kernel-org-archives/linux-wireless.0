Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.digadd.de ([195.47.195.236]:36756 "EHLO mx2.digadd.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755638Ab0E1Lee (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 May 2010 07:34:34 -0400
Message-ID: <4BFFAA26.6080602@digadd.de>
Date: Fri, 28 May 2010 13:33:58 +0200
From: "Christian P. Schmidt" <schmidt@digadd.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: reinette chatre <reinette.chatre@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Problems connectring to an AP with Acer Aspire Revo
References: <4BF795EB.9070902@digadd.de>	 <1274729665.2091.15280.camel@rchatre-DESK>  <4BFD1ED0.9050309@digadd.de>	 <1275003105.2091.20102.camel@rchatre-DESK>  <4BFF9B93.5010308@digadd.de>	 <1275043274.3909.71.camel@jlt3.sipsolutions.net>	 <4BFF9FC6.4030101@digadd.de>	 <1275044074.3909.72.camel@jlt3.sipsolutions.net> <4BFFA490.90600@digadd.de> <1275045843.3909.92.camel@jlt3.sipsolutions.net>
In-Reply-To: <1275045843.3909.92.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/28/2010 01:24 PM, Johannes Berg wrote:
> On Fri, 2010-05-28 at 13:10 +0200, Christian P. Schmidt wrote:
> 
> Ok that sounds like you have antennas.

Good :)

>> Well, maybe you can answer me a question I never dared to ask because I
>> felt stupid... I can't take the Intel card online with only ifconfig or
>> ip? I always get "unknown error 132" on ifconfig wlan0 up / ip link set
>> wlan0 up...
> 
> Huh. This means that the device detected rfkill. But you previously
> posted logs that showed it trying to associate, which cannot happen. And
> you can't even scan when you can't bring the device up??
> 
> Maybe try the rfkill tool:
> http://wireless.kernel.org/en/users/Documentation/rfkill

Ok, so something in gentoo's network init skripts unblocks the card when
you bring it online via the skript. When I don't use the skript it's
soft blocked, when running it's unblocked. I did not even have rfkill
installed at that point.

Good, that problem's gone, it's soft blocked when shut down and needs
rfkill unblock all prior to ifconfig up. Thanks for the heads up, but
that doesn't change the problem.

Regards,
Christian
