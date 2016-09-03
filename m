Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58220 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753422AbcICRDs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Sep 2016 13:03:48 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/3] mwifiex: make "PCI-E is not the winner" print more
 informative
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1472137518-10431-2-git-send-email-sgruszka@redhat.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Message-Id: <20160903170348.5223C62182@smtp.codeaurora.org> (sfid-20160903_190351_535856_A969E5F7)
Date: Sat,  3 Sep 2016 17:03:48 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> Printing ret and adapter->winner do not provide any useful information
> as those are always 0 at point where the massage is printed. Print value
> read from reg->fw_status register instead.
> 
> Stanislaw Gruszka <sgruszka@redhat.com>

Thanks, 3 patches applied to wireless-drivers-next.git:

fd3fbb65cab8 mwifiex: make "PCI-E is not the winner" print more informative
09dd9ec598c3 mwifiex: print status of FW ready event
b9aebb69ecd3 mwifiex: do not print dot when downloading FW

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9299495/
