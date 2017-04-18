Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46166 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756002AbdDRJE2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Apr 2017 05:04:28 -0400
Message-ID: <1492506263.2472.5.camel@sipsolutions.net> (sfid-20170418_110622_078177_E35926E6)
Subject: Re: [PATCH] nl80211: Fix enum type of variable in
 nl80211_put_sta_rate()
From: Johannes Berg <johannes@sipsolutions.net>
To: Matthias Kaehlcke <mka@chromium.org>,
        "David S . Miller" <davem@davemloft.net>,
        Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Grant Grundler <grundler@chromium.org>,
        Greg Hackmann <ghackmann@google.com>,
        Michael Davidson <md@google.com>
Date: Tue, 18 Apr 2017 11:04:23 +0200
In-Reply-To: <20170417225952.106468-1-mka@chromium.org> (sfid-20170418_010001_948995_47957692)
References: <20170417225952.106468-1-mka@chromium.org>
         (sfid-20170418_010001_948995_47957692)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-04-17 at 15:59 -0700, Matthias Kaehlcke wrote:
> rate_flg is of type 'enum nl80211_attrs', however it is assigned with
> 'enum nl80211_rate_info' values. Change the type of rate_flg
> accordingly.

Applied this, and the other two patches you had (IBSS enum and array-
bounds)

johannes
