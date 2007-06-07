Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dhost002-30.dex002.intermedia.net ([64.78.21.74]:35823 "EHLO
	dhost002-30.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751405AbXFGUxt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2007 16:53:49 -0400
From: "Jouni Malinen" <jkm@devicescape.com>
Date: Thu, 7 Jun 2007 13:54:31 -0700
To: Jiri Benc <jbenc@suse.cz>
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>
Subject: Re: [PATCH] mac80211: rc80211_lowest, a dumb rate control algorithm
Message-ID: <20070607205431.GD26739@devicescape.com>
References: <20070607222113.0f752bf8@griffin.suse.cz> <20070607222210.1a445cd7@griffin.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070607222210.1a445cd7@griffin.suse.cz>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 07, 2007 at 10:22:10PM +0200, Jiri Benc wrote:
> This allows the lowest rate to be used all time.

> +MODULE_DESCRIPTION("Forced 1 mbps rate control module for mac80211");

That "1 mbps" should be "lowest supported". In case of 802.11a, this is
likely to be 6 Mbps.

-- 
Jouni Malinen                                            PGP id EFC895FA
