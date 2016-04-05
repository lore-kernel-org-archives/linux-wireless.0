Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53351 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756749AbcDEJLi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2016 05:11:38 -0400
Message-ID: <1459847490.18188.20.camel@sipsolutions.net> (sfid-20160405_111159_772233_79919F71)
Subject: Re: [PATCH] mac80211: add doc for RX_FLAG_DUP_VALIDATED flag
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis de Bethencourt <luisbg@osg.samsung.com>,
	linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Date: Tue, 05 Apr 2016 11:11:30 +0200
In-Reply-To: <1458317369-28185-1-git-send-email-luisbg@osg.samsung.com>
References: <1458317369-28185-1-git-send-email-luisbg@osg.samsung.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-03-18 at 16:09 +0000, Luis de Bethencourt wrote:
> Add documentation for the flag for duplication check.
> 
> Fixes the following warning when running make htmldocs:
> warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum
> 'mac80211_rx_flags'
> 
Applied, thanks.

johannes
