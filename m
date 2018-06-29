Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:35584 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933037AbeF2JbQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Jun 2018 05:31:16 -0400
Message-ID: <1530264674.3481.36.camel@sipsolutions.net> (sfid-20180629_113120_402733_13532EAD)
Subject: Re: [PATCH 3/7] mac80211: Add api to support configuring station
 specific rssi threshold
From: Johannes Berg <johannes@sipsolutions.net>
To: Tamizh chelvam <tamizhr@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 29 Jun 2018 11:31:14 +0200
In-Reply-To: <1528886747-26342-4-git-send-email-tamizhr@codeaurora.org>
References: <1528886747-26342-1-git-send-email-tamizhr@codeaurora.org>
         <1528886747-26342-4-git-send-email-tamizhr@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The subjects are a bit confusing - I think you should align the cfg80211
and mac80211 ones so it's clearer that this one is implementing the
previous one's API. Peer vs. station, and mac80211 doesn't add API but
implements it.

This patch doesn't really do anything though, so I guess you need to
combine it with patch 5.

johannes
