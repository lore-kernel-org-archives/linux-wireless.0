Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38352 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041Ab3CKHgq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Mar 2013 03:36:46 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1UExHo-00025G-TZ
	for linux-wireless@vger.kernel.org; Mon, 11 Mar 2013 08:36:45 +0100
Message-ID: <1362987403.5284.1.camel@jlt4.sipsolutions.net> (sfid-20130311_083648_989043_76AF05CA)
Subject: Re: [PATCH] mac80211: fix crash with P2P Device returning action
 frames
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 11 Mar 2013 09:36:43 +0200
In-Reply-To: <1362737392-10782-1-git-send-email-johannes@sipsolutions.net> (sfid-20130308_111001_541108_74286781)
References: <1362737392-10782-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130308_111001_541108_74286781)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-03-08 at 11:09 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> If a P2P Device interface receives an unhandled action
> frame, we attempt to return it. This crashes because it
> doesn't have a channel context. Fix the crash by using
> status->band and properly mark the return frame as an
> off-channel frame.

Applied.

johannes

