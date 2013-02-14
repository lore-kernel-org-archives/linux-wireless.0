Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56288 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756752Ab3BNRbI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2013 12:31:08 -0500
Message-ID: <1360863065.8210.6.camel@jlt4.sipsolutions.net> (sfid-20130214_183112_787932_923C09C8)
Subject: Re: [PATCH] mac80211: always unblock CSA queue stop when
 disconnecting
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: jan.brummer@tabos.org
Date: Thu, 14 Feb 2013 18:31:05 +0100
In-Reply-To: <1360761966-32111-1-git-send-email-johannes@sipsolutions.net> (sfid-20130213_142616_988845_62AF5833)
References: <1360761966-32111-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130213_142616_988845_62AF5833)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-02-13 at 14:26 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> In some cases when disconnecting after (or during?) CSA
> the queues might not recover, and then the only way to
> recover is reloading the module.
> 
> Fix this by always unblocking the queue CSA reason when
> disconnecting.

Applied.

johannes

