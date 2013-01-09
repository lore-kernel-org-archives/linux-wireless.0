Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43126 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755530Ab3AILTG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2013 06:19:06 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TstgW-0007dx-69
	for linux-wireless@vger.kernel.org; Wed, 09 Jan 2013 12:19:04 +0100
Message-ID: <1357730368.9757.0.camel@jlt4.sipsolutions.net> (sfid-20130109_121911_499337_8CBF2E3F)
Subject: Re: [PATCH v2] regulatory: fix uevent
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Wed, 09 Jan 2013 12:19:28 +0100
In-Reply-To: <1357729561-31054-1-git-send-email-johannes@sipsolutions.net> (sfid-20130109_120539_429369_BFC6C649)
References: <1357729561-31054-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130109_120539_429369_BFC6C649)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-01-09 at 12:06 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> The uevent callback doesn't protect its access to
> last_request, which now causes a warning since
> the conversion to get_last_request(). Fix this by
> allowing to use RCU protection for last_request.

Applied.

johannes

