Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:64873 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475AbbBZQ6l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Feb 2015 11:58:41 -0500
Received: by mail-ob0-f170.google.com with SMTP id va2so12392937obc.1
        for <linux-wireless@vger.kernel.org>; Thu, 26 Feb 2015 08:58:39 -0800 (PST)
Message-ID: <54EF50BD.1010703@lwfinger.net> (sfid-20150226_175844_460738_F1507512)
Date: Thu, 26 Feb 2015 10:58:37 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: brilliantov@byterg.ru, linux-wireless@vger.kernel.org
Subject: Re: RTL8192cu: not work on linux-2.6.35
References: <54EEFD4D.3060009@byterg.ru>
In-Reply-To: <54EEFD4D.3060009@byterg.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/26/2015 05:02 AM, Brilliantov Kirill Vladimirovich wrote:
> Hello!
> I work with board on FreeScale iMX287 CPU and use linux-2.6.35.
> For use WiFi USB Trendnet TEW-648UBM I download driver
> (rtl8188C_8192C_usb_linux_v4.0.2_9000.20130911.tar.gz) from Realtek site and
> build it.

--snip--

> Yes, this chip supported in latest linux, unfortunately now I can't run new
> linux on board.
>
> Can you help run rtl8192cu on linux-2.6.35?
> Thank you and excuse me for my bad english.

Sorry, but there is no way that any of us can support a Realtek vendor driver. 
In addition, I have never tested any of the non-mac80211 drivers for the 
RTL8188CU or RTL8192CU devices.

You have the latest vendor driver that I know about.

Larry


