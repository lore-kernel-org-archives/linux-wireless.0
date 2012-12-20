Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51550 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069Ab2LTLgK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Dec 2012 06:36:10 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TleQ5-0007ac-8o
	for linux-wireless@vger.kernel.org; Thu, 20 Dec 2012 12:36:09 +0100
Message-ID: <1356003391.10029.8.camel@jlt4.sipsolutions.net> (sfid-20121220_123614_077143_F46C8DB5)
Subject: Re: [PATCH 0/4] mac80211: bss_info_changed cleanups
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Thu, 20 Dec 2012 12:36:31 +0100
In-Reply-To: <1355492806-31673-1-git-send-email-johannes@sipsolutions.net> (sfid-20121214_144629_183869_9F7A9072)
References: <1355492806-31673-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121214_144629_183869_9F7A9072)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-12-14 at 14:46 +0100, Johannes Berg wrote:
> The recalculations going on in the function are rather odd
> and hard to follow, replace them with explicit interface
> type dependent handling where needed at all

applied all

johannes

