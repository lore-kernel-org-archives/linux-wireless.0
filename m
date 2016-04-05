Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53474 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757870AbcDEJ1A (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2016 05:27:00 -0400
Message-ID: <1459848417.18188.24.camel@sipsolutions.net> (sfid-20160405_112713_606892_C504D5BA)
Subject: Re: [PATCH] mac80211: Fix BW upgrade for TDLS peers
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org, Ilan Peer <ilan.peer@intel.com>
Date: Tue, 05 Apr 2016 11:26:57 +0200
In-Reply-To: <1457436931-2330-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1457436931-2330-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-03-08 at 13:35 +0200, Emmanuel Grumbach wrote:
> From: Ilan Peer <ilan.peer@intel.com>
> 
> It is possible that the station is connected to an AP
> with bandwidth of 80+80MHz or 160MHz. In such cases
> there is no need to perform an upgrade as the maximal
> supported bandwidth is 80MHz.
> 
> In addition, when upgrading and setting center_freq1
> and bandwidth to 80MHz also set center_freq2 to 0.
> 
Applied.

johannes
