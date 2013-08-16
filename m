Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f179.google.com ([209.85.214.179]:53178 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab3HPOk4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Aug 2013 10:40:56 -0400
Received: by mail-ob0-f179.google.com with SMTP id fb19so2097213obc.24
        for <linux-wireless@vger.kernel.org>; Fri, 16 Aug 2013 07:40:55 -0700 (PDT)
Message-ID: <520E39F5.6070106@lwfinger.net> (sfid-20130816_164102_633386_826F0B58)
Date: Fri, 16 Aug 2013 09:40:53 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: poma <pomidorabelisima@gmail.com>
CC: Phillip Moss <phillipmoss12@yahoo.es>,
	linux-wireless@vger.kernel.org
Subject: Re: Signal loss rtl8723ae wifi driver
References: <1376411031.31841.YahooMailBasic@web171406.mail.ir2.yahoo.com> <520AF842.8030403@lwfinger.net> <520E36E1.1030704@gmail.com>
In-Reply-To: <520E36E1.1030704@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/16/2013 09:27 AM, poma wrote:
> On 14.08.2013 05:23, Larry Finger wrote:
> …
>>
>> Why is your device name "wlp3s0", rather than the usual "wlanX"? What is
>> controlling your connection. If it is wicd, note that I do not support
>> that piece of software. I use NetworkManager.
>>
> …
> Probably systemd-udevd, not quite to control, but renames it.
> http://www.freedesktop.org/wiki/Software/systemd/PredictableNetworkInterfaceNames/
> http://cgit.freedesktop.org/systemd/systemd/tree/src/udev/udev-builtin-net_id.c#n72
> Literally a textbook example, at least on Fedora. ;)
> You really did not know about this?

Nope. I am not a Fedora user, and openSUSE only renames to wlanX.

Larry


