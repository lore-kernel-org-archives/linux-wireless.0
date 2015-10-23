Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48421 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130AbbJWOCS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2015 10:02:18 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	driverdev-devel@linuxdriverproject.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Greg KH <gregkh@linuxfoundation.org>,
	Kalle Valo <kvalo@codeaurora.org>
Subject: Re: staging/rtl8723au should be removed
References: <562A0F94.1010001@gmail.com> <562A179F.90201@lwfinger.net>
Date: Fri, 23 Oct 2015 10:02:17 -0400
In-Reply-To: <562A179F.90201@lwfinger.net> (Larry Finger's message of "Fri, 23
	Oct 2015 06:18:55 -0500")
Message-ID: <wrfjy4ethedy.fsf@redhat.com> (sfid-20151023_160221_672407_8E50AE54)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:
> On 10/23/2015 05:44 AM, Xose Vazquez Perez wrote:
>> Hi,
>>
>> Support for RTL8723AU devices was added to
>> wireless-drivers-next.git recently:
>> https://marc.info/?l=linux-wireless&m=144541406318463
>> commit:
>> https://git.kernel.org/cgit/linux/kernel/git/kvalo/wireless-drivers-next.git/commit/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h?id=26f1fad29ad973b0fb26a9ca3dcb2a73dde781aa
>
> The new driver is remarkable, but removal of the staging driver should
> not be done quite yet.
>
> The new one in the regular tree lacks a number of features. To quote
> from its commit message "This driver is still under development, but
> has proven to be very stable for me. It currently supports station
> mode only. It has support for OFDM and CCK rates. It does lack certain
> features found in the staging driver, such as power management, AMPDU,
> and 40MHz channel support. In addition it does not support AD-HOC, AP,
> and monitor mode support at this point."

I agree - it's too early to delete drivers/staging/rtl8723au at this
point. Just like it's too early to delete drivers/staging/rtl8192u.

There is monitor mode patches in my devel tree now, courtesy of Bruno
Randolf, so one of the features has gotten fixed. I also added 40MHz
support a while ago, maybe I forgot to remove that from the commit
message.

Cheers,
Jes
