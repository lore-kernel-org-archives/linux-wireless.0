Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36310 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100Ab2HTLdC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Aug 2012 07:33:02 -0400
Message-ID: <1345462378.4459.17.camel@jlt3.sipsolutions.net> (sfid-20120820_133306_238916_52280F9A)
Subject: Re: [PATCH] mac80211: add supported rates change notification in
 IBSS
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <ordex@autistici.org>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 20 Aug 2012 13:32:58 +0200
In-Reply-To: <1344788695-1458-1-git-send-email-ordex@autistici.org>
References: <1344788695-1458-1-git-send-email-ordex@autistici.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-08-12 at 18:24 +0200, Antonio Quartulli wrote:
> In IBSS it is possible that the supported rates set for a station changes over
> time (e.g. it gets first initialised as an empty set because of no available
> information about rates and updated later). In this case the driver has to be
> notified about the change in order to update its internal table accordingly (if
> needed).
> 
> This behaviour is needed by all those drivers that handle rc internally but
> leave stations management to mac80211

Applied ... with a bunch of fixes

johannes

