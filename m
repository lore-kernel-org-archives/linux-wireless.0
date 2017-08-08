Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41070 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751925AbdHHLq0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Aug 2017 07:46:26 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,1/8] rsi: add support for rf-kill functionality
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1501770544-6746-2-git-send-email-amitkarwar@gmail.com>
References: <1501770544-6746-2-git-send-email-amitkarwar@gmail.com>
To: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Pavani Muthyala <pavani.muthyala@redpinesignals.com>
Message-Id: <20170808114626.1F0D460115@smtp.codeaurora.org> (sfid-20170808_134634_389231_160155BF)
Date: Tue,  8 Aug 2017 11:46:26 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <amitkarwar@gmail.com> wrote:

> From: Pavani Muthyala <pavani.muthyala@redpinesignals.com>
> 
> This patch implements rfkill_poll handler. Also, necessary changes
> are done in interface up and down handler to support rfkill
> functionality.
> 
> Signed-off-by: Pavani Muthyala <pavani.muthyala@redpinesignals.com>
> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>

8 patches applied to wireless-drivers-next.git, thanks.

edba3532c652 rsi: add support for rf-kill functionality
588349a1fe3b rsi: update set_antenna command frame
ce86893fa8d8 rsi: add support for legacy power save
db07971d085f rsi: add support for U-APSD power save
23e414cca1f7 rsi: rename sdio_read_buffer_status_register
d64dd2a172d8 rsi: buffer full check optimization
67c52a4dafce rsi: buffer available interrupt handling
80a88ecf3bcc rsi: RTS threshold configuration

-- 
https://patchwork.kernel.org/patch/9879251/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
