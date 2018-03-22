Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:52928 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752613AbeCVKmf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Mar 2018 06:42:35 -0400
Message-ID: <1521715353.19621.6.camel@sipsolutions.net> (sfid-20180322_114342_955594_AA28927B)
Subject: Re: [PATCH v2] mac80211: notify driver for change in multicast rates
From: Johannes Berg <johannes@sipsolutions.net>
To: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 22 Mar 2018 11:42:33 +0100
In-Reply-To: <1521676490-25366-1-git-send-email-pradeepc@codeaurora.org>
References: <1521676490-25366-1-git-send-email-pradeepc@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-03-21 at 16:54 -0700, Pradeep Kumar Chitrapu wrote:
> 
> index 4c99c13..4360765 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -336,6 +336,7 @@ enum ieee80211_bss_change {
>  	BSS_CHANGED_OCB                 = 1<<22,
>  	BSS_CHANGED_MU_GROUPS		= 1<<23,
>  	BSS_CHANGED_KEEP_ALIVE		= 1<<24,
> +	BSS_CHANGED_MCAST_RATE		= 1<<25,

Not sure why I missed this before, but you need to add documentation
for this.

johannes
