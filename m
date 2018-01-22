Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:45870 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751086AbeAVNBE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jan 2018 08:01:04 -0500
Message-ID: <1516626062.2508.26.camel@sipsolutions.net> (sfid-20180122_140109_024406_98BDA9F0)
Subject: Re: [PATCH 2/4] cfg80211: enable setting cqm config for AP mode
From: Johannes Berg <johannes@sipsolutions.net>
To: tamizhr@codeaurora.org
Cc: linux-wireless@vger.kernel.org, tamizhr@qti.qualcomm.com,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
Date: Mon, 22 Jan 2018 14:01:02 +0100
In-Reply-To: <1516174276-16789-3-git-send-email-tamizhr@codeaurora.org>
References: <1516174276-16789-1-git-send-email-tamizhr@codeaurora.org>
         <1516174276-16789-3-git-send-email-tamizhr@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In addition to what I said before, you should also document which CQM
modes are actually available per station.

Perhaps the feature bit also needs to be per mode, since in mac80211 at
least you're only implementing signal monitoring, not
nl80211_set_cqm_txe()?

johannes
