Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39022 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755715Ab2GaLZB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2012 07:25:01 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1SwAZQ-0007D7-3X
	for linux-wireless@vger.kernel.org; Tue, 31 Jul 2012 13:25:00 +0200
Message-ID: <1343733898.4474.2.camel@jlt3.sipsolutions.net> (sfid-20120731_132506_590873_D5B4F976)
Subject: Re: [PATCH] mac80211: set channel only once during auth/assoc
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Tue, 31 Jul 2012 13:24:58 +0200
In-Reply-To: <1343387391-7808-1-git-send-email-johannes@sipsolutions.net> (sfid-20120727_130957_390197_DE3CA691)
References: <1343387391-7808-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20120727_130957_390197_DE3CA691)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-07-27 at 13:09 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> There's no need to set up the channel during auth
> and again during assoc, just do it once. Currently
> this doesn't result in any changes since calling
> hw_config() with an unchanged channel will return
> early, but with the channel context work this has
> an impact on channel context assignment.

Applied.

johannes

