Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38354 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130Ab3CKHie (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Mar 2013 03:38:34 -0400
Message-ID: <1362987511.5284.2.camel@jlt4.sipsolutions.net> (sfid-20130311_083844_636931_8665F29F)
Subject: Re: [PATCH 3.9] cfg80211: fix potential BSS memory leak and update
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Larry.Finger@lwfinger.net
Date: Mon, 11 Mar 2013 09:38:31 +0200
In-Reply-To: <1362657345-16164-1-git-send-email-johannes@sipsolutions.net> (sfid-20130307_125553_226292_852022A7)
References: <1362657345-16164-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130307_125553_226292_852022A7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-03-07 at 12:55 +0100, Johannes Berg wrote:
> In the odd case that while updating information from a beacon,
> a BSS was found that is part of a hidden group, we drop the
> new information. In this case, however, we leak the IE buffer
> from the update, and erroneously update the entry's timestamp
> so it will never time out. Fix both these issues.

Applied.

johannes

