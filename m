Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:59394 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1766750AbXDSPDX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2007 11:03:23 -0400
Message-ID: <4627854B.7000300@lwfinger.net>
Date: Thu, 19 Apr 2007 10:05:47 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Jiri Benc <jbenc@suse.cz>
CC: wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>, bcm43xx-dev@berlios.de,
	Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH 0/4] mac80211 and drivers: Improve wireless statistics
References: <46211955.4080006@lwfinger.net> <20070419163453.5d792085@griffin.suse.cz>
In-Reply-To: <20070419163453.5d792085@griffin.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jiri Benc wrote:
> 
> The whole signal reporting in WE looks like a mess to me. It seems that
> no renaming could help here, I'm afraid - the names you consider better
> others consider worse.
> 
> Let's leave it as is, and return to it when converting mac80211 to use
> cfg80211. With a bit of luck it would be no issue then :-)

I have already decided to leave the whole mess alone. I will patch bcm43xx-mac80211 to conform to 
what is currently in mac80211 so that reasonable values are seen by the users.

Larry
