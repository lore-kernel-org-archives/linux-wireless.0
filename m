Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37769 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755987Ab3APOSm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2013 09:18:42 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TvTpB-0000Sj-Hw
	for linux-wireless@vger.kernel.org; Wed, 16 Jan 2013 15:18:41 +0100
Message-ID: <1358345947.22862.13.camel@jlt4.sipsolutions.net> (sfid-20130116_151853_788594_FCFFAA89)
Subject: Re: [PATCH] mac80211: call restart complete at wowlan resume time
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Wed, 16 Jan 2013 15:19:07 +0100
In-Reply-To: <1358173349-18398-1-git-send-email-johannes@sipsolutions.net> (sfid-20130114_152208_845146_4878B9DB)
References: <1358173349-18398-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130114_152208_845146_4878B9DB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-01-14 at 15:22 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> When the driver's resume function can't completely
> restore the configuration in the device, it returns
> 1 from the callback which will be treated like a HW
> restart request, but done directly.
> 
> In this case, also call the driver's restart_complete()
> function so it can finish the reconfiguration there.

Applied.

johannes

