Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:59552 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932322AbeE2Jbh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 May 2018 05:31:37 -0400
Message-ID: <1527586295.6955.9.camel@sipsolutions.net> (sfid-20180529_113419_471707_C77D84C8)
Subject: Re: [PATCH] nl80211: Include ies_len for nlmsg from ft_event
From: Johannes Berg <johannes@sipsolutions.net>
To: Srinivas Dasari <dasaris@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 29 May 2018 11:31:35 +0200
In-Reply-To: <1527585581-23277-1-git-send-email-dasaris@codeaurora.org>
References: <1527585581-23277-1-git-send-email-dasaris@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-05-29 at 14:49 +0530, Srinivas Dasari wrote:
> Length of the ies is not considered while allocating nl
> message for ft_event, though they are filled.
> Hence, consider the length also for nl_msg.

THis was already fixed by 

nl80211: fix nlmsg allocation in cfg80211_ft_event

johannes
