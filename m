Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38298 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752264AbeEKKPy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 May 2018 06:15:54 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Taketo Kabe <kabe@sra-tohoku.co.jp>
Cc: b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] drivers/net/wireless/broadcom/b43: fix transmit failure when VT is switched
References: <5AF2DE73.20608@sra-tohoku.co.jp> <20180509185101.0888bd7a@wiggum>
        <5AF41F55.4060606@sra-tohoku.co.jp>
Date: Fri, 11 May 2018 13:15:49 +0300
In-Reply-To: <5AF41F55.4060606@sra-tohoku.co.jp> (Taketo Kabe's message of
        "Thu, 10 May 2018 19:30:45 +0900")
Message-ID: <877eoacxbe.fsf@codeaurora.org> (sfid-20180511_121557_157439_397612C0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Taketo Kabe <kabe@sra-tohoku.co.jp> writes:

> From: Taketo Kabe <kabe@sra-tohoku.co.jp>
>
> Fix for b43 wireless card stopping transmission when switching VTs.

The title is wrong, it should be:

b43: fix transmit failure when VT is switched

I can fix that during commit.

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#commit_title_is_wrong


-- 
Kalle Valo
