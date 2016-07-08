Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57669 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754746AbcGHNub (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2016 09:50:31 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v3,01/10] rtlwifi: Create common routine to get hardware info
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1467731295-25850-2-git-send-email-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Arnd Bergmann <arnd@arndb.de>
Message-Id: <20160708135031.04D4D61154@smtp.codeaurora.org> (sfid-20160708_155034_432768_CC3E3195)
Date: Fri,  8 Jul 2016 13:50:30 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:
> All of the rtlwifi family of drivers have a similar routine that acquires
> the hardware info from efuse and initializes a number of variables in the
> driver's private area. A common routine is created for all drivers to use.
> 
> Reported-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Arnd Bergmann <arnd@arndb.de>

Thanks, 10 patches applied to wireless-drivers-next.git:

edb45b67a09d rtlwifi: Create common routine to get hardware info
df5cbc697d9b rtlwifi: rtl8192ce: Convert driver to use common hardware info routine
c2d9a411456c rtlwifi: rtl8192cu: Convert driver to use common hardware info routine
9468792743a5 rtlwifi: rtl8188ee: Convert driver to use common hardware info routine
5c392654ee81 rtlwifi: rtl8192ee: Convert driver to use common hardware info routine
8aaf6916de68 rtlwifi: rtl8723ae: Convert driver to use common hardware info routine
9e9c9c247c21 rtlwifi: rtl8723be: Convert driver to use common hardware info routine
2f7b4b895365 rtlwifi: rtl8821ae: Convert driver to use common hardware info routine
a8c9fb2b82ab rtlwifi: rtl8192de: Convert driver to use common hardware info routine
238ad2ddf34b rtlwifi: rtl8723ae: Clean up the hardware info routine

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9214551/

