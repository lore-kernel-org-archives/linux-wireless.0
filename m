Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:37314 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453Ab3GHI47 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jul 2013 04:56:59 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Uw7Ff-0006Tj-5Y
	for linux-wireless@vger.kernel.org; Mon, 08 Jul 2013 10:56:55 +0200
Message-ID: <1373273813.8312.4.camel@jlt4.sipsolutions.net> (sfid-20130708_105703_907792_4F1F3537)
Subject: Re: [PATCH] mac80211: add per-chain signal information to radiotap
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 08 Jul 2013 10:56:53 +0200
In-Reply-To: <1372851242-25474-1-git-send-email-johannes@sipsolutions.net> (sfid-20130703_133411_815348_70B87534)
References: <1372851242-25474-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130703_133411_815348_70B87534)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-07-03 at 13:34 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> When per-chain signal information is available, don't add
> the antenna field once but instead add a radiotap namespace
> for each chain containing the chain/antenna number and the
> signal strength on that chain.

Applied.

johannes

