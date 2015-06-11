Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f194.google.com ([209.85.214.194]:36838 "EHLO
	mail-ob0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbbFKVlG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2015 17:41:06 -0400
Received: by obcwm4 with SMTP id wm4so4268283obc.3
        for <linux-wireless@vger.kernel.org>; Thu, 11 Jun 2015 14:41:06 -0700 (PDT)
Message-ID: <557A006E.7050800@lwfinger.net> (sfid-20150611_234110_872611_B1214FD0)
Date: Thu, 11 Jun 2015 16:41:02 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Drasko DRASKOVIC <drasko.draskovic@gmail.com>,
	linux-wireless@vger.kernel.org,
	Rathgeb Paul <paul.rathgeb@skynet.be>,
	uros petrevski <uros.petrevski@gmail.com>
Subject: Re: RTL8723BS BLE Support
References: <CAEk6gTBzoR4FCJp0xo=AOOmbeE7ekROpUf0+_yKMBoqUHTgHWw@mail.gmail.com>
In-Reply-To: <CAEk6gTBzoR4FCJp0xo=AOOmbeE7ekROpUf0+_yKMBoqUHTgHWw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/11/2015 04:07 AM, Drasko DRASKOVIC wrote:
> Hi all,
> I can see here: https://github.com/lwfinger/rtl8723bs_bt Bluetooth
> support for RTL8723BS chip support. This chip should support Bluetooth
> Low Energy, based on this -
> https://wikidevi.com/wiki/Realtek_RTL8723BS_Combo_Module_(SDIO),
> although I do not see BLE mention in the datasheet:
> http://space.cechina.cn/infosharedownload.aspx?id=1011.
>
> I was wondering about the satate of this driver and BLE (not only
> Bluetooth, but specifically Bletooth Low Energy) support in Linux for
> this WiFi chip - did anybody use it, have this been proven to work for
> someone?

I created that repo from the driver that Realtek sent me. My only changes were 
to ensure that it built on a number of kernel versions.

As I have no idea who wrote the wikidevi.com article, I have no idea if they 
knew much about this chip. I am certain that the datasheet came from Realtek. If 
they do not mention Bluetooth Low Energy, then the chip probably does not 
support it.

Larry

