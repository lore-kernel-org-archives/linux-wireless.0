Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42202 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758366Ab3CDPiW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 10:38:22 -0500
Message-ID: <1362411497.21028.30.camel@jlt4.sipsolutions.net> (sfid-20130304_163824_895512_538ECAF2)
Subject: Re: [PATCH] cfg80211: enable TDLS on P2P client interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: j@w1.fi
Date: Mon, 04 Mar 2013 16:38:17 +0100
In-Reply-To: <1362385919-8260-1-git-send-email-johannes@sipsolutions.net> (sfid-20130304_093209_680610_698BC8BF)
References: <1362385919-8260-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130304_093209_680610_698BC8BF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-03-04 at 09:31 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> There's no reason TDLS should be prevented on P2P client
> interfaces, and most of the code already handles it, so
> allow adding stations for it.

Applied.

johannes

