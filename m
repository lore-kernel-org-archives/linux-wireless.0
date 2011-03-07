Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:44511 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752251Ab1CGN71 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2011 08:59:27 -0500
Subject: Re: WARN_ON in ieee80211_scan_completed_finish triggered
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>,
	Ben Greear <greearb@candelatech.com>
In-Reply-To: <1299503693.6739.1.camel@jlt3.sipsolutions.net> (sfid-20110307_141459_136572_4E5CF719)
References: <1299443142.1292.6.camel@marge>
	 <1299491485.3790.2.camel@jlt3.sipsolutions.net>
	 (sfid-20110307_105130_457515_FFFFFFFF997C7B78)  <1299498147.5665.3.camel@marge>
	 <1299499400.3790.8.camel@jlt3.sipsolutions.net>
	 <1299503693.6739.1.camel@jlt3.sipsolutions.net>
	 (sfid-20110307_141459_136572_4E5CF719)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Mar 2011 14:59:19 +0100
Message-ID: <1299506359.5665.14.camel@marge>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-03-07 at 14:14 +0100, Johannes Berg wrote:
> On Mon, 2011-03-07 at 13:03 +0100, Johannes Berg wrote:
> 
> > Actually ... It just looks like a race:
> 
> This should fix the race?

Seems to work.

-- 
Greetings, Michael.

