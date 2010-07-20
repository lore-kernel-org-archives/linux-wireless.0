Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51444 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758478Ab0GTQj6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jul 2010 12:39:58 -0400
Subject: Re: [PATCH] wireless: correct sparse warning in wext-compat.c
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1279643215-13498-1-git-send-email-linville@tuxdriver.com>
References: <1279643215-13498-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Jul 2010 18:39:50 +0200
Message-ID: <1279643990.3706.44.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-07-20 at 12:26 -0400, John W. Linville wrote:
> CHECK   net/wireless/wext-compat.c
> net/wireless/wext-compat.c:1434:5: warning: symbol 'cfg80211_wext_siwpmksa' was not declared. Should it be static?
> 
> Add declaration in cfg80211.h.  Also add an EXPORT_SYMBOL_GPL, since all
> the peer functions have it.

Or it could just be static, since it seems unlikely somebody wants to
use it for orinoco or a similar half-converted driver? Anyway I don't
mind this patch either.

johannes

