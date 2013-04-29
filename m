Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:53477 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757296Ab3D2OV5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Apr 2013 10:21:57 -0400
Message-ID: <1367245311.8289.3.camel@jlt4.sipsolutions.net> (sfid-20130429_162200_777494_9E10EEC9)
Subject: Re: [PATCH] nl80211: Add generic netlink module alias for
 cfg80211/nl80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 29 Apr 2013 16:21:51 +0200
In-Reply-To: <1367191326-30078-1-git-send-email-marcel@holtmann.org> (sfid-20130429_012225_262878_EE362FD8)
References: <1367191326-30078-1-git-send-email-marcel@holtmann.org>
	 (sfid-20130429_012225_262878_EE362FD8)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2013-04-28 at 16:22 -0700, Marcel Holtmann wrote:
> To support auto-loading of wireless modules from netlink users, add module
> alias for nl80211 family.
> 
> This also adds NL80211_GENL_NAME constant to define the "nl80211" netlink
> family name as part of uapi.

Applied, thanks.

johannes

