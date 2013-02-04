Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43437 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754435Ab3BDPpP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2013 10:45:15 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1U2OEM-00039c-5a
	for linux-wireless@vger.kernel.org; Mon, 04 Feb 2013 16:45:14 +0100
Message-ID: <1359992738.10311.27.camel@jlt4.sipsolutions.net> (sfid-20130204_164520_386967_1CB9E8BF)
Subject: Re: [PATCH] cfg80211: wrap BSS kref
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 04 Feb 2013 16:45:38 +0100
In-Reply-To: <1359679143-4810-1-git-send-email-johannes@sipsolutions.net> (sfid-20130201_013845_786545_97B08B0C)
References: <1359679143-4810-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130201_013845_786545_97B08B0C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-02-01 at 01:39 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Add inline wrappers for the BSS struct krefs
> to be able to extend them easily later.

Applied.

johannes

