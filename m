Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59310 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543AbbJWOAV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2015 10:00:21 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@codeaurora.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 1/1] New driver: rtl8xxxu (mac80211)
References: <562A3103.705@gmail.com>
Date: Fri, 23 Oct 2015 10:00:20 -0400
In-Reply-To: <562A3103.705@gmail.com> (Xose Vazquez Perez's message of "Fri,
	23 Oct 2015 15:07:15 +0200")
Message-ID: <wrfj37x1it1n.fsf@redhat.com> (sfid-20151023_160034_549311_272012BB)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Xose Vazquez Perez <xose.vazquez@gmail.com> writes:
> Jes Sorensen wrote:
>
>> This is an alternate driver for a number of Realtek WiFi USB devices,
>> including RTL8723AU, RTL8188CU, RTL8188RU, RTL8191CU, and RTL8192CU.
>> It was written from scratch utilizing the Linux mac80211 stack.
>>[...]
>>+{USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_REALTEK, 0x317f, 0xff,
>> 0xff, 0xff),
>>[...]
>>+{USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_REALTEK, 0x317f, 0xff,
>> 0xff, 0xff),
>>[...]
>
> This device was duplicated. Delete one of them.

You could just have sent me a patch instead of this.
