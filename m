Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:22728 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391AbZLKNXk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2009 08:23:40 -0500
Message-ID: <4B2247A7.7040102@nokia.com>
Date: Fri, 11 Dec 2009 15:22:47 +0200
From: Luciano Coelho <luciano.coelho@nokia.com>
MIME-Version: 1.0
To: ext Johannes Berg <johannes@sipsolutions.net>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 00/31] wl1271: patches for wk50
References: <1260531682-4695-1-git-send-email-luciano.coelho@nokia.com> <1260532494.2442.131.camel@johannes.local>
In-Reply-To: <1260532494.2442.131.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ext Johannes Berg wrote:
> On Fri, 2009-12-11 at 13:40 +0200, Luciano Coelho wrote:
>> Hi,
>>
>> These are the patches that have resulted from a one-week debug and
>> implementation camp with TI.  Mostly bug fixes and improvements, but also we
>> now added support for a new version of the firmware.
>>
>> With these patches, the driver should be pretty much functional, even though
>> there are still a couple of known bugs.
> 
> I see a lot of rate stuff here -- time to set the hw rate control flag?

Yeah, we're use the rate control stuff from the hardware more carefully now. 
But we're "still" using 2.6.32 internally, so it will be much easier for me to 
wait until the 2.6.33-rc series start (and the IEEE80211_HW_HAS_RATE_CONTROL 
gets introduced), otherwise I'll have to fork and keep maintain two separate trees.

We have a plan to start cherry-picking the latest and greatest mac80211 stuff 
from wireless-testing, but we are not doing that yet.

-- 
Cheers,
Luca.
