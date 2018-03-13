Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55550 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753108AbeCMQcp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Mar 2018 12:32:45 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/3] mt76: initialize available_antennas_{tx,rx} info
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180224155414.31063-2-lorenzo.bianconi@redhat.com>
References: <20180224155414.31063-2-lorenzo.bianconi@redhat.com>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: nbd@nbd.name, linux-wireless@vger.kernel.org
Message-Id: <20180313163244.E82226084A@smtp.codeaurora.org> (sfid-20180313_173257_937806_0D81AD51)
Date: Tue, 13 Mar 2018 16:32:44 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:

> Initialize available_antennas related info in wiphy data structure
> according to antenna_mask field; antenna_mask info is initialized
> in device specific code and will be used in mac80211 {set,get}_antenna
> callbacks
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

3 patches applied to wireless-drivers-next.git, thanks.

24114a5f9470 mt76: initialize available_antennas_{tx,rx} info
551e1ef4d291 mt76: add mt76_init_stream_cap routine
5ebdc3e0692f mt76x2: add mac80211 {set,get}_antenna callbacks

-- 
https://patchwork.kernel.org/patch/10240417/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
