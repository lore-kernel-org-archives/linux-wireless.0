Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:3204 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932282AbcIBPia (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Sep 2016 11:38:30 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] ath10k: fix group privacy action frame decryption for qca4019
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20160809063151.25993-1-rmanohar@qti.qualcomm.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        "Rajkumar Manoharan" <rmanohar@qti.qualcomm.com>,
        <rmanohar@codeaurora.org>
Message-ID: <65f8ff55122f4a19af3edd2facb8ea9e@euamsexm01a.eu.qualcomm.com> (sfid-20160902_173834_958916_A2E125AE)
Date: Fri, 2 Sep 2016 17:38:24 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> wrote:
> Recent commit 'mac80211: Encrypt "Group addressed privacy" action frames'
> encrypts group privacy action frames. But qca99x0 family chipset delivers
> broadcast/multicast management frames as encrypted and it should be
> decrypted by mac80211. Setting RX_FLAG_DECRYPTED stats for those frames
> is breaking mesh connection establishment.
> 
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>

Thanks, 1 patch applied to ath-next branch of ath.git:

7d42298eb43d ath10k: fix group privacy action frame decryption for qca4019

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9270363/
