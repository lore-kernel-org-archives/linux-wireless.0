Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:47759 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757856AbXHKDSf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2007 23:18:35 -0400
Message-ID: <46BD2A89.8050906@lwfinger.net>
Date: Fri, 10 Aug 2007 22:18:33 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>, Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 4/4] mac80211: remove radar stuff
References: <20070810220544.321975000@sipsolutions.net> <20070810220634.450509000@sipsolutions.net>
In-Reply-To: <20070810220634.450509000@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> Unused in drivers, userspace and mac80211.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---

Won't 802.11a drivers need this? If so, does it hurt to leave it in for now?

Larry
