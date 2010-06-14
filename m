Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40436 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755915Ab0FNJ6y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jun 2010 05:58:54 -0400
Subject: Re: [PATCH v2 3/3] mac80211: remove BSS from cfg80211 list when
 leaving IBSS
From: Johannes Berg <johannes@sipsolutions.net>
To: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1276509333-19023-4-git-send-email-ext-teemu.3.paasikivi@nokia.com>
References: <1276509333-19023-1-git-send-email-ext-teemu.3.paasikivi@nokia.com>
	 <1276509333-19023-2-git-send-email-ext-teemu.3.paasikivi@nokia.com>
	 <1276509333-19023-3-git-send-email-ext-teemu.3.paasikivi@nokia.com>
	 <1276509333-19023-4-git-send-email-ext-teemu.3.paasikivi@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Jun 2010 11:58:49 +0200
Message-ID: <1276509529.3926.14.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-06-14 at 12:55 +0300, Teemu Paasikivi wrote:
> Remove BSS from cfg80211 BSS list if we are only member in IBSS when
> leaving it.

Thanks, looks good.

Acked-by: Johannes Berg <johannes@sipsolutions.net>


