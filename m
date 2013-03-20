Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43863 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab3CTVVJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Mar 2013 17:21:09 -0400
Message-ID: <1363814465.9284.8.camel@jlt4.sipsolutions.net> (sfid-20130320_222114_133976_381F9FE7)
Subject: Re: pull-request: mac80211 2013-03-19
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 20 Mar 2013 22:21:05 +0100
In-Reply-To: <1363723052.8336.6.camel@jlt4.sipsolutions.net> (sfid-20130319_205755_751711_D4ADDEEC)
References: <1363723052.8336.6.camel@jlt4.sipsolutions.net>
	 (sfid-20130319_205755_751711_D4ADDEEC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-03-19 at 20:57 +0100, Johannes Berg wrote:
>       cfg80211: always check for scan end on P2P device

Ugh, consider this withdrawn. I hadn't tested with lockdep and didn't
notice the locking issue this introduces :(

johannes

