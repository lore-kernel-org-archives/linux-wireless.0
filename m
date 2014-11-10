Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51392 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584AbaKJJgv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2014 04:36:51 -0500
Message-ID: <1415612202.1847.9.camel@sipsolutions.net> (sfid-20141110_103658_912250_DE30A2D9)
Subject: Re: [PATCH 1/5] cfg80211: introduce regulatory flags controlling bw
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Mon, 10 Nov 2014 10:36:42 +0100
In-Reply-To: <1414046257-22184-2-git-send-email-arik@wizery.com> (sfid-20141023_083740_259800_D9309FFA)
References: <1414046257-22184-1-git-send-email-arik@wizery.com>
	 <1414046257-22184-2-git-send-email-arik@wizery.com>
	 (sfid-20141023_083740_259800_D9309FFA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-10-23 at 09:37 +0300, Arik Nemtsov wrote:
> Allow setting bandwidth related regulatory flags. These flags are mapped
> to the corresponding channel flags in the specified range.
> Make sure the new flags are consulted when calculating the maximum
> bandwidth allowed by a regulatory-rule.
> 
> Also allow propagating the GO_CONCURRENT modifier from a reg-rule to a
> channel.

Applied.

johannes

