Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51506 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab2LTLPT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Dec 2012 06:15:19 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Tle5t-0007ID-Rd
	for linux-wireless@vger.kernel.org; Thu, 20 Dec 2012 12:15:18 +0100
Message-ID: <1356002140.10029.2.camel@jlt4.sipsolutions.net> (sfid-20121220_121524_131487_15D818E0)
Subject: Re: [PATCH 00/24] regulatory fixes, cleanups & improvements
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Thu, 20 Dec 2012 12:15:40 +0100
In-Reply-To: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net> (sfid-20121206_174756_392946_04B4B998)
References: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121206_174756_392946_04B4B998)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-12-06 at 17:47 +0100, Johannes Berg wrote:
> The biggest improvement is using RCU, this will allow checking
> against the regdomain from any context and makes the wiphy's
> regd pointer safe to use for drivers. It also simplifies the
> locking since cfg80211_mutex isn't needed any more for those
> things, only for wdev iteration/access. 

Applied, except for patch 20.

johannes

