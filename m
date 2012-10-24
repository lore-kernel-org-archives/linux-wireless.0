Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45850 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934331Ab2JXHUZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Oct 2012 03:20:25 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TQvGK-0007Ax-0U
	for linux-wireless@vger.kernel.org; Wed, 24 Oct 2012 09:20:24 +0200
Message-ID: <1351063260.10709.0.camel@jlt4.sipsolutions.net> (sfid-20121024_092030_743370_22A9E221)
Subject: Re: [PATCH] cfg80211: add tracing for P2P Device start/stop
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Wed, 24 Oct 2012 09:21:00 +0200
In-Reply-To: <1350998264-18318-1-git-send-email-johannes@sipsolutions.net> (sfid-20121023_151716_769653_3C524697)
References: <1350998264-18318-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121023_151716_769653_3C524697)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-10-23 at 15:17 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> These were missed due to the tracing work having
> started on a kernel that didn't have P2P Device
> yet, implement them now.

Applied.

johannes

