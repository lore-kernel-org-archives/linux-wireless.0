Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:60009 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756022Ab1CBRRn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2011 12:17:43 -0500
Subject: Re: Powersave broken on p54
From: Michael Buesch <mb@bu3sch.de>
To: Christian Lamparter <chunkeey@googlemail.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <201103021813.52719.chunkeey@googlemail.com> (sfid-20110302_181438_600050_FFFFFFFF80E6967A)
References: <1299003142.6461.12.camel@maggie>
	 <201103021813.52719.chunkeey@googlemail.com>
	 (sfid-20110302_181438_600050_FFFFFFFF80E6967A)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Mar 2011 18:17:37 +0100
Message-ID: <1299086257.13604.17.camel@marge>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-03-02 at 18:13 +0100, Christian Lamparter wrote:
> sure there was the rssi->dbm update (I hope you've already updated
> your eeprom image.)

What change to the eeprom is needed? My eeprom doesn't
contain any rssi info (see recent NULL ptr fix).

> No idea, it looks like the ps-poll is broken, because
> "iwconfig wlanX power timeout 10" fixes the long delays
> almost immediately. [let's see if there's more]

So maybe it's a generic mac80211 bug? Are there other
devices with PS issues?

-- 
Greetings, Michael.

