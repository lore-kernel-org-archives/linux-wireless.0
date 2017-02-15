Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f43.google.com ([74.125.83.43]:35917 "EHLO
        mail-pg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751304AbdBOK2g (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Feb 2017 05:28:36 -0500
Received: by mail-pg0-f43.google.com with SMTP id v184so36008935pgv.3
        for <linux-wireless@vger.kernel.org>; Wed, 15 Feb 2017 02:28:36 -0800 (PST)
Subject: Re: wireless driver crashing frequently
To: ravin goyal <ravirocks1021@gmail.com>,
        linux-wireless@vger.kernel.org
References: <CANU0Mn00ju_SZ3L+ipdnZ5R-Y1m+T=MhjHmBjMpKN_i8NPWsrg@mail.gmail.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <dea21c18-30a4-f236-6f8b-1bf8d4391e0b@broadcom.com> (sfid-20170215_112840_470923_9C2233B1)
Date: Wed, 15 Feb 2017 11:28:32 +0100
MIME-Version: 1.0
In-Reply-To: <CANU0Mn00ju_SZ3L+ipdnZ5R-Y1m+T=MhjHmBjMpKN_i8NPWsrg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15-2-2017 10:54, ravin goyal wrote:
> Hello, I have a banana pi m2+ running raspbian lite 3.4.112-sun8i
> I am running hostapd on it
> 
> My wireless chip is AP6212 ,when I start hostapd sometime it runs
> sometime it leads to kernel crash
> 
> please follow this link to see the kernel messages: https://clbin.com/PXBSB?hl
> 
> I have been told to ask my doubt here since it is the problem of the
> driver in the kernel
> 
> To make hostapd work properly I have to manuallly run this command
> 
> modprobe -v bcmdhd op_mode=2
> 
> bcmdhd is my wireless driver
> 
> after this hostapd is able to broadcast the ssid, if i don't provide
> the op_mode=2 while loading the module, hostapd will not broadcast the
> ssid.
> 
> any help on this ?

You are asking the wrong crowd. bcmdhd is an android driver. In upstream
linux we have brcmfmac. Are you running android or upstream linux. At
least you are on a pretty old kernel so I suspect android.

Regards,
Arend
