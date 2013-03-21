Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:50195 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754144Ab3CUXXU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Mar 2013 19:23:20 -0400
Received: by mail-ob0-f176.google.com with SMTP id v19so3381489obq.7
        for <linux-wireless@vger.kernel.org>; Thu, 21 Mar 2013 16:23:19 -0700 (PDT)
Message-ID: <514B9665.6040702@lwfinger.net> (sfid-20130322_002327_059915_02EC6D0A)
Date: Thu, 21 Mar 2013 18:23:17 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>, dcbw@redhat.com
Subject: Re: Support for Realtek USB PID 0bda:1724 (rtl8723a?)
References: <514B8CC3.6030606@gmail.com>
In-Reply-To: <514B8CC3.6030606@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/21/2013 05:42 PM, Xose Vazquez Perez wrote:
> Larry Finger wrote:
>
>> I was sort of hoping for a detachable device. I have sent a message to Realtek
>> asking them about any drivers and devices with this chip.
>
> os_dep/linux/usb_intf.c:        {USB_DEVICE_AND_INTERFACE_INFO(USB_VENDER_ID_REALTEK, 0x1724,0xff,0xff,0xff)}, //8723AU 1*1
>
> https://github.com/liwei/rpi-rtl8188eu

That repo does not contain all the files needed to compile a driver for the 
RTL8723AU. If you set CONFIG_RTL8723A to "y", it fails to build.

Larry


