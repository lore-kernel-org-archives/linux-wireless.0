Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53468 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751586AbdHQHHZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Aug 2017 03:07:25 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,01/11] rsi: advertise ap mode support
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1502889198-4478-2-git-send-email-amitkarwar@gmail.com>
References: <1502889198-4478-2-git-send-email-amitkarwar@gmail.com>
To: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Message-Id: <20170817070725.0C8D9603AF@smtp.codeaurora.org> (sfid-20170817_090729_042281_D9EDF13C)
Date: Thu, 17 Aug 2017 07:07:25 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <amitkarwar@gmail.com> wrote:

> From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
> 
> AP mode support is advertised to cfg80211. Necessary wiphy
> parameters are initialized.
> 
> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>

11 patches applied to wireless-drivers-next.git, thanks.

6da1e00a539d rsi: advertise ap mode support
03c34c0d73ae rsi: add interface changes for ap mode
75ca0049aad6 rsi: remove interface changes for AP mode
d26a9559403c rsi: add beacon changes for AP mode
3528608f3a79 rsi: handle station connection in AP mode
571b050b42ae rsi: handle station disconnection in AP mode
19844c0a9a19 rsi: data and managemet path changes for AP mode
6572f054e964 rsi: use common descriptor for auto rate frame
8a1ff83f2bf8 rsi: update tx auto rate command frame for AP mode
32be57a666a5 rsi: aggregation parameters frame for AP mode
38ef62353acb rsi: security enhancements for AP mode

-- 
https://patchwork.kernel.org/patch/9903733/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
