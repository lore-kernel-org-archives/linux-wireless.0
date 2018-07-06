Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:35188 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932236AbeGFLiU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Jul 2018 07:38:20 -0400
Message-ID: <1530877097.3197.2.camel@sipsolutions.net> (sfid-20180706_133824_088544_32A69DB4)
Subject: Re: [PATCH 6/7] cfg80211: Accept multiple RSSI threholds for
 STA_MON command
From: Johannes Berg <johannes@sipsolutions.net>
To: Tamizh chelvam <tamizhr@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 06 Jul 2018 13:38:17 +0200
In-Reply-To: <0b97dd04efa70ff1016ae6fd2face3a1@codeaurora.org>
References: <1528886747-26342-1-git-send-email-tamizhr@codeaurora.org>
         <1528886747-26342-7-git-send-email-tamizhr@codeaurora.org>
         <1530265167.3481.45.camel@sipsolutions.net>
         <0b97dd04efa70ff1016ae6fd2face3a1@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2018-07-05 at 13:07 +0530, Tamizh chelvam wrote:

> First I've done patch to have single threshold value for AP mode and as 
> per the previous discussion extended to multiple thresholds also. Here 
> the intention is to accept one or more than one RSSI thresholds to 
> monitor. Any thought ?

Is there any point in even offering the API for a single one though? I
mean - we only implement it in mac80211 now, and there we clearly
implement multiple, so single would never be used.

Like I said:

> > Or do you expect somebody to actually really need the single threshold
> > in the near future?

johannes
