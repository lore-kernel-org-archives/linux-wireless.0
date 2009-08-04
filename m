Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:50117 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933440AbZHDW3I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2009 18:29:08 -0400
Message-ID: <4A78B632.1070404@gmx.de>
Date: Wed, 05 Aug 2009 00:29:06 +0200
From: Joerg Albert <jal2@gmx.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] cfg80211: clear SSID on disconnect
References: <1249311832.4561.2.camel@johannes.local>	 <loom.20090804T064513-963@post.gmane.org>	 <1249370029.9415.1.camel@johannes.local>	 <loom.20090804T082338-799@post.gmane.org> <1249388766.9415.6.camel@johannes.local>
In-Reply-To: <1249388766.9415.6.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/04/2009 02:26 PM, Johannes Berg wrote:
> On Tue, 2009-08-04 at 08:24 +0000, Joerg Albert wrote:
>> Johannes Berg <johannes@...> writes:
>>
>>
>>  
>>> Aha. yes, the same assignment is _also_ missing in
>>> __cfg80211_connect_result(), can you add it there manually (in the
>>> status != WLAN_STATUS_SUCCESS block at the end) and see what happens?
>> Yes, that helped in my case.
> 
> The v2 patch I posted to this thread should fix the issue then, and also
> fix two more places where it could occur.

Yes, the v2 patch worked well, too.
