Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46968 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704Ab3BELvR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2013 06:51:17 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1U2h3U-0002lz-F1
	for linux-wireless@vger.kernel.org; Tue, 05 Feb 2013 12:51:16 +0100
Message-ID: <1360065101.8376.6.camel@jlt4.sipsolutions.net> (sfid-20130205_125119_967470_196DF8DB)
Subject: Re: [RFC] cfg80211: configuration for WoWLAN over TCP
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Tue, 05 Feb 2013 12:51:41 +0100
In-Reply-To: <1360062367-15970-1-git-send-email-johannes@sipsolutions.net> (sfid-20130205_120550_522641_5234F940)
References: <1360062367-15970-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130205_120550_522641_5234F940)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-02-05 at 12:06 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Intel Wireless devices are able to make a TCP connection
> after suspending, sending some data and waking up when
> the connection receives wakeup data (or breaks). Add the
> WoWLAN configuration and feature advertising API for it.

Heh, ok, so Fengguang Wu's build testing reported that it doesn't always
build ... yep, some code relies on CONFIG_INET or so, will have to fix
that.

johannes

