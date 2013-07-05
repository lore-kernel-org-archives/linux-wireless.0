Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:55854 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757074Ab3GEIyZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jul 2013 04:54:25 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20950.35066.679067.727089@gargle.gargle.HOWL> (sfid-20130705_105429_021325_84BE7204)
Date: Fri, 5 Jul 2013 14:21:06 +0530
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Handle zero RTS threshold
In-Reply-To: <1373008522.8548.1.camel@jlt4.sipsolutions.net>
References: <1373003143-29211-1-git-send-email-sujith@msujith.org>
	<1373008522.8548.1.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> Maybe we should set it to 0xffffffff in cfg80211 to make it simpler for
> drivers?

The patch is broken, please disregard it.

Sujith
