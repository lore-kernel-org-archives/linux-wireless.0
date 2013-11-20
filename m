Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:43591 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285Ab3KTPWy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Nov 2013 10:22:54 -0500
Received: by mail-ob0-f169.google.com with SMTP id wm4so4919545obc.28
        for <linux-wireless@vger.kernel.org>; Wed, 20 Nov 2013 07:22:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAG6hwVNqLQB+8ViDyB-XhVx=TzbgZmX-DY6gDaevUoMfETWTVw@mail.gmail.com>
References: <CABGE7dsDtL0ZPAmOTW=G=hMdA-6r=yT0DtQx_-H6Yi6cGa6Udw@mail.gmail.com>
 <CABGE7dur4pM4vLz_iLx7u-g5ohKhXkwKAOmjJ86PE62mYwGPJw@mail.gmail.com>
 <CAG6hwVOOvKfZcv-J70EMeHM3pmx-ieeAF2-6UtbrmoN3xC=SLw@mail.gmail.com>
 <CABGE7dsTzYESpxfO8WL9JP1BR1QdrTNv5+EszuZm225R2pA=Zw@mail.gmail.com>
 <CABGE7ds77Ea9YeGBLCCYYDfTFEm0MqjRA03aF=vpv9Y+=Z47oA@mail.gmail.com> <CAG6hwVNqLQB+8ViDyB-XhVx=TzbgZmX-DY6gDaevUoMfETWTVw@mail.gmail.com>
From: Gustavo Azambuja <gazambuja+hostapd@gmail.com>
Date: Wed, 20 Nov 2013 13:22:33 -0200
Message-ID: <CABGE7dvky+trLL5=hPv13OHhRm9vdbU33Ndyv_oHAjG3+x24+A@mail.gmail.com> (sfid-20131120_162300_233345_74B1145F)
Subject: Re: NL80211_CMD_NEW_STATION result: -105 (No buffer space available)
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks Thomas, but is not an option using a "real" AP... I realy need
to make my own (I need access to MAC address of connected devices and
use the monitor mode at the same time).

You have some link to steps to "upgrade/install" the modify version of
frimware in my device (TL-WN722N) ?

This is one or two step ahead of my confort zone :)




On Tue, Nov 19, 2013 at 5:15 PM, Thomas Pedersen <thomas@cozybit.com> wrote:
> On Tue, Nov 19, 2013 at 3:39 AM, Gustavo Azambuja
> <gazambuja+hostapd@gmail.com> wrote:
>> Thank,
>> you know where i can find one list of devices (usb dongle) with more
>> ram, or without this limit (I need provide Internet at less to 30
>> stations)?
>
> No. But a "real" AP would be cheaper and much more perfomant anyway.
> Something like the TP-LINK WR841n can be had for about $20.
>
> Nothing stopping you from setting HTC_MAX_STA to 30 and seeing what
> happens either!
>
> --
> Thomas
