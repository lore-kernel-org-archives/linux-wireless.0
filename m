Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45544 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751543AbcIQPRz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Sep 2016 11:17:55 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/1] rtl8xxxu: Implement 8192e specific power down sequence
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1473793395-28927-2-git-send-email-Jes.Sorensen@redhat.com>
References: <1473793395-28927-2-git-send-email-Jes.Sorensen@redhat.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
        Jes Sorensen <Jes.Sorensen@redhat.com>
Message-Id: <20160917151754.8DEAF61810@smtp.codeaurora.org> (sfid-20160917_171758_245278_8C819935)
Date: Sat, 17 Sep 2016 15:17:54 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jes Sorensen <Jes.Sorensen@redhat.com> wrote:
> From: Jes Sorensen <Jes.Sorensen@redhat.com>
> 
> This powers down the 8192e correctly, or at least to the point where
> the firmware will load again, when reloading the driver module.
> 
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>

Thanks, 1 patch applied to wireless-drivers-next.git:

f1785fbf7c0b rtl8xxxu: Implement 8192e specific power down sequence

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9329843/
