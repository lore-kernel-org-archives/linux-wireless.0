Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36173 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829AbaLQKvj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2014 05:51:39 -0500
Message-ID: <1418813496.2135.10.camel@sipsolutions.net> (sfid-20141217_115141_508729_B191FB65)
Subject: Re: [PATCH] mac80211: Fix ignored HT override configurations
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org,
	Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>
Date: Wed, 17 Dec 2014 11:51:36 +0100
In-Reply-To: <1418546339-8782-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1418546339-8782-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2014-12-14 at 10:38 +0200, Emmanuel Grumbach wrote:
> From: Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>
> 
> HT override configurations was ignored when choosing the channel
> (until now, the override configuration affected only the
> capabilities shown in the IEs).
> 
> The override configurations received only on association time,
> so in this case we should determine the channel again.

Applied, thanks.

johannes

