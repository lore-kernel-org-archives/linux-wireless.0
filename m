Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53355 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757686AbcDEJMZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2016 05:12:25 -0400
Message-ID: <1459847540.18188.21.camel@sipsolutions.net> (sfid-20160405_111259_148941_9BE9CC38)
Subject: Re: [PATCH] mac80211: remove description of dropped member
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis de Bethencourt <luisbg@osg.samsung.com>,
	linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Date: Tue, 05 Apr 2016 11:12:20 +0200
In-Reply-To: <1458328998-14021-1-git-send-email-luisbg@osg.samsung.com>
References: <1458328998-14021-1-git-send-email-luisbg@osg.samsung.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-03-18 at 19:23 +0000, Luis de Bethencourt wrote:
> Commit 976bd9efdae6 ("mac80211: move beacon_loss_count into ifmgd")
> removed the member from the sta_info struct but the description
> stayed
> lingering. Remove it.
> 
Also applied.

johannes
