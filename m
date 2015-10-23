Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:34136 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994AbbJWLSr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2015 07:18:47 -0400
Received: by oies66 with SMTP id s66so63747848oie.1
        for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2015 04:18:47 -0700 (PDT)
Subject: Re: staging/rtl8723au should be removed
To: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	driverdev-devel@linuxdriverproject.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Greg KH <gregkh@linuxfoundation.org>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Kalle Valo <kvalo@codeaurora.org>
References: <562A0F94.1010001@gmail.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <562A179F.90201@lwfinger.net> (sfid-20151023_131850_947446_CD6BC78A)
Date: Fri, 23 Oct 2015 06:18:55 -0500
MIME-Version: 1.0
In-Reply-To: <562A0F94.1010001@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/23/2015 05:44 AM, Xose Vazquez Perez wrote:
> Hi,
>
> Support for RTL8723AU devices was added to
> wireless-drivers-next.git recently: https://marc.info/?l=linux-wireless&m=144541406318463
> commit: https://git.kernel.org/cgit/linux/kernel/git/kvalo/wireless-drivers-next.git/commit/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h?id=26f1fad29ad973b0fb26a9ca3dcb2a73dde781aa

The new driver is remarkable, but removal of the staging driver should not be 
done quite yet.

The new one in the regular tree lacks a number of features. To quote from its 
commit message "This driver is still under development, but has proven to be 
very stable for me. It currently supports station mode only. It has support for 
OFDM and CCK rates. It does lack certain features found in the staging driver, 
such as power management, AMPDU, and 40MHz channel support. In addition it does 
not support AD-HOC, AP, and monitor mode support at this point."

Larry


