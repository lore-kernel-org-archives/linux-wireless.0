Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:14191 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753374AbdJMLi5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Oct 2017 07:38:57 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: check power save support in STA mode through FW IE
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <150670357817.24239.7065449335785410650.stgit@potku.adurom.net>
References: <150670357817.24239.7065449335785410650.stgit@potku.adurom.net>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Message-ID: <1cded68ebc944a2791525c1065056ef7@euamsexm01e.eu.qualcomm.com> (sfid-20171013_133900_710596_6EBCB0C4)
Date: Fri, 13 Oct 2017 13:38:51 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> wrote:

> Currently ath10k host enables power save support in station mode by
> default for all firmwares but Power save for station mode still not supported
> in some of the firmware versions. Which results in firmware crash while
> issueing multiple scan commands.
> 
> Fix this problem by introducing new FW feature flag to check power save
> support in firmware and then the firmware image can tell to ath10k that power
> save mode is not supported in station mode.
> 
> Signed-off-by: Venkateswara Naralasetty <vnaralas@qti.qualcomm.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

36d9cdb6fb4a ath10k: check power save support in STA mode through FW IE

-- 
https://patchwork.kernel.org/patch/9978455/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
