Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38731 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262Ab2JOMxa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2012 08:53:30 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TNkAj-0001LV-BC
	for linux-wireless@vger.kernel.org; Mon, 15 Oct 2012 14:53:29 +0200
Message-ID: <1350305645.27801.8.camel@jlt4.sipsolutions.net> (sfid-20121015_145332_484292_BB81A2EE)
Subject: Re: [PATCH] mac80211: use __printf attribute in debugfs
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 15 Oct 2012 14:54:05 +0200
In-Reply-To: <1349018174-22867-1-git-send-email-johannes@sipsolutions.net> (sfid-20120930_171543_198899_696E1E06)
References: <1349018174-22867-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20120930_171543_198899_696E1E06)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-09-30 at 17:16 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> The internal function mac80211_format_buffer() has a
> printf-style argument list, so add the attribute to
> have gcc verify that list.

Applied the fixed version.

johannes

