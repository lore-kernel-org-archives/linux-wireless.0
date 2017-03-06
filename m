Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47748 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754399AbdCFOIy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Mar 2017 09:08:54 -0500
Message-ID: <1488805089.27057.6.camel@sipsolutions.net> (sfid-20170306_151013_155893_F0B54FBF)
Subject: Re: [PATCH v2 1/4] mac80211-hwsim: notify user-space about channel
 change.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com, linux-wireless@vger.kernel.org
Date: Mon, 06 Mar 2017 13:58:09 +0100
In-Reply-To: <1488232593-2552-2-git-send-email-greearb@candelatech.com> (sfid-20170228_053238_938538_2193D6CF)
References: <1488232593-2552-1-git-send-email-greearb@candelatech.com>
         <1488232593-2552-2-git-send-email-greearb@candelatech.com>
         (sfid-20170228_053238_938538_2193D6CF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +	if (nla_put_u32(skb, HWSIM_ATTR_CH_FREQ2, data-
> >center_freq2))
> +		goto nla_put_failure;

I'd prefer this to be conditional on it being non-zero.

I'd have fixed it, but none of these patches apply cleanly to my tree.

johannes
