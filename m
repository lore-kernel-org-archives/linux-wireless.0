Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f44.google.com ([209.85.219.44]:40045 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755603Ab3IIVwX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Sep 2013 17:52:23 -0400
Received: by mail-oa0-f44.google.com with SMTP id l17so7148405oag.31
        for <linux-wireless@vger.kernel.org>; Mon, 09 Sep 2013 14:52:22 -0700 (PDT)
Message-ID: <522E4315.4040806@lwfinger.net> (sfid-20130909_235226_064217_675F9B22)
Date: Mon, 09 Sep 2013 16:52:21 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Vincent Thiele <vincentthiele@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: No connection with TP-Link TL-WN823N (rtl8192cu)
References: <CAEZsi7Hde5NyTRgm7Lf_4LvHMAEJouzaqMNUwxr-iSipuEcsyQ@mail.gmail.com>
In-Reply-To: <CAEZsi7Hde5NyTRgm7Lf_4LvHMAEJouzaqMNUwxr-iSipuEcsyQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/09/2013 03:40 PM, Vincent Thiele wrote:
> I use TL-WN823N usb-stick with ubuntu but native drivers disconnect
> few seconds after boot. For wlan i need to install this package:
> https://code.google.com/p/realtek-8188cus-wireless-drivers-3444749-ubuntu-1304/.
> But this package can not be used with a kernel > 3.9. Please fix the
> native drivers. Best regards

I am sorry that you are having problems with your system, but your log was 
essentially useless. I saw one disconnect due to reason 4 (disassociation due to 
inactivity).

There were many changes in the rtl8192cu driver for kernel 3.11, and you need to 
run it, or a backports version of the wireless code. Your 3.8.0 kernel is too old.

I have been running rtl8192cu for the past 24 hours without a permanent 
disconnect. Under NetworkManager, I see some reason 7 deauthentications, but 
running under ifup, there have been no disassociations or deauthentications in 
over 6 hours.

I am using openSUSE KDE. There may be a problem with the Ubuntu user code as it 
seems to operate differently.

Larry

