Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:17954 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbYF0EO4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jun 2008 00:14:56 -0400
To: "Tomas Winkler" <tomasw@gmail.com>
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Samuel Ortiz" <samuel@sortiz.org>,
	=?iso-8859-15?Q?Miguel_Bot=F3n?= <mboton.lkml@gmail.com>,
	linux-wireless@vger.kernel.org, yi.zhu@intel.com
Subject: Re: [PATCH 1/2] mac80211: add power management support
References: <200711161929.36283.mboton.lkml@gmail.com>
	<200711161953.26801.mboton.lkml@gmail.com>
	<20080626174058.GA3063@sortiz.org>
	<20080626175507.GA23142@tuxdriver.com>
	<1214504623.3783.22.camel@johannes.berg>
	<1ba2fa240806261451n53e5cb8an70aad7b072121c2e@mail.gmail.com>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Fri, 27 Jun 2008 07:14:14 +0300
In-Reply-To: <1ba2fa240806261451n53e5cb8an70aad7b072121c2e@mail.gmail.com> (ext Tomas Winkler's message of "Fri\, 27 Jun 2008 00\:51\:57 +0300")
Message-ID: <87wskb7bvt.fsf@nokia.com> (sfid-20080627_061500_858076_063FCB1F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tomas Winkler <tomasw@gmail.com> writes:

> This is why we have currently implemented in iwlwif sysfs.
>
> /sys/class/net/wlanX/devices/power_level
> there are defined 6 power levels
> 0 - CAM mode (Continuous Aware Mode)
> 6 - AUTO
> 1 to 5 levels that specifies power save aggressiveness  empirically developed.
> AUTO - depends on system power source/level
> system power level is AC or BATTERY  - currently we do not have
> anything that tells us whether we run on battery or ac.
> Other factor is association state.
>
> This can be expressed as
> iwconfig power saving 1..5
> iwconfig power off - > CAM mode
> iwconfig power auto - this is unfortunately not defined by iwconfig
>
> If this acceptable we can submit the patch

Sounds good to me, at least. It would be nice to have PSM support to
mac80211.

-- 
Kalle Valo
