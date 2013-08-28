Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:60159 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753829Ab3H1RA7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Aug 2013 13:00:59 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1VEj73-0005Lk-JF
	for linux-wireless@vger.kernel.org; Wed, 28 Aug 2013 19:00:57 +0200
Message-ID: <1377709250.13797.13.camel@jlt4.sipsolutions.net> (sfid-20130828_190102_762760_A9BDE846)
Subject: Re: [PATCH] mac80211: add ieee80211_iterate_active_interfaces_rtnl()
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Wed, 28 Aug 2013 19:00:50 +0200
In-Reply-To: <1377605145-21353-1-git-send-email-johannes@sipsolutions.net> (sfid-20130827_140558_058283_87FE2375)
References: <1377605145-21353-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130827_140558_058283_87FE2375)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-08-27 at 14:05 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> If it is needed to disconnect multiple virtual interfaces after
> (WoWLAN-) suspend, the most obvious approach would be to iterate
> all interfaces by calling ieee80211_iterate_active_interfaces()
> and then call ieee80211_resume_disconnect() for each one. This
> is what the iwlmvm driver does.

Applied.

johannes

