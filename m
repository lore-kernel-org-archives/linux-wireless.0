Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48182 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab2LLKpr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2012 05:45:47 -0500
Message-ID: <1355309167.9708.0.camel@jlt4.sipsolutions.net> (sfid-20121212_114552_037402_DC9A041B)
Subject: Re: [PATCH] mac80211: modify max_nullfunc parameter
From: Johannes Berg <johannes@sipsolutions.net>
To: "Chen, Chien-Chia" <machen@suse.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	users@rt2x00.serialmonkey.com
Date: Wed, 12 Dec 2012 11:46:07 +0100
In-Reply-To: <1355308099-18193-1-git-send-email-machen@suse.com> (sfid-20121212_112818_604239_5BEF48FB)
References: <1355308099-18193-1-git-send-email-machen@suse.com>
	 (sfid-20121212_112818_604239_5BEF48FB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-12-12 at 18:28 +0800, Chen, Chien-Chia wrote:
> From: Chen, Chien-Chia <matt680209@gmail.com>
> 
> This parameter default is 2. But it is easy to cause my station 
> losing the connection with AP. After I tune it to 20. It improves 
> much when using rt2x00 and Linksys WRT160N V3 AP router.

I'm not very keen on taking a driver specific change into mac80211 ...
maybe the driver shouldn't lose so many frames instead?

johannes

