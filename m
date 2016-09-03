Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57419 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753574AbcICQxJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Sep 2016 12:53:09 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: rtlwifi: rtl8192de: Fix leak in _rtl92de_read_adapter_info()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1470770397-24390-1-git-send-email-cengelma@gmx.at>
To: Christian Engelmayer <cengelma@gmx.at>
Cc: Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn,
        arnd@arndb.de, linux-wireless@vger.kernel.org,
        Christian Engelmayer <cengelma@gmx.at>
Message-Id: <20160903165258.53FF262181@smtp.codeaurora.org> (sfid-20160903_185313_060130_433818D1)
Date: Sat,  3 Sep 2016 16:52:58 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Engelmayer <cengelma@gmx.at> wrote:
> In case rtl_get_hwinfo() fails, the function directly returns and leaks the
> already allocated hwinfo memory. Go through the correct exit path.
> 
> Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks, 1 patch applied to wireless-drivers-next.git:

a0c7858e7479 rtlwifi: rtl8192de: Fix leak in _rtl92de_read_adapter_info()

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9272131/
