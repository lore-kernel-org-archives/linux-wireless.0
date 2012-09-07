Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52061 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295Ab2IGITD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 04:19:03 -0400
Message-ID: <1347005980.4256.5.camel@jlt4.sipsolutions.net> (sfid-20120907_101910_573870_8694F51E)
Subject: Re: [PATCH] mac80211: refactor set_channel_type
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Michal Kazior <michal.kazior@tieto.com>
Date: Fri, 07 Sep 2012 10:19:40 +0200
In-Reply-To: <1346946969-10041-1-git-send-email-johannes@sipsolutions.net> (sfid-20120906_175536_327912_35F629C3)
References: <1346946969-10041-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20120906_175536_327912_35F629C3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-09-06 at 17:56 +0200, Johannes Berg wrote:
> From: Michal Kazior <michal.kazior@tieto.com>
> 
> Split functionality for further reuse.
> 
> Will prevent code duplication when channel context
> channel_type merging is introduced.

Applied.

johannes

