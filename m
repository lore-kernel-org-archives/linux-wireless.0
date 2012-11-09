Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53925 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464Ab2KIQbh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2012 11:31:37 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TWrUW-0000CO-Tr
	for linux-wireless@vger.kernel.org; Fri, 09 Nov 2012 17:31:37 +0100
Message-ID: <1352478734.9238.16.camel@jlt4.sipsolutions.net> (sfid-20121109_173140_285725_C0E032A6)
Subject: Re: [PATCH] mac80211: don't send null data packet when not
 associated
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Fri, 09 Nov 2012 17:32:14 +0100
In-Reply-To: <1352380122-18384-1-git-send-email-johannes@sipsolutions.net> (sfid-20121108_140826_775231_430ADDB3)
References: <1352380122-18384-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121108_140826_775231_430ADDB3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-11-08 at 14:08 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> On resume or firmware recovery, mac80211 sends a null
> data packet to see if the AP is still around and hasn't
> disconnected us. However, it always does this even if
> it wasn't even connected before, leading to a warning
> in the new channel context code. Fix this by checking
> that it's associated.
> 
> Change-Id: I8b77a0b3d3ece9ed509b688711c43aeb5be74348

Applied, but I deleted the stupid change-id and added a Cc stable tag
instead :)

johannes

