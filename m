Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:11312 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752311AbdJ0JZz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Oct 2017 05:25:55 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v7,2/5] ath10k: Enable TDLS peer buffer STA feature
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1508835074-3384-3-git-send-email-yintang@qti.qualcomm.com>
References: <1508835074-3384-3-git-send-email-yintang@qti.qualcomm.com>
To: <yintang@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Message-ID: <1e51ea390a67441faf15f5696e0afea8@euamsexm01a.eu.qualcomm.com> (sfid-20171027_112612_601578_26137AFF)
Date: Fri, 27 Oct 2017 11:25:49 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

yintang@qti.qualcomm.com wrote:

> From: Yingying Tang <yintang@qti.qualcomm.com>
> 
> Enable TDLS peer buffer STA feature.
> QCA6174 firmware(version: WLAN.RM.4.4) support TDLS peer buffer STA,
> it reports this capability through wmi service map in wmi service ready
> event. Set related parameter in TDLS WMI command to enable this feature.
> 
> Signed-off-by: Yingying Tang <yintang@qti.qualcomm.com>

Depends on:

a9cd27b34d66 mac80211: enable TDLS peer buffer STA feature

Currently in mac80211-next.

4 patches set to Awaiting Upstream.

10023753 [v7,2/5] ath10k: Enable TDLS peer buffer STA feature
10023743 [v7,3/5] ath10k: Enable TDLS peer inactivity detection
10023725 [v7,4/5] ath10k: Avoid to set WEP key for TDLS peer
10023737 [v7,5/5] ath10k: Fix TDLS peer TX data failure issue on encryped AP

-- 
https://patchwork.kernel.org/patch/10023753/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
