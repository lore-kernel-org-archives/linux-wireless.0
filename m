Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47568 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753051AbeAQOuJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Jan 2018 09:50:09 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/2] mt76: fix possible NULL pointer dereferencing in
 mt76x2_ampdu_action()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <18a56326d68a7d53f3197e450cae0e28382d8d2c.1513252573.git.lorenzo.bianconi@redhat.com>
References: <18a56326d68a7d53f3197e450cae0e28382d8d2c.1513252573.git.lorenzo.bianconi@redhat.com>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: nbd@nbd.name, dan.carpenter@oracle.com,
        linux-wireless@vger.kernel.org
Message-Id: <20180117145009.3F4806083C@smtp.codeaurora.org> (sfid-20180117_155013_587244_5745CED7)
Date: Wed, 17 Jan 2018 14:50:09 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:

> Initialize mt76_txq pointer after ieee80211_txq pointer check.
> Remove space after the pointer cast
> 
> Fixes: 7bc04215a66b ("mt76: add driver code for MT76x2e")
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

2 patches applied to wireless-drivers-next.git, thanks.

99ac5327e902 mt76: fix possible NULL pointer dereferencing in mt76x2_ampdu_action()
98051872fd25 mt76: fix possible NULL pointer dereferencing in mt76x2_mac_write_txwi()

-- 
https://patchwork.kernel.org/patch/10111937/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
