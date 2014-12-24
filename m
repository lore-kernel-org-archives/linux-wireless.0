Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:55076 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbaLXQjt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Dec 2014 11:39:49 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 00/16] rtlwifi updates for kernel 3.20
References: <1418893540-19944-1-git-send-email-Larry.Finger@lwfinger.net>
Date: Wed, 24 Dec 2014 18:39:40 +0200
In-Reply-To: <1418893540-19944-1-git-send-email-Larry.Finger@lwfinger.net>
	(Larry Finger's message of "Thu, 18 Dec 2014 03:05:24 -0600")
Message-ID: <87fvc580j7.fsf@kamboji.qca.qualcomm.com> (sfid-20141224_173952_606699_BE805263)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> Welcome as the wireless-driver maintainer.

Thanks.

> I'm certain that it will take a while for all of us to function with
> the new structure, but I will try.

Yeah, it will take some time to get everything working smoothly again.
But always feel free to give feedback if there's something I could
improve. And _please_ do double check my commits :)

> This patch bomb is the first of a set of cleanups. As I wrote John earlier,
> my intent is to identify code that appears in multiple drivers and move such
> routines into rtlwifi. None of the changes in this set need have high priority,
> and all should be pushed into the "next" stream for kernel 3.20.
>
> Thanks,
>
> Larry
> ---
>
> Larry Finger (15):
>   rtlwifi: rtl8821ae: Fix typos in power-sequence macro
>   rtlwifi: rtl8192ce: Add code to set the keep-alive operation
>   rtlwifi: rtl8192ce: Update setting of the media status
>   rtlwifi: rtl8192ce: Update rate setting routines
>   rtlwifi: rtl8192ce: Improve RF sleep routine
>   rtlwifi: rtl8192ce: rtl8192cu: rtl8192de: rtl8192se:
>   rtlwifi: rtl8723be: Swith to use common rate-mapping routine
>   rtlwifi: rtl8188ee: Switch to use common rate-mapping routine
>   rtlwifi: rtl8723ae: Modify driver to use rate-mapping routine in core
>   rtlwifi: rtl8192ee: Convert driver to use common rate-mapping code
>   rtlwifi: Convert all drivers to use a common set of rate descriptors
>   rtlwifi: rtl8821ae: Add VHT rate descriptors
>   rtlwifi: rtl8192cu: Rework calls to rate-control routine
>   rtlwifi: rtl8192de: Rework calls to rate-control routine
>   rtlwifi: rtl8821ae: Switch to use common rate control routine
>
> Troy Tan (1):
>   rtlwifi: rtl8821ae: Simplify loading of WOWLAN firmware

Thanks, all 16 applied to wireless-drivers-next.git.

-- 
Kalle Valo
