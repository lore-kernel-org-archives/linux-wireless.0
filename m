Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f170.google.com ([74.125.82.170]:36143 "EHLO
        mail-ot0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751940AbeA0T2l (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 27 Jan 2018 14:28:41 -0500
Received: by mail-ot0-f170.google.com with SMTP id f100so3200168otf.3
        for <linux-wireless@vger.kernel.org>; Sat, 27 Jan 2018 11:28:41 -0800 (PST)
Subject: Re: [PATCH 08/10] rtlwifi: add efuse ops for other components
To: pkshih@realtek.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
References: <20180126074645.27201-1-pkshih@realtek.com>
 <20180126074645.27201-9-pkshih@realtek.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <f2eccdc4-61d9-ccb8-ac9c-5838e1ee010c@lwfinger.net> (sfid-20180127_202845_267371_CC5F2A05)
Date: Sat, 27 Jan 2018 13:28:39 -0600
MIME-Version: 1.0
In-Reply-To: <20180126074645.27201-9-pkshih@realtek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/26/2018 01:46 AM, pkshih@realtek.com wrote:
> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> The new component phydm need to access efuse content, so we prepare ops
> for reference.
> 
> Signed-off-by: Tsang-Shian Lin <thlin@realtek.com>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
