Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52056 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750898AbdE3HSf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 May 2017 03:18:35 -0400
Message-ID: <1496128708.3327.0.camel@sipsolutions.net> (sfid-20170530_091857_297653_294C871C)
Subject: Re: [PATCH v2] mac80211: Invoke TX LED in more code paths
From: Johannes Berg <johannes@sipsolutions.net>
To: Bjorn Andersson <bjorn.andersson@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc: "open list:MAC80211" <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org
Date: Tue, 30 May 2017 09:18:28 +0200
In-Reply-To: <20170527215927.7726-1-bjorn.andersson@linaro.org> (sfid-20170527_235932_534835_9EAE8FC2)
References: <20170527215927.7726-1-bjorn.andersson@linaro.org>
         (sfid-20170527_235932_534835_9EAE8FC2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2017-05-27 at 14:59 -0700, Bjorn Andersson wrote:
> ieee80211_tx_status() is only one of the possible ways a driver can
> report a handled packet, some drivers call this for every packet
> while
> others calls it rarely or never.
> 
> In order to invoke the TX LED in the non-status reporting cases this
> patch pushes the call to ieee80211_led_tx() into
> ieee80211_report_used_skb(), which is shared between the various code
> paths.

Applied.

johannes
