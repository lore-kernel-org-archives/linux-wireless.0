Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43974 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754366AbeAHRfY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Jan 2018 12:35:24 -0500
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
Message-Id: <20180108173523.A3D036077A@smtp.codeaurora.org> (sfid-20180108_183532_866913_92A66D20)
Date: Mon,  8 Jan 2018 17:35:23 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:

> Initialize mt76_txq pointer after ieee80211_txq pointer check.
> Remove space after the pointer cast
> 
> Fixes: 7bc04215a66b ("mt76: add driver code for MT76x2e")
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

What am I supposed to do with this and patch 2? Drop?

-- 
https://patchwork.kernel.org/patch/10111937/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
