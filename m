Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43701 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933073AbcHaI26 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Aug 2016 04:28:58 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Benjamin Berg <benjamin.berg@open-mesh.com>,
        linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] ath9k: indent an if statement
References: <20160803184339.GB775@mwanda>
Date: Wed, 31 Aug 2016 11:28:52 +0300
In-Reply-To: <20160803184339.GB775@mwanda> (Dan Carpenter's message of "Wed, 3
        Aug 2016 21:43:39 +0300")
Message-ID: <87lgzd4a0r.fsf@kamboji.qca.qualcomm.com> (sfid-20160831_103228_052521_40625659)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Carpenter <dan.carpenter@oracle.com> writes:

> It looks like this code is correct, but it just needs to be indented a
> bit.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Doesn't apply anymore:

Importing patch "ath9k-indent-an-if-statement" ... error: patch failed: drivers/net/wireless/ath/ath9k/main.c:919
error: drivers/net/wireless/ath/ath9k/main.c: patch does not apply
stg import: Diff does not apply cleanly

-- 
Kalle Valo
