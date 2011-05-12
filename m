Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42498 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758050Ab1ELRZX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 May 2011 13:25:23 -0400
Subject: Re: [PATCH] mac80211: cancel scan_work in ieee80211_unregister_hw
From: Johannes Berg <johannes@sipsolutions.net>
To: Rajkumar Manoharan <rmanoharan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1305220188-13098-1-git-send-email-rmanoharan@atheros.com>
References: <1305220188-13098-1-git-send-email-rmanoharan@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 May 2011 19:25:21 +0200
Message-ID: <1305221121.3461.32.camel@jlt3.sipsolutions.net> (sfid-20110512_192526_858395_07D454A3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-05-12 at 22:39 +0530, Rajkumar Manoharan wrote:
> scan_work is never stopped if the device was unplugged during
> s/w scan.

How did you come to that conclusion? ieee80211_do_stop() does stop the
scan.

johannes

