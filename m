Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:38277 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751518AbcIMMZh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Sep 2016 08:25:37 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: remove unused variable ar_pci
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20160905133802.18755-1-chaehyun.lim@gmail.com>
To: Chaehyun Lim <chaehyun.lim@gmail.com>
CC: <netdev@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        Chaehyun Lim <chaehyun.lim@gmail.com>,
        <ath10k@lists.infradead.org>
Message-ID: <ab838c70bd944270ac482115c9194223@euamsexm01a.eu.qualcomm.com> (sfid-20160913_142541_222342_F338A599)
Date: Tue, 13 Sep 2016 14:25:28 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chaehyun Lim <chaehyun.lim@gmail.com> wrote:
> Trival fix to remove unused variable ar_pci in ath10k_pci_tx_pipe_cleanup
> when building with W=1:
> drivers/net/wireless/ath/ath10k/pci.c:1696:21: warning: variable
> 'ar_pci' set but not used [-Wunused-but-set-variable]
> 
> Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>

Thanks, 1 patch applied to ath-next branch of ath.git:

214d55394481 ath10k: remove unused variable ar_pci

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9313963/
