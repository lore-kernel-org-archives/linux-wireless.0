Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:59296 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1764066AbdDSOHO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Apr 2017 10:07:14 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: ath10k: bump up FW API to 6
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1491944688-5795-1-git-send-email-ryanhsu@qca.qualcomm.com>
References: <1491944688-5795-1-git-send-email-ryanhsu@qca.qualcomm.com>
To: <ryanhsu@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <ryanhsu@qti.qualcomm.com>
Message-ID: <8a9bab5f36e8456bafa8d872012bcf3a@euamsexm01a.eu.qualcomm.com> (sfid-20170419_160718_750404_E7FF57B8)
Date: Wed, 19 Apr 2017 16:07:07 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ryanhsu@qti.qualcomm.com wrote:
> From: Ryan Hsu <ryanhsu@qca.qualcomm.com>
> 
> For QCA6174 hw3.0, since WLAN.RM.4.4-00022-QCARMSWPZ-2, it starts to
> support the board ID information from otp, with some devices released on
> the market that didn't calibrated with OTP, will have 0 for board ID
> information, which cause the backward compatibility issue and was fixed
> in commit 'd2e202c06ca4 ("ath10k: ignore configuring the incorrect board_id")'
> 
> So bump the fw api version to differentiate the latest firmware support.
> 
> Signed-off-by: Ryan Hsu <ryanhsu@qca.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

aad1fd7f7677 ath10k: bump up FW API to 6

-- 
https://patchwork.kernel.org/patch/9676073/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
