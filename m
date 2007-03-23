Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:38482 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753421AbXCWUdW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2007 16:33:22 -0400
Date: Fri, 23 Mar 2007 21:33:21 +0100
From: Jiri Benc <jbenc@suse.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, Linville@poseidon.net,
	John <linville@tuxdriver.com>, Michael Buesch <mb@bu3sch.de>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] mac80211: Prevent unregistering of unregistered hw
Message-ID: <20070323213321.145a7932@griffin.suse.cz>
In-Reply-To: <1174680868.4470.8.camel@johannes.berg>
References: <200703232021.26462.IvDoorn@gmail.com>
	<1174680868.4470.8.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 23 Mar 2007 21:14:28 +0100, Johannes Berg wrote:
> Hm. Maybe that's better since then there's no race like in my patch. Use
> this one instead of mine please. But it does kill the system pretty
> badly if you BUG_ON with rtnl held :)

Who cares? ;-)

Applied, thanks for the patch.

 Jiri

-- 
Jiri Benc
SUSE Labs
