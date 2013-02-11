Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43013 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883Ab3BKLt1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 06:49:27 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1U4rt0-0000hG-BK
	for linux-wireless@vger.kernel.org; Mon, 11 Feb 2013 12:49:26 +0100
Message-ID: <1360583364.8738.20.camel@jlt4.sipsolutions.net> (sfid-20130211_124929_666445_DDA7FA47)
Subject: Re: [PATCH] cfg80211: remove scan ies NULL check
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 11 Feb 2013 12:49:24 +0100
In-Reply-To: <1360079641-14357-1-git-send-email-johannes@sipsolutions.net> (sfid-20130205_165345_419164_1209E500)
References: <1360079641-14357-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130205_165345_419164_1209E500)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-02-05 at 16:54 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> There's no way scan BSS IEs can be NULL as even
> if the allocation fails the frame is discarded.
> Remove some code checking for this and document
> that it is always non-NULL.

Applied.

johannes

