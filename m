Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47783 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982Ab2ITHeD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2012 03:34:03 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TEbGs-0006xj-QA
	for linux-wireless@vger.kernel.org; Thu, 20 Sep 2012 09:34:03 +0200
Message-ID: <1348126480.4161.10.camel@jlt4.sipsolutions.net> (sfid-20120920_093408_993882_F90F5CC5)
Subject: Re: [PATCH] mac80211: make reset debugfs depend on CONFIG_PM
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Thu, 20 Sep 2012 09:34:40 +0200
In-Reply-To: <1348035720-5254-1-git-send-email-johannes@sipsolutions.net> (sfid-20120919_082131_184009_EC167170)
References: <1348035720-5254-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20120919_082131_184009_EC167170)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-09-19 at 08:22 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> The suspend/resume code depends on CONFIG_PM, so
> the reset debugfs file can only be made available
> if that is enabled.
> 
> Fengguang Wu's zero-day build testing found this.

Applied.

johannes

