Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52058 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab2IGISc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 04:18:32 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1T9tlm-0004vq-SR
	for linux-wireless@vger.kernel.org; Fri, 07 Sep 2012 10:18:31 +0200
Message-ID: <1347005949.4256.2.camel@jlt4.sipsolutions.net> (sfid-20120907_101836_073613_A242BAFB)
Subject: Re: [PATCH] mac80211: disconnect if channel switch fails
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Fri, 07 Sep 2012 10:19:09 +0200
In-Reply-To: <1346943877-24194-1-git-send-email-johannes@sipsolutions.net> (sfid-20120906_170407_756731_24F5E2E9)
References: <1346943877-24194-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20120906_170407_756731_24F5E2E9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-09-06 at 17:04 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Disconnect from the AP if channel switching in the
> driver failed or if the new channel is unavailable.

Applied.

johannes

