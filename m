Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.225]:29497 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759280AbXKTUHL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2007 15:07:11 -0500
Received: by nz-out-0506.google.com with SMTP id s18so1708621nze
        for <linux-wireless@vger.kernel.org>; Tue, 20 Nov 2007 12:07:10 -0800 (PST)
Subject: Re: [PATCH 3/4] o80211s: (mac80211s) basic mesh interface support
From: Luis Carlos Cobo <luisca@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, hiertz <hiertz@ieee.org>
In-Reply-To: <1195171992.8147.81.camel@johannes.berg>
References: <473516ee.26d7720a.3f57.ffff8233@mx.google.com>
	 (sfid-20071110_022658_985099_309C7497)  <1195171992.8147.81.camel@johannes.berg>
Content-Type: text/plain
Date: Tue, 20 Nov 2007 12:06:59 -0800
Message-Id: <1195589219.7026.19.camel@localhost> (sfid-20071120_200717_090698_3615BF42)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2007-11-16 at 01:13 +0100, Johannes Berg wrote:
> Btw. I just reviewed draft 1.0 (currently have no access to later ones)
> and it talks a lot about probe responses but never when to send them. Is
> this clarified later and should it be implemented here? Or is that part
> of the "mesh AP" stuff that is removed?

Probe responses are sent as usual (in response of a probe request :-) )
Either beacons or probes request/responses are needed to detect
neighbors and then start the peer link establishment protocol. So yes,
probe responses should and will be implemented, even though it would
possible to operate just with beacons.

-- 
Luis Carlos Cobo Rus       GnuPG ID: 44019B60
cozybit Inc.


