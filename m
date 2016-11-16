Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43324 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752029AbcKPN7l (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Nov 2016 08:59:41 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [05/10] rt2800: make ba_size depend on ampdu_factor
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1478095865-8651-6-git-send-email-sgruszka@redhat.com>
References: <1478095865-8651-6-git-send-email-sgruszka@redhat.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Message-Id: <20161116135940.1CBCB61E56@smtp.codeaurora.org> (sfid-20161116_150001_121572_203AADAB)
Date: Wed, 16 Nov 2016 13:59:40 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> We can calculate BA window size (max number of pending frames not
> yet block acked) of remote station using Maximum A-MPDU length factor
> for that station.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Dropping as requested by Stanislaw.

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/9409241/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
