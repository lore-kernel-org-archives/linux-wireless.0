Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43136 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753108AbdF2NVF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Jun 2017 09:21:05 -0400
Message-ID: <1498742457.3141.3.camel@sipsolutions.net> (sfid-20170629_152222_287249_51CB7B1C)
Subject: Re: [PATCH] ieee80211: update public action codes
From: Johannes Berg <johannes@sipsolutions.net>
To: peter.oh@bowerswilkins.com, linux-wireless@vger.kernel.org
Cc: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 29 Jun 2017 15:20:57 +0200
In-Reply-To: <1498601249-8372-1-git-send-email-peter.oh@bowerswilkins.com>
References: <1498601249-8372-1-git-send-email-peter.oh@bowerswilkins.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-06-27 at 15:07 -0700, peter.oh@bowerswilkins.com wrote:
> From: Peter Oh <peter.oh@bowerswilkins.com>
> 
> Update Public Action field values as updated in IEEE Std 802.11-2016,
> so that modules/drivers can refer it.
> 
> Signed-off-by: Peter Oh <peter.oh@bowerswilkins.com>

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

Kalle, it looks like this is the only patch I'm willing to pick up
before I go, so I figured you can just throw it into your tree, and
will assign it to you in patchwork.

johannes
