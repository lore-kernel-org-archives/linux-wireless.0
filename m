Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f180.google.com ([74.125.82.180]:36945 "EHLO
        mail-ot0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751406AbeA0T4k (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 27 Jan 2018 14:56:40 -0500
Received: by mail-ot0-f180.google.com with SMTP id a24so3224782otd.4
        for <linux-wireless@vger.kernel.org>; Sat, 27 Jan 2018 11:56:39 -0800 (PST)
Subject: Re: [PATCH 03/10] rtlwifi: Use 6 bits as sequence number of TX report
To: pkshih@realtek.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
References: <20180126074645.27201-1-pkshih@realtek.com>
 <20180126074645.27201-4-pkshih@realtek.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <b3957f59-bea5-82c4-7213-4ee36f3795fb@lwfinger.net> (sfid-20180127_205752_801843_DFCA8228)
Date: Sat, 27 Jan 2018 13:56:38 -0600
MIME-Version: 1.0
In-Reply-To: <20180126074645.27201-4-pkshih@realtek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/26/2018 01:46 AM, pkshih@realtek.com wrote:
> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> In new design, SW_DEFINE[1:0] of tx desc are used by firmware, and the TX
> report only contains SW_DEFINE[7:0]. To satisfy with all cases, driver uses
> SW_DEFINE[7:2] as sequence number.
> Besides, the format of tx report have been changed, so a new flag
> RTL_SPEC_EXT_C2H is used to access report.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

This change was tested on an old design (RTL8188CE). No problems were observed.

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
