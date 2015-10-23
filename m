Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:34902 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbbJWNHU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2015 09:07:20 -0400
Received: by wicll6 with SMTP id ll6so30587188wic.0
        for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2015 06:07:19 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH 1/1] New driver: rtl8xxxu (mac80211)
To: linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@codeaurora.org>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <562A3103.705@gmail.com> (sfid-20151023_150725_027414_AA12D268)
Date: Fri, 23 Oct 2015 15:07:15 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jes Sorensen wrote:

> This is an alternate driver for a number of Realtek WiFi USB devices,
> including RTL8723AU, RTL8188CU, RTL8188RU, RTL8191CU, and RTL8192CU.
> It was written from scratch utilizing the Linux mac80211 stack.
>[...]
>+{USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_REALTEK, 0x317f, 0xff, 0xff, 0xff),
>[...]
>+{USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_REALTEK, 0x317f, 0xff, 0xff, 0xff),
>[...]

This device was duplicated. Delete one of them.
