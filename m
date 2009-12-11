Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:53558 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbZLKMQP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2009 07:16:15 -0500
Message-ID: <4B223804.9040107@nokia.com>
Date: Fri, 11 Dec 2009 14:16:04 +0200
From: Luciano Coelho <luciano.coelho@nokia.com>
MIME-Version: 1.0
To: ext Johannes Berg <johannes@sipsolutions.net>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 07/31] wl1271: fix tx power setting function
References: <1260531682-4695-1-git-send-email-luciano.coelho@nokia.com>	 <1260531682-4695-8-git-send-email-luciano.coelho@nokia.com> <1260532297.2442.126.camel@johannes.local>
In-Reply-To: <1260532297.2442.126.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ext Johannes Berg wrote:
> On Fri, 2009-12-11 at 13:40 +0200, Luciano Coelho wrote:
>> The wl1271 firmware supports maximun 25.5dBm, so the driver was returning
>> -EINVALID to anything above that.  The new mac80211 stack uses 27dBm as
>> default TX power, so we were never setting this correctly.
> 
> ??
> Just indicate a max of 25 in your channel registration max_power.
> cfg80211/mac80211/regulatory code will not go above that.

Oh? I missed this configuration possibility.  I'll fix this and send v2 soon.

So, John, please wait for my patchset v2 ;)

-- 
Cheers,
Luca.
