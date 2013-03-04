Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42200 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758150Ab3CDPh5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 10:37:57 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1UCXSe-0004fV-46
	for linux-wireless@vger.kernel.org; Mon, 04 Mar 2013 16:37:56 +0100
Message-ID: <1362411473.21028.29.camel@jlt4.sipsolutions.net> (sfid-20130304_163800_012159_B3DEA6C9)
Subject: Re: [PATCH] mac80211: add VHT capabilities station debugfs file
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 04 Mar 2013 16:37:53 +0100
In-Reply-To: <1362175935-11828-1-git-send-email-johannes@sipsolutions.net> (sfid-20130301_231229_956773_D9D04F05)
References: <1362175935-11828-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130301_231229_956773_D9D04F05)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-03-01 at 23:12 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Add a new debugfs file to view a station's VHT capabilities.

Applied, with Joe's suggested change.

johannes

