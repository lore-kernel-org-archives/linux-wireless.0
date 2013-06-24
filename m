Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36170 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab3FXN6r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jun 2013 09:58:47 -0400
Message-ID: <1372082323.8439.6.camel@jlt4.sipsolutions.net> (sfid-20130624_155850_321046_483D8A8B)
Subject: Re: [PATCH] cfg80211: fix compilation warning for
 cfg80211_leave_all()
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 24 Jun 2013 15:58:43 +0200
In-Reply-To: <1371984681-3384-1-git-send-email-arend@broadcom.com>
References: <1371984681-3384-1-git-send-email-arend@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2013-06-23 at 12:51 +0200, Arend van Spriel wrote:
> The following compilation issue popped up moving from v3.10-rc1 to
> v3.10-rc6 after merging wireless-testing.
> 
> net/wireless/sysfs.c:86:13: error: 'cfg80211_leave_all' defined
> but not used [-Werror=unused-function]
> 
> The function is only called when CONFIG_PM is enabled. Moving the
> function under CONFIG_PM as well.

Applied.

johannes

