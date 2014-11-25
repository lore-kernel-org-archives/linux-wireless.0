Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yh0-f47.google.com ([209.85.213.47]:54007 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbaKYXMv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2014 18:12:51 -0500
Received: by mail-yh0-f47.google.com with SMTP id f73so786331yha.34
        for <linux-wireless@vger.kernel.org>; Tue, 25 Nov 2014 15:12:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1013439490.18867944.1416932462547.JavaMail.root@wmich.edu>
References: <2109154365.18865892.1416932147808.JavaMail.root@wmich.edu> <1013439490.18867944.1416932462547.JavaMail.root@wmich.edu>
From: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date: Wed, 26 Nov 2014 02:12:30 +0300
Message-ID: <CAHNKnsRhPW2YGSTvmD-_hPci7V0hqCGyUHy4CfFr5QQtsF=FGw@mail.gmail.com> (sfid-20141126_001254_498253_040DE6E8)
Subject: Re: Setting WLAN RF Sensitivity value
To: Mohammad Ali Ma Abu Shattal <mohammad.a.shattal@wmich.edu>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ilw@linux.intel.com
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2014-11-25 19:21 GMT+03:00 Mohammad Ali Ma Abu Shattal
<mohammad.a.shattal@wmich.edu>:
> Dear Sir/Madam,
>
> I'm working on a project in which we need to set and get RF sensitivity of WLAN device.
Could you specify, what exactly parameter do you want to control? In
the your askubuntu post, you refer to "iwconfig wlan0 sens" command,
which can control too many aspects, including the selection of the
best AP and the detection of channel busy condition. And actual
parameter "depends on the hardware implementation" as said in iwconfig
manpage.

> I tried to set other settings such as operation mode, txpower and frequency using Linux commands : "ioctl" and "iwconfig" and it works fine.
Consider using NL80211 and "iw" utility, since IOCTL based
wireless-extensions interface is deprecated.

> Manufacturer of my device is Broadcom. It seems that either the hardware or the driver doesn't support setting and getting sensitivity. I need to know if there exists a device and/or device driver that support this feature. details of my current hardware and device driver are posted in the askubuntu question:
> http://askubuntu.com/questions/553286/wlan-sensitivity-setting-is-not-supported
> kindly send me your recommendation for such device or device driver.
>
> best regards,
> Mohammad
> ----------------------------
> Mohammad Abu Shattal
> Ph.D Student
> Department of Electrical & Computer Engineering
> Western Michigan University
> Kalamazoo, MI 49008

-- 
BR,
Sergey
