Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50776 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753378AbdBHPbW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 10:31:22 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/3] rt61pci: use entry directly
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1486558291-1615-2-git-send-email-sgruszka@redhat.com>
References: <1486558291-1615-2-git-send-email-sgruszka@redhat.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
        Helmut Schaa <helmut.schaa@googlemail.com>
Message-Id: <20170208153107.C3B3B609C6@smtp.codeaurora.org> (sfid-20170208_163251_218299_FE82879B)
Date: Wed,  8 Feb 2017 15:31:07 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

3 patches applied to wireless-drivers-next.git, thanks.

80a97eae3046 rt61pci: use entry directly
2ceb813798e1 rt2x00: call entry directly in rt2x00_dump_frame
cf81db30a6ed rt2x00: remove queue_entry from skbdesc

-- 
https://patchwork.kernel.org/patch/9562469/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
