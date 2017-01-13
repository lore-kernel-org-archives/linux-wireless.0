Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55058 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751370AbdAMKLs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 05:11:48 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [6/9] rt2800: fallback from mcs8 to mcs7
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1483707918-31480-7-git-send-email-sgruszka@redhat.com>
References: <1483707918-31480-7-git-send-email-sgruszka@redhat.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Mathias Kresin <dev@kresin.me>
Message-Id: <20170113101117.0A88360CE1@smtp.codeaurora.org> (sfid-20170113_111153_763843_E8BA00A4)
Date: Fri, 13 Jan 2017 10:11:17 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> If we do not fallback to lower rate, we are unable to calculate
> correctly number of retries in TX status code.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Dropping per Stanislaw's request

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/9500913/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
