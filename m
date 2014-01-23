Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:46622 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709AbaAWSpj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 13:45:39 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.82)
	(envelope-from <johannes@sipsolutions.net>)
	id 1W6PHV-0001go-4t
	for linux-wireless@vger.kernel.org; Thu, 23 Jan 2014 19:45:37 +0100
Message-ID: <1390502735.4142.37.camel@jlt4.sipsolutions.net> (sfid-20140123_194545_055216_6DABD349)
Subject: Re: [PATCH] mac80211_hwsim: make P2P-Device support optional
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Thu, 23 Jan 2014 19:45:35 +0100
In-Reply-To: <1389794461-30686-1-git-send-email-johannes@sipsolutions.net> (sfid-20140115_150117_489379_FFA0449D)
References: <1389794461-30686-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20140115_150117_489379_FFA0449D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-01-15 at 15:01 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> When creating new devices, allow P2P-Device support to be
> turned off to be able to test default behaviour with and
> without the support.
> 
> Also add a module parameter for the default setting.

Applied.

johannes

