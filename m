Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39391 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893AbYIKIbU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2008 04:31:20 -0400
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18632.55008.411078.289830@gargle.gargle.HOWL> (sfid-20080911_103124_770055_BB6CEFD1)
Date: Thu, 11 Sep 2008 13:59:20 +0530
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [PATCH 00/18] mac80211 cleanups and fixes
In-Reply-To: <20080910220145.707263000@sipsolutions.net>
References: <20080910220145.707263000@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
 > Hi,
 > 
 > Here's another series to clean up a bit including a few things that
 > I've been meaning to do for a long time:
 > 
 >  * mac80211: move ieee80211_set_freq to utils
 >  * mac80211: make bridge_packets a virtual interface option
 >  * mac80211: clean up some comments
 >  * mac80211: inform driver of basic rateset
 >  * mac80211: use nl80211 interface types
 > 
 > I'd been talking with Sujith about this one:
 > 
 >  * mac80211: share STA information with driver
 > 
 > and decided to just do it; as it stands it's not very useful
 > but I expect it to be used soon, if not we can remove the
 > EXPORT_SYMBOL again.
 > 

This would be very useful for ath9k. Making use of the
private area for each STA can enable removal of the node list
that is maintained currently.

Sujith
