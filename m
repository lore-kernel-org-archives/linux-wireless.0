Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:63644 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752103AbXDIABy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Apr 2007 20:01:54 -0400
Message-ID: <461982A7.30901@lwfinger.net>
Date: Sun, 08 Apr 2007 19:02:47 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Wu <flamingice@sourmilk.net>
CC: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org, Jiri Benc <jbenc@suse.cz>
Subject: Re: [PATCH] mac80211: Report correct wireless statistics
References: <461877ea.cyxM3SSnr6WhYkjX%Larry.Finger@lwfinger.net> <200704081902.23238.flamingice@sourmilk.net> <46197B90.8050408@lwfinger.net> <200704081941.18921.flamingice@sourmilk.net>
In-Reply-To: <200704081941.18921.flamingice@sourmilk.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Wu wrote:
> On Sunday 08 April 2007 19:32, Larry Finger wrote:
>> Michael Wu wrote:
>>> Is this before or after your "bcm43xx-mac80211: Fix error in
>>> initiallizing max RSSI and max signal" patch?
>>>
>> This is after that patch.
>>
> So what do the statistics look like without that patch?

Link Quality=219/60  Signal level=-200 dBm  Noise level=-69 dBm

Larry
