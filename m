Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50547 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137Ab2GMPwC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jul 2012 11:52:02 -0400
Received: by eaak11 with SMTP id k11so1126377eaa.19
        for <linux-wireless@vger.kernel.org>; Fri, 13 Jul 2012 08:52:01 -0700 (PDT)
Message-ID: <5000441D.70308@gmail.com> (sfid-20120713_175207_954702_D58D974C)
Date: Fri, 13 Jul 2012 17:51:57 +0200
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: arliton@gmail.com, linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Problem: Realtek Semiconductor RTL8190 does not work
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arliton Rocha wrote:

> The following card does not work.
>     Realtek Semiconductor Co., Ltd. RTL8190 802.11n Wireless LAN

> lspci -n:
>
>     03:00.0 0280: 10ec:8190

There is no support for RTL8190P devices in any upstream realtek driver.

It's only supported by an old vendor driver.

You can get it from: http://people.debian.org/~benh/rtl-wlan/rtl8192e_linux_2.6.0015.1013.2010.tar.gz
or by request to wlanfae@realtek.com
