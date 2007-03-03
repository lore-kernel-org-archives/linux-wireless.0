Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49452 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbXCCTxi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Mar 2007 14:53:38 -0500
Subject: Re: question: /sys/class/net/*/wireless
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jkmaline@cc.hut.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20070303174008.GA5081@jm.kir.nu>
References: <1172920691.4966.6.camel@johannes.berg>
	 <1172921257.4966.12.camel@johannes.berg>  <20070303174008.GA5081@jm.kir.nu>
Content-Type: text/plain
Date: Sat, 03 Mar 2007 20:53:33 +0100
Message-Id: <1172951614.4277.2.camel@localhost>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sa, 2007-03-03 at 09:40 -0800, Jouni Malinen wrote:

> Well, it could be added to the schedule, but taken into account how
> widely used /proc/net/wireless and wireless extensions are in user space
> programs, I don't think this should be removed anytime soon, if ever. I
> would object removal for at least the next five years..

Will you write the compat code for cfg80211 for it? :P

johannes

