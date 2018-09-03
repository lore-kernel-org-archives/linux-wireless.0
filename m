Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47882 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726172AbeICRZh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Sep 2018 13:25:37 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Kristian Evensen <kristian.evensen@gmail.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mt76: Enable NL80211_EXT_FEATURE_CQM_RSSI_LIST
References: <20180901083834.11201-1-kristian.evensen@gmail.com>
Date: Mon, 03 Sep 2018 16:05:29 +0300
In-Reply-To: <20180901083834.11201-1-kristian.evensen@gmail.com> (Kristian
        Evensen's message of "Sat, 1 Sep 2018 10:38:34 +0200")
Message-ID: <87ftyqwx2e.fsf@codeaurora.org> (sfid-20180903_150544_644750_3FEE7A48)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kristian Evensen <kristian.evensen@gmail.com> writes:

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
> v1->v2:
> * Updated commit message. Thanks Kalle Valo, Arend van Spriel,
> Lorenzo Bianconi and Andrew Zaborowski.
>
> Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
> ---

The changelog should be here, after the '---' line, so that git can
automatically drop it. But I can fix it before I commit, but in the
future please add it to the correct place.

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#changelog_missing

-- 
Kalle Valo
