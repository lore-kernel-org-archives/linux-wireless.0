Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:33617 "EHLO
        alexa-out-lv-02.qualcomm.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751933AbdHCLjL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Aug 2017 07:39:11 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath9k: fix debugfs file permission
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1499859860.2050.5.camel@googlemail.com>
References: <1499859860.2050.5.camel@googlemail.com>
To: Christoph Fritz <chf.fritz@googlemail.com>
CC: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        <linux-wireless@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Message-ID: <8258d5771ccc4aa3984e1d619da57237@euamsexm01a.eu.qualcomm.com> (sfid-20170803_133914_420614_682D3220)
Date: Thu, 3 Aug 2017 13:39:04 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christoph Fritz <chf.fritz@googlemail.com> wrote:

> This patch fixes a trivial debugfs file permission issue. Debugfs
> file ack_to has no write function, so S_IWUSR gets purged.
> 
> Signed-off-by: Christoph Fritz <chf.fritz@googlemail.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

f085c105479f ath9k: fix debugfs file permission

-- 
https://patchwork.kernel.org/patch/9836539/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
