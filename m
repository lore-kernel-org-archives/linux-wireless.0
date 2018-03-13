Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59780 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932755AbeCMQfm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Mar 2018 12:35:42 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mt7601u: let mac80211 validate rx CCMP PN
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <9ccb187ffdba10f63148402aa38a5db436c52935.1520588242.git.lorenzo.bianconi@redhat.com>
References: <9ccb187ffdba10f63148402aa38a5db436c52935.1520588242.git.lorenzo.bianconi@redhat.com>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: kubakici@wp.pl, linux-wireless@vger.kernel.org
Message-Id: <20180313163542.3C8626084A@smtp.codeaurora.org> (sfid-20180313_173608_156496_5283559D)
Date: Tue, 13 Mar 2018 16:35:42 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:

> Apparently the hardware does not perform CCMP PN validation so
> let mac80211 take care of possible replay attacks in sw.
> Moreover indicate ICV and MIC had been stripped setting corresponding
> bits in ieee80211_rx_status.
> The fix has been validated using 4.2.1 and 4.1.3 tests from the WiFi
> Alliance vulnerability detection tool.
> 
> Fixes: c869f77d6abb ("add mt7601u driver")
> Acked-by: Jakub Kicinski <kubakici@wp.pl>
> Tested-by: David Park <david.park@hitemengineering.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

Patch applied to wireless-drivers-next.git, thanks.

a9eab62d4164 mt7601u: let mac80211 validate rx CCMP PN

-- 
https://patchwork.kernel.org/patch/10270239/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
