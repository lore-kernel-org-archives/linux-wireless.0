Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45112 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299Ab1ECIbW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 04:31:22 -0400
Subject: Re: WARNING: at net/mac80211/wep.c:101
 ieee80211_wep_add_iv+0x52/0x150 [mac80211]()
From: Johannes Berg <johannes@sipsolutions.net>
To: Fabio Rossi <rossi.f@inwind.it>
Cc: linux-wireless@vger.kernel.org,
	Yogesh Ashok Powar <yogeshp@marvell.com>
In-Reply-To: <201105022257.11767.rossi.f@inwind.it> (sfid-20110503_010442_651315_E03E0ED0)
References: <201105022257.11767.rossi.f@inwind.it>
	 (sfid-20110503_010442_651315_E03E0ED0)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 May 2011 10:31:19 +0200
Message-ID: <1304411479.3720.1.camel@jlt3.sipsolutions.net> (sfid-20110503_103126_234473_709B434C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-05-02 at 22:57 +0200, Fabio Rossi wrote:
> I get the following WARNING:
> 
> WARNING: at net/mac80211/wep.c:101 ieee80211_wep_add_iv+0x52/0x150 [mac80211]
> ()

Once, or consistently? Must be caused by 

commit aac6af5534fade2b18682a0b9efad1a6c04c34c6
Author: Yogesh Ashok Powar <yogeshp@marvell.com>
Date:   Wed Apr 27 18:40:29 2011 +0530

    mac80211: Skip tailroom reservation for full HW-crypto devices

Yogesh, please investigate how this happens.

johannes

