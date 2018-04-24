Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55954 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750882AbeDXRYZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Apr 2018 13:24:25 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2, RESEND,
 1/4] rsi: move xtend_desc structure from rsi_main.h to rsi_mgmt.h
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1522332892-5251-2-git-send-email-amitkarwar@gmail.com>
References: <1522332892-5251-2-git-send-email-amitkarwar@gmail.com>
To: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Message-Id: <20180424172424.D308960863@smtp.codeaurora.org> (sfid-20180424_192429_092742_047785C2)
Date: Tue, 24 Apr 2018 17:24:24 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <amitkarwar@gmail.com> wrote:

> From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
> 
> All descriptor structures are in rsi_mgmt.h except this
> extended descriptor structure. Hence moving it to rsi_mgmt.h
> and also renaming to rsi_xtend_desc.
> 
> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>

4 patches applied to wireless-drivers-next.git, thanks.

5dc3638735f1 rsi: move xtend_desc structure from rsi_main.h to rsi_mgmt.h
1be05eb5e4dc rsi: move descriptor preparation to core
62dc108d5f7c rsi: enable 80MHz clock by default
4fd6c4762f37 rsi: roaming enhancements

-- 
https://patchwork.kernel.org/patch/10315497/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
