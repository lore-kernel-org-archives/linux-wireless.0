Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54800 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766Ab3AaM7u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2013 07:59:50 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1U0tk4-0000C2-MJ
	for linux-wireless@vger.kernel.org; Thu, 31 Jan 2013 13:59:48 +0100
Message-ID: <1359637213.8415.7.camel@jlt4.sipsolutions.net> (sfid-20130131_135953_931317_8AC30FB0)
Subject: Re: [PATCH] cfg80211/mac80211: support reporting wakeup reason
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Thu, 31 Jan 2013 14:00:13 +0100
In-Reply-To: <1359381367-9577-1-git-send-email-johannes@sipsolutions.net> (sfid-20130128_145550_208423_371C5F67)
References: <1359381367-9577-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130128_145550_208423_371C5F67)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-01-28 at 14:56 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> When waking up from WoWLAN, it is useful to know
> what triggered the wakeup. Support reporting the
> wakeup reason(s) in cfg80211 (and a pass-through
> in mac80211) to allow userspace to know.

Applied.

johannes

