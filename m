Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:26615 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750951AbcIMMYs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Sep 2016 08:24:48 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [V2] ath10k: fix memory leak on caldata on error exit path
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20160903163819.13115-1-colin.king@canonical.com>
To: Colin Ian King <colin.king@canonical.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Message-ID: <c603113a967a45c18ddce5deff55b753@euamsexm01a.eu.qualcomm.com> (sfid-20160913_142508_209655_7240F392)
Date: Tue, 13 Sep 2016 14:24:40 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Colin Ian King <colin.king@canonical.com> wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> caldata is not being free'd on the error exit path, causing
> a memory leak and data definitely should not be freed. Free
> caldata instead of data.
> 
> Thanks to Kalle Valo for spotting that data should not be
> free'd.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Thanks, 1 patch applied to ath-next branch of ath.git:

5f4761dda2ba ath10k: fix memory leak on caldata on error exit path

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9312163/
