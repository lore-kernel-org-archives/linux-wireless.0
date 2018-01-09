Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38078 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755937AbeAIIHI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Jan 2018 03:07:08 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,6/9] wil6210: add support for headroom configuration
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1513270393-919-7-git-send-email-qca_merez@qca.qualcomm.com>
References: <1513270393-919-7-git-send-email-qca_merez@qca.qualcomm.com>
To: Maya Erez <qca_merez@qca.qualcomm.com>
Cc: Lazar Alexei <QCA_ailizaro@QCA.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
        Maya Erez <qca_merez@qca.qualcomm.com>
Message-Id: <20180109080707.B05B66081B@smtp.codeaurora.org> (sfid-20180109_090713_885588_28916B36)
Date: Tue,  9 Jan 2018 08:07:07 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maya Erez <qca_merez@qca.qualcomm.com> wrote:

> Add module parameter for configuring the headroom size
> in the skb allocation.
> 
> Signed-off-by: Lazar Alexei <qca_ailizaro@qca.qualcomm.com>
> Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Why?

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#commit_log_does_not_answer_why

And I'm a bit skeptic about this, controlling headroom via a module parameter
is not really making any sense to me.

-- 
https://patchwork.kernel.org/patch/10112703/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
