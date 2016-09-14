Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53979 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761877AbcINRB1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Sep 2016 13:01:27 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/2] rtl8xxxu: Reset device on module unload if still attached
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1473444085-6363-2-git-send-email-Jes.Sorensen@redhat.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-wireless@vger.kernel.org,
        Jes Sorensen <Jes.Sorensen@redhat.com>
Message-Id: <20160914170126.C8C5B61AD5@smtp.codeaurora.org> (sfid-20160914_190130_471536_248DCF3A)
Date: Wed, 14 Sep 2016 17:01:26 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jes Sorensen <Jes.Sorensen@redhat.com> wrote:
> From: Jes Sorensen <Jes.Sorensen@redhat.com>
> 
> If the USB dongle is still attached, reset it on module unload to
> avoid scans failing when reloading the driver.
> 
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>

Thanks, 2 patches applied to wireless-drivers-next.git:

54cdf5c727cb rtl8xxxu: Reset device on module unload if still attached
0cd7f70399f7 rtl8xxxu: fix spelling mistake "firmare" -> "firmware"

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9324069/
