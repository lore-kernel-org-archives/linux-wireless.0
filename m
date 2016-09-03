Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57949 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753296AbcICRBL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Sep 2016 13:01:11 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: rtlwifi: rtl8723ae: Fix leak in _rtl8723e_read_adapter_info()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1470772452-24642-1-git-send-email-cengelma@gmx.at>
To: Christian Engelmayer <cengelma@gmx.at>
Cc: Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn,
        arnd@arndb.de, joe@perches.com, linux-wireless@vger.kernel.org,
        Christian Engelmayer <cengelma@gmx.at>
Message-Id: <20160903165401.C32C762177@smtp.codeaurora.org> (sfid-20160903_190114_739904_5C862062)
Date: Sat,  3 Sep 2016 16:54:01 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Engelmayer <cengelma@gmx.at> wrote:
> In case of (rtlhal->oem_id != RT_CID_DEFAULT), the function directly
> returns and leaks the already allocated hwinfo memory. Go through the
> correct exit path.
> 
> Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks, 1 patch applied to wireless-drivers-next.git:

3eeacaa902a3 rtlwifi: rtl8723ae: Fix leak in _rtl8723e_read_adapter_info()

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9272147/
