Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51892 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753765AbcJUHzJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Oct 2016 03:55:09 -0400
Message-ID: <1477036505.4068.7.camel@sipsolutions.net> (sfid-20161021_095512_612733_9005813C)
Subject: Re: [PATCH] cfg80211: add generic helper to check interface is
 running
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 21 Oct 2016 09:55:05 +0200
In-Reply-To: <1476990502-32472-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1476990502-32472-1-git-send-email-arend.vanspriel@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-10-20 at 20:08 +0100, Arend van Spriel wrote:
> Adding a helper using wdev to check if interface is running. This
> deals with both non-netdev and netdev interfaces. In struct
> wireless_dev replacing 'p2p_started' and 'nan_started' by
> 'is_running' as those are mutual exclusive anyway.

Applied, thanks.

I renamed the helper to just wdev_running() because we also have
sdata_running() in mac80211.

johannes
