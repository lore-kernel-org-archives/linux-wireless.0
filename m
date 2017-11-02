Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51120 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755826AbdKBRi5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Nov 2017 13:38:57 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/2] rsi: move rsi_sdio_reinit_device() out of CONFIG_PM
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1509538365-31532-1-git-send-email-amitkarwar@gmail.com>
References: <1509538365-31532-1-git-send-email-amitkarwar@gmail.com>
To: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Message-Id: <20171102173857.3313B607C9@smtp.codeaurora.org> (sfid-20171102_183902_228284_80DC749B)
Date: Thu,  2 Nov 2017 17:38:57 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <amitkarwar@gmail.com> wrote:

> From: Amitkumar Karwar <amit.karwar@redpinesignals.com>
> 
> This function is generic. It doesn't contain wowlan specific code.
> It should not be under CONFIG_PM. This patch resolves compilation
> errors observed when CONFIG_PM flag is disabled.
> 
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Fixes: ef71ed0608c ("rsi: sdio: Add WOWLAN support for S5 shutdown state")
> Fixes: a24e35fcee0 ("rsi: sdio: Add WOWLAN support for S4 hibernate state")
> Fixes: e1ced6422a3 ("rsi: sdio: add WOWLAN support for S3 suspend state")
> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>

2 patches applied to wireless-drivers-next.git, thanks.

39f1332c526c rsi: move rsi_sdio_reinit_device() out of CONFIG_PM
e6b3b2ed3d27 rsi: fix kbuild reported build errors with CONFIG_PM off

-- 
https://patchwork.kernel.org/patch/10036297/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
