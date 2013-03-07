Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53084 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab3CGK0J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Mar 2013 05:26:09 -0500
Message-ID: <1362651965.8694.28.camel@jlt4.sipsolutions.net> (sfid-20130307_112612_898447_15234EE4)
Subject: Re: [PATCH] mac80211: Call drv_set_tim only if there is a change
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Ilan Peer <ilan.peer@intel.com>
Date: Thu, 07 Mar 2013 11:26:05 +0100
In-Reply-To: <1362573850-1460-1-git-send-email-johannes@sipsolutions.net> (sfid-20130306_134421_977530_69EF968F)
References: <1362573850-1460-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130306_134421_977530_69EF968F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-03-06 at 13:44 +0100, Johannes Berg wrote:
> From: Ilan Peer <ilan.peer@intel.com>
> 
> It is possible that sta_info_recalc_tim() is called consecutively
> without changing the station's tim bit. In such cases there is no
> need to call the driver's set_tim() callback.

Applied.

johannes

