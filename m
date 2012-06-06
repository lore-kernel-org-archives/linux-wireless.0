Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53091 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab2FFIyf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 04:54:35 -0400
Message-ID: <1338972874.4513.27.camel@jlt3.sipsolutions.net> (sfid-20120606_105438_602503_9442464A)
Subject: Re: [RFC 04/14] cfg80211: .stop_ap when interface is going down
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 06 Jun 2012 10:54:34 +0200
In-Reply-To: <1338203942-5667-5-git-send-email-michal.kazior@tieto.com>
References: <1338203942-5667-1-git-send-email-michal.kazior@tieto.com>
	 <1338203942-5667-5-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-05-28 at 13:18 +0200, Michal Kazior wrote:
> We'll need this for proper channel tracking (which
> is going to be needed for channel context
> accounting and finding matching/active interface
> combination).

I've not quite made up my mind about full channel tracking in cfg80211,
but this totally makes sense anyway.

johannes

