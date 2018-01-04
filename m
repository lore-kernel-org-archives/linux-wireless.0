Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:52472 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753251AbeADPJF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Jan 2018 10:09:05 -0500
Message-ID: <1515078541.10342.30.camel@sipsolutions.net> (sfid-20180104_160937_232903_6F017BB1)
Subject: Re: [PATCH] nl80211: Check for the required netlink attribute
 presence
From: Johannes Berg <johannes@sipsolutions.net>
To: Hao Chen <flank3rsky@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 04 Jan 2018 16:09:01 +0100
In-Reply-To: <1514948431-20893-1-git-send-email-flank3rsky@gmail.com> (sfid-20180103_040046_373329_293E7D92)
References: <1514948431-20893-1-git-send-email-flank3rsky@gmail.com>
         (sfid-20180103_040046_373329_293E7D92)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-01-03 at 11:00 +0800, Hao Chen wrote:
> nl80211_nan_add_func() does not check if the required attribute
> NL80211_NAN_FUNC_FOLLOW_UP_DEST is present when processing
> NL80211_CMD_ADD_NAN_FUNCTION request. This request can be issued
> by users with CAP_NET_ADMIN privilege and may result in NULL dereference
> and a system crash. Add a check for the required attribute presence.

Applied, thanks.

johannes
