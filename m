Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53836 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611Ab1IEMMA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Sep 2011 08:12:00 -0400
Subject: Re: [RFC 5/5] nl80211/cfg80211: adding intermediate scan result
 filter.
From: Johannes Berg <johannes@sipsolutions.net>
To: Victor Goldenshtein <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1315224151-16552-6-git-send-email-VictorG@ti.com>
References: <1315224151-16552-1-git-send-email-VictorG@ti.com>
	 <1315224151-16552-6-git-send-email-VictorG@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Sep 2011 14:11:56 +0200
Message-ID: <1315224716.4075.13.camel@jlt3.sipsolutions.net> (sfid-20110905_141202_596786_080714CD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-09-05 at 15:02 +0300, Victor Goldenshtein wrote:
> User might want to be notified with intermediate scan results only
> above some minimal RSSI. Adding new NL80211_ATTR_IM_SCAN_RESULT_MIN_RSSI
> u32 attribute for the intermediate scan results  RSSI filtering mechanism,
> which will significantly reduce unnecessary Kernel-User traffic.
> It might be optionally enabled during NL80211_CMD_TRIGGER_SCAN.

I think unicasting the responses will be a better reduction in traffic
-- is this really worth the complexity?


Also -- I don't like your subjects much. IMHO they shouldn't have a . at
the end and should worded in "simple present" rather than "present
continuous" tense [1]: "add intermediate ..." rather than "adding
intermediate".

johannes

[1] http://www.englishpage.com/verbpage/simplepresent.html

