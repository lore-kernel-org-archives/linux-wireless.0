Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59995 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab2FYIGl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jun 2012 04:06:41 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Sj4Jk-0006va-2V
	for linux-wireless@vger.kernel.org; Mon, 25 Jun 2012 10:06:40 +0200
Message-ID: <1340611597.4589.7.camel@jlt3.sipsolutions.net> (sfid-20120625_100645_795855_BCBF8F0E)
Subject: Re: [RFC 0/17] add P2P Device support
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 25 Jun 2012 10:06:37 +0200
In-Reply-To: <1340117456-10154-1-git-send-email-johannes@sipsolutions.net> (sfid-20120619_165120_048461_9B077046)
References: <1340117456-10154-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20120619_165120_048461_9B077046)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-06-19 at 16:50 +0200, Johannes Berg wrote:
> In order to support different P2P Device addresses, I've
> been working on patches to support a P2P Device abstraction.
> 
> A big part of it is changing nl80211 to be able to identify
> wireless_dev structs by their new wdev_id rather than only
> by interface index.
> 
> Then there's code to actually make some APIs netdev independent
> and finally to actually create a P2P Device abstraction in both
> cfg80211 and mac80211.

FWIW, if anyone was curious, I consider this code pretty much done and
have done some testing on it, but we're working on the corresponding
wpa_s changes to use it and that I don't want to commit these patches
(except for the first few cleanups that are already in John's tree)
before we've had more testing with the entire system including wpa_s.

johannes

