Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56064 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab2FFJL1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 05:11:27 -0400
Message-ID: <1338973886.4513.43.camel@jlt3.sipsolutions.net> (sfid-20120606_111129_614705_9DA3FF22)
Subject: Re: [RFC 08/14] mac80211: refactor virtual monitor code
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 06 Jun 2012 11:11:26 +0200
In-Reply-To: <1338203942-5667-9-git-send-email-michal.kazior@tieto.com>
References: <1338203942-5667-1-git-send-email-michal.kazior@tieto.com>
	 <1338203942-5667-9-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-05-28 at 13:18 +0200, Michal Kazior wrote:
> Use cfg80211 the new .set_monitor_enabled instead
> of tracking it inside mac80211.

Makes sense with the previous patch as is, but changes there obviously
affect this.

johannes

