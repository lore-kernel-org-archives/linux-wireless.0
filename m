Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:15283 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754489AbcHaH2W (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Aug 2016 03:28:22 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/4] ath10k: implement wmi echo command
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1468924452-23877-2-git-send-email-michal.kazior@tieto.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <marek.puzyniak@tieto.com>, <linux-wireless@vger.kernel.org>,
        "Michal Kazior" <michal.kazior@tieto.com>,
        <ath10k@lists.infradead.org>
Message-ID: <9a7befb7bfad4d409c3a7cd3ab59bd91@euamsexm01a.eu.qualcomm.com> (sfid-20160831_092826_167911_F5519DA4)
Date: Wed, 31 Aug 2016 09:28:12 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> wrote:
> Will be useful for implementing command barriers.
> 
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, 4 patches applied to ath-next branch of ath.git:

e25854f2404c ath10k: implement wmi echo command
84d4911b7184 ath10k: implement wmi echo event
20ddca21dcf8 ath10k: add wmi command barrier utility
47b1848d9fde ath10k: fix spurious tx/rx during boot

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9236705/
