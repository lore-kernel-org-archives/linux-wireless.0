Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41168 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462Ab2J3IdC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Oct 2012 04:33:02 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TT7Ft-00078D-DB
	for linux-wireless@vger.kernel.org; Tue, 30 Oct 2012 09:33:01 +0100
Message-ID: <1351586015.10097.7.camel@jlt4.sipsolutions.net> (sfid-20121030_093307_847670_DA7B8C57)
Subject: Re: [PATCH] mac80211: use a counter for remain-on-channel cookie
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Tue, 30 Oct 2012 09:33:35 +0100
In-Reply-To: <1351261056-8284-1-git-send-email-johannes@sipsolutions.net> (sfid-20121026_161712_193279_E9BF90FC)
References: <1351261056-8284-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121026_161712_193279_E9BF90FC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-10-26 at 16:17 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Instead of using the pointer which can be re-used
> fairly quickly due to allocator patterns and then
> makes debugging difficult, maintain a counter and
> use its value. Since it's a 64-bit value it can't
> really wrap, but catch that case anyway since it
> most likely points to a bug somewhere.
> 

Applied.

johannes

