Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:60795 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751000AbdJ0Ntn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Oct 2017 09:49:43 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: spectral: Remove redundant check
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1507974075-6987-1-git-send-email-chris.gekas@gmail.com>
References: <1507974075-6987-1-git-send-email-chris.gekas@gmail.com>
To: Christos Gkekas <chris.gekas@gmail.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Christos Gkekas <chris.gekas@gmail.com>
Message-ID: <5f9c14b73128416da92cca6fcd69dd4d@euamsexm01a.eu.qualcomm.com> (sfid-20171027_155009_904272_1B0B7B57)
Date: Fri, 27 Oct 2017 15:49:36 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christos Gkekas <chris.gekas@gmail.com> wrote:

> Variable val is unsigned, so checking whether it is less than zero is
> redundant.
> 
> Signed-off-by: Christos Gkekas <chris.gekas@gmail.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

d83c0d3293bb ath10k: spectral: remove redundant check in write_file_spectral_count()

-- 
https://patchwork.kernel.org/patch/10006335/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
