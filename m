Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:35770 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932280AbeF2JkB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Jun 2018 05:40:01 -0400
Message-ID: <1530265199.3481.46.camel@sipsolutions.net> (sfid-20180629_114004_815912_269436E1)
Subject: Re: [PATCH 7/7] mac80211: Add api to configure low and high RSSI
 threshold
From: Johannes Berg <johannes@sipsolutions.net>
To: Tamizh chelvam <tamizhr@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 29 Jun 2018 11:39:59 +0200
In-Reply-To: <1528886747-26342-8-git-send-email-tamizhr@codeaurora.org>
References: <1528886747-26342-1-git-send-email-tamizhr@codeaurora.org>
         <1528886747-26342-8-git-send-email-tamizhr@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-06-13 at 16:15 +0530, Tamizh chelvam wrote:
> Add set_sta_mon_rssi_range_config api to support
> configuring low and high RSSI threshold values
> for a connected station. And trigger an event if a
> station's signal strength goes out of configured
> range.

Same here, let's not worry about the "single threshold" thing - it
simplifies the code.

johannes
