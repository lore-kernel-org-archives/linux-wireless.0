Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47390 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726087AbeIDMjR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 08:39:17 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH v2] mt76: Enable NL80211_EXT_FEATURE_CQM_RSSI_LIST
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180901083834.11201-1-kristian.evensen@gmail.com>
References: <20180901083834.11201-1-kristian.evensen@gmail.com>
To: Kristian Evensen <kristian.evensen@gmail.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kristian Evensen <kristian.evensen@gmail.com>
Message-Id: <20180904081515.6E874607B9@smtp.codeaurora.org> (sfid-20180904_101536_217244_61B789A2)
Date: Tue,  4 Sep 2018 08:15:15 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kristian Evensen <kristian.evensen@gmail.com> wrote:

> Enable the use of CQM_RSSI_LIST with mt76-devices. The change has been
> tested with the mt7602, mt7603 and mt7621 PCI wifi-cards. I passed a
> list of RSSI thresholds to the driver, and when disconnecting/connecting
> the antenna(s) I got an event each time the RSSI went above/below a
> threshold.
> 
> While I have not been able to test the change with any of the mt76
> USB-devices (no access to a device), the RX RSSI management code is
> shared between the two device types. Thus, CQM should also work with the
> mt76 USB-devices.
> 
> Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

b37b30afc2b3 mt76: Enable NL80211_EXT_FEATURE_CQM_RSSI_LIST

-- 
https://patchwork.kernel.org/patch/10584647/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
