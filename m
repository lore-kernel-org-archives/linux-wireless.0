Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55772 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760920Ab3B1WRp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Feb 2013 17:17:45 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1UBBnM-0003Og-75
	for linux-wireless@vger.kernel.org; Thu, 28 Feb 2013 23:17:44 +0100
Message-ID: <1362089861.8330.11.camel@jlt4.sipsolutions.net> (sfid-20130228_231748_700306_E9E60259)
Subject: Re: [PATCH] cfg80211: prohibit zero keepalive interval
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Thu, 28 Feb 2013 23:17:41 +0100
In-Reply-To: <1361913166-17570-1-git-send-email-johannes@sipsolutions.net> (sfid-20130226_221256_413864_51CD2849)
References: <1361913166-17570-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130226_221256_413864_51CD2849)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-02-26 at 22:12 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> It's not useful to specify a 0 keepalive interval, this
> would send too much data. Prohibit this to also avoid
> device issues.

Applied.

johannes

