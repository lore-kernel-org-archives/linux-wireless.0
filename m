Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:44998 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753909AbYILSqh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Sep 2008 14:46:37 -0400
Message-ID: <48CAB90C.5090302@lwfinger.net> (sfid-20080912_204640_877147_4BFF495C)
Date: Fri, 12 Sep 2008 13:46:36 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: John Linville <linville@tuxdriver.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: The new regulatory code kills my wireless
References: <48CAA8D6.1030605@lwfinger.net> <20080912174036.GC6134@tesla>
In-Reply-To: <20080912174036.GC6134@tesla>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> On Fri, Sep 12, 2008 at 10:37:26AM -0700, Larry Finger wrote:
>> After pulling the latest git from wireless-testing, my wireless
>> failed. I bisected this to be commit
>> 544ec9a11fdef5142a76a8eb4b186a80a272c035, "cfg80211: Add new wireless
>> regulatory infrastructure".
--snip--
> 
> Please apply johill's patch, "[PATCH] cfg80211: fix regdomain macro"

That patch fixed the problem. For someone following this thread, the 
patch is by Johannes Berg.

I can understand when some oddball hardware causes a corner-case 
problem - I just had one with an ancient laptop - but somehow, I 
expect that most people will use the old regulatory option, at least 
for a while. Shouldn't the most rudimentary testing have caught this 
problem?

Larry
