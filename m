Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f179.google.com ([209.85.215.179]:55593 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab3HPO1s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Aug 2013 10:27:48 -0400
Received: by mail-ea0-f179.google.com with SMTP id b10so1048220eae.10
        for <linux-wireless@vger.kernel.org>; Fri, 16 Aug 2013 07:27:47 -0700 (PDT)
Message-ID: <520E36E1.1030704@gmail.com> (sfid-20130816_162754_596404_33D641A0)
Date: Fri, 16 Aug 2013 16:27:45 +0200
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: Phillip Moss <phillipmoss12@yahoo.es>,
	linux-wireless@vger.kernel.org
Subject: Re: Signal loss rtl8723ae wifi driver
References: <1376411031.31841.YahooMailBasic@web171406.mail.ir2.yahoo.com> <520AF842.8030403@lwfinger.net>
In-Reply-To: <520AF842.8030403@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 14.08.2013 05:23, Larry Finger wrote:
…
> 
> Why is your device name "wlp3s0", rather than the usual "wlanX"? What is
> controlling your connection. If it is wicd, note that I do not support
> that piece of software. I use NetworkManager.
>
…
Probably systemd-udevd, not quite to control, but renames it.
http://www.freedesktop.org/wiki/Software/systemd/PredictableNetworkInterfaceNames/
http://cgit.freedesktop.org/systemd/systemd/tree/src/udev/udev-builtin-net_id.c#n72
Literally a textbook example, at least on Fedora. ;)
You really did not know about this?


poma

