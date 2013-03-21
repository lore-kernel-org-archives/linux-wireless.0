Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:38968 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753754Ab3CUWmQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Mar 2013 18:42:16 -0400
Received: by mail-we0-f181.google.com with SMTP id p43so2788687wea.40
        for <linux-wireless@vger.kernel.org>; Thu, 21 Mar 2013 15:42:14 -0700 (PDT)
Message-ID: <514B8CC3.6030606@gmail.com> (sfid-20130321_234220_364777_BCF5459C)
Date: Thu, 21 Mar 2013 23:42:11 +0100
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>, dcbw@redhat.com
Subject: Re: Support for Realtek USB PID 0bda:1724 (rtl8723a?)
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote:

> I was sort of hoping for a detachable device. I have sent a message to Realtek 
> asking them about any drivers and devices with this chip.

os_dep/linux/usb_intf.c:        {USB_DEVICE_AND_INTERFACE_INFO(USB_VENDER_ID_REALTEK, 0x1724,0xff,0xff,0xff)}, //8723AU 1*1

https://github.com/liwei/rpi-rtl8188eu
